Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaHKRk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:40:27 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:50404 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbaHKRkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:40:22 -0400
Date: Mon, 11 Aug 2014 12:40:18 -0500
From: Shaun Ruffell <sruffell@digium.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/15] purgatory: Core purgatory functionality
Message-ID: <20140811174017.GD12610@digium.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-12-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403814824-7587-12-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, it looks like the following patch (committed in
8fc5b4d4121c95482b2583) adds a new requirement to use at least gcc
4.4 to build the kernel?

On Thu, Jun 26, 2014 at 04:33:40PM -0400, Vivek Goyal wrote:
> Create a stand alone relocatable object purgatory which runs between two
> kernels. This name, concept and some code has been taken from kexec-tools.
> Idea is that this code runs after a crash and it runs in minimal environment.
> So keep it separate from rest of the kernel and in long term we will have
> to practically do no maintenance of this code.
> 
> This code also has the logic to do verify sha256 hashes of various
> segments which have been loaded into memory. So first we verify that
> the kernel we are jumping to is fine and has not been corrupted and
> make progress only if checsums are verified.
> 
> This code also takes care of copying some memory contents to backup region.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/Kbuild                   |   4 ++
>  arch/x86/Makefile                 |   8 +++
>  arch/x86/purgatory/Makefile       |  30 +++++++++++
>  arch/x86/purgatory/entry64.S      | 101 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/purgatory/purgatory.c    |  72 +++++++++++++++++++++++++++
>  arch/x86/purgatory/setup-x86_64.S |  58 ++++++++++++++++++++++
>  arch/x86/purgatory/stack.S        |  19 +++++++
>  arch/x86/purgatory/string.c       |  13 +++++
>  8 files changed, 305 insertions(+)
>  create mode 100644 arch/x86/purgatory/Makefile
>  create mode 100644 arch/x86/purgatory/entry64.S
>  create mode 100644 arch/x86/purgatory/purgatory.c
>  create mode 100644 arch/x86/purgatory/setup-x86_64.S
>  create mode 100644 arch/x86/purgatory/stack.S
>  create mode 100644 arch/x86/purgatory/string.c
> 

[snip]

> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> new file mode 100644
> index 0000000..e5829dd
> --- /dev/null
> +++ b/arch/x86/purgatory/Makefile
> @@ -0,0 +1,30 @@
> +purgatory-y := purgatory.o stack.o setup-x86_$(BITS).o sha256.o entry64.o string.o
> +
> +targets += $(purgatory-y)
> +PURGATORY_OBJS = $(addprefix $(obj)/,$(purgatory-y))
> +
> +LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined -nostdlib -z nodefaultlib
> +targets += purgatory.ro
> +
> +# Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
> +# in turn leaves some undefined symbols like __fentry__ in purgatory and not
> +# sure how to relocate those. Like kexec-tools, use custom flags.
> +
> +KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -MD -Os -mcmodel=large

The above "-mcmodel=large" compiler flag produces the following output on GCC 4.1.2.

  $ make modules_prepare ; gcc --version
    CHK     include/config/kernel.release
    CHK     include/generated/uapi/linux/version.h
    CHK     include/generated/utsrelease.h
    CC      arch/x86/purgatory/purgatory.o
  arch/x86/purgatory/purgatory.c:1: sorry, unimplemented: code model ‘large’ not supported yet
  make[1]: *** [arch/x86/purgatory/purgatory.o] Error 1
  make: *** [archprepare] Error 2
  gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-54)
  Copyright (C) 2006 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

I did a quick search for a discussion the indicates this compiler is now
officially too old to build the kernel but did not find one.

If this is required, maybe Documentation/Changes needs to be updated
with the new minimum required version?

Cheers,
Shaun
