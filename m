Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbaEDPmH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaEDPmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Franciosi <felipe@paradoxo.org>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.14 131/158] mtip32xx: Unmap the DMA segments before completing the IO request
Date: Sun,  4 May 2014 11:40:40 -0400
Message-Id: <20140504154047.817129949@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Franciosi <felipe@paradoxo.org>

commit 368c89d7ac70f937c93cd6f3b65bcfdfb3ba794f upstream.

If the buffers are unmapped after completing a request, then stale data
might be in the request.

Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/mtip32xx/mtip32xx.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -266,6 +266,12 @@ static void mtip_async_complete(struct m
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
@@ -273,12 +279,6 @@ static void mtip_async_complete(struct m
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
@@ -709,6 +709,12 @@ static void mtip_timeout_function(unsign
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
@@ -716,12 +722,6 @@ static void mtip_timeout_function(unsign
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


