Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbbAZQNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:13:35 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:38069 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbbAZQNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:13:32 -0500
Date: Mon, 26 Jan 2015 11:13:28 -0500
From: Tejun Heo <tj@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC] loop: make partition scanning reliable
Message-ID: <20150126161328.GA21242@htj.dyndns.org>
References: <1422267319-8428-1-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422267319-8428-1-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Mon, Jan 26, 2015 at 11:15:19AM +0100, David Herrmann wrote:
> -static int blkdev_reread_part(struct block_device *bdev)
> +int blkdev_reread_part(struct block_device *bdev, int skipbusy)
>  {
>  	struct gendisk *disk = bdev->bd_disk;
>  	int res;
> @@ -159,12 +159,15 @@ static int blkdev_reread_part(struct block_device *bdev)
>  		return -EINVAL;
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EACCES;
> -	if (!mutex_trylock(&bdev->bd_mutex))
> +	if (!skipbusy)
> +		mutex_lock(&bdev->bd_mutex);
> +	else if (!mutex_trylock(&bdev->bd_mutex))
>  		return -EBUSY;

Do we actually need the mutex_trylock() path?  Why can't we just
always grab the mutex?

...
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index 6cb1beb..4047985 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -637,7 +637,7 @@ out:
>   * new backing store is the same size and type as the old backing store.
>   */
>  static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
> -			  unsigned int arg)
> +			  unsigned int arg, int *rrpart)

bool *rrpart would be better but can't we communicate this through the
return value?  Wouldn't that be prettier?

Thanks.

-- 
tejun
