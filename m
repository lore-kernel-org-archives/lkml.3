Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658Ab3CYWku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:40:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab3CYWkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:40:49 -0400
Date: Mon, 25 Mar 2013 15:40:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-fbdev@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: Re: [PATCH v3 3/3] backlight: as3711: add OF support
Message-Id: <20130325154046.82d9337f25cec12b9fa03625@linux-foundation.org>
In-Reply-To: <1363968949-12151-4-git-send-email-g.liakhovetski@gmx.de>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
	<1363968949-12151-4-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013 17:15:49 +0100 Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Add support for configuring AS3711 backlight driver from DT.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
> Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/video/backlight/as3711_bl.c |  118 ++++++++++++++++++++++++++++++++++-
>  1 files changed, 117 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/backlight/as3711_bl.c b/drivers/video/backlight/as3711_bl.c
> index 41d52fe..123887c 100644
> --- a/drivers/video/backlight/as3711_bl.c
> +++ b/drivers/video/backlight/as3711_bl.c
> @@ -258,6 +258,109 @@ static int as3711_bl_register(struct platform_device *pdev,
>  	return 0;
>  }
>  
> +static int as3711_backlight_parse_dt(struct device *dev)
> +{
> +	struct as3711_bl_pdata *pdata = dev_get_platdata(dev);
> +	struct device_node *bl =
> +		of_find_node_by_name(dev->parent->of_node, "backlight"), *fb;
> +	int ret;

It's tidier to do

	struct device_node *bl;
	
	bl = of_find_node_by_name(dev->parent->of_node, "backlight"), *fb;

and avoid the 80-col trickery.

> +	if (!bl) {
> +		dev_dbg(dev, "backlight node not found\n");
> +		return -ENODEV;
> +	}
> +
> +	fb = of_parse_phandle(bl, "su1-dev", 0);
> +	if (fb) {
> +		pdata->su1_fb = fb->full_name;
> +
> +		ret = of_property_read_u32(bl, "su1-max-uA", &pdata->su1_max_uA);
> +		if (pdata->su1_max_uA <= 0)
> +			ret = -EINVAL;
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	fb = of_parse_phandle(bl, "su2-dev", 0);
> +	if (fb) {
> +		int count = 0;
> +
> +		pdata->su2_fb = fb->full_name;
> +
> +		ret = of_property_read_u32(bl, "su2-max-uA", &pdata->su2_max_uA);
> +		if (pdata->su2_max_uA <= 0)
> +			ret = -EINVAL;
> +		if (ret < 0)
> +			return ret;
> +
> +		if (of_find_property(bl, "su2-feedback-voltage", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_VOLTAGE;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr1", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR1;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr2", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR2;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr3", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR3;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-feedback-curr-auto", NULL)) {
> +			pdata->su2_feedback = AS3711_SU2_CURR_AUTO;
> +			count++;
> +		}
> +		if (count != 1)
> +			return -EINVAL;

This looks odd.  If the firmware provides both su2-feedback-voltage and
su2-feedback-curr1, we fail?  Firmware developers are notoriously
flakey - can the code be more defensive here?

> +		count = 0;
> +		if (of_find_property(bl, "su2-fbprot-lx-sd4", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_LX_SD4;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-fbprot-gpio2", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_GPIO2;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-fbprot-gpio3", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_GPIO3;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-fbprot-gpio4", NULL)) {
> +			pdata->su2_fbprot = AS3711_SU2_GPIO4;
> +			count++;
> +		}
> +		if (count != 1)
> +			return -EINVAL;
> +
> +		count = 0;
> +		if (of_find_property(bl, "su2-auto-curr1", NULL)) {
> +			pdata->su2_auto_curr1 = true;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-auto-curr2", NULL)) {
> +			pdata->su2_auto_curr2 = true;
> +			count++;
> +		}
> +		if (of_find_property(bl, "su2-auto-curr3", NULL)) {
> +			pdata->su2_auto_curr3 = true;
> +			count++;
> +		}
> +
> +		/*
> +		 * At least one su2-auto-curr* must be specified iff
> +		 * AS3711_SU2_CURR_AUTO is used
> +		 */
> +		if (!count ^ (pdata->su2_feedback != AS3711_SU2_CURR_AUTO))
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>
> ...
>
