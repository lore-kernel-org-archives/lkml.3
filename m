Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab3EPPp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:45:56 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61999 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957Ab3EPPpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:45:52 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18RC5CqlxTiB734A1UNDNXkIS+aGe/WTts=
Date: Thu, 16 May 2013 11:45:43 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dove: add a kms/drm driver
Message-ID: <20130516154543.GG6563@titan.lakedaemon.net>
References: <20130516132822.09b883cf@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130516132822.09b883cf@armhf>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-François,

Please run ./scripts/get_maintainer.pl on your patches before
submitting.  In this case:

$ ./scripts/get_maintainer.pl -f drivers/gpu/drm/
David Airlie <airlied@linux.ie> (maintainer:DRM DRIVERS)
dri-devel@lists.freedesktop.org (open list:DRM DRIVERS)
linux-kernel@vger.kernel.org (open list)

I've added them to the CC:

thx,

Jason.


On Thu, May 16, 2013 at 01:28:22PM +0200, Jean-Francois Moine wrote:
> This patch adds a KMS/DRM video driver for the LCD and display
> controllers of the Marvell's Dove SoC.
> 
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  drivers/gpu/drm/Kconfig          |    2 +
>  drivers/gpu/drm/Makefile         |    1 +
>  drivers/gpu/drm/dove/Kconfig     |   10 +
>  drivers/gpu/drm/dove/Makefile    |    6 +
>  drivers/gpu/drm/dove/dove_crtc.c | 1378 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/dove/dove_dcon.h |   64 +++
>  drivers/gpu/drm/dove/dove_drv.c  |  380 +++++++++++++
>  drivers/gpu/drm/dove/dove_drv.h  |   93 ++++
>  drivers/gpu/drm/dove/dove_ec.c   |  570 ++++++++++++++++++++
>  drivers/gpu/drm/dove/dove_lcd.h  |  519 ++++++++++++++++++
>  10 files changed, 3023 insertions(+)
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index b16c50e..c6e4f4f 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -220,3 +220,5 @@ source "drivers/gpu/drm/omapdrm/Kconfig"
>  source "drivers/gpu/drm/tilcdc/Kconfig"
>  
>  source "drivers/gpu/drm/qxl/Kconfig"
> +
> +source "drivers/gpu/drm/dove/Kconfig"
> diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
> index 1c9f243..6428683 100644
> --- a/drivers/gpu/drm/Makefile
> +++ b/drivers/gpu/drm/Makefile
> @@ -52,4 +52,5 @@ obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
>  obj-$(CONFIG_DRM_OMAP)	+= omapdrm/
>  obj-$(CONFIG_DRM_TILCDC)	+= tilcdc/
>  obj-$(CONFIG_DRM_QXL) += qxl/
> +obj-$(CONFIG_DRM_DOVE)	+= dove/
>  obj-y			+= i2c/
> diff --git a/drivers/gpu/drm/dove/Kconfig b/drivers/gpu/drm/dove/Kconfig
> new file mode 100644
> index 0000000..465dc4d
> --- /dev/null
> +++ b/drivers/gpu/drm/dove/Kconfig
> @@ -0,0 +1,10 @@
> +config DRM_DOVE
> +	tristate "DRM Support for Marvell Dove"
> +	depends on DRM && ARCH_DOVE
> +	depends on OF
> +	select DRM_KMS_HELPER
> +	select DRM_KMS_CMA_HELPER
> +	select DRM_GEM_CMA_HELPER
> +	help
> +	  Choose this option if you have a Marvell Dove chipset.
> +	  If M is selected the module will be called dove-drm.
> diff --git a/drivers/gpu/drm/dove/Makefile b/drivers/gpu/drm/dove/Makefile
> new file mode 100644
> index 0000000..3758a19
> --- /dev/null
> +++ b/drivers/gpu/drm/dove/Makefile
> @@ -0,0 +1,6 @@
> +#
> +# Makefile for Marvell Dove's DRM device driver
> +#
> +
> +dove-drm-objs := dove_drv.o dove_crtc.o dove_ec.o
> +obj-$(CONFIG_DRM_DOVE) += dove-drm.o
> diff --git a/drivers/gpu/drm/dove/dove_crtc.c b/drivers/gpu/drm/dove/dove_crtc.c
> new file mode 100644
> index 0000000..9e397e7
> --- /dev/null
> +++ b/drivers/gpu/drm/dove/dove_crtc.c
> @@ -0,0 +1,1378 @@
> +/*
> + * Marvell Dove DRM driver - CRTC
> + *
> + * Copyright (C) 2013
> + *   Jean-Francois Moine <moinejf@free.fr>
> + *   Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of_irq.h>
> +
> +#include "dove_drv.h"
> +#include "dove_lcd.h"
> +
> +#define DOVE_LCD_REG_BASE_MASK	0xfffff
> +#define DOVE_LCD0_REG_BASE	0x20000
> +#define DOVE_LCD1_REG_BASE	0x10000
> +
> +#define to_dove_lcd(x) container_of(x, struct dove_lcd, crtc)
> +
> +static inline void dove_write(struct dove_lcd *dove_lcd, u32 reg, u32 data)
> +{
> +	writel(data, dove_lcd->mmio + reg);
> +}
> +static inline u32 dove_read(struct dove_lcd *dove_lcd, u32 reg)
> +{
> +	return readl(dove_lcd->mmio + reg);
> +}
> +static inline void dove_set(struct dove_lcd *dove_lcd, u32 reg, u32 mask)
> +{
> +	dove_write(dove_lcd, reg, dove_read(dove_lcd, reg) | mask);
> +}
> +static inline void dove_clear(struct dove_lcd *dove_lcd, u32 reg, u32 mask)
> +{
> +	dove_write(dove_lcd, reg, dove_read(dove_lcd, reg) & ~mask);
> +}
> +
> +/*
> + * vertical blank functions
> + */
> +u32 dove_vblank_count(struct drm_device *dev, int crtc)
> +{
> +	struct dove_lcd *dove_lcd = dove_drm.lcds[crtc];
> +
> +	return STA_GRA_FRAME_COUNT(dove_read(dove_lcd, SPU_IRQ_ISR));
> +}
> +
> +int dove_enable_vblank(struct drm_device *dev, int crtc)
> +{
> +	struct dove_lcd *dove_lcd = dove_drm.lcds[crtc];
> +
> +#ifdef HANDLE_INTERLACE
> +	dove_lcd->vblank_enabled = 1;
> +#endif
> +	dove_set(dove_lcd, SPU_IRQ_ENA, IRQ_GRA_FRAME_DONE);
> +	return 0;
> +}
> +
> +void dove_disable_vblank(struct drm_device *dev, int crtc)
> +{
> +	struct dove_lcd *dove_lcd = dove_drm.lcds[crtc];
> +
> +#ifdef HANDLE_INTERLACE
> +	dove_lcd->vblank_enabled = 0;
> +	if (!dove_lcd->v_sync0)
> +#endif
> +	dove_clear(dove_lcd, SPU_IRQ_ENA, IRQ_GRA_FRAME_DONE);
> +}
> +
> +#ifdef CONFIG_DEBUG_FS
> +static int dove_lcd_regs_show(struct seq_file *m,
> +			struct dove_lcd *dove_lcd)
> +{
> +	u32 x, shl, shh, total_v, total_h, active_h, active_v;
> +	u32 orig_buff_x, orig_buff_y, zoomed_x, zoomed_y;
> +	unsigned i;
> +
> +	seq_printf(m, "\t\t*** LCD %d ***\n", dove_lcd->num);
> +
> +	/* Get resolution */
> +	x = dove_read(dove_lcd, LCD_SPU_V_H_ACTIVE);
> +	active_h = H_LCD(x);
> +	active_v = V_LCD(x);
> +
> +	/* Get total line */
> +	x = dove_read(dove_lcd, LCD_SPUT_V_H_TOTAL);
> +	total_h = H_LCD(x);
> +	total_v = V_LCD(x);
> +	seq_printf(m, "----total-------------------------<%4dx%4d>"
> +					"-------------------------\n"
> +			"----active--------------|", total_h, total_v);
> +
> +	/* Get H Timings */
> +	x = dove_read(dove_lcd, LCD_SPU_H_PORCH);
> +	shl = F_LCD(x);
> +	shh = B_LCD(x);
> +	seq_printf(m, "->front porch(%d)->hsync(%d)->back porch(%d)\n",
> +		shl, total_h - shl -shh - active_h, shh);
> +
> +	seq_printf(m,	"|\t\t\t|\n"
> +			"|\t\t\t|\n"
> +			"|\t<%4dx%4d>\t|\n"
> +			"|\t\t\t|\n"
> +			"|\t\t\t|\n"
> +			"------------------------|\n", active_h, active_v);
> +
> +	/* Get V Timings */
> +	x = dove_read(dove_lcd, LCD_SPU_V_PORCH);
> +	shl = F_LCD(x);
> +	shh = B_LCD(x);
> +	seq_printf(m, "|\n|front porch(%d)\n|vsync(%d)\n|back porch(%d)\n",
> +		shl, total_v - shl - shh - active_v, shh);
> +	seq_printf(m, "----------------------------------"
> +			"-----------------------------------\n");
> +
> +	/* Get Line Pitch */
> +	x = dove_read(dove_lcd, LCD_CFG_GRA_PITCH);
> +	shl = x & 0x0000ffff;
> +	seq_printf(m, "gfx line pitch in memory is <%d>\n",
> +			shl);
> +
> +	/* Get scaling info */
> +	x = dove_read(dove_lcd, LCD_SPU_GRA_HPXL_VLN);
> +	orig_buff_x = H_LCD(x);
> +	orig_buff_y = V_LCD(x);
> +	x = dove_read(dove_lcd, LCD_SPU_GZM_HPXL_VLN);
> +	zoomed_x = H_LCD(x);
> +	zoomed_y = V_LCD(x);
> +	seq_printf(m, "Scaled from <%dx%d> to <%dx%d>\n",
> +			orig_buff_x, orig_buff_y, zoomed_x, zoomed_y);
> +
> +	seq_printf(m, "======================================\n");
> +
> +	for (i = 0x0080; i <= 0x01c4; i += 4) {
> +		x = dove_read(dove_lcd, i);
> +		seq_printf(m, "0x%04x 0x%08x\n", i, x);
> +	}
> +	return 0;
> +}
> +
> +static int dove_regs_show(struct seq_file *m, void *arg)
> +{
> +	struct dove_lcd *dove_lcd;
> +	unsigned i;
> +
> +	for (i = 0; i < MAX_DOVE_LCD; i++) {
> +		dove_lcd = dove_drm.lcds[i];
> +		if (dove_lcd)
> +			dove_lcd_regs_show(m, dove_lcd);
> +	}
> +	return 0;
> +}
> +
> +static struct drm_info_list dove_debugfs_list[] = {
> +	{ "lcd", dove_regs_show, 0 },
> +	{ "fb",   drm_fb_cma_debugfs_show, 0 },
> +};
> +
> +int dove_debugfs_init(struct drm_minor *minor)
> +{
> +	struct drm_device *dev = minor->dev;
> +	int ret;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	ret = drm_debugfs_create_files(dove_debugfs_list,
> +			ARRAY_SIZE(dove_debugfs_list),
> +			minor->debugfs_root, minor);
> +	if (ret)
> +		dev_err(dev->dev, "could not install dove_debugfs_list\n");
> +
> +	return ret;
> +}
> +
> +void dove_debugfs_cleanup(struct drm_minor *minor)
> +{
> +	drm_debugfs_remove_files(dove_debugfs_list,
> +			ARRAY_SIZE(dove_debugfs_list), minor);
> +}
> +#endif
> +
> +static void dove_update_base(struct dove_lcd *dove_lcd)
> +{
> +	struct drm_crtc *crtc = &dove_lcd->crtc;
> +	struct drm_framebuffer *fb = crtc->fb;
> +	struct drm_gem_cma_object *gem;
> +	unsigned int depth, bpp;
> +	dma_addr_t start;
> +
> +	drm_fb_get_bpp_depth(fb->pixel_format, &depth, &bpp);
> +	gem = drm_fb_cma_get_gem_obj(fb, 0);
> +	start = gem->paddr + fb->offsets[0] +
> +			crtc->y * fb->pitches[0] +
> +			crtc->x * bpp / 8;
> +
> +	dove_write(dove_lcd, LCD_CFG_GRA_START_ADDR0, start);
> +#ifdef HANDLE_INTERLACE
> +	if (dove_lcd->crtc.mode.mode->flags & DRM_MODE_FLAG_INTERLACE) {
> +		dove_write(dove_lcd, LCD_CFG_GRA_START_ADDR1,
> +					start + fb->pitches[0]);
> +		dove_write(dove_lcd, LCD_CFG_GRA_PITCH, fb->pitches[0] * 2);
> +		return;
> +	}
> +#endif
> +	dove_write(dove_lcd, LCD_CFG_GRA_START_ADDR1, start);
> +	dove_write(dove_lcd, LCD_CFG_GRA_PITCH, fb->pitches[0]);
> +}
> +
> +static void set_frame_timings(struct dove_lcd *dove_lcd)
> +{
> +	struct drm_crtc *crtc = &dove_lcd->crtc;
> +	const struct drm_display_mode *mode = &crtc->mode;
> +	u32 h_active, v_active, h_orig, v_orig, h_zoom, v_zoom;
> +	u32 hfp, hbp, vfp, vbp, hs, vs, v_total;
> +	u32 x;
> +
> +	/*
> +	 * Calc active size, zoomed size, porch.
> +	 */
> +	h_active = h_zoom = mode->hdisplay;
> +	v_active = v_zoom = mode->vdisplay;
> +	hfp = mode->hsync_start - mode->hdisplay;
> +	hbp = mode->htotal - mode->hsync_end;
> +	vfp = mode->vsync_start - mode->vdisplay;
> +	vbp = mode->vtotal - mode->vsync_end;
> +	hs = mode->hsync_end - mode->hsync_start;
> +	vs = mode->vsync_end - mode->vsync_start;
> +
> +	/*
> +	 * Calc original size.
> +	 */
> +	h_orig = h_active;
> +	v_orig = v_active;
> +
> +#ifdef HANDLE_INTERLACE
> +	/* interlaced workaround */
> +	if (mode->flags & DRM_MODE_FLAG_INTERLACE) {
> +		v_active /= 2;
> +		v_zoom /= 2;
> +		v_orig /= 2;
> +	}
> +#endif
> +
> +	/* calc total width and height */
> +	v_total = v_active + vfp + vs + vbp;
> +
> +	/* apply setting to registers */
> +	dove_write(dove_lcd, LCD_SPU_V_H_ACTIVE, LCD_H_V(h_active, v_active));
> +	dove_write(dove_lcd, LCD_SPU_GRA_HPXL_VLN, LCD_H_V(h_orig, v_orig));
> +	dove_write(dove_lcd, LCD_SPU_GZM_HPXL_VLN, LCD_H_V(h_zoom, v_zoom));
> +	dove_write(dove_lcd, LCD_SPU_H_PORCH, LCD_F_B(hfp, hbp));
> +	dove_write(dove_lcd, LCD_SPU_V_PORCH, LCD_F_B(vfp, vbp));
> +	dove_write(dove_lcd, LCD_SPUT_V_H_TOTAL,
> +					LCD_H_V(mode->htotal, v_total));
> +
> +	/* configure vsync adjust logic */
> +	x = dove_read(dove_lcd, LCD_TV_CONTROL1);
> +	x &= ~(VSYNC_L_OFFSET_MASK | VSYNC_H_OFFSET_MASK);
> +	x |= VSYNC_OFFSET_EN |			/* VSYNC adjust enable */
> +		VSYNC_L_OFFSET(h_active + hfp) |
> +		VSYNC_H_OFFSET(h_active + hfp);
> +#ifdef HANDLE_INTERLACE
> +	if (mode->flags & DRM_MODE_FLAG_INTERLACE) {
> +		dove_lcd->v_sync0 = VSYNC_L_OFFSET(h_active + hfp) |
> +				VSYNC_H_OFFSET(h_active + hfp);
> +		dove_lcd->v_sync1 = VSYNC_L_OFFSET(h_active / 2 + hfp) |
> +				VSYNC_H_OFFSET(h_active / 2 + hfp);
> +	} else {
> +		dove_lcd->v_sync0 = 0;
> +	}
> +#endif
> +	dove_write(dove_lcd, LCD_TV_CONTROL1, x);
> +}
> +
> +static int dove_set_clock(struct dove_lcd *dove_lcd)
> +{
> +	struct drm_crtc *crtc = &dove_lcd->crtc;
> +	const struct drm_display_mode *mode = &crtc->mode;
> +	struct clk *clk;
> +	u32 x, needed_pixclk, ref_clk, div, fract;
> +	int clk_src;
> +
> +	fract = 0;
> +	needed_pixclk = mode->clock * 1000;
> +#ifdef HANDLE_INTERLACE
> +	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
> +		needed_pixclk /= 2;
> +#endif
> +
> +	/* first check if pixclk is multiple of current clock */
> +	clk_src = dove_lcd->clk_src;
> +	clk = dove_lcd->clk[clk_src];
> +	ref_clk = clk_get_rate(clk);
> +
> +	DRM_DEBUG_DRIVER("clk src %d rate %u needed %u div %u mod %u\n",
> +			clk_src, ref_clk, needed_pixclk,
> +			ref_clk / needed_pixclk, ref_clk % needed_pixclk);
> +
> +	if (ref_clk % needed_pixclk == 0) {
> +		div = ref_clk / needed_pixclk;
> +		goto set_clock;
> +	}
> +
> +	/* try to set current clock to requested pixclk */
> +	clk_set_rate(clk, needed_pixclk);
> +	ref_clk = clk_get_rate(clk);
> +	if (ref_clk == needed_pixclk) {
> +		div = 1;
> +		goto set_clock;
> +	}
> +
> +	/* check if any other clock can set pixclk directly */
> +	for (clk_src = 0; clk_src < MAX_CLK; clk_src++) {
> +		clk = dove_lcd->clk[clk_src];
> +		if (!clk)
> +			continue;
> +
> +		/* try to set clock to requested pixclk */
> +		clk_set_rate(clk, needed_pixclk);
> +		ref_clk = clk_get_rate(clk);
> +
> +		if (ref_clk % needed_pixclk == 0) {
> +			div = ref_clk / needed_pixclk;
> +			goto set_clock;
> +		}
> +	}
> +
> +	/* fall back to default fix clock source LCD or AXI */
> +	if (dove_lcd->clk[SCLK_SRC_PLLDIV])
> +		clk_src = SCLK_SRC_PLLDIV;
> +	else
> +		clk_src = SCLK_SRC_AXI;
> +	clk = dove_lcd->clk[clk_src];
> +
> +	clk_set_rate(clk, needed_pixclk);
> +	ref_clk = clk_get_rate(clk);
> +		
> +	/* use internal divider */
> +	if (false) {
> +/*fixme: does not work*/
> +		ref_clk /= 1000;
> +		needed_pixclk /= 1000;
> +		x = (ref_clk * 0x1000 + needed_pixclk - 1) / needed_pixclk;
> +		div = x >> 12;
> +		if (div < 1)
> +			div = 1;
> +		else
> +			fract = x & 0xfff;
> +	} else {
> +		div = (ref_clk + needed_pixclk - 1) / needed_pixclk;
> +		if (div < 1)
> +			div = 1;
> +	}
> +
> +set_clock:
> +	dove_lcd->clk_src = clk_src;
> +	DRM_DEBUG_DRIVER("set clk src %d ref %u div %u fract %u needed %u\n",
> +			clk_src, ref_clk, div, fract, needed_pixclk);
> +	x = SET_SCLK(clk_src, div, fract);
> +	dove_write(dove_lcd, LCD_CFG_SCLK_DIV, x);
> +	return 0;
> +}
> +
> +static void set_dma_control(struct dove_lcd *dove_lcd)
> +{
> +	const struct drm_display_mode *mode = &dove_lcd->crtc.mode;
> +	u32 x;
> +	int fmt, rbswap;
> +
> +	rbswap = 1;				/* default */
> +	switch (dove_lcd->crtc.fb->pixel_format) {
> +	case DRM_FORMAT_BGR888:
> +		rbswap = 0;
> +	case DRM_FORMAT_RGB888:
> +		fmt = GMODE_RGB888PACKED;
> +		break;
> +	case DRM_FORMAT_XBGR8888:
> +		rbswap = 0;
> +	case DRM_FORMAT_XRGB8888:		/* depth 24 */
> +		fmt = GMODE_RGBA888;
> +		break;
> +	case DRM_FORMAT_ABGR8888:
> +		rbswap = 0;
> +	case DRM_FORMAT_ARGB8888:		/* depth 32 */
> +		fmt = GMODE_RGB888UNPACKED;
> +		break;
> +	case DRM_FORMAT_YVYU:
> +		rbswap = 0;
> +	case DRM_FORMAT_YUYV:
> +		fmt = GMODE_YUV422PACKED;
> +		break;
> +	case DRM_FORMAT_YVU422:
> +		rbswap = 0;
> +	case DRM_FORMAT_YUV422:
> +		fmt = GMODE_YUV422PLANAR;
> +		break;
> +	case DRM_FORMAT_YVU420:
> +		rbswap = 0;
> +	default:
> +/*	case DRM_FORMAT_YUV420: */
> +		fmt = GMODE_YUV420PLANAR;
> +		break;
> +	}
> +
> +	x = dove_read(dove_lcd, LCD_SPU_DMA_CTRL0);
> +	x &= ~(CFG_PALETTE_ENA |		/* true color */
> +		CFG_GRAFORMAT_MASK |
> +		CFG_GRA_SWAPRB |
> +		CFG_GRA_FTOGGLE);
> +	x |= CFG_GRA_ENA |			/* graphic enable */
> +		CFG_GRA_HSMOOTH;		/* horiz. smooth scaling */
> +	x |= CFG_GRAFORMAT(fmt);
> +
> +	if (!rbswap)
> +		x |= CFG_GRA_SWAPRB;
> +#ifdef HANDLE_INTERLACE
> +	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
> +		x |= CFG_GRA_FTOGGLE;
> +#endif
> +	dove_write(dove_lcd, LCD_SPU_DMA_CTRL0, x);
> +
> +	/*
> +	 * trigger DMA on the falling edge of vsync if vsync is
> +	 * active low, or on the rising edge if vsync is active high
> +	 */
> +	if (!(mode->flags & DRM_MODE_FLAG_PVSYNC))
> +		dove_set(dove_lcd, LCD_SPU_DMA_CTRL1, CFG_VSYNC_INV);
> +}
> +
> +/* this function is called on mode DRM_MODE_DPMS_ON
> + * and also at loading time with gpio_only set */
> +static void set_dumb_panel_control(struct dove_lcd *dove_lcd,
> +				int gpio_only)
> +{
> +	const struct drm_display_mode *mode = &dove_lcd->crtc.mode;
> +	u32 x;
> +
> +	x = 0;
> +	if (dove_lcd->dpms == DRM_MODE_DPMS_ON)
> +		x = CFG_DUMB_ENA;
> +	if (!gpio_only) {
> +		if (dove_lcd->dpms == DRM_MODE_DPMS_ON)
> +			/*
> +			 * When dumb interface isn't under 24bit
> +			 * It might be under SPI or GPIO. If set
> +			 * to 0x7 will force LCD_D[23:0] output
> +			 * blank color and damage GPIO and SPI
> +			 * behavior.
> +			 */
> +			x |= CFG_DUMBMODE(DUMB24_RGB888_0);
> +		else
> +			x |= CFG_DUMBMODE(7);
> +/*fixme
> +		if (mode->flags & FB_SYNC_COMP_HIGH_ACT)
> +			x |= CFG_INV_COMPSYNC;
> +*/
> +		if (!(mode->flags & DRM_MODE_FLAG_PVSYNC))
> +			x |= CFG_INV_VSYNC;
> +
> +		/* Following is a weired workaround. This bit shouldn't be set
> +		 * For now, if it's 1080p or 720 then don't set HOR_HIGH_ACT */
> +		if ((mode->hdisplay == 1920 && mode->vdisplay == 1080) ||
> +		    (mode->hdisplay == 1280 && mode->vdisplay == 720))
> +			/* Do nothing */
> +			;
> +		else
> +			if (!(mode->flags & DRM_MODE_FLAG_PHSYNC))
> +				x |= CFG_INV_HSYNC;
> +	}
> +
> +	dove_write(dove_lcd, LCD_SPU_DUMB_CTRL, x);
> +}
> +
> +void dove_crtc_start(struct dove_lcd *dove_lcd)
> +{
> +	struct drm_crtc *crtc = &dove_lcd->crtc;
> +	struct drm_display_mode *mode = &crtc->mode;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	if (mode->clock == 0) {
> +		dev_err(dove_lcd->dev, "crtc_start: no clock!\n");
> +		dove_lcd->dpms = DRM_MODE_DPMS_OFF;
> +		return;
> +	}
> +
> +	set_frame_timings(dove_lcd);
> +	if (dove_set_clock(dove_lcd) < 0)
> +		return;
> +	set_dma_control(dove_lcd);
> +	dove_update_base(dove_lcd);
> +	set_dumb_panel_control(dove_lcd, 0);
> +
> +#ifdef HANDLE_INTERLACE
> +	if (dove_lcd->v_sync0) {		/* interlace mode on */
> +		dove_set(dove_lcd, SPU_IRQ_ENA, IRQ_GRA_FRAME_DONE);
> +	} else {				/* interlace mode off */
> +		if (!dove_lcd->vblank_enabled)
> +			dove_clear(dove_lcd, SPU_IRQ_ENA, IRQ_GRA_FRAME_DONE);
> +	}
> +#endif
> +
> +	DRM_DEBUG_DRIVER("start %s@%d\n",
> +			crtc->mode.name, crtc->mode.vrefresh);
> +}
> +
> +void dove_crtc_stop(struct dove_lcd *dove_lcd)
> +{
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	dove_clear(dove_lcd, LCD_SPU_DMA_CTRL0, CFG_GRA_ENA);
> +	dove_clear(dove_lcd, LCD_SPU_DUMB_CTRL, CFG_DUMB_ENA);
> +#ifdef HANDLE_INTERLACE
> +	if (dove_lcd->v_sync0
> +	 && !dove_lcd->vblank_enabled)
> +		dove_clear(dove_lcd, SPU_IRQ_ENA, IRQ_GRA_FRAME_DONE);
> +#endif
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * cursor
> + */
> +
> +/* load the hardware cursor */
> +static int load_cursor(struct dove_lcd *dove_lcd,
> +			struct drm_file *file_priv,
> +			uint32_t handle,
> +			int data_len)
> +{
> +	struct drm_gem_object *obj;
> +	struct drm_gem_cma_object *cma_obj;
> +	u8 *p_pixel;
> +	u32 u, val;
> +	u32 ram, color;
> +	int i, j, ret;
> +
> +	obj = drm_gem_object_lookup(dove_drm.drm, file_priv, handle);
> +	if (!obj)
> +		return -ENOENT;
> +
> +	if (!obj->map_list.map) {
> +		dev_warn(dove_lcd->dev, "cursor not mapped\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	if (data_len != obj->size) {
> +		dev_warn(dove_lcd->dev, "bad cursor size\n");
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	cma_obj = to_drm_gem_cma_obj(obj);
> +	p_pixel = cma_obj->vaddr;
> +
> +	u = CFG_SRAM_INIT_WR_RD(SRAMID_INIT_WRITE) |
> +			CFG_SRAM_ADDR_LCDID(SRAMID_HWC);
> +	ram = CFG_SRAM_INIT_WR_RD(SRAMID_INIT_WRITE);
> +
> +	/* load the RGBA cursor to SRAM */
> +	for (i = 0; i < data_len / 4 / 4; i++) {
> +		color = (p_pixel[3 * 4 + 0] << 24) |	/* red */
> +			(p_pixel[2 * 4 + 0] << 16) |
> +			(p_pixel[1 * 4 + 0] << 8) |
> +			p_pixel[0];
> +		dove_write(dove_lcd, LCD_SPU_SRAM_WRDAT, color);
> +		dove_write(dove_lcd, LCD_SPU_SRAM_CTRL,
> +				ram | CFG_SRAM_ADDR_LCDID(SRAMID_HWC32_RAM1));
> +		color = (p_pixel[3 * 4 + 1] << 24) |	/* green */
> +			(p_pixel[2 * 4 + 1] << 16) |
> +			(p_pixel[1 * 4 + 1] << 8) |
> +			p_pixel[1];
> +		dove_write(dove_lcd, LCD_SPU_SRAM_WRDAT, color);
> +		dove_write(dove_lcd, LCD_SPU_SRAM_CTRL,
> +				ram | CFG_SRAM_ADDR_LCDID(SRAMID_HWC32_RAM2));
> +		color = (p_pixel[3 * 4 + 2] << 24) |	/* blue */
> +			(p_pixel[2 * 4 + 2] << 16) |
> +			(p_pixel[1 * 4 + 2] << 8) |
> +			p_pixel[2];
> +		dove_write(dove_lcd, LCD_SPU_SRAM_WRDAT, color);
> +		dove_write(dove_lcd, LCD_SPU_SRAM_CTRL,
> +				ram | CFG_SRAM_ADDR_LCDID(SRAMID_HWC32_RAM3));
> +		p_pixel += 4 * 4;
> +		if ((++ram & 0xff) == 0) {
> +			ram -= 0x100;			/* I[7:0] */
> +			ram += 1 << 12;			/* J[1:0] */
> +		}
> +	}
> +
> +	/* set the transparency */
> +	p_pixel = cma_obj->vaddr;
> +	for (i = 0; i < data_len / 16 / 4; i++) {
> +		val = 0;
> +		for (j = 16 * 4 - 4; j >= 0 ; j -= 4) {
> +			val <<= 2;
> +			if (p_pixel[j + 3])	/* alpha */
> +				val |= 1;	/* not transparent */
> +		}
> +		dove_write(dove_lcd, LCD_SPU_SRAM_WRDAT, val);
> +		dove_write(dove_lcd, LCD_SPU_SRAM_CTRL, u++);
> +		p_pixel += 16 * 4;
> +	}
> +	ret = 0;
> +out:
> +	drm_gem_object_unreference_unlocked(obj);
> +	return ret;
> +}
> +
> +static int dove_cursor_set(struct drm_crtc *crtc,
> +			struct drm_file *file_priv,
> +			uint32_t handle,
> +			uint32_t width,
> +			uint32_t height)
> +{
> +	struct dove_lcd *dove_lcd = to_dove_lcd(crtc);
> +	int ret;
> +
> +	DRM_DEBUG_DRIVER("%dx%d handle %d\n", width, height, handle);
> +
> +	/* disable cursor */
> +	dove_clear(dove_lcd, LCD_SPU_DMA_CTRL0, CFG_HWC_ENA);
> +
> +	if (!handle)
> +		return 0;		/* cursor off */
> +
> +	if (width != 64 || height != 64) {
> +		dev_err(dove_lcd->dev, "bad cursor size\n");
> +		return -EINVAL;
> +	}
> +
> +	/* load the cursor */
> +	ret = load_cursor(dove_lcd, file_priv, handle, width * height * 4);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* set cursor size */
> +	dove_write(dove_lcd, LCD_SPU_HWC_HPXL_VLN, LCD_H_V(width, height));
> +
> +	/* enable cursor */
> +	dove_set(dove_lcd, LCD_SPU_DMA_CTRL0, CFG_HWC_ENA);
> +
> +	return 0;
> +}
> +
> +static int dove_cursor_move(struct drm_crtc *crtc,
> +				int x, int y)
> +{
> +	struct dove_lcd *dove_lcd = to_dove_lcd(crtc);
> +
> +	if (x < 0)
> +		x = 0;
> +	if (y < 0)
> +		y = 0;
> +	dove_clear(dove_lcd, LCD_SPU_DMA_CTRL0, CFG_HWC_ENA);
> +	dove_write(dove_lcd, LCD_SPU_HWC_OVSA_HPXL_VLN, LCD_H_V(x, y));
> +	dove_set(dove_lcd, LCD_SPU_DMA_CTRL0, CFG_HWC_ENA);
> +	return 0;
> +}
> +
> +static void dove_crtc_destroy(struct drm_crtc *crtc)
> +{
> +	struct dove_lcd *dove_lcd = to_dove_lcd(crtc);
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	WARN_ON(dove_lcd->dpms == DRM_MODE_DPMS_ON);
> +
> +	drm_crtc_cleanup(crtc);
> +}
> +
> +static int dove_crtc_page_flip(struct drm_crtc *crtc,
> +			struct drm_framebuffer *fb,
> +			struct drm_pending_vblank_event *event)
> +{
> +	struct dove_lcd *dove_lcd = to_dove_lcd(crtc);
> +	struct drm_device *drm = dove_drm.drm;
> +	unsigned long flags;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	spin_lock_irqsave(&drm->event_lock, flags);
> +	if (dove_lcd->event) {
> +		spin_unlock_irqrestore(&drm->event_lock, flags);
> +		dev_err(drm->dev, "already pending page flip!\n");
> +		return -EBUSY;
> +	}
> +	spin_unlock_irqrestore(&drm->event_lock, flags);
> +
> +	crtc->fb = fb;
> +	dove_update_base(dove_lcd);
> +
> +	if (event) {
> +		event->pipe = 0;
> +		spin_lock_irqsave(&drm->event_lock, flags);
> +		dove_lcd->event = event;
> +		spin_unlock_irqrestore(&drm->event_lock, flags);
> +		drm_vblank_get(drm, dove_lcd->num);
> +	}
> +
> +	return 0;
> +}
> +
> +static void dove_crtc_dpms(struct drm_crtc *crtc, int mode)
> +{
> +	struct dove_lcd *dove_lcd = to_dove_lcd(crtc);
> +
> +	/* we really only care about on or off */
> +	if (mode != DRM_MODE_DPMS_ON)
> +		mode = DRM_MODE_DPMS_OFF;
> +
> +	DRM_DEBUG_DRIVER("dpms %s\n", mode == DRM_MODE_DPMS_ON ? "on" : "off");
> +
> +	if (dove_lcd->dpms == mode)
> +		return;
> +
> +	dove_lcd->dpms = mode;
> +
> +	if (mode == DRM_MODE_DPMS_ON)
> +		dove_crtc_start(dove_lcd);
> +	else
> +		dove_crtc_stop(dove_lcd);
> +}
> +
> +static bool dove_crtc_mode_fixup(struct drm_crtc *crtc,
> +				const struct drm_display_mode *mode,
> +				struct drm_display_mode *adjusted_mode)
> +{
> +	DRM_DEBUG_DRIVER("\n");
> +	if (adjusted_mode->vrefresh == 0) {
> +/*		drm_mode_set_name(adjusted_mode); */
> +		adjusted_mode->vrefresh = drm_mode_vrefresh(adjusted_mode);
> +		DRM_DEBUG_DRIVER("%s@%d\n",
> +				adjusted_mode->name, adjusted_mode->vrefresh);
> +	}
> +	return true;
> +}
> +
> +static void dove_crtc_prepare(struct drm_crtc *crtc)
> +{
> +	DRM_DEBUG_DRIVER("\n");
> +	dove_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
> +}
> +
> +static void dove_crtc_commit(struct drm_crtc *crtc)
> +{
> +	DRM_DEBUG_DRIVER("\n");
> +/*	dove_crtc_dpms(crtc, DRM_MODE_DPMS_ON); */
> +}
> +
> +static int dove_crtc_mode_set(struct drm_crtc *crtc,
> +			struct drm_display_mode *mode,
> +			struct drm_display_mode *adjusted_mode,
> +			int x, int y,
> +			struct drm_framebuffer *old_fb)
> +{
> +	unsigned int bandwidth;
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	if (mode->hdisplay > 2048)
> +		return MODE_VIRTUAL_X;
> +
> +	/* width must be multiple of 16 */
> +	if (mode->hdisplay & 0xf)
> +		return MODE_VIRTUAL_X;
> +
> +	if (mode->vdisplay > 2048)
> +		return MODE_VIRTUAL_Y;
> +
> +	/* filter out modes that would require too much memory bandwidth: */
> +	bandwidth = mode->hdisplay * mode->vdisplay * drm_mode_vrefresh(mode);
> +	if (bandwidth > 1920 * 1080 * 60)
> +		return MODE_BAD;
> +
> +/*fixme: is this useful? */
> +	mode = &crtc->mode;
> +	if (mode->vrefresh == 0) {
> +		drm_mode_set_name(mode);
> +		mode->vrefresh = drm_mode_vrefresh(mode);
> +		DRM_DEBUG_DRIVER("%s@%d\n", mode->name, mode->vrefresh);
> +	}
> +	return MODE_OK;
> +}
> +
> +static int dove_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
> +				struct drm_framebuffer *old_fb)
> +{
> +	struct dove_lcd *dove_lcd = to_dove_lcd(crtc);
> +
> +	DRM_DEBUG_DRIVER("\n");
> +	dove_update_base(dove_lcd);
> +	return 0;
> +}
> +
> +/* mandatory drm function */
> +static void dove_crtc_load_lut(struct drm_crtc *crtc)
> +{
> +	DRM_DEBUG_DRIVER("\n");
> +}
> +
> +static const struct drm_crtc_funcs dove_crtc_funcs = {
> +	.cursor_set	= dove_cursor_set,
> +	.cursor_move	= dove_cursor_move,
> +	.destroy        = dove_crtc_destroy,
> +	.set_config     = drm_crtc_helper_set_config,
> +	.page_flip      = dove_crtc_page_flip,
> +};
> +
> +static const struct drm_crtc_helper_funcs dove_crtc_helper_funcs = {
> +	.dpms           = dove_crtc_dpms,
> +	.mode_fixup     = dove_crtc_mode_fixup,
> +	.prepare        = dove_crtc_prepare,
> +	.commit         = dove_crtc_commit,
> +	.mode_set       = dove_crtc_mode_set,
> +	.mode_set_base  = dove_crtc_mode_set_base,
> +	.load_lut       = dove_crtc_load_lut,
> +};
> +
> +void dove_crtc_cancel_page_flip(struct dove_lcd *dove_lcd,
> +				struct drm_file *file)
> +{
> +	struct drm_pending_vblank_event *event;
> +	struct drm_device *drm = dove_drm.drm;
> +	unsigned long flags;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	/*
> +	 * Destroy the pending vertical blanking event associated with the
> +	 * pending page flip, if any, and disable vertical blanking interrupts.
> +	 */
> +	spin_lock_irqsave(&drm->event_lock, flags);
> +	event = dove_lcd->event;
> +	if (event && event->base.file_priv == file) {
> +		dove_lcd->event = NULL;
> +		event->base.destroy(&event->base);
> +		drm_vblank_put(drm, dove_lcd->num);
> +	}
> +	spin_unlock_irqrestore(&drm->event_lock, flags);
> +}
> +
> +/* configure default register values */
> +static void dove_set_defaults(struct dove_lcd *dove_lcd)
> +{
> +	u32 x;
> +
> +	/* set the default clock */
> +	if (dove_lcd->clk[SCLK_SRC_PLLDIV])
> +		dove_lcd->clk_src = SCLK_SRC_PLLDIV;
> +	else
> +		dove_lcd->clk_src = SCLK_SRC_AXI;
> +	DRM_DEBUG_DRIVER("default clock %d\n", dove_lcd->clk_src);
> +
> +	x = SET_SCLK(dove_lcd->clk_src, 1, 0);
> +	dove_write(dove_lcd, LCD_CFG_SCLK_DIV, x);
> +	dove_write(dove_lcd, LCD_SPU_BLANKCOLOR, 0);
> +
> +	dove_write(dove_lcd, SPU_IOPAD_CONTROL, IOPAD_DUMB24);
> +	dove_write(dove_lcd, LCD_CFG_GRA_START_ADDR1, 0);
> +	dove_write(dove_lcd, LCD_SPU_GRA_OVSA_HPXL_VLN, 0);
> +	dove_write(dove_lcd, LCD_SPU_SRAM_PARA0, 0);
> +	dove_write(dove_lcd, LCD_SPU_SRAM_PARA1, CFG_CSB_256x32 |
> +						CFG_CSB_256x24 |
> +						CFG_CSB_256x8);
> +	dove_write(dove_lcd, LCD_SPU_DMA_CTRL1, CFG_VSYNC_TRIG(2) |
> +						CFG_GATED_ENA |
> +						CFG_PWRDN_ENA |
> +						CFG_ALPHA_MODE(2) |
> +						CFG_ALPHA(0xff) |
> +						CFG_PXLCMD(0x81));
> +
> +	/*
> +	 * Fix me: to avoid jiggling issue for high resolution in
> +	 * dual display, we set watermark to affect LCD AXI read
> +	 * from MC (default 0x80). Lower watermark means LCD will
> +	 * do DMA read more often.
> +	 */
> +	x = dove_read(dove_lcd, LCD_CFG_RDREG4F);
> +	x &= ~DMA_WATERMARK_MASK;
> +	x |= DMA_WATERMARK(0x20);
> +
> +	/*
> +	 * Disable LCD SRAM Read Wait State to resolve HWC32 make
> +	 * system hang while use external clock.
> +	 */
> +	x &= ~LCD_SRAM_WAIT;
> +	dove_write(dove_lcd, LCD_CFG_RDREG4F, x);
> +
> +	/* prepare the hwc32 */
> +	dove_set(dove_lcd, LCD_TV_CONTROL1, HWC32_ENABLE);
> +
> +	/* set hwc32 with 100% static alpha blending factor */
> +	dove_write(dove_lcd, LCD_SPU_ALPHA_COLOR1,
> +				HWC32_CFG_ALPHA(0xff));
> +}
> +
> +static irqreturn_t dove_lcd_irq(int irq, void *dev_id)
> +{
> +	struct dove_lcd *dove_lcd = (struct dove_lcd *) dev_id;
> +	struct drm_pending_vblank_event *event;
> +	struct drm_device *drm = dove_drm.drm;
> +	u32 isr;
> +	unsigned long flags;
> +
> +	isr = dove_read(dove_lcd, SPU_IRQ_ISR);
> +	dove_write(dove_lcd, SPU_IRQ_ISR, 0);
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	if (isr & IRQ_GRA_FRAME_DONE) {
> +#ifdef HANDLE_INTERLACE
> +		if (dove_lcd->v_sync0) {
> +			u32 x;
> +
> +			x = dove_read(dove_lcd, LCD_TV_CONTROL1);
> +			x &= ~(VSYNC_L_OFFSET_MASK | VSYNC_H_OFFSET_MASK);
> +			if (isr & IRQ_GRA_FRAME0)
> +				x |= dove_lcd->v_sync0;
> +			else
> +				x |= dove_lcd->v_sync1;
> +			dove_write(dove_lcd, LCD_TV_CONTROL1, x);
> +		}
> +		if (dove_lcd->vblank_enabled)
> +#endif
> +		drm_handle_vblank(drm, dove_lcd->num); 
> +		spin_lock_irqsave(&drm->event_lock, flags);
> +		event = dove_lcd->event;
> +		dove_lcd->event = NULL;
> +		if (event)
> +			drm_send_vblank_event(drm, dove_lcd->num, event);
> +		spin_unlock_irqrestore(&drm->event_lock, flags);
> +		if (event)
> +			drm_vblank_put(drm, dove_lcd->num);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/* initialize a lcd */
> +static int dove_crtc_init(struct dove_lcd *dove_lcd)
> +{
> +	struct drm_crtc *crtc = &dove_lcd->crtc;
> +	int ret;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	dove_lcd->dpms = DRM_MODE_DPMS_OFF;
> +
> +	ret = drm_crtc_init(dove_drm.drm, crtc, &dove_crtc_funcs);
> +	if (ret < 0)
> +		goto fail;
> +
> +	dove_write(dove_lcd, SPU_IRQ_ENA, 0);	/* disable interrupts */
> +	ret = devm_request_irq(dove_lcd->dev, dove_lcd->irq, dove_lcd_irq, 0,
> +			dove_lcd->name, dove_lcd);
> +	if (ret < 0) {
> +		dev_err(dove_lcd->dev, "unable to request irq %d\n",
> +				dove_lcd->irq);
> +		goto fail;
> +	}
> +
> +	if (ret < 0) {
> +		dev_err(dove_lcd->dev, "failed to install IRQ handler\n");
> +		goto fail;
> +	}
> +
> +	dove_set_defaults(dove_lcd);
> +	set_dumb_panel_control(dove_lcd, 1);
> +
> +	drm_crtc_helper_add(crtc, &dove_crtc_helper_funcs);
> +
> +	return 0;
> +
> +fail:
> +	dove_crtc_destroy(crtc);
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Overlay plane
> + */
> +
> +static void plane_update_base(struct dove_lcd *dove_lcd,
> +				int plane_num,
> +				struct drm_framebuffer *fb,
> +				int fmt,
> +				int x, int y,
> +				int w, int h)
> +{
> +	struct drm_gem_cma_object *gem;
> +	unsigned int addr;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	gem = drm_fb_cma_get_gem_obj(fb, plane_num);
> +
> +	addr = gem->paddr + fb->offsets[0] + y * fb->pitches[0] + x;
> +	dove_write(dove_lcd, LCD_SPU_DMA_START_ADDR_Y0, addr);
> +
> +	switch (fmt) {
> +	case VMODE_YUV422PLANAR:
> +	case VMODE_YUV420PLANAR:
> +		addr += w * h / 2;	/* planar */
> +		break;
> +	}
> +	dove_write(dove_lcd, LCD_SPU_DMA_START_ADDR_U0, addr);
> +
> +	switch (fmt) {
> +	case VMODE_YUV422PLANAR:
> +		addr += w * h / 2;
> +		break;
> +	case VMODE_YUV420PLANAR:
> +		addr += w * h / 4;
> +		break;
> +	}
> +	dove_write(dove_lcd, LCD_SPU_DMA_START_ADDR_V0, addr);
> +
> +	switch (fb->pixel_format) {
> +	case VMODE_YUV422PACKED:
> +		dove_write(dove_lcd, LCD_SPU_DMA_PITCH_YC,
> +						LCD_Y_C(w * 2, 0));
> +		dove_write(dove_lcd, LCD_SPU_DMA_PITCH_UV, LCD_U_V(w, w));
> +		break;
> +	default:
> +/*	case VMODE_YUV422PLANAR: */
> +/*	case VMODE_YUV420PLANAR: */
> +		dove_write(dove_lcd, LCD_SPU_DMA_PITCH_YC, LCD_Y_C(w, 0));
> +		dove_write(dove_lcd, LCD_SPU_DMA_PITCH_UV,
> +						LCD_U_V(w / 2, w / 2));
> +		break;
> +	}
> +}
> +
> +static int dove_plane_update(struct drm_plane *plane,
> +			struct drm_crtc *crtc,
> +			struct drm_framebuffer *fb,
> +			int crtc_x, int crtc_y,
> +			unsigned int crtc_w, unsigned int crtc_h,
> +			uint32_t src_x, uint32_t src_y,
> +			uint32_t src_w, uint32_t src_h)
> +{
> +	struct dove_lcd *dove_lcd = to_dove_lcd(crtc);
> +	u32 x, x_bk;
> +	int fmt, rbswap;
> +
> +	DRM_DEBUG_DRIVER("%d\n", plane == &dove_lcd->planes[PLANE_VID]);
> +
> +	if (plane != &dove_lcd->planes[PLANE_VID])
> +		return 0;
> +	rbswap = 1;				/* default */
> +	switch (fb->pixel_format) {
> +	case DRM_FORMAT_YVYU:
> +		rbswap = 0;
> +	case DRM_FORMAT_YUYV:
> +	case DRM_FORMAT_UYVY:
> +		fmt = VMODE_YUV422PACKED;
> +		break;
> +	case DRM_FORMAT_YVU422:
> +		rbswap = 0;
> +	case DRM_FORMAT_YUV422:
> +		fmt = VMODE_YUV422PLANAR;
> +		break;
> +	case DRM_FORMAT_YVU420:
> +		rbswap = 0;
> +	default:
> +/*	case DRM_FORMAT_YUV420: */
> +		fmt = VMODE_YUV420PLANAR;
> +		break;
> +	}
> +
> +	x_bk = x = dove_read(dove_lcd, LCD_SPU_DMA_CTRL0);
> +					/* clear video layer's field */
> +	x &= ~(CFG_YUV2RGB_DMA | CFG_DMA_SWAP_MASK |
> +		CFG_DMA_TSTMODE | CFG_DMA_HSMOOTH | CFG_DMA_FTOGGLE |
> +		CFG_DMAFORMAT_MASK | CFG_PALETTE_ENA);
> +	x |= CFG_DMA_HSMOOTH;		/* enable horizontal smooth scaling */
> +	x |= CFG_DMAFORMAT(fmt);	/* configure hardware pixel format */
> +/*fixme: no RGB */
> +	if (fb->pixel_format == DRM_FORMAT_UYVY) {
> +		x |= CFG_YUV2RGB_DMA;
> +	} else if (fmt == VMODE_YUV422PACKED) {
> +		x |= CFG_YUV2RGB_DMA |
> +			CFG_DMA_SWAPYU |
> +			CFG_DMA_SWAPRB;
> +		if (rbswap)
> +			x |= CFG_DMA_SWAPUV;
> +	} else {				/* planar */
> +		x |= CFG_YUV2RGB_DMA |
> +			CFG_DMA_SWAPRB;
> +		if (!rbswap)
> +			x |= CFG_DMA_SWAPUV;
> +	}
> +	if (x != x_bk)
> +		dove_write(dove_lcd, LCD_SPU_DMA_CTRL0, x);
> +
> +	/* set the dma addresses */
> +	plane_update_base(dove_lcd, PLANE_VID,
> +			fb, fmt, src_x, src_y, src_w, src_h);
> +
> +	/* original size */
> +	dove_write(dove_lcd, LCD_SPU_DMA_HPXL_VLN,
> +				LCD_H_V(src_w, src_h));
> +
> +	/* scaled size */
> +	dove_write(dove_lcd, LCD_SPU_DZM_HPXL_VLN,
> +				LCD_H_V(crtc_w, crtc_h));
> +
> +	/* update video position offset */
> +	dove_write(dove_lcd, LCD_SPUT_DMA_OVSA_HPXL_VLN,
> +				LCD_H_V(crtc_x, crtc_y));
> +	return 0;
> +}
> +
> +static int dove_plane_disable(struct drm_plane *plane)
> +{
> +	struct dove_lcd *dove_lcd = to_dove_lcd(plane->crtc);
> +
> +	DRM_DEBUG_DRIVER("%d\n",
> +			plane == &dove_lcd->planes[PLANE_VID]);
> +
> +	if (plane != &dove_lcd->planes[PLANE_VID])
> +		return 0;
> +
> +	dove_clear(dove_lcd, LCD_SPU_DMA_CTRL0, CFG_DMA_ENA);
> +	return 0;
> +}
> +
> +static void dove_plane_destroy(struct drm_plane *plane)
> +{
> +	dove_plane_disable(plane);
> +	drm_plane_cleanup(plane);
> +}
> +
> +static const struct drm_plane_funcs plane_funcs = {
> +	.update_plane = dove_plane_update,
> +	.disable_plane = dove_plane_disable,
> +	.destroy = dove_plane_destroy,
> +};
> +static const uint32_t gfx_formats[] = {
> +	DRM_FORMAT_BGR888,
> +	DRM_FORMAT_RGB888,
> +	DRM_FORMAT_XBGR8888,
> +	DRM_FORMAT_XRGB8888,
> +	DRM_FORMAT_ABGR8888,
> +	DRM_FORMAT_ARGB8888,
> +	DRM_FORMAT_YVYU,
> +	DRM_FORMAT_YUYV,
> +	DRM_FORMAT_YVU422,
> +	DRM_FORMAT_YUV422,
> +	DRM_FORMAT_YVU420,
> +	DRM_FORMAT_YUV420,
> +};
> +static const uint32_t vid_formats[] = {
> +	DRM_FORMAT_YVYU,
> +	DRM_FORMAT_YUYV,
> +	DRM_FORMAT_YVU422,
> +	DRM_FORMAT_YUV422,
> +	DRM_FORMAT_YVU420,
> +	DRM_FORMAT_YUV420,
> +	DRM_FORMAT_UYVY,
> +};
> +
> +static int dove_planes_init(struct dove_lcd *dove_lcd)
> +{
> +	struct drm_device *drm = dove_drm.drm;
> +	struct drm_plane *plane;
> +	int ret;
> +
> +	if (false) {
> +		plane = &dove_lcd->planes[PLANE_VID];
> +		ret = drm_plane_init(drm, plane, 1 << dove_lcd->num,
> +				&plane_funcs,
> +				gfx_formats, ARRAY_SIZE(gfx_formats), true);
> +		if (ret < 0)
> +			return ret;
> +		plane->crtc = &dove_lcd->crtc;
> +	}
> +	plane = &dove_lcd->planes[PLANE_VID];
> +	ret = drm_plane_init(drm, plane, 1 << dove_lcd->num,
> +				&plane_funcs,
> +				vid_formats, ARRAY_SIZE(vid_formats), false);
> +	if (ret < 0)
> +		return ret;
> +	plane->crtc = &dove_lcd->crtc;
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Initialization
> + */
> +
> +int dove_lcd_init(struct dove_lcd *dove_lcd)
> +{
> +	int ret;
> +
> +	ret = dove_crtc_init(dove_lcd);
> +	if (ret < 0)
> +		return ret;
> +	ret = dove_planes_init(dove_lcd);
> +	if (ret < 0)
> +		dev_err(dove_lcd->dev, "failed to create the planes\n");
> +
> +	return ret;
> +}
> +
> +/* at probe time, get the possible LCD clocks */
> +static int get_lcd_clocks(struct dove_lcd *dove_lcd)
> +{
> +	struct device *dev = dove_lcd->dev;
> +	struct device_node *np = dev->of_node;
> +	struct of_phandle_args clkspec;
> +	struct clk *clk;
> +	int i, no_clock, ret;
> +
> +	no_clock = 1;
> +	for (i = 0; i < MAX_CLK; i++) {
> +
> +		/* check first if there is a phandle to the clock */
> +		ret = of_parse_phandle_with_args(np,
> +					"clocks", "#clock-cells", i,
> +					&clkspec);
> +		if (ret)
> +			continue;		/* no defined clock here */
> +		of_node_put(clkspec.np);
> +
> +		/* if no clock driver, ignore this clock */
> +		clk = of_clk_get(np, i);
> +		if (IS_ERR(clk)) {
> +			if (!dove_drm.probe_defer) {
> +				dove_drm.probe_defer = 1;
> +				return -EPROBE_DEFER;
> +			}
> +			dev_err(dev, "no driver for clock %i\n", i);
> +			continue;
> +		}
> +		DRM_DEBUG_DRIVER("clock %d ok\n", i);
> +		clk_prepare_enable(clk);
> +		dove_lcd->clk[i] = clk;
> +		no_clock = 0;
> +	}
> +	if (no_clock) {
> +		dev_err(dev, "no available clock\n");
> +		return -EINVAL;
> +	}
> +	if (!dove_lcd->clk[SCLK_SRC_PLLDIV] && !dove_lcd->clk[SCLK_SRC_AXI]) {
> +		dev_err(dev, "no fixed clock\n");
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int dove_lcd_remove(struct platform_device *pdev)
> +{
> +	struct dove_lcd *dove_lcd = platform_get_drvdata(pdev);
> +	struct clk *clk;
> +	int i;
> +
> +	dove_write(dove_lcd, SPU_IRQ_ENA, 0);	/* disable interrupts */
> +
> +	if (dove_drm.lcds[dove_lcd->num] == dove_lcd)
> +		dove_drm.lcds[dove_lcd->num] = NULL;
> +
> +	for (i = 0; i < MAX_CLK; i++) {
> +		clk = dove_lcd->clk[i];
> +		if (clk) {
> +			clk_disable_unprepare(clk);
> +			clk_put(clk);
> +		}
> +	}
> +	
> +	kfree(dove_lcd);
> +	return 0;
> +}
> +
> +static int dove_lcd_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct dove_lcd *dove_lcd;
> +	struct resource *res;
> +	int ret;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	/* bail out early if no DT data */
> +	if (!np) {
> +		dev_err(dev, "no device-tree\n");
> +		return -ENXIO;
> +	}
> +
> +	dove_lcd = kzalloc(sizeof *dove_lcd, GFP_KERNEL);
> +	if (!dove_lcd) {
> +		dev_err(dev, "failed to allocate private data\n");
> +		return -ENOMEM;
> +	}
> +	platform_set_drvdata(pdev, dove_lcd);
> +	dove_lcd->dev = dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(dev, "failed to get memory resource\n");
> +		ret = -EINVAL;
> +		goto fail;
> +	}
> +
> +	dove_lcd->mmio = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(dove_lcd->mmio)) {
> +		dev_err(dev, "failed map registers\n");
> +		ret = PTR_ERR(dove_lcd->mmio);
> +		dove_lcd->mmio = NULL;
> +		goto fail;
> +	}
> +
> +	switch (((u32) dove_lcd->mmio) & DOVE_LCD_REG_BASE_MASK) {
> +	case DOVE_LCD0_REG_BASE:
> +/*		dove_lcd->num = 0; */
> +		break;
> +	case DOVE_LCD1_REG_BASE:
> +		dove_lcd->num = 1;
> +		break;
> +	default:
> +		dev_err(dev, "unknown lcd reg base %08x\n",
> +					(u32) dove_lcd->mmio);
> +		ret = -EINVAL;
> +		goto fail;
> +	}
> +	snprintf(dove_lcd->name, sizeof dove_lcd->name, "dove-lcd%d",
> +			dove_lcd->num);
> +	dove_drm.lcds[dove_lcd->num] = dove_lcd;
> +
> +	dove_lcd->irq = irq_of_parse_and_map(np, 0);
> +	if (dove_lcd->irq < 0 || dove_lcd->irq == NO_IRQ) {
> +		dev_err(dev, "unable to get irq lcd %d\n", dove_lcd->num);
> +		ret = -EINVAL;
> +		goto fail;
> +	}
> +
> +	ret = get_lcd_clocks(dove_lcd);
> +	if (ret < 0)
> +		goto fail;
> +
> +	/* check the presence of a possible external slave encoder */
> +	ret = dove_ec_probe(dove_lcd);
> +	if (ret < 0)
> +		goto fail;
> +
> +	/* init done, try to initialize the drm driver */
> +	return dove_probed();
> +
> +fail:
> +	dove_lcd_remove(pdev);
> +	return ret;
> +}
> +
> +static struct of_device_id dove_lcd_of_match[] = {
> +	{ .compatible = "marvell,dove-lcd" },
> +	{ },
> +};
> +struct platform_driver dove_lcd_platform_driver = {
> +	.driver     = {
> +		.owner  = THIS_MODULE,
> +		.name   = "dove-lcd",
> +		.of_match_table = dove_lcd_of_match,
> +	},
> +	.probe      = dove_lcd_probe,
> +	.remove     = dove_lcd_remove,
> +};
> diff --git a/drivers/gpu/drm/dove/dove_dcon.h b/drivers/gpu/drm/dove/dove_dcon.h
> new file mode 100644
> index 0000000..da2b99c
> --- /dev/null
> +++ b/drivers/gpu/drm/dove/dove_dcon.h
> @@ -0,0 +1,64 @@
> +/*
> + * Display controller registers of Marvell DOVE
> + *
> + * Copyright (C) 2013
> + *   Jean-Francois Moine <moinejf@free.fr>
> + *   Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _DOVE_DCON_H_
> +#define	_DOVE_DCON_H_
> +
> +/* ------------< DCON register >------------ */
> +
> +#define DCON_CTL0		0x0000
> +#define   VGA_CLK_DISABLE		BIT(25)
> +#define   DCON_CLK_DISABLE		BIT(24)
> +#define   DCON_RST			BIT(23)
> +#define   LCD_Disable			BIT(17)
> +#define   Reverse_Scan			BIT(10)
> +#define   LCD_Port_B_Select_MASK	0x00000300
> +#define		Port_B_Select_LCD1	0x00000000
> +#define		Port_B_Select_LCD0	0x00000100
> +#define		Port_B_Select_A_copy	0x00000300
> +#define   LCD_Port_A_Select_MASK	0x000000c0
> +#define		Port_A_Select_LCD	0x00000000
> +#define		Port_A_Select_OLPC	0x00000040
> +#define		Port_A_Select_Dual	0x00000080
> +#define		Port_A_Select_ext	0x000000c0
> +#define   LBUF_EN			BIT(5)
> +#define DCON_IRQ_CTL		0x0008
> +#define   IRQ_Control_MASK		0x00ff0000
> +#define DITHER_REG_R		0x0050
> +#define DITHER_REG_G		0x0054
> +#define DITHER_REG_B		0x0058
> +#define DCON_DITHER_PAT_RL	0x0060
> +#define DCON_DITHER_PAT_RH	0x0064
> +#define DCON_DITHER_PAT_GL	0x0068
> +#define DCON_DITHER_PAT_GH	0x006c
> +#define DCON_DITHER_PAT_BL	0x0070
> +#define DCON_DITHER_PAT_BH	0x0074
> +#define VGA_Global		0x0080
> +#define VGA_CHA			0x0084
> +#define VGA_CHB			0x0088
> +#define VGA_CHC			0x008c
> +#define VGA_CHA_STA		0x0090
> +#define VGA_CHB_STA		0x0094
> +#define VGA_CHC_STA		0x0098
> +#define CT_LUT_INDEX		0x00a4
> +#define CT_LUT_DATA		0x00a8
> +#define FTDLL_CTL		0x00c0
> +
> +#endif /* _DOVE_DCON_H_ */
> diff --git a/drivers/gpu/drm/dove/dove_drv.c b/drivers/gpu/drm/dove/dove_drv.c
> new file mode 100644
> index 0000000..e9e77ad
> --- /dev/null
> +++ b/drivers/gpu/drm/dove/dove_drv.c
> @@ -0,0 +1,380 @@
> +/*
> + * Marvell Dove DRM driver - main
> + *
> + * Copyright (C) 2013
> + *   Jean-Francois Moine <moinejf@free.fr>
> + *   Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pm.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/of.h>
> +
> +#include "dove_drv.h"
> +
> +#define DRIVER_NAME	"dove-drm"
> +#define DRIVER_DESC	"Marvell Dove DRM"
> +#define DRIVER_DATE	"20130516"
> +#define DRIVER_MAJOR	1
> +#define DRIVER_MINOR	0
> +
> +struct dove_drm dove_drm;
> +static struct platform_device *g_pdev;
> +static atomic_t probed;
> +
> +static struct drm_framebuffer *dove_fb_create(struct drm_device *drm,
> +					struct drm_file *file_priv,
> +					struct drm_mode_fb_cmd2 *mode_cmd)
> +{
> +	DRM_DEBUG_DRIVER("fmt %.4s\n", (char *) &mode_cmd->pixel_format);
> +
> +	switch (mode_cmd->pixel_format) {
> +	case DRM_FORMAT_BGR888:
> +	case DRM_FORMAT_RGB888:
> +	case DRM_FORMAT_XBGR8888:
> +	case DRM_FORMAT_XRGB8888:
> +	case DRM_FORMAT_ABGR8888:
> +	case DRM_FORMAT_ARGB8888:
> +	case DRM_FORMAT_YVYU:
> +	case DRM_FORMAT_YUYV:
> +	case DRM_FORMAT_YVU422:
> +	case DRM_FORMAT_YUV422:
> +	case DRM_FORMAT_YVU420:
> +	case DRM_FORMAT_YUV420:
> +		break;
> +	default:
> +		return ERR_PTR(-EINVAL);
> +	}
> +	return drm_fb_cma_create(drm, file_priv, mode_cmd);
> +}
> +
> +static void dove_fb_output_poll_changed(struct drm_device *drm)
> +{
> +	DRM_DEBUG_DRIVER("fb:%d\n", dove_drm.fbdev != NULL);
> +	if (dove_drm.fbdev)
> +		drm_fbdev_cma_hotplug_event(dove_drm.fbdev);
> +}
> +
> +static const struct drm_mode_config_funcs mode_config_funcs = {
> +	.fb_create = dove_fb_create,
> +	.output_poll_changed = dove_fb_output_poll_changed,
> +};
> +
> +/*
> + * DRM operations:
> + */
> +static int dove_unload(struct drm_device *drm)
> +{
> +	struct dove_lcd *dove_lcd;
> +	int i;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	for (i = 0; i < MAX_DOVE_LCD; i++) {
> +		dove_lcd = dove_drm.lcds[i];
> +		if (dove_lcd) {
> +			if (dove_lcd->planes[PLANE_VID].dev)
> +				drm_plane_cleanup(&dove_lcd->planes[PLANE_VID]);
> +			if (dove_lcd->planes[PLANE_GFX].dev)
> +				drm_plane_cleanup(&dove_lcd->planes[PLANE_GFX]);
> +		}
> +	}
> +	drm_kms_helper_poll_fini(drm);
> +	drm_mode_config_cleanup(drm);
> +	drm_vblank_cleanup(drm);
> +
> +	return 0;
> +}
> +
> +/* this function is called when all LCDs and dcon have been probed */
> +static int dove_load(struct drm_device *drm, unsigned long flags)
> +{
> +	struct platform_device *pdev = drm->platformdev;
> +	struct dove_lcd *dove_lcd;
> +	int i, ret;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	dove_drm.drm = drm;
> +	platform_set_drvdata(pdev, &dove_drm);
> +	drm->dev_private = &dove_drm;
> +
> +	drm_mode_config_init(drm);
> +
> +/*	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32); */
> +
> +	for (i = 0; i < MAX_DOVE_LCD; i++) {
> +		dove_lcd = dove_drm.lcds[i];
> +		if (dove_lcd) {
> +			ret = dove_lcd_init(dove_lcd);
> +			if (ret < 0)
> +				goto fail;
> +			ret = dove_ec_init(dove_lcd);
> +			if (ret < 0)
> +				goto fail;
> +		}
> +	}
> +
> +	drm->mode_config.min_width = 0;
> +	drm->mode_config.min_height = 0;
> +	drm->mode_config.max_width = 2048;
> +	drm->mode_config.max_height = 2048;
> +	drm->mode_config.funcs = &mode_config_funcs;
> +
> +	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
> +	if (ret < 0) {
> +		dev_err(drm->dev, "failed to initialize vblank\n");
> +		goto fail;
> +	}
> +
> +	dove_drm.fbdev = drm_fbdev_cma_init(drm,
> +					32,	/* bpp */
> +					drm->mode_config.num_crtc,
> +					drm->mode_config.num_connector);
> +
> +	drm_kms_helper_poll_init(drm);
> +	return 0;
> +fail:
> +	dove_unload(drm);
> +	return ret;
> +}
> +
> +static void dove_preclose(struct drm_device *drm, struct drm_file *file)
> +{
> +	struct dove_lcd *dove_lcd;
> +	int i;
> +
> +	for (i = 0; i < MAX_DOVE_LCD; i++) {
> +		dove_lcd = dove_drm.lcds[i];
> +		if (dove_lcd)
> +			dove_crtc_cancel_page_flip(dove_lcd, file);
> +	}
> +}
> +
> +static void dove_lastclose(struct drm_device *drm)
> +{
> +	drm_fbdev_cma_restore_mode(dove_drm.fbdev);
> +}
> +
> +static int dove_gem_cma_dumb_create(struct drm_file *file_priv,
> +				struct drm_device *dev,
> +				struct drm_mode_create_dumb *args)
> +{
> +	if (args->height * args->width * args->bpp == 0) {
> +		dev_err(dev->dev, "dumb_create %dx%d bpp %d!\n",
> +			args->height, args->width, args->bpp);
> +		return -ENOMEM;
> +	}
> +	return drm_gem_cma_dumb_create(file_priv, dev, args);
> +}
> +
> +static const struct file_operations fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= drm_open,
> +	.release	= drm_release,
> +	.unlocked_ioctl	= drm_ioctl,
> +	.poll		= drm_poll,
> +	.read		= drm_read,
> +	.fasync		= drm_fasync,
> +	.llseek		= no_llseek,
> +	.mmap		= drm_gem_cma_mmap,
> +};
> +
> +static struct drm_driver dove_driver = {
> +	.driver_features	= DRIVER_GEM | DRIVER_MODESET,
> +	.load			= dove_load,
> +	.unload			= dove_unload,
> +	.preclose		= dove_preclose,
> +	.lastclose		= dove_lastclose,
> +	.get_vblank_counter	= dove_vblank_count,
> +	.enable_vblank		= dove_enable_vblank,
> +	.disable_vblank		= dove_disable_vblank,
> +	.gem_free_object	= drm_gem_cma_free_object,
> +	.gem_vm_ops		= &drm_gem_cma_vm_ops,
> +	.dumb_create		= dove_gem_cma_dumb_create,
> +	.dumb_map_offset	= drm_gem_cma_dumb_map_offset,
> +	.dumb_destroy		= drm_gem_cma_dumb_destroy,
> +#ifdef CONFIG_DEBUG_FS
> +	.debugfs_init		= dove_debugfs_init,
> +	.debugfs_cleanup	= dove_debugfs_cleanup,
> +#endif
> +	.fops			= &fops,
> +
> +	.name			= DRIVER_NAME,
> +	.desc			= DRIVER_DESC,
> +	.date			= DRIVER_DATE,
> +	.major			= DRIVER_MAJOR,
> +	.minor			= DRIVER_MINOR,
> +};
> +
> +#ifdef CONFIG_PM_SLEEP
> +/*
> + * Power management
> + */
> +static int dove_pm_suspend(struct device *dev)
> +{
> +	struct drm_device *drm = dev_get_drvdata(dev);
> +	struct dove_lcd *dove_lcd;
> +	int i;
> +
> +	drm_kms_helper_poll_disable(drm);
> +	for (i = 0; i < MAX_DOVE_LCD; i++) {
> +		dove_lcd = dove_drm.lcds[i];
> +		if (dove_lcd)
> +			dove_crtc_stop(dove_lcd);
> +	}
> +	return 0;
> +}
> +
> +static int dove_pm_resume(struct device *dev)
> +{
> +	struct drm_device *drm = dev_get_drvdata(dev);
> +	struct dove_lcd *dove_lcd;
> +	int i;
> +
> +	for (i = 0; i < MAX_DOVE_LCD; i++) {
> +		dove_lcd = dove_drm.lcds[i];
> +		if (dove_lcd
> +		 && dove_lcd->dpms == DRM_MODE_DPMS_ON)
> +			dove_crtc_start(dove_lcd);
> +	}
> +	drm_kms_helper_poll_enable(drm);
> +	return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops dove_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(dove_pm_suspend, dove_pm_resume)
> +};
> +
> +/*
> + * Platform driver
> + */
> +
> +/* count the number of awaited sub devices */
> +static int dove_subdev_cnt(void)
> +{
> +	struct device_node *np;
> +	unsigned int n;
> +	static struct of_device_id dove_of_subdev[] = {
> +		{ .compatible = "marvell,dove-lcd" },
> +		{ .compatible = "marvell,dove-dcon" },
> +		{ },
> +	};
> +
> +	n = 0;
> +	np = NULL;
> +	for (;;) {
> +		np = of_find_matching_node_and_match(np,
> +						dove_of_subdev, NULL);
> +		if (!np)
> +			break;
> +		if (of_device_is_available(np))
> +			n++;
> +	}
> +	return n;
> +}
> +
> +int dove_probed(void)
> +{
> +	if (atomic_add_return(1, &probed) == 0)
> +		return drm_platform_init(&dove_driver, g_pdev);
> +	return 0;
> +}
> +
> +static int dove_pdev_probe(struct platform_device *pdev)
> +{
> +	int awaited;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	g_pdev = pdev;
> +
> +	awaited = dove_subdev_cnt();
> +	if (awaited == 0) {
> +		dev_err(&pdev->dev, "no lcd nor dcon devices\n");
> +		return -ENXIO;
> +	}
> +	if (atomic_sub_return(awaited, &probed) == 0)
> +		return drm_platform_init(&dove_driver, pdev);
> +	return 0;
> +}
> +
> +static int dove_pdev_remove(struct platform_device *pdev)
> +{
> +	drm_platform_exit(&dove_driver, pdev);
> +	return 0;
> +}
> +
> +static struct of_device_id dove_of_match[] = {
> +	{ .compatible = "marvell,dove-video" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, dove_of_match);
> +
> +static struct platform_driver dove_platform_driver = {
> +	.probe      = dove_pdev_probe,
> +	.remove     = dove_pdev_remove,
> +	.driver     = {
> +		.owner  = THIS_MODULE,
> +		.name   = "dove-drm",
> +		.pm     = &dove_pm_ops,
> +		.of_match_table = dove_of_match,
> +	},
> +};
> +
> +static int __init dove_drm_init(void)
> +{
> +	int ret;
> +
> +	/* wait for other drivers to be loaded (si5351, tda998x..) */
> +	msleep(200);
> +
> +/* uncomment to activate the drm trace at startup time */
> +/*	drm_debug = DRM_UT_CORE | DRM_UT_DRIVER | DRM_UT_KMS; */
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	ret = platform_driver_register(&dove_lcd_platform_driver);
> +	if (ret < 0)
> +		return ret;
> +	ret = platform_driver_register(&dove_dcon_platform_driver);
> +	if (ret < 0)
> +		goto out1;
> +	ret = platform_driver_register(&dove_platform_driver);
> +	if (ret < 0)
> +		goto out2;
> +	return 0;
> +
> +out2:
> +	platform_driver_unregister(&dove_dcon_platform_driver);
> +out1:
> +	platform_driver_unregister(&dove_lcd_platform_driver);
> +	return ret;
> +}
> +static void __exit dove_drm_fini(void)
> +{
> +	platform_driver_unregister(&dove_platform_driver);
> +	platform_driver_unregister(&dove_dcon_platform_driver);
> +	platform_driver_unregister(&dove_lcd_platform_driver);
> +}
> +module_init(dove_drm_init);
> +module_exit(dove_drm_fini);
> +
> +MODULE_AUTHOR("Jean-Francois Moine <moinejf@free.fr>");
> +MODULE_AUTHOR("Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>");
> +MODULE_DESCRIPTION("Marvell Dove DRM Driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/gpu/drm/dove/dove_drv.h b/drivers/gpu/drm/dove/dove_drv.h
> new file mode 100644
> index 0000000..7488c7e
> --- /dev/null
> +++ b/drivers/gpu/drm/dove/dove_drv.h
> @@ -0,0 +1,93 @@
> +/*
> + * Copyright (C) 2013 Jean-François Moine
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __DOVE_DRV_H__
> +#define __DOVE_DRV_H__
> +
> +#include <linux/clk.h>
> +#include <drm/drmP.h>
> +#include <drm/drm_crtc_helper.h>
> +#include <drm/drm_encoder_slave.h>
> +#include <drm/drm_gem_cma_helper.h>
> +#include <drm/drm_fb_cma_helper.h>
> +
> +/* (not tested) */
> +/*#define HANDLE_INTERLACE 1*/
> +
> +#define MAX_DOVE_LCD 2		/* max number of dove lcd devices */
> +#define MAX_CLK 4		/* max number of clocks per crtc */
> +
> +#define PLANE_GFX 0
> +#define PLANE_VID 1
> +#define NPLANES 2
> +
> +struct dove_lcd {
> +	void __iomem *mmio;
> +	struct device *dev;
> +	struct drm_crtc crtc;
> +
> +	u8 num;			/* index in dove_drm */
> +	u8 dpms;
> +
> +#ifdef HANDLE_INTERLACE
> +	u8 vblank_enabled;
> +	u32 v_sync0;
> +	u32 v_sync1;
> +#endif
> +
> +	short clk_src;		/* current clock source */
> +	struct clk *clk[MAX_CLK];
> +
> +	int irq;
> +	char name[16];
> +
> +	struct drm_pending_vblank_event *event;
> +
> +	struct drm_plane planes[NPLANES];
> +
> +	struct drm_connector connector;
> +	struct drm_encoder_slave encoder_slave;
> +};
> +
> +struct dove_drm {
> +	struct drm_device *drm;
> +	struct dove_lcd *lcds[MAX_DOVE_LCD];
> +
> +	struct drm_fbdev_cma *fbdev;
> +	int probe_defer;
> +};
> +
> +extern struct dove_drm dove_drm;
> +int dove_probed(void);
> +
> +u32 dove_vblank_count(struct drm_device *dev, int crtc);
> +int dove_enable_vblank(struct drm_device *dev, int crtc);
> +void dove_disable_vblank(struct drm_device *dev, int crtc);
> +int dove_lcd_init(struct dove_lcd *dove_lcd);
> +void dove_crtc_cancel_page_flip(struct dove_lcd *dove_lcd,
> +				struct drm_file *file);
> +void dove_crtc_start(struct dove_lcd *dove_lcd);
> +void dove_crtc_stop(struct dove_lcd *dove_lcd);
> +#ifdef CONFIG_DEBUG_FS
> +int dove_debugfs_init(struct drm_minor *minor);
> +void dove_debugfs_cleanup(struct drm_minor *minor);
> +#endif
> +extern struct platform_driver dove_lcd_platform_driver;
> +
> +int dove_ec_probe(struct dove_lcd *dove_lcd);
> +int dove_ec_init(struct dove_lcd *dove_lcd);
> +extern struct platform_driver dove_dcon_platform_driver;
> +#endif /* __DOVE_DRV_H__ */
> diff --git a/drivers/gpu/drm/dove/dove_ec.c b/drivers/gpu/drm/dove/dove_ec.c
> new file mode 100644
> index 0000000..003b031
> --- /dev/null
> +++ b/drivers/gpu/drm/dove/dove_ec.c
> @@ -0,0 +1,570 @@
> +/*
> + * Marvell Dove DRM driver - encoder / connector and display controller
> + *
> + * Copyright (C) 2013
> + *   Jean-Francois Moine <moinejf@free.fr>
> + *   Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/i2c.h>
> +#include <linux/of_i2c.h>
> +#include <linux/module.h>
> +
> +#include "dove_drv.h"
> +#include "dove_dcon.h"
> +
> +struct dove_dcon {
> +	void __iomem *mmio;
> +	struct device *dev;
> +};
> +static struct dove_dcon dove_dcon;
> +
> +/* -----------------------------------------------------------------------------
> + * Encoder
> + */
> +/* LVDS and VGA/DAC functions */
> +static void dove_encoder_dpms(struct drm_encoder *encoder, int mode)
> +{
> +}
> +static bool dove_encoder_mode_fixup(struct drm_encoder *encoder,
> +				const struct drm_display_mode *mode,
> +				struct drm_display_mode *adjusted_mode)
> +{
> +	return true;
> +}
> +static void dove_encoder_prepare(struct drm_encoder *encoder)
> +{
> +}
> +static void dove_encoder_commit(struct drm_encoder *encoder)
> +{
> +}
> +static void dove_encoder_mode_set(struct drm_encoder *encoder,
> +				struct drm_display_mode *mode,
> +				struct drm_display_mode *adjusted_mode)
> +{
> +}
> +
> +static const struct drm_encoder_helper_funcs lvds_encoder_helper_funcs = {
> +	.dpms = dove_encoder_dpms,
> +	.mode_fixup = dove_encoder_mode_fixup,
> +	.prepare = dove_encoder_prepare,
> +	.commit = dove_encoder_commit,
> +	.mode_set = dove_encoder_mode_set,
> +};
> +
> +/* HDMI (i2c) functions */
> +static const struct drm_encoder_helper_funcs hdmi_encoder_helper_funcs = {
> +	.dpms = drm_i2c_encoder_dpms,
> +	.mode_fixup = drm_i2c_encoder_mode_fixup,
> +	.prepare = drm_i2c_encoder_prepare,
> +	.commit = drm_i2c_encoder_commit,
> +	.mode_set = drm_i2c_encoder_mode_set,
> +};
> +
> +static void dove_drm_encoder_destroy(struct drm_encoder *encoder)
> +{
> +	struct drm_encoder_slave *encoder_slave = to_encoder_slave(encoder);
> +	struct i2c_client *i2c_client;
> +	struct module *module;
> +
> +	if (encoder_slave->slave_funcs)
> +		encoder_slave->slave_funcs->destroy(encoder);
> +	i2c_client = encoder_slave->bus_priv;
> +	if (i2c_client) {
> +		module = i2c_client->driver->driver.owner;
> +		module_put(module);
> +	}
> +	if (encoder->dev)
> +		drm_encoder_cleanup(encoder);
> +}
> +
> +static const struct drm_encoder_funcs encoder_funcs = {
> +	.destroy = dove_drm_encoder_destroy,
> +};
> +
> +static int dove_encoder_get_hdmi(struct dove_lcd *dove_lcd)
> +{
> +	struct device *dev = dove_lcd->dev;
> +	struct drm_device *drm = dove_drm.drm;
> +	struct drm_encoder_slave *encoder_slave = &dove_lcd->encoder_slave;
> +	struct drm_encoder *encoder = &encoder_slave->base;
> +	struct drm_connector *connector = &dove_lcd->connector;
> +	struct i2c_client *i2c_client;
> +	struct module *module;
> +	struct drm_i2c_encoder_driver *encoder_drv;
> +	int ret;
> +
> +	i2c_client = encoder_slave->bus_priv;
> +	if (!i2c_client) {
> +		dev_err(dev, "no external-encoder for hdmi\n");
> +		return -EINVAL;
> +	}
> +
> +	encoder_drv = to_drm_i2c_encoder_driver(i2c_client->driver);
> +	if (!encoder_drv || !encoder_drv->encoder_init) {
> +		dev_err(dev, "no external encoder init\n");
> +		return -EINVAL;
> +	}
> +
> +	/* lock the external encoder module */
> +	module = i2c_client->driver->driver.owner;
> +	if (!module || !try_module_get(module)) {
> +		dev_err(dev, "cannot get module %s\n", module->name);
> +		return -EINVAL;
> +	}
> +
> +	ret = encoder_drv->encoder_init(i2c_client, drm, encoder_slave);
> +	if (ret < 0) {
> +		dev_err(dev, "slave encoder init failed\n");
> +		return ret;
> +	}
> +	encoder_slave->slave_funcs->create_resources(encoder, connector);
> +	return ret;
> +}
> +
> +static int dove_encoder_init(struct dove_lcd *dove_lcd,
> +				int mode_encoder)
> +{
> +	struct drm_device *drm = dove_drm.drm;
> +	struct drm_encoder_slave *encoder_slave = &dove_lcd->encoder_slave;
> +	struct drm_encoder *encoder = &encoder_slave->base;
> +	int ret;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	/* do early init in case of error */
> +	ret = drm_encoder_init(drm, encoder, &encoder_funcs, mode_encoder);
> +	if (ret < 0) {
> +		dev_err(dove_lcd->dev, "drm encoder init failed\n");
> +		return ret;
> +	}
> +
> +	encoder->possible_crtcs = 1 << dove_lcd->num;
> +
> +	/*
> +	 * If the display controller is present,
> +	 * - the port A cannot be VGA/DAC,
> +	 * - the port B can be only VGA/DAC and may receive the lcd 0 output.
> +	 */
> +	if (dove_dcon.mmio) {
> +		if (dove_lcd->num == 0) {
> +			if (mode_encoder == DRM_MODE_ENCODER_DAC) {
> +				dev_err(dove_lcd->dev,
> +						"bad lcd 0 port-type\n");
> +				return -EINVAL;
> +			}
> +		} else {
> +			if (mode_encoder != DRM_MODE_ENCODER_DAC) {
> +				dev_err(dove_lcd->dev,
> +						"bad lcd 1 port-type\n");
> +				return -EINVAL;
> +			}
> +			encoder->possible_crtcs |= 1;
> +
> +			/* the port B may receive the LCD 0 output */
> +			encoder->possible_clones = 1;
> +		}
> +	}
> +
> +	switch (mode_encoder) {
> +	case DRM_MODE_ENCODER_DAC:
> +/*fixme: to do */
> +	case DRM_MODE_ENCODER_LVDS:
> +		drm_encoder_helper_add(encoder, &lvds_encoder_helper_funcs);
> +		ret = 0;
> +		break;
> +	case DRM_MODE_ENCODER_TMDS:
> +		drm_encoder_helper_add(encoder, &hdmi_encoder_helper_funcs);
> +		ret = dove_encoder_get_hdmi(dove_lcd);
> +		break;
> +	}
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Connector
> + */
> +
> +static int dove_lvds_get_modes(struct dove_lcd *dove_lcd)
> +{
> +	struct device *dev = dove_lcd->dev;
> +	struct device_node *np = dev->of_node;
> +	struct drm_connector *connector = &dove_lcd->connector;
> +	struct drm_display_mode *mode;
> +	int clock, hdisplay, vdisplay, hfp, hbp, vfp, vbp, hs, vs;
> +	int w_mm, h_mm;
> +	int ret;
> +
> +	/* same as of_videomode, but simpler! */
> +	np = of_find_node_by_name(np, "display-timings");
> +	if (!np) {
> +		dev_err(dev, "no display-timings\n");
> +		return -EINVAL;
> +	}
> +	np = of_get_next_child(np, NULL);
> +	if (!np) {
> +		dev_err(dev, "no 'mode' subnode in DT\n");
> +		return -EINVAL;
> +	}
> +
> +	ret = 0;
> +	ret |= of_property_read_u32(np, "hactive", &hdisplay);
> +	ret |= of_property_read_u32(np, "vactive", &vdisplay);
> +	ret |= of_property_read_u32(np, "hfront-porch", &hfp);
> +	ret |= of_property_read_u32(np, "hsync-len", &hs);
> +	ret |= of_property_read_u32(np, "hback-porch", &hbp);
> +	ret |= of_property_read_u32(np, "vfront-porch", &vfp);
> +	ret |= of_property_read_u32(np, "vsync-len", &vs);
> +	ret |= of_property_read_u32(np, "vback-porch", &vbp);
> +	ret |= of_property_read_u32(np, "clock", &clock);
> +	if (ret) {
> +		dev_err(dev, "bad display-timings\n");
> +		return -EINVAL;
> +	}
> +	if (clock < 15000 || clock > 150000) {
> +		dev_err(dev, "bad clock\n");
> +		return -EINVAL;
> +	}
> +
> +	mode = drm_mode_create(dove_drm.drm);
> +	if (!mode) {
> +		ret = -ENOMEM;
> +		return ret;
> +	}
> +
> +	mode->clock = clock;
> +	mode->hdisplay = hdisplay;
> +	mode->hsync_start = hdisplay + hfp;
> +	mode->hsync_end = mode->hsync_start + hs;
> +	mode->htotal = mode->hsync_end + hbp;
> +	mode->vdisplay = vdisplay;
> +	mode->vsync_start = vdisplay + vfp;
> +	mode->vsync_end = mode->vsync_start + vs;
> +	mode->vtotal = mode->vsync_end + vbp;
> +
> +	drm_mode_set_name(mode);
> +	mode->vrefresh = drm_mode_vrefresh(mode);
> +	mode->type = DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
> +	drm_mode_probed_add(connector, mode);
> +
> +	/* optional display dimension */
> +	ret = of_property_read_u32(np, "width-mm", &w_mm);
> +	ret |= of_property_read_u32(np, "height-mm", &h_mm);
> +	if (ret >= 0) {
> +		connector->display_info.width_mm = w_mm;
> +		connector->display_info.height_mm = h_mm;
> +	}
> +	return 1;
> +}
> +
> +static int dove_drm_connector_get_modes(struct drm_connector *connector)
> +{
> +	struct dove_lcd *dove_lcd = 
> +		container_of(connector, struct dove_lcd, connector);
> +	struct drm_encoder_slave *encoder_slave = &dove_lcd->encoder_slave;
> +	int ret;
> +
> +	switch (connector->connector_type) {
> +	case DRM_MODE_CONNECTOR_VGA:
> +/*fixme:to do */
> +	case DRM_MODE_CONNECTOR_LVDS:
> +		ret = dove_lvds_get_modes(dove_lcd);
> +		break;
> +	default:
> +/*	case DRM_MODE_CONNECTOR_HDMIA: */
> +/*	case DRM_MODE_CONNECTOR_HDMIB: */
> +		ret = encoder_slave->slave_funcs->get_modes(&encoder_slave->base,
> +							connector);
> +		break;
> +	}
> +	DRM_DEBUG_DRIVER("-> %d\n", ret);
> +	return ret;
> +}
> +
> +static int dove_drm_connector_mode_valid(struct drm_connector *connector,
> +					  struct drm_display_mode *mode)
> +{
> +	struct dove_lcd *dove_lcd = 
> +		container_of(connector, struct dove_lcd, connector);
> +	struct drm_encoder_slave *encoder_slave = &dove_lcd->encoder_slave;
> +
> +	if (!encoder_slave->slave_funcs)
> +		return MODE_OK;
> +	return encoder_slave->slave_funcs->mode_valid(&encoder_slave->base,
> +							mode);
> +}
> +
> +static struct drm_encoder *
> +dove_drm_connector_best_encoder(struct drm_connector *connector)
> +{
> +	struct dove_lcd *dove_lcd = 
> +		container_of(connector, struct dove_lcd, connector);
> +
> +	return &dove_lcd->encoder_slave.base;
> +}
> +
> +static const struct drm_connector_helper_funcs connector_helper_funcs = {
> +	.get_modes = dove_drm_connector_get_modes,
> +	.mode_valid = dove_drm_connector_mode_valid,
> +	.best_encoder = dove_drm_connector_best_encoder,
> +};
> +
> +static void dove_drm_connector_destroy(struct drm_connector *connector)
> +{
> +	if (!connector->dev)
> +		return;
> +	drm_sysfs_connector_remove(connector);
> +	drm_connector_cleanup(connector);
> +}
> +
> +static enum drm_connector_status
> +dove_drm_connector_detect(struct drm_connector *connector, bool force)
> +{
> +	struct dove_lcd *dove_lcd = 
> +		container_of(connector, struct dove_lcd, connector);
> +	struct drm_encoder_slave *encoder_slave = &dove_lcd->encoder_slave;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +	if (encoder_slave->slave_funcs)
> +		return encoder_slave->slave_funcs->detect(&encoder_slave->base,
> +							connector);
> +/*fixme: KO with VGA*/
> +	return connector_status_connected;
> +}
> +
> +static void dove_drm_connector_dpms(struct drm_connector *connector,
> +				int mode)
> +{
> +	struct dove_lcd *dove_lcd =
> +		container_of(connector, struct dove_lcd, connector);
> +	struct drm_encoder *encoder = connector->encoder;
> +	struct drm_encoder_slave *encoder_slave = to_encoder_slave(encoder);
> +	struct dove_lcd *dove_lcd2 =
> +		container_of(encoder_slave, struct dove_lcd, encoder_slave);
> +	int modeA, modeB;
> +	u32 reg;
> +
> +	if (mode == dove_lcd->connector.dpms)
> +		return;
> +
> +	/* adjust the port B input */
> +	if (dove_dcon.mmio) {
> +		reg = readl(dove_dcon.mmio + DCON_CTL0);
> +		reg &= ~LCD_Port_B_Select_MASK;
> +		if (dove_lcd2 != dove_lcd) {
> +			if (dove_lcd->num == 0) {
> +				modeA = mode;
> +				modeB = dove_lcd2->connector.dpms;
> +			} else {
> +				modeA = dove_lcd->connector.dpms;
> +				modeB = mode;
> +			}
> +
> +			if (modeB == DRM_MODE_DPMS_ON) {
> +				if (modeA == DRM_MODE_DPMS_ON)
> +					reg |= Port_B_Select_A_copy;
> +				else
> +					reg |= Port_B_Select_LCD0;
> +			}
> +		}
> +		writel(reg, dove_dcon.mmio + DCON_CTL0);
> +		DRM_DEBUG_DRIVER("port B select %08x\n", reg);
> +	}
> +
> +	drm_helper_connector_dpms(connector, mode);
> +}
> +
> +static int dove_connector_set_property(struct drm_connector *connector,
> +				struct drm_property *property,
> +				uint64_t value)
> +{
> +	struct dove_lcd *dove_lcd = 
> +		container_of(connector, struct dove_lcd, connector);
> +	struct drm_encoder_slave *encoder_slave = &dove_lcd->encoder_slave;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +	if (!encoder_slave->slave_funcs)
> +		return 0;
> +	return encoder_slave->slave_funcs->set_property(&encoder_slave->base,
> +							connector,
> +							property,
> +							value);
> +}
> +
> +static const struct drm_connector_funcs connector_funcs = {
> +	.destroy = dove_drm_connector_destroy,
> +	.dpms = dove_drm_connector_dpms,
> +	.detect = dove_drm_connector_detect,
> +	.fill_modes = drm_helper_probe_single_connector_modes,
> +	.set_property = dove_connector_set_property,
> +};
> +
> +/* initialize the couple connector-encoder of a LCD */
> +int dove_ec_init(struct dove_lcd *dove_lcd)
> +{
> +	struct device *dev = dove_lcd->dev;
> +	struct device_node *np = dev->of_node;
> +	struct drm_device *drm = dove_drm.drm;
> +	struct drm_connector *connector = &dove_lcd->connector;
> +	struct drm_encoder_slave *encoder_slave = &dove_lcd->encoder_slave;
> +	struct drm_encoder *encoder = &encoder_slave->base;
> +	u32 port_type;
> +	int mode_encoder, ret;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	/* get the port (connector) type */
> +	if (of_property_read_u32(np, "marvell,port-type", &port_type)) {
> +		dev_err(dev, "no port-type\n");
> +		return -EINVAL;
> +	}
> +	switch (port_type) {
> +	case DRM_MODE_CONNECTOR_VGA:		/* 1 */
> +		mode_encoder = DRM_MODE_ENCODER_DAC;
> +		break;
> +	case DRM_MODE_CONNECTOR_LVDS:		/* 7 */
> +		mode_encoder = DRM_MODE_ENCODER_LVDS;
> +		break;
> +	case DRM_MODE_CONNECTOR_HDMIA:		/* 11 */
> +	case DRM_MODE_CONNECTOR_HDMIB:		/* 12 */
> +		mode_encoder = DRM_MODE_ENCODER_TMDS;
> +		break;
> +	default:
> +		dev_err(dev, "bad port type %d\n", port_type);
> +		return -EINVAL;
> +	}
> +
> +	ret = drm_connector_init(drm, connector, &connector_funcs, port_type);
> +	if (ret < 0)
> +		return ret;
> +
> +	drm_connector_helper_add(connector, &connector_helper_funcs);
> +
> +#ifdef HANDLE_INTERLACE
> +	connector->interlace_allowed = true;
> +#endif
> +
> +	ret = dove_encoder_init(dove_lcd, mode_encoder);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = drm_mode_connector_attach_encoder(connector, encoder);
> +	if (ret < 0)
> +		goto err;
> +
> +	connector->encoder = encoder;
> +
> +	ret = drm_sysfs_connector_add(connector);
> +	if (ret < 0)
> +		goto err;
> +
> +	drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
> +	ret = drm_object_property_set_value(&connector->base,
> +					drm->mode_config.dpms_property,
> +					DRM_MODE_DPMS_OFF);
> +	if (ret < 0)
> +		goto err;
> +	return 0;
> +
> +err:
> +	dev_err(dev, "dove_ec_init err %d\n", ret);
> +	dove_drm_encoder_destroy(&encoder_slave->base);
> +	drm_connector_cleanup(connector);
> +	return ret;
> +}
> +
> +/* at probe time, check the presence of a possible external slave encoder */
> +int dove_ec_probe(struct dove_lcd *dove_lcd)
> +{
> +	struct device *dev = dove_lcd->dev;
> +	struct device_node *np = dev->of_node;
> +	struct device_node *i2c_node;
> +	struct i2c_client *i2c_client;
> +
> +	/* get the optional external encoder */
> +	i2c_node = of_parse_phandle(np, "marvell,external-encoder", 0);
> +	if (!i2c_node)
> +		return 0;
> +
> +	i2c_client = of_find_i2c_device_by_node(i2c_node);
> +	of_node_put(i2c_node);
> +	if (!i2c_client) {
> +		dev_err(dev, "bad external-encoder\n");
> +		return -EINVAL;
> +	}
> +
> +	/* check if the slave-encoder module is initialized */
> +	if (!i2c_client->driver) {
> +		if (dove_drm.probe_defer) {
> +			dev_err(dev, "cannot get the external-encoder\n");
> +			return -EINVAL;
> +		}
> +		dove_drm.probe_defer = 1;
> +		return -EPROBE_DEFER;
> +	}
> +
> +	dove_lcd->encoder_slave.bus_priv = i2c_client;
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Display controller
> + */
> +
> +static int dove_dcon_remove(struct platform_device *pdev)
> +{
> +	dove_dcon.mmio = NULL;
> +	return 0;
> +}
> +
> +static int dove_dcon_probe(struct platform_device *pdev)
> +{
> +	struct resource *res;
> +	void __iomem *mmio;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "failed to get dcon resource\n");
> +		return -EINVAL;
> +	}
> +
> +	mmio = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(mmio)) {
> +		dev_err(&pdev->dev, "failed map dcon registers\n");
> +		return PTR_ERR(mmio);
> +	}
> +
> +	dove_dcon.mmio = mmio;
> +	dove_dcon.dev = &pdev->dev;
> +
> +	/* init done, try to initialize the drm driver */
> +	return dove_probed();
> +}
> +
> +static struct of_device_id dove_dcon_of_match[] = {
> +	{ .compatible = "marvell,dove-dcon" },
> +	{ },
> +};
> +struct platform_driver dove_dcon_platform_driver = {
> +	.driver     = {
> +		.owner  = THIS_MODULE,
> +		.name   = "dove-dcon",
> +		.of_match_table = dove_dcon_of_match,
> +	},
> +	.probe      = dove_dcon_probe,
> +	.remove     = dove_dcon_remove,
> +};
> diff --git a/drivers/gpu/drm/dove/dove_lcd.h b/drivers/gpu/drm/dove/dove_lcd.h
> new file mode 100644
> index 0000000..03b198b
> --- /dev/null
> +++ b/drivers/gpu/drm/dove/dove_lcd.h
> @@ -0,0 +1,519 @@
> +/*
> + * LCD controller registers of Marvell DOVE
> + *
> + * Copyright (C) 2013
> + *   Jean-Francois Moine <moinejf@free.fr>
> + *   Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _DOVE_LCD_H_
> +#define	_DOVE_LCD_H_
> +
> +/* ------------< LCD register >------------ */
> +
> +/* Video Frame 0&1 start address registers */
> +#define	LCD_TV_CONTROL1			0x0084
> +#define   VSYNC_L_OFFSET(o)			((o) << 20)
> +#define   VSYNC_L_OFFSET_MASK			(0xfff << 20)
> +#define   HWC32_ENABLE				BIT(13)
> +#define   VSYNC_OFFSET_EN			BIT(12)
> +#define   VSYNC_H_OFFSET(o)			(o)
> +#define   VSYNC_H_OFFSET_MASK			0xfff
> +
> +/* Video Frame 0&1 start address registers */
> +#define	LCD_SPU_DMA_START_ADDR_Y0	0x00c0
> +#define	LCD_SPU_DMA_START_ADDR_U0	0x00c4
> +#define	LCD_SPU_DMA_START_ADDR_V0	0x00c8
> +#define LCD_CFG_DMA_START_ADDR_0	0x00cc /* Cmd address */
> +#define	LCD_SPU_DMA_START_ADDR_Y1	0x00d0
> +#define	LCD_SPU_DMA_START_ADDR_U1	0x00d4
> +#define	LCD_SPU_DMA_START_ADDR_V1	0x00d8
> +#define LCD_CFG_DMA_START_ADDR_1	0x00dc /* Cmd address */
> +
> +/* YC & UV Pitch */
> +#define LCD_SPU_DMA_PITCH_YC		0x00e0
> +#define   LCD_Y_C(y, c)				(((c) << 16) | (y))
> +#define LCD_SPU_DMA_PITCH_UV		0x00e4
> +#define   LCD_U_V(u, v)				(((v) << 16) | (u))
> +
> +/* Video Starting Point on Screen Register */
> +#define LCD_SPUT_DMA_OVSA_HPXL_VLN	0x00e8
> +
> +/* Video Size Register */
> +#define LCD_SPU_DMA_HPXL_VLN		0x00ec
> +
> +/* Video Size After zooming Register */
> +#define LCD_SPU_DZM_HPXL_VLN		0x00f0
> +
> +/* Graphic Frame 0&1 Starting Address Register */
> +#define LCD_CFG_GRA_START_ADDR0		0x00f4
> +#define LCD_CFG_GRA_START_ADDR1		0x00f8
> +
> +/* Graphic Frame Pitch */
> +#define LCD_CFG_GRA_PITCH		0x00fc
> +
> +/* Graphic Starting Point on Screen Register */
> +#define LCD_SPU_GRA_OVSA_HPXL_VLN	0x0100
> +
> +/* Graphic Size Register */
> +#define LCD_SPU_GRA_HPXL_VLN		0x0104
> +
> +/* Graphic Size after Zooming Register */
> +#define LCD_SPU_GZM_HPXL_VLN		0x0108
> +
> +/* HW Cursor Starting Point on Screen Register */
> +#define LCD_SPU_HWC_OVSA_HPXL_VLN	0x010c
> +
> +/* HW Cursor Size */
> +#define LCD_SPU_HWC_HPXL_VLN		0x0110
> +
> +/* Total Screen Size Register */
> +#define LCD_SPUT_V_H_TOTAL		0x0114
> +
> +/* Total Screen Active Size Register */
> +#define LCD_SPU_V_H_ACTIVE		0x0118
> +#define   LCD_H_V(h, v)				(((v) << 16) | (h))
> +#define   H_LCD(x)				((x) & 0xffff)
> +#define   V_LCD(x)				(((x) >> 16) & 0xffff)
> +
> +/* Screen H&V Porch Register */
> +#define LCD_SPU_H_PORCH			0x011c
> +#define LCD_SPU_V_PORCH			0x0120
> +#define   LCD_F_B(f, b)				(((b) << 16) | (f))
> +#define   F_LCD(x)				((x) & 0xffff)
> +#define   B_LCD(x)				(((x) >> 16) & 0xffff)
> +
> +/* Screen Blank Color Register */
> +#define LCD_SPU_BLANKCOLOR		0x0124
> +
> +/* HW Cursor Color 1&2 Register */
> +#define LCD_SPU_ALPHA_COLOR1		0x0128
> +#define   HWC32_CFG_ALPHA(alpha)		((alpha) << 24)
> +#define LCD_SPU_ALPHA_COLOR2		0x012c
> +#define   COLOR_MASK				0x00ffffff
> +#define   COLOR_RGB(r, g, b) (((b) << 16) | ((g) << 8) | (r))
> +
> +/* Video YUV Color Key Control */
> +#define LCD_SPU_COLORKEY_Y		0x0130
> +#define   CFG_CKEY_Y2(y2)			((y2) << 24)
> +#define   CFG_CKEY_Y2_MASK			0xff000000
> +#define   CFG_CKEY_Y1(y1)			((y1) << 16)
> +#define   CFG_CKEY_Y1_MASK			0x00ff0000
> +#define   CFG_CKEY_Y(y)				((y) << 8)
> +#define   CFG_CKEY_Y_MASK			0x0000ff00
> +#define   CFG_ALPHA_Y(y)			(y)
> +#define   CFG_ALPHA_Y_MASK			0x000000ff
> +#define LCD_SPU_COLORKEY_U		0x0134
> +#define   CFG_CKEY_U2(u2)			((u2) << 24)
> +#define   CFG_CKEY_U2_MASK			0xff000000
> +#define   CFG_CKEY_U1(u1)			((u1) << 16)
> +#define   CFG_CKEY_U1_MASK			0x00ff0000
> +#define   CFG_CKEY_U(u)				((u) << 8)
> +#define   CFG_CKEY_U_MASK			0x0000ff00
> +#define   CFG_ALPHA_U(u)			(u)
> +#define   CFG_ALPHA_U_MASK			0x000000ff
> +#define LCD_SPU_COLORKEY_V		0x0138
> +#define   CFG_CKEY_V2(v2)			((v2) << 24)
> +#define   CFG_CKEY_V2_MASK			0xff000000
> +#define   CFG_CKEY_V1(v1)			((v1) << 16)
> +#define   CFG_CKEY_V1_MASK			0x00ff0000
> +#define   CFG_CKEY_V(v)				((v) << 8)
> +#define   CFG_CKEY_V_MASK			0x0000ff00
> +#define   CFG_ALPHA_V(v)			(v)
> +#define   CFG_ALPHA_V_MASK			0x000000ff
> +
> +/* LCD General Configuration Register */
> +#define LCD_CFG_RDREG4F			0x013c
> +#define   LCD_SRAM_WAIT				BIT(11)
> +#define   DMA_WATERMARK_MASK			0xff
> +#define   DMA_WATERMARK(m)			(m)
> +
> +/* SPI Read Data Register */
> +#define LCD_SPU_SPI_RXDATA		0x0140
> +
> +/* Smart Panel Read Data Register */
> +#define LCD_SPU_ISA_RSDATA		0x0144
> +#define   ISA_RXDATA_16BIT_1_DATA_MASK		0x000000ff
> +#define   ISA_RXDATA_16BIT_2_DATA_MASK		0x0000ff00
> +#define   ISA_RXDATA_16BIT_3_DATA_MASK		0x00ff0000
> +#define   ISA_RXDATA_16BIT_4_DATA_MASK		0xff000000
> +#define   ISA_RXDATA_32BIT_1_DATA_MASK		0x00ffffff
> +
> +/* HWC SRAM Read Data Register */
> +#define LCD_SPU_HWC_RDDAT		0x0158
> +
> +/* Gamma Table SRAM Read Data Register */
> +#define LCD_SPU_GAMMA_RDDAT		0x015c
> +#define   GAMMA_RDDAT_MASK			0x000000ff
> +
> +/* Palette Table SRAM Read Data Register */
> +#define LCD_SPU_PALETTE_RDDAT		0x0160
> +#define   PALETTE_RDDAT_MASK			0x00ffffff
> +
> +/* I/O Pads Input Read Only Register */
> +#define LCD_SPU_IOPAD_IN		0x0178
> +#define   IOPAD_IN_MASK				0x0fffffff
> +
> +/* Reserved Read Only Registers */
> +#define LCD_CFG_RDREG5F			0x017c
> +#define   IRE_FRAME_CNT_MASK			0x000000c0
> +#define   IPE_FRAME_CNT_MASK			0x00000030
> +#define   GRA_FRAME_CNT_MASK			0x0000000c	/* Graphic */
> +#define   DMA_FRAME_CNT_MASK			0x00000003	/* Video */
> +
> +/* SPI Control Register. */
> +#define LCD_SPU_SPI_CTRL		0x0180
> +#define   CFG_SCLKCNT(div)			((div) << 24)
> +#define   CFG_SCLKCNT_MASK			0xff000000
> +#define   CFG_RXBITS(rx)			((rx) << 16)
> +#define   CFG_RXBITS_MASK			0x00ff0000
> +#define   CFG_TXBITS(tx)			((tx) << 8)
> +#define   CFG_TXBITS_MASK			0x0000ff00
> +#define   CFG_CLKINV				BIT(7)
> +#define   CFG_KEEPXFER				BIT(6)
> +#define   CFG_RXBITSTO0				BIT(5)
> +#define   CFG_TXBITSTO0				BIT(4)
> +#define   CFG_SPI_ENA				BIT(3)
> +#define   CFG_SPI_SEL				BIT(2)
> +#define   CFG_SPI_3W4WB				BIT(1)
> +#define   CFG_SPI_START				BIT(0)
> +
> +/* SPI Tx Data Register */
> +#define LCD_SPU_SPI_TXDATA		0x0184
> +
> +/*
> + *  1. Smart Pannel 8-bit Bus Control Register.
> + *  2. AHB Slave Path Data Port Register
> + */
> +#define LCD_SPU_SMPN_CTRL		0x0188
> +
> +/* DMA Control 0 Register */
> +#define LCD_SPU_DMA_CTRL0		0x0190
> +#define   CFG_NOBLENDING			BIT(31)
> +#define   CFG_GAMMA_ENA				BIT(30)
> +#define   CFG_CBSH_ENA				BIT(29)
> +#define   CFG_PALETTE_ENA			BIT(28)
> +#define   CFG_ARBFAST_ENA			BIT(27)
> +#define   CFG_HWC_1BITMOD			BIT(26)
> +#define   CFG_HWC_1BITENA			BIT(25)
> +#define   CFG_HWC_ENA				BIT(24)
> +#define   CFG_DMAFORMAT(dmaformat)		((dmaformat) << 20)
> +#define   CFG_DMAFORMAT_MASK			0x00f00000
> +#define   CFG_GRAFORMAT(graformat)		((graformat) << 16)
> +#define   CFG_GRAFORMAT_MASK			0x000f0000
> +/* for graphic part */
> +#define   CFG_GRA_FTOGGLE			BIT(15)
> +#define   CFG_GRA_HSMOOTH			BIT(14)
> +#define   CFG_GRA_TSTMODE			BIT(13)
> +#define   CFG_GRA_SWAPRB			BIT(12)
> +#define   CFG_GRA_SWAPUV			BIT(11)
> +#define   CFG_GRA_SWAPYU			BIT(10)
> +#define   CFG_YUV2RGB_GRA			BIT(9)
> +#define   CFG_GRA_ENA				BIT(8)
> +/* for video part */
> +#define   CFG_DMA_FTOGGLE			BIT(7)
> +#define   CFG_DMA_HSMOOTH			BIT(6)
> +#define   CFG_DMA_TSTMODE			BIT(5)
> +#define   CFG_DMA_SWAPRB			BIT(4)
> +#define   CFG_DMA_SWAPUV			BIT(3)
> +#define   CFG_DMA_SWAPYU			BIT(2)
> +#define   CFG_DMA_SWAP_MASK			0x0000001c
> +#define   CFG_YUV2RGB_DMA			BIT(1)
> +#define   CFG_DMA_ENA				BIT(0)
> +
> +/* DMA Control 1 Register */
> +#define LCD_SPU_DMA_CTRL1		0x0194
> +#define   CFG_FRAME_TRIG			BIT(31)
> +#define   CFG_VSYNC_TRIG(trig)			((trig) << 28)
> +#define   CFG_VSYNC_TRIG_MASK			0x70000000
> +#define   CFG_VSYNC_INV				BIT(27)
> +#define   CFG_COLOR_KEY_MODE(cmode)		((cmode) << 24)
> +#define   CFG_COLOR_KEY_MASK			0x07000000
> +#define   CFG_CARRY				BIT(23)
> +#define   CFG_GATED_ENA				BIT(21)
> +#define   CFG_PWRDN_ENA				BIT(20)
> +#define   CFG_DSCALE(dscale)			((dscale) << 18)
> +#define   CFG_DSCALE_MASK			0x000c0000
> +#define   CFG_ALPHA_MODE(amode)			((amode) << 16)
> +#define   CFG_ALPHA_MODE_MASK			0x00030000
> +#define   CFG_ALPHA(alpha)			((alpha) << 8)
> +#define   CFG_ALPHA_MASK			0x0000ff00
> +#define   CFG_PXLCMD(pxlcmd)			(pxlcmd)
> +#define   CFG_PXLCMD_MASK			0x000000ff
> +
> +/* SRAM Control Register */
> +#define LCD_SPU_SRAM_CTRL		0x0198
> +#define   CFG_SRAM_INIT_WR_RD(mode)		((mode) << 14)
> +#define   CFG_SRAM_INIT_WR_RD_MASK		0x0000c000
> +#define   CFG_SRAM_ADDR_LCDID(id)		((id) << 8)
> +#define   CFG_SRAM_ADDR_LCDID_MASK		0x00000f00
> +#define   CFG_SRAM_ADDR(addr)			(addr)
> +#define   CFG_SRAM_ADDR_MASK			0x000000ff
> +
> +/* SRAM Write Data Register */
> +#define LCD_SPU_SRAM_WRDAT		0x019c
> +
> +/* SRAM RTC/WTC Control Register */
> +#define LCD_SPU_SRAM_PARA0		0x01a0
> +
> +/* SRAM Power Down Control Register */
> +#define LCD_SPU_SRAM_PARA1		0x01a4
> +#define   CFG_CSB_256x32			BIT(15)		/* HWC */
> +#define   CFG_CSB_256x24			BIT(14)		/* Palette */
> +#define   CFG_CSB_256x8				BIT(13)		/* Gamma */
> +#define   CFG_PDWN256x32			BIT(7)		/* HWC */
> +#define   CFG_PDWN256x24			BIT(6)		/* Palette */
> +#define   CFG_PDWN256x8				BIT(5)		/* Gamma */
> +#define   CFG_PDWN32x32				BIT(3)
> +#define   CFG_PDWN16x66				BIT(2)
> +#define   CFG_PDWN32x66				BIT(1)
> +#define   CFG_PDWN64x66				BIT(0)
> +
> +/* Smart or Dumb Panel Clock Divider */
> +#define LCD_CFG_SCLK_DIV		0x01a8
> +#define   SET_SCLK(src, div, frac) (((src) << 30) | ((frac) << 16 ) | (div))
> +
> +/* Video Contrast Register */
> +#define LCD_SPU_CONTRAST		0x01ac
> +#define   CFG_BRIGHTNESS(bright)		((bright) << 16)
> +#define   CFG_BRIGHTNESS_MASK			0xffff0000
> +#define   CFG_CONTRAST(contrast)		(contrast)
> +#define   CFG_CONTRAST_MASK			0x0000ffff
> +
> +/* Video Saturation Register */
> +#define LCD_SPU_SATURATION		0x01b0
> +#define   CFG_C_MULTS(mult)			((mult) << 16)
> +#define   CFG_C_MULTS_MASK			0xffff0000
> +#define   CFG_SATURATION(sat)			(sat)
> +#define   CFG_SATURATION_MASK			0x0000ffff
> +
> +/* Video Hue Adjust Register */
> +#define LCD_SPU_CBSH_HUE		0x01b4
> +#define   CFG_SIN0(sin0)			((sin0) << 16)
> +#define   CFG_SIN0_MASK				0xffff0000
> +#define   CFG_COS0(con0)			(con0)
> +#define   CFG_COS0_MASK				0x0000ffff
> +
> +/* Dump LCD Panel Control Register */
> +#define LCD_SPU_DUMB_CTRL		0x01b8
> +#define   CFG_DUMBMODE(mode)			((mode) << 28)
> +#define   CFG_DUMBMODE_MASK			0xf0000000
> +#define   CFG_LCDGPIO_O(data)			((data) << 20)
> +#define   CFG_LCDGPIO_O_MASK			0x0ff00000
> +#define   CFG_LCDGPIO_ENA(gpio)			((gpio) << 12)
> +#define   CFG_LCDGPIO_ENA_MASK			0x000ff000
> +#define   CFG_BIAS_OUT				BIT(8)
> +#define   CFG_REVERSE_RGB			BIT(7)
> +#define   CFG_INV_COMPBLANK			BIT(6)
> +#define   CFG_INV_COMPSYNC			BIT(5)
> +#define   CFG_INV_HENA				BIT(4)
> +#define   CFG_INV_VSYNC				BIT(3)
> +#define   CFG_INV_HSYNC				BIT(2)
> +#define   CFG_INV_PCLK				BIT(1)
> +#define   CFG_DUMB_ENA				BIT(0)
> +
> +/* LCD I/O Pads Control Register */
> +#define SPU_IOPAD_CONTROL		0x01bc
> +#define   CFG_VSC_LINEAR(vm)			((vm) << 18)	/* gfx */
> +#define   CFG_VSC_LINEAR_MASK			0x000c0000
> +#define   CFG_GRA_VM_ENA			BIT(15)		/* gfx */
> +#define   CFG_DMA_VM_ENA			BIT(14)		/* video */
> +#define   CFG_CMD_VM_ENA			BIT(13)
> +#define   CFG_CSC(csc)				((csc) << 8)
> +#define   CFG_CSC_MASK				0x00000300
> +#define   CFG_AXICTRL(axi)			((axi) << 4)
> +#define   CFG_AXICTRL_MASK			0x000000f0
> +#define   CFG_IOPADMODE(iopad)			(iopad)
> +#define   CFG_IOPADMODE_MASK			0x0000000f
> +
> +/* LCD Interrupt Control Register */
> +#define SPU_IRQ_ENA			0x1c0
> +/* LCD Interrupt Status Register */
> +#define SPU_IRQ_ISR			0x1c4
> +#define   IRQ_DMA_FRAME0			BIT(31)
> +#define   IRQ_DMA_FRAME1			BIT(30)
> +#define   IRQ_DMA_FIFO_UNDERFLOW		BIT(29)
> +#define   IRQ_GRA_FRAME0			BIT(27)
> +#define   IRQ_GRA_FRAME1			BIT(26)
> +#define   IRQ_GRA_FIFO_UNDERFLOW		BIT(25)
> +#define   IRQ_SMART_VSYNC			BIT(23)
> +#define   IRQ_DUMB_FRAME_DONE			BIT(22)
> +#define   IRQ_SMART_FRAME_DONE			BIT(21)
> +#define   IRQ_HWCURSOR_FRAME_DONE		BIT(20)
> +#define   IRQ_AHB_CMD_EMPTY			BIT(19)
> +#define   IRQ_SPI_TRANSFER_DONE			BIT(18)
> +#define   IRQ_POWERDOWN				BIT(17)
> +#define   IRQ_AXI_ERROR				BIT(16)
> +/* read only status */
> +#define   STA_DMA_FRAME0			BIT(15)
> +#define   STA_DMA_FRAME1			BIT(14)
> +#define   STA_DMA_FRAME_COUNT(x) (((x) & (BIT(13) | BIT(12))) >> 12)
> +#define   STA_GRA_FRAME0			BIT(11)
> +#define   STA_GRA_FRAME1			BIT(10)
> +#define   STA_GRA_FRAME_COUNT(x) (((x) & (BIT(9) | BIT(8))) >> 8)
> +#define   STA_SMART_VSYNC			BIT(7)
> +#define   STA_DUMB_FRAME_DONE			BIT(6)
> +#define   STA_SMART_FRAME_DONE			BIT(5)
> +#define   STA_HWCURSOR_FRAME_DONE		BIT(4)
> +#define   STA_AHB_CMD_EMPTY			BIT(3)
> +#define   STA_DMA_FIFO_EMPTY			BIT(2)
> +#define   STA_GRA_FIFO_EMPTY			BIT(1)
> +#define   STA_POWERDOWN				BIT(0)
> +
> +#define IRQ_DMA_FRAME_DONE			(IRQ_DMA_FRAME0 | IRQ_DMA_FRAME1)
> +#define IRQ_GRA_FRAME_DONE \
> +			(IRQ_GRA_FRAME0 | IRQ_GRA_FRAME1 | IRQ_SMART_VSYNC)
> +
> +/*
> + * defined Video Memory Color format for DMA control 0 register
> + * DMA0 bit[23:20]
> + */
> +#define VMODE_RGB565		0x0
> +#define VMODE_RGB1555		0x1
> +#define VMODE_RGB888PACKED	0x2
> +#define VMODE_RGB888UNPACKED	0x3
> +#define VMODE_RGBA888		0x4
> +#define VMODE_YUV422PACKED	0x5
> +#define VMODE_YUV422PLANAR	0x6
> +#define VMODE_YUV420PLANAR	0x7
> +#define VMODE_SMPNCMD		0x8
> +#define VMODE_PALETTE4BIT	0x9
> +#define VMODE_PALETTE8BIT	0xa
> +#define VMODE_RESERVED		0xb
> +
> +/*
> + * defined Graphic Memory Color format for DMA control 0 register
> + * DMA0 bit[19:16]
> + */
> +#define GMODE_RGB565		0x0
> +#define GMODE_RGB1555		0x1
> +#define GMODE_RGB888PACKED	0x2
> +#define GMODE_RGB888UNPACKED	0x3
> +#define GMODE_RGBA888		0x4
> +#define GMODE_YUV422PACKED	0x5
> +#define GMODE_YUV422PLANAR	0x6
> +#define GMODE_YUV420PLANAR	0x7
> +#define GMODE_SMPNCMD		0x8
> +#define GMODE_PALETTE4BIT	0x9
> +#define GMODE_PALETTE8BIT	0xa
> +#define GMODE_RESERVED		0xb
> +
> +/*
> + * define for DMA control 1 register
> + */
> +#define DMA1_FRAME_TRIG		31	/* bit location */
> +#define DMA1_VSYNC_MODE		28
> +#define DMA1_VSYNC_INV		27
> +#define DMA1_CKEY		24
> +#define DMA1_CARRY		23
> +#define DMA1_LNBUF_ENA		22
> +#define DMA1_GATED_ENA		21
> +#define DMA1_PWRDN_ENA		20
> +#define DMA1_DSCALE		18
> +#define DMA1_ALPHA_MODE		16
> +#define DMA1_ALPHA		 8
> +#define DMA1_PXLCMD		 0
> +
> +/*
> + * defined for Configure Dumb Mode
> + * DUMB LCD Panel bit[31:28]
> + */
> +#define DUMB16_RGB565_0		0x0
> +#define DUMB16_RGB565_1		0x1
> +#define DUMB18_RGB666_0		0x2
> +#define DUMB18_RGB666_1		0x3
> +#define DUMB12_RGB444_0		0x4
> +#define DUMB12_RGB444_1		0x5
> +#define DUMB24_RGB888_0		0x6
> +#define DUMB_BLANK		0x7
> +
> +/*
> + * defined for Configure I/O Pin Allocation Mode
> + * LCD LCD I/O Pads control register bit[3:0]
> + */
> +#define IOPAD_DUMB24		0x0
> +#define IOPAD_DUMB18SPI		0x1
> +#define IOPAD_DUMB18GPIO	0x2
> +#define IOPAD_DUMB16SPI		0x3
> +#define IOPAD_DUMB16GPIO	0x4
> +#define IOPAD_DUMB12		0x5
> +#define IOPAD_SMART18SPI	0x6
> +#define IOPAD_SMART16SPI	0x7
> +#define IOPAD_SMART8BOTH	0x8
> +
> +/*
> + * clock source SCLK_Source bit[31:30]
> + */
> +#define SCLK_SRC_AXI 0
> +#define SCLK_SRC_EXTCLK0 1
> +#define SCLK_SRC_PLLDIV 2
> +#define SCLK_SRC_EXTCLK1 3
> +
> +/*
> + * defined Dumb Panel Clock Divider register
> + * SCLK_Source bit[31]
> + */
> +#define AXI_BUS_SEL		0x80000000	/* 0: PLL clock select*/
> +#define CCD_CLK_SEL		0x40000000
> +#define DCON_CLK_SEL		0x20000000
> +#define IDLE_CLK_INT_DIV	0x1		/* idle Integer Divider */
> +#define DIS_CLK_INT_DIV		0x0		/* Disable Integer Divider */
> +
> +/* SRAM ID */
> +#define SRAMID_GAMMA_YR		0x0
> +#define SRAMID_GAMMA_UG		0x1
> +#define SRAMID_GAMMA_VB		0x2
> +#define SRAMID_PALETTE		0x3
> +#define SRAMID_HWC32_RAM1	0xc
> +#define SRAMID_HWC32_RAM2	0xd
> +#define SRAMID_HWC32_RAM3	0xe
> +#define SRAMID_HWC		0xf
> +
> +/* SRAM INIT Read/Write */
> +#define SRAMID_INIT_READ	0x0
> +#define SRAMID_INIT_WRITE	0x2
> +#define SRAMID_INIT_DEFAULT	0x3
> +
> +/*
> + * defined VSYNC selection mode for DMA control 1 register
> + * DMA1 bit[30:28]
> + */
> +#define VMODE_SMPN		0x0
> +#define VMODE_SMPNIRQ		0x1
> +#define VMODE_DUMB		0x2
> +#define VMODE_IPE		0x3
> +#define VMODE_IRE		0x4
> +
> +/*
> + * defined Configure Alpha and Alpha mode for DMA control 1 register
> + * DMA1 bit[15:08](alpha) / bit[17:16](alpha mode)
> + */
> +/* ALPHA mode */
> +#define MODE_ALPHA_DMA		0xa0
> +#define MODE_ALPHA_GRA		0x1
> +#define MODE_ALPHA_CFG		0x2
> +
> +/* alpha value */
> +#define ALPHA_NOGRAPHIC		0xff	/* all video, no graphic */
> +#define ALPHA_NOVIDEO		0x00	/* all graphic, no video */
> +#define ALPHA_GRAPHnVIDEO	0x0f	/* Selects graphic & video */
> +
> +/*
> + * defined Pixel Command for DMA control 1 register
> + * DMA1 bit[07:00]
> + */
> +#define PIXEL_CMD		0x81
> +
> +#endif /* _DOVE_LCD_H_ */
> 
> 
> -- 
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
