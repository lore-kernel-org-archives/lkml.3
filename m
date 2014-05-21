Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaEURKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:10:36 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49801 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaEURKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:10:32 -0400
Date: Wed, 21 May 2014 19:08:12 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v3 03/16] drm: sti: add HDMI driver
Message-ID: <20140521170808.GQ2014@ulmo>
References: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
 <1400594186-8956-4-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7kD9y3RnPUgTZee0"
Content-Disposition: inline
In-Reply-To: <1400594186-8956-4-git-send-email-benjamin.gaignard@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7kD9y3RnPUgTZee0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 03:56:13PM +0200, Benjamin Gaignard wrote:
[...]
> diff --git a/drivers/gpu/drm/sti/sti_hdmi.c b/drivers/gpu/drm/sti/sti_hdmi.c
[...]
> +/* Reference to the hdmi device */
> +struct device *hdmi_dev;

No globals please.

> +/*
> + * Helper to write bit field
> + *
> + * @addr: register to update
> + * @val: value to write
> + * @mask: bit field mask to use
> + */
> +static inline void hdmi_reg_writemask(void __iomem *addr, u32 val, u32 mask)

Given the hdmi_ prefix I'd expect this to take a struct sti_hdmi * as
first argument. Maybe you can also leave out the _reg in there since it
should be pretty obvious what this writes.

