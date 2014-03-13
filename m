Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaCMOe6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:34:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:31779 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbaCMOe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:34:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,647,1389744000"; 
   d="scan'208";a="111026240"
From: Felipe Franciosi <felipe@paradoxo.org>
To: <linux-kernel@vger.kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Felipe Franciosi <felipe@paradoxo.org>
Subject: [PATCH 2/2] mtip32xx: Unmap the DMA segments before completing the IO request
Date: Thu, 13 Mar 2014 14:34:21 +0000
Message-ID: <1394721261-2764-3-git-send-email-felipe@paradoxo.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394721261-2764-1-git-send-email-felipe@paradoxo.org>
References: <1394721261-2764-1-git-send-email-felipe@paradoxo.org>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the buffers are unmapped after completing a request, then stale data
might be in the request.

Signed-off-by: Felipe Franciosi <felipe@paradoxo.org>
---
 drivers/block/mtip32xx/mtip32xx.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 787c9d3..4dd2642 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -266,6 +266,12 @@ static void mtip_async_complete(struct mtip_port *port,
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
@@ -273,12 +279,6 @@ static void mtip_async_complete(struct mtip_port *port,
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
@@ -709,6 +709,12 @@ static void mtip_timeout_function(unsigned long int data)
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
@@ -716,12 +722,6 @@ static void mtip_timeout_function(unsigned long int data)
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
-- 
1.7.10.4

