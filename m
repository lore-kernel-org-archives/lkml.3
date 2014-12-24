Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaLXNXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 08:23:12 -0500
Received: from ns.lynxeye.de ([87.118.118.114]:50811 "EHLO lynxeye.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751641AbaLXNXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 08:23:09 -0500
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Dec 2014 08:23:09 EST
Message-ID: <1419427385.2179.13.camel@lynxeye.de>
Subject: Re: [PATCH nouveau 06/11] platform: complete the power up/down
 sequence
From: Lucas Stach <dev@lynxeye.de>
To: Vince Hsu <vinceh@nvidia.com>
Cc: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 24 Dec 2014 14:23:05 +0100
In-Reply-To: <1419331204-26679-7-git-send-email-vinceh@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
	 <1419331204-26679-7-git-send-email-vinceh@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.8 (3.12.8-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
> This patch adds some missing pieces of the rail gaing/ungating sequence that
> can improve the stability in theory.
> 
> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> ---
>  drm/nouveau_platform.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  drm/nouveau_platform.h |  3 +++
>  2 files changed, 45 insertions(+)
> 
> diff --git a/drm/nouveau_platform.c b/drm/nouveau_platform.c
> index 68788b17a45c..527fe2358fc9 100644
> --- a/drm/nouveau_platform.c
> +++ b/drm/nouveau_platform.c
> @@ -25,9 +25,11 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/of.h>
> +#include <linux/of_platform.h>
>  #include <linux/reset.h>
>  #include <linux/regulator/consumer.h>
>  #include <soc/tegra/fuse.h>
> +#include <soc/tegra/mc.h>
>  #include <soc/tegra/pmc.h>
>  
>  #include "nouveau_drm.h"
> @@ -61,6 +63,9 @@ static int nouveau_platform_power_up(struct nouveau_platform_gpu *gpu)
>  	reset_control_deassert(gpu->rst);
>  	udelay(10);
>  
> +	tegra_mc_flush(gpu->mc, gpu->swgroup, false);
> +	udelay(10);
> +
>  	return 0;
>  
>  err_clamp:
> @@ -77,6 +82,14 @@ static int nouveau_platform_power_down(struct nouveau_platform_gpu *gpu)
>  {
>  	int err;
>  
> +	tegra_mc_flush(gpu->mc, gpu->swgroup, true);
> +	udelay(10);
> +
> +	err = tegra_powergate_gpu_set_clamping(true);
> +	if (err)
> +		return err;
> +	udelay(10);
> +
>  	reset_control_assert(gpu->rst);
>  	udelay(10);
>  
> @@ -91,6 +104,31 @@ static int nouveau_platform_power_down(struct nouveau_platform_gpu *gpu)
>  	return 0;
>  }
>  
> +static int nouveau_platform_get_mc(struct device *dev,
> +		struct tegra_mc **mc, unsigned int *swgroup)

Uhm, no. If this is needed this has to be a Tegra MC function and not
burried into nouveau code. You are using knowledge about the internal
workings of the MC driver here.

Also this should probably only take the Dt node pointer as argument and
return a something like a tegra_mc_client struct that contains both the
MC device pointer and the swgroup so you can pass that to
tegra_mc_flush().

> +{
> +	struct of_phandle_args args;
> +	struct platform_device *pdev;
> +	int ret;
> +
> +	ret = of_parse_phandle_with_fixed_args(dev->of_node, "mc",
> +				1, 0, &args);
> +	if (ret)
> +		return ret;
> +
> +	pdev = of_find_device_by_node(args.np);
> +	if (!pdev)
> +		return -EINVAL;

This is wrong, you need to handle -EPROBE_DEFER here.

> +
> +	*mc = platform_get_drvdata(pdev);
> +	if (!*mc)
> +		return -EINVAL;
> +
> +	*swgroup = args.args[0];
> +
> +	return 0;
> +}
> +
>  static int nouveau_platform_probe(struct platform_device *pdev)
>  {
>  	struct nouveau_platform_gpu *gpu;
> @@ -118,6 +156,10 @@ static int nouveau_platform_probe(struct platform_device *pdev)
>  	if (IS_ERR(gpu->clk_pwr))
>  		return PTR_ERR(gpu->clk_pwr);
>  
> +	err = nouveau_platform_get_mc(&pdev->dev, &gpu->mc, &gpu->swgroup);
> +	if (err)
> +		return err;
> +
>  	err = nouveau_platform_power_up(gpu);
>  	if (err)
>  		return err;
> diff --git a/drm/nouveau_platform.h b/drm/nouveau_platform.h
> index 58c28b5653d5..969dbddd786d 100644
> --- a/drm/nouveau_platform.h
> +++ b/drm/nouveau_platform.h
> @@ -35,6 +35,9 @@ struct nouveau_platform_gpu {
>  	struct clk *clk_pwr;
>  
>  	struct regulator *vdd;
> +
> +	struct tegra_mc *mc;
> +	unsigned int swgroup;
>  };
>  
>  struct nouveau_platform_device {


