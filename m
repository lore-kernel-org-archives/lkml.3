Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761260Ab3DBJbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:31:13 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:58480 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760918Ab3DBJbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:31:09 -0400
Date: Tue, 2 Apr 2013 05:31:06 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <985125161.581860.1364895066584.JavaMail.root@redhat.com>
In-Reply-To: <20130402090047.GF3670@kernel.dk>
References: <1462091996.435156.1364882416199.JavaMail.root@redhat.com> <247719576.438259.1364882929749.JavaMail.root@redhat.com> <20130402070537.GP6369@dastard> <20130402071937.GC3670@kernel.dk> <20130402073035.GD3670@kernel.dk> <14055702.547701.1364891947331.JavaMail.root@redhat.com> <20130402090047.GF3670@kernel.dk>
Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running
 xfstests case #78]
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.11]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF19 (Linux)/8.0.3_GA_5664)
Thread-Topic: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running xfstests case #78]
Thread-Index: VFaXVt88xXrJyY97wdDxyGpExk9LwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: "Jens Axboe" <axboe@kernel.dk>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "Dave Chinner" <david@fromorbit.com>, xfs@oss.sgi.com, "LKML" <linux-kernel@vger.kernel.org>
> Sent: Tuesday, April 2, 2013 5:00:47 PM
> Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5 running xfstests case #78]
> 
> On Tue, Apr 02 2013, CAI Qian wrote:
> > 
> > 
> > ----- Original Message -----
> > > From: "Jens Axboe" <axboe@kernel.dk>
> > > To: "Dave Chinner" <david@fromorbit.com>
> > > Cc: "CAI Qian" <caiqian@redhat.com>, xfs@oss.sgi.com, "LKML"
> > > <linux-kernel@vger.kernel.org>
> > > Sent: Tuesday, April 2, 2013 3:30:35 PM
> > > Subject: Re: Loopback device hung [was Re: xfs deadlock on 3.9-rc5
> > > running xfstests case #78]
> > > 
> > > On Tue, Apr 02 2013, Jens Axboe wrote:
> > > > On Tue, Apr 02 2013, Dave Chinner wrote:
> > > > > [Added jens Axboe to CC]
> > > > > 
> > > > > On Tue, Apr 02, 2013 at 02:08:49AM -0400, CAI Qian wrote:
> > > > > > Saw on almost all the servers range from x64, ppc64 and s390x with
> > > > > > kernel
> > > > > > 3.9-rc5 and xfsprogs-3.1.10. Never caught this in 3.9-rc4, so looks
> > > > > > like
> > > > > > something new broke this. Log is here with sysrq debug info.
> > > > > > http://people.redhat.com/qcai/stable/log
> > > > 
> > > > CAI Qian, can you try and back the below out and test again?
> > > 
> > > Nevermind, it's clearly that one. The below should improve the
> > > situation, but it's not pretty. A better fix would be to allow
> > > auto-deletion even if PART_NO_SCAN is set.
> > Jens, when compiled the mainline (up to fefcdbe) with this patch,
> > it error-ed out,
> 
> Looks like I sent the wrong one, updated below.
The patch works well. Thanks!
CAI Qian
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index fe5f640..faa3afa 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1057,14 +1057,15 @@ static int loop_clr_fd(struct loop_device *lo)
>  		struct disk_part_iter piter;
>  		struct hd_struct *part;
>  
> -		mutex_lock_nested(&bdev->bd_mutex, 1);
> -		invalidate_partition(bdev->bd_disk, 0);
> -		disk_part_iter_init(&piter, bdev->bd_disk,
> -					DISK_PITER_INCL_EMPTY);
> -		while ((part = disk_part_iter_next(&piter)))
> -			delete_partition(bdev->bd_disk, part->partno);
> -		disk_part_iter_exit(&piter);
> -		mutex_unlock(&bdev->bd_mutex);
> +		if (mutex_trylock(&bdev->bd_mutex)) {
> +			invalidate_partition(bdev->bd_disk, 0);
> +			disk_part_iter_init(&piter, bdev->bd_disk,
> +						DISK_PITER_INCL_EMPTY);
> +			while ((part = disk_part_iter_next(&piter)))
> +				delete_partition(bdev->bd_disk, part->partno);
> +			disk_part_iter_exit(&piter);
> +			mutex_unlock(&bdev->bd_mutex);
> +		}
>  	}
>  
>  	/*
> 
> --
> Jens Axboe
> 
> 
