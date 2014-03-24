Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaCXIoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:44:14 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:41668 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaCXIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:44:12 -0400
Date: Mon, 24 Mar 2014 08:44:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mfd: arizona: Fix and factor out read of device tree
 GPIOs
Message-ID: <20140324084407.GL8541@lee--X1>
References: <1395224338-3709-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395224338-3709-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140321105218.GH15213@lee--X1>
 <20140321154400.GF1665@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140321154400.GF1665@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > On non-DT systems with device tree built in the current device tree GPIO
> > > reads will overwrite the pdata with zero when they fail. This patch
> > > factors out the reading of GPIOs for the Arizona devices into a helper
> > > function, and ensures that the pdata version will be preserved if the
> > > device tree read fails.
> > > 
> > > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> > > ---
> > >  drivers/mfd/arizona-core.c       |   33 ++++++++++++++++++++++++---------
> > >  include/linux/mfd/arizona/core.h |    3 +++
> > >  2 files changed, 27 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> > > index a45aab9..333621e 100644
> > > --- a/drivers/mfd/arizona-core.c
> > > +++ b/drivers/mfd/arizona-core.c
> > > @@ -512,19 +512,34 @@ int arizona_of_get_type(struct device *dev)
> > >  }
> > >  EXPORT_SYMBOL_GPL(arizona_of_get_type);
> > >  
> > > +int arizona_of_get_named_gpio(struct arizona *arizona, const char *prop,
> > > +			      bool mandatory, int *gpio)
> > > +{
> > > +	int ret;
> > > +
> > > +	ret = of_get_named_gpio(arizona->dev->of_node, prop, 0);
> > > +	if (ret >= 0) {
> > > +		*gpio = ret;
> > > +		return ret;
> > > +	}
> > > +
> > > +	/* Warn if GPIO is mandatory and not specified */
> > > +	if (mandatory && *gpio <= 0)
> > > +		dev_err(arizona->dev,
> > > +				"Mandatory DT gpio %s missing/malformed: %d\n",
> > > +				prop, ret);
> > > +
> > > +	return ret;
> > > +}
> > > +EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
> > > +
> > >  static int arizona_of_get_core_pdata(struct arizona *arizona)
> > >  {
> > > +	struct arizona_pdata *pdata = &arizona->pdata;
> > >  	int ret, i;
> > >  
> > > -	arizona->pdata.reset = of_get_named_gpio(arizona->dev->of_node,
> > > -						 "wlf,reset", 0);
> > > -	if (arizona->pdata.reset < 0)
> > > -		arizona->pdata.reset = 0;
> > > -
> > > -	arizona->pdata.ldoena = of_get_named_gpio(arizona->dev->of_node,
> > > -						  "wlf,ldoena", 0);
> > > -	if (arizona->pdata.ldoena < 0)
> > > -		arizona->pdata.ldoena = 0;
> > > +	arizona_of_get_named_gpio(arizona, "wlf,reset", true, &pdata->reset);
> > > +	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true, &pdata->ldoena);
> > >  
> > >  	ret = of_property_read_u32_array(arizona->dev->of_node,
> > >  					 "wlf,gpio-defaults",
> > 
> > This doesn't look correct to me at all. Have you tested it in the DT
> > and !DT case? By the looks of it arizona_of_get_core_pdata() is only
> > called if no platform data is present. Yet you are dereferencing it
> > here without allocated any memory.
> 
> The pdata struct is contained within the arizona one so there is
> no need to allocate memory for it.

Ah yes, I see that now. Thanks for the clarification.

> > So how were any platform data passed variables being overwritten in
> > the first place?
> 
> Ah good point this is not called if the pdata exists, I will
> update the commit message.

Great.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
