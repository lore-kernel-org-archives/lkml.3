Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab3CHAeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 19:34:05 -0500
Received: from ozlabs.org ([203.10.76.45]:60939 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758166Ab3CHAdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 19:33:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Hogan <james.hogan@imgtec.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-next@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
In-Reply-To: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com>
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 08 Mar 2013 11:03:13 +1100
Message-ID: <87sj46wyf2.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan <james.hogan@imgtec.com> writes:
> The commit "consolidate cond_syscall and SYSCALL_ALIAS declarations"
> broke the build on blackfin and metag due to the following code:
>
>   #ifndef SYMBOL_NAME
>   #ifdef CONFIG_SYMBOL_PREFIX
>   #define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
>   #else
>   #define SYMBOL_NAME(x) x
>   #endif
>   #endif
>   #define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
>
> __stringify literally stringifies CONFIG_SYMBOL_PREFIX ##x, so you get
> lines like this in the assembly output:
>
>   .weak CONFIG_SYMBOL_PREFIXsys_quotactl
>   .set
>   CONFIG_SYMBOL_PREFIXsys_quotactl,CONFIG_SYMBOL_PREFIXsys_ni_syscall
>
> This is fixed by defining SYMBOL_PREFIX from the command line for c
> files in addition to assembly for architectures that set
> CONFIG_SYMBOL_PREFIX (scripts/Makefile.lib), and defining __SYMBOL_NAME
> as:
>
>   #define __SYMBOL_NAME(x) __stringify(SYMBOL_PREFIX) #x
>
> We first have to ensure SYMBOL_PREFIX is defined (which avoids polluting
> the command lines for architectures that don't use symbol prefixes).
> Also the definition of SYMBOL_PREFIX in <linux/kernel.h> is removed as
> it conflicts, isn't used anywhere, and is defined as a string so differs
> from the assembly definition.

So now, if CONFIG_SYMBOL_PREFIX, SYMBOL_PREFIX is defined on the cmdline
as a string.  Otherwise it's empty (not the empty string?):

> +/* This helps us to avoid #ifdef SYMBOL_PREFIX */
> +#ifndef SYMBOL_PREFIX
> +#define SYMBOL_PREFIX
>  #endif
> -#define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
> +
> +#define __SYMBOL_NAME(x) __stringify(SYMBOL_PREFIX) #x

And why are you __stringify()ing a string?

>  #ifndef cond_syscall
>  #define cond_syscall(x) asm(".weak\t" __SYMBOL_NAME(x) \
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 07125e6..f1cce6a 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -123,6 +123,7 @@ ifdef CONFIG_SYMBOL_PREFIX
>  _sym_flags = -DSYMBOL_PREFIX=$(patsubst "%",%,$(CONFIG_SYMBOL_PREFIX))
>  _cpp_flags += $(_sym_flags)
>  _a_flags += $(_sym_flags)
> +_c_flags += $(_sym_flags)
>  endif

Confused,
Rusty.
