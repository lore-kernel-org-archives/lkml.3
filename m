Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab3FCUyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:54:23 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41201 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756753Ab3FCUyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:54:20 -0400
MIME-Version: 1.0
In-Reply-To: <51ACFDF2.4040600@infradead.org>
References: <20130603163717.a6f78476e57d92fadd6f6a23@canb.auug.org.au>
	<51ACFDF2.4040600@infradead.org>
Date: Mon, 3 Jun 2013 22:54:19 +0200
X-Google-Sender-Auth: axMXci_Syh_fmhrpaYEgjXweVvE
Message-ID: <CAMuHMdUALrScFE895xRiBvgUpVa9Tvic5M7YxefrEgyeMaSjhw@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 3 (fonts.c & vivi)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 10:34 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 06/02/13 23:37, Stephen Rothwell wrote:
>> Changes since 20130531:
> on x86_64:
>
> warning: (VIDEO_VIVI && USB_SISUSBVGA && SOLO6X10) selects FONT_SUPPORT which has unmet direct dependencies (HAS_IOMEM && VT)
> warning: (VIDEO_VIVI && FB_VGA16 && FB_S3 && FB_VT8623 && FB_ARK && USB_SISUSBVGA_CON && SOLO6X10) selects FONT_8x16 which has unmet direct dependencies (HAS_IOMEM && VT && FONT_SUPPORT)

I knew about thet warning. But I thought it was harmless, as none of the font
code really depends on console support...

> drivers/built-in.o: In function `vivi_init':
> vivi.c:(.init.text+0x1a3da): undefined reference to `find_font'
>
> when CONFIG_VT is not enabled.

... but I missed that drivers/video/console is not used if CONFIG_VT=y.
Sorry for that.

> Just make CONFIG_VIDEO_VIVI depend on VT ?

Does this (whitespace-damaged copy-and-paste) help?

--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -12,7 +12,7 @@ fb-y                              := fbmem.o fbmon.o fbcmap.o
                                      modedb.o fbcvt.o
 fb-objs                           := $(fb-y)

-obj-$(CONFIG_VT)                 += console/
+obj-y                            += console/
 obj-$(CONFIG_LOGO)               += logo/
 obj-y                            += backlight/

It shouldn't make a difference if nothing inside drivers/video/console
is enabled,
as all objects in drivers/video/console/Makefile are conditional.

BTW, my plan was to move the font code to lib/font, but I haven't done that yet.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
