Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab3JRWNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 18:13:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33807 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab3JRWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 18:13:37 -0400
Date: Fri, 18 Oct 2013 17:12:35 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 2/2] rsxx: Fix possible kernel panic with invalid config.
Message-ID: <20131018221235.GC1278@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101822-6688-0000-0000-000002AB080E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This patch fixes a possible Kernel Panic on driver load if 
the configuration on the card is messed up or not yet set.
The driver could possible give a 32 bit unsigned all Fs to
the kernel as the device's block size.

Now we only write the block size to the kernel if the
configuration from the card is valid.

Also, driver version is being updated.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-2.6.32-422.el6-vanilla/Documentation/dontdiff linux-2.6.32-422.el6-vanilla/drivers/block/rsxx/dev.c linux-2.6.32-422.el6/drivers/block/rsxx/dev.c
--- linux-2.6.32-422.el6-vanilla/drivers/block/rsxx/dev.c	2013-10-15 15:19:39.406674940 -0500
+++ linux-2.6.32-422.el6/drivers/block/rsxx/dev.c	2013-10-18 13:40:30.943877311 -0500
@@ -297,13 +297,15 @@ int rsxx_setup_dev(struct rsxx_cardinfo 
 		return -ENOMEM;
 	}
 
-	blk_size = card->config.data.block_size;
+	if (card->config_valid) {
+		blk_size = card->config.data.block_size;
+		blk_queue_dma_alignment(card->queue, blk_size - 1);
+		blk_queue_logical_block_size(card->queue, blk_size);
+	}
 
 	blk_queue_make_request(card->queue, rsxx_make_request);
 	blk_queue_bounce_limit(card->queue, BLK_BOUNCE_ANY);
-	blk_queue_dma_alignment(card->queue, blk_size - 1);
 	blk_queue_max_hw_sectors(card->queue, blkdev_max_hw_sectors);
-	blk_queue_logical_block_size(card->queue, blk_size);
 	blk_queue_physical_block_size(card->queue, RSXX_HW_BLK_SIZE);
 
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, card->queue);
diff -uprN -X linux-2.6.32-422.el6-vanilla/Documentation/dontdiff linux-2.6.32-422.el6-vanilla/drivers/block/rsxx/rsxx_priv.h linux-2.6.32-422.el6/drivers/block/rsxx/rsxx_priv.h
--- linux-2.6.32-422.el6-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-10-18 13:21:36.219677235 -0500
+++ linux-2.6.32-422.el6/drivers/block/rsxx/rsxx_priv.h	2013-10-18 13:40:30.952991256 -0500
@@ -52,7 +52,7 @@ struct proc_cmd;
 #define RS70_PCI_REV_SUPPORTED	4
 
 #define DRIVER_NAME "rsxx"
-#define DRIVER_VERSION "4.0.2.2510"
+#define DRIVER_VERSION "4.0.3.2516"
 
 /* Block size is 4096 */
 #define RSXX_HW_BLK_SHIFT		12

