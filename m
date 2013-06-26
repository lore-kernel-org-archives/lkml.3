Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab3FZQWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:22:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:62736 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab3FZQWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:22:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,945,1363158000"; 
   d="scan'208";a="335887022"
Message-ID: <1372263718.8177.74.camel@envy.home>
Subject: Re: [PATCH 5/8] minnowboard-gpio: Export MinnowBoard expansion GPIO
From: Darren Hart <dvhart@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        danders@circuitco.com, vishal.l.verma@intel.com,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        platform-driver-x86@vger.kernel.org
Date: Wed, 26 Jun 2013 09:21:58 -0700
In-Reply-To: <1372233328.24799.48.camel@smile>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <c7bed09378e5edf88872e277b238ecc3f52634aa.1372211451.git.dvhart@linux.intel.com>
	 <1372233328.24799.48.camel@smile>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 10:55 +0300, Andy Shevchenko wrote:
> On Tue, 2013-06-25 at 18:53 -0700, Darren Hart wrote: 
> > Request and export the user-configurable GPIO lines to sysfs. This provides a
> > label readable in /debugfs/gpio and a simple interface for experimenting with
> > GPIO on the MinnowBoard.
> > 
> > This is separate from the minnowboard driver to provide users with the
> > flexibility to write kernel drivers for their own devices using these GPIO
> > lines.
> 
> Few comments below.
> 
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -35,6 +35,24 @@ config MINNOWBOARD
> >  
> >  	  If you have a MinnowBoard, say Y or M here.
> >  
> > +if MINNOWBOARD
> > +config MINNOWBOARD_GPIO
> > +	tristate "MinnowBoard Expansion GPIO"
> > +	depends on MINNOWBOARD
> > +	default n
> 
> Like you already had been told you don't need to have default n.
> 
> > --- /dev/null
> > +++ b/drivers/platform/x86/minnowboard-gpio.c
> 
> > +#include <linux/platform_device.h>
> > +#include <linux/module.h>
> > +#include <linux/gpio.h>
> > +#include <linux/gpio_keys.h>
> > +#include <linux/input.h>
> > +#include <linux/minnowboard.h>
> 
> + empty line here?
> 
> > +#include "minnowboard-gpio.h"
> 
> > +static int __init minnow_gpio_module_init(void)
> > +{
> > +	int err;
> > +
> > +	err = -ENODEV;
> > +	if (!minnow_detect())
> > +		goto out;
> > +
> > +#ifdef MODULE
> > +#ifdef CONFIG_MINNOWBOARD_MODULE
> 
> And less ifdefs with IS_MODULE().
> 

All good to here and consistent with Olof's comments. Thanks, I will
include in V2.

> > +	if (request_module("minnowboard"))
> > +		goto out;
> > +#endif
> > +#endif
> > +
> > +	/* Auxillary Expansion GPIOs */
> > +	if (!minnow_lvds_detect()) {
> > +		pr_debug("LVDS_DETECT not asserted, configuring Aux GPIO lines\n");
> > +		err = gpio_request_array(expansion_aux_gpios,
> > +					 ARRAY_SIZE(expansion_aux_gpios));
> > +		if (err) {
> > +			pr_err("Failed to request expansion aux GPIO lines\n");
> > +			goto out;
> > +		}
> > +	} else {
> > +		pr_debug("LVDS_DETECT asserted, ignoring aux GPIO lines\n");
> > +	}
> > +
> > +	/* Expansion GPIOs */
> > +	err = gpio_request_array(expansion_gpios, ARRAY_SIZE(expansion_gpios));
> > +	if (err) {
> > +		pr_err("Failed to request expansion GPIO lines\n");
> > +		if (minnow_lvds_detect())
> > +			gpio_free_array(expansion_aux_gpios,
> > +					ARRAY_SIZE(expansion_aux_gpios));
> > +		goto out;
> > +	}
> > +
> > + out:
> > +	return err;
> 
> Are you planning to add something else to 'out' path?
> Otherwise I think it will look better if you do return instead of
> [useless] gotos.

I suppose this is a matter of preference. I am allergic to multiple
return points. However, your argument is consistent with CodingStyle
Chapter 7 in that it states "and some common work such as cleanup has to
be done." If that "and" is a required sort of &&, then I should change
it. Do others have a strong opinion here?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel

