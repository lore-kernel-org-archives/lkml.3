Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaJTMmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:42:53 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:14950 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaJTMmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:42:43 -0400
Date: Mon, 20 Oct 2014 14:42:42 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
CC: <wsa@the-dreams.de>, <ludovic.desroches@atmel.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] i2c/at91: add support for system PM
Message-ID: <20141020124242.GD7443@ldesroches-Latitude-E6320>
Mail-Followup-To: Wenyou Yang <wenyou.yang@atmel.com>, wsa@the-dreams.de,
	linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
	nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org
References: <1413776535-10123-1-git-send-email-wenyou.yang@atmel.com>
 <1413776535-10123-3-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1413776535-10123-3-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 11:42:13AM +0800, Wenyou Yang wrote:
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Acked by: Ludovic Desroches <ludovic.desroches@atmel.com>

> ---
>  drivers/i2c/busses/i2c-at91.c |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index 03b9f48..8f408f8 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -845,6 +845,35 @@ static int at91_twi_remove(struct platform_device *pdev)
>  }
>  
>  #ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
> +static int at91_twi_suspend(struct device *dev)
> +{
> +	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
> +
> +	if (!pm_runtime_suspended(dev))
> +		clk_disable_unprepare(twi_dev->clk);
> +
> +	return 0;
> +}
> +
> +static int at91_twi_resume(struct device *dev)
> +{
> +	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
> +	int ret;
> +
> +	if (!pm_runtime_suspended(dev)) {
> +		ret = clk_prepare_enable(twi_dev->clk);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	pm_runtime_mark_last_busy(dev);
> +	pm_request_autosuspend(dev);
> +
> +	return 0;
> +}
> +#endif
> +
>  #ifdef CONFIG_PM_RUNTIME
>  static int at91_twi_runtime_suspend(struct device *dev)
>  {
> @@ -864,6 +893,7 @@ static int at91_twi_runtime_resume(struct device *dev)
>  #endif
>  
>  static const struct dev_pm_ops at91_twi_pm = {
> +	SET_SYSTEM_SLEEP_PM_OPS(at91_twi_suspend, at91_twi_resume)
>  	SET_RUNTIME_PM_OPS(at91_twi_runtime_suspend,
>  				at91_twi_runtime_resume, NULL)
>  };
> -- 
> 1.7.9.5
> 
