Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3JJR2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:28:50 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56889 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3JJR2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:28:48 -0400
Date: Thu, 10 Oct 2013 19:28:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH] x86/efi: Add EFI framebuffer earlyprintk support
Message-ID: <20131010172844.GA26430@gmail.com>
References: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381423261-30566-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> From: Matt Fleming <matt.fleming@intel.com>
> 
> It's incredibly difficult to diagnose early EFI boot issues without
> special hardware because earlyprintk=vga doesn't work on EFI systems.
> 
> Add support for writing to the EFI framebuffer, via earlyprintk=efi,
> which will actually give users a chance of providing debug output.
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Jones <pjones@redhat.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Very nice patch!

Some (mostly minor) nits:

> ---
>  Documentation/kernel-parameters.txt  |   8 +-
>  arch/x86/Kconfig.debug               |   9 ++
>  arch/x86/include/asm/efi.h           |   2 +
>  arch/x86/kernel/early_printk.c       |   7 ++
>  arch/x86/platform/efi/Makefile       |   1 +
>  arch/x86/platform/efi/early_printk.c | 166 +++++++++++++++++++++++++++++++++++
>  6 files changed, 190 insertions(+), 3 deletions(-)
>  create mode 100644 arch/x86/platform/efi/early_printk.c
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index fcbb736..c07cb09 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -847,6 +847,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  
>  	earlyprintk=	[X86,SH,BLACKFIN,ARM]
>  			earlyprintk=vga
> +			earlyprintk=efi
>  			earlyprintk=xen
>  			earlyprintk=serial[,ttySn[,baudrate]]
>  			earlyprintk=serial[,0x...[,baudrate]]
> @@ -860,7 +861,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Append ",keep" to not disable it when the real console
>  			takes over.
>  
> -			Only vga or serial or usb debug port at a time.
> +			Only one of vga, efi, serial, or usb debug port can
> +			be used at a time.
>  
>  			Currently only ttyS0 and ttyS1 may be specified by
>  			name.  Other I/O ports may be explicitly specified
> @@ -874,8 +876,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Interaction with the standard serial driver is not
>  			very good.
>  
> -			The VGA output is eventually overwritten by the real
> -			console.
> +			The VGA and EFI output is eventually overwritten by
> +			the real console.
>  
>  			The xen output can only be used by Xen PV guests.
>  
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 78d91af..d05df92 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -59,6 +59,15 @@ config EARLY_PRINTK_DBGP
>  	  with klogd/syslogd or the X server. You should normally N here,
>  	  unless you want to debug such a crash. You need usb debug device.
>  
> +config EARLY_PRINTK_EFI
> +	bool "Early printk via EFI framebuffer"

s/via the EFI framebuffer

?

> +	depends on EFI && EARLY_PRINTK && FONT_SUPPORT
> +	---help---
> +	  Write kernel log output directly into the EFI framebuffer.
> +
> +	  This is useful for kernel debugging when your machine crashes very
> +	  early before the console code is initialized.
> +
>  config X86_PTDUMP
>  	bool "Export kernel pagetable layout to userspace via debugfs"
>  	depends on DEBUG_KERNEL
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 0062a01..65c6e6e 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -109,6 +109,8 @@ static inline bool efi_is_native(void)
>  	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
>  }
>  
> +extern struct console early_efi_console;
> +
>  #else
>  /*
>   * IF EFI is not configured, have the EFI calls return -ENOSYS.
> diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
> index d15f575..6d3d200 100644
> --- a/arch/x86/kernel/early_printk.c
> +++ b/arch/x86/kernel/early_printk.c
> @@ -17,6 +17,8 @@
>  #include <asm/mrst.h>
>  #include <asm/pgtable.h>
>  #include <linux/usb/ehci_def.h>
> +#include <linux/efi.h>
> +#include <asm/efi.h>

Given that linux/efi.h does not include asm/efi.h (in purpose I suppose), 
asm/efi.h could include linux/efi.h and avoid the duplication thusly.

>  
>  /* Simple VGA output */
>  #define VGABASE		(__ISA_IO_base + 0xb8000)
> @@ -234,6 +236,11 @@ static int __init setup_early_printk(char *buf)
>  			early_console_register(&early_hsu_console, keep);
>  		}
>  #endif
> +#ifdef CONFIG_EARLY_PRINTK_EFI
> +		if (!strncmp(buf, "efi", 3))
> +			early_console_register(&early_efi_console, keep);
> +#endif
> +
>  		buf++;
>  	}
>  	return 0;
> diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
> index 6db1cc4..b7b0b35 100644
> --- a/arch/x86/platform/efi/Makefile
> +++ b/arch/x86/platform/efi/Makefile
> @@ -1,2 +1,3 @@
>  obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
>  obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
> +obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
> diff --git a/arch/x86/platform/efi/early_printk.c b/arch/x86/platform/efi/early_printk.c
> new file mode 100644
> index 0000000..bfe597b
> --- /dev/null
> +++ b/arch/x86/platform/efi/early_printk.c
> @@ -0,0 +1,166 @@
> +/*
> + * Copyright (C) 2013 Intel Corporation; author Matt Fleming
> + *
> + *  This file is part of the Linux kernel, and is made available under
> + *  the terms of the GNU General Public License version 2.
> + */
> +
> +#include <linux/console.h>
> +#include <linux/font.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <asm/setup.h>

