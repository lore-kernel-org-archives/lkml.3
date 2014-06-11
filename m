Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaFKKIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 06:08:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41422 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFKKIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 06:08:14 -0400
Date: Wed, 11 Jun 2014 13:07:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] mfd: vexpress: use after free in
 vexpress_syscfg_regmap_init()
Message-ID: <20140611100752.GR5500@mwanda>
References: <20140611060725.GC7569@mwanda>
 <1402478542.3523.9.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402478542.3523.9.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 10:22:22AM +0100, Pawel Moll wrote:
> On Wed, 2014-06-11 at 07:07 +0100, Dan Carpenter wrote:
> > We should return NULL if regmap_init() fails instead of continuing.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > diff --git a/drivers/misc/vexpress-syscfg.c b/drivers/misc/vexpress-syscfg.c
> > index 73068e5..2c0ddb2 100644
> > --- a/drivers/misc/vexpress-syscfg.c
> > +++ b/drivers/misc/vexpress-syscfg.c
> > @@ -231,10 +231,12 @@ static struct regmap *vexpress_syscfg_regmap_init(struct device *dev,
> >  	func->regmap = regmap_init(dev, NULL, func,
> >  			&vexpress_syscfg_regmap_config);
> >  
> > -	if (IS_ERR(func->regmap))
> > +	if (IS_ERR(func->regmap)) {
> >  		kfree(func);
> > -	else
> > -		list_add(&func->list, &syscfg->funcs);
> > +		return NULL;
> > +	}
> > +
> > +	list_add(&func->list, &syscfg->funcs);
> >  
> >  	return func->regmap;
> >  }
> 
> Not really, no. What made you think so?
> 
> vexpress_config_bridge_ops.regmap_init should return an ERR_PTR in case
> of troubles, not a NULL. See devm_regmap_init_vexpress_config() in
> drivers/bus/vexpress-config.c:
> 
>         regmap = bridge->ops->regmap_init(dev, bridge->context);
>         if (IS_ERR(regmap)) {

Ah...  That was sloppy of me.  There is a similar bug earlier and I'll
fix that as well.

regards,
dan carpenter

