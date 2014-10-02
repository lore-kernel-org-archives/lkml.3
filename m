Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaJBNjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:39:15 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40555 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaJBNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:39:12 -0400
Date: Thu, 2 Oct 2014 14:38:57 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Pinski <apinski@cavium.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pinskia@gmail.com" <pinskia@gmail.com>
Subject: Re: [PATCH 18/24] ARM64: Add vdso for ILP32 and use it for the
 signal return
Message-ID: <20141002133857.GD32147@e104818-lin.cambridge.arm.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com>
 <1409779158-30963-19-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409779158-30963-19-git-send-email-apinski@cavium.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 10:19:12PM +0100, Andrew Pinski wrote:
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index f47c064..5311147 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -242,6 +242,10 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
> 
>         if (ka->sa.sa_flags & SA_RESTORER)
>                 sigtramp = ka->sa.sa_restorer;
> +#ifdef CONFIG_ARM64_ILP32
> +       else if (is_ilp32_compat_task())
> +               sigtramp = VDSO_SYMBOL(current->mm->context.vdso, sigtramp_ilp32);
> +#endif

Could we avoid the #ifdef here given that is_ilp32_compat_task() returns
0 when !CONFIG_ARM64_ILP32? I haven't tried to compile it.

> diff --git a/arch/arm64/kernel/vdso-ilp32/Makefile b/arch/arm64/kernel/vdso-ilp32/Makefile
> new file mode 100644
> index 0000000..c8f5472
> --- /dev/null
> +++ b/arch/arm64/kernel/vdso-ilp32/Makefile

Do we expect so many ILP32 files as to use a separate vdso-ilp32
directory? I prefer a single vdso directory.

> @@ -0,0 +1,72 @@
> +#
> +# Building a vDSO image for AArch64.
> +#
> +# Author: Will Deacon <will.deacon@arm.com>
> +# Heavily based on the vDSO Makefiles for other archs.
> +#
> +
> +obj-ilp32-vdso := gettimeofday-ilp32.o note-ilp32.o sigreturn-ilp32.o
> +
> +# Build rules
> +targets := $(obj-ilp32-vdso) vdso-ilp32.so vdso-ilp32.so.dbg
> +obj-ilp32-vdso := $(addprefix $(obj)/, $(obj-ilp32-vdso))
> +
> +ccflags-y := -shared -fno-common -fno-builtin
> +ccflags-y += -nostdlib -Wl,-soname=linux-ilp32-vdso.so.1 \
> +               $(call cc-ldoption, -Wl$(comma)--hash-style=sysv)
> +
> +obj-y += vdso-ilp32.o
> +extra-y += vdso-ilp32.lds vdso-ilp32-offsets.h
> +CPPFLAGS_vdso-ilp32.lds += -P -C -U$(ARCH) -mabi=ilp32
> +
> +# Force dependency (incbin is bad)
> +$(obj)/vdso-ilp32.o : $(obj)/vdso-ilp32.so
> +
> +# Link rule for the .so file, .lds has to be first
> +$(obj)/vdso-ilp32.so.dbg: $(src)/vdso-ilp32.lds $(obj-ilp32-vdso)
> +       $(call if_changed,vdso-ilp32ld)
> +
> +# Strip rule for the .so file
> +$(obj)/%.so: OBJCOPYFLAGS := -S
> +$(obj)/%.so: $(obj)/%.so.dbg FORCE
> +       $(call if_changed,objcopy)
> +
> +# Generate VDSO offsets using helper script
> +gen-vdsosym := $(srctree)/$(src)/../vdso/gen_vdso_offsets.sh
> +quiet_cmd_vdsosym = VDSOSYM $@
> +define cmd_vdsosym
> +       $(NM) $< | $(gen-vdsosym) | LC_ALL=C sort > $@ && \
> +       cp $@ include/generated/
> +endef
> +
> +$(obj)/vdso-ilp32-offsets.h: $(obj)/vdso-ilp32.so.dbg FORCE
> +       $(call if_changed,vdsosym)
> +
> +# Assembly rules for the .S files
> +#$(obj-ilp32-vdso): %.o: $(src)/../vdso/$(subst -ilp32,,%.S)
> +#      $(call if_changed_dep,vdso-ilp32as)
> +
> +$(obj)/gettimeofday-ilp32.o: $(src)/../vdso/gettimeofday.S
> +       $(call if_changed_dep,vdso-ilp32as)
> +
> +$(obj)/note-ilp32.o: $(src)/../vdso/note.S
> +       $(call if_changed_dep,vdso-ilp32as)
> +
> +$(obj)/sigreturn-ilp32.o: $(src)/../vdso/sigreturn.S
> +       $(call if_changed_dep,vdso-ilp32as)

So we don't even need many new files, just different compiler flags.

> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> index a777ac3..21b3726 100644
> --- a/arch/arm64/kernel/vdso.c
> +++ b/arch/arm64/kernel/vdso.c
> @@ -41,6 +41,12 @@ extern char vdso_start, vdso_end;
>  static unsigned long vdso_pages;
>  static struct page **vdso_pagelist;
> 
> +#ifdef CONFIG_ARM64_ILP32
> +extern char vdso_ilp32_start, vdso_ilp32_end;
> +static unsigned long vdso_ilp32_pages;
> +static struct page **vdso_ilp32_pagelist;
> +#endif

I think the compiler could optimise away some of these and avoid the
#ifdef (similarly in the code where we check for
is_ilp32_compat_task()).

-- 
Catalin
