Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbaDRNWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:22:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33506 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754737AbaDRNWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:22:35 -0400
Message-ID: <535126D2.4080406@free-electrons.com>
Date: Fri, 18 Apr 2014 15:21:22 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
CC: plagnioj@jcrosoft.com, airlied@linux.ie, robdclark@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] atmel: drm: added drm driver for the atmel hlcd controller
References: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com> <1397814309-32160-2-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1397814309-32160-2-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ,

On 18/04/2014 11:45, Jean-Jacques Hiblot wrote:
> +
> +static void update_scanout(struct drm_crtc *crtc)
> +{
> +	struct atmel_hlcdc_crtc *hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
> +	struct drm_device *dev = crtc->dev;
> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
> +	struct drm_framebuffer *fb = crtc->fb;
> +

I guess you meant

struct drm_framebuffer *fb = hclcd_crtc->fb;


because otherwise you get an error when compiling (there are similar
issues below).

> +	struct drm_gem_cma_object *gem;
> +	struct atmel_hlcd_dma_desc *desc = hlcdc_crtc->dma_descs[DMA_BASE];
> +	unsigned int depth, bpp;
> +	dma_addr_t start;
> +	dma_addr_t desc_phys = hlcdc_crtc->dma_descs_phys[DMA_BASE];
> +
> +	drm_fb_get_bpp_depth(fb->pixel_format, &depth, &bpp);
> +	gem = drm_fb_cma_get_gem_obj(fb, 0);
> +
> +	start = gem->paddr + fb->offsets[0] +
> +			(crtc->y * fb->pitches[0]) + (crtc->x * bpp/8);
> +
> +	if (hlcdc_crtc->fb != fb) {
> +		struct drm_framebuffer *oldfb = hlcdc_crtc->fb;
> +		drm_framebuffer_reference(fb);
> +		hlcdc_crtc->fb = fb;
> +		if (oldfb) {
> +			drm_flip_work_queue(&hlcdc_crtc->unref_work, oldfb);
> +			drm_flip_work_commit(&hlcdc_crtc->unref_work, priv->wq);
> +		}
> +	}
> +
> +	if (desc->address != start) {
> +		desc->address = start;
> +		desc->next = desc_phys;
> +		desc->control = LCDC_OVRCTRL_DFETCH;
> +	}
> +
> +	if (hlcdc_read(dev, ATMEL_LCDC_BASENEXT) != desc_phys) {
> +		hlcdc_write(dev, ATMEL_LCDC_BASENEXT, desc_phys);
> +		hlcdc_write(dev, ATMEL_LCDC_BASECHER, LCDC_BASECHER_UPDATEEN);
> +	}
> +}
> +
> +static void start(struct drm_crtc *crtc)
> +{
> +	struct drm_device *dev = crtc->dev;
> +
> +	hlcdc_write(dev, ATMEL_LCDC_LCDEN, LCDC_LCDEN_CLKEN);
> +	while (!(hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_CLKSTS))
> +		cpu_relax();
> +	hlcdc_write(dev, ATMEL_LCDC_LCDEN, LCDC_LCDEN_SYNCEN);
> +	while (!(hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_LCDSTS))
> +		cpu_relax();
> +	hlcdc_write(dev, ATMEL_LCDC_LCDEN, LCDC_LCDEN_DISPEN);
> +	while (!(hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_DISPSTS))
> +		cpu_relax();
> +	hlcdc_write(dev, ATMEL_LCDC_LCDEN, LCDC_LCDEN_PWMEN);
> +	while (!(hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_PWMSTS))
> +		cpu_relax();
> +}
> +
> +static void stop(struct drm_crtc *crtc)
> +{
> +	struct drm_device *dev = crtc->dev;
> +
> +	/* Disable DISP signal */
> +	hlcdc_write(dev, ATMEL_LCDC_LCDDIS, LCDC_LCDDIS_DISPDIS);
> +	while ((hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_DISPSTS))
> +		cpu_relax();
> +	/* Disable synchronization */
> +	hlcdc_write(dev, ATMEL_LCDC_LCDDIS, LCDC_LCDDIS_SYNCDIS);
> +	while ((hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_LCDSTS))
> +		cpu_relax();
> +	/* Disable pixel clock */
> +	hlcdc_write(dev, ATMEL_LCDC_LCDDIS, LCDC_LCDDIS_CLKDIS);
> +	while ((hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_CLKSTS))
> +		cpu_relax();
> +	/* Disable PWM */
> +	hlcdc_write(dev, ATMEL_LCDC_LCDDIS, LCDC_LCDDIS_PWMDIS);
> +	while ((hlcdc_read(dev, ATMEL_LCDC_LCDSR) & LCDC_LCDSR_PWMSTS))
> +		cpu_relax();
> +}
> +
> +static void atmel_hlcdc_crtc_destroy(struct drm_crtc *crtc)
> +{
> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
> +	struct drm_device *dev = crtc->dev;
> +
> +	WARN_ON(atmel_hlcdc_crtc->dpms == DRM_MODE_DPMS_ON);
> +
> +	drm_crtc_cleanup(crtc);
> +	drm_flip_work_cleanup(&atmel_hlcdc_crtc->unref_work);
> +
> +	if (atmel_hlcdc_crtc->dma_descs[0])
> +		dma_free_writecombine(dev->dev,
> +			      sizeof(struct atmel_hlcd_dma_desc) * DMA_MAX,
> +			      atmel_hlcdc_crtc->dma_descs[0],
> +			      atmel_hlcdc_crtc->dma_descs_phys[0]);
> +	kfree(atmel_hlcdc_crtc);
> +}
> +
> +static int atmel_hlcdc_crtc_page_flip(struct drm_crtc *crtc,
> +		struct drm_framebuffer *fb,
> +		struct drm_pending_vblank_event *event,
> +		uint32_t page_flip_flags)
> +{
> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
> +	struct drm_device *dev = crtc->dev;
> +
> +	if (atmel_hlcdc_crtc->event) {
> +		dev_err(dev->dev, "already pending page flip!\n");
> +		return -EBUSY;
> +	}
> +
> +	crtc->fb = fb;

ditto

> +	atmel_hlcdc_crtc->event = event;
> +	update_scanout(crtc);
> +	return 0;
> +}
> +
> +static void atmel_hlcdc_crtc_dpms(struct drm_crtc *crtc, int mode)
> +{
> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
> +	struct drm_device *dev = crtc->dev;
> +
> +	/* we really only care about on or off: */
> +	if (mode != DRM_MODE_DPMS_ON)
> +		mode = DRM_MODE_DPMS_OFF;
> +
> +	if (atmel_hlcdc_crtc->dpms == mode)
> +		return;
> +
> +	atmel_hlcdc_crtc->dpms = mode;
> +
> +	pm_runtime_get_sync(dev->dev);
> +
> +	if (mode == DRM_MODE_DPMS_ON) {
> +		pm_runtime_forbid(dev->dev);
> +		start(crtc);
> +	} else {
> +		stop(crtc);
> +		pm_runtime_allow(dev->dev);
> +	}
> +
> +	pm_runtime_put_sync(dev->dev);
> +}
> +
> +static bool atmel_hlcdc_crtc_mode_fixup(struct drm_crtc *crtc,
> +		const struct drm_display_mode *mode,
> +		struct drm_display_mode *adjusted_mode)
> +{
> +	return true;
> +}
> +
> +static void atmel_hlcdc_crtc_prepare(struct drm_crtc *crtc)
> +{
> +	atmel_hlcdc_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
> +}
> +
> +static void atmel_hlcdc_crtc_commit(struct drm_crtc *crtc)
> +{
> +	atmel_hlcdc_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
> +}
> +
> +static u32 atmel_hlcdfb_get_rgbmode(struct device *dev, int depth, int bpp)
> +{
> +	u32 value = 0;
> +
> +	switch (depth) {
> +	case 1:
> +		value = LCDC_BASECFG1_CLUTMODE_1BPP | LCDC_BASECFG1_CLUTEN;
> +		break;
> +	case 2:
> +		value = LCDC_BASECFG1_CLUTMODE_2BPP | LCDC_BASECFG1_CLUTEN;
> +		break;
> +	case 4:
> +		value = LCDC_BASECFG1_CLUTMODE_4BPP | LCDC_BASECFG1_CLUTEN;
> +		break;
> +	case 8:
> +		value = LCDC_BASECFG1_CLUTMODE_8BPP | LCDC_BASECFG1_CLUTEN;
> +		break;
> +	case 12:
> +		value = LCDC_BASECFG1_RGBMODE_12BPP_RGB_444;
> +		break;
> +	case 16:
> +		value = LCDC_BASECFG1_RGBMODE_16BPP_RGB_565;
> +		break;
> +	case 18:
> +		value = LCDC_BASECFG1_RGBMODE_18BPP_RGB_666_PACKED;
> +		break;
> +	case 24:
> +		value = LCDC_BASECFG1_RGBMODE_24BPP_RGB_888_PACKED;
> +		break;
> +	case 32:
> +		value = LCDC_BASECFG1_RGBMODE_32BPP_ARGB_8888;
> +		break;
> +	default:
> +		dev_err(dev, "Cannot set video mode for depth %d, bpp %d\n",
> +			depth, bpp);
> +		break;
> +	}
> +
> +	return value;
> +}
> +
> +
> +void atmel_hlcdc_crtc_update_clk(struct drm_crtc *crtc, int clock)
> +{
> +	struct drm_device *dev = crtc->dev;
> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
> +	unsigned long value;
> +	unsigned long clk_value_khz;
> +
> +	if (clock == 0)
> +		clock = crtc->mode.clock;
> +
> +	pm_runtime_get_sync(dev->dev);
> +
> +	clk_value_khz = clk_get_rate(priv->clk) / 1000;
> +
> +	value = DIV_ROUND_CLOSEST(clk_value_khz, clock);
> +
> +	if (value < 1) {
> +		dev_notice(dev->dev, "using system clock as pixel clock\n");
> +		value = LCDC_LCDCFG0_CLKPWMSEL | LCDC_LCDCFG0_CGDISBASE;
> +		hlcdc_write(dev, ATMEL_LCDC_LCDCFG0, value);
> +	} else {
> +		dev_dbg(dev->dev, "  updated pixclk:     %lu KHz\n",
> +				clk_value_khz / value);
> +		value = value - 2;
> +		dev_dbg(dev->dev, "  * programming CLKDIV = 0x%08lx\n",
> +					value);
> +		value = LCDC_LCDCFG0_CLKPWMSEL |
> +			(value << LCDC_LCDCFG0_CLKDIV_OFFSET)
> +			| LCDC_LCDCFG0_CGDISBASE;
> +		hlcdc_write(dev, ATMEL_LCDC_LCDCFG0, value);
> +	}
> +
> +	pm_runtime_put_sync(dev->dev);
> +}
> +
> +static int atmel_hlcdc_crtc_mode_set(struct drm_crtc *crtc,
> +		struct drm_display_mode *mode,
> +		struct drm_display_mode *adjusted_mode,
> +		int x, int y,
> +		struct drm_framebuffer *old_fb)
> +{
> +	struct atmel_hlcdc_crtc *atmel_hlcdc_crtc = to_atmel_hlcdc_crtc(crtc);
> +	struct drm_device *dev = crtc->dev;
> +	struct atmel_hlcdc_drm_private *priv = dev->dev_private;
> +	int dpms = atmel_hlcdc_crtc->dpms;
> +	int hbp, hfp, hsw, vbp, vfp, vsw;
> +	unsigned int depth, bpp;
> +	unsigned long value;
> +	int ret;
> +
> +	ret = atmel_hlcdc_crtc_mode_valid(crtc, mode);
> +	if (WARN_ON(ret))
> +		return ret;
> +
> +	pm_runtime_get_sync(dev->dev);
> +
> +	if (dpms == DRM_MODE_DPMS_ON)
> +		atmel_hlcdc_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
> +
> +	dev_dbg(dev->dev, "%s:\n", __func__);
> +
> +
> +	/* Set pixel clock */
> +	atmel_hlcdc_crtc_update_clk(crtc, mode->clock);
> +
> +	/* Initialize control register 5 */
> +	value = priv->default_lcdcfg5;
> +	value |= (priv->guard_time << LCDC_LCDCFG5_GUARDTIME_OFFSET)
> +		| LCDC_LCDCFG5_DISPDLY
> +		| LCDC_LCDCFG5_VSPDLYS;
> +
> +	if (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC)
> +		value |= LCDC_LCDCFG5_HSPOL;
> +
> +	if (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC)
> +		value |= LCDC_LCDCFG5_VSPOL;
> +
> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG5 = %08lx\n", value);
> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG5, value);
> +
> +
> +	/* Configure timings: */
> +	hbp = MAX(mode->htotal - mode->hsync_end, 1);
> +	hfp = MAX(mode->hsync_start - mode->hdisplay, 1);
> +	hsw = MAX(mode->hsync_end - mode->hsync_start, 1);
> +	vbp = MAX(mode->vtotal - mode->vsync_end, 0);
> +	vfp = MAX(mode->vsync_start - mode->vdisplay, 1);
> +	vsw = MAX(mode->vsync_end - mode->vsync_start, 1);
> +
> +	DBG("%dx%d, hbp=%u, hfp=%u, hsw=%u, vbp=%u, vfp=%u, vsw=%u",
> +		mode->hdisplay, mode->vdisplay, hbp, hfp, hsw, vbp, vfp, vsw);
> +
> +	/* Vertical & Horizontal Timing */
> +	value = (vsw - 1) << LCDC_LCDCFG1_VSPW_OFFSET;
> +	value |= (hsw - 1) << LCDC_LCDCFG1_HSPW_OFFSET;
> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG1 = %08lx\n", value);
> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG1, value);
> +
> +	value = (vbp) << LCDC_LCDCFG2_VBPW_OFFSET;
> +	value |= (vfp - 1) << LCDC_LCDCFG2_VFPW_OFFSET;
> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG2 = %08lx\n", value);
> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG2, value);
> +
> +	value = (hbp - 1) << LCDC_LCDCFG3_HBPW_OFFSET;
> +	value |= (hfp - 1) << LCDC_LCDCFG3_HFPW_OFFSET;
> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG3 = %08lx\n", value);
> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG3, value);
> +
> +	/* Display size */
> +	value = (mode->vdisplay - 1) << LCDC_LCDCFG4_RPF_OFFSET;
> +	value |= (mode->hdisplay - 1) << LCDC_LCDCFG4_PPL_OFFSET;
> +	dev_dbg(dev->dev, "  * LCDC_LCDCFG4 = %08lx\n", value);
> +	hlcdc_write(dev, ATMEL_LCDC_LCDCFG4, value);
> +
> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG0,
> +		    LCDC_BASECFG0_BLEN_AHB_INCR16 | LCDC_BASECFG0_DLBO);
> +
> +	drm_fb_get_bpp_depth(crtc->fb->pixel_format, &depth, &bpp);
ditto
> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG1,
> +		    atmel_hlcdfb_get_rgbmode(dev->dev, depth, bpp));
> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG2, 0);
> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG3, 0);	/* Default color */
> +	hlcdc_write(dev, ATMEL_LCDC_BASECFG4, LCDC_BASECFG4_DMA);
> +
>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

