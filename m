Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaKGLpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:45:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40677 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaKGLps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:45:48 -0500
Message-ID: <1415360707.2776.1.camel@pengutronix.de>
Subject: Re: [PATCH V4 5/6] dw-hdmi: add support for multi byte register
 width access
From: Lucas Stach <l.stach@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com
Date: Fri, 07 Nov 2014 12:45:07 +0100
In-Reply-To: <1415360125-8655-1-git-send-email-andy.yan@rock-chips.com>
References: <1415360068-8606-1-git-send-email-andy.yan@rock-chips.com>
	 <1415360125-8655-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 07.11.2014, 19:35 +0800 schrieb Andy Yan:
> On rockchip rk3288, only word(32-bit) accesses are
> permitted for hdmi registers.  Byte width access (writeb,
> readb) generates an imprecise external abort.
> 
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> ---
>  drivers/gpu/drm/bridge/dw_hdmi.c | 49 +++++++++++++++++++++++++++++++++++++---
>  1 file changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
> index df76a8c..9867642 100644
> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
> @@ -126,19 +126,42 @@ struct dw_hdmi {
[...]
> +	u32 val;
> +
> +	if (!of_property_read_u32(np, "reg-io-width", &val)) {
> +		switch (val) {
> +		case 4:
> +			hdmi->write = dw_hdmi_writel;
> +			hdmi->read = dw_hdmi_readl;
> +			hdmi->reg_shift = 2;
> +			break;
> +		default:
> +			hdmi->write = dw_hdmi_writeb;
> +			hdmi->read = dw_hdmi_readb;
> +			hdmi->reg_shift = 0;
> +			break;
> +		}
> +	} else {
> +		hdmi->write = dw_hdmi_writeb;
> +		hdmi->read = dw_hdmi_readb;
> +		hdmi->reg_shift = 0;
> +	}
>  
>  	ddc_node = of_parse_phandle(np, "ddc-i2c-bus", 0);
>  	if (ddc_node) {

This should throw an error if the property value in devicetree is not
recognized. This could be simplified like this:

	u32 val = 1;

	// this won't touch val if it can't find the property
	of_property_read_u32(np, "reg-io-width", &val) 


	switch (val) {
	case 4:
		hdmi->write = dw_hdmi_writel;
		hdmi->read = dw_hdmi_readl;
		hdmi->reg_shift = 2;
		break;
	case 1:
		hdmi->write = dw_hdmi_writeb;
		hdmi->read = dw_hdmi_readb;
		hdmi->reg_shift = 0;
		break;
	default:
		dev_err(dev, "unrecognized value for reg-io-width");
		// error handling
	}

Also the DT binding doc for this property is missing.

Regards,
Lucas
-- 
Pengutronix e.K.             | Lucas Stach                 |
Industrial Linux Solutions   | http://www.pengutronix.de/  |

