Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaFKKda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:33:30 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:56430 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751634AbaFKKd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:33:27 -0400
Message-ID: <1402482800.3523.20.camel@hornet>
Subject: Re: [patch v2] mfd: vexpress: fix error handling
 vexpress_syscfg_regmap_init()
From: Pawel Moll <pawel.moll@arm.com>
To: Dan Carpenter <dan.carpenter@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 11 Jun 2014 11:33:20 +0100
In-Reply-To: <20140611101740.GA13148@mwanda>
References: <20140611101740.GA13148@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 11:17 +0100, Dan Carpenter wrote:
> This function should be returning an ERR_PTR() on failure instead of
> NULL.  Also there is a use after free bug if regmap_init() fails because
> we free "func" and then dereference doing the return.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
> index 73068e5..3250fc1 100644
> --- a/drivers/misc/vexpress-syscfg.c
> +++ b/drivers/misc/vexpress-syscfg.c
> @@ -199,7 +199,7 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
>  	func = kzalloc(sizeof(*func) + sizeof(*func->template) * num,
>  			GFP_KERNEL);
>  	if (!func)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
>  	func->syscfg = syscfg;
>  	func->num_templates = num;
> @@ -231,10 +231,14 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
>  	func->regmap = regmap_init(dev, NULL, func,
>  			&vexpress_syscfg_regmap_config);
>  
> -	if (IS_ERR(func->regmap))
> +	if (IS_ERR(func->regmap)) {
> +		void *err = func->regmap;
> +
>  		kfree(func);
> -	else
> -		list_add(&func->list, &syscfg->funcs);
> +		return err;
> +	}
> +
> +	list_add(&func->list, &syscfg->funcs);
>  
>  	return func->regmap;
>  }

Uh, right. Dereferencing a freed structure. My bad. Thanks for spotting
this!

Acked-by: Pawel Moll <pawel.moll@arm.com>

(nit: the subject should be "misc: vexpress:" rather then "mfd:")

Arnd, Olof, can you pick this one as an early fix or do you want me to
queue it for rc1-based fixes branch?

Paweł

