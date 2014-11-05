Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaKENmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 08:42:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40691 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaKENmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 08:42:05 -0500
Message-ID: <1415194882.5696.9.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] imx-drm: imx-hdmi: split imx soc specific code from
 imx-hdmi
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Date: Wed, 05 Nov 2014 14:41:22 +0100
In-Reply-To: <1415192101-6404-2-git-send-email-andy.yan@rock-chips.com>
References: <1415192101-6404-1-git-send-email-andy.yan@rock-chips.com>
	 <1415192101-6404-2-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

I think separating the core from the SoC specific part is a good step
into the right direction.

Am Mittwoch, den 05.11.2014, 20:55 +0800 schrieb Andy Yan:
> imx6 and rockchip rk3288 and JZ4780 (Ingenic Xburst/MIPS)
> use the interface compatible Designware HDMI IP, but they
> also have some lightly difference, such as phy pll configuration,
> register width(imx hdmi register is one byte, but rk3288 is 4
> bytes width), 4K support(imx6 doesn't support 4k, but rk3288 does),
> clk useage,and the crtc mux configuration is also platform specific.
> 
> To reuse the imx hdmi driver, split the platform specific code out
> to dw_hdmi-imx.c.
> 
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
[...]
> +static int imx_hdmi_parse_dt(struct imx_hdmi_priv *hdmi)
> +{
> +	struct device_node *np = hdmi->dev->of_node;
> +
> +	hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
> +	if (IS_ERR(hdmi->regmap)) {
> +		dev_err(hdmi->dev, "Unable to get gpr\n");
> +		return PTR_ERR(hdmi->regmap);
> +	}
> +
> +	hdmi->isfr_clk = devm_clk_get(hdmi->dev, "isfr");
> +	if (IS_ERR(hdmi->isfr_clk)) {
> +		dev_err(hdmi->dev, "Unable to get HDMI isfr clk\n");
> +		return PTR_ERR(hdmi->isfr_clk);
> +	}
> +
> +	hdmi->iahb_clk = devm_clk_get(hdmi->dev, "iahb");
> +	if (IS_ERR(hdmi->iahb_clk)) {
> +		dev_err(hdmi->dev, "Unable to get HDMI iahb clk\n");
> +		return PTR_ERR(hdmi->iahb_clk);
> +	}

Surely this IP core needs to be clocked regardless of the SoC? How are
clocks controlled on rk3288 and jz4780?

[...]
> +/*On rockchip platform, no-word access to the hdmi
> + * register will causes an imprecise external abort
> + */
> +static inline void hdmi_writel(struct imx_hdmi *hdmi, u32 val, int offset)
> +{
> +	writel(val, hdmi->regs + (offset << 2));
> +}
>  
> -	bool phy_enabled;
> -	struct drm_display_mode previous_mode;
> +static inline u32 hdmi_readl(struct imx_hdmi *hdmi, int offset)
> +{
> +	return readl(hdmi->regs + (offset << 2));
> +}
>  
> -	struct regmap *regmap;
> -	struct i2c_adapter *ddc;
> -	void __iomem *regs;
> +static void hdmi_modl(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
> +{
> +	u32 val = hdmi_readl(hdmi, reg) & ~mask;
>  
> -	unsigned int sample_rate;
> -	int ratio;
> -};
> +	val |= data & mask;
> +	hdmi_writel(hdmi, val, reg);
> +}
>  
> -static void imx_hdmi_set_ipu_di_mux(struct imx_hdmi *hdmi, int ipu_di)
> +static void hdmi_mask_writel(struct imx_hdmi *hdmi, u32 data, unsigned int reg,
> +			     u32 shift, u32 mask)
>  {
> -	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
> -			   IMX6Q_GPR3_HDMI_MUX_CTL_MASK,
> -			   ipu_di << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
> +	hdmi_modl(hdmi, data << shift, mask, reg);
>  }
>  
> -static inline void hdmi_writeb(struct imx_hdmi *hdmi, u8 val, int offset)
> +static inline void hdmi_writeb(struct imx_hdmi *hdmi, u32 val, int offset)
>  {
>  	writeb(val, hdmi->regs + offset);
>  }
>  
> -static inline u8 hdmi_readb(struct imx_hdmi *hdmi, int offset)
> +static inline u32 hdmi_readb(struct imx_hdmi *hdmi, int offset)
>  {
>  	return readb(hdmi->regs + offset);
>  }
>  
> -static void hdmi_modb(struct imx_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
> +static void hdmi_modb(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
>  {
>  	u8 val = hdmi_readb(hdmi, reg) & ~mask;

Do you really need to use readl instead of readb? In my opinion it would
be better then to convert the driver to use regmap for register access
(in a separate patch) and then let the SoC specific driver extension
provide the regmap to the core driver.

[...]
> diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
> new file mode 100644
> index 0000000..e7e8285
> --- /dev/null
> +++ b/include/drm/bridge/dw_hdmi.h
> @@ -0,0 +1,114 @@
> +/*
> + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef __DW_HDMI_H__
> +#define __DW_HDMI_H__
> +
> +#include <drm/drmP.h>
> +
> +#define HDMI_EDID_LEN           512
> +
> +enum {
> +	RES_8,
> +	RES_10,
> +	RES_12,
> +	RES_MAX,
> +};
> +
> +enum imx_hdmi_devtype {
> +	IMX6Q_HDMI,
> +	IMX6DL_HDMI,
> +};
> +
> +struct mpll_config {
> +	unsigned long mpixelclock;
> +	struct {
> +		u16 cpce;
> +		u16 gmp;
> +	} res[RES_MAX];
> +};
> +
> +struct curr_ctrl {
> +	unsigned long mpixelclock;
> +	u16 curr[RES_MAX];
> +};

For a header file in include/drm/bridge maybe these struct names are a
bit too generic now.

regards
Philipp


