Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaKKOmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:42:13 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:34100 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaKKOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:42:11 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <420548288b203b1374fd949bf0b5bd1a>
X-DNS-TYPE: 0
Message-ID: <5462202E.2080809@rock-chips.com>
Date: Tue, 11 Nov 2014 22:41:50 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, airlied@linux.ie,
        heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
CC: devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Inki Dae <inki.dae@samsung.com>, linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>,
        djkurtz@google.com, Philipp Zabel <p.zabel@pengutronix.de>,
        ykk@rock-chips.com, Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Shawn Guo <shawn.guo@linaro.org>,
        jay.xu@rock-chips.com, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v7 4/7] staging: imx-drm: imx-hdmi: move imx-hdmi to bridge/dw-hdmi
References: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com> <1415710398-12120-1-git-send-email-andy.yan@rock-chips.com> <54621A3D.9090406@imgtec.com>
In-Reply-To: <54621A3D.9090406@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年11月11日 22:16, Zubair Lutfullah Kakakhel wrote:
> Hi Andy,
>
> On 11/11/14 12:53, Andy Yan wrote:
>> the original imx hdmi driver is under staging/imx-drm,
>> which depends on imx-drm, so move the imx hdmi drvier out
> Spelling mistake. 				^'driver'
>
>> to drm/bridge and rename imx-hdmi to dw-hdmi
> 				      ^dw_hdmi
  thanks , these will be fixed in v8
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>>
>> ---
>>
>> Changes in v7: None
>> Changes in v6: None
>> Changes in v5: None
>> Changes in v4: None
>> Changes in v3: None
>> Changes in v2:
>> - use git format -M to generate these patch
>>
>>   drivers/gpu/drm/bridge/Kconfig                     |   5 +
>>   drivers/gpu/drm/bridge/Makefile                    |   1 +
>>   .../imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c}        | 281 +++++++++++----------
>>   .../imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h}        |  46 +---
>>   drivers/staging/imx-drm/Kconfig                    |   1 +
>>   drivers/staging/imx-drm/Makefile                   |   2 +-
>>   drivers/staging/imx-drm/dw_hdmi-imx.c              |  70 ++---
>>   include/drm/bridge/dw_hdmi.h                       |  57 +++++
>>   8 files changed, 243 insertions(+), 220 deletions(-)
>>   rename drivers/{staging/imx-drm/imx-hdmi.c => gpu/drm/bridge/dw_hdmi.c} (83%)
>>   rename drivers/{staging/imx-drm/imx-hdmi.h => gpu/drm/bridge/dw_hdmi.h} (97%)
>>   create mode 100644 include/drm/bridge/dw_hdmi.h
>>
>> diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
>> index 884923f..26162ef 100644
>> --- a/drivers/gpu/drm/bridge/Kconfig
>> +++ b/drivers/gpu/drm/bridge/Kconfig
>> @@ -3,3 +3,8 @@ config DRM_PTN3460
>>   	depends on DRM
>>   	select DRM_KMS_HELPER
>>   	---help---
>> +
>> +config DRM_DW_HDMI
>> +	bool "Synopsys DesignWare High-Definition Multimedia Interface"
>> +	depends on DRM
>> +	select DRM_KMS_HELPER
>> diff --git a/drivers/gpu/drm/bridge/Makefile b/drivers/gpu/drm/bridge/Makefile
>> index b4733e1..d8a8cfd 100644
>> --- a/drivers/gpu/drm/bridge/Makefile
>> +++ b/drivers/gpu/drm/bridge/Makefile
>> @@ -1,3 +1,4 @@
>>   ccflags-y := -Iinclude/drm
>>   
>>   obj-$(CONFIG_DRM_PTN3460) += ptn3460.o
>> +obj-$(CONFIG_DRM_DW_HDMI) += dw_hdmi.o
>> diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
>> similarity index 83%
>> rename from drivers/staging/imx-drm/imx-hdmi.c
>> rename to drivers/gpu/drm/bridge/dw_hdmi.c
>> index c7e5f12..e9f0dfe 100644
>> --- a/drivers/staging/imx-drm/imx-hdmi.c
>> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
>> @@ -6,8 +6,7 @@
>>    * the Free Software Foundation; either version 2 of the License, or
>>    * (at your option) any later version.
>>    *
>> - * SH-Mobile High-Definition Multimedia Interface (HDMI) driver
>> - * for SLISHDMI13T and SLIPHDMIT IP cores
> ...
>
>> diff --git a/drivers/staging/imx-drm/imx-hdmi.h b/drivers/gpu/drm/bridge/dw_hdmi.h
>> similarity index 97%
>> rename from drivers/staging/imx-drm/imx-hdmi.h
>> rename to drivers/gpu/drm/bridge/dw_hdmi.h
>> index e67d60d..b8412a9 100644
>> --- a/drivers/staging/imx-drm/imx-hdmi.h
>> +++ b/drivers/gpu/drm/bridge/dw_hdmi.h
>> @@ -7,8 +7,8 @@
>>    * (at your option) any later version.
>>    */
>>   
>> -#ifndef __IMX_HDMI_H__
>> -#define __IMX_HDMI_H__
>> +#ifndef __DW_HDMI__
>> +#define __DW_HDMI__
>>   
>>   /* Identification Registers */
>>   #define HDMI_DESIGN_ID                          0x0000
>> @@ -1030,46 +1030,4 @@ enum {
>>   	HDMI_A_VIDPOLCFG_HSYNCPOL_ACTIVE_LOW = 0x0,
>>   };
>>   
>> -enum {
>> -	RES_8,
>> -	RES_10,
>> -	RES_12,
>> -	RES_MAX,
>> -};
>> -
>> -enum imx_hdmi_devtype {
>> -	IMX6Q_HDMI,
>> -	IMX6DL_HDMI,
>> -};
>> -
>> -struct mpll_config {
>> -	unsigned long mpixelclock;
>> -	struct {
>> -		u16 cpce;
>> -		u16 gmp;
>> -	} res[RES_MAX];
>> -};
>> -
>> -struct curr_ctrl {
>> -	unsigned long mpixelclock;
>> -	u16 curr[RES_MAX];
>> -};
>> -
>> -struct imx_hdmi_plat_data {
>> -	void * (*setup)(struct platform_device *pdev);
>> -	void (*exit)(void *priv);
>> -	void (*encoder_commit)(void *priv, struct drm_encoder *encoder);
>> -	void (*encoder_prepare)(struct drm_connector *connector,
>> -				struct drm_encoder *encoder);
>> -	enum drm_mode_status (*mode_valid)(struct drm_connector *connector,
>> -					   struct drm_display_mode *mode);
>> -	const struct mpll_config *mpll_cfg;
>> -	const struct curr_ctrl *cur_ctr;
>> -	enum imx_hdmi_devtype dev_type;
>> -
>> -};
>> -
>> -int imx_hdmi_platform_register(struct platform_device *pdev,
>> -			       const struct imx_hdmi_plat_data *plat_data);
>> -int imx_hdmi_platform_unregister(struct platform_device *pdev);
> Doesn't this change belong in the previous splitting patch?
     in previous splitting patch we put these in staging/imx-drm/imx-hdmi.h
    now we move these common  struct to include/drm/bridge/dw-hdmi.h
