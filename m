Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbaEMKLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:11:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933488AbaEMKL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Franciosi <felipe@paradoxo.org>,
        Jens Axboe <axboe@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 104/182] mtip32xx: Unmap the DMA segments before completing the IO request
Date: Tue, 13 May 2014 11:27:36 +0200
Message-Id: <97c9da48c28aff1eb9e296ffea9323948bbd319c.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Franciosi <felipe@paradoxo.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 368c89d7ac70f937c93cd6f3b65bcfdfb3ba794f upstream.

If the buffers are unmapped after completing a request, then stale data
might be in the request.

Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/mtip32xx/mtip32xx.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index bd3d20741958..4d26c25aa9c5 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -621,6 +621,12 @@ static void mtip_timeout_function(unsigned long int data)
 			 */
 			writel(1 << bit, port->completed[group]);
 
+			/* Unmap the DMA scatter list entries */
+			dma_unmap_sg(&port->dd->pdev->dev,
+					command->sg,
+					command->scatter_ents,
+					command->direction);
+
 			/* Call the async completion callback. */
 			if (likely(command->async_callback))
 				command->async_callback(command->async_data,
@@ -628,12 +634,6 @@ static void mtip_timeout_function(unsigned long int data)
 			command->async_callback = NULL;
 			command->comp_func = NULL;
 
-			/* Unmap the DMA scatter list entries */
-			dma_unmap_sg(&port->dd->pdev->dev,
-					command->sg,
-					command->scatter_ents,
-					command->direction);
-
 			/*
 			 * Clear the allocated bit and active tag for the
 			 * command.
@@ -711,6 +711,12 @@ static void mtip_async_complete(struct mtip_port *port,
 			"Command tag %d failed due to TFE\n", tag);
 	}
 
+	/* Unmap the DMA scatter list entries */
+	dma_unmap_sg(&dd->pdev->dev,
+		command->sg,
+		command->scatter_ents,
+		command->direction);
+
 	/* Upper layer callback */
 	if (likely(command->async_callback))
 		command->async_callback(command->async_data, cb_status);
@@ -718,12 +724,6 @@ static void mtip_async_complete(struct mtip_port *port,
 	command->async_callback = NULL;
 	command->comp_func = NULL;
 
-	/* Unmap the DMA scatter list entries */
-	dma_unmap_sg(&dd->pdev->dev,
-		command->sg,
-		command->scatter_ents,
-		command->direction);
-
 	/* Clear the allocated and active bits for the command */
 	atomic_set(&port->commands[tag].active, 0);
 	release_slot(port, tag);
-- 
1.9.3

