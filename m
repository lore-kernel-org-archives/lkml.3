Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaDROgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:36:04 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:46320 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaDROf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:35:59 -0400
Date: Fri, 18 Apr 2014 16:35:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH 01/28] nios2: Build infrastructure
Message-ID: <20140418143553.GB8589@ravnborg.org>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
 <1397824031-4892-2-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397824031-4892-2-git-send-email-lftan@altera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 08:26:48PM +0800, Ley Foon Tan wrote:
> This patch adds Makefile and Kconfig files required for building a
> nios2 kernel.

It is good practice to add build infrastructure last - so build is not broken.
But for a new architecture it matters only little.

Some comments in the following.

	Sam
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
> 
> diff --git a/arch/nios2/Kconfig b/arch/nios2/Kconfig
> new file mode 100644
> index 0000000..2bd0d0d7160f31a5c5890cf8a059b9f53378be6e
> --- /dev/null
> +++ b/arch/nios2/Kconfig
> @@ -0,0 +1,213 @@
> +config NIOS2
> +	def_bool y
> +	select OF
> +	select OF_EARLY_FLATTREE
> +	select USB_ARCH_HAS_HCD if USB_SUPPORT
> +	select ARCH_WANT_OPTIONAL_GPIOLIB
> +	select GENERIC_IRQ_PROBE
> +	select GENERIC_IRQ_SHOW
> +	select GENERIC_CPU_DEVICES
> +	select GENERIC_ATOMIC64
> +	select MODULES_USE_ELF_RELA
> +	select IRQ_DOMAIN
> +	select SOC_BUS
> +	select CLKSRC_OF
If you keep this list sorted then merge issues are less likely.

> +menu "Advanced setup"
> +
> +config ADVANCED_OPTIONS
> +	bool "Prompt for advanced kernel configuration options"
> +	help
> +
> +comment "Default settings for advanced configuration options are used"
> +	depends on !ADVANCED_OPTIONS
> +
> +config KERNEL_MMU_REGION_BASE_BOOL
> +	bool "Set custom kernel MMU region base address"
> +	depends on ADVANCED_OPTIONS
> +	help
> +	  This option allows you to set the virtual address of the kernel MMU region.
> +
> +	  Say N here unless you know what you are doing.

All Nios2 specific options should be prefixed with NIOS2_
This is what is done for all new arch specific symbols.

> diff --git a/arch/nios2/boot/Makefile b/arch/nios2/boot/Makefile
> new file mode 100644
> index 0000000..00aef5e266f9cc629f126445535f9aae6ca8962f
> --- /dev/null
> +++ b/arch/nios2/boot/Makefile
> @@ -0,0 +1,51 @@
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
> +$(obj)/vmlinux.bin: vmlinux FORCE
> +	$(call if_changed,objcopy)
> +
> +$(obj)/vmlinux.gz: $(obj)/vmlinux.bin FORCE
> +	$(call if_changed,gzip)
> +
> +$(obj)/vmImage: $(obj)/vmlinux.gz
> +	$(call if_changed,uimage)
> +	@$(kecho) 'Kernel: $@ is ready'

Add:
targets += vmlinux.bin vmlinux.gz vmImage
to make $(call if_changed ... actually work.


> +obj-y += cpuinfo.o insnemu.o irq.o nios2_ksyms.o process.o prom.o ptrace.o \
> +	 setup.o signal.o sys_nios2.o syscall_table.o time.o traps.o

In new stuff try to avoid using ... \
to contatenate lines.
Use:
obj-y += xxx

This is much more readable.

