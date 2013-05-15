Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3EOLpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 07:45:10 -0400
Received: from ams-iport-2.cisco.com ([144.254.224.141]:31265 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab3EOLpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 07:45:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEFADd0k1GQ/khM/2dsb2JhbABbgweDc70WeRZ0gh8BAQUjVhALGAICJgICVwYTiAyrPZE9gSaNeAeCQoETA5c0kT2DETo
X-IronPort-AV: E=Sophos;i="4.87,677,1363132800"; 
   d="scan'208";a="82599983"
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] console/font: Refactor font support code selection logic
Date: Wed, 15 May 2013 13:45:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-2.slh.1-aptosid-amd64; KDE/4.8.4; x86_64; ; )
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org,
        Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Helge Deller <deller@gmx.de>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1368618050-26895-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1368618050-26895-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305151345.02306.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 15 May 2013 13:40:50 Geert Uytterhoeven wrote:
> The current Makefile rules to build font support are messy and buggy.
> Replace them by Kconfig rules:
>   - Introduce CONFIG_FONT_SUPPORT, which controls the building of all font
>     code,
>   - Select CONFIG_FONT_SUPPORT for all drivers that use fonts,
>   - Select CONFIG_FONT_8x16 for all drivers that default to the VGA8x16
>     font,
>   - Drop the bogus console dependency for CONFIG_VIDEO_VIVI.
> 
> This fixes (if CONFIG_SOLO6X10=y and there are no built-in console
> drivers):
> 
> drivers/built-in.o: In function `solo_osd_print':
> drivers/staging/media/solo6x10/solo6x10-enc.c:144: undefined reference to `.find_font'
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

