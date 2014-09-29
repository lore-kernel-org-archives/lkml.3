Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaI2RVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:21:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49178 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752602AbaI2RVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:21:04 -0400
Date: Mon, 29 Sep 2014 19:20:57 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v6 05/11] drm: add Atmel HLCDC Display Controller
 support
Message-ID: <20140929192057.1ede0346@bbrezillon>
In-Reply-To: <1412001864-3251-6-git-send-email-boris.brezillon@free-electrons.com>
References: <1412001864-3251-1-git-send-email-boris.brezillon@free-electrons.com>
	<1412001864-3251-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014 16:44:18 +0200
Boris Brezillon <boris.brezillon@free-electrons.com> wrote:

> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
> 
> The Atmel HLCDC (HLCD Controller) IP available on some Atmel SoCs (i.e.
> at91sam9n12, at91sam9x5 family or sama5d3 family) provides a display
> controller device.
> 
> This display controller supports at least one primary plane and might
> provide several overlays and an hardware cursor depending on the IP
> version.
> 
> At the moment, this driver only implements an RGB connector to interface
> with LCD panels, but support for other kind of external devices might be
> added later.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Reviewed-by: Rob Clark <robdclark@gmail.com>
> Tested-by: Anthony Harivel <anthony.harivel@emtrion.de>
> Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> ---
>  drivers/gpu/drm/Kconfig                          |   2 +
>  drivers/gpu/drm/Makefile                         |   1 +
>  drivers/gpu/drm/atmel-hlcdc/Kconfig              |  13 +
>  drivers/gpu/drm/atmel-hlcdc/Makefile             |   7 +
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c   | 392 +++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c     | 527 ++++++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h     | 216 ++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c  | 659 ++++++++++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h  | 403 +++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c | 443 ++++++++++++
>  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c  | 833 +++++++++++++++++++++++
>  11 files changed, 3496 insertions(+)
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/Kconfig
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/Makefile
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c
>  create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
> 
> diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
> index b066bb3..2d97f7e 100644
> --- a/drivers/gpu/drm/Kconfig
> +++ b/drivers/gpu/drm/Kconfig
> @@ -185,6 +185,8 @@ source "drivers/gpu/drm/cirrus/Kconfig"
>  

[...]

> +
> +int atmel_hlcdc_crtc_mode_valid(struct drm_crtc *c,
> +				struct drm_display_mode *mode)
> +{
> +	struct videomode vm;
> +
> +	vm.vfront_porch = mode->vsync_start - mode->vdisplay;
> +	vm.vback_porch = mode->vtotal - mode->vsync_end;
> +	vm.vsync_len = mode->vsync_end - mode->vsync_start;
> +	vm.hfront_porch = mode->hsync_start - mode->hdisplay;
> +	vm.hback_porch = mode->htotal - mode->hsync_end;
> +	vm.hsync_len = mode->hsync_end - mode->hsync_start;
> +
> +	if (vm.hsync_len > 0x40 || vm.hsync_len < 1)
> +		return MODE_HSYNC;
> +
> +	if (vm.vsync_len > 0x40 || vm.vsync_len < 1)
> +		return MODE_VSYNC;
> +
> +	if (vm.vfront_porch > 0x40 || vm.hfront_porch < 1 ||
> +	    vm.vback_porch > 0x40 || vm.vback_porch < 0 ||
> +	    mode->hdisplay > 2048 || mode->hdisplay < 1)
> +		return MODE_H_ILLEGAL;
> +
> +	if (vm.hfront_porch > 0x200 || vm.hfront_porch < 1 ||
> +	    vm.hback_porch > 0x200 || vm.hback_porch < 1 ||
> +	    mode->hdisplay > 2048 || mode->hdisplay < 1)
> +		return MODE_V_ILLEGAL;
> +
> +	return MODE_OK;
> +}
> +

I forgot to squash the commit removing this function which a vestige
from one of my attempt to provide a common mode_valid function that can
be called from the connector mode_valid function.

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