>
>>   #endif /* __IMX_HDMI_H__ */
>> diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
>> index ab31848..560e1d3 100644
>> --- a/drivers/staging/imx-drm/Kconfig
>> +++ b/drivers/staging/imx-drm/Kconfig
>> @@ -50,5 +50,6 @@ config DRM_IMX_IPUV3
>>   config DRM_IMX_HDMI
>>   	tristate "Freescale i.MX DRM HDMI"
>>   	depends on DRM_IMX
>> +	select DRM_DW_HDMI
>>   	help
>>   	  Choose this if you want to use HDMI on i.MX6.
>> diff --git a/drivers/staging/imx-drm/Makefile b/drivers/staging/imx-drm/Makefile
>> index 809027d..f3ecd89 100644
>> --- a/drivers/staging/imx-drm/Makefile
>> +++ b/drivers/staging/imx-drm/Makefile
>> @@ -9,4 +9,4 @@ obj-$(CONFIG_DRM_IMX_LDB) += imx-ldb.o
>>   
>>   imx-ipuv3-crtc-objs  := ipuv3-crtc.o ipuv3-plane.o
>>   obj-$(CONFIG_DRM_IMX_IPUV3)	+= imx-ipuv3-crtc.o
>> -obj-$(CONFIG_DRM_IMX_HDMI) += imx-hdmi.o dw_hdmi-imx.o
>> +obj-$(CONFIG_DRM_IMX_HDMI) += dw_hdmi-imx.o
>> diff --git a/drivers/staging/imx-drm/dw_hdmi-imx.c b/drivers/staging/imx-drm/dw_hdmi-imx.c
>> index 0db978e..4b48ea6 100644
>> --- a/drivers/staging/imx-drm/dw_hdmi-imx.c
>> +++ b/drivers/staging/imx-drm/dw_hdmi-imx.c
> All other files in imx-drm/ are named imx-xyz.
>
> no underscore either.
>
> I wonder if they are ok with dw_hdmi-imx.c
>
> How about imx-dw-hdmi.c
> and imx-dw-hdmi.h ?
   I see some dw ip drivers like dw-mmc and dwmac have
   name style like dw_xxx.c for core driver, dw_xx_yy.c
   for platform driver, so I keep the same with it.
