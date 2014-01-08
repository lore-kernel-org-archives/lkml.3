Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbaAHUU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:20:26 -0500
Received: from zimbra.real-time.com ([63.170.91.9]:49683 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaAHUUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:20:21 -0500
Date: Thu, 9 Jan 2014 07:19:58 +1100
From: James Cameron <quozl@laptop.org>
To: falcon@meizu.com
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Mario Fetka <mario.fetka@gmail.com>
Subject: Re: [RFC PATCH V2] ARM: compressed: Move ramdisk forward to reserve
 more memory for kernel image
Message-ID: <20140108201958.GA3116@us.netrek.org>
References: <1389171405-19658-1-git-send-email-falcon@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389171405-19658-1-git-send-email-falcon@meizu.com>
Organization: Netrek Vanilla Server Dictator
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 04:56:45PM +0800, falcon@meizu.com wrote:
> From: Wu Zhangjin <falcon@meizu.com>
> 
> During embedded linux system booting, before decompressing the kernel image,
> the bootloader(E.g. Uboot) loads the compressed kernel image and ramdisk into
> two contiguous memory space, these two memory space are fixed after the Uboot
> is released, as a result, the maximum size of the decompressed kernel image is
> limited by the size of the reserved memory space (the difference of the two
> contiguous memory addresses).

This is not a problem for Open Firmware, which chooses an address for
the ramdisk based on the size of the kernel image, and there may be
other bootloaders that do the same, so an alternate wording may be:

"... before decompressing the kernel image, a bootloader loads the
compressed kernel image and ramdisk into two contiguous memory space,
these two memory space may be fixed after the bootloader is released,
..."

Speculation: you might also list versions of Uboot that are affected,
and whether there exists a version of Uboot that is unaffected, or if
it cannot be fixed due to a standard or specification.  I apologise
that I am ignorant of much of Uboot.

> If want more functions or some debug options, the decompressed kernel image
> may be bigger and may overwrite the followed ramdisk and result in kernel boot
> failure for missing a valid ramdisk.
> 
> To fix up this issue, before decompressing the kernel image, this option moves
> the loaded ramdisk image forward with a specified offset and reserve more
> memory for the decompressed kernel image.
> 
> --
> 
> v1-->v2:
> 
>   o Fix up ATAG_RAMDISK support
>   o Add phys base addr for ORION5X and KIRKWOOD
>   o Add an independent move_ramdisk.h, new board support can be added here.
> 
> TODO:
> 
>   o Add dtb support
> 
> Signed-off-by: Wu Zhangjin <falcon@meizu.com>
> ---
>  arch/arm/boot/compressed/Makefile       |    2 +-
>  arch/arm/boot/compressed/misc.c         |    7 +++-
>  arch/arm/boot/compressed/move_ramdisk.c |   61 +++++++++++++++++++++++++++++++
>  arch/arm/boot/compressed/move_ramdisk.h |   35 ++++++++++++++++++
>  usr/Kconfig                             |   29 +++++++++++++++
>  5 files changed, 131 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/boot/compressed/move_ramdisk.c
>  create mode 100644 arch/arm/boot/compressed/move_ramdisk.h
> 
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index bb26756..e4ef227 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -23,7 +23,7 @@ endif
>  
>  AFLAGS_head.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
>  HEAD	= head.o
> -OBJS	+= misc.o decompress.o
> +OBJS	+= misc.o decompress.o move_ramdisk.o
>  FONTC	= $(srctree)/drivers/video/console/font_acorn_8x8.c
>  
>  # string library code (-Os is enforced to keep it much smaller)
> diff --git a/arch/arm/boot/compressed/misc.c b/arch/arm/boot/compressed/misc.c
> index 8e2a8fc..df1df60 100644
> --- a/arch/arm/boot/compressed/misc.c
> +++ b/arch/arm/boot/compressed/misc.c
> @@ -22,7 +22,8 @@ unsigned int __machine_arch_type;
>  #include <linux/types.h>
>  #include <linux/linkage.h>
>  
> -static void putstr(const char *ptr);
> +extern void move_ramdisk(void);
> +extern void putstr(const char *ptr);
>  extern void error(char *x);
>  
>  #include <mach/uncompress.h>
> @@ -83,7 +84,7 @@ static void icedcc_putc(int ch)
>  #define putc(ch)	icedcc_putc(ch)
>  #endif
>  
> -static void putstr(const char *ptr)
> +void putstr(const char *ptr)
>  {
>  	char c;
>  
> @@ -144,6 +145,8 @@ decompress_kernel(unsigned long output_start, unsigned long free_mem_ptr_p,
>  
>  	arch_decomp_setup();
>  
> +	move_ramdisk();
> +
>  	putstr("Uncompressing Linux...");
>  	ret = do_decompress(input_data, input_data_end - input_data,
>  			    output_data, error);
> diff --git a/arch/arm/boot/compressed/move_ramdisk.c b/arch/arm/boot/compressed/move_ramdisk.c
> new file mode 100644
> index 0000000..b984433
> --- /dev/null
> +++ b/arch/arm/boot/compressed/move_ramdisk.c
> @@ -0,0 +1,61 @@
> +/*
> + * move_ramdisk.c
> + *
> + * Author: Wu Zhangjin, wuzhangjin@gmail.com, December 2013
> + * Copyright: (C) 2013 Meizu Telecom Equipment Co., Ltd
> + *
> + * Please get help of MOVE_RAMDISK from usr/Kconfig.
> + */
> +
> +
> +#include "move_ramdisk.h"
> +
> +extern void putstr(const char *ptr);
> +
> +void move_ramdisk(void)
> +{
> +#if defined(CONFIG_MOVE_RAMDISK) && defined(TAG_BASE_ADDR)
> +	struct tag *tags = (struct tag *)(TAG_BASE_ADDR);
> +	__u32 start, target, size;
> +	int found = 0, type = 0;
> +
> +	putstr("Searching ramdisk ...\n");
> +	if (tags->hdr.tag == ATAG_CORE) {
> +		putstr("Found tags ...\n");
> +		for (tags = tag_next(tags); tags->hdr.size; tags = tag_next(tags)) {
> +			if (tags->hdr.tag == ATAG_INITRD2) {
> +				putstr("Found initrd2 tag ...\n");
> +				found = 1;
> +				break;
> +			} else if (tags->hdr.tag == ATAG_INITRD) {
> +				putstr("Found initrd tag ...\n");
> +				found = 1;
> +				break;
> +			} else if (tags->hdr.tag == ATAG_RAMDISK) {
> +				putstr("Found ramdisk tag ...\n");
> +				found = 1;
> +				type = 1;
> +				break;
> +			}
> +		}
> +		if (found) {
> +			if (type == 0) {
> +				start = tags->u.initrd.start;
> +				size = tags->u.initrd.size;
> +				target = start + MOVE_RAMDISK_OFFSET;
> +				tags->u.initrd.start = target;
> +			} else {
> +				start = tags->u.ramdisk.start;
> +				size = tags->u.ramdisk.size;
> +				target = start + MOVE_RAMDISK_OFFSET;
> +				tags->u.ramdisk.start = target;
> +			}
> +
> +			putstr("Moving ramdisk forward ...\n");
> +			memcpy((char *)target, (char *)start, size + SIZE_FIXUP_OFFSET);
> +		}
> +	} else {
> +		putstr("No tag found ...\n");
> +	}
> +#endif
> +}
> diff --git a/arch/arm/boot/compressed/move_ramdisk.h b/arch/arm/boot/compressed/move_ramdisk.h
> new file mode 100644
> index 0000000..b824cde
> --- /dev/null
> +++ b/arch/arm/boot/compressed/move_ramdisk.h
> @@ -0,0 +1,35 @@
> +#ifndef _MOVE_RAMDISK_H
> +#define _MOVE_RAMDISK_H
> +
> +#include <asm/setup.h>
> +#include <asm/memory.h>
> +#include <asm/string.h>
> +
> +/* The physical base address of your platform, see PHYS_OFFSET */
> +#ifdef PLAT_PHYS_OFFSET
> +#define __PLAT_PHYS_OFFSET	(PLAT_PHYS_OFFSET)
> +#else
> +
> +#ifdef defined (CONFIG_ARCH_ORION5X) || defined (CONFIG_ARCH_KIRKWOOD)
> +#define __PLAT_PHYS_OFFSET    UL(0x00000000)
> +#else
> +#error "Please define __PLAT_PHYS_OFFSET, the physical base address of DRAM"
> +#endif
> +
> +#endif /* PLAT_PHYS_OFFSET */
> +
> +/* Most boards put tag at the offset 0x100 with the base PHYS_OFFSET */
> +#define TAG_BASE_OFFSET		(0x100)
> +
> +/* The tag address */
> +#ifdef __PLAT_PHYS_OFFSET
> +#define TAG_BASE_ADDR		(__PLAT_PHYS_OFFSET + TAG_BASE_OFFSET)
> +#endif
> +
> +/* Some old Uboot pass the wrong size to kernel, fix up it with an offset. */
> +#define SIZE_FIXUP_OFFSET	(1024)
> +
> +#define MOVE_RAMDISK_OFFSET	(CONFIG_MOVE_RAMDISK_OFFSET_M * 1024 * 1024)
> +#define tag_next(t)	((struct tag *)((__u32 *)(t) + (t)->hdr.size))
> +
> +#endif /* _MOVE_RAMDISK_H */
> diff --git a/usr/Kconfig b/usr/Kconfig
> index 65b845b..ad5ce5b 100644
> --- a/usr/Kconfig
> +++ b/usr/Kconfig
> @@ -166,3 +166,32 @@ config INITRAMFS_COMPRESSION_LZO
>  	  (both compression and decompression) is the fastest.
>  
>  endchoice
> +
> +config MOVE_RAMDISK
> +	bool "Move ramdisk forward to reserve more memory for kernel image"
> +	depends on ARM
> +	help
> +	  During embedded linux system booting, before decompressing the kernel
> +	  image, the bootloader(E.g. Uboot) loads the compressed kernel image
> +	  and ramdisk into two contiguous memory space, these two memory space
> +	  are fixed after the Uboot is released, as a result, the maximum size
> +	  of the decompressed kernel image is limited by the size of the
> +	  reserved memory space (the difference of the two contiguous memory
> +	  addresses).

Same here.

> +
> +	  If want more functions or some debug options, the decompressed kernel
> +	  image may be bigger and may override the followed ramdisk and result
> +	  in kernel boot failure for missing a valid ramdisk.
> +
> +	  To fix up this issue, before decompressing the kernel image, this
> +	  option moves the loaded ramdisk image forward with a specified offset
> +	  and reserve more memory for the decompressed kernel image.
> +
> +config MOVE_RAMDISK_OFFSET_M
> +	int "Set the move offset of ramdisk (in Mbytes)"
> +	range 5 100
> +	default "20"
> +	depends on MOVE_RAMDISK
> +	help
> +	  Specify the move offset of the ramdisk, if want a bigger kernel, please
> +	  Increase this size.
> -- 
> 1.7.10.4

-- 
James Cameron
http://quozl.linux.org.au/
