Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab3CGDbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:31:55 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:53261 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab3CGDbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:31:53 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <grant.likely@secretlab.ca>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <richard.genoud@gmail.com>,
        <JM.Lin@atmel.com>, <wenyou.yang@atmel.com>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 05/16] spi/spi-atmel: call unmapping on transfers buffers
Date: Thu, 7 Mar 2013 11:29:17 +0800
Message-ID: <1362626957-6777-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
References: <1362626715-6549-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
[wenyou.yang@atmel.com: submit the patch]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 drivers/spi/spi-atmel.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index ce9c894..2f61a80 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1049,6 +1049,7 @@ static int atmel_spi_remove(struct platform_device *pdev)
 	struct spi_master	*master = platform_get_drvdata(pdev);
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 	struct spi_message	*msg;
+	struct spi_transfer	*xfer;
 
 	/* reset the hardware and block queue progress */
 	spin_lock_irq(&as->lock);
@@ -1060,9 +1061,10 @@ static int atmel_spi_remove(struct platform_device *pdev)
 
 	/* Terminate remaining queued transfers */
 	list_for_each_entry(msg, &as->queue, queue) {
-		/* REVISIT unmapping the dma is a NOP on ARM and AVR32
-		 * but we shouldn't depend on that...
-		 */
+		list_for_each_entry(xfer, &msg->transfers, transfer_list) {
+			if (!msg->is_dma_mapped)
+				atmel_spi_dma_unmap_xfer(master, xfer);
+		}
 		msg->status = -ESHUTDOWN;
 		msg->complete(msg->context);
 	}
-- 
1.7.9.5

