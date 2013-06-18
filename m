Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3FRIU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:20:27 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:47899 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309Ab3FRIUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:20:23 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Jens Axboe <axboe@kernel.dk>, Mike Miller <mike.miller@hp.com>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        <iss_storagedev@hp.com>
Subject: [PATCH 5/9] cciss: rework pci pm related code for simplification
Date: Tue, 18 Jun 2013 16:19:13 +0800
Message-ID: <1371543553-13064-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pci core pm interface to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com
Cc: linux-kernel@vger.kernel.org
---
 drivers/block/cciss.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 62b6c2c..18da685 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4528,9 +4528,6 @@ static int cciss_message(struct pci_dev *pdev, unsigned char opcode,
 static int cciss_controller_hard_reset(struct pci_dev *pdev,
 	void * __iomem vaddr, u32 use_doorbell)
 {
-	u16 pmcsr;
-	int pos;
-
 	if (use_doorbell) {
 		/* For everything after the P600, the PCI power state method
 		 * of resetting the controller doesn't work, so we have this
@@ -4548,8 +4545,7 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
 		 * this causes a secondary PCI reset which will reset the
 		 * controller." */
 
-		pos = pci_find_capability(pdev, PCI_CAP_ID_PM);
-		if (pos == 0) {
+		if (!pdev->pm_cap) {
 			dev_err(&pdev->dev,
 				"cciss_controller_hard_reset: "
 				"PCI PM not supported\n");
@@ -4557,18 +4553,12 @@ static int cciss_controller_hard_reset(struct pci_dev *pdev,
 		}
 		dev_info(&pdev->dev, "using PCI PM to reset controller\n");
 		/* enter the D3hot power management state */
-		pci_read_config_word(pdev, pos + PCI_PM_CTRL, &pmcsr);
-		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
-		pmcsr |= PCI_D3hot;
-		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
+		pci_set_power_state(pdev, PCI_D3hot);
 
 		msleep(500);
 
 		/* enter the D0 power management state */
-		pmcsr &= ~PCI_PM_CTRL_STATE_MASK;
-		pmcsr |= PCI_D0;
-		pci_write_config_word(pdev, pos + PCI_PM_CTRL, pmcsr);
-
+		pci_set_power_state(pdev, PCI_D0);
 		/*
 		 * The P600 requires a small delay when changing states.
 		 * Otherwise we may think the board did not reset and we bail.
-- 
1.7.1


