Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3ENBVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:21:47 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40959 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab3ENBT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:26 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Asai Thambi S P <asamymuthupa@micron.com>, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 16/21] mtip32xx: convert to batch completion
Date: Mon, 13 May 2013 18:18:53 -0700
Message-Id: <1368494338-7069-17-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[asamymuthupa@micron.com:
	* changes for conversion to bio batch completion from Kent
	* fix to apply the above changes cleanly on latest mtip32xx code
	* batch bio completion changes in
		* mtip_command_cleanup()
		* mtip_timeout_function()
		* mtip_handle_tfe()]

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/block/mtip32xx/mtip32xx.c | 86 ++++++++++++++++++++++-----------------
 drivers/block/mtip32xx/mtip32xx.h |  8 ++--
 2 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 847107e..1262321 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -151,6 +151,9 @@ static void mtip_command_cleanup(struct driver_data *dd)
 	struct mtip_cmd *command;
 	struct mtip_port *port = dd->port;
 	static int in_progress;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (in_progress)
 		return;
@@ -166,11 +169,9 @@ static void mtip_command_cleanup(struct driver_data *dd)
 			command = &port->commands[commandindex];
 
 			if (atomic_read(&command->active)
-			    && (command->async_callback)) {
-				command->async_callback(command->async_data,
-					-ENODEV);
-				command->async_callback = NULL;
-				command->async_data = NULL;
+			    && (command->bio)) {
+				bio_endio_batch(command->bio, -ENODEV, &batch);
+				command->bio = NULL;
 			}
 
 			dma_unmap_sg(&port->dd->pdev->dev,
@@ -178,9 +179,10 @@ static void mtip_command_cleanup(struct driver_data *dd)
 				command->scatter_ents,
 				command->direction);
 		}
+		up(&port->cmd_slot);
 	}
 
-	up(&port->cmd_slot);
+	batch_complete(&batch);
 
 	set_bit(MTIP_DDF_CLEANUP_BIT, &dd->dd_flag);
 	in_progress = 0;
@@ -580,6 +582,9 @@ static void mtip_timeout_function(unsigned long int data)
 	unsigned int bit, group;
 	unsigned int num_command_slots;
 	unsigned long to, tagaccum[SLOTBITS_IN_LONGS];
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (unlikely(!port))
 		return;
@@ -622,11 +627,9 @@ static void mtip_timeout_function(unsigned long int data)
 			writel(1 << bit, port->completed[group]);
 
 			/* Call the async completion callback. */
-			if (likely(command->async_callback))
-				command->async_callback(command->async_data,
-							 -EIO);
-			command->async_callback = NULL;
-			command->comp_func = NULL;
+			if (likely(command->bio))
+				bio_endio_batch(command->bio, -EIO, &batch);
+			command->bio = NULL;
 
 			/* Unmap the DMA scatter list entries */
 			dma_unmap_sg(&port->dd->pdev->dev,
@@ -645,6 +648,8 @@ static void mtip_timeout_function(unsigned long int data)
 		}
 	}
 
