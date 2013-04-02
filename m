Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955Ab3DBHan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:30:43 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39702
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759023Ab3DBHam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:30:42 -0400
Date: Tue, 2 Apr 2013 09:30:35 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: CAI Qian <caiqian@redhat.com>, xfs@oss.sgi.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
Message-ID: <20130402073035.GD3670@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
 <247719576.438259.1364882929749.JavaMail.root@redhat.com>
 <20130402070537.GP6369@dastard>
 <20130402071937.GC3670@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402071937.GC3670@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02 2013, Jens Axboe wrote:
> On Tue, Apr 02 2013, Dave Chinner wrote:
> > [Added jens Axboe to CC]
> > 
> > On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > > Saw on almost all the servers range from x64, ppc64 and s390x with kernel
> > > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks like
> > > something new broke this. Log is here with sysrq debug info.
> > > http://people.redhat.com/qcai/stable/log
> 
> CAI Qian, can you try and back the below out and test again?

Nevermind, it's clearly that one. The below should improve the
situation, but it's not pretty. A better fix would be to allow
auto-deletion even if PART_NO_SCAN is set.

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index fe5f640..d6c5764 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1057,14 +1057,15 @@ static int loop_clr_fd(struct loop_device *lo)
 		struct disk_part_iter piter;
 		struct hd_struct *part;
 
-		mutex_lock_nested(&bdev->bd_mutex, 1);
-		invalidate_partition(bdev->bd_disk, 0);
-		disk_part_iter_init(&piter, bdev->bd_disk,
-					DISK_PITER_INCL_EMPTY);
-		while ((part = disk_part_iter_next(&piter)))
-			delete_partition(bdev->bd_disk, part->partno);
-		disk_part_iter_exit(&piter);
-		mutex_unlock(&bdev->bd_mutex);
+		if (mutex_trylock(&bdev->bd_mutex, 1))
+			invalidate_partition(bdev->bd_disk, 0);
+			disk_part_iter_init(&piter, bdev->bd_disk,
+						DISK_PITER_INCL_EMPTY);
+			while ((part = disk_part_iter_next(&piter)))
+				delete_partition(bdev->bd_disk, part->partno);
+			disk_part_iter_exit(&piter);
+			mutex_unlock(&bdev->bd_mutex);
+		}
 	}
 
 	/*

-- 
Jens Axboe

