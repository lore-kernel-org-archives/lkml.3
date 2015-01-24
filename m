Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbbAXApx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:45:53 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:47776 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbbAXApv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:45:51 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org, heukelum@mailshack.com,
        mita@miraclelinux.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: find_*_bit reimplementation
Organization: D03
References: <1421702706-10404-1-git-send-email-yury.norov@gmail.com>
X-Hashcash: 1:20:150124:heukelum@mailshack.com::d1oVTWF07461FfG7:00000000000000000000000000000000000000009D5
X-Hashcash: 1:20:150124:yury.norov@gmail.com::ls3vb2Wkm2BK0FUr:000000000000000000000000000000000000000002VJS
X-Hashcash: 1:20:150124:mita@miraclelinux.com::RsRAZDMh8Z5i2K8g:00000000000000000000000000000000000000002k9E
X-Hashcash: 1:20:150124:linux-kernel@vger.kernel.org::V4zpLMW835U6G8Iy:000000000000000000000000000000000FeHd
Date: Sat, 24 Jan 2015 01:45:45 +0100
In-Reply-To: <1421702706-10404-1-git-send-email-yury.norov@gmail.com> (Yury
	Norov's message of "Tue, 20 Jan 2015 00:25:06 +0300")
Message-ID: <87y4otknuu.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19 2015, Yury Norov <yury.norov@gmail.com> wrote:

> New implementation takes less space, and, I hope, easier to understand.
>
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  lib/find_next_bit.c | 265 +++++++++++++++-------------------------------------
>  1 file changed, 73 insertions(+), 192 deletions(-)
>

That diffstat is certainly nice. Do you also have numbers for the
size of the generated code, and do you know if there is a
measurable performance difference? Have you tested whether the new and
old code give the same results, also in corner cases?

Some remarks inline below.

> diff --git a/lib/find_next_bit.c b/lib/find_next_bit.c
> index 0cbfc0b..a5c915f 100644
> --- a/lib/find_next_bit.c
> +++ b/lib/find_next_bit.c
> @@ -11,10 +11,39 @@
>  
>  #include <linux/bitops.h>
>  #include <linux/export.h>
> +#include <linux/kernel.h>
>  #include <asm/types.h>
>  #include <asm/byteorder.h>
>  
> -#define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
> +#define HIGH_BITS_MASK(nr)		(ULONG_MAX << (nr))
> +#define MIN(a, b)			((a) < (b) ? (a) : (b))
> +

Please don't duplicate min/max macros. kernel.h already provides everything you need.

> +#if !defined(find_next_bit) || !defined(find_next_zero_bit)
> +static unsigned long _find_next_bit(const unsigned long *addr,
> +		unsigned long end, unsigned long start, unsigned long flags)

Having two parameters called end and start appearing in that
order is slightly confusing. Why not keep the name 'size' for
end, or maybe 'nbits' to make the unit clear. Also, I think flags
should just be a bool and maybe renamed to something more meaningful.

> +{
> +	unsigned long tmp = flags ? addr[start / BITS_PER_LONG]
> +			: ~addr[start / BITS_PER_LONG];
> +
> +	/* Handle 1st word. */
> +	if (!IS_ALIGNED(start, BITS_PER_LONG)) {
> +		tmp &= HIGH_BITS_MASK(start % BITS_PER_LONG);
> +		start = round_down(start, BITS_PER_LONG);
> +	}
> +
> +	do {
> +		if (tmp)
> +			return MIN(start + __ffs(tmp), end);
> +
> +		start += BITS_PER_LONG;
> +		if (start >= end)
> +			return end;
> +
> +		tmp = flags ? addr[start / BITS_PER_LONG]
> +			: ~addr[start / BITS_PER_LONG];
> +	} while (1);
> +}
> +#endif
>  
>  #ifndef find_next_bit
>  /*
> @@ -23,86 +52,16 @@
>  unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
>  			    unsigned long offset)
>  {
> -	const unsigned long *p = addr + BITOP_WORD(offset);
> -	unsigned long result = offset & ~(BITS_PER_LONG-1);
> -	unsigned long tmp;
> -
> -	if (offset >= size)
> -		return size;

The previous versions handled this, but your code will always access
the word at addr[start/BITS_PER_LONG]. Are you sure no caller ever
passes start >= size?

> -	size -= result;
> -	offset %= BITS_PER_LONG;
> -	if (offset) {
> -		tmp = *(p++);
> -		tmp &= (~0UL << offset);
> -		if (size < BITS_PER_LONG)
> -			goto found_first;
> -		if (tmp)
> -			goto found_middle;
> -		size -= BITS_PER_LONG;
> -		result += BITS_PER_LONG;
> -	}
> -	while (size & ~(BITS_PER_LONG-1)) {
> -		if ((tmp = *(p++)))
> -			goto found_middle;
> -		result += BITS_PER_LONG;
> -		size -= BITS_PER_LONG;
> -	}
> -	if (!size)
> -		return result;
> -	tmp = *p;
> -
> -found_first:
> -	tmp &= (~0UL >> (BITS_PER_LONG - size));
> -	if (tmp == 0UL)		/* Are any bits set? */
> -		return result + size;	/* Nope. */
> -found_middle:
> -	return result + __ffs(tmp);
> +	return _find_next_bit(addr, size, offset, 1);
>  }
>  EXPORT_SYMBOL(find_next_bit);
>  #endif
>  
>  #ifndef find_next_zero_bit
> -/*
> - * This implementation of find_{first,next}_zero_bit was stolen from
> - * Linus' asm-alpha/bitops.h.
> - */
>  unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
>  				 unsigned long offset)
>  {
> -	const unsigned long *p = addr + BITOP_WORD(offset);
> -	unsigned long result = offset & ~(BITS_PER_LONG-1);
> -	unsigned long tmp;
> -
> -	if (offset >= size)
> -		return size;
> -	size -= result;
> -	offset %= BITS_PER_LONG;
> -	if (offset) {
> -		tmp = *(p++);
> -		tmp |= ~0UL >> (BITS_PER_LONG - offset);
> -		if (size < BITS_PER_LONG)
> -			goto found_first;
> -		if (~tmp)
> -			goto found_middle;
> -		size -= BITS_PER_LONG;
> -		result += BITS_PER_LONG;
> -	}
> -	while (size & ~(BITS_PER_LONG-1)) {
> -		if (~(tmp = *(p++)))
> -			goto found_middle;
> -		result += BITS_PER_LONG;
> -		size -= BITS_PER_LONG;
> -	}
> -	if (!size)
> -		return result;
> -	tmp = *p;
> -
> -found_first:
> -	tmp |= ~0UL << size;
> -	if (tmp == ~0UL)	/* Are any bits zero? */
> -		return result + size;	/* Nope. */
> -found_middle:
> -	return result + ffz(tmp);
> +	return _find_next_bit(addr, size, offset, 0);
>  }
>  EXPORT_SYMBOL(find_next_zero_bit);
>  #endif
> @@ -113,24 +72,14 @@ EXPORT_SYMBOL(find_next_zero_bit);
>   */
>  unsigned long find_first_bit(const unsigned long *addr, unsigned long size)
>  {
> -	const unsigned long *p = addr;
> -	unsigned long result = 0;
> -	unsigned long tmp;
> +	unsigned int idx;
>  
> -	while (size & ~(BITS_PER_LONG-1)) {
> -		if ((tmp = *(p++)))
> -			goto found;
> -		result += BITS_PER_LONG;
> -		size -= BITS_PER_LONG;
> +	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
> +		if (addr[idx])
> +			return idx * BITS_PER_LONG + __ffs(addr[idx]);
>  	}

I'm afraid this is wrong. It doesn't take garbage bits in the last
(partial) word into account. You either need to loop over the full
words and handle the last separately, masking off the garbage bits, or
wrap min(, size) around the above expression, just as you've done in
_find_next_bit. I think I prefer the latter.

Does anyone use insane size bitmaps with 2^32 bits or more? If so,
you'd have to watch out for overflow and use unsigned long for idx.

> -	if (!size)
> -		return result;
>  
> -	tmp = (*p) & (~0UL >> (BITS_PER_LONG - size));
> -	if (tmp == 0UL)		/* Are any bits set? */
> -		return result + size;	/* Nope. */
> -found:
> -	return result + __ffs(tmp);
> +	return size;
>  }
>  EXPORT_SYMBOL(find_first_bit);
>  #endif
> @@ -141,24 +90,14 @@ EXPORT_SYMBOL(find_first_bit);
>   */
>  unsigned long find_first_zero_bit(const unsigned long *addr, unsigned long size)
>  {
> -	const unsigned long *p = addr;
> -	unsigned long result = 0;
> -	unsigned long tmp;
> +	unsigned int idx;
>  
> -	while (size & ~(BITS_PER_LONG-1)) {
> -		if (~(tmp = *(p++)))
> -			goto found;
> -		result += BITS_PER_LONG;
> -		size -= BITS_PER_LONG;
> +	for (idx = 0; idx * BITS_PER_LONG < size; idx++) {
> +		if (addr[idx] != ULONG_MAX)
> +			return idx * BITS_PER_LONG + ffz(addr[idx]);
>  	}

The same of course applies here.

> -	if (!size)
> -		return result;
>  
> -	tmp = (*p) | (~0UL << size);
> -	if (tmp == ~0UL)	/* Are any bits zero? */
> -		return result + size;	/* Nope. */
> -found:
> -	return result + ffz(tmp);
> +	return size;
>  }
>  EXPORT_SYMBOL(find_first_zero_bit);
>  #endif
> @@ -166,18 +105,6 @@ EXPORT_SYMBOL(find_first_zero_bit);
>  #ifdef __BIG_ENDIAN
>  
>  /* include/linux/byteorder does not support "unsigned long" type */
> -static inline unsigned long ext2_swabp(const unsigned long * x)
> -{
> -#if BITS_PER_LONG == 64
> -	return (unsigned long) __swab64p((u64 *) x);
> -#elif BITS_PER_LONG == 32
> -	return (unsigned long) __swab32p((u32 *) x);
> -#else
> -#error BITS_PER_LONG not defined
> -#endif
> -}
> -
> -/* include/linux/byteorder doesn't support "unsigned long" type */
>  static inline unsigned long ext2_swab(const unsigned long y)
>  {
>  #if BITS_PER_LONG == 64
> @@ -189,48 +116,40 @@ static inline unsigned long ext2_swab(const unsigned long y)
>  #endif
>  }
>  
> -#ifndef find_next_zero_bit_le
> -unsigned long find_next_zero_bit_le(const void *addr, unsigned
> -		long size, unsigned long offset)
> +#if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
> +static unsigned long _find_next_bit_le(const unsigned long *addr,
> +		unsigned long end, unsigned long start, unsigned long flags)
>  {
> -	const unsigned long *p = addr;
> -	unsigned long result = offset & ~(BITS_PER_LONG - 1);
> -	unsigned long tmp;
> -
> -	if (offset >= size)
> -		return size;
> -	p += BITOP_WORD(offset);
> -	size -= result;
> -	offset &= (BITS_PER_LONG - 1UL);
> -	if (offset) {
> -		tmp = ext2_swabp(p++);
> -		tmp |= (~0UL >> (BITS_PER_LONG - offset));
> -		if (size < BITS_PER_LONG)
> -			goto found_first;
> -		if (~tmp)
> -			goto found_middle;
> -		size -= BITS_PER_LONG;
> -		result += BITS_PER_LONG;
> +	unsigned long tmp = flags ? addr[start / BITS_PER_LONG]
> +			: ~addr[start / BITS_PER_LONG];
> +
> +	/* Handle 1st word. */
> +	if (!IS_ALIGNED(start, BITS_PER_LONG)) {
> +		tmp &= ext2_swab(HIGH_BITS_MASK(start
> +					% BITS_PER_LONG));

Nit: There's no reason to break that line.

> +		start = round_down(start, BITS_PER_LONG);
>  	}
>  
> -	while (size & ~(BITS_PER_LONG - 1)) {
> -		if (~(tmp = *(p++)))
> -			goto found_middle_swap;
> -		result += BITS_PER_LONG;
> -		size -= BITS_PER_LONG;
> -	}
> -	if (!size)
> -		return result;
> -	tmp = ext2_swabp(p);
> -found_first:
> -	tmp |= ~0UL << size;
> -	if (tmp == ~0UL)	/* Are any bits zero? */
> -		return result + size; /* Nope. Skip ffz */
> -found_middle:
> -	return result + ffz(tmp);
> +	do {
> +		if (tmp)
> +			return MIN(start +
> +				__ffs(ext2_swab(tmp)), end);

Again, no reason to break the line.
  
> -found_middle_swap:
> -	return result + ffz(ext2_swab(tmp));
> +		start += BITS_PER_LONG;
> +		if (start >= end)
> +			return end;
> +
> +		tmp = flags ? addr[start / BITS_PER_LONG]
> +			: ~addr[start / BITS_PER_LONG];
> +	} while (1);
> +}
> +#endif
> +
> +#ifndef find_next_zero_bit_le
> +unsigned long find_next_zero_bit_le(const void *addr, unsigned
> +		long size, unsigned long offset)
> +{
> +	return _find_next_bit_le(addr, size, offset, o);

I'm assuming you only compile-tested this on little-endian. The o
wants to be a 0.

Rasmus

