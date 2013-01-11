Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3AKO0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:26:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39308 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3AKO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:26:42 -0500
Message-ID: <50F0211D.7040209@kernel.dk>
Date: Fri, 11 Jan 2013 15:26:37 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: majianpeng <majianpeng@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com >> Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: [PATCH] blkcg: Before starting a new slice, firstly count bps/iops
 limit in func tg_may_dispatch.
References: <201301111711251317275@gmail.com>
In-Reply-To: <201301111711251317275@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-11 10:11, majianpeng wrote:
> In func tg_may_dispatch,
>> if (throtl_slice_used(td, tg, rw))
>> 		throtl_start_new_slice(td, tg, rw);
> ...
>> if (tg_with_in_bps_limit(td, tg, bio, &bps_wait)
>> 	    && tg_with_in_iops_limit(td, tg, bio, &iops_wait)) {
> 
> In funcs tg_with_in_(bps/iops)_limit, it used the slice_start to count.
> So if privious slice expired, it start a new slice.This can cause hung
> task.
> 
> The next steps can repeat this bug.
> 1:echo "8:48 10240" > blkio.throttle.write_bps_devic
> 2:dd if=/dev/zero of=/dev/sdd bs=1M count=1 oflag=direct
> 
> Using the blktrace, the messages about throttle:
> root@kernel:/mnt/programs# blktrace -d /dev/sdd -a notify -o -|blkparse -i -
>   8,48   1        0     0.000000000     0  m   N throtl / [W] new slice start=4294854679 end=4294854779 jiffies=4294854679
>   8,48   1        0     0.000000966     0  m   N throtl / [W] extend slice start=4294854679 end=4294905900 jiffies=4294854679
>   8,48   1        0     0.000002553     0  m   N throtl / [W] bio. bdisp=0 sz=524288 bps=10240 iodisp=0 iops=4294967295 queued=0/0
>   8,48   1        0     0.000004788     0  m   N throtl schedule work. delay=51200 jiffies=4294854679
>   8,48   1        0    51.304698681     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>   8,48   1        0    51.304701979     0  m   N throtl / [W] new slice start=4294905984 end=4294906084 jiffies=4294905984
>   8,48   1        0    51.304703329     0  m   N throtl / [W] extend slice start=4294905984 end=4294957200 jiffies=4294905984
>   8,48   1        0    51.304705783     0  m   N throtl schedule work. delay=51200 jiffies=4294905984
>   8,48   1        0   102.632697082     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>   8,48   1        0   102.632700544     0  m   N throtl / [W] new slice start=4294957312 end=4294957412 jiffies=4294957312
>   8,48   1        0   102.632701922     0  m   N throtl / [W] extend slice start=4294957312 end=4295008600 jiffies=4294957312
>   8,48   1        0   102.632704016     0  m   N throtl schedule work. delay=51200 jiffies=4294957312
>   8,48   1        0   153.960696503     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>   8,48   1        0   153.960699797     0  m   N throtl / [W] new slice start=4295008640 end=4295008740 jiffies=4295008640
>   8,48   1        0   153.960701153     0  m   N throtl / [W] extend slice start=4295008640 end=4295059900 jiffies=4295008640
>   8,48   1        0   153.960703218     0  m   N throtl schedule work. delay=51200 jiffies=4295008640
>   8,48   1        0   205.288697067     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>   8,48   1        0   205.288700268     0  m   N throtl / [W] new slice start=4295059968 end=4295060068 jiffies=4295059968
>   8,48   1        0   205.288701630     0  m   N throtl / [W] extend slice start=4295059968 end=4295111200 jiffies=4295059968
>   8,48   1        0   205.288703784     0  m   N throtl schedule work. delay=51200 jiffies=4295059968
>   8,48   1        0   256.616696184     0  m   N throtl dispatch nr_queued=1 read=0 write=1
>   8,48   1        0   256.616699266     0  m   N throtl / [W] new slice start=4295111296 end=4295111396 jiffies=4295111296
>   8,48   1        0   256.616700574     0  m   N throtl / [W] extend slice start=4295111296 end=4295162500 jiffies=4295111296
>   8,48   1        0   256.616702701     0  m   N throtl schedule work. delay=51200 jiffies=4295111296
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  block/blk-throttle.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 3114622..9258789 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -645,6 +645,15 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
>  	}
>  
>  	/*
> +	 * If privious slice expired,then start new slice.
> +	 * But counting bps and iops limit need privious slice info
> +	 * which ->slice_start.
> +	 */
> +	if (tg_with_in_bps_limit(td, tg, bio, &bps_wait)
> +	    && tg_with_in_iops_limit(td, tg, bio, &iops_wait))
> +		if (wait)
> +			*wait = 0;
> +	/*
>  	 * If previous slice expired, start a new one otherwise renew/extend
>  	 * existing slice to make sure it is at least throtl_slice interval
>  	 * long since now.
> @@ -656,12 +665,8 @@ static bool tg_may_dispatch(struct throtl_data *td, struct throtl_grp *tg,
>  			throtl_extend_slice(td, tg, rw, jiffies + throtl_slice);
>  	}
>  
> -	if (tg_with_in_bps_limit(td, tg, bio, &bps_wait)
> -	    && tg_with_in_iops_limit(td, tg, bio, &iops_wait)) {
> -		if (wait)
> -			*wait = 0;
> +	if (!(bps_wait || iops_wait))
>  		return 1;
> -	}
>  
>  	max_wait = max(bps_wait, iops_wait);

Looks pretty sane to me. Vivek?

-- 
Jens Axboe