+	batch_complete(&batch);
+
 	if (cmdto_cnt) {
 		print_tags(port->dd, "timed out", tagaccum, cmdto_cnt);
 		if (!test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags)) {
@@ -695,7 +700,8 @@ static void mtip_timeout_function(unsigned long int data)
 static void mtip_async_complete(struct mtip_port *port,
 				int tag,
 				void *data,
-				int status)
+				int status,
+				struct batch_complete *batch)
 {
 	struct mtip_cmd *command;
 	struct driver_data *dd = data;
@@ -712,11 +718,10 @@ static void mtip_async_complete(struct mtip_port *port,
 	}
 
 	/* Upper layer callback */
-	if (likely(command->async_callback))
-		command->async_callback(command->async_data, cb_status);
+	if (likely(command->bio))
+		bio_endio_batch(command->bio, cb_status, batch);
 
-	command->async_callback = NULL;
-	command->comp_func = NULL;
+	command->bio = NULL;
 
 	/* Unmap the DMA scatter list entries */
 	dma_unmap_sg(&dd->pdev->dev,
@@ -752,24 +757,22 @@ static void mtip_async_complete(struct mtip_port *port,
 static void mtip_completion(struct mtip_port *port,
 			    int tag,
 			    void *data,
-			    int status)
+			    int status,
+			    struct batch_complete *batch)
 {
-	struct mtip_cmd *command = &port->commands[tag];
 	struct completion *waiting = data;
 	if (unlikely(status == PORT_IRQ_TF_ERR))
 		dev_warn(&port->dd->pdev->dev,
 			"Internal command %d completed with TFE\n", tag);
 
-	command->async_callback = NULL;
-	command->comp_func = NULL;
-
 	complete(waiting);
 }
 
 static void mtip_null_completion(struct mtip_port *port,
 			    int tag,
 			    void *data,
-			    int status)
+			    int status,
+			    struct batch_complete *batch)
 {
 	return;
 }
@@ -798,6 +801,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 	unsigned char *buf;
 	char *fail_reason = NULL;
 	int fail_all_ncq_write = 0, fail_all_ncq_cmds = 0;
+	struct batch_complete batch;
 
 	dev_warn(&dd->pdev->dev, "Taskfile error\n");
 
@@ -815,13 +819,14 @@ static void mtip_handle_tfe(struct driver_data *dd)
 		atomic_inc(&cmd->active); /* active > 1 indicates error */
 		if (cmd->comp_data && cmd->comp_func) {
 			cmd->comp_func(port, MTIP_TAG_INTERNAL,
-					cmd->comp_data, PORT_IRQ_TF_ERR);
+					cmd->comp_data, PORT_IRQ_TF_ERR, NULL);
 		}
 		goto handle_tfe_exit;
 	}
 
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
+	batch_complete_init(&batch);
 
 	/* Loop through all the groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -848,7 +853,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 				cmd->comp_func(port,
 					 tag,
 					 cmd->comp_data,
-					 0);
+					 0, &batch);
 			} else {
 				dev_err(&port->dd->pdev->dev,
 					"Missing completion func for tag %d",
@@ -861,6 +866,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 			}
 		}
 	}
+	batch_complete(&batch);
 
 	print_tags(dd, "completed (TFE)", tagaccum, cmd_cnt);
 
@@ -902,6 +908,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
+	batch_complete_init(&batch);
 
 	/* Loop through all the groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -935,7 +942,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 					if (cmd->comp_func) {
 						cmd->comp_func(port, tag,
 							cmd->comp_data,
-							-ENODATA);
+							-ENODATA, &batch);
 					}
 					continue;
 				}
@@ -965,13 +972,15 @@ static void mtip_handle_tfe(struct driver_data *dd)
 					port,
 					tag,
 					cmd->comp_data,
-					PORT_IRQ_TF_ERR);
+					PORT_IRQ_TF_ERR, &batch);
 			else
 				dev_warn(&port->dd->pdev->dev,
 					"Bad completion for tag %d\n",
 					tag);
 		}
 	}
+
+	batch_complete(&batch);
 	print_tags(dd, "reissued (TFE)", tagaccum, cmd_cnt);
 
 handle_tfe_exit:
@@ -992,6 +1001,9 @@ static inline void mtip_workq_sdbfx(struct mtip_port *port, int group,
 	struct driver_data *dd = port->dd;
 	int tag, bit;
 	struct mtip_cmd *command;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (!completed) {
 		WARN_ON_ONCE(!completed);
@@ -1016,7 +1028,8 @@ static inline void mtip_workq_sdbfx(struct mtip_port *port, int group,
 					port,
 					tag,
 					command->comp_data,
-					0);
+					0,
+					&batch);
 			} else {
 				dev_warn(&dd->pdev->dev,
 					"Null completion "
@@ -1026,13 +1039,16 @@ static inline void mtip_workq_sdbfx(struct mtip_port *port, int group,
 				if (mtip_check_surprise_removal(
 					dd->pdev)) {
 					mtip_command_cleanup(dd);
-					return;
+					goto out;
 				}
 			}
 		}
 		completed >>= 1;
 	}
 
+out:
+	batch_complete(&batch);
+
 	/* If last, re-enable interrupts */
 	if (atomic_dec_return(&dd->irq_workers_active) == 0)
 		writel(0xffffffff, dd->mmio + HOST_IRQ_STAT);
@@ -1053,7 +1069,7 @@ static inline void mtip_process_legacy(struct driver_data *dd, u32 port_stat)
 			cmd->comp_func(port,
 				MTIP_TAG_INTERNAL,
 				cmd->comp_data,
-				0);
+				0, NULL);
 			return;
 		}
 	}
@@ -2561,8 +2577,8 @@ static int mtip_hw_ioctl(struct driver_data *dd, unsigned int cmd,
  *	None
  */
 static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
-			      int nsect, int nents, int tag, void *callback,
-			      void *data, int dir, int unaligned)
+			      int nsect, int nents, int tag,
+			      struct bio *bio, int dir, int unaligned)
 {
 	struct host_to_dev_fis	*fis;
 	struct mtip_port *port = dd->port;
@@ -2621,12 +2637,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
 	command->comp_func = mtip_async_complete;
 	command->direction = dma_dir;
 
-	/*
-	 * Set the completion function and data for the command passed
-	 * from the upper layer.
-	 */
-	command->async_data = data;
-	command->async_callback = callback;
+	command->bio = bio;
 
 	/*
 	 * To prevent this command from being issued
@@ -3934,7 +3945,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 				bio_sectors(bio),
 				nents,
 				tag,
-				bio_endio,
 				bio,
 				bio_data_dir(bio),
 				unaligned);
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 3bb8a29..7a2ddfd 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -328,11 +328,9 @@ struct mtip_cmd {
 	void (*comp_func)(struct mtip_port *port,
 				int tag,
 				void *data,
-				int status);
-	/* Additional callback function that may be called by comp_func() */
-	void (*async_callback)(void *data, int status);
-
-	void *async_data; /* Addl. data passed to async_callback() */
+				int status,
+				struct batch_complete *batch);
+	struct bio *bio;
 
 	int scatter_ents; /* Number of scatter list entries used */
 
-- 
1.8.2.1

