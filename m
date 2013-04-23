Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3DWROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:14:20 -0400
Received: from masquerade.micron.com ([137.201.242.130]:25789 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab3DWROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:14:19 -0400
Message-ID: <5176C163.3090404@micron.com>
Date: Tue, 23 Apr 2013 22:44:11 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>
Subject: [PATCH] mtip32xx: Workaround for unaligned writes
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19820.000
X-TM-AS-Result: No-9.812100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workaround for handling unaligned writes: limit number of outstanding
unaligned writes

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   59 +++++++++++++++++++++++++++++-------
 drivers/block/mtip32xx/mtip32xx.h |   11 +++++++
 2 files changed, 58 insertions(+), 12 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 30a03ab..c0d3873 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -712,7 +712,10 @@ static void mtip_async_complete(struct mtip_port *port,
 	atomic_set(&port->commands[tag].active, 0);
 	release_slot(port, tag);
 
-	up(&port->cmd_slot);
+	if (unlikely(command->unaligned))
+		up(&port->cmd_slot_unal);
+	else
+		up(&port->cmd_slot);
 }
 
 /*
@@ -2557,7 +2560,7 @@ static int mtip_hw_ioctl(struct driver_data *dd, unsigned int cmd,
  */
 static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
 			      int nsect, int nents, int tag, void *callback,
-			      void *data, int dir)
+			      void *data, int dir, int unaligned)
 {
 	struct host_to_dev_fis	*fis;
 	struct mtip_port *port = dd->port;
@@ -2570,6 +2573,7 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
 
 	command->scatter_ents = nents;
 
+	command->unaligned = unaligned;
 	/*
 	 * The number of retries for this command before it is
 	 * reported as a failure to the upper layers.
@@ -2598,6 +2602,9 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
 	fis->res3        = 0;
 	fill_command_sg(dd, command, nents);
 
+	if (unaligned)
+		fis->device |= 1 << 7;
+
 	/* Populate the command header */
 	command->command_header->opts =
 			__force_bit2int cpu_to_le32(
@@ -2644,9 +2651,13 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t sector,
  * return value
  *      None
  */
-static void mtip_hw_release_scatterlist(struct driver_data *dd, int tag)
+static void mtip_hw_release_scatterlist(struct driver_data *dd, int tag,
+								int unaligned)
 {
+	struct semaphore *sem = unaligned ? &dd->port->cmd_slot_unal :
+							&dd->port->cmd_slot;
 	release_slot(dd->port, tag);
+	up(sem);
 }
 
 /*
@@ -2661,22 +2672,25 @@ static void mtip_hw_release_scatterlist(struct driver_data *dd, int tag)
  *	or NULL if no command slots are available.
  */
 static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
-						   int *tag)
+						   int *tag, int unaligned)
 {
+	struct semaphore *sem = unaligned ? &dd->port->cmd_slot_unal :
+							&dd->port->cmd_slot;
+
 	/*
 	 * It is possible that, even with this semaphore, a thread
 	 * may think that no command slots are available. Therefore, we
 	 * need to make an attempt to get_slot().
 	 */
-	down(&dd->port->cmd_slot);
+	down(sem);
 	*tag = get_slot(dd->port);
 
 	if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag))) {
-		up(&dd->port->cmd_slot);
+		up(sem);
 		return NULL;
 	}
 	if (unlikely(*tag < 0)) {
-		up(&dd->port->cmd_slot);
+		up(sem);
 		return NULL;
 	}
 
@@ -2909,6 +2923,11 @@ static inline void hba_setup(struct driver_data *dd)
 		dd->mmio + HOST_HSORG);
 }
 
