Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaKZQXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:23:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33537 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbaKZQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:23:37 -0500
Message-ID: <1417018985.3177.8.camel@pengutronix.de>
Subject: Re: [PATCH v13 08/12] drm: bridge/dw_hdmi: add mode_valid support
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
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Date: Wed, 26 Nov 2014 17:23:05 +0100
In-Reply-To: <1417008811-32308-1-git-send-email-andy.yan@rock-chips.com>
References: <1417008157-31861-1-git-send-email-andy.yan@rock-chips.com>
	 <1417008811-32308-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 26.11.2014, 21:33 +0800 schrieb Andy Yan:
> some platform may not support all the display mode,
> add mode_valid interface check it
> 
> also add drm_connector_register which add a debugfs
> interface for dump display modes and edid information
> 
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> ---
> 
> Changes in v13: None
> Changes in v12: None
> Changes in v11: None
> Changes in v10: None
> Changes in v9: None
> Changes in v8: None
> Changes in v7: None
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> 
>  drivers/gpu/drm/bridge/dw_hdmi.c | 17 +++++++++++++++++
>  include/drm/bridge/dw_hdmi.h     |  2 ++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/gpu/drm/bridge/dw_hdmi.c b/drivers/gpu/drm/bridge/dw_hdmi.c
> index 5e88c8d..b13e782 100644
> --- a/drivers/gpu/drm/bridge/dw_hdmi.c
> +++ b/drivers/gpu/drm/bridge/dw_hdmi.c
> @@ -1406,6 +1406,20 @@ static int dw_hdmi_connector_get_modes(struct drm_connector *connector)
>  	return 0;
>  }
>  
> +static enum drm_mode_status
> +dw_hdmi_connector_mode_valid(struct drm_connector *connector,
> +			     struct drm_display_mode *mode)
> +{
> +	struct dw_hdmi *hdmi = container_of(connector,
> +					   struct dw_hdmi, connector);
> +	enum drm_mode_status mode_status = MODE_OK;
> +
> +	if (hdmi->plat_data->mode_valid)
> +		mode_status = hdmi->plat_data->mode_valid(connector, mode);
> +
> +	return mode_status;
> +}
> +
>  static struct drm_encoder *dw_hdmi_connector_best_encoder(struct drm_connector
>  							   *connector)
>  {
> @@ -1430,6 +1444,7 @@ static struct drm_connector_funcs dw_hdmi_connector_funcs = {
>  
>  static struct drm_connector_helper_funcs dw_hdmi_connector_helper_funcs = {
>  	.get_modes = dw_hdmi_connector_get_modes,
> +	.mode_valid = dw_hdmi_connector_mode_valid,
>  	.best_encoder = dw_hdmi_connector_best_encoder,
>  };
>  
> @@ -1631,6 +1646,8 @@ int dw_hdmi_bind(struct device *dev, struct device *master,
>  
>  	dev_set_drvdata(dev, hdmi);
>  
> +	drm_connector_register(&hdmi->connector);
> +

This is not right, the connector is registered by the imx-drm core in
the drm_driver .load callback.

regards
Philipp

