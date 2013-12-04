Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab3LDN0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 08:26:20 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:56403 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932351Ab3LDN0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 08:26:18 -0500
X-Auth-Info: qDxO7ofu4Ehi9KFwiQjPyIZwpyLOVEishAK9TbsRdfE=
Date: Wed, 4 Dec 2013 14:26:13 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH v2] pinctrl: baytrail: lock IRQs when starting them
Message-ID: <20131204132613.GD2982@book.gsilab.sittig.org>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Stephen Warren <swarren@nvidia.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>
References: <1386082822-20094-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386082822-20094-1-git-send-email-linus.walleij@linaro.org>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 16:00 +0100, Linus Walleij wrote:
> 
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -372,11 +372,33 @@ static void byt_irq_mask(struct irq_data *d)
>  {
>  }
>  
> +static unsigned int byt_irq_startup(struct irq_data *d)
> +{
> +	struct byt_gpio *vg = irq_data_get_irq_handler_data(d);
> +
> +	if (gpio_lock_as_irq(&vg->chip, irqd_to_hwirq(d)))
> +		dev_err(vg->chip.dev,
> +			"unable to lock HW IRQ %lu for IRQ\n",
> +			irqd_to_hwirq(d));
> +	byt_irq_unmask(d);
> +	return 0;
> +}

Just a thought:  If failure to lock is non-fatal, should the
message be a warning then?

I do agree that failure to lock the GPIO should be non-fatal, as
there was debate and still might be concerns about how strict
locking should be.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
