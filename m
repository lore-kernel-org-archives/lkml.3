Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaIPLFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:05:37 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:53000 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaIPLFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:05:23 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-mtd@lists.infradead.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Huang Shijie <shijie8@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/7] mtd: denali: remove a set-but-unused variable
Date: Tue, 16 Sep 2014 20:04:23 +0900
Message-Id: <1410865465-17941-6-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410865465-17941-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable "retry" in wait_for_irq() is set, but not used.
Likewise, for "irq_status" in denali_read_page_raw().

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---

Changes in v3:
  - Remove also set-but-unused irq_status

Changes in v2: None

 drivers/mtd/nand/denali.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index 4cb1497..e5c39d2 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -697,7 +697,6 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
 {
 	unsigned long comp_res;
 	uint32_t intr_status;
-	bool retry = false;
 	unsigned long timeout = msecs_to_jiffies(1000);
 
 	do {
@@ -717,7 +716,6 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
 			 * need to wait again
 			 */
 			spin_unlock_irq(&denali->irq_lock);
-			retry = true;
 		}
 	} while (comp_res != 0);
 
@@ -1220,7 +1218,6 @@ static int denali_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
 	dma_addr_t addr = denali->buf.dma_buf;
 	size_t size = denali->mtd.writesize + denali->mtd.oobsize;
 
-	uint32_t irq_status;
 	uint32_t irq_mask = INTR_STATUS__DMA_CMD_COMP;
 
 	if (page != denali->page) {
@@ -1239,7 +1236,7 @@ static int denali_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
 	denali_setup_dma(denali, DENALI_READ);
 
 	/* wait for operation to complete */
-	irq_status = wait_for_irq(denali, irq_mask);
+	wait_for_irq(denali, irq_mask);
 
 	dma_sync_single_for_cpu(denali->dev, addr, size, DMA_FROM_DEVICE);
 
-- 
1.9.1

