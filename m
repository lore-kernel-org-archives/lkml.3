Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaKGMKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:10:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43680 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbaKGMKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:10:09 -0500
Date: Fri, 7 Nov 2014 12:09:33 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Alban Bedel <albeu@free.fr>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH] OF: Add support for built in FDT blob
Message-ID: <20141107120933.GA5487@leverpostej>
References: <1415358849-25879-1-git-send-email-albeu@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415358849-25879-1-git-send-email-albeu@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 07, 2014 at 11:14:09AM +0000, Alban Bedel wrote:
> Allow embedding an FDT blob in the kernel image, this is mostly
> useful to run new kernels on boards with old bootloaders.

I am very much not keen on embedding a DTB within a kernel. It's far
nicer for the two to remain separate blobs, with a small shim to set up
the DTB address.

On ARM we have appended DTB for this purpose, which is at least better
than embedding the DT inside of the kernel.

What architecture and bootloader are you using that necessitate this?

Thanks,
Mark.

> Signed-off-by: Alban Bedel <albeu@free.fr>
> ---
>  drivers/of/Kconfig    | 16 ++++++++++++++++
>  drivers/of/Makefile   |  8 ++++++++
>  drivers/of/fdt.c      |  8 ++++++++
>  drivers/of/fdt_blob.S | 17 +++++++++++++++++
>  4 files changed, 49 insertions(+)
>  create mode 100644 drivers/of/fdt_blob.S
> 
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 1a13f5b..97c5d18 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -83,4 +83,20 @@ config OF_RESERVED_MEM
>  config OF_RESOLVE
>  	bool
>  
> +config OF_BUILTIN_FDT
> +	bool "Include a FDT blob in the kernel"
> +	help
> +	  Include a FDT blob in the kernel to use as default when
> +	  no blob has been passed by the bootloader. This is useful
> +	  to use devicetree on boards with old bootloaders.
> +
> +	  If unsure, say N.
> +
> +config OF_BUILTIN_FDT_BLOB
> +	string "FDT Blob name"
> +	depends on OF_BUILTIN_FDT
> +	help
> +	  Name of the FDT blob to build in the kernel, from one of the
> +	  dtbs available for the current platform.
> +
>  endmenu # OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index ca9209c..b96c6e9 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -14,6 +14,14 @@ obj-$(CONFIG_OF_PCI_IRQ)  += of_pci_irq.o
>  obj-$(CONFIG_OF_MTD)	+= of_mtd.o
>  obj-$(CONFIG_OF_RESERVED_MEM) += of_reserved_mem.o
>  obj-$(CONFIG_OF_RESOLVE)  += resolver.o
> +obj-$(CONFIG_OF_BUILTIN_FDT) += fdt_blob.o
>  
>  CFLAGS_fdt.o = -I$(src)/../../scripts/dtc/libfdt
>  CFLAGS_fdt_address.o = -I$(src)/../../scripts/dtc/libfdt
> +
> +# The FDT blob to include
> +FDT_BLOB := arch/$(ARCH)/boot/dts/$(CONFIG_OF_BUILTIN_FDT_BLOB:"%"=%).dtb
> +# Undefine ARCH to avoid breaking the FDT path
> +AFLAGS_fdt_blob.o += -U$(ARCH) -DFDT_BLOB=$(FDT_BLOB)
> +# This dependency can't be automatically tracked
> +$(obj)/fdt_blob.o: $(obj)/../../$(FDT_BLOB)
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index d1ffca8..ffb86a7 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -26,6 +26,9 @@
>  #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
>  #include <asm/page.h>
>  
> +extern char __fdt_blob_start[];
> +extern unsigned long __fdt_blob_size;
> +
>  /*
>   * of_fdt_limit_memory - limit the number of regions in the /memory node
>   * @limit: maximum entries
> @@ -1064,6 +1067,11 @@ void __init unflatten_and_copy_device_tree(void)
>  	int size;
>  	void *dt;
>  
> +#ifdef CONFIG_OF_BUILTIN_FDT
> +	if (!initial_boot_params && __fdt_blob_size > 0)
> +		initial_boot_params = __fdt_blob_start;
> +#endif
> +
>  	if (!initial_boot_params) {
>  		pr_warn("No valid device tree found, continuing without\n");
>  		return;
> diff --git a/drivers/of/fdt_blob.S b/drivers/of/fdt_blob.S
> new file mode 100644
> index 0000000..fcaa2aa
> --- /dev/null
> +++ b/drivers/of/fdt_blob.S
> @@ -0,0 +1,17 @@
> +#include <linux/stringify.h>
> +#include <asm-generic/vmlinux.lds.h>
> +
> +.align 4
> +.section .init.fdt_blob,"a"
> +.globl VMLINUX_SYMBOL(__fdt_blob_start)
> +VMLINUX_SYMBOL(__fdt_blob_start):
> +.incbin __stringify(FDT_BLOB)
> +__fdt_blob_end:
> +.section .init.fdt_blob.info,"a"
> +.globl VMLINUX_SYMBOL(__fdt_blob_size)
> +VMLINUX_SYMBOL(__fdt_blob_size):
> +#ifdef CONFIG_64BIT
> +        .quad __fdt_blob_end - __fdt_blob_start
> +#else
> +        .long __fdt_blob_end - __fdt_blob_start
> +#endif
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
