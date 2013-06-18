Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab3FRIXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:23:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:27133 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3FRIXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:23:13 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 7/9] PCI: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
Date: Tue, 18 Jun 2013 16:22:14 +0800
Message-ID: <1371543734-14148-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci pm cap register offset has been saved in pci_pm_init(),
so we can use pdev->pm_cap instead of using pci_find_capability(..)
here.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/pci.c    |    2 +-
 drivers/pci/quirks.c |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a899d8b..1117f2c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -805,7 +805,7 @@ pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state)
 {
 	pci_power_t ret;
 
-	if (!pci_find_capability(dev, PCI_CAP_ID_PM))
+	if (!dev->pm_cap)
 		return PCI_D0;
 
 	ret = platform_pci_choose_state(dev);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7d68aee..422812b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1832,7 +1832,6 @@ static void quirk_e100_interrupt(struct pci_dev *dev)
 	u16 command, pmcsr;
 	u8 __iomem *csr;
 	u8 cmd_hi;
-	int pm;
 
 	switch (dev->device) {
 	/* PCI IDs taken from drivers/net/e100.c */
@@ -1870,9 +1869,8 @@ static void quirk_e100_interrupt(struct pci_dev *dev)
 	 * Check that the device is in the D0 power state. If it's not,
 	 * there is no point to look any further.
 	 */
-	pm = pci_find_capability(dev, PCI_CAP_ID_PM);
-	if (pm) {
-		pci_read_config_word(dev, pm + PCI_PM_CTRL, &pmcsr);
+	if (dev->pm_cap) {
+		pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &pmcsr);
 		if ((pmcsr & PCI_PM_CTRL_STATE_MASK) != PCI_D0)
 			return;
 	}
-- 
1.7.1


