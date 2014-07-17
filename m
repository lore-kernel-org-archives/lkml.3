Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaGQJfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:35:25 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:34351 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaGQJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:35:19 -0400
Date: Thu, 17 Jul 2014 11:35:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 29/29] nios2: Build infrastructure
Message-ID: <20140717093514.GA15755@ravnborg.org>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
 <1405413956-2772-30-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405413956-2772-30-git-send-email-lftan@altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ley.

Looks much better than last time I reviewed this.
A bunch of small comments follows.

	Sam

> diff --git a/arch/nios2/Makefile b/arch/nios2/Makefile
> new file mode 100644
> index 0000000..62b789a
> --- /dev/null
> +++ b/arch/nios2/Makefile
> @@ -0,0 +1,78 @@
> +#
> +# This file is subject to the terms and conditions of the GNU General Public
> +# License.  See the file "COPYING" in the main directory of this archive
> +# for more details.
> +#
> +# Copyright (C) 2013 Altera Corporation
> +# Copyright (C) 1994, 95, 96, 2003 by Wind River Systems
> +# Written by Fredrik Markstrom
> +#
> +# This file is included by the global makefile so that you can add your own
> +# architecture-specific flags and dependencies. Remember to do have actions
> +# for "archclean" cleaning up for this architecture.
> +#
> +# Nios2 port by Wind River Systems Inc trough:
> +#   fredrik.markstrom@gmail.com and ivarholmqvist@gmail.com
> +
> +UTS_SYSNAME = Linux
> +
> +export MMU
> +
> +cflags-y :=
> +LDFLAGS		:=
> +LDFLAGS_vmlinux	:=
These assignments are not needed.


> +
> +LIBGCC		:= $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
> +
> +KBUILD_AFLAGS += $(cflags-y)
This is nop since $(cflags-y) is empty.

> +KBUILD_CFLAGS += -pipe -D__linux__ -D__ELF__ $(cflags-y)
Here the $(cflags-y) can be dropped too.

> +INSTALL_PATH ?= /tftpboot
> +boot := arch/$(ARCH)/boot
In all other places you spell out nios2 - so do it here too.


> +BOOT_TARGETS = vmImage zImage
> +PHONY += $(BOOT_TARGETS) install
> +KBUILD_IMAGE := $(boot)/vmImage
> +
> +ifneq ($(CONFIG_NIOS2_DTB_SOURCE),"")
> +	core-y	+= $(boot)/
> +endif
> +
> +all: vmImage
> +
> +archclean:
> +	$(Q)$(MAKE) $(clean)=$(boot)
> +
> +%.dtb:
> +	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
> +
> +dtbs:
> +	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
> +
> +$(BOOT_TARGETS): vmlinux
> +	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
> +
> +install:
> +	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
> +
> +define archhelp
> +  echo  '* vmImage         - Kernel-only image for U-Boot (arch/$(ARCH)/boot/vmImage)'


> +  echo  '  install         - Install kernel using'
> +  echo  '                     (your) ~/bin/$(CROSS_COMPILE)installkernel or'
> +  echo  '                     (distribution) PATH: $(CROSS_COMPILE)installkernel or'
> +  echo  '                     install to $$(INSTALL_PATH)'
Is this explanation true for nios2?
I could not check because the install.sh script was not included.

> +  echo  '  dtbs            - Build device tree blobs for enabled boards'
> +endef

> diff --git a/arch/nios2/boot/Makefile b/arch/nios2/boot/Makefile
> new file mode 100644
> index 0000000..35c80e8
> --- /dev/null
> +++ b/arch/nios2/boot/Makefile
> @@ -0,0 +1,52 @@
> +#
> +# arch/nios2/boot/Makefile
> +#
> +# This file is subject to the terms and conditions of the GNU General Public
> +# License.  See the file "COPYING" in the main directory of this archive
> +# for more details.
> +#
> +
> +UIMAGE_LOADADDR = $(shell $(NM) vmlinux | awk '$$NF == "_stext" {print $$1}')
> +UIMAGE_ENTRYADDR = $(shell $(NM) vmlinux | awk '$$NF == "_start" {print $$1}')
> +UIMAGE_COMPRESSION = gzip
> +
> +OBJCOPYFLAGS_vmlinux.bin := -O binary
> +
> +targets += vmlinux.bin vmlinux.gz vmImage
> +
> +$(obj)/vmlinux.bin: vmlinux FORCE
> +	$(call if_changed,objcopy)
> +
> +$(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
> +	$(call if_changed,gzip)
> +
> +$(obj)/vmImage: $(obj)/vmlinux.gz
> +	$(call if_changed,uimage)
> +	@$(kecho) 'Kernel: $@ is ready'
> +
> +# Rule to build device tree blobs
> +DTB_SRC := $(subst ",,$(CONFIG_NIOS2_DTB_SOURCE))
If you use: 
   $(patsubst "%"

Then my editor get less confused. This is also what is used
for similar purposes for other architectures.

> +
> +# Make sure the generated dtb gets removed during clean
> +extra-$(CONFIG_NIOS2_DTB_SOURCE_BOOL) += system.dtb
This is not needed as you cover this with the assignmnet to clean-files later in this file.

> +
> +$(obj)/system.dtb: $(DTB_SRC) FORCE
> +	$(call cmd,dtc)
> +
> +# Ensure system.dtb exists
> +$(obj)/linked_dtb.o: $(obj)/system.dtb
> +
> +obj-$(CONFIG_NIOS2_DTB_SOURCE_BOOL) += linked_dtb.o
> +
> +targets += $(dtb-y)
> +
> +# Rule to build device tree blobs with make command
> +$(obj)/%.dtb: $(src)/dts/%.dts FORCE
> +	$(call if_changed_dep,dtc)
> +
> +$(obj)/dtbs: $(addprefix $(obj)/, $(dtb-y))
> +
> +clean-files := *.dtb
> +
> +install:
> +	sh $(srctree)/$(src)/install.sh $(KERNELRELEASE) $(BOOTIMAGE) System.map "$(INSTALL_PATH)"

The install.sh script is not included (or I did not find it).


> diff --git a/arch/nios2/include/asm/Kbuild b/arch/nios2/include/asm/Kbuild
> new file mode 100644
> index 0000000..dfe7a79
> --- /dev/null
> +++ b/arch/nios2/include/asm/Kbuild
> @@ -0,0 +1,67 @@
> +include include/asm-generic/Kbuild.asm
The above include is wrong - please drop it.


> +header-y += ucontext.h
> +header-y += traps.h
We no longer visit include/asm for exported hedaders.
So the two assignments above are not used.

You will likely move them to arch/nios2/include/uapi/asm/Kbuild to
let them be exported.

