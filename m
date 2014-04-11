Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaDKS1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:27:17 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:55001 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaDKS1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:27:14 -0400
MIME-Version: 1.0
In-Reply-To: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
Date: Fri, 11 Apr 2014 14:27:13 -0400
Message-ID: <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this bug really still present in modern CPUs?  This change breaks
running 16-bit apps in Wine.  I have a few really old games I like to
play on occasion, and I don't have a copy of Win 3.11 to put in a VM.

On Fri, Apr 11, 2014 at 1:36 PM, tip-bot for H. Peter Anvin
<tipbot@zytor.com> wrote:
> Commit-ID:  b3b42ac2cbae1f3cecbb6229964a4d48af31d382
> Gitweb:     http://git.kernel.org/tip/b3b42ac2cbae1f3cecbb6229964a4d48af31d382
> Author:     H. Peter Anvin <hpa@linux.intel.com>
> AuthorDate: Sun, 16 Mar 2014 15:31:54 -0700
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 11 Apr 2014 10:10:09 -0700
>
> x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
>
> The IRET instruction, when returning to a 16-bit segment, only
> restores the bottom 16 bits of the user space stack pointer.  We have
> a software workaround for that ("espfix") for the 32-bit kernel, but
> it relies on a nonzero stack segment base which is not available in
> 32-bit mode.
>
> Since 16-bit support is somewhat crippled anyway on a 64-bit kernel
> (no V86 mode), and most (if not quite all) 64-bit processors support
> virtualization for the users who really need it, simply reject
> attempts at creating a 16-bit segment when running on top of a 64-bit
> kernel.
>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Link: http://lkml.kernel.org/n/tip-kicdm89kzw9lldryb1br9od0@git.kernel.org
> Cc: <stable@vger.kernel.org>
> ---
>  arch/x86/kernel/ldt.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
> index ebc9873..af1d14a 100644
> --- a/arch/x86/kernel/ldt.c
> +++ b/arch/x86/kernel/ldt.c
> @@ -229,6 +229,17 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
>                 }
>         }
>
> +       /*
> +        * On x86-64 we do not support 16-bit segments due to
> +        * IRET leaking the high bits of the kernel stack address.
> +        */
> +#ifdef CONFIG_X86_64
> +       if (!ldt_info.seg_32bit) {
> +               error = -EINVAL;
> +               goto out_unlock;
> +       }
> +#endif
> +
>         fill_ldt(&ldt, &ldt_info);
>         if (oldmode)
>                 ldt.avl = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
