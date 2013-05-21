Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3EUCdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:33:13 -0400
Received: from mx1.sisa.samsung.com ([63.166.156.249]:47134 "EHLO
	mx1.sisa.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab3EUCdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:33:11 -0400
X-ASG-Debug-ID: 1369103590-05c03219fb0cd80001-xx1T2L
X-Barracuda-Envelope-From: shuah.kh@samsung.com
X-Barracuda-Apparent-Source-IP: 105.144.21.115
X-ASG-Whitelist: Client
From: Shuah Khan <shuah.kh@samsung.com>
To: "bzhao@marvell.com" <bzhao@marvell.com>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: [RFC PATCH] net/wireless/mwifiex/pcie: Convert to dev_pm_ops from
 legacy pm ops
Thread-Topic: [RFC PATCH] net/wireless/mwifiex/pcie: Convert to dev_pm_ops
 from legacy pm ops
X-ASG-Orig-Subj: [RFC PATCH] net/wireless/mwifiex/pcie: Convert to dev_pm_ops from
 legacy pm ops
Thread-Index: AQHOVcuInHnHweBRfkqda9opXtALJw==
Date: Tue, 21 May 2013 02:33:09 +0000
Message-ID: <1369103589.12093.4.camel@lorien>
Reply-To: Shuah Khan <shuah.kh@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.144.34.7]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB8F19BA2BA64C4B9F1209B2F32034F5@sisa.samsung.com>
MIME-Version: 1.0
X-Barracuda-Connect: webmail.sisa.samsung.com[105.144.21.115]
X-Barracuda-Start-Time: 1369103590
X-Barracuda-URL: http://192.168.0.101:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4L2XZfQ017115

Convert the driver to use dev_pm_ops for power management and remove Legacy PM
handling. This change re-uses existing suspend and resume interfaces for 
dev_pm_ops.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
Suggested-by: rafael.j.wysocki@intel.com
---

Rafael,

This is the first driver patch to convert drivers to use dev_pm_ops for
power management. Please review for the approach and make suggestions for
improvement.

thanks,
-- Shuah

 drivers/net/wireless/mwifiex/pcie.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 20c9c4c..a271c64 100644
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
@@ -249,6 +263,13 @@ static DEFINE_PCI_DEVICE_TABLE(mwifiex_ids) = {
 
 MODULE_DEVICE_TABLE(pci, mwifiex_ids);
 
+#ifdef CONFIG_PM
+/* Power Management Hooks */
+static const struct dev_pm_ops mwifiex_pcie_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(mwifiex_pcie_suspend, mwifiex_pcie_resume)
+};
+#endif
+
 /* PCI Device Driver */
 static struct pci_driver __refdata mwifiex_pcie = {
 	.name     = "mwifiex_pcie",
@@ -256,9 +277,9 @@ static struct pci_driver __refdata mwifiex_pcie = {
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


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
