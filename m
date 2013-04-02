Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856Ab3DBJAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:00:53 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39974
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758800Ab3DBJAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:00:52 -0400
Date: Tue, 2 Apr 2013 11:00:47 +0200
From: Jens Axboe <axboe@kernel.dk>
To: CAI Qian <caiqian@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
Message-ID: <20130402090047.GF3670@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com>
 <247719576.438259.1364882929749.JavaMail.root@redhat.com>
 <20130402070537.GP6369@dastard>
 <20130402071937.GC3670@kernel.dk>
 <20130402073035.GD3670@kernel.dk>
 <14055702.547701.1364891947331.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14055702.547701.1364891947331.JavaMail.root@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02 2013, CAI Qian wrote:
> 
> 
> ----- Original Message -----
> > From: "Jens Axboe" <axboe@kernel.dk>
> > To: "Dave Chinner" <david@fromorbit.com>
> > Cc: "CAI Qian" <caiqian@redhat.com>, xfs@oss.sgi.com, "LKML" <linux-kernel@vger.kernel.org>
> > Sent: Tuesday, April 2, 2013 3:30:35 PM
> > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running xfstests case #78]
> > 
> > On Tue, Apr 02 2013, Jens Axboe wrote:
> > > On Tue, Apr 02 2013, Dave Chinner wrote:
> > > > [Added jens Axboe to CC]
> > > > 
> > > > On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > > > > Saw on almost all the servers range from x64, ppc64 and s390x with
> > > > > kernel
> > > > > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks
> > > > > like
> > > > > something new broke this. Log is here with sysrq debug info.
> > > > > http://people.redhat.com/qcai/stable/log
> > > 
> > > CAI Qian, can you try and back the below out and test again?
> > 
> > Nevermind, it's clearly that one. The below should improve the
> > situation, but it's not pretty. A better fix would be to allow
> > auto-deletion even if PART_NO_SCAN is set.
> Jens, when compiled the mainline (up to fefcdbe) with this patch,
> it error-ed out,

Looks like I sent the wrong one, updated below.

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index fe5f640..faa3afa 100644
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
+		if (mutex_trylock(&bdev->bd_mutex)) {
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