Does this want to include asm/efi.h, to make sure the definition of 
early_efi_console matches?

> +static const struct font_desc *font;
> +
> +static void early_efi_clear_line(int y)
> +{
> +	unsigned long base, *dst;
> +	u16 len;
> +
> +	base = boot_params.screen_info.lfb_base;
> +	len = boot_params.screen_info.lfb_linelength;
> +
> +	dst = early_ioremap(base + (y * len), len);

that really wants to be:

	dst = early_ioremap(base + y*len, len);

as the precedence is clear.

Btw., could we perhaps remap the whole framebuffer at init time, or is it 
too large? If early_ioremap() fails for whatever reason then that will 
emit a WARN_ON(), which will recurse in a fairly nasty way ...

> +	if (!dst)
> +		return;
> +
> +	memset(dst, 0, len);
> +	early_iounmap(dst, len);
> +}
> +
> +static __init void early_efi_clear_screen(void)
> +{
> +	struct screen_info *si;
> +	int y;
> +
> +	si = &boot_params.screen_info;
> +	for (y = 0; y < si->lfb_height; y++)
> +		early_efi_clear_line(y);

Looks a bit superfluous to introduce 'si' just for that single use?

> +}
> +
> +static void early_efi_write_char(void *dst, char c, int h)
> +{
> +	const u8 *src;
> +	u32 fgcolor = 0xaaaaaa;

That's RGB grey, right? Why not 0xffffff for a very visible white?

> +	u8 s8;
> +	int m;
> +
> +	src = font->data + (c * font->height);

here too the multiplication does not need parantheses.

> +	s8 = *(src + h);

We normally only care about the ASCII range, but doesn't 'c' want to be 
'unsigned char', to make sure we do the right thing, should anyone use 
above 0x7f characters in printk, accidentally or intentionally?

> +
> +	for (m = 0; m < 8; m++) {
> +		u32 val, mask = 0;
> +
> +		if ((s8 >> (7 - m)) & 1)
> +			mask = 0xffffffff;
> +
> +		val = mask & fgcolor;

Hm, because this is really about 32-bit pixel framebuffer, is that mask 
code a _really_ roundabout way of saying:

	const u32 color_grey  = 0x00aaaaaa;
	const u32 color_black = 0x00000000;
	...

		if ((s8 >> (7 - m)) & 1)
			pixel = color_grey;
		else
			pixel = color_black;

		*dst = pixel;

?

> +		memcpy(dst, &val, 4);

Also, why not pass in dst as 'u32 *' and replace the memcpy with:

		*dst = val;

?

> +		dst += 4;

and this with:

		dst++;

?

> +	}
> +}
> +
> +static uint32_t efi_x, efi_y;

These globals might make sense at the top of the file.

Also, in kernel code we prefer to write 'u32' or 'unsigned int', not 
uint32_t - like you do in many other places within this patch.

