Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab3BZGzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 01:55:53 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:24012 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753379Ab3BZGzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 01:55:52 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <richard.genoud@gmail.com>,
        <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 06/16] spi/spi-atmel: status information passed through controller data
Date: Tue, 26 Feb 2013 14:47:59 +0800
Message-ID: <1361861289-30332-7-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361861289-30332-1-git-send-email-wenyou.yang@atmel.com>
References: <1361861289-30332-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

The status of transfer is stored in controller data structure
so that it can be used not only by atmel_spi_msg_done() function.
This will be useful for upcoming dmaengine enabled driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
[wenyou.yang@atmel.com: submit the patch]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/spi/spi-atmel.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 6ea41a7..136ed8f 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -210,6 +210,7 @@ struct atmel_spi {
 	unsigned long		current_remaining_bytes;
 	struct spi_transfer	*next_transfer;
 	unsigned long		next_remaining_bytes;
+	int			done_status;
 
 	void			*buffer;
 	dma_addr_t		buffer_dma;
@@ -555,15 +556,15 @@ static void atmel_spi_dma_unmap_xfer(struct spi_master *master,
 
 static void
 atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
-		struct spi_message *msg, int status, int stay)
+		struct spi_message *msg, int stay)
 {
-	if (!stay || status < 0)
+	if (!stay || as->done_status < 0)
 		cs_deactivate(as, msg->spi);
 	else
 		as->stay = msg->spi;
 
 	list_del(&msg->queue);
-	msg->status = status;
+	msg->status = as->done_status;
 
 	dev_dbg(master->dev.parent,
 		"xfer complete: %u bytes transferred\n",
@@ -575,6 +576,7 @@ atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
 
 	as->current_transfer = NULL;
 	as->next_transfer = NULL;
+	as->done_status = 0;
 
 	/* continue if needed */
 	if (list_empty(&as->queue) || as->stopping)
@@ -652,7 +654,8 @@ atmel_spi_interrupt(int irq, void *dev_id)
 		/* Clear any overrun happening while cleaning up */
 		spi_readl(as, SR);
 
-		atmel_spi_msg_done(master, as, msg, -EIO, 0);
+		as->done_status = -EIO;
+		atmel_spi_msg_done(master, as, msg, 0);
 	} else if (pending & (SPI_BIT(RXBUFF) | SPI_BIT(ENDRX))) {
 		ret = IRQ_HANDLED;
 
@@ -670,7 +673,7 @@ atmel_spi_interrupt(int irq, void *dev_id)
 
 			if (atmel_spi_xfer_is_last(msg, xfer)) {
 				/* report completed message */
-				atmel_spi_msg_done(master, as, msg, 0,
+				atmel_spi_msg_done(master, as, msg,
 						xfer->cs_change);
 			} else {
 				if (xfer->cs_change) {
-- 
1.7.9.5

