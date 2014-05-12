Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbaELNCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 09:02:35 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58276 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755912AbaELNCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 09:02:33 -0400
Message-ID: <5370C667.6060106@free-electrons.com>
Date: Mon, 12 May 2014 15:02:31 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] drm/panel: add support for simple-panel description
 definition using DT
References: <1399645002-18000-1-git-send-email-boris.brezillon@free-electrons.com> <1399645002-18000-2-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1399645002-18000-2-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/05/2014 16:16, Boris BREZILLON wrote:
> Currently, the only way to add new panel descriptions to the simple panel
> driver is to add new entries in the platform_of_match table.
>
> Add support for panel description retrieval from the DT.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/gpu/drm/panel/Kconfig        |  1 +
>  drivers/gpu/drm/panel/panel-simple.c | 70 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 71 insertions(+)
>
> diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
> index 4ec874d..4fe3d48 100644
> --- a/drivers/gpu/drm/panel/Kconfig
> +++ b/drivers/gpu/drm/panel/Kconfig
> @@ -1,6 +1,7 @@
>  config DRM_PANEL
>  	bool
>  	depends on DRM
> +	select VIDEOMODE_HELPERS
>  	help
>  	  Panel registration and lookup framework.
>  
> diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
> index 309f29e..fcf648d 100644
> --- a/drivers/gpu/drm/panel/panel-simple.c
> +++ b/drivers/gpu/drm/panel/panel-simple.c
> @@ -33,6 +33,10 @@
>  #include <drm/drm_mipi_dsi.h>
>  #include <drm/drm_panel.h>
>  
> +#include <video/display_timing.h>
> +#include <video/of_display_timing.h>
> +#include <video/videomode.h>
> +
>  struct panel_desc {
>  	const struct drm_display_mode *modes;
>  	unsigned int num_modes;
> @@ -168,6 +172,61 @@ static const struct drm_panel_funcs panel_simple_funcs = {
>  	.get_modes = panel_simple_get_modes,
>  };
>  
> +static struct panel_desc *of_panel_desc_init(struct device *dev)
> +{
> +	struct display_timings *timings;
> +	struct panel_desc *desc;
> +	u32 width, height;
> +	int err;
> +	int i;
> +
> +	err = of_property_read_u32(dev->of_node, "width", &width);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	err = of_property_read_u32(dev->of_node, "height", &height);
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	desc = devm_kzalloc(dev, sizeof(*desc), GFP_KERNEL);
> +	if (!desc)
> +		return ERR_PTR(-ENOMEM);
> +
> +	timings = of_get_display_timings(dev->of_node);
> +	if (timings) {
> +		struct drm_display_mode *modes =
> +				devm_kzalloc(dev,
> +					     timings->num_timings *
> +					     sizeof(*desc->modes),
> +					     GFP_KERNEL);
> +
> +		if (!modes)
> +			return ERR_PTR(-ENOMEM);
> +
> +		for (i = 0; i < timings->num_timings; i++) {
> +			struct videomode vm;
> +
> +			if (videomode_from_timings(timings, &vm, i))
> +				break;
> +
> +			drm_display_mode_from_videomode(&vm, modes + i);
> +
> +			modes[i].type = DRM_MODE_TYPE_DRIVER;
> +
> +			if (timings->native_mode == i)
> +				modes[i].type |= DRM_MODE_TYPE_PREFERRED;
> +			desc->num_modes++;
> +		}

Oops, I forgot to add:
                          desc->modes = modes;

> +
> +		kfree(timings);
> +	}
> +
> +	desc->size.width = width;
> +	desc->size.height = height;
> +
> +	return desc;
> +}
> +
>  static int panel_simple_probe(struct device *dev, const struct panel_desc *desc)
>  {
>  	struct device_node *backlight, *ddc;
> @@ -178,6 +237,17 @@ static int panel_simple_probe(struct device *dev, const struct panel_desc *desc)
>  	if (!panel)
>  		return -ENOMEM;
>  
> +	if (!desc) {
> +		desc = of_panel_desc_init(dev);
> +		/*
> +		 * Do not fail on DT panel desc retrieval error because
> +		 * some systems do not need a panel description to work
> +		 * properly.
> +		 */
> +		if (IS_ERR(desc))
> +			desc = NULL;
> +	}
> +
>  	panel->enabled = false;
>  	panel->desc = desc;
>  

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

