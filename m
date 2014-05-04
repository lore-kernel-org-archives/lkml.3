Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477AbaEDPmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbaEDPmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sam Bradshaw <sbradshaw@micron.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.14 132/158] mtip32xx: mtip_async_complete() bug fixes
Date: Sun,  4 May 2014 11:40:41 -0400
Message-Id: <20140504154047.956578865@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Bradshaw <sbradshaw@micron.com>

commit 5eb9291c36c7d71d7c6c832d5a4f551eb8ac015d upstream.

This patch fixes 2 issues in the fast completion path:
1) Possible double completions / double dma_unmap_sg() calls due to lack
of atomicity in the check and subsequent dereference of the upper layer
callback function. Fixed with cmpxchg before unmap and callback.
2) Regression in unaligned IO constraining workaround for p420m devices.
Fixed by checking if IO is unaligned and using proper semaphore if so.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/mtip32xx/mtip32xx.c |   93 +++++++++++++++++++++-----------------
 drivers/block/mtip32xx/mtip32xx.h |    2 
 2 files changed, 53 insertions(+), 42 deletions(-)

--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -252,38 +252,45 @@ static void mtip_async_complete(struct m
 				void *data,
 				int status)
 {
-	struct mtip_cmd *command;
+	struct mtip_cmd *cmd;
 	struct driver_data *dd = data;
-	int cb_status = status ? -EIO : 0;
+	int unaligned, cb_status = status ? -EIO : 0;
+	void (*func)(void *, int);
 
 	if (unlikely(!dd) || unlikely(!port))
 		return;
 
-	command = &port->commands[tag];
+	cmd = &port->commands[tag];
 
 	if (unlikely(status == PORT_IRQ_TF_ERR)) {
 		dev_warn(&port->dd->pdev->dev,
 			"Command tag %d failed due to TFE\n", tag);
 	}
 
-	/* Unmap the DMA scatter list entries */
-	dma_unmap_sg(&dd->pdev->dev,
-		command->sg,
-		command->scatter_ents,
-		command->direction);
+	/* Clear the active flag */
+	atomic_set(&port->commands[tag].active, 0);
 
 	/* Upper layer callback */
-	if (likely(command->async_callback))
-		command->async_callback(command->async_data, cb_status);
-
-	command->async_callback = NULL;
-	command->comp_func = NULL;
+	func = cmd->async_callback;
+	if (likely(func && cmpxchg(&cmd->async_callback, func, 0) == func)) {
 
-	/* Clear the allocated and active bits for the command */
-	atomic_set(&port->commands[tag].active, 0);
-	release_slot(port, tag);
-
-	up(&port->cmd_slot);
+		/* Unmap the DMA scatter list entries */
+		dma_unmap_sg(&dd->pdev->dev,
+			cmd->sg,
+			cmd->scatter_ents,
+			cmd->direction);
+
+		func(cmd->async_data, cb_status);
+		unaligned = cmd->unaligned;
+
+		/* Clear the allocated bit for the command */
+		release_slot(port, tag);
+
+		if (unlikely(unaligned))
+			up(&port->cmd_slot_unal);
+		else
+			up(&port->cmd_slot);
+	}
 }
 
 /*
@@ -660,11 +667,12 @@ static void mtip_timeout_function(unsign
 {
 	struct mtip_port *port = (struct mtip_port *) data;
 	struct host_to_dev_fis *fis;
-	struct mtip_cmd *command;
-	int tag, cmdto_cnt = 0;
+	struct mtip_cmd *cmd;
+	int unaligned, tag, cmdto_cnt = 0;
 	unsigned int bit, group;
 	unsigned int num_command_slots;
 	unsigned long to, tagaccum[SLOTBITS_IN_LONGS];
+	void (*func)(void *, int);
 
 	if (unlikely(!port))
 		return;
@@ -694,8 +702,8 @@ static void mtip_timeout_function(unsign
 			group = tag >> 5;
 			bit = tag & 0x1F;
 
-			command = &port->commands[tag];
-			fis = (struct host_to_dev_fis *) command->command;
+			cmd = &port->commands[tag];
+			fis = (struct host_to_dev_fis *) cmd->command;
 
 			set_bit(tag, tagaccum);
 			cmdto_cnt++;
@@ -709,27 +717,30 @@ static void mtip_timeout_function(unsign
 			 */
 			writel(1 << bit, port->completed[group]);
 
-			/* Unmap the DMA scatter list entries */
-			dma_unmap_sg(&port->dd->pdev->dev,
-					command->sg,
-					command->scatter_ents,
-					command->direction);
-
-			/* Call the async completion callback. */
-			if (likely(command->async_callback))
-				command->async_callback(command->async_data,
-							 -EIO);
-			command->async_callback = NULL;
-			command->comp_func = NULL;
-
-			/*
-			 * Clear the allocated bit and active tag for the
-			 * command.
-			 */
+			/* Clear the active flag for the command */
 			atomic_set(&port->commands[tag].active, 0);
-			release_slot(port, tag);
 
-			up(&port->cmd_slot);
+			func = cmd->async_callback;
+			if (func &&
+			    cmpxchg(&cmd->async_callback, func, 0) == func) {
+
+				/* Unmap the DMA scatter list entries */
+				dma_unmap_sg(&port->dd->pdev->dev,
+						cmd->sg,
+						cmd->scatter_ents,
+						cmd->direction);
+
+				func(cmd->async_data, -EIO);
+				unaligned = cmd->unaligned;
+
+				/* Clear the allocated bit for the command. */
+				release_slot(port, tag);
+
+				if (unaligned)
+					up(&port->cmd_slot_unal);
+				else
+					up(&port->cmd_slot);
+			}
 		}
 	}
 
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -92,7 +92,7 @@
 
 /* Driver name and version strings */
 #define MTIP_DRV_NAME		"mtip32xx"
-#define MTIP_DRV_VERSION	"1.3.0"
+#define MTIP_DRV_VERSION	"1.3.1"
 
 /* Maximum number of minor device numbers per device. */
 #define MTIP_MAX_MINORS		16


