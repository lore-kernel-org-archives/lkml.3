Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbbAMJqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:46:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbbAMJqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:46:11 -0500
Date: Tue, 13 Jan 2015 11:45:54 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 23/40] tile: enable sparse checks for get/put_user
Message-ID: <20150113094554.GB4434@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-24-git-send-email-mst@redhat.com>
 <54B46204.1010003@ezchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B46204.1010003@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 07:08:36PM -0500, Chris Metcalf wrote:
> On 1/6/2015 10:44 AM, Michael S. Tsirkin wrote:
> >Tile currently does not trigger sparse warnings when get_user
> >causes an illegal assignment across bitwise types.
> >
> >For example:
> >
> >__le32 __user *p;
> >__u32 x;
> >put_user(x, p);
> >
> >violates endian-ness rules, but currently does not trigger sparse
> >warning on tile.
> >
> >Fix this by adding some dead code.
> >
> >Signed-off-by: Michael S. Tsirkin<mst@redhat.com>
> >---
> >  arch/tile/include/asm/uaccess.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> >diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
> >index 22cffa1..03d905c 100644
> >--- a/arch/tile/include/asm/uaccess.h
> >+++ b/arch/tile/include/asm/uaccess.h
> >@@ -218,6 +218,8 @@ extern int __get_user_bad(void)
> >  		case 8: __get_user_8(x, ptr, __ret); break;		\
> >  		default: __ret = __get_user_bad(); break;		\
> >  		}							\
> >+		if (0)							\
> >+			x = *(__force typeof(*ptr) *)(ptr);		\
> >  		__ret;							\
> >  	})
> 
> The "if (0)" suggestion is cute, but pretty hacky :-)
> 
> Here's a revised change that may fix both of your sparse concerns with
> tile, without having to give up the optimized 64-bit get/put on tilepro.
> Would this fix both the issue discussed in this change, as well as the
> issue in the previous change (where you removed the typeof(x-x) cast)?

The patches look good, thanks! they are almost there, however, they do
not completely resolve the issue that my patch 1 tried (incorrectly) to
fix: namely x being a bitwise type.  Comments below.

> The key changes are to copy the x86 definition of __inttype(), and then to
> arrange to use an intermediate integral type that gets assigned to or from
> the actual typed value so as to expose any sparse issues.
> 
> If this works for you, I'm happy to queue it in the tile tree, or I can
> provide a proper git commit for you to include in your series, whichever
> works better for you.

Please queue it up for 3.20. Extra __force is needed in a couple of
places - would you like to fix this up yourself, or do you want me to
write a patch on top?

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
> +       __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
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
>                              "9:"                                       \
>                              : "=r" (ret), "=r" (__a), "=&r" (__b)      \
>                              : "r" (ptr), "i" (-EFAULT));               \
> -               (x) = (__typeof(x))(__typeof((x)-(x)))                  \
> +               (x) = (__typeof(x))(__inttype(x))                       \
>                         (((u64)__hi32(__a, __b) << 32) |                \
>                          __lo32(__a, __b));                             \
>         })

This cast to __typeof(x) needs to be done with __force, otherwise
there will be a warning with bitwise types.


> @@ -210,14 +210,16 @@ extern int __get_user_bad(void)
>  #define __get_user(x, ptr)                                             \
>         ({                                                              \
>                 int __ret;                                              \
> +               __inttype(*(ptr)) __x;                                  \
>                 __chk_user_ptr(ptr);                                    \
>                 switch (sizeof(*(ptr))) {                               \
> -               case 1: __get_user_1(x, ptr, __ret); break;             \
> -               case 2: __get_user_2(x, ptr, __ret); break;             \
> -               case 4: __get_user_4(x, ptr, __ret); break;             \
> -               case 8: __get_user_8(x, ptr, __ret); break;             \
> +               case 1: __get_user_1(__x, ptr, __ret); break;           \
> +               case 2: __get_user_2(__x, ptr, __ret); break;           \
> +               case 4: __get_user_4(__x, ptr, __ret); break;           \
> +               case 8: __get_user_8(__x, ptr, __ret); break;           \
>                 default: __ret = __get_user_bad(); break;               \
>                 }                                                       \
> +               (x) = (typeof(x))__x;                                   \

And this one too.

>                 __ret;                                                  \
>         })
> 
> @@ -246,7 +248,7 @@ extern int __get_user_bad(void)
>  #define __put_user_4(x, ptr, ret) __put_user_asm(sw, x, ptr, ret)
>  #define __put_user_8(x, ptr, ret)                                      \
>         ({                                                              \
> -               u64 __x = (__typeof((x)-(x)))(x);                       \
> +               u64 __x = (__inttype(x))(x);                            \

And this cast to __inttype too.


>                 int __lo = (int) __x, __hi = (int) (__x >> 32);         \
>                 asm volatile("1: { sw %1, %2; addi %0, %1, 4 }\n"       \
>                              "2: { sw %0, %3; movei %0, 0 }\n"          \
> @@ -289,12 +291,13 @@ extern int __put_user_bad(void)
>  #define __put_user(x, ptr)                                             \
>  ({                                                                     \
>         int __ret;                                                      \
> +       typeof(*(ptr)) __x = (x);                                       \
>         __chk_user_ptr(ptr);                                            \
>         switch (sizeof(*(ptr))) {                                       \
> -       case 1: __put_user_1(x, ptr, __ret); break;                     \
> -       case 2: __put_user_2(x, ptr, __ret); break;                     \
> -       case 4: __put_user_4(x, ptr, __ret); break;                     \
> -       case 8: __put_user_8(x, ptr, __ret); break;                     \
> +       case 1: __put_user_1(__x, ptr, __ret); break;                   \
> +       case 2: __put_user_2(__x, ptr, __ret); break;                   \
> +       case 4: __put_user_4(__x, ptr, __ret); break;                   \
> +       case 8: __put_user_8(__x, ptr, __ret); break;                   \
>         default: __ret = __put_user_bad(); break;                       \
>         }                                                               \
>         __ret;                                                          \
> 
> -- 
> Chris Metcalf, EZChip Semiconductor
> http://www.ezchip.com
