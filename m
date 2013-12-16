Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3LQBv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 20:51:26 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48009 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab3LQBvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 20:51:17 -0500
Date: Mon, 16 Dec 2013 07:37:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 6/7] Input: pmic8xxx-keypad - Migrate to devm_* APIs
Message-ID: <20131216153726.GB8884@core.coreip.homeip.net>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
 <1386718996-3733-7-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386718996-3733-7-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:43:15PM -0800, Stephen Boyd wrote:
> Simplify the error paths and reduce the lines of code in this
> driver by using the devm_* APIs.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/input/keyboard/pmic8xxx-keypad.c | 62 +++++++++-----------------------
>  1 file changed, 17 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/input/keyboard/pmic8xxx-keypad.c b/drivers/input/keyboard/pmic8xxx-keypad.c
> index 2c9f19a..4e6bfbf 100644
> --- a/drivers/input/keyboard/pmic8xxx-keypad.c
> +++ b/drivers/input/keyboard/pmic8xxx-keypad.c
> @@ -586,7 +586,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	kp = kzalloc(sizeof(*kp), GFP_KERNEL);
> +	kp = devm_kzalloc(&pdev->dev, sizeof(*kp), GFP_KERNEL);
>  	if (!kp)
>  		return -ENOMEM;
>  
> @@ -595,32 +595,27 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>  	kp->pdata	= pdata;
>  	kp->dev		= &pdev->dev;
>  
> -	kp->input = input_allocate_device();
> +	kp->input = devm_input_allocate_device(&pdev->dev);
>  	if (!kp->input) {
>  		dev_err(&pdev->dev, "unable to allocate input device\n");
> -		rc = -ENOMEM;
> -		goto err_alloc_device;
> +		return -ENOMEM;
>  	}
>  
>  	kp->key_sense_irq = platform_get_irq(pdev, 0);
>  	if (kp->key_sense_irq < 0) {
>  		dev_err(&pdev->dev, "unable to get keypad sense irq\n");
> -		rc = -ENXIO;
> -		goto err_get_irq;
> +		return kp->key_sense_irq;
>  	}
>  
>  	kp->key_stuck_irq = platform_get_irq(pdev, 1);
>  	if (kp->key_stuck_irq < 0) {
>  		dev_err(&pdev->dev, "unable to get keypad stuck irq\n");
> -		rc = -ENXIO;
> -		goto err_get_irq;
> +		return kp->key_stuck_irq;
>  	}
>  
>  	kp->input->name = pdata->input_name ? : "PMIC8XXX keypad";
>  	kp->input->phys = pdata->input_phys_device ? : "pmic8xxx_keypad/input0";
>  
> -	kp->input->dev.parent	= &pdev->dev;
> -
>  	kp->input->id.bustype	= BUS_I2C;
>  	kp->input->id.version	= 0x0001;
>  	kp->input->id.product	= 0x0001;
> @@ -634,7 +629,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>  					kp->keycodes, kp->input);
>  	if (rc) {
>  		dev_err(&pdev->dev, "failed to build keymap\n");
> -		goto err_get_irq;
> +		return rc;
>  	}
>  
>  	if (pdata->rep)
> @@ -650,7 +645,7 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>  	rc = pmic8xxx_kpd_init(kp);
>  	if (rc < 0) {
>  		dev_err(&pdev->dev, "unable to initialize keypad controller\n");
> -		goto err_get_irq;
> +		return rc;
>  	}
>  
>  	rc = pmic8xxx_kp_config_gpio(pdata->cols_gpio_start,
> @@ -667,24 +662,26 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>  		goto err_gpio_config;
>  	}
>  
> -	rc = request_any_context_irq(kp->key_sense_irq, pmic8xxx_kp_irq,
> -				 IRQF_TRIGGER_RISING, "pmic-keypad", kp);
> +	rc = devm_request_any_context_irq(&pdev->dev, kp->key_sense_irq,
> +			pmic8xxx_kp_irq, IRQF_TRIGGER_RISING, "pmic-keypad",
> +			kp);
>  	if (rc < 0) {
>  		dev_err(&pdev->dev, "failed to request keypad sense irq\n");
> -		goto err_get_irq;
> +		return rc;
>  	}
>  
> -	rc = request_any_context_irq(kp->key_stuck_irq, pmic8xxx_kp_stuck_irq,
> -				 IRQF_TRIGGER_RISING, "pmic-keypad-stuck", kp);
> +	rc = devm_request_any_context_irq(&pdev->dev, kp->key_stuck_irq,
> +			pmic8xxx_kp_stuck_irq, IRQF_TRIGGER_RISING,
> +			"pmic-keypad-stuck", kp);
>  	if (rc < 0) {
>  		dev_err(&pdev->dev, "failed to request keypad stuck irq\n");
> -		goto err_req_stuck_irq;
> +		return rc;
>  	}
>  
>  	rc = pmic8xxx_kp_read_u8(kp, &ctrl_val, KEYP_CTRL);
>  	if (rc < 0) {
>  		dev_err(&pdev->dev, "failed to read KEYP_CTRL register\n");
> -		goto err_pmic_reg_read;
> +		return rc;
>  	}
>  
>  	kp->ctrl_reg = ctrl_val;
> @@ -692,36 +689,12 @@ static int pmic8xxx_kp_probe(struct platform_device *pdev)
>  	rc = input_register_device(kp->input);
>  	if (rc < 0) {
>  		dev_err(&pdev->dev, "unable to register keypad input device\n");
> -		goto err_pmic_reg_read;
> +		return rc;
>  	}
>  
>  	device_init_wakeup(&pdev->dev, pdata->wakeup);
>  
>  	return 0;
> -
> -err_pmic_reg_read:
> -	free_irq(kp->key_stuck_irq, kp);
> -err_req_stuck_irq:
> -	free_irq(kp->key_sense_irq, kp);
> -err_gpio_config:
> -err_get_irq:
> -	input_free_device(kp->input);
> -err_alloc_device:
> -	kfree(kp);
> -	return rc;
> -}
> -
> -static int pmic8xxx_kp_remove(struct platform_device *pdev)
> -{
> -	struct pmic8xxx_kp *kp = platform_get_drvdata(pdev);
> -
> -	device_init_wakeup(&pdev->dev, 0);

Why are we removing restoring wakeup capable state?

> -	free_irq(kp->key_stuck_irq, kp);
> -	free_irq(kp->key_sense_irq, kp);
> -	input_unregister_device(kp->input);
> -	kfree(kp);
> -
> -	return 0;
>  }
>  
>  #ifdef CONFIG_PM_SLEEP
> @@ -771,7 +744,6 @@ static SIMPLE_DEV_PM_OPS(pm8xxx_kp_pm_ops,
>  
>  static struct platform_driver pmic8xxx_kp_driver = {
>  	.probe		= pmic8xxx_kp_probe,
> -	.remove		= pmic8xxx_kp_remove,
>  	.driver		= {
>  		.name = PM8XXX_KEYPAD_DEV_NAME,
>  		.owner = THIS_MODULE,
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

-- 
Dmitry
