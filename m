Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbaCQJ51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:57:27 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47430 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbaCQJ5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:57:24 -0400
Date: Mon, 17 Mar 2014 17:56:53 +0800
From: Shaohua Li <shli@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        agk@redhat.com
Subject: Re: [patch v3]DM: dm-insitu-comp: a compressed DM target for SSD
Message-ID: <20140317095653.GA1014@kernel.org>
References: <20140218101304.GA24889@kernel.org>
 <20140307075733.GB21790@kernel.org>
 <20140310135256.GA28665@redhat.com>
 <20140314094008.GA2386@kernel.org>
 <20140314224444.GA18027@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314224444.GA18027@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 06:44:45PM -0400, Mike Snitzer wrote:
> On Fri, Mar 14 2014 at  5:40am -0400,
> Shaohua Li <shli@kernel.org> wrote:
> 
> > On Mon, Mar 10, 2014 at 09:52:56AM -0400, Mike Snitzer wrote:
> > > On Fri, Mar 07 2014 at  2:57am -0500,
> > > Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > ping!
> > > 
> > > Hi,
> > > 
> > > I intend to get dm-insitu-comp reviewed for 3.15.  Sorry I haven't
> > > gotten back with you before now, been busy tending to 3.14-rc issues.
> > > 
> > > I took a quick first pass over your code a couple weeks ago.  Looks to
> > > be in great shape relative to coding conventions and the more DM
> > > specific conventions.  Clearly demonstrates you have a good command of
> > > DM concepts and quirks.
> 
> Think I need to eat my words from above at least partially.  Given you
> haven't implemented any of the target suspend or resume hooks this
> target will _not_ work properly across suspend + resume cycles that all
> DM targets must support.
> 
> But we can obviously work through it with urgency for 3.15.
> 
> I've pulled your v3 patch into git and have overlayed edits from my
> first pass.  Lots of funky wrapping to conform to 80 columns.  But
> whitespace aside, I've added FIXME:s in the relevant files.  If you work
> on any of these FIXMEs please send follow-up patches so that we don't
> step on each others' toes.
> 
> Please see the 'for-3.15-insitu-comp' branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git

Thanks for your to look at it. I fixed them against your tree. Please check below patch.


Subject: dm-insitu-comp: fix different issues

Fix different issues pointed out by Mike and add suspend/resume support.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/dm-insitu-comp.c |  108 ++++++++++++++++++++++++++++++--------------
 drivers/md/dm-insitu-comp.h |    8 +++
 2 files changed, 84 insertions(+), 32 deletions(-)

Index: linux/drivers/md/dm-insitu-comp.c
===================================================================
--- linux.orig/drivers/md/dm-insitu-comp.c	2014-03-17 12:37:37.850751341 +0800
+++ linux/drivers/md/dm-insitu-comp.c	2014-03-17 17:40:01.106660303 +0800
@@ -17,6 +17,7 @@
 #include "dm-insitu-comp.h"
 
 #define DM_MSG_PREFIX "insitu-comp"
