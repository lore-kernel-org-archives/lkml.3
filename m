Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaI2Ryc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:54:32 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32961 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaI2Ryb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:54:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18wY71Ww2G/jXeCVDHjYw3s
Date: Mon, 29 Sep 2014 10:54:27 -0700
From: Tony Lindgren <tony@atomide.com>
To: He YunLei <heyunlei@huawei.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        wangbintian@huawei.com, liguozhu@hisilicon.com,
        kong.kongxinwei@hisilicon.com
Subject: Re: [RFC PATCH] pinctrl: pinctrl-single.c:  init pinctrl single at
 arch_initcall time
Message-ID: <20140929175427.GE3122@atomide.com>
References: <542934F4.10303@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542934F4.10303@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* He YunLei <heyunlei@huawei.com> [140929 03:32]:
> On our arm platform, some modules (e.g. I2C bus driver) will use the
> pinctrl-single driver to configure the SoC pin, but pinctrl-single driver
> uses module_init time, that makes some modules initialize ahead the
> pinctrl-single and fail to register.
> 
> This patch promotes the initialization priority of pinctrl-single from
> module_init time to arch_initcall time.

This has come up earlier and so far in all cases the problem
is that you have custom initcall levels for your other drivers.

Get rid of custom initcall levels for your drivers and the
problem goes away. There's no need to init the drivers earlier
nowadays. If you have other dependencies then deferred probe
helps but should be only needed for a limited number of cases.

We want to initialize things later, not earlier in general. That
removes the issues of no proper debug output while booting the
kernel.

Regards,

Tony

 
> Signed-off-by: Yunlei He <heyunlei@huawei.com>
> Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
> ---
>  drivers/pinctrl/pinctrl-single.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-single.c
> b/drivers/pinctrl/pinctrl-single.c
> index 95dd9cf..4b9e5b9 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -2012,7 +2012,18 @@ static struct platform_driver pcs_driver = {
>  #endif
>  };
> 
> -module_platform_driver(pcs_driver);
> +static int __init pinctrl_single_init(void)
> +{
> +		return platform_driver_register(&pcs_driver);
> +}
> +
> +static void __exit pinctrl_single_exit(void)
> +{
> +		platform_driver_unregister(&pcs_driver);
> +}
> +
> +arch_initcall(pinctrl_single_init);
> +module_exit(pinctrl_single_exit);
> 
>  MODULE_AUTHOR("Tony Lindgren <tony@atomide.com>");
>  MODULE_DESCRIPTION("One-register-per-pin type device tree based pinctrl
> driver");
> -- 
> 1.7.9.5
> 
