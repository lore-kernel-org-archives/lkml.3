Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaCMUw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:52:57 -0400
Received: from mailout.micron.com ([137.201.242.129]:45711 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259AbaCMUwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:52:55 -0400
Message-ID: <53221E92.3030707@micron.com>
Date: Thu, 13 Mar 2014 14:09:38 -0700
From: Sam Bradshaw <sbradshaw@micron.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>, Felipe Franciosi <felipe@paradoxo.org>,
        <david.vrabel@citrix.com>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa)" 
	<asamymuthupa@micron.com>
Subject: [PATCH] mtip32xx: mtip_async_complete() bug fixes
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20564.000
X-TM-AS-Result: No--0.872600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes 2 issues in the fast completion path:
1) Possible double completions / double dma_unmap_sg() calls due to lack 
of atomicity in the check and subsequent dereference of the upper layer 
callback function.  Fixed with cmpxchg before unmap and callback.
2) Regression in unaligned IO constraining workaround for p420m devices. 
  Fixed by checking if IO is unaligned and using proper semaphore if so.

Bumped version to indicate presence of these fixes.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
diff --git a/drivers/block/mtip32xx/mtip32xx.c 
b/drivers/block/mtip32xx/mtip32xx.c
index b2012b7..624e9d9 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -252,38 +252,45 @@ static void mtip_async_complete(struct mtip_port 
*port,
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
+	func = cmd->async_callback;
+	if (likely(func && cmpxchg(&cmd->async_callback, func, 0) == func)) {

-	command->async_callback = NULL;
-	command->comp_func = NULL;
+		/* Unmap the DMA scatter list entries */
+		dma_unmap_sg(&dd->pdev->dev,
+			cmd->sg,
+			cmd->scatter_ents,
+			cmd->direction);

-	/* Clear the allocated and active bits for the command */
-	atomic_set(&port->commands[tag].active, 0);
-	release_slot(port, tag);
+		func(cmd->async_data, cb_status);
+		unaligned = cmd->unaligned;

-	up(&port->cmd_slot);
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
@@ -660,11 +667,12 @@ static void mtip_timeout_function(unsigned long 
int data)
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
@@ -694,8 +702,8 @@ static void mtip_timeout_function(unsigned long int 
data)
  			group = tag >> 5;
  			bit = tag & 0x1F;

-			command = &port->commands[tag];
-			fis = (struct host_to_dev_fis *) command->command;
+			cmd = &port->commands[tag];
+			fis = (struct host_to_dev_fis *) cmd->command;

  			set_bit(tag, tagaccum);
  			cmdto_cnt++;
@@ -709,27 +717,30 @@ static void mtip_timeout_function(unsigned long 
int data)
  			 */
  			writel(1 << bit, port->completed[group]);

-			/* Unmap the DMA scatter list entries */
-			dma_unmap_sg(&port->dd->pdev->dev,
-					command->sg,
-					command->scatter_ents,
-					command->direction);
+			/* Clear the active flag for the command */
+			atomic_set(&port->commands[tag].active, 0);

-			/* Call the async completion callback. */
-			if (likely(command->async_callback))
-				command->async_callback(command->async_data,
-							 -EIO);
-			command->async_callback = NULL;
-			command->comp_func = NULL;
+			func = cmd->async_callback;
+			if (func &&
+			    cmpxchg(&cmd->async_callback, func, 0) == func) {

-			/*
-			 * Clear the allocated bit and active tag for the
-			 * command.
-			 */
-			atomic_set(&port->commands[tag].active, 0);
-			release_slot(port, tag);
+				/* Unmap the DMA scatter list entries */
+				dma_unmap_sg(&port->dd->pdev->dev,
+						cmd->sg,
+						cmd->scatter_ents,
+						cmd->direction);

-			up(&port->cmd_slot);
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

diff --git a/drivers/block/mtip32xx/mtip32xx.h 
b/drivers/block/mtip32xx/mtip32xx.h
index 54174cb..ffb955e 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -92,7 +92,7 @@

  /* Driver name and version strings */
  #define MTIP_DRV_NAME		"mtip32xx"
-#define MTIP_DRV_VERSION	"1.3.0"
+#define MTIP_DRV_VERSION	"1.3.1"

  /* Maximum number of minor device numbers per device. */
  #define MTIP_MAX_MINORS		16

