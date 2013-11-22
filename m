Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3KVKLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:11:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:3339 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab3KVKL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:11:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,751,1378882800"; 
   d="scan'208";a="437897804"
Date: Fri, 22 Nov 2013 12:18:03 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mmc: sdhci-acpi: covert to use GPIO descriptor API
Message-ID: <20131122101803.GG2281@intel.com>
References: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385045153-25160-3-git-send-email-mika.westerberg@linux.intel.com>
 <528F1B7E.7010601@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528F1B7E.7010601@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 10:53:18AM +0200, Adrian Hunter wrote:
> On 21/11/13 16:45, Mika Westerberg wrote:
> > The new descriptor based GPIO interface is now the recommend and more safer
> 
> "recommend and more safer" -> "recommended and safer"

OK.

> 
> > way of using GPIOs from device drivers. Convert the ACPI SDHCI driver to
> > use that interface.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/mmc/host/sdhci-acpi.c | 26 ++++++++++----------------
> >  1 file changed, 10 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/mmc/host/sdhci-acpi.c b/drivers/mmc/host/sdhci-acpi.c
> > index ef19874fcd1f..379ddfe14bc7 100644
> > --- a/drivers/mmc/host/sdhci-acpi.c
> > +++ b/drivers/mmc/host/sdhci-acpi.c
> > @@ -31,10 +31,9 @@
> >  #include <linux/bitops.h>
> >  #include <linux/types.h>
> >  #include <linux/err.h>
> > -#include <linux/gpio.h>
> > +#include <linux/gpio/consumer.h>
> >  #include <linux/interrupt.h>
> >  #include <linux/acpi.h>
> > -#include <linux/acpi_gpio.h>
> >  #include <linux/pm.h>
> >  #include <linux/pm_runtime.h>
> >  #include <linux/delay.h>
> > @@ -199,22 +198,19 @@ static irqreturn_t sdhci_acpi_sd_cd(int irq, void *dev_id)
> >  	return IRQ_HANDLED;
> >  }
> >  
> > -static int sdhci_acpi_add_own_cd(struct device *dev, int gpio,
> > -				 struct mmc_host *mmc)
> > +static int sdhci_acpi_add_own_cd(struct device *dev, struct mmc_host *mmc)
> >  {
> > +	struct gpio_desc *desc;
> >  	unsigned long flags;
> >  	int err, irq;
> >  
> > -	if (gpio < 0) {
> > -		err = gpio;
> > +	desc = devm_gpiod_get_index(dev, NULL, 0);
> 
> I notice that:
> 
> 	devm_gpio_request_one(.., label)
> 		-> gpio_request_one(..., label)
> 			-> gpiod_request(..., label)
> 
> but:
> 
> 	devm_gpiod_get_index(..., con_id, ...)
> 		-> gpiod_get_index(..., con_id, ...)
> 			-> gpiod_request(..., con_id)
> 
> which suggests that 'con_id' is equivalent to 'label'.
> i.e. "sd_cd".  Is it?

Indeed, it is. Even though ACPI doesn't use con_id for lookup gpiolib uses
it as a label once the GPIO descriptor is found.

I'll change that from NULL to "sd_cd".
