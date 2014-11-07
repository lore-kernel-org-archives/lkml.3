Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbaKGCsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 21:48:25 -0500
Received: from regular1.263xmail.com ([211.150.99.131]:34417 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbaKGCsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 21:48:21 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: linux-rockchip@lists.infradead.org
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <40cb6c0a3e6e57b239ff652904ef54ac>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <545C32DB.7090907@rock-chips.com>
Date: Fri, 07 Nov 2014 10:47:55 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
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
Subject: Re: [PATCH 1/2] imx-drm: imx-hdmi: split imx soc specific code from
 imx-hdmi
References: <1415192101-6404-1-git-send-email-andy.yan@rock-chips.com>	 <1415192101-6404-2-git-send-email-andy.yan@rock-chips.com> <1415194882.5696.9.camel@pengutronix.de>
In-Reply-To: <1415194882.5696.9.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年11月05日 21:41, Philipp Zabel wrote:
> Hi Andy,
>
> I think separating the core from the SoC specific part is a good step
> into the right direction.
>
> Am Mittwoch, den 05.11.2014, 20:55 +0800 schrieb Andy Yan:
>> imx6 and rockchip rk3288 and JZ4780 (Ingenic Xburst/MIPS)
>> use the interface compatible Designware HDMI IP, but they
>> also have some lightly difference, such as phy pll configuration,
>> register width(imx hdmi register is one byte, but rk3288 is 4
>> bytes width), 4K support(imx6 doesn't support 4k, but rk3288 does),
>> clk useage,and the crtc mux configuration is also platform specific.
>>
>> To reuse the imx hdmi driver, split the platform specific code out
>> to dw_hdmi-imx.c.
>>
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> [...]
>> +static int imx_hdmi_parse_dt(struct imx_hdmi_priv *hdmi)
>> +{
>> +	struct device_node *np = hdmi->dev->of_node;
>> +
>> +	hdmi->regmap = syscon_regmap_lookup_by_phandle(np, "gpr");
>> +	if (IS_ERR(hdmi->regmap)) {
>> +		dev_err(hdmi->dev, "Unable to get gpr\n");
>> +		return PTR_ERR(hdmi->regmap);
>> +	}
>> +
>> +	hdmi->isfr_clk = devm_clk_get(hdmi->dev, "isfr");
>> +	if (IS_ERR(hdmi->isfr_clk)) {
>> +		dev_err(hdmi->dev, "Unable to get HDMI isfr clk\n");
>> +		return PTR_ERR(hdmi->isfr_clk);
>> +	}
>> +
>> +	hdmi->iahb_clk = devm_clk_get(hdmi->dev, "iahb");
>> +	if (IS_ERR(hdmi->iahb_clk)) {
>> +		dev_err(hdmi->dev, "Unable to get HDMI iahb clk\n");
>> +		return PTR_ERR(hdmi->iahb_clk);
>> +	}
> Surely this IP core needs to be clocked regardless of the SoC? How are
> clocks controlled on rk3288 and jz4780?
yes, this IP core need to be clocked. But different Soc has different
usage of the clk, on freescale imx platform one clk is used for isfr, 
one is used for iahb,
but on rockchip rk3288, one clk is used for control logic , the another 
is used for hdcp.
I am not sure how are the clocks on jz4780

>
> [...]
>> +/*On rockchip platform, no-word access to the hdmi
>> + * register will causes an imprecise external abort
>> + */
>> +static inline void hdmi_writel(struct imx_hdmi *hdmi, u32 val, int offset)
>> +{
>> +	writel(val, hdmi->regs + (offset << 2));
>> +}
>>   
>> -	bool phy_enabled;
>> -	struct drm_display_mode previous_mode;
>> +static inline u32 hdmi_readl(struct imx_hdmi *hdmi, int offset)
>> +{
>> +	return readl(hdmi->regs + (offset << 2));
>> +}
>>   
>> -	struct regmap *regmap;
>> -	struct i2c_adapter *ddc;
>> -	void __iomem *regs;
>> +static void hdmi_modl(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
>> +{
>> +	u32 val = hdmi_readl(hdmi, reg) & ~mask;
>>   
>> -	unsigned int sample_rate;
>> -	int ratio;
>> -};
>> +	val |= data & mask;
>> +	hdmi_writel(hdmi, val, reg);
>> +}
>>   
>> -static void imx_hdmi_set_ipu_di_mux(struct imx_hdmi *hdmi, int ipu_di)
>> +static void hdmi_mask_writel(struct imx_hdmi *hdmi, u32 data, unsigned int reg,
>> +			     u32 shift, u32 mask)
>>   {
>> -	regmap_update_bits(hdmi->regmap, IOMUXC_GPR3,
>> -			   IMX6Q_GPR3_HDMI_MUX_CTL_MASK,
>> -			   ipu_di << IMX6Q_GPR3_HDMI_MUX_CTL_SHIFT);
>> +	hdmi_modl(hdmi, data << shift, mask, reg);
>>   }
>>   
>> -static inline void hdmi_writeb(struct imx_hdmi *hdmi, u8 val, int offset)
>> +static inline void hdmi_writeb(struct imx_hdmi *hdmi, u32 val, int offset)
>>   {
>>   	writeb(val, hdmi->regs + offset);
>>   }
>>   
>> -static inline u8 hdmi_readb(struct imx_hdmi *hdmi, int offset)
>> +static inline u32 hdmi_readb(struct imx_hdmi *hdmi, int offset)
>>   {
>>   	return readb(hdmi->regs + offset);
>>   }
>>   
>> -static void hdmi_modb(struct imx_hdmi *hdmi, u8 data, u8 mask, unsigned reg)
>> +static void hdmi_modb(struct imx_hdmi *hdmi, u32 data, u32 mask, unsigned reg)
>>   {
>>   	u8 val = hdmi_readb(hdmi, reg) & ~mask;
> Do you really need to use readl instead of readb? In my opinion it would
> be better then to convert the driver to use regmap for register access
> (in a separate patch) and then let the SoC specific driver extension
> provide the regmap to the core driver.
Rockchip RK3288 can only access the hdmi register by 32bit(readl/writel)
byte access(readb/writeb) will cause  an imprecise external abort

I refactor the register access in PATCH V3, if you have any 
suggestion,please
tell me.
>
> [...]
>> diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
>> new file mode 100644
>> index 0000000..e7e8285
>> --- /dev/null
>> +++ b/include/drm/bridge/dw_hdmi.h
>> @@ -0,0 +1,114 @@
>> +/*
>> + * Copyright (C) 2011 Freescale Semiconductor, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + */
>> +
>> +#ifndef __DW_HDMI_H__
>> +#define __DW_HDMI_H__
>> +
>> +#include <drm/drmP.h>
>> +
>> +#define HDMI_EDID_LEN           512
>> +
>> +enum {
>> +	RES_8,
>> +	RES_10,
>> +	RES_12,
>> +	RES_MAX,
>> +};
>> +
>> +enum imx_hdmi_devtype {
>> +	IMX6Q_HDMI,
>> +	IMX6DL_HDMI,
>> +};
>> +
>> +struct mpll_config {
>> +	unsigned long mpixelclock;
>> +	struct {
>> +		u16 cpce;
>> +		u16 gmp;
>> +	} res[RES_MAX];
>> +};
>> +
>> +struct curr_ctrl {
>> +	unsigned long mpixelclock;
>> +	u16 curr[RES_MAX];
>> +};
> For a header file in include/drm/bridge maybe these struct names are a
> bit too generic now.
>
> regards
> Philipp
>
>
>
>
>


