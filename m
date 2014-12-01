Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaLAPSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:18:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39625 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbaLAPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:18:42 -0500
Message-ID: <1417447114.4624.20.camel@pengutronix.de>
Subject: Re: [PATCH RESEND v4 1/3] drm: add bus_formats and num_bus_formats
 fields to drm_display_info
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>
Date: Mon, 01 Dec 2014 16:18:34 +0100
In-Reply-To: <1417423335-11408-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
	 <1417423335-11408-1-git-send-email-boris.brezillon@free-electrons.com>
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

Am Montag, den 01.12.2014, 09:42 +0100 schrieb Boris Brezillon:
> Add bus_formats and num_bus_formats fields and
> drm_display_info_set_bus_formats helper function to specify the bus
> formats supported by a given display.
> 
> This information can be used by display controller drivers to configure
> the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
> RGB or LVDS busses).
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

> ---
> Hi,
> 
> Sorry for the noise: I ran checkpatch after sending the series and it found
> a typo and two "line over 80 characters" warnings.
> 
> This version fixes those warnings.
> 
> Regards,
> 
> Boris
> 
>  drivers/gpu/drm/drm_crtc.c | 33 +++++++++++++++++++++++++++++++++
>  include/drm/drm_crtc.h     |  8 ++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index e79c8d3..20030ec 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -763,6 +763,39 @@ static void drm_mode_remove(struct drm_connector *connector,
>  	drm_mode_destroy(connector->dev, mode);
>  }
>  
> +/*
> + * drm_display_info_set_bus_formats - set the supported bus formats
> + * @info: display info to store bus formats in
> + * @fmts: array containing the supported bus formats
> + * @nfmts: the number of entries in the fmts array
> + *
> + * Store the supported bus formats in display info structure.
> + * See MEDIA_BUS_FMT_* definitions in include/uapi/linux/media-bus-format.h for
> + * a full list of available formats.
> + */
> +int drm_display_info_set_bus_formats(struct drm_display_info *info,
> +				     const u32 *fmts,
> +				     unsigned int num_fmts)
> +{
> +	u32 *formats = NULL;
> +
> +	if (!fmts && num_fmts)
> +		return -EINVAL;
> +
> +	if (fmts && num_fmts) {
> +		formats = kmemdup(fmts, sizeof(*fmts) * num_fmts, GFP_KERNEL);
> +		if (!formats)
> +			return -ENOMEM;
> +	}
> +
> +	kfree(info->bus_formats);
> +	info->bus_formats = formats;
> +	info->num_bus_formats = num_fmts;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(drm_display_info_set_bus_formats);
> +
>  /**
>   * drm_connector_get_cmdline_mode - reads the user's cmdline mode
>   * @connector: connector to quwery
> diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
> index c40070a..65dd08a 100644
> --- a/include/drm/drm_crtc.h
> +++ b/include/drm/drm_crtc.h
> @@ -31,6 +31,7 @@
>  #include <linux/idr.h>
>  #include <linux/fb.h>
>  #include <linux/hdmi.h>
> +#include <linux/media-bus-format.h>
>  #include <uapi/drm/drm_mode.h>
>  #include <uapi/drm/drm_fourcc.h>
>  #include <drm/drm_modeset_lock.h>
> @@ -130,6 +131,9 @@ struct drm_display_info {
>  	enum subpixel_order subpixel_order;
>  	u32 color_formats;
>  
> +	const u32 *bus_formats;
> +	unsigned int num_bus_formats;
> +
>  	/* Mask of supported hdmi deep color modes */
>  	u8 edid_hdmi_dc_modes;
>  
> @@ -982,6 +986,10 @@ extern int drm_mode_connector_set_path_property(struct drm_connector *connector,
>  extern int drm_mode_connector_update_edid_property(struct drm_connector *connector,
>  						struct edid *edid);
>  
> +extern int drm_display_info_set_bus_formats(struct drm_display_info *info,
> +					    const u32 *fmts,
> +					    unsigned int nfmts);
> +
>  static inline bool drm_property_type_is(struct drm_property *property,
>  		uint32_t type)
>  {


