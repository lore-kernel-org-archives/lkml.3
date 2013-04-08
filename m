Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936377Ab3DHVam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:30:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936268Ab3DHVai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:30:38 -0400
Date: Mon, 8 Apr 2013 14:30:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>, Jiri Kosina <jkosina@suse.cz>,
        Guennadi Liakhovetski <lg@denx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitmap: speedup in bitmap_find_free_region when order
 is 0
Message-Id: <20130408143037.5fe18306172315fc040329de@linux-foundation.org>
In-Reply-To: <1365387828-24326-1-git-send-email-chanho.min@lge.com>
References: <1365387828-24326-1-git-send-email-chanho.min@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  8 Apr 2013 11:23:48 +0900 Chanho Min <chanho.min@lge.com> wrote:

> If bitmap_find_free_region() is called with order=0, We can reduce
> for-loops to find 1 free bit. First, It scans bitmap array by the
> increment of long type, then find 1 free bit within 1 long type value.

That seems sensible.  I assume-without-checking that single-bit is a
common case?

> In 32 bits system and 1024 bits size, in the worst case, We need 1024
> for-loops to find 1 free bit. But, If This is applied, it takes
> 64 for-loops. Instead, if free bit is in the first index of the bitmaps,
> It will be needed additional 1 for-loop. But from second index, It
> will be speed up significantly.
> 
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -1099,6 +1099,37 @@ done:
>  }
>  
>  /**
> + * bitmap_find_free_one - find a mem region
> + *	@bitmap: array of unsigned longs corresponding to the bitmap
> + *	@bits: number of bits in the bitmap
> + *
> + * Find one of free (zero) bits in a @bitmap of @bits bits and
> + * allocate them (set them to one).
> + *
> + * Return the bit offset in bitmap of the allocated region,
> + * or -errno on failure.
> + */
> +static int __bitmap_find_free_one(unsigned long *bitmap, int bits)
> +{
> +	int pos, i;
> +	unsigned long mask = (unsigned long)(~((unsigned long) 0));

That seems unnecessarily complicated.  "unsigned long mask = -1;" works :)

> +	int nlongs_reg = BITS_TO_LONGS(bits);
> +
> +	for (i = 0 ; i < nlongs_reg ; i++) {
> +		if ((bitmap[i] & mask) != mask) {

But here we could just do "if (bitmap[i] != -1)".  Or ~0UL.

> +			for (pos = 0 ; pos < BITS_PER_LONG ; pos++) {
> +				if (!__reg_op(&bitmap[i], pos, 0,
> +					REG_OP_ISFREE))
> +					continue;
> +				__reg_op(&bitmap[i], pos, 0, REG_OP_ALLOC);
> +				return pos;
> +			}
> +		}
> +	}
> +	return -ENOMEM;
> +}

afacit the code is buggy - if `bits' is not an exact multiple of
BITS_PER_LONG, this search will wander off the end of the specified
region?

> +/**
>   * bitmap_find_free_region - find a contiguous aligned mem region
>   *	@bitmap: array of unsigned longs corresponding to the bitmap
>   *	@bits: number of bits in the bitmap
> @@ -1116,6 +1147,9 @@ int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
>  {
>  	int pos, end;		/* scans bitmap by regions of size order */
>  
> +	if (order == 0)
> +		return __bitmap_find_free_one(bitmap, bits);
> +
>  	for (pos = 0 ; (end = pos + (1 << order)) <= bits; pos = end) {
>  		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
>  			continue;

