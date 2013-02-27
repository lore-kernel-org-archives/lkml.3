Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab3B0OWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:22:00 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:58418 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760074Ab3B0OV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:21:59 -0500
Message-ID: <512E1685.6080206@slimlogic.co.uk>
Date: Wed, 27 Feb 2013 14:21:57 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, swarren@nvidia.com, ian@slimlogic.co.uk
Subject: Re: [PATCH 2/2] mfd: palmas: get rid of of_platform_populate() in
 DT registration
References: <1361974120-18134-1-git-send-email-ldewangan@nvidia.com> <1361974120-18134-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1361974120-18134-2-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/13 14:08, Laxman Dewangan wrote:
> If driver is getting registered through DT then it look for
> population of platform data which is not possible if platform
> completely support the DT.
No it doesnt!
> In this case, if device is registered through DT then just ignore
> platform data population and continue the further registration.
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/mfd/palmas.c |   21 +++++++++------------
>  1 files changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> index 25f0eab..6771d9b 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c
> @@ -465,18 +465,6 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>  	if (ret)
>  		goto err_irq;
>  
> -	/*
> -	 * If we are probing with DT do this the DT way and return here
> -	 * otherwise continue and add devices using mfd helpers.
> -	 */
> -	if (node) {
> -		ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
> -		if (ret < 0)
> -			goto err_irq;
> -		else
> -			return ret;
> -	}
> -
At this point we exit the function and do nothing with the platform data
which should work on wholy DT systems. I have tested it!
>  	children = kmemdup(palmas_children, sizeof(palmas_children),
>  			   GFP_KERNEL);
>  	if (!children) {
> @@ -484,6 +472,14 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>  		goto err_irq;
>  	}
>  
> +	/*
> +	 * If we are probing with DT then skip the platform data initialisation
> +	 * for children.
> +	 */
> +	if (node)
> +		goto skip_platform_data_init;
> +
> +
>  	children[PALMAS_PMIC_ID].platform_data = pdata->pmic_pdata;
>  	children[PALMAS_PMIC_ID].pdata_size = sizeof(*pdata->pmic_pdata);
>  
> @@ -500,6 +496,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
>  	children[PALMAS_CLK_ID].platform_data = pdata->clk_pdata;
>  	children[PALMAS_CLK_ID].pdata_size = sizeof(*pdata->clk_pdata);
>  
> +skip_platform_data_init:
>  	ret = mfd_add_devices(palmas->dev, -1,
>  			      children, ARRAY_SIZE(palmas_children),
>  			      NULL, 0,
I think this change is wrong! It seems to be based on a misreading of
the code!

Graeme