+static int mtip_device_unaligned_constrained(struct driver_data *dd)
+{
+	return (dd->pdev->device == P420M_DEVICE_ID ? 1 : 0);
+}
+
 /*
  * Detect the details of the product, and store anything needed
  * into the driver data structure.  This includes product type and
@@ -3131,8 +3150,15 @@ static int mtip_hw_init(struct driver_data *dd)
 	for (i = 0; i < MTIP_MAX_SLOT_GROUPS; i++)
 		dd->work[i].port = dd->port;
 
+	/* Enable unaligned IO constraints for some devices */
+	if (mtip_device_unaligned_constrained(dd))
+		dd->unal_qdepth = MTIP_MAX_UNALIGNED_SLOTS;
+	else
+		dd->unal_qdepth = 0;
+
 	/* Counting semaphore to track command slot usage */
-	sema_init(&dd->port->cmd_slot, num_command_slots - 1);
+	sema_init(&dd->port->cmd_slot, num_command_slots - 1 - dd->unal_qdepth);
+	sema_init(&dd->port->cmd_slot_unal, dd->unal_qdepth);
 
 	/* Spinlock to prevent concurrent issue */
 	for (i = 0; i < MTIP_MAX_SLOT_GROUPS; i++)
@@ -3735,7 +3761,7 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 	struct scatterlist *sg;
 	struct bio_vec *bvec;
 	int nents = 0;
-	int tag = 0;
+	int tag = 0, unaligned = 0;
 
 	if (unlikely(dd->dd_flag & MTIP_DDF_STOP_IO)) {
 		if (unlikely(test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
@@ -3771,7 +3797,15 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 		return;
 	}
 
-	sg = mtip_hw_get_scatterlist(dd, &tag);
+	if (bio_data_dir(bio) == WRITE && bio_sectors(bio) <= 64 &&
+							dd->unal_qdepth) {
+		if (bio->bi_sector % 8 != 0) /* Unaligned on 4k boundaries */
+			unaligned = 1;
+		else if (bio_sectors(bio) % 8 != 0) /* Aligned but not 4k/8k */
+			unaligned = 1;
+	}
+
+	sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
 	if (likely(sg != NULL)) {
 		blk_queue_bounce(queue, &bio);
 
@@ -3779,7 +3813,7 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 			dev_warn(&dd->pdev->dev,
 				"Maximum number of SGL entries exceeded\n");
 			bio_io_error(bio);
-			mtip_hw_release_scatterlist(dd, tag);
+			mtip_hw_release_scatterlist(dd, tag, unaligned);
 			return;
 		}
 
@@ -3799,7 +3833,8 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
 				tag,
 				bio_endio,
 				bio,
-				bio_data_dir(bio));
+				bio_data_dir(bio),
+				unaligned);
 	} else
 		bio_io_error(bio);
 }
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 3bffff5..579fb84 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -52,6 +52,9 @@
 #define MTIP_FTL_REBUILD_MAGIC		0xED51
 #define MTIP_FTL_REBUILD_TIMEOUT_MS	2400000
 
+/* unaligned IO handling */
+#define MTIP_MAX_UNALIGNED_SLOTS	8
+
 /* Macro to extract the tag bit number from a tag value. */
 #define MTIP_TAG_BIT(tag)	(tag & 0x1F)
 
@@ -333,6 +336,8 @@ struct mtip_cmd {
 
 	int scatter_ents; /* Number of scatter list entries used */
 
+	int unaligned; /* command is unaligned on 4k boundary */
+
 	struct scatterlist sg[MTIP_MAX_SG]; /* Scatter list entries */
 
 	int retries; /* The number of retries left for this command. */
@@ -452,6 +457,10 @@ struct mtip_port {
 	 * command slots available.
 	 */
 	struct semaphore cmd_slot;
+
+	/* Semaphore to control queue depth of unaligned IOs */
+	struct semaphore cmd_slot_unal;
+
 	/* Spinlock for working around command-issue bug. */
 	spinlock_t cmd_issue_lock[MTIP_MAX_SLOT_GROUPS];
 };
@@ -501,6 +510,8 @@ struct driver_data {
 	atomic_t irq_workers_active;
 
 	int isr_binding;
+
+	int unal_qdepth; /* qdepth of unaligned IO queue */
 };
 
 #endif
-- 
1.7.1


