Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaDXCFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 22:05:47 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46361 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaDXCFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 22:05:22 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
Date: Thu, 24 Apr 2014 11:06:32 +0900
From: Minchan Kim <minchan@kernel.org>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>, iamjoonsoo.kim@lge.com,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] zram: correct offset usage in zram_bio_discard
Message-ID: <20140424020632.GA863@bbox>
References: <000001cf5ecf$f4f4f850$dedee8f0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cf5ecf$f4f4f850$dedee8f0$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 23, 2014 at 04:41:15PM +0800, Weijie Yang wrote:
> We want to skip the physical block(PAGE_SIZE) which is partially
> covered by the discard bio, so we check the remaining size and
> subtract it if there is a need to goto the next physical block.
> 
> The current offset usage in zram_bio_discard is incorrect, it will
> cause its upper filesystem breakdown.
> Consider the following scenario:
> on some architecture or config, PAGE_SIZE is 64K for example,
> filesystem is set up on zram disk without PAGE_SIZE aligned,
> a discard bio leads to a offset = 4K and size=72K,
> normally, it should not really discard any physical block as it
> partially cover two physical blocks.
> However, with the current offset usage, it will discard the second
> physical block and free its memory, which will cause filesystem breakdown.
> 
> This patch corrects the offset usage in zram_bio_discard.

Nice catch.
Surely we need fix but I'd like to go further. Let's think.
How do you find that? Real problem or code review?
I'd like to know how much that happens in real practice because if it's
a lot, it means discard support is just an overhead without any benefit.

If you just found it with code review(ie, don't have any data),
would you mind adding some stat like 'num_discard/failed_discard' so
we can keep an eye on that. Although it's for rare case, I think it's worth.
Because someone would do swapon zram with --discard,
it could make same problem due to early page freeing of zram-swap to
avoid duplicating VM-owned memory and ZRAM-owned memory.

We can guide to zram-swap user not to use swapon with --discard but
I don't want it because swap_slot_free_notify is really mess which
violates layering so I hope replace it with discard finally so such
statistics really help us to drive that way more quickly.

> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
> Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>  drivers/block/zram/zram_drv.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 9849b52..48eccb3 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -572,10 +572,10 @@ static void zram_bio_discard(struct zram *zram, u32 index,
>  	 * skipping this logical block is appropriate here.
>  	 */
>  	if (offset) {
> -		if (n < offset)
> +		if (n <= (PAGE_SIZE - offset))
>  			return;
>  
> -		n -= offset;
> +		n -= (PAGE_SIZE - offset);
>  		index++;
>  	}
>  
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
