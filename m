Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbaJaNqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:46:13 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34996 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759923AbaJaNqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:46:11 -0400
Date: Fri, 31 Oct 2014 22:46:32 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Minchan Kim'" <minchan@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: avoid kunmap_atomic a NULL pointer
Message-ID: <20141031134632.GA942@swordfish>
References: <000001cff409$bf7bfa50$3e73eef0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001cff409$bf7bfa50$3e73eef0$%yang@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/30/14 14:20), Weijie Yang wrote:
> zram could kunmap_atomic a NULL pointer in a rare situation:
> a zram page become a full-zeroed page after a partial write io.
> The current code doesn't handle this case and kunmap_atomic a
> NULL porinter, which panic the kernel.
> 
> This patch fixes this issue.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

thank you, Weijie.

Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss

> ---
>  drivers/block/zram/zram_drv.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index 2ad0b5b..3920ee4 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -560,7 +560,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
>  	}
>  
>  	if (page_zero_filled(uncmem)) {
> -		kunmap_atomic(user_mem);
> +		if (user_mem)
> +			kunmap_atomic(user_mem);
>  		/* Free memory associated with this sector now. */
>  		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
>  		zram_free_page(zram, index);
> -- 
> 1.7.0.4
> 
> 
