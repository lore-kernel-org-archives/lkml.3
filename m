Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab3D3Trz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:47:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932708Ab3D3Trx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:47:53 -0400
Date: Tue, 30 Apr 2013 12:47:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chanho Min <chanho.min@lge.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>,
        Yann Collet <yann.collet.73@gmail.com>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert.uytterhoeven@gmail.com>,
        linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] lib: add weak __clzsi2()/__clzdi2() functions
Message-Id: <20130430124750.bf5655264e637bbcb82c9693@linux-foundation.org>
In-Reply-To: <1367214005-14302-1-git-send-email-chanho.min@lge.com>
References: <1367214005-14302-1-git-send-email-chanho.min@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013 14:40:05 +0900 Chanho Min <chanho.min@lge.com> wrote:

> Some architectures need __clzsi2() or __clzdi2() for __builtin_clz and
> It causes build failure. They can be implemented using the fls() and
> overridden by linking arch-specific versions may not be implemented yet.
> 
> Reference: https://lkml.org/lkml/2013/4/18/603
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Chanho Min <chanho.min@lge.com>
>
> ...
>
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -23,7 +23,7 @@ lib-y	+= kobject.o klist.o
>  
>  obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
>  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> -	 gcd.o lcm.o list_sort.o uuid.o flex_array.o \
> +	 gcd.o lcm.o list_sort.o uuid.o flex_array.o clz.o\
>  	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o
>  obj-y += string_helpers.o
>  obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
> diff --git a/lib/clz.c b/lib/clz.c
> new file mode 100644
> index 0000000..5222b2d
> --- /dev/null
> +++ b/lib/clz.c
> @@ -0,0 +1,36 @@
> +/*
> + * lib/clz.c
> + *
> + * Copyright (C) 2013 Chanho Min <chanho.min@lge.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * __clzsi2/_clzdi2() can be overridden by linking arch-specific versions.
> + */
> +
> +#include <linux/export.h>
> +#include <linux/kernel.h>
> +
> +int __weak __clzsi2(int val)
> +{
> +	return BITS_PER_LONG - fls(val);
> +}
> +EXPORT_SYMBOL(__clzsi2);
> +
> +#if BITS_PER_LONG == 32
> +int __weak __clzdi2(long val)
> +{
> +	return BITS_PER_LONG - fls((int)val);
> +}
> +EXPORT_SYMBOL(__clzdi2);
> +#elif BITS_PER_LONG == 64
> +int __weak __clzdi2i(long val)

This is a typo, surely?  I'll switch it to __clzdi2.

> +{
> +	return BITS_PER_LONG - fls64((u64)val);
> +}
> +EXPORT_SYMBOL(__clzdi2);
> +#else
> +#error BITS_PER_LONG not 32 or 64
> +#endif

