Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3ANHlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:41:18 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:37376 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab3ANHlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:41:14 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Subject: [v4 PATCH 02/12] spi/atmel_spi: call unmapping on transfers buffers
Date: Mon, 14 Jan 2013 15:34:27 +0800
Message-Id: <1358148877-18679-3-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358148877-18679-1-git-send-email-wenyou.yang@atmel.com>
References: <1358148877-18679-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 14 Jan 2013 07:40:50.0261 (UTC) FILETIME=[7961C050:01CDF22A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-atmel.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 4516839..9782206 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1016,6 +1016,7 @@ static int atmel_spi_remove(struct platform_device *pdev)
 	struct spi_master	*master = platform_get_drvdata(pdev);
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 	struct spi_message	*msg;
+	struct spi_transfer	*xfer;
 
 	/* reset the hardware and block queue progress */
 	spin_lock_irq(&as->lock);
@@ -1027,9 +1028,10 @@ static int atmel_spi_remove(struct platform_device *pdev)
 
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

