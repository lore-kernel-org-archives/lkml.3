Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaLAPGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:06:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54825 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaLAPGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:06:35 -0500
Message-ID: <1417446386.4624.17.camel@pengutronix.de>
Subject: Re: [PATCH v4 1/3] drm: add bus_formats and num_bus_formats fields
 to drm_display_info
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>
Date: Mon, 01 Dec 2014 16:06:26 +0100
In-Reply-To: <1417422061-10384-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1417422061-10384-1-git-send-email-boris.brezillon@free-electrons.com>
	 <1417422061-10384-2-git-send-email-boris.brezillon@free-electrons.com>
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

Am Montag, den 01.12.2014, 09:20 +0100 schrieb Boris Brezillon:
> Add bus_formats and num_bus_formats fields and
> drm_display_info_set_bus_formats helper function to specify the bus
> formats supported by a given display.
> 
> This information can be used by display controller drivers to configure
> the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
> RGB or LVDS busses).
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  drivers/gpu/drm/drm_crtc.c | 32 ++++++++++++++++++++++++++++++++
>  include/drm/drm_crtc.h     |  7 +++++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index e79c8d3..d3b7ed0 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -763,6 +763,38 @@ static void drm_mode_remove(struct drm_connector *connector,
>  	drm_mode_destroy(connector->dev, mode);
>  }
>  
> +/*
> + * drm_display_info_set_bus_formats - set the supported bus formats
> + * @info: display info to store bus formats in
> + * @fmts: array containing the supported bus formats
> + * @nfmts: the number of entries in the fmts array
> + *
> + * Store the suppported bus formats in display info structure.
> + * See MEDIA_BUS_FMT_* definitions in include/uapi/linux/media-bus-format.h for
> + * a full list of available formats.
> + */
> +int drm_display_info_set_bus_formats(struct drm_display_info *info, const u32 *fmts,
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
> index c40070a..a35844f 100644
> --- a/include/drm/drm_crtc.h
> +++ b/include/drm/drm_crtc.h
> @@ -31,6 +31,7 @@
>  #include <linux/idr.h>
>  #include <linux/fb.h>
>  #include <linux/hdmi.h>
> +#include <linux/media-bus-format.h>

Nothing in drm_crtc.h uses MEDIA_BUS_FMT_*, is media-bus-format.h
included here for the convenience of the user of
drm_display_info_set_bus_formats?

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
> @@ -982,6 +986,9 @@ extern int drm_mode_connector_set_path_property(struct drm_connector *connector,
>  extern int drm_mode_connector_update_edid_property(struct drm_connector *connector,
>  						struct edid *edid);
>  
> +extern int drm_display_info_set_bus_formats(struct drm_display_info *info,
> +					    const u32 *fmts, unsigned int nfmts);
> +
>  static inline bool drm_property_type_is(struct drm_property *property,
>  		uint32_t type)
>  {

regards
Philipp