> +
> +static __init void
> +early_efi_write(struct console *con, const char *str, unsigned int num)
> +{
> +	struct screen_info *si;
> +	unsigned long base;
> +	unsigned int len;
> +	const char *s;
> +	void *dst;
> +
> +	base = boot_params.screen_info.lfb_base;
> +	si = &boot_params.screen_info;
> +	len = si->lfb_linelength;
> +
> +	while (num) {
> +		unsigned int linemax;
> +		int h, count = 0;
> +
> +		for (s = str; *s && *s != '\n'; s++) {
> +			if (count == num)
> +				break;
> +			count++;
> +		}
> +
> +		linemax = (si->lfb_width - efi_x) / font->width;
> +		if (count > linemax)
> +			count = linemax;
> +
> +		for (h = 0; h < font->height; h++) {
> +			unsigned int n, x;
> +
> +			dst = early_ioremap(base + (efi_y + h) * len, len);

So, this applies to other functions as well but it's visible here too: 
some of the line/height geometry types are unsigned, others are signed: 
'x' is unsigned but 'h' is signed.

It's not consistent - for performance and consistency reasons it might be 
good to just standardize all geometry on unsigned int or so?

(Assuming negative numbers are never used, which appears to be the case.)

> +			if (!dst)
> +				return;
> +
> +			s = str;
> +			n = count;
> +			x = efi_x;
> +
> +			while (n-- > 0) {
> +				early_efi_write_char(dst + x * 4, *s++, h);
> +				x += font->width;

Would be nice to put the s++ side effect into a separate line, it wasn't 
obvious to me at first glance.

Also, multiplications are nicer written without the spaces:

				early_efi_write_char(dst + x*4, *s++, h);

> +			}
> +
> +			early_iounmap(dst, len);
> +		}
> +
> +		num -= count;
> +		efi_x += count * font->width;
> +		str += count;
> +
> +		if (num > 0 && *s == '\n') {
> +			efi_x = 0;
> +			efi_y += font->height;

btw., it's a fixed-width, fixed-height font, right?

> +			str++;
> +			num--;
> +		}
> +
> +		if (efi_x >= si->lfb_width) {
> +			efi_x = 0;
> +			efi_y += font->height;
> +		}
> +
> +		if (efi_y + font->height >= si->lfb_height) {
> +			early_efi_clear_screen();
> +			efi_y = 0;

So, if I understand it correctly this clears the screen and starts at the 
top when we scroll off the bottom, right?

That might make the recovery of oopses hard when the number of log lines 
is unlucky.

Would scrolling a few lines up instead, via a well-calculated memcpy and 
memset be doable?

> +		}
> +	}
> +}
> +
> +static __init int early_efi_setup(struct console *con, char *options)
> +{
> +	struct screen_info *si;
> +	u16 xres, yres;
> +
> +	si = &boot_params.screen_info;
> +	xres = si->lfb_width;
> +	yres = si->lfb_height;
> +
> +	/*
> +	 * early_efi_write_char() implicitly assumes a framebuffer with
> +	 * 32-bits per pixel.
> +	 */
> +	if (si->lfb_depth != 32)
> +		return -ENODEV;

Is a non-32-bit framebuffer a possibility? If yes then it might be nice to 
emit an informative printk() here, so that users who try to enable EFI 
early-printk can at least see why it's not working. (Assuming they get to 
look at regular printk output, on a safe/working kernel.)

Also, if non-32-bit framebuffers are common, it would be rather easy to 
generalize early_efi_write_char() framebuffer depth multiples of eight 
(24, 16):

  - white is -1 masked to the pixel width
  - black is zero
  - the memory step granularity is the number of bytes in a pixel

> +
> +	font = get_default_font(xres, yres, ~(u32)0, ~(u32)0);

Any reason why it's not:

	font = get_default_font(xres, yres, -1, -1);

?

> +	if (!font)
> +		return -ENODEV;
> +
> +	early_efi_clear_screen();

Assuming we implement scrolling above, here too it might make sense to 
scroll up the framebuffer - if the crash is early enough then some 
firmware and boot stub info might still be present in the framebuffer?

> +
> +	return 0;
> +}
> +
> +struct console early_efi_console = {
> +	.name =		"earlyefi",
> +	.write =	early_efi_write,
> +	.setup =	early_efi_setup,
> +	.flags =	CON_PRINTBUFFER,
> +	.index =	-1,
> +};

Thanks,

	Ingo
