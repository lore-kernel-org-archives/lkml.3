Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaKZRsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:48:25 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56748 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZRsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:48:24 -0500
MIME-Version: 1.0
In-Reply-To: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
References: <1417010419-3827-1-git-send-email-sasha.levin@oracle.com>
Date: Wed, 26 Nov 2014 21:48:24 +0400
Message-ID: <CAPAsAGwgYHiiz=APmz74t4TLsXeR2yv4sfrukWaZiy1XOU=9WQ@mail.gmail.com>
Subject: Re: [RFC 1/2] compiler: use compiler to detect integer overflows
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-26 17:00 GMT+03:00 Sasha Levin <sasha.levin@oracle.com>:
> We've used to detect integer overflows by causing an overflow and testing the
> result. For example, to test for addition overflow we would:
>
>         if (a + b < a)
>                 /* Overflow detected */
>
> While it works, this is actually an undefined behaviour and we're not

There is a case when such check doesn't work. If a == INT_MIN then  (a + b < a)
always will be false.


> guaranteed to have integers overflowing this way. GCC5 has introduced
> built in macros (which existed in Clang/LLVM for a while) to test for
> addition, subtraction and multiplication overflows.
>
> Rather than keep relying on the current behaviour of GCC, let's take
> it's olive branch and test for overflows by using the builtin
> functions.
>
> Changing existing code is simple and can be done using Coccinelle:
>
> @@ expression X; expression Y; expression Z; constant C; @@
> (
> - X + Y < Y
> + check_add_overflow(X, Y)
> |
> - X - Y > X
> + check_sub_overflow(X, Y)
> |
> - X != 0 && Y > C / X
> + check_mul_overflow(X, Y, C)
> )
>
> Which also makes the code much more clearer, for example:
>
> -       if (addr + len < addr)
> +       if (check_add_overflow(addr, len))
>                 return -EFAULT;
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>
> The patch following this one is an example of how changes to existing
> code will look like. It's just one patch out of about 40 which are very
> simiar - so to avoid lots of useless mails I'll avoid sending them until
> this patch looks ok.
>
>  include/linux/compiler-gcc5.h |    8 ++++++++
>  include/linux/compiler.h      |   11 +++++++++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
> index c8c5659..9d39f66 100644
> --- a/include/linux/compiler-gcc5.h
> +++ b/include/linux/compiler-gcc5.h
> @@ -63,3 +63,11 @@
>  #define __HAVE_BUILTIN_BSWAP64__
>  #define __HAVE_BUILTIN_BSWAP16__
>  #endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
> +
> +__maybe_unused static unsigned int gcc_overflow_dummy;

To make you macro bellow work correctly, type of gcc_overflow_dummy
variable has to be typeof(A + B)

E.g. currently you macros will return true for 0xffffffffULL + 1ULL.

> +#define check_add_overflow(A, B) \
> +               __builtin_add_overflow((A), (B), &gcc_overflow_dummy)
> +#define check_sub_overflow(A, B) \
> +               __builtin_sub_overflow((A), (B), &gcc_overflow_dummy)
> +#define check_mul_overflow(A, B, C) \
> +               __builtin_mul_overflow((A), (B), &gcc_overflow_dummy)
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 934a834..7f15a18 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -388,4 +388,15 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>  # define __kprobes
>  # define nokprobe_inline       inline
>  #endif
> +
> +#ifndef check_add_overflow
> +#define check_add_overflow(A, B) (((A) + (B)) < (A))
> +#endif
> +#ifndef check_sub_overflow
> +#define check_sub_overflow(A, B) (((A) - (B)) > (A))
> +#endif
> +#ifndef check_mul_overflow
> +#define check_mul_overflow(A, B, C) ((A) != 0 && (B) > (C) / (A))
> +#endif
> +
>  #endif /* __LINUX_COMPILER_H */
> --
> 1.7.10.4
>
