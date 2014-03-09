Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaCIV6o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 17:58:44 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:44477 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaCIV6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 17:58:43 -0400
Date: Sun, 9 Mar 2014 22:58:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: behanw@converseincode.com
Cc: mmarek@suse.cz, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, sparse@chrisli.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org,
        torvalds@linux-foundation.org, dwmw2@infradead.org,
        pageexec@freemail.hu,
        Jan-Simon =?iso-8859-1?Q?M=F6ller?= <dl9pf@gmx.de>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH 1/5] kbuild: LLVMLinux: Add Kbuild support for building
 kernel with Clang
Message-ID: <20140309215834.GA29655@ravnborg.org>
References: <1393376923-21892-1-git-send-email-behanw@converseincode.com>
 <1393376923-21892-2-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393376923-21892-2-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 05:08:39PM -0800, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> Add support to toplevel Makefile for compiling with clang, both for
> HOSTCC and CC. Use cc-option to prevent gcc option from breaking clang, and
> from clang options from breaking gcc.
> 
> Clang 3.4 semantics are the same as gcc semantics for unsupported flags. For
> unsupported warnings clang 3.4 returns true but shows a warning and gcc shows
> a warning and returns false.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Cc: PaX Team <pageexec@freemail.hu>
> ---
>  Makefile | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 831b36a..c4ab30d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -247,6 +247,15 @@ HOSTCXX      = g++
>  HOSTCFLAGS   = -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer
>  HOSTCXXFLAGS = -O2
>  
> +ifeq ($(shell $(HOSTCC) -v 2>&1 | grep -c "clang version"), 1)
> +HOSTCOMPILER := clang
> +HOSTCFLAGS  += -Wno-unused-value -Wno-unused-parameter \
> +		-Wno-missing-field-initializers -fno-delete-null-pointer-checks
> +else
> +HOSTCOMPILER := gcc
> +endif
> +export HOSTCOMPILER
I see no use of HOSTCOMPLIER anywhere in this patchset not in the kernel. Can we drop this?

> +
>  # Decide whether to build built-in, modular, or both.
>  # Normally, just do built-in.
>  
> @@ -323,6 +332,12 @@ endif
>  
>  export quiet Q KBUILD_VERBOSE
>  
> +ifeq ($(shell $(CC) -v 2>&1 | grep -c "clang version"), 1)
> +COMPILER := clang
> +else
> +COMPILER := gcc
> +endif
> +export COMPILER
Likewise - COMPILER seems unsued- can it be dropped?

>  
>  # Look for make include files relative to root of kernel src
>  MAKEFLAGS += --include-dir=$(srctree)
> @@ -382,7 +397,7 @@ KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
>  		   -fno-strict-aliasing -fno-common \
>  		   -Werror-implicit-function-declaration \
>  		   -Wno-format-security \
> -		   -fno-delete-null-pointer-checks
> +		   $(call cc-option,-fno-delete-null-pointer-checks,)
>  KBUILD_AFLAGS_KERNEL :=
>  KBUILD_CFLAGS_KERNEL :=
>  KBUILD_AFLAGS   := -D__ASSEMBLY__
> @@ -620,9 +635,24 @@ else
>  endif
>  KBUILD_CFLAGS += $(stackp-flag)
>  
> +ifeq ($(COMPILER),clang)
Except that COMPILER is used here. But this does not warrant the export.

> +KBUILD_CPPFLAGS += $(call cc-option,-Qunused-arguments,)
Is this really needed today?
https://bugzilla.mozilla.org/show_bug.cgi?id=717713 suggest that this is default.

> +KBUILD_CPPFLAGS += $(call cc-option,-Wno-unknown-warning-option,)
https://bugzilla.mozilla.org/show_bug.cgi?id=731316 seems to suggest this is default


> +KBUILD_CFLAGS += $(call cc-disable-warning, unused-variable)
> +KBUILD_CFLAGS += $(call cc-disable-warning, format-invalid-specifier)
> +KBUILD_CFLAGS += $(call cc-disable-warning, gnu)
Is it really justified to disable these warnings?
# of warnign for a defconfig build would be a nice figure to judge from.

> +# Quiet clang warning: comparison of unsigned expression < 0 is always false
> +KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
Same with this.

> +# CLANG uses a _MergedGlobals as optimization, but this breaks modpost, as the
> +# source of a reference will be _MergedGlobals and not on of the whitelisted names.
> +# See modpost pattern 2
> +KBUILD_CFLAGS += $(call cc-option, -mno-global-merge,)
Should we fix modpost?


	Sam
