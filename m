Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab3BZSpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:45:38 -0500
Received: from masquerade.micron.com ([137.201.242.130]:33082 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab3BZSpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:45:36 -0500
Message-ID: <512D02B3.2020202@micron.com>
Date: Wed, 27 Feb 2013 00:15:07 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: Kent Overstreet <koverstreet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>
Subject: [PATCH] conversion to bio batch completion
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19670.001
X-TM-AS-Result: No--5.396500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This patch is for linux-next, applies cleanly on for-next branch.

This patch contains the following:
	* changes for conversion to bio batch completion from Kent
	* fix to apply the above changes cleanly on latest mtip32xx code
	* batch bio completion changes in 
		* mtip_command_cleanup()
		* mtip_timeout_function()
		* mtip_handle_tfe()

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   86 ++++++++++++++++++++----------------
 drivers/block/mtip32xx/mtip32xx.h |    8 +--
 2 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 11cc952..22d2b0f 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -146,6 +146,9 @@ static void mtip_command_cleanup(struct driver_data *dd)
 	struct mtip_cmd *command;
 	struct mtip_port *port = dd->port;
 	static int in_progress;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (in_progress)
 		return;
@@ -161,11 +164,9 @@ static void mtip_command_cleanup(struct driver_data *dd)
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
@@ -173,9 +174,10 @@ static void mtip_command_cleanup(struct driver_data *dd)
 				command->scatter_ents,
 				command->direction);
 		}
+		up(&port->cmd_slot);
 	}
 
-	up(&port->cmd_slot);
+	batch_complete(&batch);
 
 	set_bit(MTIP_DDF_CLEANUP_BIT, &dd->dd_flag);
 	in_progress = 0;
@@ -564,6 +566,9 @@ static void mtip_timeout_function(unsigned long int data)
 	unsigned int bit, group;
 	unsigned int num_command_slots;
 	unsigned long to, tagaccum[SLOTBITS_IN_LONGS];
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (unlikely(!port))
 		return;
@@ -606,11 +611,9 @@ static void mtip_timeout_function(unsigned long int data)
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
@@ -628,6 +631,8 @@ static void mtip_timeout_function(unsigned long int data)
 			up(&port->cmd_slot);
 		}
 	}
+
+	batch_complete(&batch);
 
 	if (cmdto_cnt) {
 		print_tags(port->dd, "timed out", tagaccum, cmdto_cnt);
@@ -679,7 +684,8 @@ static void mtip_timeout_function(unsigned long int data)
 static void mtip_async_complete(struct mtip_port *port,
 				int tag,
 				void *data,
-				int status)
+				int status,
+				struct batch_complete *batch)
 {
 	struct mtip_cmd *command;
 	struct driver_data *dd = data;
@@ -696,11 +702,10 @@ static void mtip_async_complete(struct mtip_port *port,
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
@@ -733,24 +738,22 @@ static void mtip_async_complete(struct mtip_port *port,
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
@@ -779,6 +782,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 	unsigned char *buf;
 	char *fail_reason = NULL;
 	int fail_all_ncq_write = 0, fail_all_ncq_cmds = 0;
+	struct batch_complete batch;
 
 	dev_warn(&dd->pdev->dev, "Taskfile error\n");
 
@@ -796,13 +800,14 @@ static void mtip_handle_tfe(struct driver_data *dd)
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
@@ -829,7 +834,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 				cmd->comp_func(port,
 					 tag,
 					 cmd->comp_data,
-					 0);
+					 0, &batch);
 			} else {
 				dev_err(&port->dd->pdev->dev,
 					"Missing completion func for tag %d",
@@ -842,6 +847,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 			}
 		}
 	}
+	batch_complete(&batch);
 
 	print_tags(dd, "completed (TFE)", tagaccum, cmd_cnt);
 
@@ -883,6 +889,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 
 	/* clear the tag accumulator */
 	memset(tagaccum, 0, SLOTBITS_IN_LONGS * sizeof(long));
+	batch_complete_init(&batch);
 
 	/* Loop through all the groups */
 	for (group = 0; group < dd->slot_groups; group++) {
@@ -916,7 +923,7 @@ static void mtip_handle_tfe(struct driver_data *dd)
 					if (cmd->comp_func) {
 						cmd->comp_func(port, tag,
 							cmd->comp_data,
-							-ENODATA);
+							-ENODATA, &batch);
 					}
 					continue;
 				}
@@ -946,13 +953,15 @@ static void mtip_handle_tfe(struct driver_data *dd)
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
@@ -973,6 +982,9 @@ static inline void mtip_workq_sdbfx(struct mtip_port *port, int group,
 	struct driver_data *dd = port->dd;
 	int tag, bit;
 	struct mtip_cmd *command;
+	struct batch_complete batch;
+
+	batch_complete_init(&batch);
 
 	if (!completed) {
 		WARN_ON_ONCE(!completed);
@@ -997,7 +1009,8 @@ static inline void mtip_workq_sdbfx(struct mtip_port *port, int group,
 					port,
 					tag,
 					command->comp_data,
-					0);
+					0,
+					&batch);
 			} else {
 				dev_warn(&dd->pdev->dev,
 					"Null completion "
@@ -1007,13 +1020,16 @@ static inline void mtip_workq_sdbfx(struct mtip_port *port, int group,
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
@@ -1034,7 +1050,7 @@ static inline void mtip_process_legacy(struct driver_data *dd, u32 port_stat)
 			cmd->comp_func(port,
 				MTIP_TAG_INTERNAL,
 				cmd->comp_data,
-				0);
+				0, NULL);
 			return;
 		}
 	}
@@ -2554,8 +2570,8 @@ static int mtip_hw_ioctl(struct driver_data *dd, unsigned int cmd,
  *	None
  */
 static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
-			      int nsect, int nents, int tag, void *callback,
-			      void *data, int dir)
+			      int nsect, int nents, int tag,
+			      struct bio *bio, int dir)
 {
 	struct host_to_dev_fis	*fis;
 	struct mtip_port *port = dd->port;
@@ -2610,12 +2626,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
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
@@ -3795,7 +3806,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 				bio_sectors(bio),
 				nents,
 				tag,
-				bio_endio,
 				bio,
 				bio_data_dir(bio));
 	} else
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 3bffff5..af8c6f7 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -325,11 +325,9 @@ struct mtip_cmd {
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
1.7.1

