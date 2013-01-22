Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3AVUO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 15:14:58 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:58901 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755554Ab3AVUO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 15:14:57 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/DRfnaEysJTPS4SC9K3qW3
Date: Tue, 22 Jan 2013 12:14:53 -0800
From: Tony Lindgren <tony@atomide.com>
To: Luciano Coelho <coelho@ti.com>
Cc: gregkh@linuxfoundation.org, peter.ujfalusi@ti.com, balbi@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "drivers/misc/ti-st: remove gpio handling"
Message-ID: <20130122201453.GR22517@atomide.com>
References: <1358766762-24405-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358766762-24405-1-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luciano Coelho <coelho@ti.com> [130121 03:16]:
> This reverts commit eccf2979b2c034b516e01b8a104c3739f7ef07d1.
> 
> The reason is that it broke TI WiLink shared transport on Panda.
> Also, callback functions should not be added to board files anymore,
> so revert to implementing the power functions in the driver itself.
> 
> Additionally, changed a variable name ('status' to 'err') so that this
> revert compiles properly.
> 
> Cc: stable <stable@vger.kernel.org> [3.7]
> Signed-off-by: Luciano Coelho <coelho@ti.com>

This also makes sense from converting to DT based boot as the GPIO
calls should happen in the driver. Those mdelays probably can be fixed,
but since this is a revert to a known working version:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  drivers/misc/ti-st/st_kim.c |   37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
> index 9ff942a..83269f1 100644
> --- a/drivers/misc/ti-st/st_kim.c
> +++ b/drivers/misc/ti-st/st_kim.c
> @@ -468,6 +468,11 @@ long st_kim_start(void *kim_data)
>  		if (pdata->chip_enable)
>  			pdata->chip_enable(kim_gdata);
>  
> +		/* Configure BT nShutdown to HIGH state */
> +		gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
> +		mdelay(5);	/* FIXME: a proper toggle */
> +		gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
> +		mdelay(100);
>  		/* re-initialize the completion */
>  		INIT_COMPLETION(kim_gdata->ldisc_installed);
>  		/* send notification to UIM */
> @@ -509,7 +514,8 @@ long st_kim_start(void *kim_data)
>   *	(b) upon failure to either install ldisc or download firmware.
>   *	The function is responsible to (a) notify UIM about un-installation,
>   *	(b) flush UART if the ldisc was installed.
> - *	(c) invoke platform's chip disabling routine.
> + *	(c) reset BT_EN - pull down nshutdown at the end.
> + *	(d) invoke platform's chip disabling routine.
>   */
>  long st_kim_stop(void *kim_data)
>  {
> @@ -541,6 +547,13 @@ long st_kim_stop(void *kim_data)
>  		err = -ETIMEDOUT;
>  	}
>  
> +	/* By default configure BT nShutdown to LOW state */
> +	gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
> +	mdelay(1);
> +	gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
> +	mdelay(1);
> +	gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
> +
>  	/* platform specific disable */
>  	if (pdata->chip_disable)
>  		pdata->chip_disable(kim_gdata);
> @@ -733,6 +746,20 @@ static int kim_probe(struct platform_device *pdev)
>  	/* refer to itself */
>  	kim_gdata->core_data->kim_data = kim_gdata;
>  
> +	/* Claim the chip enable nShutdown gpio from the system */
> +	kim_gdata->nshutdown = pdata->nshutdown_gpio;
> +	err = gpio_request(kim_gdata->nshutdown, "kim");
> +	if (unlikely(err)) {
> +		pr_err(" gpio %ld request failed ", kim_gdata->nshutdown);
> +		return err;
> +	}
> +
> +	/* Configure nShutdown GPIO as output=0 */
> +	err = gpio_direction_output(kim_gdata->nshutdown, 0);
> +	if (unlikely(err)) {
> +		pr_err(" unable to configure gpio %ld", kim_gdata->nshutdown);
> +		return err;
> +	}
>  	/* get reference of pdev for request_firmware
>  	 */
>  	kim_gdata->kim_pdev = pdev;
> @@ -779,10 +806,18 @@ err_core_init:
>  
>  static int kim_remove(struct platform_device *pdev)
>  {
> +	/* free the GPIOs requested */
> +	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
>  	struct kim_data_s	*kim_gdata;
>  
>  	kim_gdata = dev_get_drvdata(&pdev->dev);
>  
> +	/* Free the Bluetooth/FM/GPIO
> +	 * nShutdown gpio from the system
> +	 */
> +	gpio_free(pdata->nshutdown_gpio);
> +	pr_info("nshutdown GPIO Freed");
> +
>  	debugfs_remove_recursive(kim_debugfs_dir);
>  	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
>  	pr_info("sysfs entries removed");
> -- 
> 1.7.10.4
> 
