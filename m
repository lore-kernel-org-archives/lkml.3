Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaHUFhC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:37:02 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:48030 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaHUFhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:37:00 -0400
MIME-Version: 1.0
In-Reply-To: <1405021635-19179-1-git-send-email-daniel.thompson@linaro.org>
References: <1403258510-5760-1-git-send-email-daniel.thompson@linaro.org>
	<1405021635-19179-1-git-send-email-daniel.thompson@linaro.org>
Date: Wed, 20 Aug 2014 22:36:59 -0700
Message-ID: <CAA3XUr0byMWN-QfYKke+6bmu-_ukYpTdpRJN37Gk6JtxXtoA7w@mail.gmail.com>
Subject: Re: [PATCH 3.16.0-rc3-rmk v5] ARM: add get_user() support for 8 byte types
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 July 2014 12:47, Daniel Thompson <daniel.thompson@linaro.org> wrote:
> Recent contributions, including to DRM and binder, introduce 64-bit
> values in their interfaces. A common motivation for this is to allow
> the same ABI for 32- and 64-bit userspaces (and therefore also a shared
> ABI for 32/64 hybrid userspaces). Anyhow, the developers would like to
> avoid gotchas like having to use copy_from_user().
>
> This feature is already implemented on x86-32 and the majority of other
> 32-bit architectures. The current list of get_user_8 hold out
> architectures are: arm, avr32, blackfin, m32r, metag, microblaze,
> mn10300, sh.
>
> Credit:
>
>     My name sits rather uneasily at the top of this patch. The v1 and
>     v2 versions of the patch were written by Rob Clark and to produce v4
>     I mostly copied code from Russell King and H. Peter Anvin. However I
>     have mangled the patch sufficiently that *blame* is rightfully mine
>     even if credit should more widely shared.
>
> Changelog:
>
> v5: updated to use the ret macro (requested by Russell King)
> v4: remove an inlined add on big endian systems (spotted by Russell King),
>     used __ARMEB__ rather than BIG_ENDIAN (to match rest of file),
>     cleared r3 on EFAULT during __get_user_8.
> v3: fix a couple of checkpatch issues
> v2: pass correct size to check_uaccess, and better handling of narrowing
>     double word read with __get_user_xb() (Russell King's suggestion)
> v1: original
>
> Signed-off-by: Rob Clark <robdclark@gmail.com>
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
> ---
>  arch/arm/include/asm/uaccess.h | 20 +++++++++++++++++++-
>  arch/arm/lib/getuser.S         | 37 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 55 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
> index 75d9579..7057cf8 100644
> --- a/arch/arm/include/asm/uaccess.h
> +++ b/arch/arm/include/asm/uaccess.h
> @@ -107,6 +107,8 @@ static inline void set_fs(mm_segment_t fs)
>  extern int __get_user_1(void *);
>  extern int __get_user_2(void *);
>  extern int __get_user_4(void *);
> +extern int __get_user_lo8(void *);
> +extern int __get_user_8(void *);
>
>  #define __GUP_CLOBBER_1        "lr", "cc"
>  #ifdef CONFIG_CPU_USE_DOMAINS
> @@ -115,6 +117,8 @@ extern int __get_user_4(void *);
>  #define __GUP_CLOBBER_2 "lr", "cc"
>  #endif
>  #define __GUP_CLOBBER_4        "lr", "cc"
> +#define __GUP_CLOBBER_lo8 "lr", "cc"
> +#define __GUP_CLOBBER_8        "lr", "cc"
>
>  #define __get_user_x(__r2,__p,__e,__l,__s)                             \
>            __asm__ __volatile__ (                                       \
> @@ -125,11 +129,19 @@ extern int __get_user_4(void *);
>                 : "0" (__p), "r" (__l)                                  \
>                 : __GUP_CLOBBER_##__s)
>
> +/* narrowing a double-word get into a single 32bit word register: */
> +#ifdef __ARMEB__
> +#define __get_user_xb(__r2, __p, __e, __l, __s)                                \
> +       __get_user_x(__r2, __p, __e, __l, lo8)
> +#else
> +#define __get_user_xb __get_user_x
> +#endif
> +
>  #define __get_user_check(x,p)                                                  \
>         ({                                                              \
>                 unsigned long __limit = current_thread_info()->addr_limit - 1; \
>                 register const typeof(*(p)) __user *__p asm("r0") = (p);\
> -               register unsigned long __r2 asm("r2");                  \
> +               register typeof(x) __r2 asm("r2");                      \

Above breaks V7 BE case when get_user called for target
variable of 64 bit in size but '*__p' is 32 bit or smaller. Please
look at [1] for more details.

Thanks,
Victor

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-August/280806.html

>                 register unsigned long __l asm("r1") = __limit;         \
>                 register int __e asm("r0");                             \
>                 switch (sizeof(*(__p))) {                               \
> @@ -142,6 +154,12 @@ extern int __get_user_4(void *);
>                 case 4:                                                 \
>                         __get_user_x(__r2, __p, __e, __l, 4);           \
>                         break;                                          \
> +               case 8:                                                 \
> +                       if (sizeof((x)) < 8)                            \
> +                               __get_user_xb(__r2, __p, __e, __l, 4);  \
> +                       else                                            \
> +                               __get_user_x(__r2, __p, __e, __l, 8);   \
> +                       break;                                          \
>                 default: __e = __get_user_bad(); break;                 \
>                 }                                                       \
>                 x = (typeof(*(p))) __r2;                                \
> diff --git a/arch/arm/lib/getuser.S b/arch/arm/lib/getuser.S
> index 0f958e3..9386000 100644
> --- a/arch/arm/lib/getuser.S
> +++ b/arch/arm/lib/getuser.S
> @@ -18,7 +18,7 @@
>   * Inputs:     r0 contains the address
>   *             r1 contains the address limit, which must be preserved
>   * Outputs:    r0 is the error code
> - *             r2 contains the zero-extended value
> + *             r2, r3 contains the zero-extended value
>   *             lr corrupted
>   *
>   * No other registers must be altered.  (see <asm/uaccess.h>
> @@ -66,15 +66,50 @@ ENTRY(__get_user_4)
>         ret     lr
>  ENDPROC(__get_user_4)
>
> +ENTRY(__get_user_8)
> +       check_uaccess r0, 8, r1, r2, __get_user_bad
> +#ifdef CONFIG_THUMB2_KERNEL
> +5: TUSER(ldr)  r2, [r0]
> +6: TUSER(ldr)  r3, [r0, #4]
> +#else
> +5: TUSER(ldr)  r2, [r0], #4
> +6: TUSER(ldr)  r3, [r0]
> +#endif
> +       mov     r0, #0
> +       ret     lr
> +ENDPROC(__get_user_8)
> +
> +#ifdef __ARMEB__
> +ENTRY(__get_user_lo8)
> +       check_uaccess r0, 8, r1, r2, __get_user_bad
> +#ifdef CONFIG_CPU_USE_DOMAINS
> +       add     r0, r0, #4
> +7:     ldrt    r2, [r0]
> +#else
> +7:     ldr     r2, [r0, #4]
> +#endif
> +       mov     r0, #0
> +       ret     lr
> +ENDPROC(__get_user_lo8)
> +#endif
> +
> +__get_user_bad8:
> +       mov     r3, #0
>  __get_user_bad:
>         mov     r2, #0
>         mov     r0, #-EFAULT
>         ret     lr
>  ENDPROC(__get_user_bad)
> +ENDPROC(__get_user_bad8)
>
>  .pushsection __ex_table, "a"
>         .long   1b, __get_user_bad
>         .long   2b, __get_user_bad
>         .long   3b, __get_user_bad
>         .long   4b, __get_user_bad
> +       .long   5b, __get_user_bad8
> +       .long   6b, __get_user_bad8
> +#ifdef __ARMEB__
> +       .long   7b, __get_user_bad
> +#endif
>  .popsection
> --
> 1.9.3
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
