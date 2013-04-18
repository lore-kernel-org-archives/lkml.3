Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965272Ab3DRNgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:36:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46510 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935032Ab3DRNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:36:01 -0400
Date: Thu, 18 Apr 2013 06:35:46 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        namhyung@gmail.com, agk@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG REPORT] Kernel panic on 3.9.0-rc7-4-gbb33db7
Message-ID: <20130418133546.GX4816@kernel.dk>
References: <516E5EF8.9090507@cn.fujitsu.com>
 <1366209997.8817.12.camel@pippen.local.home>
 <20130418123738.GV4816@kernel.dk>
 <516FED09.1040008@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516FED09.1040008@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18 2013, Wanlong Gao wrote:
> > A bio is always fully initialized, regardless of which internal
> > allocator it came from. If people are doing private kmallocs, then they
> > better be using bio_init() as well.
> > 
> > Wanlong, would it be possible to get a full dmesg on boot see I can see
> > what drivers and file systems are in use? Anything special about your
> > setup.
> 
> Sure, attached.

Does the below help?


diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 9e5b8c2..f9a51a6 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -780,15 +780,23 @@ static void blk_add_trace_bio_bounce(void *ignore,
 	blk_add_trace_bio(q, bio, BLK_TA_BOUNCE, 0);
 }
 
+static struct request_queue *blk_trace_get_queue(struct block_device *bdev)
+{
+	if (bdev->bd_disk == NULL)
+		return NULL;
+
+	return bdev_get_queue(bdev);
+}
+
 static void blk_add_trace_bio_complete(void *ignore, struct bio *bio, int error)
 {
 	struct request_queue *q;
 	struct blk_trace *bt;
 
-	if (!bio->bi_bdev)
+	q = blk_trace_get_queue(bio->bi_bdev);
+	if (!q)
 		return;
 
-	q = bdev_get_queue(bio->bi_bdev);
 	bt = q->blk_trace;
 
 	/*
@@ -1641,14 +1649,6 @@ static ssize_t blk_trace_mask2str(char *buf, int mask)
 	return p - buf;
 }
 
-static struct request_queue *blk_trace_get_queue(struct block_device *bdev)
-{
-	if (bdev->bd_disk == NULL)
-		return NULL;
-
-	return bdev_get_queue(bdev);
-}
-
 static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)

-- 
Jens Axboe

