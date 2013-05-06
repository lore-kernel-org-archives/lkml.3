Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab3EFHzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:55:55 -0400
Received: from ozlabs.org ([203.10.76.45]:49581 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab3EFHyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:54:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Hogan <james.hogan@imgtec.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] linkage.h: fix build breakage due to symbol prefix handling
In-Reply-To: <20130502153035.03afb3f75d9bfd4693319e8c@canb.auug.org.au>
References: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com> <878v3yql7r.fsf@rustcorp.com.au> <20130502133737.c2874e483bdc1380a59786f4@canb.auug.org.au> <20130502153035.03afb3f75d9bfd4693319e8c@canb.auug.org.au>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 06 May 2013 14:59:05 +0930
Message-ID: <87a9o8r80u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:
> Version from today's merge fix.  Rusty, you should show this to Linus
> when you ask him to merge your modules tree (assuming it looks right :-)).
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 14 Mar 2013 17:14:41 +1100
> Subject: [PATCH] cond_syscall and SYSCALL_ALIAS merge fixup
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

I ended up with something similar, except I didn't remove
linux/stringify.h from the includes.

Thanks!
Rusty.

> ---
>  include/linux/linkage.h |   17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
> index de09dec..bedcddf 100644
> --- a/include/linux/linkage.h
> +++ b/include/linux/linkage.h
> @@ -2,7 +2,7 @@
>  #define _LINUX_LINKAGE_H
>  
>  #include <linux/compiler.h>
> -#include <linux/stringify.h>
> +#include <linux/export.h>
>  #include <asm/linkage.h>
>  
>  #ifdef __cplusplus
> @@ -15,21 +15,16 @@
>  #define asmlinkage CPP_ASMLINKAGE
>  #endif
>  
> -#ifdef CONFIG_SYMBOL_PREFIX
> -#define __SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX __stringify(x)
> -#else
> -#define __SYMBOL_NAME(x) __stringify(x)
> -#endif
> -
>  #ifndef cond_syscall
> -#define cond_syscall(x) asm(".weak\t" __SYMBOL_NAME(x) \
> -	"\n\t.set\t" __SYMBOL_NAME(x) "," __SYMBOL_NAME(sys_ni_syscall));
> +#define cond_syscall(x) asm(".weak\t" VMLINUX_SYMBOL_STR(x) "\n\t"	\
> +			    ".set\t" VMLINUX_SYMBOL_STR(x) ","	\
> +			    VMLINUX_SYMBOL_STR(sys_ni_syscall))
>  #endif
>  
>  #ifndef SYSCALL_ALIAS
>  #define SYSCALL_ALIAS(alias, name)				\
> -	asm ("\t.globl " __SYMBOL_NAME(alias)			\
> -	"\n\t.set\t" __SYMBOL_NAME(alias) "," __SYMBOL_NAME(name))
> +	asm ("\t.globl " VMLINUX_SYMBOL_STR(alias)			\
> +	"\n\t.set\t" VMLINUX_SYMBOL_STR(alias) "," VMLINUX_SYMBOL_STR(name))
>  #endif
>  
>  #define __page_aligned_data	__section(.data..page_aligned) __aligned(PAGE_SIZE)
>
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
