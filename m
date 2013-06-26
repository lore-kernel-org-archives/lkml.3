Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab3FZHzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:55:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:16241 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195Ab3FZHzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:55:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="322725981"
Message-ID: <1372233328.24799.48.camel@smile>
Subject: Re: [PATCH 5/8] minnowboard-gpio: Export MinnowBoard expansion GPIO
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        danders@circuitco.com, vishal.l.verma@intel.com,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        platform-driver-x86@vger.kernel.org
Date: Wed, 26 Jun 2013 10:55:28 +0300
In-Reply-To: <c7bed09378e5edf88872e277b238ecc3f52634aa.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <c7bed09378e5edf88872e277b238ecc3f52634aa.1372211451.git.dvhart@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 18:53 -0700, Darren Hart wrote: 
> Request and export the user-configurable GPIO lines to sysfs. This provides a
> label readable in /debugfs/gpio and a simple interface for experimenting with
> GPIO on the MinnowBoard.
> 
> This is separate from the minnowboard driver to provide users with the
> flexibility to write kernel drivers for their own devices using these GPIO
> lines.

Few comments below.

> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -35,6 +35,24 @@ config MINNOWBOARD
>  
>  	  If you have a MinnowBoard, say Y or M here.
>  
> +if MINNOWBOARD
> +config MINNOWBOARD_GPIO
> +	tristate "MinnowBoard Expansion GPIO"
> +	depends on MINNOWBOARD
> +	default n

Like you already had been told you don't need to have default n.

> --- /dev/null
> +++ b/drivers/platform/x86/minnowboard-gpio.c

> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/gpio.h>
> +#include <linux/gpio_keys.h>
> +#include <linux/input.h>
> +#include <linux/minnowboard.h>

+ empty line here?

> +#include "minnowboard-gpio.h"

> +static int __init minnow_gpio_module_init(void)
> +{
> +	int err;
> +
> +	err = -ENODEV;
> +	if (!minnow_detect())
> +		goto out;
> +
> +#ifdef MODULE
> +#ifdef CONFIG_MINNOWBOARD_MODULE

And less ifdefs with IS_MODULE().

> +	if (request_module("minnowboard"))
> +		goto out;
> +#endif
> +#endif
> +
> +	/* Auxillary Expansion GPIOs */
> +	if (!minnow_lvds_detect()) {
> +		pr_debug("LVDS_DETECT not asserted, configuring Aux GPIO lines\n");
> +		err = gpio_request_array(expansion_aux_gpios,
> +					 ARRAY_SIZE(expansion_aux_gpios));
> +		if (err) {
> +			pr_err("Failed to request expansion aux GPIO lines\n");
> +			goto out;
> +		}
> +	} else {
> +		pr_debug("LVDS_DETECT asserted, ignoring aux GPIO lines\n");
> +	}
> +
> +	/* Expansion GPIOs */
> +	err = gpio_request_array(expansion_gpios, ARRAY_SIZE(expansion_gpios));
> +	if (err) {
> +		pr_err("Failed to request expansion GPIO lines\n");
> +		if (minnow_lvds_detect())
> +			gpio_free_array(expansion_aux_gpios,
> +					ARRAY_SIZE(expansion_aux_gpios));
> +		goto out;
> +	}
> +
> + out:
> +	return err;

Are you planning to add something else to 'out' path?
Otherwise I think it will look better if you do return instead of
[useless] gotos.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
