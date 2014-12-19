Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaLSLHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 06:07:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36410 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSLHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 06:07:11 -0500
Message-ID: <1418987224.3165.66.camel@pengutronix.de>
Subject: Re: [PATCH v2 1/7] gpu: ipu-di: Add ipu_di_adjust_videomode()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>, Deepak Das <deepak_das@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 19 Dec 2014 12:07:04 +0100
In-Reply-To: <1418954426-21909-2-git-send-email-steve_longerbeam@mentor.com>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
	 <1418954426-21909-2-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

Am Donnerstag, den 18.12.2014, 18:00 -0800 schrieb Steve Longerbeam:
> From: Jiada Wang <jiada_wang@mentor.com>
> 
> On some monitors, high resolution modes are not working, exhibiting
> pixel column truncation problems (for example, 1280x1024 displays as
> 1280x1022).
> 
> The function ipu_di_adjust_videomode() aims to fix these issues by
> adjusting a passed videomode to IPU restrictions. The function can
> be called from the drm_crtc_helper_funcs->mode_fixup() methods.
> 
> Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
> Signed-off-by: Deepak Das <deepak_das@mentor.com>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/gpu/ipu-v3/ipu-di.c |   29 +++++++++++++++++++++++++++++
>  include/video/imx-ipu-v3.h  |    2 ++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/drivers/gpu/ipu-v3/ipu-di.c b/drivers/gpu/ipu-v3/ipu-di.c
> index c490ba4..46f9570 100644
> --- a/drivers/gpu/ipu-v3/ipu-di.c
> +++ b/drivers/gpu/ipu-v3/ipu-di.c
> @@ -511,6 +511,35 @@ static void ipu_di_config_clock(struct ipu_di *di,
>  		clk_get_rate(di->clk_di_pixel) / (clkgen0 >> 4));
>  }
>  
> +/*
> + * This function is called to adjust a video mode to IPU restrictions.
> + * It is meant to be called from drm crtc mode_fixup() methods.
> + */
> +int ipu_di_adjust_videomode(struct ipu_di *di, struct videomode *mode)
> +{
> +	u32 diff;
> +
> +	if (mode->vfront_porch >= 2)
> +		return 0;
> +
> +	diff = 2 - mode->vfront_porch;
> +
> +	if (mode->vback_porch >= diff) {
> +		mode->vfront_porch = 2;
> +		mode->vback_porch -= diff;

Should we also add

	else if (mode->vback_porch >= 1 && mode->vsync_len > 1) {
		mode->vback_porch--;
		mode->vsync_len--;

here and maybe move the two "mode->vback_porch = 2" to a single place
below the conditional statement?

> +	} else if (mode->vsync_len > diff) {
> +		mode->vfront_porch = 2;
> +		mode->vsync_len = mode->vsync_len - diff;

Why use "vback_porch -= diff" above, but not "vsync_len -= diff" here?

> +	} else {
> +		dev_warn(di->ipu->dev, "failed to adjust videomode\n");
> +		return -EINVAL;
> +	}
> +
> +	dev_warn(di->ipu->dev, "videomode adapted for IPU restrictions\n");

Since we can return the adjusted mode to userspace now, I think this
should be dev_dbg.

regards
Philipp

