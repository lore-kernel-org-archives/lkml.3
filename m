Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030449AbaDJREG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:04:06 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:50035 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030428AbaDJREE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:04:04 -0400
Date: Thu, 10 Apr 2014 13:03:59 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
cc: Russell King <linux@arm.linux.org.uk>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        linaro-networking@linaro.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: zImage: ensure header in LE format for BE8
 kernels
In-Reply-To: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org>
Message-ID: <alpine.LFD.2.11.1404101302380.980@knanqh.ubzr>
References: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014, Taras Kondratiuk wrote:

> From: Nico Pitre <nico@fluxnic.net>

Please use "Nicolas Pitre" as my full name.

> All known BE8-capable systems have LE bootloaders, so we need to ensure
> that the magic number and image start/end values are in little endian
> format.
> 
> [ben.dooks@codethink.co.uk: from nico's original email on this subject]
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> [taras.kondratiuk@linaro.org: removed lds.S->lds rule, added target to extra-y]
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---
> Nico, should I add your Signed-off-by?

Sure.

> 
> Discussion about the patch:
> http://www.spinics.net/lists/arm-kernel/msg320670.html
> 
> Based on v3.14+ master commit 39de65aa2c3eee901db020a4f1396998e09602a3
> 
>  arch/arm/boot/compressed/.gitignore     |    1 +
>  arch/arm/boot/compressed/Makefile       |    4 ++--
>  arch/arm/boot/compressed/head.S         |    7 ++++---
>  arch/arm/boot/compressed/vmlinux.lds.in |   14 ++++++++++++++
>  4 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/boot/compressed/.gitignore b/arch/arm/boot/compressed/.gitignore
> index 0714e03..6a26e7b 100644
> --- a/arch/arm/boot/compressed/.gitignore
> +++ b/arch/arm/boot/compressed/.gitignore
> @@ -10,6 +10,7 @@ piggy.xzkern
>  piggy.lz4
>  vmlinux
>  vmlinux.lds
> +vmlinux.lds.S
>  
>  # borrowed libfdt files
>  fdt.c
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index 68c9183..8a80906 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -114,7 +114,7 @@ targets       := vmlinux vmlinux.lds \
>  # Make sure files are removed during clean
>  extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern piggy.lz4 \
>  		 lib1funcs.S ashldi3.S bswapsdi2.S $(libfdt) $(libfdt_hdrs) \
> -		 hyp-stub.S
> +		 hyp-stub.S vmlinux.lds.S
>  
>  ifeq ($(CONFIG_FUNCTION_TRACER),y)
>  ORIG_CFLAGS := $(KBUILD_CFLAGS)
> @@ -199,7 +199,7 @@ CFLAGS_font.o := -Dstatic=
>  $(obj)/font.c: $(FONTC)
>  	$(call cmd,shipped)
>  
> -$(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile $(KCONFIG_CONFIG)
> +$(obj)/vmlinux.lds.S: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile $(KCONFIG_CONFIG)
>  	@sed "$(SEDFLAGS)" < $< > $@
>  
>  $(obj)/hyp-stub.S: $(srctree)/arch/$(SRCARCH)/kernel/hyp-stub.S
> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
> index 066b034..8ea1773 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -130,9 +130,10 @@ start:
>   THUMB(		adr	r12, BSYM(1f)	)
>   THUMB(		bx	r12		)
>  
> -		.word	0x016f2818		@ Magic numbers to help the loader
> -		.word	start			@ absolute load/run zImage address
> -		.word	_edata			@ zImage end address
> +		.word	_magic_sig	@ Magic numbers to help the loader
> +		.word	_magic_start	@ absolute load/run zImage address
> +		.word	_magic_end	@ zImage end address
> +
>   THUMB(		.thumb			)
>  1:
>   ARM_BE8(	setend	be )			@ go BE8 if compiled for BE8
> diff --git a/arch/arm/boot/compressed/vmlinux.lds.in b/arch/arm/boot/compressed/vmlinux.lds.in
> index 4919f2a..6016223 100644
> --- a/arch/arm/boot/compressed/vmlinux.lds.in
> +++ b/arch/arm/boot/compressed/vmlinux.lds.in
> @@ -7,6 +7,16 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> +
> +#ifdef CONFIG_CPU_ENDIAN_BE8
> +#define ZIMAGE_MAGIC(x) ( (((x) >> 24) & 0x000000ff) | \
> +			  (((x) >>  8) & 0x0000ff00) | \
> +			  (((x) <<  8) & 0x00ff0000) | \
> +			  (((x) << 24) & 0xff000000) )
> +#else
> +#define ZIMAGE_MAGIC(x) (x)
> +#endif
> +
>  OUTPUT_ARCH(arm)
>  ENTRY(_start)
>  SECTIONS
> @@ -57,6 +67,10 @@ SECTIONS
>    .pad			: { BYTE(0); . = ALIGN(8); }
>    _edata = .;
>  
> +  _magic_sig = ZIMAGE_MAGIC(0x016f2818);
> +  _magic_start = ZIMAGE_MAGIC(_start);
> +  _magic_end = ZIMAGE_MAGIC(_edata);
> +
>    . = BSS_START;
>    __bss_start = .;
>    .bss			: { *(.bss) }
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
