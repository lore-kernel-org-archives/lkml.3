Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab3DBJsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:48:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60365 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab3DBJsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:48:38 -0400
Date: Tue, 2 Apr 2013 11:48:34 +0200
From: Jens Axboe <axboe@kernel.dk>
To: CAI Qian <caiqian@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        LKML <linux-kernel@vger.kernel.org>, psusi@ubuntu.com
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
Message-ID: <20130402094834.GA4667@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
 <247719576.438259.1364882929749.JavaMail.root@redhat.com>
 <20130402070537.GP6369@dastard>
 <20130402071937.GC3670@kernel.dk>
 <20130402073035.GD3670@kernel.dk>
 <14055702.547701.1364891947331.JavaMail.root@redhat.com>
 <20130402090047.GF3670@kernel.dk>
 <985125161.581860.1364895066584.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <985125161.581860.1364895066584.JavaMail.root@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02 2013, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Jens Axboe" <axboe@kernel.dk>
> > To: "CAI Qian" <caiqian@redhat.com>
> > Cc: "Dave Chinner" <david@fromorbit.com>, xfs@oss.sgi.com, "LKML" <linux-kernel@vger.kernel.org>
> > Sent: Tuesday, April 2, 2013 5:00:47 PM
> > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running xfstests case #78]
> > 
> > On Tue, Apr 02 2013, CAI Qian wrote:
> > > 
> > > 
> > > ----- Original Message -----
> > > > From: "Jens Axboe" <axboe@kernel.dk>
> > > > To: "Dave Chinner" <david@fromorbit.com>
> > > > Cc: "CAI Qian" <caiqian@redhat.com>, xfs@oss.sgi.com, "LKML"
> > > > <linux-kernel@vger.kernel.org>
> > > > Sent: Tuesday, April 2, 2013 3:30:35 PM
> > > > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5
> > > > running xfstests case #78]
> > > > 
> > > > On Tue, Apr 02 2013, Jens Axboe wrote:
> > > > > On Tue, Apr 02 2013, Dave Chinner wrote:
> > > > > > [Added jens Axboe to CC]
> > > > > > 
> > > > > > On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > > > > > > Saw on almost all the servers range from x64, ppc64 and s390x with
> > > > > > > kernel
> > > > > > > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks
> > > > > > > like
> > > > > > > something new broke this. Log is here with sysrq debug info.
> > > > > > > http://people.redhat.com/qcai/stable/log
> > > > > 
> > > > > CAI Qian, can you try and back the below out and test again?
> > > > 
> > > > Nevermind, it's clearly that one. The below should improve the
> > > > situation, but it's not pretty. A better fix would be to allow
> > > > auto-deletion even if PART_NO_SCAN is set.
> > > Jens, when compiled the mainline (up to fefcdbe) with this patch,
> > > it error-ed out,
> > 
> > Looks like I sent the wrong one, updated below.
> The patch works well. Thanks!

Thanks for testing! I don't particularly like this stuff in loop,
though. It's quite nasty and depends on other behaviour. It would be
prettier if we just had rescan_partitions() do the right thing, and only
drop partitions and not rescan if NO_PART_SCAN is set.

Ala the below, dropping the loop change and implementing that change in
the core code. Phillip, can you check whether this does the right thing
for your bug too?

diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..8b78b5a 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -155,7 +155,7 @@ static int blkdev_reread_part(struct block_device *bdev)
 	struct gendisk *disk = bdev->bd_disk;
 	int res;
 
-	if (!disk_part_scan_enabled(disk) || bdev != bdev->bd_contains)
+	if (bdev != bdev->bd_contains)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
diff --git a/block/partition-generic.c b/block/partition-generic.c
index ae95ee6..bf4bb60 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -431,6 +431,15 @@ rescan:
 		disk->fops->revalidate_disk(disk);
 	check_disk_size_change(disk, bdev);
 	bdev->bd_invalidated = 0;
+
+	/*
+	 * If partition scanning is disabled, we are done.
+	 */
+	if (!disk_part_scan_enabled(disk)) {
+		kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
+		return 0;
+	}
+
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	if (IS_ERR(state)) {
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 2c127f9..8b6df76 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1057,24 +1057,6 @@ static int loop_clr_fd(struct loop_device *lo)
 	mutex_unlock(&lo->lo_ctl_mutex);
 
 	/*
-	 * Remove all partitions, since BLKRRPART won't remove user
-	 * added partitions when max_part=0
-	 */
-	if (bdev) {
-		struct disk_part_iter piter;
-		struct hd_struct *part;
-
-		mutex_lock_nested(&bdev->bd_mutex, 1);
-		invalidate_partition(bdev->bd_disk, 0);
-		disk_part_iter_init(&piter, bdev->bd_disk,
-					DISK_PITER_INCL_EMPTY);
-		while ((part = disk_part_iter_next(&piter)))
-			delete_partition(bdev->bd_disk, part->partno);
-		disk_part_iter_exit(&piter);
-		mutex_unlock(&bdev->bd_mutex);
-	}
-
-	/*
 	 * Need not hold lo_ctl_mutex to fput backing file.
 	 * Calling fput holding lo_ctl_mutex triggers a circular
 	 * lock dependency possibility warning as fput can take

-- 
Jens Axboe

