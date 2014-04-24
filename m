Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaDXLTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:19:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46472 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaDXIxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Franciosi <felipe@paradoxo.org>, Jens Axboe <axboe@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 050/182] mtip32xx: Unmap the DMA segments before completing the IO request
Date: Thu, 24 Apr 2014 09:49:35 +0100
Message-Id: <1398329507-5911-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Franciosi <felipe@paradoxo.org>

commit 368c89d7ac70f937c93cd6f3b65bcfdfb3ba794f upstream.

If the buffers are unmapped after completing a request, then stale data
might be in the request.

Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/mtip32xx/mtip32xx.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index bd3d207..4d26c25 100644
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
1.9.1

