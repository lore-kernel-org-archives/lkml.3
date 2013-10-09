Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3JIHeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 03:34:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41883 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab3JIHe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 03:34:28 -0400
Date: Wed, 9 Oct 2013 09:34:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] i2c: i2c-imx: replace platform_driver_probe to
 support deferred probing
Message-ID: <20131009073423.GS10079@pengutronix.de>
References: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
 <1381264542-29396-3-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1381264542-29396-3-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 10:35:34PM +0200, Wolfram Sang wrote:
> Subsystems like pinctrl and gpio rightfully make use of deferred probing at
> core level. Now, deferred drivers won't be retried if they don't have a .probe
> function specified in the driver struct. Fix this driver to have that, so the
> devices it supports won't get lost in a deferred probe.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Cc: kernel@pengutronix.de
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Thanks
Uwe

> ---
>  drivers/i2c/busses/i2c-imx.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index ccf4665..1d7efa3 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -365,7 +365,7 @@ static void i2c_imx_stop(struct imx_i2c_struct *i2c_imx)
>  	clk_disable_unprepare(i2c_imx->clk);
>  }
>  
> -static void __init i2c_imx_set_clk(struct imx_i2c_struct *i2c_imx,
> +static void i2c_imx_set_clk(struct imx_i2c_struct *i2c_imx,
>  							unsigned int rate)
>  {
>  	struct imx_i2c_clk_pair *i2c_clk_div = i2c_imx->hwdata->clk_div;
> @@ -589,7 +589,7 @@ static struct i2c_algorithm i2c_imx_algo = {
>  	.functionality	= i2c_imx_func,
>  };
>  
> -static int __init i2c_imx_probe(struct platform_device *pdev)
> +static int i2c_imx_probe(struct platform_device *pdev)
>  {
>  	const struct of_device_id *of_id = of_match_device(i2c_imx_dt_ids,
>  							   &pdev->dev);
> @@ -697,7 +697,7 @@ static int __init i2c_imx_probe(struct platform_device *pdev)
>  	return 0;   /* Return OK */
>  }
>  
> -static int __exit i2c_imx_remove(struct platform_device *pdev)
> +static int i2c_imx_remove(struct platform_device *pdev)
>  {
>  	struct imx_i2c_struct *i2c_imx = platform_get_drvdata(pdev);
>  
> @@ -715,7 +715,8 @@ static int __exit i2c_imx_remove(struct platform_device *pdev)
>  }
>  
>  static struct platform_driver i2c_imx_driver = {
> -	.remove		= __exit_p(i2c_imx_remove),
> +	.probe = i2c_imx_probe,
> +	.remove = i2c_imx_remove,
>  	.driver	= {
>  		.name	= DRIVER_NAME,
>  		.owner	= THIS_MODULE,
> @@ -726,7 +727,7 @@ static struct platform_driver i2c_imx_driver = {
>  
>  static int __init i2c_adap_imx_init(void)
>  {
> -	return platform_driver_probe(&i2c_imx_driver, i2c_imx_probe);
> +	return platform_driver_register(&i2c_imx_driver);
>  }
>  subsys_initcall(i2c_adap_imx_init);
>  
> -- 
> 1.8.4.rc3
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
