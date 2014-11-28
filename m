Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaK1WNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:13:23 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:56584 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaK1WNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:13:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/3] drm: add bus_formats and nbus_formats fields to drm_display_info
Date: Sat, 29 Nov 2014 00:13:47 +0200
Message-ID: <56712774.y8GaD3rGMh@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1416318380-20122-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1416318380-20122-1-git-send-email-boris.brezillon@free-electrons.com> <1416318380-20122-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Thank you for the patch. I just have two small comments.

On Tuesday 18 November 2014 14:46:18 Boris Brezillon wrote:
> Add bus_formats and nbus_formats fields and
> drm_display_info_set_bus_formats helper function to specify the bus
> formats supported by a given display.
> 
> This information can be used by display controller drivers to configure
> the output interface appropriately (i.e. RGB565, RGB666 or RGB888 on raw
> RGB or LVDS busses).
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  drivers/gpu/drm/drm_crtc.c | 30 ++++++++++++++++++++++++++++++
>  include/drm/drm_crtc.h     |  7 +++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
> index e79c8d3..17e3acf 100644
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -763,6 +763,36 @@ static void drm_mode_remove(struct drm_connector
> *connector, drm_mode_destroy(connector->dev, mode);
>  }
> 
> +/*
> + * drm_display_info_set_bus_formats - set the supported bus formats
> + * @info: display info to store bus formats in
> + * @fmts: array containing the supported bus formats
> + * @nfmts: the number of entries in the fmts array
> + *
> + * Store the suppported bus formats in display info structure.

Could you document that the formats are specified as MEDIA_BUS_FMT_* values ?

> + */
> +int drm_display_info_set_bus_formats(struct drm_display_info *info, const
> u32 *fmts, +				     unsigned int num_fmts)
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
> index c40070a..2e0a3e8 100644
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
> +	int num_bus_formats;

As the number of formats is never negative, I would make it an unsigned int.

> +
>  	/* Mask of supported hdmi deep color modes */
>  	u8 edid_hdmi_dc_modes;
> 
> @@ -982,6 +986,9 @@ extern int drm_mode_connector_set_path_property(struct
> drm_connector *connector, extern int
> drm_mode_connector_update_edid_property(struct drm_connector *connector,
> struct edid *edid);
> 
> +extern int drm_display_info_set_bus_formats(struct drm_display_info *info,
> +					    const u32 *fmts, unsigned int nfmts);
> +
>  static inline bool drm_property_type_is(struct drm_property *property,
>  		uint32_t type)
>  {

-- 
Regards,

Laurent Pinchart

