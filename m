Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450Ab3DBHTo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:19:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57660 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3DBHTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:19:43 -0400
Date: Tue, 2 Apr 2013 09:19:37 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
Message-ID: <20130402071937.GC3670@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
 <247719576.438259.1364882929749.JavaMail.root@redhat.com>
 <20130402070537.GP6369@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402070537.GP6369@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02 2013, Dave Chinner wrote:
> [Added jens Axboe to CC]
> 
> On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > Saw on almost all the servers range from x64, ppc64 and s390x with kernel
> > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks like
> > something new broke this. Log is here with sysrq debug info.
> > http://people.redhat.com/qcai/stable/log

CAI Qian, can you try and back the below out and test again?


commit 8761a3dc1f07b163414e2215a2cadbb4cfe2a107
Author: Phillip Susi <psusi@ubuntu.com>
Date:   Fri Mar 22 12:21:53 2013 -0600

    loop: cleanup partitions when detaching loop device
    
    Any partitions added by user space to the loop device were being
    left in place after detaching the loop device.  This was because
    the detach path issued a BLKRRPART to clean up partitions if
    LO_FLAGS_PARTSCAN was set, meaning that the partitions were auto
    scanned on attach.  Replace this BLKRRPART with code that
    unconditionally cleans up partitions on detach instead.
    
    Signed-off-by: Phillip Susi <psusi@ubuntu.com>
    
    Modified by Jens to export delete_partition().
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/block/partition-generic.c b/block/partition-generic.c
index 789cdea..ae95ee6 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -257,6 +257,7 @@ void delete_partition(struct gendisk *disk, int partno)
 
 	hd_struct_put(part);
 }
+EXPORT_SYMBOL(delete_partition);
 
 static ssize_t whole_disk_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ee13a82..fe5f640 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1044,12 +1044,29 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
-		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	lo->lo_flags = 0;
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
 	mutex_unlock(&lo->lo_ctl_mutex);
+
+	/*
+	 * Remove all partitions, since BLKRRPART won't remove user
+	 * added partitions when max_part=0
+	 */
+	if (bdev) {
+		struct disk_part_iter piter;
+		struct hd_struct *part;
+
+		mutex_lock_nested(&bdev->bd_mutex, 1);
+		invalidate_partition(bdev->bd_disk, 0);
+		disk_part_iter_init(&piter, bdev->bd_disk,
+					DISK_PITER_INCL_EMPTY);
+		while ((part = disk_part_iter_next(&piter)))
+			delete_partition(bdev->bd_disk, part->partno);
+		disk_part_iter_exit(&piter);
+		mutex_unlock(&bdev->bd_mutex);
+	}
+
 	/*
 	 * Need not hold lo_ctl_mutex to fput backing file.
 	 * Calling fput holding lo_ctl_mutex triggers a circular

-- 
Jens Axboe