That looks much more sane. Thanks!

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/platform/Kconfig         |    2 +-
>  drivers/staging/media/solo6x10/Kconfig |    2 ++
>  drivers/usb/misc/sisusbvga/Kconfig     |    1 +
>  drivers/video/console/Kconfig          |   12 ++++++++++--
>  drivers/video/console/Makefile         |   14 +++++---------
>  5 files changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 0cbe1ff..c1f29d5 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -220,7 +220,7 @@ if V4L_TEST_DRIVERS
>  config VIDEO_VIVI
>  	tristate "Virtual Video Driver"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && !SPARC32 && !SPARC64
> -	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
> +	select FONT_SUPPORT
>  	select FONT_8x16
>  	select VIDEOBUF2_VMALLOC
>  	default n
> diff --git a/drivers/staging/media/solo6x10/Kconfig b/drivers/staging/media/solo6x10/Kconfig
> index ec32776..b34bb6c 100644
> --- a/drivers/staging/media/solo6x10/Kconfig
> +++ b/drivers/staging/media/solo6x10/Kconfig
> @@ -1,6 +1,8 @@
>  config SOLO6X10
>  	tristate "Softlogic 6x10 MPEG codec cards"
>  	depends on PCI && VIDEO_DEV && SND && I2C
> +	select FONT_SUPPORT
> +	select FONT_8x16
>  	select VIDEOBUF2_DMA_SG
>  	select VIDEOBUF2_DMA_CONTIG
>  	select SND_PCM
> diff --git a/drivers/usb/misc/sisusbvga/Kconfig b/drivers/usb/misc/sisusbvga/Kconfig
> index 0d03a52..36bc28c 100644
> --- a/drivers/usb/misc/sisusbvga/Kconfig
> +++ b/drivers/usb/misc/sisusbvga/Kconfig
> @@ -2,6 +2,7 @@
>  config USB_SISUSBVGA
>  	tristate "USB 2.0 SVGA dongle support (Net2280/SiS315)"
>  	depends on (USB_MUSB_HDRC || USB_EHCI_HCD)
> +	select FONT_SUPPORT if USB_SISUSBVGA_CON
>          ---help---
>  	  Say Y here if you intend to attach a USB2VGA dongle based on a
>  	  Net2280 and a SiS315 chip.
> diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
> index bc922c4..baf27dc 100644
> --- a/drivers/video/console/Kconfig
> +++ b/drivers/video/console/Kconfig
> @@ -62,6 +62,7 @@ config MDA_CONSOLE
>  config SGI_NEWPORT_CONSOLE
>          tristate "SGI Newport Console support"
>          depends on SGI_IP22 
> +        select FONT_SUPPORT
>          help
>            Say Y here if you want the console on the Newport aka XL graphics
>            card of your Indy.  Most people say Y here.
> @@ -91,6 +92,7 @@ config FRAMEBUFFER_CONSOLE
>  	tristate "Framebuffer Console support"
>  	depends on FB
>  	select CRC32
> +	select FONT_SUPPORT
>  	help
>  	  Low-level framebuffer-based console driver.
>  
> @@ -123,12 +125,18 @@ config FRAMEBUFFER_CONSOLE_ROTATION
>  config STI_CONSOLE
>          bool "STI text console"
>          depends on PARISC
> +        select FONT_SUPPORT
>          default y
>          help
>            The STI console is the builtin display/keyboard on HP-PARISC
>            machines.  Say Y here to build support for it into your kernel.
>            The alternative is to use your primary serial port as a console.
>  
> +config FONT_SUPPORT
> +	tristate
> +
> +if FONT_SUPPORT
> +
>  config FONTS
>  	bool "Select compiled-in fonts"
>  	depends on FRAMEBUFFER_CONSOLE || STI_CONSOLE
> @@ -158,7 +166,6 @@ config FONT_8x8
>  
>  config FONT_8x16
>  	bool "VGA 8x16 font" if FONTS
> -	depends on FRAMEBUFFER_CONSOLE || SGI_NEWPORT_CONSOLE || STI_CONSOLE || USB_SISUSBVGA_CON
>  	default y if !SPARC && !FONTS
>  	help
>  	  This is the "high resolution" font for the VGA frame buffer (the one
> @@ -226,7 +233,6 @@ config FONT_10x18
>  
>  config FONT_AUTOSELECT
>  	def_bool y
> -	depends on FRAMEBUFFER_CONSOLE || SGI_NEWPORT_CONSOLE || STI_CONSOLE || USB_SISUSBVGA_CON
>  	depends on !FONT_8x8
>  	depends on !FONT_6x11
>  	depends on !FONT_7x14
> @@ -238,5 +244,7 @@ config FONT_AUTOSELECT
>  	depends on !FONT_10x18
>  	select FONT_8x16
>  
> +endif # FONT_SUPPORT
> +
>  endmenu
>  
> diff --git a/drivers/video/console/Makefile b/drivers/video/console/Makefile
> index a862e91..3a11b63 100644
> --- a/drivers/video/console/Makefile
> +++ b/drivers/video/console/Makefile
> @@ -18,14 +18,14 @@ font-objs-$(CONFIG_FONT_MINI_4x6)  += font_mini_4x6.o
>  
>  font-objs += $(font-objs-y)
>  
> -# Each configuration option enables a list of files.
> +obj-$(CONFIG_FONT_SUPPORT)         += font.o
>  
>  obj-$(CONFIG_DUMMY_CONSOLE)       += dummycon.o
> -obj-$(CONFIG_SGI_NEWPORT_CONSOLE) += newport_con.o font.o
> -obj-$(CONFIG_STI_CONSOLE)         += sticon.o sticore.o font.o
> +obj-$(CONFIG_SGI_NEWPORT_CONSOLE) += newport_con.o
> +obj-$(CONFIG_STI_CONSOLE)         += sticon.o sticore.o
>  obj-$(CONFIG_VGA_CONSOLE)         += vgacon.o
>  obj-$(CONFIG_MDA_CONSOLE)         += mdacon.o
> -obj-$(CONFIG_FRAMEBUFFER_CONSOLE) += fbcon.o bitblit.o font.o softcursor.o
> +obj-$(CONFIG_FRAMEBUFFER_CONSOLE) += fbcon.o bitblit.o softcursor.o
>  ifeq ($(CONFIG_FB_TILEBLITTING),y)
>  obj-$(CONFIG_FRAMEBUFFER_CONSOLE)     += tileblit.o
>  endif
> @@ -34,8 +34,4 @@ obj-$(CONFIG_FRAMEBUFFER_CONSOLE)     += fbcon_rotate.o fbcon_cw.o fbcon_ud.o \
>                                           fbcon_ccw.o
>  endif
>  
> -obj-$(CONFIG_FB_STI)              += sticore.o font.o
> -
> -ifeq ($(CONFIG_USB_SISUSBVGA_CON),y)
> -obj-$(CONFIG_USB_SISUSBVGA)           += font.o
> -endif
> +obj-$(CONFIG_FB_STI)              += sticore.o
> 
