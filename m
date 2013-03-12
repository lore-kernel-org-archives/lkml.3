Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab3CLKzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:55:08 -0400
Received: from multi.imgtec.com ([194.200.65.239]:43982 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3CLKzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:55:06 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-mmc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "Jaehoon Chung" <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 1/3] dw_mmc: Don't loop when handling an interrupt
Date: Tue, 12 Mar 2013 10:53:11 +0000
Message-ID: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_12_10_55_04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to loop when handling an interrupt. The "if" clauses
will handle all of them sequentially. This also eliminates the extra loop
we used to take with no pending interrupts and we ended up breaking out
of the while loop.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>
---
The patch is based on Chris Ball's mmc-next branch

 drivers/mmc/host/dw_mmc.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 60063cc..78c7251 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1563,11 +1563,11 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 {
 	struct dw_mci *host = dev_id;
 	u32 pending;
-	unsigned int pass_count = 0;
 	int i;
 
-	do {
-		pending = mci_readl(host, MINTSTS); /* read-only mask reg */
+	pending = mci_readl(host, MINTSTS); /* read-only mask reg */
+
+	if (pending) {
 
 		/*
 		 * DTO fix - version 2.10a and below, and only if internal DMA
@@ -1579,9 +1579,6 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 				pending |= SDMMC_INT_DATA_OVER;
 		}
 
-		if (!pending)
-			break;
-
 		if (pending & DW_MCI_CMD_ERROR_FLAGS) {
 			mci_writel(host, RINTSTS, DW_MCI_CMD_ERROR_FLAGS);
 			host->cmd_status = pending;
@@ -1642,7 +1639,7 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 			}
 		}
 
-	} while (pass_count++ < 5);
+	}
 
 #ifdef CONFIG_MMC_DW_IDMAC
 	/* Handle DMA interrupts */
-- 
1.7.1