>> @@ -10,14 +10,14 @@
>>   #include <linux/platform_device.h>
>>   #include <linux/mfd/syscon.h>
>>   #include <linux/mfd/syscon/imx6q-iomuxc-gpr.h>
>> +#include <drm/bridge/dw_hdmi.h>
>>   #include <video/imx-ipu-v3.h>
>>   #include <linux/regmap.h>
>>   #include <linux/clk.h>
>>   
>>   #include "imx-drm.h"
>> -#include "imx-hdmi.h"
>>   
>>   
>> -static const struct of_device_id imx_hdmi_imx_ids[] = {
>> +static const struct of_device_id dw_hdmi_imx_ids[] = {
>>   	{ .compatible = "fsl,imx6q-hdmi",
>>   	  .data = &imx6q_hdmi_drv_data
> Weren't there multiple compatible strings in imx-hdmi.c?
   imx6q , imx6dl use different compatible strings for different
configuration in original imx-hdmi.c
>
>>   	}, {
>> @@ -178,38 +178,38 @@ static const struct of_device_id imx_hdmi_imx_ids[] = {
>>   	},
>>   	{},
>>   };
>> -MODULE_DEVICE_TABLE(of, imx_hdmi_imx_dt_ids);
>> +MODULE_DEVICE_TABLE(of, dw_hdmi_imx_dt_ids);
>>   
> ...
>
>> diff --git a/include/drm/bridge/dw_hdmi.h b/include/drm/bridge/dw_hdmi.h
>> new file mode 100644
>> index 0000000..6683b63
>> --- /dev/null
>> +++ b/include/drm/bridge/dw_hdmi.h
>> @@ -0,0 +1,57 @@
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
>> +enum {
>> +	RES_8,
>> +	RES_10,
>> +	RES_12,
>> +	RES_MAX,
>> +};
>> +
>> +enum dw_hdmi_devtype {
>> +	IMX6Q_HDMI,
>> +	IMX6DL_HDMI,
>> +};
> This enum going into dw_hdmi.
> Does this mean that dw hdmi code still has some SoC specific things left?
> Where is this needed.

    yes, imx6q and imx6dl have different configuration in function
    dw_hdmi_clear_overflow, as for rk3288,  function hdmi_phy_configure
    also have different with power control of some block.
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
>> +
>> +struct dw_hdmi_plat_data {
>> +	void * (*setup)(struct platform_device *pdev);
>> +	void (*exit)(void *priv);
>> +	void (*encoder_commit)(void *priv, struct drm_encoder *encoder);
>> +	void (*encoder_prepare)(struct drm_connector *connector,
>> +				struct drm_encoder *encoder);
>> +	enum drm_mode_status (*mode_valid)(struct drm_connector *connector,
>> +					   struct drm_display_mode *mode);
>> +	const struct mpll_config *mpll_cfg;
>> +	const struct curr_ctrl *cur_ctr;
>> +	enum dw_hdmi_devtype dev_type;
>> +
>> +};
>> +
>> +int dw_hdmi_platform_register(struct platform_device *pdev,
>> +			      const struct dw_hdmi_plat_data *plat_data);
>> +int dw_hdmi_platform_unregister(struct platform_device *pdev);
>> +#endif /* __IMX_HDMI_H__ */
>>
> Regards
> ZubairLK
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>