> +/*
> + * HDMI interrupt handler
> + *
> + * @irq: irq number
> + * @arg: connector structure
> + */
> +static irqreturn_t hdmi_irq_thread(int irq, void *arg)
> +{
> +	struct sti_hdmi *hdmi = arg;
> +	u32 status;
> +
> +	/* read interrupt status */
> +	status = readl(hdmi->regs + HDMI_INT_STA);
> +
> +	/* PLL lock interrupt */
> +	if (status & HDMI_INT_DLL_LCK) {
> +		hdmi->event_received = true;
> +		wake_up_interruptible(&hdmi->wait_event);
> +	}

I think a more common way to do this is using a struct completion.

> +	/* Hot plug detection */
> +	if (status & HDMI_INT_HOT_PLUG) {
> +		hdmi->hpd = gpio_get_value(hdmi->hpd_gpio);

Hmm... that's odd. You get an interrupt from the HDMI controller but
need to read a GPIO to find out what the status is?

> +		if (hdmi->drm_dev)
> +			drm_helper_hpd_irq_event(hdmi->drm_dev);
> +	}
> +
> +	/* Sw reset completed */
> +	if (status & HDMI_INT_SW_RST) {
> +		hdmi->event_received = true;
> +		wake_up_interruptible(&hdmi->wait_event);
> +	}

There's no way to distinguish this from HDMI_INT_DLL_LCK.

> +	/* clear interrupt status */
> +	writel(status, hdmi->regs + HDMI_INT_CLR);
> +
> +	/* TODO: check why this sync bus write solves the problem which
> +	 * is that without this line, the handler is sometimes called twice
> +	 */
> +	/* sync bus write */
> +	readl(hdmi->regs + HDMI_INT_STA);

This seems to be something that you're systematically doing wrong.

> +/*
> + * Start hdmi phy interface
> + *
> + * @hdmi: pointer on the hdmi internal structure
> + *
> + * Return -1 if error occurs
> + */
> +static int hdmi_phy_start(struct sti_hdmi *hdmi)
> +{
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	if (hdmi->tx3g0c55phy)
> +		return sti_hdmi_tx3g0c55phy_start(hdmi);
> +
> +	return sti_hdmi_tx3g4c28phy_start(hdmi);
> +}

This looks like a prime candidate for the generic PHY framework. That
will allow you to simply store a struct phy * and use the generic API
rather than special case every possible type of PHY.

> +/*
> + * Stop hdmi phy interface
> + *
> + * @hdmi: pointer on the hdmi internal structure
> + */
> +static void hdmi_phy_stop(struct sti_hdmi *hdmi)
> +{
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	if (hdmi->tx3g0c55phy)
> +		sti_hdmi_tx3g0c55phy_stop(hdmi);
> +	else
> +		sti_hdmi_tx3g4c28phy_stop(hdmi);
> +}

Same here. The generic PHY equivalents for this would be phy_power_on()
and phy_power_off().

> +/*
> + * Set hdmi active area depending on the drm display mode selected
> + *
> + * @hdmi: pointer on the hdmi internal structure
> + */
> +static void hdmi_active_area(struct sti_hdmi *hdmi)
> +{
> +	u32 xmin, xmax;
> +	u32 ymin, ymax;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	/*
> +	 *       Active        Front        Sync       Back          Active
> +	 *       Region        Porch                  Porch          Region
> +	 * <---------------><-------->0<---------><--------><----------------->
> +	 *
> +	 *   ///////////////|                               |  ///////////////|
> +	 *  /////////////// |                               | /////////////// |
> +	 * ///////////////  |.........            ..........|///////////////  |
> +	 *                            0___________      x/ymin           x/ymax
> +	 *
> +	 * <--[hv]display-->                                 <--[hv]display-->
> +	 * <--[hv]sync_start--------->                       <--[hv]sync_start-
> +	 * <--[hv]sync_end----------------------->           <--[hv]sync_end---
> +	 * <--[hv]total------------------------------------> <--[hv]total------
> +	 */

There's an instance of this picture somewhere else already, no need to
keep a copy in every subdriver. Also this is something that people are
supposed to know. Perhaps it should be moved to a central place for
reference?

> +
> +	xmin = sti_vtg_get_pixel_number(hdmi->mode, 0);
> +	xmax = sti_vtg_get_pixel_number(hdmi->mode, hdmi->mode.hdisplay - 1);
> +	ymin = sti_vtg_get_line_number(hdmi->mode, 0);
> +	ymax = sti_vtg_get_line_number(hdmi->mode, hdmi->mode.vdisplay - 1);
> +
> +	writel(xmin, hdmi->regs + HDMI_ACTIVE_VID_XMIN);
> +	writel(xmax, hdmi->regs + HDMI_ACTIVE_VID_XMAX);
> +	writel(ymin, hdmi->regs + HDMI_ACTIVE_VID_YMIN);
> +	writel(ymax, hdmi->regs + HDMI_ACTIVE_VID_YMAX);
> +
> +	DRM_DEBUG_DRIVER("xmin=%d xmax=%d ymin=%d ymax=%d\n",
> +			 xmin, xmax, ymin, ymax);
> +}

I feel a midlayer coming up in subsequent patches. This looks like it
should be more tightly coupled to DRM.

> +/*
> + * Overall hdmi configuration
> + *
> + * @hdmi: pointer on the hdmi internal structure
> + */
> +static void hdmi_config(struct sti_hdmi *hdmi)
> +{
> +	u32 val;
> +	u32 mask;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	/* Clear overrun and underrun fifo */
> +	mask = HDMI_CFG_FIFO_OVERRUN_CLR | HDMI_CFG_FIFO_UNDERRUN_CLR;
> +	val = HDMI_CFG_FIFO_OVERRUN_CLR | HDMI_CFG_FIFO_UNDERRUN_CLR;
> +
> +	/* Enable HDMI mode not DVI */
> +	mask |= HDMI_CFG_HDMI_NOT_DVI | HDMI_CFG_ESS_NOT_OESS;
> +	val |= HDMI_CFG_HDMI_NOT_DVI | HDMI_CFG_ESS_NOT_OESS;
> +
> +	/* Enable sink term detection */
> +	mask |= HDMI_CFG_SINK_TERM_DET_EN;
> +	val |= HDMI_CFG_SINK_TERM_DET_EN;
> +
> +	/* Set Hsync polarity */
> +	if ((hdmi->mode.flags && DRM_MODE_FLAG_NHSYNC)

s/&&/&/

> +	    == DRM_MODE_FLAG_NHSYNC) {
> +		DRM_DEBUG_DRIVER("H Sync Negative\n");
> +		mask |= HDMI_CFG_H_SYNC_POL_NEG;
> +		val |= HDMI_CFG_H_SYNC_POL_NEG;
> +	}
> +
> +	/* Set Vsync polarity */
> +	if ((hdmi->mode.flags && DRM_MODE_FLAG_NVSYNC)
> +	    == DRM_MODE_FLAG_NVSYNC) {
> +		DRM_DEBUG_DRIVER("V Sync Negative\n");
> +		mask |= HDMI_CFG_V_SYNC_POL_NEG;
> +		val |= HDMI_CFG_V_SYNC_POL_NEG;
> +	}
> +
> +	/* Enable HDMI */
> +	mask |= HDMI_CFG_DEVICE_EN;
> +	val |= HDMI_CFG_DEVICE_EN;
> +
> +	hdmi_reg_writemask(hdmi->regs + HDMI_CFG, val, mask);

Quite frankly I don't see how hdmi_reg_writemask() makes this any more
readable. This is equally readable in my opinion:

	value = hdmi_read(hdmi, HDMI_CFG);
	value &= ~HDMI...;
	value |= HDMI...;
	...
	hdmi_write(hdmi, value, HDMI_CFG);

Of course since your mask and value are always the same in the above
there's really no use in masking out and ORing back in the value in the
first place, so all of these can simply be:

	value = HDMI... | HDMI... | HDMI... | ...;

	if (...)
		value |= HDMI...;

	hdmi_write(hdmi, value, HDMI_CFG);

> +/*
> + * Prepare and configure the AVI infoframe
> + *
> + * AVI infoframe are transmitted at least once per two video field and
> + * contains information about HDMI transmission mode such as color space,
> + * colorimetry, ...
> + *
> + * @hdmi: pointer on the hdmi internal structure
> + *
> + * Return negative value if error occurs
> + */
> +static int hdmi_avi_infoframe_config(struct sti_hdmi *hdmi)
> +{
> +	struct drm_display_mode *mode = &hdmi->mode;
> +	struct hdmi_avi_infoframe infoframe;
> +	u8 buffer[HDMI_INFOFRAME_HEADER_SIZE + HDMI_AVI_INFOFRAME_SIZE];

I think you can use HDMI_INFOFRAME_SIZE(AVI) here.

> +	u8 *frame = buffer + HDMI_INFOFRAME_HEADER_SIZE - 1;

Why "- 1"? I think this warrants a comment.

> +	u32 val;
> +	u32 mask;
> +	int ret;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	ret = drm_hdmi_avi_infoframe_from_display_mode(&infoframe, mode);
> +	if (ret < 0) {
> +		DRM_ERROR("failed to setup AVI infoframe: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* TODO: remove static infoframe configuration */
> +	infoframe.colorspace = HDMI_COLORSPACE_RGB;
> +	infoframe.quantization_range = HDMI_QUANTIZATION_RANGE_DEFAULT;
> +	infoframe.colorimetry = HDMI_COLORIMETRY_NONE;
> +	infoframe.pixel_repeat = 0;

Why is this even necessary in the first place? If it really is it's
likely that the core is just missing something, in which case the
drm_hdmi_avi_infoframe_from_display_mode() helper should be fixed.

> +	ret = hdmi_avi_infoframe_pack(&infoframe, buffer, sizeof(buffer));
> +	if (ret < 0) {
> +		DRM_ERROR("failed to pack AVI infoframe: %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Disable transmission slot for AVI infoframe */
> +	val = HDMI_IFRAME_DISABLED;
> +	mask = HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, HDMI_IFRAME_SLOT_AVI);

This is really impossible to parse by a human. I'd rather see this open-
coded than obfuscated by some magic macro.

> +	hdmi_reg_writemask(hdmi->regs + HDMI_SW_DI_CFG, val, mask);
> +
> +	/* Infoframe header */
> +	val = buffer[0x0];
> +	val |= buffer[0x1] << 8;
> +	val |= buffer[0x2] << 16;
> +	writel(val, hdmi->regs + HDMI_SW_DI_N_HEAD_WORD(HDMI_IFRAME_SLOT_AVI));

I think a hdmi_writel() helper would be useful here. Also the registers
below seem to be all successive in memory, so maybe some sort of look
would make this easier to read.

> +	/* Infoframe packet bytes */
> +	val = frame[0x0];
> +	val |= frame[0x1] << 8;
> +	val |= frame[0x2] << 16;
> +	val |= frame[0x3] << 24;
> +	writel(val, hdmi->regs + HDMI_SW_DI_N_PKT_WORD0(HDMI_IFRAME_SLOT_AVI));
> +	val = frame[0x4];
> +	val |= frame[0x5] << 8;
> +	val |= frame[0x6] << 16;
> +	val |= frame[0x7] << 24;
> +	writel(val, hdmi->regs + HDMI_SW_DI_N_PKT_WORD1(HDMI_IFRAME_SLOT_AVI));
> +	val = frame[0x8];
> +	val |= frame[0x9] << 8;
> +	val |= frame[0xA] << 16;
> +	val |= frame[0xB] << 24;
> +	writel(val, hdmi->regs + HDMI_SW_DI_N_PKT_WORD2(HDMI_IFRAME_SLOT_AVI));
> +	val = frame[0xC];
> +	val |= frame[0xD] << 8;
> +	writel(val, hdmi->regs + HDMI_SW_DI_N_PKT_WORD3(HDMI_IFRAME_SLOT_AVI));
> +
> +	/* Enable transmission slot for AVI infoframe */
> +	/* According to the hdmi specification, AVI infoframe should be
> +	 * transmitted at least once per two video fields */
> +	val = HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_FIELD, HDMI_IFRAME_SLOT_AVI);
> +	mask = HDMI_IFRAME_CFG_DI_N(HDMI_IFRAME_MASK, HDMI_IFRAME_SLOT_AVI);
> +	hdmi_reg_writemask(hdmi->regs + HDMI_SW_DI_CFG, val, mask);

Again, not much gain in the hdmi_reg_writemask() helper here.

> +/*
> + * Software reset of the hdmi subsystem
> + *
> + * @hdmi: pointer on the hdmi internal structure
> + *
> + * Return -1 if error occurs

No, this function never fails and always returns 0. Ideally it would
propagate errors from lower layers if they can't be handled here.

> + */
> +#define HDMI_TIMEOUT_SWRESET  100	/*milliseconds */
> +static int hdmi_swreset(struct sti_hdmi *hdmi)
> +{
> +	u32 val;
> +	u32 mask;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	/* Enable hdmi_audio clock only during hdmi reset */
> +	if (clk_prepare_enable(hdmi->clk_audio))
> +		DRM_INFO("Failed to prepare/enable hdmi_audio clk\n");

You should propagate this error. If the clock can't be enabled
presumably the remainder of this function can't succeed, so there's no
point continuing beyond this.

> +	/* Sw reset */

You should either spell this out ("software") or use all caps for
abbreviations ("SW").

> +	mask = HDMI_CFG_SW_RST_EN;
> +	val = HDMI_CFG_SW_RST_EN;
> +
> +	hdmi->event_received = false;
> +	hdmi_reg_writemask(hdmi->regs + HDMI_CFG, val, mask);
> +
> +	/* Wait reset completed */
> +	wait_event_interruptible_timeout(hdmi->wait_event,
> +					 hdmi->event_received == true,
> +					 msecs_to_jiffies
> +					 (HDMI_TIMEOUT_SWRESET));

I think a completion would be better here. Perhaps even that would be
overkill. You could also simply use a loop with a timeout where you
check for the reset complete bit to be flagged.

> +	/*
> +	 * HDMI_STA_SW_RST bit is set to '1' when SW_RST bit in HDMI_CFG is
> +	 * set to '1' and clk_audio is running.
> +	 */
> +	if ((readl(hdmi->regs + HDMI_STA) & HDMI_STA_SW_RST) == 0)
> +		DRM_INFO("Warning: HDMI sw reset timeout occurs\n");

If this times out there's something from and you should return an error
here so that appropriate action can be taken at higher levels.

> +/*
> + * Attach the I2C ddc client to allow hdmi i2c communication
> + *
> + * @ddc: i2c client
> + */
> +static struct i2c_client *hdmi_ddc;
> +void sti_hdmi_attach_ddc_client(struct i2c_client *ddc)
> +{
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	if (ddc)
> +		hdmi_ddc = ddc;
> +}

This doesn't look right. All other drivers use an i2c_adapter directly,
so this should do the same. Since this will be using device tree it can
use the same mechanism that every other DT driver uses.

On that note, I haven't seen you post the device tree bindings for this
yet. It would be good to get a look at that as well since it may help
with understanding how this all fits together. Also it will need to be
reviewed as well anyway and depending on the output the drivers may need
significant rework.

> +/*
> + * Get modes from edid
> + *
> + * @drm_connector: pointer on the drm connector
> + */
> +static int sti_hdmi_get_modes(struct drm_connector *drm_connector)
> +{
> +	struct edid *edid;
> +	int count;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	if ((!hdmi_ddc) || (!hdmi_ddc->adapter))
> +		goto fail;
> +
> +	edid = drm_get_edid(drm_connector, hdmi_ddc->adapter);
> +	if (!edid)
> +		goto fail;

You need to call drm_mode_connector_update_edid_property() even in case
of failure here, since otherwise the connector will keep carrying a
stale copy of the EDID.

> +
> +	count = drm_add_edid_modes(drm_connector, edid);
> +	if (count)
> +		drm_mode_connector_update_edid_property(drm_connector, edid);
> +	else
> +		DRM_ERROR("Add edid modes failed\n");

s/edid/EDID/ or better yet, just drop this error message.

> +
> +	kfree(edid);
> +	return count;
> +
> +fail:
> +	DRM_ERROR("Can not read HDMI EDID\n");
> +	return -1;

This function should return the number of modes probed, so 0 in case of
failure.

> +static int sti_hdmi_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct sti_hdmi *hdmi;
> +	struct device_node *np = dev->of_node;
> +	struct resource *res;
> +	int ret;
> +
> +	DRM_INFO("%s\n", __func__);
> +
> +	hdmi = devm_kzalloc(dev, sizeof(*hdmi), GFP_KERNEL);
> +	if (!hdmi) {
> +		DRM_ERROR("Failed to allocate memory for hdmi\n");
> +		return -ENOMEM;
> +	}
> +
> +	hdmi->dev = pdev->dev;
> +
> +	/* Get resources */
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "hdmi-reg");

If you move the PHY programming to a different driver then this becomes
the only resource and you don't need a name. Regardless, though, I think
something like "hdmi" or "regs" would be more appropriate here.

> +	if (!res) {
> +		DRM_ERROR("Invalid hdmi resource\n");
> +		return -ENOMEM;
> +	}
> +	hdmi->regs = devm_ioremap_nocache(dev, res->start, resource_size(res));
> +	if (IS_ERR(hdmi->regs))
> +		return PTR_ERR(hdmi->regs);
> +
> +	if (of_device_is_compatible(np, "st,stih416-hdmi")) {
> +		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
> +						   "syscfg");
> +		if (!res) {
> +			DRM_ERROR("Invalid syscfg resource\n");
> +			return -ENOMEM;
> +		}
> +		hdmi->syscfg = devm_ioremap_nocache(dev, res->start,
> +						    resource_size(res));
> +		if (IS_ERR(hdmi->syscfg))
> +			return PTR_ERR(hdmi->syscfg);
> +
> +		hdmi->tx3g0c55phy = true;
> +	}

Again this seems like it would be better exposed as a generic PHY. That
way you can simply request the PHY and use it if present. Perhaps this
isn't really a PHY but something else entirely. What is this syscfg
register range? Does it belong to some other device? I suspect that
since you're not requesting the region this may in fact already be used
by some other driver. In that case doing this is unsafe and you should
provide a way to call into that other driver from this one to apply the
corresponding configuration.

> +
> +	/* Get clock resources */
> +	hdmi->clk_pix = devm_clk_get(dev, "hdmi_pix");
[...]
> +	hdmi->clk_tmds = devm_clk_get(dev, "hdmi_tmds");
[...]
> +	hdmi->clk_phy = devm_clk_get(dev, "hdmi_phy");
[...]
> +	hdmi->clk_audio = devm_clk_get(dev, "hdmi_audio");

You can drop the hdmi_ prefix on all of these clock names since they're
relative to the HDMI device anyway.

> +
> +	hdmi->hpd_gpio = of_get_named_gpio(np, "hdmi,hpd-gpio", 0);

This should use the gpiod API if at all possible.

> +	if (hdmi->hpd_gpio < 0) {
> +		DRM_ERROR("Failed to get hdmi hpd-gpio\n");
> +		return -EIO;
> +	}
> +
> +	hdmi->hpd = gpio_get_value(hdmi->hpd_gpio);

Why do you cache this value here? Can't you simply read it directly when
it's needed?

> +	init_waitqueue_head(&hdmi->wait_event);
> +
> +	/* Get irq ressources */
> +	hdmi->irq = platform_get_irq_byname(pdev, "hdmi_irq");

Again, no need for the hdmi_ prefix. In this case it would also be an
option to just name it "hdmi" if it's the only interrupt that this
device can raise.

> +	ret = devm_request_threaded_irq(dev, hdmi->irq, NULL,
> +					hdmi_irq_thread, IRQF_ONESHOT,
> +					"hdmi_irq", hdmi);

Perhaps dev_name(dev) instead of "hdmi_irq". Also perhaps you should
provide a hdmi_irq() to implement the hard IRQ handler (reading the
interrupt status registers) and if you determine that you need to do
something that may sleep (as in case of the hotplug detect) you can
return IRQ_WAKE_THREAD to only run the threaded handler if necessary.

> +	if (ret) {
> +		DRM_ERROR("Failed to register hdmi interrupt\n");

s/hdmi/HDMI/

> +		return ret;
> +	}
> +
> +	/* Get reset resources */

This comment is superfluous.

> +	hdmi->reset = devm_reset_control_get(dev, "hdmi");
> +	/* Take hdmi out of reset */
> +	if (!IS_ERR(hdmi->reset))
> +		reset_control_deassert(hdmi->reset);

Shouldn't this rather be:

	if (IS_ERR(hdmi->reset))
		return PTR_ERR(hdmi->reset);

	err = reset_control_deassert(hdmi->reset);
	if (err < 0)
		return err;

?

> +	hdmi_dev = &hdmi->dev;
> +
> +	platform_set_drvdata(pdev, hdmi);
> +
> +	return component_add(&pdev->dev, &sti_hdmi_ops);
> +}
> +
> +static int sti_hdmi_remove(struct platform_device *pdev)
> +{
> +	component_del(&pdev->dev, &sti_hdmi_ops);
> +	return 0;
> +}
> +
> +static struct of_device_id hdmi_match_types[] = {
> +	{
> +	 .compatible = "st,stih416-hdmi",
> +	 },
> +	{
> +	 .compatible = "st,stih407-hdmi",
> +	 },
> +	{ /* end node */ }
> +};
> +MODULE_DEVICE_TABLE(of, hdmi_match_types);

Weird indentation again. And s/hdmi_match_types/hdmi_of_match/?

> +struct platform_driver sti_hdmi_driver = {
> +	.driver = {
> +		   .name = "sti-hdmi",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = hdmi_match_types,
> +		   },
> +	.probe = sti_hdmi_probe,
> +	.remove = sti_hdmi_remove,
> +};
> +module_platform_driver(sti_hdmi_driver);
> +
> +MODULE_LICENSE("GPL");

I don't think you need that in every file that's built into a one module
with other files. Only use it in the main source file.

Also s/GPL/GPL v2/.

> diff --git a/drivers/gpu/drm/sti/sti_hdmi.h b/drivers/gpu/drm/sti/sti_hdmi.h
[...]
> +/* HDMI v2.9 macro cell */

What does that mean?

> +void sti_hdmi_attach_ddc_client(struct i2c_client *ddc);
> +
> +int sti_hdmi_tx3g0c55phy_start(struct sti_hdmi *hdmi);
> +void sti_hdmi_tx3g0c55phy_stop(struct sti_hdmi *hdmi);
> +void sti_hdmi_tx3g0c55phy_show(struct sti_hdmi *hdmi, struct seq_file *m);
> +
> +int sti_hdmi_tx3g4c28phy_start(struct sti_hdmi *hdmi);
> +void sti_hdmi_tx3g4c28phy_stop(struct sti_hdmi *hdmi);
> +void sti_hdmi_tx3g4c28phy_show(struct sti_hdmi *hdmi, struct seq_file *m);
> +
> +extern struct i2c_driver ddc_driver;

You should be able to get rid of all of these.

> diff --git a/drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c b/drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c
[...]
> +/*
> + * Enable the old BCH/rejection PLL is now reused to provide the CLKPXPLL
> + * clock input to the new PHY PLL that generates the serializer clock
> + * (TMDS*10) and the TMDS clock which is now fed back into the HDMI
> + * formatter instead of the TMDS clock line from ClockGenB.
> + *
> + * @hdmi: pointer on the hdmi internal structure
> + *
> + * Return -1 if error occurs

Should return a proper error code.

> + */
> +static int enable_pll_rejection(struct sti_hdmi *hdmi)
> +{
> +	int inputclock;

unsigned?

> +	u32 mdiv;
> +	u32 ndiv;
> +	u32 pdiv;
> +	u32 mask;
> +	u32 val;

Variables of the same type can be declared on a single line to make this
shorter.

> +	int i;

unsigned?

> +	inputclock = hdmi->mode.clock * 1000;
> +
> +	DRM_DEBUG_DRIVER("hdmi rejection pll input clock = %dHz\n", inputclock);
> +
> +	/* Force to power down the HDMI rejection PLL */
> +	mask = REJECTION_PLL_HDMI_ENABLE_MASK;
> +	val = 0x0 << REJECTION_PLL_HDMI_ENABLE_SHIFT;
> +	reg_writemask(hdmi->syscfg + HDMI_REJECTION_PLL_CONFIGURATION,
> +		      val, mask);
> +
> +	/* Check the HDMI rejection PLL is really down */
> +	for (i = 0; i < HDMI_WAIT_PLL_REJECTION_STATUS; i++) {
> +		val = readl(hdmi->syscfg + HDMI_REJECTION_PLL_STATUS);
> +		if ((val & REJECTION_PLL_HDMI_REJ_PLL_LOCK) == 0)
> +			break;
> +	}
> +	if (i == HDMI_WAIT_PLL_REJECTION_STATUS) {
> +		DRM_ERROR("hdmi rejection pll is not well powered down\n");
> +		return -1;
> +	}

Should this perhaps be a timed loop rather than a busy loop?

> +	/* Power up the HDMI rejection PLL */
> +	/*
> +	 * Note: On this SoC (stiH416) we are forced to have the input clock
> +	 * be equal to the HDMI pixel clock.
> +	 *
> +	 * The values here have been suggested by validation however they are
> +	 * still provisional and subject to change.
> +	 *
> +	 * PLLout = (Fin*Mdiv) / ((2 * Ndiv) / 2^Pdiv)
> +	 */
> +	if (inputclock < 50000000) {
> +		/*
> +		 * For slower clocks we need to multiply more to keep the
> +		 * internal VCO frequency within the physical specification
> +		 * of the PLL.
> +		 */
> +		pdiv = 4;
> +		ndiv = 240;
> +		mdiv = 30;
> +	} else {
> +		pdiv = 2;
> +		ndiv = 60;
> +		mdiv = 30;
> +	}
> +
> +	mask = REJECTION_PLL_HDMI_PDIV_MASK |
> +	    REJECTION_PLL_HDMI_NDIV_MASK |
> +	    REJECTION_PLL_HDMI_MDIV_MASK | REJECTION_PLL_HDMI_ENABLE_MASK;
> +	val = (pdiv << REJECTION_PLL_HDMI_PDIV_SHIFT) |
> +	    (ndiv << REJECTION_PLL_HDMI_NDIV_SHIFT) |
> +	    (mdiv << REJECTION_PLL_HDMI_MDIV_SHIFT) |
> +	    (0x1 << REJECTION_PLL_HDMI_ENABLE_SHIFT);
> +	reg_writemask(hdmi->syscfg + HDMI_REJECTION_PLL_CONFIGURATION,
> +		      val, mask);
> +
> +	/* Check the HDMI rejection PLL is really up */
> +	for (i = 0; i < HDMI_WAIT_PLL_REJECTION_STATUS; i++) {
> +		val = readl(hdmi->syscfg + HDMI_REJECTION_PLL_STATUS);
> +		if ((val & REJECTION_PLL_HDMI_REJ_PLL_LOCK) != 0)
> +			break;
> +	}
> +	if (i == HDMI_WAIT_PLL_REJECTION_STATUS) {
> +		DRM_ERROR("hdmi rejection pll is not well powered up\n");
> +		return -1;
> +	}

Same here.

> +
> +	DRM_DEBUG_DRIVER("hdmi rejection pll locked\n");
> +
> +	return 0;
> +}
> +
> +/*
> + * Disable the pll rejection
> + *
> + * @hdmi: pointer on the hdmi internal structure
> + */
> +static void disable_pll_rejection(struct sti_hdmi *hdmi)
> +{
> +	int i;
> +	u32 val;
> +	u32 mask;
> +
> +	DRM_DEBUG_DRIVER("\n");
> +
> +	mask = REJECTION_PLL_HDMI_ENABLE_MASK;
> +	val = 0x0 << REJECTION_PLL_HDMI_ENABLE_SHIFT;
> +	reg_writemask(hdmi->syscfg + HDMI_REJECTION_PLL_CONFIGURATION,
> +		      val, mask);
> +
> +	/* Check the HDMI rejection PLL is really down */
> +	for (i = 0; i < HDMI_WAIT_PLL_REJECTION_STATUS; i++) {
> +		val = readl(hdmi->syscfg + HDMI_REJECTION_PLL_STATUS);
> +		if ((val & REJECTION_PLL_HDMI_REJ_PLL_LOCK) == 0)
> +			break;
> +	}
> +	if (i == HDMI_WAIT_PLL_REJECTION_STATUS)
> +		DRM_ERROR("hdmi rejection pll is not well powered down\n");
> +	else
> +		DRM_DEBUG_DRIVER("hdmi rejection pll is powered down\n");

And here.

> +}
> +
> +/*
> + * Start hdmi phy macro cell tx3g0c55
> + *
> + * @hdmi: pointer on the hdmi internal structure
> + *
> + * Return -1 if error occurs

Should return a proper error code.

> + */
> +int sti_hdmi_tx3g0c55phy_start(struct sti_hdmi *hdmi)
> +{
> +	u32 ckpxpll = hdmi->mode.clock * 1000;
> +	u32 tmdsck;
> +	u32 freqvco;
> +	u32 pllctrl = 0;
> +	u32 val;
> +	int i;

unsigned

> +
> +	if (enable_pll_rejection(hdmi))
> +		return -1;

	err = enable_pll_rejection(hdmi);
	if (err < 0)
		return err;

> +	/* TODO: manage DeepColor (30, 36 and 48 bits) and pixel repetition */
> +
> +	/* Assuming no pixel repetition and 24bits color */
> +	tmdsck = ckpxpll;
> +	pllctrl = 2 << HDMI_SRZ_PLL_CFG_NDIV_SHIFT;
> +
> +	/*
> +	 * Setup the PLL mode parameter based on the ckpxpll. If we haven't got
> +	 * a clock frequency supported by one of the specific PLL modes then we
> +	 * will end up using the generic mode (0) which only supports a 10x
> +	 * multiplier, hence only 24bit color.
> +	 */
> +	for (i = 0; i < NB_PLL_MODE; i++) {
> +		if (ckpxpll >= pllmodes[i].min && ckpxpll <= pllmodes[i].max)
> +			pllctrl |= HDMI_SRZ_PLL_CFG_MODE(pllmodes[i].mode);
> +	}
> +
> +	freqvco = tmdsck * 10;
> +	if (freqvco <= 425000000UL)
> +		pllctrl |= HDMI_SRZ_PLL_CFG_VCOR(HDMI_SRZ_PLL_CFG_VCOR_425MHZ);
> +	else if (freqvco <= 850000000UL)
> +		pllctrl |= HDMI_SRZ_PLL_CFG_VCOR(HDMI_SRZ_PLL_CFG_VCOR_850MHZ);
> +	else if (freqvco <= 1700000000UL)
> +		pllctrl |= HDMI_SRZ_PLL_CFG_VCOR(HDMI_SRZ_PLL_CFG_VCOR_1700MHZ);
> +	else if (freqvco <= 2970000000UL)
> +		pllctrl |= HDMI_SRZ_PLL_CFG_VCOR(HDMI_SRZ_PLL_CFG_VCOR_3000MHZ);
> +	else {
> +		DRM_ERROR("PHY serializer clock out of range\n");
> +		goto err;
> +	}

This could be a table.

> +
> +	/*
> +	 * Configure and power up the PHY PLL
> +	 */
> +	hdmi->event_received = false;
> +	DRM_DEBUG_DRIVER("pllctrl = 0x%x\n", pllctrl);
> +	writel(pllctrl, hdmi->regs + HDMI_SRZ_PLL_CFG);
> +
> +	/* wait PLL interrupt */
> +	wait_event_interruptible_timeout(hdmi->wait_event,
> +					 hdmi->event_received == true,
> +					 msecs_to_jiffies
> +					 (HDMI_TIMEOUT_PLL_LOCK));
> +
> +	if ((readl(hdmi->regs + HDMI_STA) & HDMI_STA_DLL_LCK) == 0) {
> +		DRM_ERROR("hdmi phy pll not locked\n");
> +		goto err;
> +	}

There doesn't seem to be a need for this to be strictly interrupt
driven. A simple timed loop would do equally well.

> +	DRM_DEBUG_DRIVER("got PHY PLL Lock\n");
> +
> +	/*
> +	 * To configure the source termination and pre-emphasis appropriately
> +	 * for different high speed TMDS clock frequencies a phy configuration
> +	 * table must be provided, tailored to the SoC and board combination.
> +	 */
> +	for (i = 0; i < NB_HDMI_PHY_CONFIG; i++) {
> +		if ((hdmiphy_config[i].min_tmds_freq <= tmdsck) &&
> +		    (hdmiphy_config[i].max_tmds_freq >= tmdsck)) {
> +			val = hdmiphy_config[i].config[0];
> +			writel(val, hdmi->regs + HDMI_SRZ_TAP_1);
> +			val = hdmiphy_config[i].config[1];
> +			writel(val, hdmi->regs + HDMI_SRZ_TAP_2);
> +			val = hdmiphy_config[i].config[2];
> +			writel(val, hdmi->regs + HDMI_SRZ_TAP_3);
> +			val = hdmiphy_config[i].config[3];
> +			val |= HDMI_SRZ_CTRL_EXTERNAL_DATA_EN;
> +			val &= ~HDMI_SRZ_CTRL_POWER_DOWN;
> +			writel(val, hdmi->regs + HDMI_SRZ_CTRL);
> +
> +			DRM_DEBUG_DRIVER("serializer cfg 0x%x 0x%x 0x%x 0x%x\n",
> +					 hdmiphy_config[i].config[0],
> +					 hdmiphy_config[i].config[1],
> +					 hdmiphy_config[i].config[2],
> +					 hdmiphy_config[i].config[3]);
> +			return 0;
> +		}
> +	}
> +
> +	/*
> +	 * Default, power up the serializer with no pre-emphasis or source
> +	 * termination.
> +	 */

Should this case produce a warning?

> +	writel(0x0, hdmi->regs + HDMI_SRZ_TAP_1);
> +	writel(0x0, hdmi->regs + HDMI_SRZ_TAP_2);
> +	writel(0x0, hdmi->regs + HDMI_SRZ_TAP_3);
> +	writel(HDMI_SRZ_CTRL_EXTERNAL_DATA_EN, hdmi->regs + HDMI_SRZ_CTRL);
> +
> +	return 0;
> +
> +err:
> +	disable_pll_rejection(hdmi);
> +
> +	return -1;
> +}
[...]

> +/*
> + * Debugfs
> + */
> +#define HDMI_DBG_DUMP(reg) seq_printf(m, "\n %-25s 0x%08X", #reg, \
> +		readl(hdmi->regs + reg))
> +void sti_hdmi_tx3g0c55phy_show(struct sti_hdmi *hdmi, struct seq_file *m)
> +{
> +	HDMI_DBG_DUMP(HDMI_SRZ_PLL_CFG);
> +	HDMI_DBG_DUMP(HDMI_SRZ_TAP_1);
> +	HDMI_DBG_DUMP(HDMI_SRZ_TAP_2);
> +	HDMI_DBG_DUMP(HDMI_SRZ_TAP_3);
> +	HDMI_DBG_DUMP(HDMI_SRZ_CTRL);
> +	seq_puts(m, "\n");

Why the empty line? Is this supposed to be used as part of a larger
file? I'd recommend against doing that and rather have one debugfs entry
for each device's register file.

> diff --git a/drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c b/drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c
[...]

Mostly the same comments apply here as for the other PHY.

Thierry

--7kD9y3RnPUgTZee0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfN14AAoJEN0jrNd/PrOh38QP/j5lWDWPPhLi1lcwqnt9o+F0
OTeaE8a8JQbdpvcI0vbbyh+F/Fk7bYAWoUxbYkgj4/ETOCqn6dX4moAUM9kCFmj/
93HlqeYH2BdOi0xNpF9/iAN30DXTUHnSwHeNnb6M01wHD8waxuZbwLBpuDpSuzin
bU/WhU6NFBjgQ5/5YeaLojz3lOwfmQBhRJD60soPbB6h5qB7z9Ep8Vkn+E2C0EF9
qQo1Itp9oDAcRGXr6cwmkyjTJyG/p28V2IcdZN/Q+DFRsaYp7yM/0JJDEiZ99S6W
SAFwfBH4pzuXHaL2FxB0+vKHJ9ispNZGOmAgXnaA1emhMrl44OrOoXcVHDfKmb4Q
x9wMnNixHwUl18KclYMaex+yG7IyFVpXReBgeUA3V1Q08JSxih80QTQw8Hn7PK5o
CN+bG3qiP1C8IrEeEPTRNuaA0WhemMQX741R5jqRC0Wn8SuBw73KkAZyvjroeQCY
FEThKwUXs5sffcR6pCjNr73RjQH+z7D+FKmRNZoOSSBnpZe9R0l3CEdGPbRUstR3
rH9tlpM6k9pbZbSh3fxNTn+UmzyzRWBI9G7dGJuJ84gaS1mJA+DBMD/pV1k8D8bZ
52gjWk3E4UgXvIL5t99ScO6oH5zm7pD1IdWomeEPOYyOywFEs1UM9EUjypC6qgf2
Oj992PRJbSaHVkliJix2
=b1nM
-----END PGP SIGNATURE-----

--7kD9y3RnPUgTZee0--
