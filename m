Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3IZKlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:41:04 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:53936 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3IZKlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:41:00 -0400
MIME-Version: 1.0
In-Reply-To: <1377073172-3662-3-git-send-email-richard@nod.at>
References: <1377073172-3662-1-git-send-email-richard@nod.at> <1377073172-3662-3-git-send-email-richard@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Thu, 26 Sep 2013 16:10:19 +0530
Message-ID: <CALkWK0kCrQ9hPABD_XQ9QFG-vByP+xZWZs+RkVK77+cX7Odz7g@mail.gmail.com>
Subject: Re: [PATCH 2/8] um: Do not use SUBARCH
To: Richard Weinberger <richard@nod.at>
Cc: linux-arch@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        geert@linux-m68k.org, ralf@linux-mips.org, lethal@linux-sh.org,
        Jeff Dike <jdike@addtoit.com>, gxt@mprc.pku.edu.cn,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-m68k@vger.kernel.org, linux-mips@linux-mips.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> This patch is based on: https://lkml.org/lkml/2013/7/4/396

This is the original patch I sent across in July.

> diff --git a/arch/um/Makefile b/arch/um/Makefile
> index 133f7de..5bc7892 100644
> --- a/arch/um/Makefile
> +++ b/arch/um/Makefile
> @@ -8,6 +8,8 @@
>
>  ARCH_DIR := arch/um
>  OS := $(shell uname -s)
> +OS_ARCH := $(shell uname -m)
> +
>  # We require bash because the vmlinux link and loader script cpp use bash
>  # features.
>  SHELL := /bin/bash
> @@ -20,15 +22,14 @@ core-y                      += $(ARCH_DIR)/kernel/          \
>
>  MODE_INCLUDE   += -I$(srctree)/$(ARCH_DIR)/include/shared/skas
>
> -HEADER_ARCH    := $(SUBARCH)
> -
> -# Additional ARCH settings for x86
> -ifeq ($(SUBARCH),i386)
> -        HEADER_ARCH := x86
> -endif
> -ifeq ($(SUBARCH),x86_64)
> -        HEADER_ARCH := x86
> -       KBUILD_CFLAGS += -mcmodel=large
> +# Currently we support only i386 and x86_64, if you port UML to another arch
> +# add another if branch...
> +ifeq ($(OS_ARCH),x86_64)
> +       HEADER_ARCH := x86
> +       KBUILD_DEFCONFIG := x86_64_defconfig
> +else
> +       HEADER_ARCH := x86
> +       KBUILD_DEFCONFIG := i386_defconfig
>  endif

I honestly don't get why this approach is superior to the original
one. In the original, I could set SUBARCH to whatever target
architecture and attempt to build user-mode Linux. Fact that it is
only implemented for i386 and x86_64 aside, keeping a SUBARCH means
that it's possible to build a 32-bit kernel on a 64-bit machine and
vice-versa. If you want stuff to work automagically (ie. in the 90%
case), you have to shell out to uname -m to figure out the host's real
architecture. Which both versions do sufficiently well.

Forget all that. What matters is that upstream is still broken, and
users are suffering. Despite a reasonable fix being submitted in July.
