Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936856Ab3DIDKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 23:10:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934726Ab3DIDKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 23:10:01 -0400
Date: Mon, 8 Apr 2013 20:10:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Nadia Yvette Chambers <nyc@holomorphy.com>, Jiri Kosina <jkosina@suse.cz>,
        Guennadi Liakhovetski <lg@denx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bitmap: speedup in bitmap_find_free_region when
 order is 0
Message-Id: <20130408201001.f4c74887.akpm@linux-foundation.org>
In-Reply-To: <1365475486-14371-1-git-send-email-chanho.min@lge.com>
References: <1365475486-14371-1-git-send-email-chanho.min@lge.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Apr 2013 11:44:46 +0900 Chanho Min <chanho.min@lge.com> wrote:

> If bitmap_find_free_region() is called with order=0, We can reduce
> for-loops to find 1 free bit. First, It scans bitmap array by the
> increment of long type, then find 1 free bit within 1 long type value.
> 
> In 32 bits system and 1024 bits size, in the worst case, We need 1024
> for-loops to find 1 free bit. But, If This is applied, it takes
> 64 for-loops. Instead, if free bit is in the first index of the bitmaps,
> It will be needed additional 1 for-loop. But from second index, It
> will speed up significantly.
> 
> Changes compared to v1:
>  - Modified unnecessarily complicated code.
>  - Fixed the buggy code if `bits' is not an multiple of BITS_PER_LONG.
> 
> ...
>
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -1099,6 +1099,39 @@ done:
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
> +	int pos, end = BITS_PER_LONG, i;
> +	int nlongs_reg = BITS_TO_LONGS(bits);

Still wrong, I think - BITS_TO_LONG() rounds up.

> +	int last_bits = bits % BITS_PER_LONG;
> +
> +	for (i = 0 ; i < nlongs_reg ; i++) {

No space before the semicolon, please.  checkpatch should warn about
this but it seems to be broken.

> +		if (bitmap[i] != ~0UL) {
> +			if (i == (nlongs_reg - 1) && last_bits)
> +				end = last_bits;
> +			for (pos = 0 ; pos < end ; pos++) {
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
> +
> +/**
>   * bitmap_find_free_region - find a contiguous aligned mem region
>   *	@bitmap: array of unsigned longs corresponding to the bitmap
>   *	@bits: number of bits in the bitmap
> @@ -1116,6 +1149,9 @@ int bitmap_find_free_region(unsigned long *bitmap, int bits, int order)
>  {
>  	int pos, end;		/* scans bitmap by regions of size order */
>  
> +	if (order == 0)
> +		return __bitmap_find_free_one(bitmap, bits);
> +
>  	for (pos = 0 ; (end = pos + (1 << order)) <= bits; pos = end) {
>  		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
>  			continue;

It seems excessively complicated to me.  Why not change
bitmap_find_free_region() to skip the leading all-ones words and when
it finds a not-all-ones word, adjust `pos' then fall into the existing
bit-at-a-time search?

In fact we could use the 64-bits-at-a-time search for allocations other
than order-zero:

--- a/lib/bitmap.c~a
+++ a/lib/bitmap.c
@@ -1117,6 +1117,12 @@ int bitmap_find_free_region(unsigned lon
 	int pos, end;		/* scans bitmap by regions of size order */
 
 	for (pos = 0 ; (end = pos + (1 << order)) <= bits; pos = end) {
+		if (pos & (BITS_PER_LONG - 1) == 0) {
+			if (bitmap[pos / BITS_PER_LONG] == ~0UL) {
+				pos += BITS_PER_LONG;
+				continue;
+			}
+		}
 		if (!__reg_op(bitmap, pos, order, REG_OP_ISFREE))
 			continue;
 		__reg_op(bitmap, pos, order, REG_OP_ALLOC);

(that's presumably slow and buggy, but you get the idea ;))

Another obvious inefficiency in bitmap_find_free_region() is that when
it inspects a region at `pos' for 1<<order zero bits and fails to find
them, it resumes the search at pos+1.  Dumb - it should resume
searching at the next-one-bit, rounded up to the next 1<<order.

Obviously nobody tried very hard here - is any poor soul using this
code for large bitmaps?  I guess "yes", as 1024-CPU machines exist.


