Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbbAMW3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:29:34 -0500
Received: from mail.kernel.org ([198.145.29.136]:49528 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbbAMW3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:29:32 -0500
Date: Wed, 14 Jan 2015 00:29:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] tile: fix put_user sparse errors
Message-ID: <20150113222925.GA23641@redhat.com>
References: <201501131950.t0DJognR027020@lab-37.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501131950.t0DJognR027020@lab-37.internal.tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 02:39:05PM -0500, Chris Metcalf wrote:
> Use x86's __inttype macro instead of using the typeof(x-x) trick to
> generate a suitable integer size type.  This avoids a sparse warning
> when examining the x-x type with a bitwise type.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  arch/tile/include/asm/uaccess.h | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
> index b6cde3209b96..b81b24a8489b 100644
> --- a/arch/tile/include/asm/uaccess.h
> +++ b/arch/tile/include/asm/uaccess.h
> @@ -114,14 +114,14 @@ struct exception_table_entry {
>  extern int fixup_exception(struct pt_regs *regs);
>  
>  /*
> + * This is a type: either unsigned long, if the argument fits into
> + * that type, or otherwise unsigned long long.
> + */
> +#define __inttype(x) \
> +	__typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
> +
> +/*
>   * Support macros for __get_user().
> - *
> - * Implementation note: The "case 8" logic of casting to the type of
> - * the result of subtracting the value from itself is basically a way
> - * of keeping all integer types the same, but casting any pointers to
> - * ptrdiff_t, i.e. also an integer type.  This way there are no
> - * questionable casts seen by the compiler on an ILP32 platform.
> - *
>   * Note that __get_user() and __put_user() assume proper alignment.
>   */
>  
> @@ -178,7 +178,7 @@ extern int fixup_exception(struct pt_regs *regs);
>  			     "9:"					\
>  			     : "=r" (ret), "=r" (__a), "=&r" (__b)	\
>  			     : "r" (ptr), "i" (-EFAULT));		\
> -		(x) = (__typeof(x))(__typeof((x)-(x)))			\
> +		(x) = (__force __typeof(x))(__inttype(x))		\
>  			(((u64)__hi32(__a, __b) << 32) |		\
>  			 __lo32(__a, __b));				\
>  	})
> @@ -246,7 +246,7 @@ extern int __get_user_bad(void)
>  #define __put_user_4(x, ptr, ret) __put_user_asm(sw, x, ptr, ret)
>  #define __put_user_8(x, ptr, ret)					\
>  	({								\
> -		u64 __x = (__typeof((x)-(x)))(x);			\
> +		u64 __x = (__force __inttype(x))(x);			\
>  		int __lo = (int) __x, __hi = (int) (__x >> 32);		\
>  		asm volatile("1: { sw %1, %2; addi %0, %1, 4 }\n"	\
>  			     "2: { sw %0, %3; movei %0, 0 }\n"		\
> -- 
> 2.1.2
