Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaIWKVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:21:09 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56029 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797AbaIWKUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <1410168160-3624-2-git-send-email-lftan@altera.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
	<1410168160-3624-2-git-send-email-lftan@altera.com>
Date: Tue, 23 Sep 2014 18:20:08 +0800
Message-ID: <CAFiDJ5-b_P7aWFXYP4GcgTUb3t_j6dZCsjeGZwVUs+7qo0v-GA@mail.gmail.com>
Subject: Re: [PATCH v3 01/29] asm-generic: add generic futex for !CONFIG_SMP
From: "LF.Tan" <lftan.linux@gmail.com>
To: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Ley Foon Tan <lftan@altera.com>, LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2014 at 5:22 PM, Ley Foon Tan <lftan@altera.com> wrote:
> Follow m68k futex implementation for !CONFIG_SMP.
>
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>  include/asm-generic/futex.h | 82 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
>
> diff --git a/include/asm-generic/futex.h b/include/asm-generic/futex.h
> index 01f227e..f5650a5 100644
> --- a/include/asm-generic/futex.h
> +++ b/include/asm-generic/futex.h
> @@ -5,6 +5,87 @@
>  #include <linux/uaccess.h>
>  #include <asm/errno.h>
>
> +#ifndef CONFIG_SMP
> +static inline int
> +futex_atomic_op_inuser(int encoded_op, u32 __user *uaddr)
> +{
> +       int op = (encoded_op >> 28) & 7;
> +       int cmp = (encoded_op >> 24) & 15;
> +       int oparg = (encoded_op << 8) >> 20;
> +       int cmparg = (encoded_op << 20) >> 20;
> +       int oldval, ret;
> +       u32 tmp;
> +
> +       if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
> +               oparg = 1 << oparg;
> +
> +       pagefault_disable();    /* implies preempt_disable() */
> +
> +       ret = -EFAULT;
> +       if (unlikely(get_user(oldval, uaddr) != 0))
> +               goto out_pagefault_enable;
> +
> +       ret = 0;
> +       tmp = oldval;
> +
> +       switch (op) {
> +       case FUTEX_OP_SET:
> +               tmp = oparg;
> +               break;
> +       case FUTEX_OP_ADD:
> +               tmp += oparg;
> +               break;
> +       case FUTEX_OP_OR:
> +               tmp |= oparg;
> +               break;
> +       case FUTEX_OP_ANDN:
> +               tmp &= ~oparg;
> +               break;
> +       case FUTEX_OP_XOR:
> +               tmp ^= oparg;
> +               break;
> +       default:
> +               ret = -ENOSYS;
> +       }
> +
> +       if (ret == 0 && unlikely(put_user(tmp, uaddr) != 0))
> +               ret = -EFAULT;
> +
> +out_pagefault_enable:
> +       pagefault_enable();     /* subsumes preempt_enable() */
> +
> +       if (ret == 0) {
> +               switch (cmp) {
> +               case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
> +               case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
> +               case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
> +               case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
> +               case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
> +               case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
> +               default: ret = -ENOSYS;
> +               }
> +       }
> +       return ret;
> +}
> +
> +static inline int
> +futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
> +                             u32 oldval, u32 newval)
> +{
> +       u32 val;
> +
> +       if (unlikely(get_user(val, uaddr) != 0))
> +               return -EFAULT;
> +
> +       if (val == oldval && unlikely(put_user(newval, uaddr) != 0))
> +               return -EFAULT;
> +
> +       *uval = val;
> +
> +       return 0;
> +}
> +
> +#else
>  static inline int
>  futex_atomic_op_inuser (int encoded_op, u32 __user *uaddr)
>  {
> @@ -54,4 +135,5 @@ futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
>         return -ENOSYS;
>  }
>
> +#endif /* CONFIG_SMP */
>  #endif
> --
> 1.8.2.1
>

Hi Arnd

Are you okay with this generic futex in asm-generic?

Regards
Ley Foon
