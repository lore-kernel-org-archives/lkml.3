Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935145AbaKNKXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:23:35 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:7632 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934166AbaKNKXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:23:34 -0500
Message-ID: <5465D816.3020708@imgtec.com>
Date: Fri, 14 Nov 2014 10:23:18 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Yan <andy.yan@rock-chips.com>, <airlied@linux.ie>, <heiko@sntech.de>,
        <fabio.estevam@freescale.com>, <rmk+kernel@arm.linux.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, <djkurtz@google.com>,
        <ykk@rock-chips.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <devel@driverdev.osuosl.org>,
        <devicetree@vger.kernel.org>, <linux-rockchip@lists.infradead.org>,
        <jay.xu@rock-chips.com>, Pawel Moll <pawel.moll@arm.com>,
        <mark.yao@rock-chips.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v10 11/11] drm: bridge/dw_hdmi: add rockchip rk3288 support
References: <1415934583-16290-1-git-send-email-andy.yan@rock-chips.com> <1415935884-17130-1-git-send-email-andy.yan@rock-chips.com>
In-Reply-To: <1415935884-17130-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy

On 14/11/14 03:31, Andy Yan wrote:
> Rockchip RK3288 hdmi is compatible with dw_hdmi
> 
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> 
> ---
> 
> Changes in v10:
> - add more display mode support mpll configuration for rk3288
> 
> Changes in v9:
> - move some phy configuration to platform driver
> 
> Changes in v8: None
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/gpu/drm/bridge/dw_hdmi.c            |  10 +
>  drivers/gpu/drm/bridge/dw_hdmi.h            |   3 +-
>  drivers/gpu/drm/rockchip/Kconfig            |  10 +
>  drivers/gpu/drm/rockchip/Makefile           |   2 +-
>  drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c | 355 ++++++++++++++++++++++++++++
>  include/drm/bridge/dw_hdmi.h                |   1 +
>  6 files changed, 379 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/gpu/drm/rockchip/dw_hdmi-rockchip.c
> 
> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
> index a2876fe..1dd1f0b 100644
> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
> @@ -715,6 +715,13 @@ static void dw_hdmi_phy_enable_tmds(struct dw_hdmi *hdmi, u8 enable)
>  			 HDMI_PHY_CONF0_ENTMDS_MASK);
>  }
>  
> +static void dw_hdmi_phy_enable_spare(struct dw_hdmi *hdmi, u8 enable)
> +{
> +	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
> +			 HDMI_PHY_CONF0_SPARECTRL_OFFSET,
> +			 HDMI_PHY_CONF0_SPARECTRL_MASK);
> +}
> +

What does enable spare do? Can other future SoCs use it?

This looks like DW specific. And can be a separate commit that adds a feature to the dw hdmi driver.

Thanks
ZubairLK

>  static void dw_hdmi_phy_gen2_pddq(struct dw_hdmi *hdmi, u8 enable)
>  {
>  	hdmi_mask_writeb(hdmi, enable, HDMI_PHY_CONF0,
> @@ -846,6 +853,9 @@ static int hdmi_phy_configure(struct dw_hdmi *hdmi, unsigned char prep,
>  	dw_hdmi_phy_gen2_txpwron(hdmi, 1);
>  	dw_hdmi_phy_gen2_pddq(hdmi, 0);
>  
> +	if (hdmi->dev_type == RK3288_HDMI)
> +		dw_hdmi_phy_enable_spare(hdmi, 1);
> +
>  	/*Wait for PHY PLL lock */
>  	msec = 5;
>  	do {
> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.h b/drivers/gpu/drm/bridge/dw_hdmi.h
> index b8412a9..30a6b28 100644
> --- a/drivers/gpu/drm/bridge/dw_hdmi.h
> +++ b/drivers/gpu/drm/bridge/dw_hdmi.h
> @@ -837,7 +837,8 @@ enum {
>  	HDMI_PHY_CONF0_PDZ_OFFSET = 7,
>  	HDMI_PHY_CONF0_ENTMDS_MASK = 0x40,
>  	HDMI_PHY_CONF0_ENTMDS_OFFSET = 6,
> -	HDMI_PHY_CONF0_SPARECTRL = 0x20,
> +	HDMI_PHY_CONF0_SPARECTRL_MASK = 0x20,
> +	HDMI_PHY_CONF0_SPARECTRL_OFFSET = 5,

Cheers,
ZubairLK

