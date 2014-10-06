Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaJFSlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:41:13 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:39891 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaJFSlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:41:11 -0400
Date: Mon, 6 Oct 2014 14:41:03 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] thermal: ti-soc-thermal: Switch to using managed
 resources
Message-ID: <20141006184101.GB5524@developer>
References: <1411149909-13007-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411149909-13007-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pramod,

On Fri, Sep 19, 2014 at 11:35:09PM +0530, Pramod Gurav wrote:
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

How the manager is supposed to handle  and free the clocks' resources if
no dev is passed to devm_ functions?

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
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
