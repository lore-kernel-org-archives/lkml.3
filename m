Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbaFKJWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:22:31 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:24516 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751310AbaFKJW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:22:29 -0400
Message-ID: <1402478542.3523.9.camel@hornet>
Subject: Re: [patch] mfd: vexpress: use after free in
 vexpress_syscfg_regmap_init()
From: Pawel Moll <pawel.moll@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 11 Jun 2014 10:22:22 +0100
In-Reply-To: <20140611060725.GC7569@mwanda>
References: <20140611060725.GC7569@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 07:07 +0100, Dan Carpenter wrote:
> We should return NULL if regmap_init() fails instead of continuing.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
> index 73068e5..2c0ddb2 100644
> --- a/drivers/misc/vexpress-syscfg.c
> +++ b/drivers/misc/vexpress-syscfg.c
> @@ -231,10 +231,12 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
>  	func->regmap = regmap_init(dev, NULL, func,
>  			&vexpress_syscfg_regmap_config);
>  
> -	if (IS_ERR(func->regmap))
> +	if (IS_ERR(func->regmap)) {
>  		kfree(func);
> -	else
> -		list_add(&func->list, &syscfg->funcs);
> +		return NULL;
> +	}
> +
> +	list_add(&func->list, &syscfg->funcs);
>  
>  	return func->regmap;
>  }

Not really, no. What made you think so?

vexpress_config_bridge_ops.regmap_init should return an ERR_PTR in case
of troubles, not a NULL. See devm_regmap_init_vexpress_config() in
drivers/bus/vexpress-config.c:

        regmap = bridge->ops->regmap_init(dev, bridge->context);
        if (IS_ERR(regmap)) {                                

Pawel

