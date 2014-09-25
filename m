Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaIYHdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:33:42 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:34040 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbaIYHdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:33:41 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <5423C62B.1030709@smartplayin.com>
Date: Thu, 25 Sep 2014 13:07:15 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: edubezval@gmail.com
CC: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] thermal: ti-soc-thermal: Switch to using managed resources
References: <1411149909-13007-1-git-send-email-pramod.gurav@smartplayin.com>
In-Reply-To: <1411149909-13007-1-git-send-email-pramod.gurav@smartplayin.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Valentin

On Friday 19 September 2014 11:35 PM, Pramod Gurav wrote:
> This change switches to managed resource APIs to allocated resources
> such as irq, clock. Hence does away with release statements of the
> same resorces in error lables and remove function.
> 
> Cc: Eduardo Valentin <eduardo.valentin@ti.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c | 46 ++++++++---------------------
>  1 file changed, 12 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> index 634b6ce..e068dd5 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -1060,7 +1060,7 @@ static int ti_bandgap_tshut_init(struct ti_bandgap *bgp,
>  	int status;
>  
>  	/* Request for gpio_86 line */
> -	status = gpio_request(gpio_nr, "tshut");
> +	status = devm_gpio_request(&pdev->dev, gpio_nr, "tshut");
>  	if (status < 0) {
>  		dev_err(bgp->dev, "Could not request for TSHUT GPIO:%i\n", 86);
>  		return status;
> @@ -1071,11 +1071,12 @@ static int ti_bandgap_tshut_init(struct ti_bandgap *bgp,
>  		return status;
>  	}
>  
> -	status = request_irq(gpio_to_irq(gpio_nr), ti_bandgap_tshut_irq_handler,
> -			     IRQF_TRIGGER_RISING, "tshut", NULL);
> +	status = devm_request_irq(&pdev->dev, gpio_to_irq(gpio_nr),
> +				  ti_bandgap_tshut_irq_handler,
> +				  IRQF_TRIGGER_RISING, "tshut", NULL);
>  	if (status) {
> -		gpio_free(gpio_nr);
>  		dev_err(bgp->dev, "request irq failed for TSHUT");
> +		return status;
>  	}
>  
>  	return 0;
> @@ -1104,7 +1105,7 @@ static int ti_bandgap_talert_init(struct ti_bandgap *bgp,
>  		dev_err(&pdev->dev, "get_irq failed\n");
>  		return bgp->irq;
>  	}
> -	ret = request_threaded_irq(bgp->irq, NULL,
> +	ret = devm_request_threaded_irq(&pdev->dev, bgp->irq, NULL,
>  				   ti_bandgap_talert_irq_handler,
>  				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
>  				   "talert", bgp);
> @@ -1212,21 +1213,17 @@ int ti_bandgap_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> -	bgp->fclock = clk_get(NULL, bgp->conf->fclock_name);
> -	ret = IS_ERR(bgp->fclock);
> -	if (ret) {
> +	bgp->fclock = devm_clk_get(NULL, bgp->conf->fclock_name);
> +	if (IS_ERR(bgp->fclock)) {
>  		dev_err(&pdev->dev, "failed to request fclock reference\n");
> -		ret = PTR_ERR(bgp->fclock);
> -		goto free_irqs;
> +		return PTR_ERR(bgp->fclock);
>  	}
>  
> -	bgp->div_clk = clk_get(NULL,  bgp->conf->div_ck_name);
> -	ret = IS_ERR(bgp->div_clk);
> -	if (ret) {
> +	bgp->div_clk = devm_clk_get(NULL,  bgp->conf->div_ck_name);
> +	if (IS_ERR(bgp->div_clk)) {
>  		dev_err(&pdev->dev,
>  			"failed to request div_ts_ck clock ref\n");
> -		ret = PTR_ERR(bgp->div_clk);
> -		goto free_irqs;
> +		return PTR_ERR(bgp->div_clk);
>  	}
>  
>  	for (i = 0; i < bgp->conf->sensor_count; i++) {
> @@ -1251,7 +1248,6 @@ int ti_bandgap_probe(struct platform_device *pdev)
>  	    clk_rate <= 0) {
>  		ret = -ENODEV;
>  		dev_err(&pdev->dev, "wrong clock rate (%d)\n", clk_rate);
> -		goto put_clks;
>  	}
>  
>  	ret = clk_set_rate(bgp->div_clk, clk_rate);
> @@ -1357,14 +1353,6 @@ remove_sensors:
>  disable_clk:
>  	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
>  		clk_disable_unprepare(bgp->fclock);
> -put_clks:
> -	clk_put(bgp->fclock);
> -	clk_put(bgp->div_clk);
> -free_irqs:
> -	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
> -		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
> -		gpio_free(bgp->tshut_gpio);
> -	}
>  
>  	return ret;
>  }
> @@ -1388,16 +1376,6 @@ int ti_bandgap_remove(struct platform_device *pdev)
>  
>  	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
>  		clk_disable_unprepare(bgp->fclock);
> -	clk_put(bgp->fclock);
> -	clk_put(bgp->div_clk);
> -
> -	if (TI_BANDGAP_HAS(bgp, TALERT))
> -		free_irq(bgp->irq, bgp);
> -
> -	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
> -		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
> -		gpio_free(bgp->tshut_gpio);
> -	}
>  
>  	return 0;
>  }
> 
