Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab3GBP01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:26:27 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:47362 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138Ab3GBP00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:26:26 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: bzhao@marvell.com, linville@tuxdriver.com, rjw@sisk.pl
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] wireless: Convert mwifiex/pcie to dev_pm_ops from legacy pm ops
Date: Tue,  2 Jul 2013 09:24:35 -0600
Message-Id: <1372778675-2909-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the mwifiex/pci driver to use dev_pm_ops for power management and
remove Legacy PM handling. This change re-uses existing suspend and resume
interfaces for dev_pm_ops.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/net/wireless/mwifiex/pcie.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 20c9c4c..b169318 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -85,7 +85,7 @@ static bool mwifiex_pcie_ok_to_access_hw(struct mwifiex_adapter *adapter)
  * If already not suspended, this function allocates and sends a host
  * sleep activate request to the firmware and turns off the traffic.
  */
-static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
+static int __mwifiex_pcie_suspend(struct pci_dev *pdev)
 {
 	struct mwifiex_adapter *adapter;
 	struct pcie_service_card *card;
@@ -112,6 +112,13 @@ static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
+static int mwifiex_pcie_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return __mwifiex_pcie_suspend(pdev);
+}
+
 /*
  * Kernel needs to suspend all functions separately. Therefore all
  * registered functions must have drivers with suspend and resume
@@ -120,7 +127,7 @@ static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
  * If already not resumed, this function turns on the traffic and
  * sends a host sleep cancel request to the firmware.
  */
-static int mwifiex_pcie_resume(struct pci_dev *pdev)
+static int __mwifiex_pcie_resume(struct pci_dev *pdev)
 {
 	struct mwifiex_adapter *adapter;
 	struct pcie_service_card *card;
@@ -150,6 +157,13 @@ static int mwifiex_pcie_resume(struct pci_dev *pdev)
 
 	return 0;
 }
+
+static int mwifiex_pcie_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return __mwifiex_pcie_resume(pdev);
+}
 #endif
 
 /*
@@ -213,7 +227,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (user_rmmod) {
 #ifdef CONFIG_PM
 		if (adapter->is_suspended)
-			mwifiex_pcie_resume(pdev);
+			__mwifiex_pcie_resume(pdev);
 #endif
 
 		for (i = 0; i < adapter->priv_num; i++)
@@ -249,6 +263,14 @@ static DEFINE_PCI_DEVICE_TABLE(mwifiex_ids) = {
 
 MODULE_DEVICE_TABLE(pci, mwifiex_ids);
 
+#ifdef CONFIG_PM
+/* Power Management Hooks */
+static const struct dev_pm_ops mwifiex_pcie_pm_ops = {
+	.suspend = mwifiex_pcie_suspend,
+	.resume = mwifiex_pcie_resume,
+};
+#endif
+
 /* PCI Device Driver */
 static struct pci_driver __refdata mwifiex_pcie = {
 	.name     = "mwifiex_pcie",
@@ -256,9 +278,9 @@ static struct pci_driver __refdata mwifiex_pcie = {
 	.probe    = mwifiex_pcie_probe,
 	.remove   = mwifiex_pcie_remove,
 #ifdef CONFIG_PM
-	/* Power Management Hooks */
-	.suspend  = mwifiex_pcie_suspend,
-	.resume   = mwifiex_pcie_resume,
+	.driver   = {
+		.pm = &mwifiex_pcie_pm_ops,
+	},
 #endif
 };
 
-- 
1.7.10.4

