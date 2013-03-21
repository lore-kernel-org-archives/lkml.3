Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3CUXlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 19:41:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59468 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab3CUXlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 19:41:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>, rui.zhang@intel.com
Cc: andrew@lunn.ch, jason@lakedaemon.net, rob.lee@linaro.org,
        len.brown@intel.com, khilman@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kirkwood: fix coccicheck warnings
Date: Fri, 22 Mar 2013 00:48:25 +0100
Message-ID: <1773787.ohbjPLoSz4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1362987319-6369-1-git-send-email-silviupopescu1990@gmail.com>
References: <1362987319-6369-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 11, 2013 09:35:19 AM Silviu-Mihai Popescu wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

If I'm supposed to take these changes, please split them into separate patches
for cpufreq, cpuidle and thermal (which would be for Rui BTW).

Thanks,
Rafael


> ---
>  drivers/cpufreq/kirkwood-cpufreq.c |    8 +++-----
>  drivers/cpuidle/cpuidle-kirkwood.c |    6 +++---
>  drivers/thermal/kirkwood_thermal.c |    8 +++-----
>  3 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
> index 0e83e3c..6052476 100644
> --- a/drivers/cpufreq/kirkwood-cpufreq.c
> +++ b/drivers/cpufreq/kirkwood-cpufreq.c
> @@ -175,11 +175,9 @@ static int kirkwood_cpufreq_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "Cannot get memory resource\n");
>  		return -ENODEV;
>  	}
> -	priv.base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!priv.base) {
> -		dev_err(&pdev->dev, "Cannot ioremap\n");
> -		return -EADDRNOTAVAIL;
> -	}
> +	priv.base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv.base))
> +		return PTR_ERR(priv.base);
>  
>  	np = of_find_node_by_path("/cpus/cpu@0");
>  	if (!np)
> diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
> index 670aa1e..53aad73 100644
> --- a/drivers/cpuidle/cpuidle-kirkwood.c
> +++ b/drivers/cpuidle/cpuidle-kirkwood.c
> @@ -66,9 +66,9 @@ static int kirkwood_cpuidle_probe(struct platform_device *pdev)
>  	if (res == NULL)
>  		return -EINVAL;
>  
> -	ddr_operation_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!ddr_operation_base)
> -		return -EADDRNOTAVAIL;
> +	ddr_operation_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(ddr_operation_base))
> +		return PTR_ERR(ddr_operation_base);
>  
>  	device = &per_cpu(kirkwood_cpuidle_device, smp_processor_id());
>  	device->state_count = KIRKWOOD_MAX_STATES;
> diff --git a/drivers/thermal/kirkwood_thermal.c b/drivers/thermal/kirkwood_thermal.c
> index 65cb4f0..e5500ed 100644
> --- a/drivers/thermal/kirkwood_thermal.c
> +++ b/drivers/thermal/kirkwood_thermal.c
> @@ -85,11 +85,9 @@ static int kirkwood_thermal_probe(struct platform_device *pdev)
>  	if (!priv)
>  		return -ENOMEM;
>  
> -	priv->sensor = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!priv->sensor) {
> -		dev_err(&pdev->dev, "Failed to request_ioremap memory\n");
> -		return -EADDRNOTAVAIL;
> -	}
> +	priv->sensor = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->sensor))
> +		return PTR_ERR(priv->sensor);
>  
>  	thermal = thermal_zone_device_register("kirkwood_thermal", 0, 0,
>  					       priv, &ops, NULL, 0, 0);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