+#define DEFAULT_WRITEBACK_DELAY 5
 
 static inline int lzo_comp_len(int comp_len)
 {
@@ -40,6 +41,10 @@ static struct kmem_cache *insitu_comp_me
 static struct insitu_comp_io_worker insitu_comp_io_workers[NR_CPUS];
 static struct workqueue_struct *insitu_comp_wq;
 
+#define BYTE_BITS 8
+#define BYTE_BITS_SHIFT 3
+#define BYTE_BITS_MASK (BYTE_BITS - 1)
+
 /* each block has 5 bits of metadata */
 static u8 insitu_comp_get_meta(struct insitu_comp_info *info, u64 block_index)
 {
@@ -47,15 +52,14 @@ static u8 insitu_comp_get_meta(struct in
 	int bits, offset;
 	u8 data, ret = 0;
 
-	// FIXME: "magic" numbers in this function (7, 3)
-	offset = first_bit & 7;
-	bits = min_t(u8, INSITU_COMP_META_BITS, 8 - offset);
+	offset = first_bit & BYTE_BITS_MASK;
+	bits = min_t(u8, INSITU_COMP_META_BITS, BYTE_BITS - offset);
 
-	data = info->meta_bitmap[first_bit >> 3];
+	data = info->meta_bitmap[first_bit >> BYTE_BITS_SHIFT];
 	ret = (data >> offset) & ((1 << bits) - 1);
 
 	if (bits < INSITU_COMP_META_BITS) {
-		data = info->meta_bitmap[(first_bit >> 3) + 1];
+		data = info->meta_bitmap[(first_bit >> BYTE_BITS_SHIFT) + 1];
 		bits = INSITU_COMP_META_BITS - bits;
 		ret |= (data & ((1 << bits) - 1)) <<
 			(INSITU_COMP_META_BITS - bits);
@@ -71,14 +75,13 @@ static void insitu_comp_set_meta(struct
 	u8 data;
 	struct page *page;
 
-	// FIXME: "magic" numbers in this function (7, 3)
-	offset = first_bit & 7;
-	bits = min_t(u8, INSITU_COMP_META_BITS, 8 - offset);
+	offset = first_bit & BYTE_BITS_MASK;
+	bits = min_t(u8, INSITU_COMP_META_BITS, BYTE_BITS - offset);
 
-	data = info->meta_bitmap[first_bit >> 3];
+	data = info->meta_bitmap[first_bit >> BYTE_BITS_SHIFT];
 	data &= ~(((1 << bits) - 1) << offset);
 	data |= (meta & ((1 << bits) - 1)) << offset;
-	info->meta_bitmap[first_bit >> 3] = data;
+	info->meta_bitmap[first_bit >> BYTE_BITS_SHIFT] = data;
 
 	/*
 	 * For writethrough, we write metadata directly.  For writeback, if
@@ -301,9 +304,24 @@ static int insitu_comp_meta_writeback_th
 	init_completion(&wb.complete);
 
 	while (!kthread_should_stop()) {
-		// FIXME: writeback_delay should be in secs
-		schedule_timeout_interruptible(msecs_to_jiffies(info->writeback_delay * 1000));
+		schedule_timeout_interruptible(
+		    msecs_to_jiffies(info->writeback_delay * MSEC_PER_SEC));
 		insitu_comp_flush_dirty_meta(info, &wb);
+
+		if (info->wb_thread_suspend_status != WB_THREAD_RESUMED) {
+			writeback_flush_io_done(&wb, 0);
+			wait_for_completion(&wb.complete);
+
+			info->wb_thread_suspend_status = WB_THREAD_SUSPENDED;
+			wake_up_interruptible(&info->wb_thread_suspend_wq);
+
+			wait_event_interruptible(info->wb_thread_suspend_wq,
+			  info->wb_thread_suspend_status == WB_THREAD_RESUMED ||
+			  kthread_should_stop());
+
+			atomic_set(&wb.cnt, 1);
+			init_completion(&wb.complete);
+		}
 	}
 
 	insitu_comp_flush_dirty_meta(info, &wb);
@@ -357,6 +375,8 @@ static int insitu_comp_init_meta(struct
 			info->ti->error = "Create writeback thread error";
 			return -EINVAL;
 		}
+		info->wb_thread_suspend_status = WB_THREAD_RESUMED;
+		init_waitqueue_head(&info->wb_thread_suspend_wq);
 	}
 
 	return 0;
@@ -410,7 +430,6 @@ static int insitu_comp_read_or_create_su
 
 	total_blocks = i_size_read(info->dev->bdev->bd_inode) >> INSITU_COMP_BLOCK_SHIFT;
 	data_blocks = total_blocks - 1;
-	// FIXME: 64bit divide on 32bit?  must compile/work on 32bit
 	rem = do_div(data_blocks, INSITU_COMP_BLOCK_SIZE * 8 + INSITU_COMP_META_BITS);
 	meta_blocks = data_blocks * INSITU_COMP_META_BITS;
 	data_blocks *= INSITU_COMP_BLOCK_SIZE * 8;
@@ -507,13 +526,11 @@ out:
  */
 static int insitu_comp_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
-	// FIXME: add proper feature arg processing.
-	// FIXME: pick default metadata write mode.
 	struct insitu_comp_info *info;
 	char write_mode[15];
 	int ret, i;
 
-	if (argc < 2) {
+	if (argc < 1) {
 		ti->error = "Invalid argument count";
 		return -EINVAL;
 	}
@@ -525,19 +542,18 @@ static int insitu_comp_ctr(struct dm_tar
 	}
 	info->ti = ti;
 
+	info->write_mode = INSITU_COMP_WRITE_BACK;
+	info->writeback_delay = DEFAULT_WRITEBACK_DELAY;
+	if (argc == 1)
+		goto skip_optargs;
+
 	if (sscanf(argv[1], "%s", write_mode) != 1) {
 		ti->error = "Invalid argument";
 		ret = -EINVAL;
 		goto err_para;
 	}
 
-	if (strcmp(write_mode, "writeback") == 0) {
-		if (argc != 3) {
-			ti->error = "Invalid argument";
-			ret = -EINVAL;
-			goto err_para;
-		}
-		info->write_mode = INSITU_COMP_WRITE_BACK;
+	if (strcmp(write_mode, "writeback") == 0 && argc == 3) {
 		if (sscanf(argv[2], "%u", &info->writeback_delay) != 1) {
 			ti->error = "Invalid argument";
 			ret = -EINVAL;
@@ -551,6 +567,7 @@ static int insitu_comp_ctr(struct dm_tar
 		goto err_para;
 	}
 
+skip_optargs:
 	if (dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
 							&info->dev)) {
 		ti->error = "Can't get device";
@@ -1348,6 +1365,28 @@ static int insitu_comp_map(struct dm_tar
 	return DM_MAPIO_SUBMITTED;
 }
 
+static void insitu_comp_postsuspend(struct dm_target *ti)
+{
+	struct insitu_comp_info *info = ti->private;
+	/* all requests are finished already */
+	if (info->write_mode != INSITU_COMP_WRITE_BACK)
+		return;
+	info->wb_thread_suspend_status = WB_THREAD_SUSPENDING;
+	wake_up_process(info->writeback_tsk);
+
+	wait_event_interruptible(info->wb_thread_suspend_wq,
+		info->wb_thread_suspend_status == WB_THREAD_SUSPENDED);
+}
+
+static void insitu_comp_resume(struct dm_target *ti)
+{
+	struct insitu_comp_info *info = ti->private;
+	if (info->write_mode != INSITU_COMP_WRITE_BACK)
+		return;
+	info->wb_thread_suspend_status = WB_THREAD_RESUMED;
+	wake_up_interruptible(&info->wb_thread_suspend_wq);
+}
+
 /*
  * INFO: uncompressed_data_size compressed_data_size metadata_size
  * TABLE: writethrough/writeback commit_delay
@@ -1360,10 +1399,10 @@ static void insitu_comp_status(struct dm
 
 	switch (type) {
 	case STATUSTYPE_INFO:
-		DMEMIT("%lu %lu %lu",
-		       atomic64_read(&info->uncompressed_write_size),
-		       atomic64_read(&info->compressed_write_size),
-		       atomic64_read(&info->meta_write_size));
+		DMEMIT("%llu %llu %llu",
+		    (long long)atomic64_read(&info->uncompressed_write_size),
+		    (long long)atomic64_read(&info->compressed_write_size),
+		    (long long)atomic64_read(&info->meta_write_size));
 		break;
 	case STATUSTYPE_TABLE:
 		if (info->write_mode == INSITU_COMP_WRITE_BACK)
@@ -1407,8 +1446,8 @@ static struct target_type insitu_comp_ta
 	.ctr    = insitu_comp_ctr,
 	.dtr    = insitu_comp_dtr,
 	.map    = insitu_comp_map,
-	// FIXME: no .postsuspend or .preresume or .resume!?
-	// need to flush workqueue at a minimum.  what about commit?  see pool_target or cache_target
+	.postsuspend = insitu_comp_postsuspend,
+	.resume = insitu_comp_resume,
 	.status = insitu_comp_status,
 	.iterate_devices = insitu_comp_iterate_devices,
 	.io_hints = insitu_comp_io_hints,
@@ -1430,14 +1469,19 @@ static int __init insitu_comp_init(void)
 	default_compressor = r;
 
 	r = -ENOMEM;
-	// FIXME: add dm_ prefix to at least these 2 structs so slabs are attributed to dm
-	insitu_comp_io_range_cachep = KMEM_CACHE(insitu_comp_io_range, 0);
+	insitu_comp_io_range_cachep = kmem_cache_create("dm_insitu_comp_io_range",
+		sizeof(struct insitu_comp_io_range),
+		__alignof__(struct insitu_comp_io_range),
+		0, NULL);
 	if (!insitu_comp_io_range_cachep) {
 		DMWARN("Can't create io_range cache");
 		goto err;
 	}
 
-	insitu_comp_meta_io_cachep = KMEM_CACHE(insitu_comp_meta_io, 0);
+	insitu_comp_meta_io_cachep = kmem_cache_create("dm_insitu_comp_meta_io",
+		sizeof(struct insitu_comp_meta_io),
+		__alignof__(struct insitu_comp_meta_io),
+		0, NULL);
 	if (!insitu_comp_meta_io_cachep) {
 		DMWARN("Can't create meta_io cache");
 		goto err;
Index: linux/drivers/md/dm-insitu-comp.h
===================================================================
--- linux.orig/drivers/md/dm-insitu-comp.h	2014-03-17 12:37:37.850751341 +0800
+++ linux/drivers/md/dm-insitu-comp.h	2014-03-17 16:22:24.553201921 +0800
@@ -92,6 +92,8 @@ struct insitu_comp_info {
 	enum INSITU_COMP_WRITE_MODE write_mode;
 	unsigned int writeback_delay; /* second unit */
 	struct task_struct *writeback_tsk;
+	int wb_thread_suspend_status;
+	wait_queue_head_t wb_thread_suspend_wq;
 	struct dm_io_client *io_client;
 
 	atomic64_t compressed_write_size;
@@ -99,6 +101,12 @@ struct insitu_comp_info {
 	atomic64_t meta_write_size;
 };
 
+enum {
+	WB_THREAD_RESUMED = 0,
+	WB_THREAD_SUSPENDING = 1,
+	WB_THREAD_SUSPENDED = 2,
+};
+
 struct insitu_comp_meta_io {
 	struct dm_io_request io_req;
 	struct dm_io_region io_region;
