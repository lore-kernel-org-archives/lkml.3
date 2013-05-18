Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab3ERN26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 09:28:58 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:55508 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3ERN24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 09:28:56 -0400
MIME-Version: 1.0
In-Reply-To: <1368868514-18975-5-git-send-email-linux@prisktech.co.nz>
References: <1368868514-18975-1-git-send-email-linux@prisktech.co.nz>
	<1368868514-18975-5-git-send-email-linux@prisktech.co.nz>
Date: Sat, 18 May 2013 17:28:54 +0400
Message-ID: <CABjd4Yxrk3hXnB5f6u+1HcJjymDZbtQ1F1HXkZ2dzF3dwCrWhg@mail.gmail.com>
Subject: Re: [PATCH 4/4] fb: vt8500: Add VGA output support to wm8505fb driver.
From: Alexey Charkov <alchark@gmail.com>
To: "VT8500/WM8505 Linux Kernel" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tomi.valkeinen@ti.com,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Tony Prisk <linux@prisktech.co.nz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/18 Tony Prisk <linux@prisktech.co.nz>:
> The APC8750 does not support an LCD panel, but provides a VGA connector.
> This patch adds support for the VGA interface, and defines an optional
> devicetree property to specify the output interface. The default if not
> specified is LCD for backward compatibility.
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>  .../devicetree/bindings/video/wm,wm8505-fb.txt     |    5 ++++
>  drivers/video/wm8505fb.c                           |   31 ++++++++++++++++++--
>  2 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt b/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
> index 601416c..9f1d648 100644
> --- a/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
> +++ b/Documentation/devicetree/bindings/video/wm,wm8505-fb.txt
> @@ -7,6 +7,10 @@ Required properties:
>  - bits-per-pixel : bit depth of framebuffer (16 or 32)
>  - clocks : phandle to DVO clock
>
> +Optional properties:
> +- output-interface : the interface the fb should output on. Valid values are
> +       "lcd" or "vga". If not specified, the default is "lcd".
> +
>  Required subnodes:
>  - display-timings: see display-timing.txt for information
>
> @@ -17,6 +21,7 @@ Example:
>                 reg = <0xd8051700 0x200>;
>                 bits-per-pixel = <16>;
>                 clocks = <&clkdvo>;
> +               output-interface = "vga";
>
>                 display-timings {
>                         native-mode = <&timing0>;
> diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
> index f8bffc2..d1f7f33 100644
> --- a/drivers/video/wm8505fb.c
> +++ b/drivers/video/wm8505fb.c
> @@ -130,12 +130,17 @@
>
>  #define to_wm8505fb_info(__info) container_of(__info, \
>                                                 struct wm8505fb_info, fb)
> +
> +#define INTERFACE_LCD  1
> +#define INTERFACE_VGA  2
> +
>  struct wm8505fb_info {
>         struct fb_info fb;
>         void __iomem *regbase;
>         unsigned int contrast;
>         struct device *dev;
>         struct clk *clk_dvo;
> +       int interface;
>  };
>
>
> @@ -158,7 +163,11 @@ static int wm8505fb_init_hw(struct fb_info *info)
>          * 0x31C sets the correct color mode (RGB565) for WM8650
>          * Bit 8+9 (0x300) are ignored on WM8505 as reserved
>          */
> -       writel(0x31c,                  fbi->regbase + REG_GOVRH_YUVRGB);
> +       if (fbi->interface == INTERFACE_VGA)
> +               writel(0x338, fbi->regbase + REG_GOVRH_YUVRGB);
> +       else
> +               writel(0x31c, fbi->regbase + REG_GOVRH_YUVRGB);
> +
>         writel(1,                      fbi->regbase + REG_GOVRH_DVO_PIX);

Tony,

Would it be possible to also define known bit offsets for those
registers, while you are at this? It would probably reduce the black
magic quite a bit :)

>         /* Virtual buffer size */
> @@ -167,7 +176,12 @@ static int wm8505fb_init_hw(struct fb_info *info)
>
>         /* black magic ;) */
>         writel(0xf,                    fbi->regbase + REG_GOVRH_FHI);
> -       writel(4,                      fbi->regbase + REG_GOVRH_DVO_SET);
> +
> +       if (fbi->interface == INTERFACE_VGA)
> +               writel(0xe, fbi->regbase + REG_GOVRH_DVO_SET);
> +       else
> +               writel(4, fbi->regbase + REG_GOVRH_DVO_SET);

I don't remember if HDMI is yet another option for this register or
not... If it is, it would probably warrant defining fbi->interface as
an enum and changing this if-else into a switch statement to let the
compiler add its checks/warnings.

>         writel(1,                      fbi->regbase + REG_GOVRH_MIF);
>         writel(1,                      fbi->regbase + REG_GOVRH_REG_STS);
>
> @@ -194,11 +208,15 @@ static int wm8505fb_set_timing(struct fb_info *info)
>         writel(h_end,   fbi->regbase + REG_GOVRH_ACTPX_END);
>         writel(h_all,   fbi->regbase + REG_GOVRH_H_ALLPXL);
>         writel(h_sync,  fbi->regbase + REG_GOVRH_HDMI_HSYNW);
> +       if (fbi->interface == INTERFACE_VGA)
> +               writel(h_sync,  fbi->regbase + REG_GOVRH_VGA_HSYNW);

Will it misbehave on LCD if you write to the VGA register unconditionally?

>         writel(v_start, fbi->regbase + REG_GOVRH_ACTLN_BG);
>         writel(v_end,   fbi->regbase + REG_GOVRH_ACTLN_END);
>         writel(v_all,   fbi->regbase + REG_GOVRH_V_ALLLN);
>         writel(v_sync,  fbi->regbase + REG_GOVRH_HDMI_VBISW);
> +       if (fbi->interface == INTERFACE_VGA)
> +               writel(info->var.pixclock,  fbi->regbase + REG_GOVRH_VGA_VSYNW);

Same here. I would assume that setting the pixclock should not hurt
LCD, which would then simplify the code a little.

Thanks,
Alexey
