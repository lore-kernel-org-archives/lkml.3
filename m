Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbbAVMry (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 07:47:54 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:52745 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbbAVMrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:47:52 -0500
Message-ID: <54C0F175.7010502@plexistor.com>
Date: Thu, 22 Jan 2015 14:47:49 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
CC: Tony Luck <tony.luck@gmail.com>, Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: Remove annoying "unknown partition table" message
References: <54AD5893.9040701@plexistor.com> <54AD59DC.4020703@plexistor.com> <CA+8MBbJbKwyJJoFy2uyNvR5La3hFac-pSh8mZBV=BnNJzKQMhg@mail.gmail.com> <54B99591.7080007@fb.com> <54BBB048.7010207@plexistor.com> <20150118151059.GA17263@infradead.org> <54BBD225.3080200@plexistor.com> <54BBD5D7.6000802@plexistor.com> <54BECD89.7030404@fb.com> <54C0EF78.4030203@plexistor.com>
In-Reply-To: <54C0EF78.4030203@plexistor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 02:39 PM, Boaz Harrosh wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
> 
> As Christoph put it:
>   Can we just get rid of the warnings?  It's fairly annoying as devices
>   without partitions are perfectly fine and very useful.
> 
> Me too I see this message every VM boot for ages on all my
> devices. Would love to just remove it. For me a partition-table
> is only needed for a booting BIOS, grub, and stuff.
> 
> CC: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>

Jens Hi

Sorry for the delay, was unavailable from beginning of the week.

I have tested this. The message no longer shows.

I also hacked to return -EIO if sector ZERO is read, and
the "unable to read partition table" will show, (as well as 16
other messages complaining at other places). So I guess it is
test.

Thanks
Boaz

> ---
>  block/partitions/check.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/block/partitions/check.c b/block/partitions/check.c
> index 9ac1df7..16118d1 100644
> --- a/block/partitions/check.c
> +++ b/block/partitions/check.c
> @@ -184,12 +184,12 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
>  	if (err)
>  	/* The partition is unrecognized. So report I/O errors if there were any */
>  		res = err;
> -	if (!res)
> -		strlcat(state->pp_buf, " unknown partition table\n", PAGE_SIZE);
> -	else if (warn_no_part)
> -		strlcat(state->pp_buf, " unable to read partition table\n", PAGE_SIZE);
> -
> -	printk(KERN_INFO "%s", state->pp_buf);
> +	if (res) {
> +		if (warn_no_part)
> +			strlcat(state->pp_buf,
> +				" unable to read partition table\n", PAGE_SIZE);
> +		printk(KERN_INFO "%s", state->pp_buf);
> +	}
>  
>  	free_page((unsigned long)state->pp_buf);
>  	free_partitions(state);
> 

