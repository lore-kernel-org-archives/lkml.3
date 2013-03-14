Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab3CNWHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:07:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3CNWHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:07:11 -0400
Date: Thu, 14 Mar 2013 15:07:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Phillip Susi <psusi@ubuntu.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: cleanup partitions when detaching loop device
Message-Id: <20130314150709.056aa4de5fadf3a5e94103d4@linux-foundation.org>
In-Reply-To: <1362336553-16880-1-git-send-email-psusi@ubuntu.com>
References: <1362336553-16880-1-git-send-email-psusi@ubuntu.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  3 Mar 2013 13:49:13 -0500 Phillip Susi <psusi@ubuntu.com> wrote:

> Any partitions added by user space to the loop device were being
> left in place after detaching the loop device.  This was because
> the detach path issued a BLKRRPART to clean up partitions if
> LO_FLAGS_PARTSCAN was set, meaning that the partitions were auto
> scanned on attach.  Replace this BLKRRPART with code that
> unconditionally cleans up partitions on detach instead.

huh.  What is the user-visible effect of this bug?  Just a memory leak
or something more serious?

If "something more serious", why did this problem remain hidden for so
long?

> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -1039,12 +1039,24 @@ static int loop_clr_fd(struct loop_device *lo)
>  	lo->lo_state = Lo_unbound;
>  	/* This is safe: open() is still holding a reference. */
>  	module_put(THIS_MODULE);
> -	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
> -		ioctl_by_bdev(bdev, BLKRRPART, 0);
>  	lo->lo_flags = 0;
>  	if (!part_shift)
>  		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
>  	mutex_unlock(&lo->lo_ctl_mutex);
> +	if (bdev)
> +	{

scripts/checkpatch.pl is your friend.

Can you please suggest a code comment which we can slip in here to tell
readers what's going on and why we're doing this?

> +		struct disk_part_iter piter;
> +		struct hd_struct *part;
> +
> +		mutex_lock_nested(&bdev->bd_mutex, 1);
> +		invalidate_partition(bdev->bd_disk, 0);
> +		disk_part_iter_init(&piter, bdev->bd_disk, DISK_PITER_INCL_EMPTY);
> +		while ((part = disk_part_iter_next(&piter)))
> +			delete_partition(bdev->bd_disk, part->partno);
> +		disk_part_iter_exit(&piter);
> +		mutex_unlock(&bdev->bd_mutex);
> +	}

