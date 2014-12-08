Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaLHN2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:28:38 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62849 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaLHN2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:28:35 -0500
Date: Mon, 8 Dec 2014 14:28:29 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Hai Li <hali@codeaurora.org>
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robdclark@gmail.com
Subject: Re: [PATCH 1/2] drm/msm: Initial add eDP support in msm drm driver
 (V2)
Message-ID: <20141208132827.GA13942@ulmo.nvidia.com>
References: <1417815001-9883-1-git-send-email-hali@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <1417815001-9883-1-git-send-email-hali@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 05, 2014 at 04:30:00PM -0500, Hai Li wrote:
[...]
> diff --git a/drivers/gpu/drm/msm/edp/edp.c b/drivers/gpu/drm/msm/edp/edp.c
> new file mode 100644
> index 0000000..32e21e1
> --- /dev/null
> +++ b/drivers/gpu/drm/msm/edp/edp.c
> @@ -0,0 +1,211 @@
> +/*
> + * Copyright (c) 2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/of_irq.h>
> +#include "edp.h"
> +
> +static irqreturn_t edp_irq(int irq, void *dev_id)
> +{
> +	struct msm_edp *edp =3D dev_id;
> +
> +	/* Process eDP irq */
> +	return msm_edp_ctrl_irq(edp->ctrl);
> +}

I find that the architecture of this makes it really difficult to
review. If I want to see what this function does I now have to jump
somewhere else in this patch (over 2000 lines ahead).

> +static void edp_destroy(struct platform_device *pdev)
> +{
> +	struct msm_edp *edp =3D platform_get_drvdata(pdev);
> +
> +	if (!edp)
> +		return;
> +
> +	if (edp->ctrl) {
> +		msm_edp_ctrl_destroy(edp->ctrl);
> +		edp->ctrl =3D NULL;
> +	}
> +
> +	platform_set_drvdata(pdev, NULL);
> +
> +	devm_kfree(&pdev->dev, edp);

The whole point of the devm_* functions is that you don't have to clean
them up manually. Why do you need to call this here?

> +}
> +
> +/* construct hdmi at bind/probe time, grab all the resources. */
> +static struct msm_edp *edp_init(struct platform_device *pdev)
> +{
> +	struct msm_edp *edp =3D NULL;
> +	int ret;
> +
> +	if (!pdev) {
> +		pr_err("no edp device\n");

s/edp/eDP/ here and in a few other places that I haven't pointed out
explicitly.

> +		ret =3D -ENXIO;
> +		goto fail;
> +	}
> +
> +	edp =3D devm_kzalloc(&pdev->dev, sizeof(*edp), GFP_KERNEL);
> +	if (!edp) {
> +		ret =3D -ENOMEM;
> +		goto fail;
> +	}
> +	DBG("edp probed=3D%p", edp);
> +
> +	edp->pdev =3D pdev;
> +	platform_set_drvdata(pdev, edp);
> +
> +	ret =3D msm_edp_ctrl_init(edp);
> +	if (ret)
> +		goto fail;
> +
> +	return edp;
> +
> +fail:
> +	if (edp)
> +		edp_destroy(pdev);
> +
> +	return ERR_PTR(ret);
> +}
> +
> +static int edp_bind(struct device *dev, struct device *master, void *dat=
a)
> +{
> +	struct drm_device *drm =3D dev_get_drvdata(master);
> +	struct msm_drm_private *priv =3D drm->dev_private;
> +	struct msm_edp *edp;
> +
> +	DBG("");
> +	edp =3D edp_init(to_platform_device(dev));

There's a lot of this casting to platform devices and then using
pdev->dev to get at the struct device. I don't immediately see a use for
the platform device, so why not just stick with struct device *
consistently?

> +	if (IS_ERR(edp))
> +		return PTR_ERR(edp);
> +	priv->edp =3D edp;
> +
> +	return 0;
> +}
> +
> +static void edp_unbind(struct device *dev, struct device *master,
> +		void *data)

We typically align parameters on subsequent lines with the first
parameter on the first line. But perhaps Rob doesn't care so much.

