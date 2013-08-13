Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3HMLHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 07:07:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56497 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab3HMLHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 07:07:32 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Thomas Backlund <tmb@mageia.org>
Cc: Jordi Pujol <jordipujolp@gmail.com>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: ZRAM 3.10.6 Buffer I/O error
References: <1998314.O9XRMyhM6u@pcjordi> <52090FD2.9030702@mageia.org>
Date: Tue, 13 Aug 2013 12:07:27 +0100
In-Reply-To: <52090FD2.9030702@mageia.org> (Thomas Backlund's message of "Mon,
	12 Aug 2013 19:39:46 +0300")
Message-ID: <87txitc0i8.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Backlund <tmb@mageia.org> writes:

> 12.08.2013 17:27, Jordi Pujol skrev:
>> Hello,
>>
>> zram shows an error when mounting a swap partition,
>> current version Linux kernel 3.10.6,
>> previous versions worked, I suppose that latest zram patches have some
>> problem,
>>
>> machine is an AMD64 dual core, 4GB RAM
>>
>> + modprobe -qb zram num_devices=2
>> + echo 104857600 > /sys/block/zram0/disksize
>>
>> # mkswap /dev/zram0
>> Setting up swapspace version 1, size = 102396 KiB
>> no label, UUID=6c249930-2ba0-46cf-a8c6-766481942b7d
>>
>> # pager /var/log/dmesg
>> (no more errors shown)
>>
>> # swapon /dev/zram0
>>
>> # pager /var/log/dmesg
>> ...
>> [  309.300479] Buffer I/O error on device zram0, logical block 25599
>> [  309.300491] Buffer I/O error on device zram0, logical block 25599
>> [  309.300514] Buffer I/O error on device zram0, logical block 25599
>> [  345.205887] Adding 102396k swap on /dev/zram0.  Priority:-2 extents:1
>> across:102396k SSFS
>>
>> full log files and the kernel source are stored in the address:
>>
>> http://livenet.selfip.com/ftp/debian/zram_3.10.6_IO_error/
>>
>
>
> I think this one should fix it and belongs in 3.10 stable too:
>
> From 75c7caf5a052ffd8db3312fa7864ee2d142890c4 Mon Sep 17 00:00:00 2001
> From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date: Sat, 22 Jun 2013 14:21:00 +0000
> Subject: zram: allow request end to coincide with disksize
>
> Pass valid_io_request() checks if request end coincides with disksize
> (end equals bound), only fail if we attempt to read beyond the bound.
>
> mkfs.ext2 produces numerous errors:
> [ 2164.632747] quiet_error: 1 callbacks suppressed
> [ 2164.633260] Buffer I/O error on device zram0, logical block 153599
> [ 2164.633265] lost page write due to I/O error on zram0
>
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
> index 7538774..82c7202 100644
> --- a/drivers/staging/zram/zram_drv.c
> +++ b/drivers/staging/zram/zram_drv.c
> @@ -180,7 +180,7 @@ static inline int valid_io_request(struct zram *zram, struct
> bio *bio)
>  	end = start + (bio->bi_size >> SECTOR_SHIFT);
>  	bound = zram->disksize >> SECTOR_SHIFT;
>  	/* out of range range */
> -	if (unlikely(start >= bound || end >= bound || start > end))
> +	if (unlikely(start >= bound || end > bound || start > end))
>  		return 0;
>
>  	/* I/O request is valid */
> --
> cgit v0.9.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I believe this patch should be applied to other stable trees that also
contain commit 12a7ad3b810e77137d0caf97a6dd97591e075b30 ("zram: avoid
access beyond the zram device").  I'm queuing it for the 3.5 kernel.

Cheers,
-- 
Luis