> +static const struct of_device_id dt_match[] =3D {
> +	{ .compatible =3D "qcom,mdss-edp" },
> +	{}
> +};

Don't you want a MODULE_DEVICE_TABLE here?

> +/* Second part of initialization, the drm/kms level modeset_init */
> +int msm_edp_modeset_init(struct msm_edp *edp,
> +		struct drm_device *dev, struct drm_encoder *encoder)
> +{
> +	struct platform_device *pdev =3D edp->pdev;
> +	struct msm_drm_private *priv =3D dev->dev_private;
> +	int ret;
> +
> +	edp->encoder =3D encoder;
> +	edp->dev =3D dev;
> +
> +	edp->bridge =3D msm_edp_bridge_init(edp);
> +	if (IS_ERR(edp->bridge)) {
> +		ret =3D PTR_ERR(edp->bridge);
> +		dev_err(dev->dev, "failed to create eDP bridge: %d\n", ret);
> +		edp->bridge =3D NULL;
> +		goto fail;
> +	}
> +
> +	edp->connector =3D msm_edp_connector_init(edp);
> +	if (IS_ERR(edp->connector)) {
> +		ret =3D PTR_ERR(edp->connector);
> +		dev_err(dev->dev, "failed to create eDP connector: %d\n", ret);
> +		edp->connector =3D NULL;
> +		goto fail;
> +	}
> +
> +	edp->irq =3D irq_of_parse_and_map(pdev->dev.of_node, 0);

Why not use the more idiomatic platform_get_irq()?

> +	if (edp->irq < 0) {
> +		ret =3D edp->irq;
> +		dev_err(dev->dev, "failed to get irq: %d\n", ret);

s/irq/IRQ/

> diff --git a/drivers/gpu/drm/msm/edp/edp.h b/drivers/gpu/drm/msm/edp/edp.h
[...]
> +#ifndef __EDP_CONNECTOR_H__
> +#define __EDP_CONNECTOR_H__
> +
> +#include <linux/clk.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/of_gpio.h>
> +#include <linux/pwm.h>
> +#include <linux/i2c.h>

These should be alphabetically sorted.

> diff --git a/drivers/gpu/drm/msm/edp/edp_aux.c b/drivers/gpu/drm/msm/edp/=
edp_aux.c
[...]
> +#define to_edp_aux(x) container_of(x, struct edp_aux, drm_aux)

Perhaps this should be a static inline function for better type safety.

> +static int edp_msg_fifo_tx(struct edp_aux *aux, struct drm_dp_aux_msg *m=
sg)
> +{
> +	u32 data[4];
> +	u32 reg, len;
> +	bool native =3D msg->request & (DP_AUX_NATIVE_WRITE & DP_AUX_NATIVE_REA=
D);
> +	bool read =3D msg->request & (DP_AUX_I2C_READ & DP_AUX_NATIVE_READ);
> +	u8 *msgdata =3D msg->buffer;
> +	int i;
> +
> +	if (read)
> +		len =3D 4;
> +	else
> +		len =3D msg->size + 4;
> +
> +	/*
> +	 * cmd fifo only has depth of 144 bytes
> +	 */
> +	if (len > AUX_CMD_FIFO_LEN)
> +		return -EINVAL;
> +
> +	/* Pack cmd and write to HW */
> +	data[0] =3D (msg->address >> 16) & 0xf;	/* addr[19:16] */
> +	if (read)
> +		data[0] |=3D  BIT(4);		/* R/W */
> +
> +	data[1] =3D (msg->address >> 8) & 0xff;	/* addr[15:8] */
> +	data[2] =3D msg->address & 0xff;		/* addr[7:0] */
> +	data[3] =3D (msg->size - 1) & 0xff;	/* len[7:0] */
> +
> +	for (i =3D 0; i < len; i++) {
> +		reg =3D (i < 4) ? data[i] : msgdata[i - 4];
> +		reg =3D EDP_AUX_DATA_DATA(reg); /* index =3D 0, write */
> +		if (i =3D=3D 0)
> +			reg |=3D EDP_AUX_DATA_INDEX_WRITE;
> +		edp_write(aux->base + REG_EDP_AUX_DATA, reg);
> +
> +		/* Write data 1 by 1 into the FIFO */
> +		wmb();

I don't understand why you think you need these. You already use the
right accessors and they already provide correct barriers. Are you
really sure you need them?

> +	}
> +
> +	reg =3D 0; /* Transaction number is always 1 */
> +	if (!native) /* i2c */
> +		reg |=3D EDP_AUX_TRANS_CTRL_I2C;
> +
> +	reg |=3D EDP_AUX_TRANS_CTRL_GO;
> +	edp_write(aux->base + REG_EDP_AUX_TRANS_CTRL, reg);
> +
> +	/* Make sure transaction is triggered */
> +	wmb();

Same here... and in various other places.

> +/*
> + * This function does the real job to process an aux transaction.

s/aux/AUX/

> + * It will call msm_edp_aux_ctrl() function to reset the aux channel,
> + * if the waiting is timeout.
> + * The caller who triggers the transaction should avoid the
> + * msm_edp_aux_ctrl() running concurrently in other threads, i.e.
> + * start transaction only when aux channel is fully enabled.
> + */
> +ssize_t edp_aux_transfer(struct drm_dp_aux *drm_aux, struct drm_dp_aux_m=
sg *msg)
> +{
> +	struct edp_aux *aux =3D to_edp_aux(drm_aux);
> +	ssize_t ret;
> +	bool native =3D msg->request & (DP_AUX_NATIVE_WRITE & DP_AUX_NATIVE_REA=
D);
> +	bool read =3D msg->request & (DP_AUX_I2C_READ & DP_AUX_NATIVE_READ);

These checks are confusing. It seems like they might actually work
because of how these symbols are defined, but I'd expect something like:

	native =3D msg->request & (DP_AUX_NATIVE_WRITE | DP_AUX_NATIVE_READ);

Or perhaps even clearer:

	switch (msg->request) {
	case DP_AUX_NATIVE_WRITE:
	case DP_AUX_NATIVE_READ:
		native =3D true;
		break;

	...
	}

> +	/* Ignore address only message */
> +	if ((msg->size =3D=3D 0) || (msg->buffer =3D=3D NULL)) {
> +		msg->reply =3D native ?
> +			DP_AUX_NATIVE_REPLY_ACK : DP_AUX_I2C_REPLY_ACK;
> +		return msg->size;
> +	}

How do you support I2C-over-AUX then? How else will the device know
which I2C slave to address?

> diff --git a/drivers/gpu/drm/msm/edp/edp_bridge.c b/drivers/gpu/drm/msm/e=
dp/edp_bridge.c
[...]
> +static const struct drm_bridge_funcs edp_bridge_funcs =3D {
> +		.pre_enable =3D edp_bridge_pre_enable,
> +		.enable =3D edp_bridge_enable,
> +		.disable =3D edp_bridge_disable,
> +		.post_disable =3D edp_bridge_post_disable,
> +		.mode_set =3D edp_bridge_mode_set,
> +		.destroy =3D edp_bridge_destroy,
> +		.mode_fixup =3D edp_bridge_mode_fixup,

These should be indented using a single tab.

> diff --git a/drivers/gpu/drm/msm/edp/edp_connector.c b/drivers/gpu/drm/ms=
m/edp/edp_connector.c
[...]
> +static int edp_connector_get_modes(struct drm_connector *connector)
> +{
> +	struct edp_connector *edp_connector =3D to_edp_connector(connector);
> +	struct msm_edp *edp =3D edp_connector->edp;
> +
> +	struct edid *drm_edid =3D NULL;
> +	int ret =3D 0;
> +
> +	DBG("");
> +	ret =3D msm_edp_ctrl_get_edid(edp->ctrl, connector, &drm_edid);
> +	if (ret)
> +		return ret;
> +
> +	if (drm_edid) {
> +		drm_mode_connector_update_edid_property(connector, drm_edid);

I think you want to call this unconditionally to make sure the EDID
property is cleared if you couldn't get a new one. Otherwise you'll end
up with a stale EDID in sysfs.

> +		ret =3D drm_add_edid_modes(connector, drm_edid);
> +	}
> +
> +	return ret;
> +}
[...]
> +static const struct drm_connector_funcs edp_connector_funcs =3D {
> +	.dpms =3D drm_helper_connector_dpms,
> +	.detect =3D edp_connector_detect,
> +	.fill_modes =3D drm_helper_probe_single_connector_modes,
> +	.destroy =3D edp_connector_destroy,
> +};
> +
> +static const struct drm_connector_helper_funcs edp_connector_helper_func=
s =3D {
> +	.get_modes =3D edp_connector_get_modes,
> +	.mode_valid =3D edp_connector_mode_valid,
> +	.best_encoder =3D edp_connector_best_encoder,
> +};

This is missing mandatory callbacks for atomic modesetting, isn't this
going to simply crash when applied on top of a recent kernel with atomic
modesetting support?

> +
> +/* initialize connector */
> +struct drm_connector *msm_edp_connector_init(struct msm_edp *edp)
> +{
> +	struct drm_connector *connector =3D NULL;
> +	struct edp_connector *edp_connector;
> +	int ret;
> +
> +	edp_connector =3D kzalloc(sizeof(*edp_connector), GFP_KERNEL);
> +	if (!edp_connector) {
> +		ret =3D -ENOMEM;
> +		goto fail;
> +	}
> +
> +	edp_connector->edp =3D edp;
> +
> +	connector =3D &edp_connector->base;
> +
> +	ret =3D drm_connector_init(edp->dev, connector, &edp_connector_funcs,
> +			DRM_MODE_CONNECTOR_eDP);
> +	if (ret)
> +		goto fail;
> +
> +	drm_connector_helper_add(connector, &edp_connector_helper_funcs);
> +
> +	/* We don't support HPD, so only poll status until connected. */
> +	connector->polled =3D DRM_CONNECTOR_POLL_CONNECT;
> +
> +	/* Display driver doesn't support interlace now. */
> +	connector->interlace_allowed =3D 0;
> +	connector->doublescan_allowed =3D 0;

These are boolean, so their value should be false rather than 0.

> diff --git a/drivers/gpu/drm/msm/edp/edp_ctrl.c b/drivers/gpu/drm/msm/edp=
/edp_ctrl.c
[...]
> +#include <linux/kernel.h>
> +#include <linux/gpio.h>
> +#include <linux/leds.h>
> +#include "edp.h"
> +#include "edp.xml.h"
> +#include "drm_dp_helper.h"
> +#include "drm_edid.h"
> +#include "drm_crtc.h"

I think a more natural ordering would be linux/*, drm_*, edp.*, because
that's most generic to most specific.

> +#define RGB_COMPONENTS		3

In my opinion this is overkill. Just use a literal 3 in the two places
where this is actually used. The context is enough to know what this is
for.

> +static int cont_splash;	/* 1 to enable continuous splash screen */
> +EXPORT_SYMBOL(cont_splash);
> +
> +module_param(cont_splash, int, 0);
> +MODULE_PARM_DESC(cont_splash, "Enable continuous splash screen on eDP");

Huh? Is this supposed to allow hand-off from firmware to kernel? If so I
don't think that's going to work without having proper support for it
across the driver. I don't see support for this in the MDP subdriver, so
I doubt that it's going to work at all.

Either way, I don't think using a module parameter for this is the right
solution.

> +struct edp_ctrl {
> +	struct platform_device *pdev;
> +
> +	void __iomem *base;
> +
> +	/* regulators */
> +	struct regulator *vdda_vreg;
> +	struct regulator *lvl_reg;
> +
> +	/* clocks */
> +	struct clk *aux_clk;
> +	struct clk *pixel_clk;
> +	struct clk *ahb_clk;
> +	struct clk *link_clk;
> +	struct clk *mdp_core_clk;
> +
> +	/* gpios */
> +	int gpio_panel_en;
> +	int gpio_panel_hpd;
> +	int gpio_lvl_en;
> +	int gpio_bkl_en;

These should really be using the new gpiod_*() API. Also, at least
panel_en and bkl_en seem wrongly placed. They should be handled in the
panel and backlight drivers, not the eDP driver.

Also it seems like gpio_lvl_en and lvl_reg are two different ways of
representing the same thing. You should use the regulator only and if
it's a simple GPIO use the fixed regulator with a gpio property.

> +
> +	/* backlight */
> +	struct pwm_device *bl_pwm;
> +	u32 pwm_period;
> +	u32 bl_level;
> +#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
> +	struct backlight_device *backlight_dev;
> +#endif

This looks very much like a duplicate of pwm-backlight. Any reason why
you can't use it?

> +struct edp_pixel_clk_div {
> +	u32 rate; /* in kHz */
> +	u32 m;
> +	u32 n;
> +};
> +
> +#define EDP_PIXEL_CLK_NUM 8
> +static const struct edp_pixel_clk_div clk_divs[2][EDP_PIXEL_CLK_NUM] =3D=
 {
> +	{ /* Link clock =3D 162MHz, source clock =3D 810MHz */
> +		{119000, 31,  211}, /* WSXGA+ 1680x1050@60Hz CVT */
> +		{130250, 32,  199}, /* UXGA 1600x1200@60Hz CVT */
> +		{148500, 11,  60},  /* FHD 1920x1080@60Hz */
> +		{154000, 50,  263}, /* WUXGA 1920x1200@60Hz CVT */
> +		{209250, 31,  120}, /* QXGA 2048x1536@60Hz CVT */
> +		{268500, 119, 359}, /* WQXGA 2560x1600@60Hz CVT */
> +		{138530, 33,  193}, /* AUO B116HAN03.0 Panel */
> +		{141400, 48,  275}, /* AUO B133HTN01.2 Panel */
> +	},
> +	{ /* Link clock =3D 270MHz, source clock =3D 675MHz */
> +		{119000, 52,  295}, /* WSXGA+ 1680x1050@60Hz CVT */
> +		{130250, 11,  57},  /* UXGA 1600x1200@60Hz CVT */
> +		{148500, 11,  50},  /* FHD 1920x1080@60Hz */
> +		{154000, 47,  206}, /* WUXGA 1920x1200@60Hz CVT */
> +		{209250, 31,  100}, /* QXGA 2048x1536@60Hz CVT */
> +		{268500, 107, 269}, /* WQXGA 2560x1600@60Hz CVT */
> +		{138530, 63,  307}, /* AUO B116HAN03.0 Panel */
> +		{141400, 53,  253}, /* AUO B133HTN01.2 Panel */
> +	},
> +};

Can't you compute these programmatically? If you rely on this table
you'll need to extend it everytime you want to support a new panel or
resolution.

> +static void edp_clk_deinit(struct edp_ctrl *ctrl)
> +{
> +	struct device *dev =3D &ctrl->pdev->dev;
> +
> +	if (ctrl->aux_clk)
> +		devm_clk_put(dev, ctrl->aux_clk);
> +	if (ctrl->pixel_clk)
> +		devm_clk_put(dev, ctrl->pixel_clk);
> +	if (ctrl->ahb_clk)
> +		devm_clk_put(dev, ctrl->ahb_clk);
> +	if (ctrl->link_clk)
> +		devm_clk_put(dev, ctrl->link_clk);
> +	if (ctrl->mdp_core_clk)
> +		devm_clk_put(dev, ctrl->mdp_core_clk);
> +}

What's the point of using devm_* if you do manual cleanup anyway?

> +	ctrl->mdp_core_clk =3D devm_clk_get(dev, "mdp_core_clk");
> +	if (IS_ERR(ctrl->mdp_core_clk)) {
> +		pr_err("%s: Can't find mdp_core_clk", __func__);
> +		ctrl->mdp_core_clk =3D NULL;
> +		goto edp_clk_err;
> +	}
> +
> +	return 0;
> +
> +edp_clk_err:
> +	edp_clk_deinit(ctrl);
> +	return -EPERM;

You should really propagate a proper error code here.

> +static int edp_regulator_init(struct edp_ctrl *ctrl)
> +{
> +	struct device *dev =3D &ctrl->pdev->dev;
> +	int ret;
> +
> +	DBG("");
> +	ctrl->vdda_vreg =3D devm_regulator_get(dev, "vdda");
> +	if (IS_ERR(ctrl->vdda_vreg)) {
> +		pr_err("%s: Could not get vdda reg, ret =3D %ld\n", __func__,
> +				PTR_ERR(ctrl->vdda_vreg));
> +		ctrl->vdda_vreg =3D NULL;
> +		ret =3D -ENODEV;
> +		goto f0;
> +	}
> +
> +	ret =3D regulator_set_voltage(ctrl->vdda_vreg, VDDA_MIN_UV, VDDA_MAX_UV=
);
> +	if (ret) {
> +		pr_err("%s:vdda_vreg set_voltage failed, %d\n", __func__, ret);
> +		goto f1;
> +	}
> +
> +	ret =3D regulator_set_optimum_mode(ctrl->vdda_vreg, VDDA_UA_ON_LOAD);
> +	if (ret < 0) {
> +		pr_err("%s: vdda_vreg set regulator mode failed.\n", __func__);
> +		goto f1;
> +	}
> +
> +	ret =3D regulator_enable(ctrl->vdda_vreg);
> +	if (ret) {
> +		pr_err("%s: Failed to enable vdda_vreg regulator.\n", __func__);
> +		goto f2;
> +	}
> +
> +	DBG("exit");
> +	return 0;
> +
> +f2:
> +	regulator_set_optimum_mode(ctrl->vdda_vreg, VDDA_UA_OFF_LOAD);
> +f1:
> +	devm_regulator_put(ctrl->vdda_vreg);
> +	ctrl->vdda_vreg =3D NULL;
> +f0:
> +	return ret;

The label names could be improved here.

> +/* The power source of the level translation chip is different on differ=
ent
> + * target boards, i.e. a gpio or a regulator.
> + */

Like I said above you should simply always make this a regulator and use
a fixed GPIO regulator if it's controlled by a GPIO.

> +static int edp_sink_power_state(struct edp_ctrl *ctrl, u8 state)
> +{
> +	u8 s =3D state;
> +
> +	DBG("%d", s);
> +
> +	if (ctrl->dp_link.revision < 0x11)
> +		return 0;
> +
> +	if (drm_dp_dpcd_write(ctrl->drm_aux, DP_SET_POWER, &s, 1) < 1) {
> +		pr_err("%s: Set power state to panel failed\n", __func__);
> +		return -ENOLINK;
> +	}
> +
> +	return 0;
> +}

This is essentially drm_dp_link_power_up()/drm_dp_link_power_down().
Please use common code where available. And if it's not available yet
the code is completely generic, please add a core function so that
other drivers can reuse it.

> +static int edp_train_pattern_set_write(struct edp_ctrl *ctrl, u8 pattern)
> +{
> +	u8 p =3D pattern;
> +
> +	DBG("pattern=3D%x", p);
> +	if (drm_dp_dpcd_write(ctrl->drm_aux, 0x102, &p, 1) < 1) {

0x102 is DP_TRAINING_PATTERN_SET.

> +static void edp_host_train_set(struct edp_ctrl *ctrl, u32 train)
> +{
> +	int cnt;
> +	u32 data;
> +	u32 bit;
> +
> +	bit =3D 1;
> +	bit <<=3D (train - 1);
> +	DBG("%s: bit=3D%d train=3D%d", __func__, bit, train);
> +
> +	edp_state_ctrl(ctrl, bit);
> +	bit =3D 8;
> +	bit <<=3D (train - 1);
> +	cnt =3D 10;

Maybe do that as part of the declaration?

> +	while (cnt--) {
> +		data =3D edp_read(ctrl->base + REG_EDP_MAINLINK_READY);
> +		if (data & bit)
> +			break;
> +	}
> +
> +	if (cnt =3D=3D 0)
> +		pr_err("%s: set link_train=3D%d failed\n", __func__, train);

I don't think this works as was intended. while (cnt--) will still
execute the loop once because the post-fix operator is applied after the
variable is evaluated. That is, after the loop terminates, cnt will
really be -1, so the error won't be printed. It will only be printed if
the loop happens to terminate on the penultimate iteration.

> +	int tries;
> +	int ret =3D 0;
> +	int rlen;
> +
> +	DBG("");
> +
> +	edp_host_train_set(ctrl, 0x02); /* train_2 */

Perhaps use the DP_TRAINING_PATTERN_* symbolic names and avoid the
comment.

> +static int edp_ctrl_training(struct edp_ctrl *ctrl)
> +{
> +	int ret;
> +
> +	/* Do link training only when power is on */
> +	if (ctrl->cont_splash || (!ctrl->power_on))

No need for the parentheses around !ctrl->power_on.

> +static void edp_ctrl_on_worker(struct work_struct *work)
> +{
[...]
> +}
> +
> +static void edp_ctrl_off_worker(struct work_struct *work)
> +{
> +	struct edp_ctrl *ctrl =3D container_of(
> +				work, struct edp_ctrl, off_work);
> +	int ret =3D 0;

No need to initialize this.

[...]
> +}

Why are these two functions workers?

> +
> +irqreturn_t msm_edp_ctrl_irq(struct edp_ctrl *ctrl)
> +{
[...]
> +	if (isr1 & EDP_INTERRUPT_REG_1_HPD)
> +		DBG("edp_hpd");

Don't you want to handle this?

> +
> +	if (isr2 & EDP_INTERRUPT_REG_2_READY_FOR_VIDEO)
> +		DBG("edp_video_ready");
> +
> +	if (isr2 & EDP_INTERRUPT_REG_2_IDLE_PATTERNs_SENT) {

s/PATTERNs/PATTERNS/? I was going to make that comment to the definition
of this define, but I can't seem to find it. I suspect that it comes
=66rom one of the generated headers, but I can't seem to find either the
generated header nor the XML.

> +		DBG("idle_patterns_sent");
> +		complete(&ctrl->idle_comp);
> +	}
> +
> +	msm_edp_aux_irq(ctrl->aux, isr1);
> +
> +	return IRQ_HANDLED;
> +}
[...]
> +bool msm_edp_ctrl_panel_connected(struct edp_ctrl *ctrl)
> +{
> +	bool ret;

This is unnecessary, the only place where this is used is to return the
value of ctrl->edp_connected. You can use that directly instead.

[...]
> +	ret =3D ctrl->edp_connected;
> +	mutex_unlock(&ctrl->dev_mutex);
> +
> +	return ret;
> +}
> +
> +int msm_edp_ctrl_get_edid(struct edp_ctrl *ctrl,
> +		struct drm_connector *connector, struct edid **edid)
> +{
> +	int ret =3D 0;
> +
> +	mutex_lock(&ctrl->dev_mutex);
> +
> +	if (ctrl->edid) {
> +		if (edid) {
> +			DBG("Just return edid buffer");
> +			*edid =3D ctrl->edid;
> +		}
> +		goto unlock_ret;
> +	}

Is there a way to invalidate an existing EDID?

> +
> +	if (!ctrl->power_on) {
> +		if (!ctrl->cont_splash)
> +			edp_ctrl_phy_aux_enable(ctrl, 1);
> +		edp_ctrl_irq_enable(ctrl, 1);
> +	}
> +
> +	ret =3D drm_dp_link_probe(ctrl->drm_aux, &ctrl->dp_link);
> +	if (ret) {
> +		pr_err("%s: read dpcd cap failed, %d\n", __func__, ret);
> +		goto disable_ret;
> +	}
> +
> +	/* Initialize link rate as panel max link rate */
> +	ctrl->link_rate =3D drm_dp_link_rate_to_bw_code(ctrl->dp_link.rate);

There's a lot of code here that should probably be a separate function
rather than be called as part of retrieving the EDID.

> +int msm_edp_ctrl_timing_cfg(struct edp_ctrl *ctrl,
> +	struct drm_display_mode *mode, struct drm_display_info *info)

Can mode and info be const?

> +{
> +	u32 hstart_from_sync, vstart_from_sync;
> +	u32 data;
> +	int ret =3D 0;
> +
[...]
> +
> +	vstart_from_sync =3D mode->vtotal - mode->vsync_start;
> +	hstart_from_sync =3D (mode->htotal - mode->hsync_start);

No need for the parentheses.

> diff --git a/drivers/gpu/drm/msm/edp/edp_phy.c b/drivers/gpu/drm/msm/edp/=
edp_phy.c
[...]
> +bool msm_edp_phy_ready(struct edp_phy *phy)
> +{
> +	u32 status;
> +	int cnt;
> +
> +	cnt =3D 100;
> +	while (--cnt) {
> +		status =3D edp_read(phy->base +
> +				REG_EDP_PHY_GLB_PHY_STATUS);
> +		if (status & 0x01)

Can you add a define for 0x01?

> +			break;
> +		usleep_range(500, 1000);
> +	}
> +
> +	if (cnt <=3D 0) {

This is a better version than above, except that cnt can never be
negative. It will be zero upon timeout.

> +		pr_err("%s: PHY NOT ready\n", __func__);
> +		return false;
> +	} else {
> +		return true;
> +	}
> +}
> +
> +void msm_edp_phy_ctrl(struct edp_phy *phy, int enable)
> +{
> +	DBG("enable=3D%d", enable);
> +	if (enable) {
> +		/* Reset */
> +		edp_write(phy->base + REG_EDP_PHY_CTRL, 0x005); /* bit 0, 2 */
> +		wmb();
> +		usleep_range(500, 1000);
> +		edp_write(phy->base + REG_EDP_PHY_CTRL, 0x000);
> +		edp_write(phy->base + REG_EDP_PHY_GLB_PD_CTL, 0x3f);
> +		edp_write(phy->base + REG_EDP_PHY_GLB_CFG, 0x1);
> +	} else {
> +		edp_write(phy->base + REG_EDP_PHY_GLB_PD_CTL, 0xc0);
> +	}

Please, also add defines for the values here. It's impossible to tell
=66rom the code what this does or what might need fixing if there was a
bug.

> +void msm_edp_phy_lane_power_ctrl(struct edp_phy *phy, int up, int max_la=
ne)

bool for up? And unsigned int for max_lane?

> +{
> +	int i;

This could also be unsigned int.

Thierry

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUhad7AAoJEN0jrNd/PrOhb+sP/jvJELj2SASuyELvukbIMpn7
3pY1eErsbomg26RIPArZ4QySbmUqzFyBBpIwU/j3G5BUzi3nhDcoKq99VEcEzP/M
EEVGkkDEOSSCRxNixYdjCepAYVaf7Ym24pVWTyP5mFYXObwCpHe9rAg1kZqN38Cc
VVxcbfK8B3nghZHofxvgVUf3kR/0F5VfCenXU6+++/OFaoV1mY7yGurm/BpHS34w
S/RrmFsG0zJ0e+tBNp7mU62A1tbtvBZlD3nWuqNj+JVMiG4xO0AHEJEaBs3JEWVN
trh78G366/gAotTADflLjIMTZOjA/K2X6rRYDel7rhjLZRLtp4C+gkBIZKF3ycsJ
nRsM0QDHL1PvK92e9qzFuF85xZ0px1/bC7swLuzczxVfwqFNefUUgu0ApE4p0XfA
LwXbFcZR4q/EI9l6pG4PovDsNjTQKQcVATAhRA6F4UD9w0Ut86HlzyTZ7jqVH6MS
LSKi3dcnl1o9pZnLyblqbufhxagut57xortIMszrzny8CTLdQsE/ATFdw2HR14bT
NCFXLDf+mrFmBPUTXCYlL2rNjWPiC/wBQOQ3HpN3r7HDsD6jmc/mccWsvyOxoBdG
cmpwNefQq1yIPyVbO0tHO5NDwrvGEXlVLk5GRtS4Uxc6BEft6xYQao3hvaCoPvLr
eH8emnqHbIcJ3xErUY5Q
=+Y+o
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
