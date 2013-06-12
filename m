Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3FLNcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 09:32:36 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61368 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529Ab3FLNce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 09:32:34 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/NuAjNQS8iZm5VNwb5lw2n
Date: Wed, 12 Jun 2013 06:32:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>, j-keerthy@ti.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] PM / AVS: SmartReflex/class3: Fix order of
 initialization of SR class and SR driver
Message-ID: <20130612133231.GQ8164@atomide.com>
References: <1370339913-16135-1-git-send-email-andrii.tseglytskyi@ti.com>
 <1370339913-16135-3-git-send-email-andrii.tseglytskyi@ti.com>
 <87fvwpdfab.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvwpdfab.fsf@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@linaro.org> [130610 10:58]:
> Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:
> 
> > SmartReflex consists of three entities: SR device, SR class and
> > SR driver. SmartReflex driver depends on SmartReflex class, but
> > order of their initialization is not clear. They both use
> > late_initcall(), and order depends on Makefile calls.
> > Patch moves initialization of SR class to device_initcall(),
> > and removes redundant call of sr_late_init().
> >
> > This provides predictable order of SmartReflex initcalls:
> > 1. device_initcall() -> SmartReflex class init
> > 2. late_initcall() -> SmartReflex driver init
> >
> > Signed-off-by: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
> 
> Tony will have to decide on whether he's OK with the initcall changes.
> 
> I can queue this with the rest of the AVS changes with Tony's ack.

I'd rather not make anything earlier, relying on the Makefile is just
fine here. These pieces are always compiled in too. The reason why
we should only minimal things initialized earlier than module_init
is that this way we have a proper console initialized and see real
error messages without having to have DEBUG_LL + earlyprintk enabled.

If anything else is needed, you have have just one late_initcall
that checks the return values of the various SR related init functions
to make sure all the dependencies are met.

Regards,

Tony
 
> >  arch/arm/mach-omap2/smartreflex-class3.c |    2 +-
> >  drivers/power/avs/smartreflex.c          |    9 ---------
> >  2 files changed, 1 insertion(+), 10 deletions(-)
> >
> > diff --git a/arch/arm/mach-omap2/smartreflex-class3.c b/arch/arm/mach-omap2/smartreflex-class3.c
> > index aee3c89..50523b8 100644
> > --- a/arch/arm/mach-omap2/smartreflex-class3.c
> > +++ b/arch/arm/mach-omap2/smartreflex-class3.c
> > @@ -59,4 +59,4 @@ static int __init sr_class3_init(void)
> >  	pr_info("SmartReflex Class3 initialized\n");
> >  	return sr_register_class(&class3_data);
> >  }
> > -omap_late_initcall(sr_class3_init);
> > +omap_device_initcall(sr_class3_init);
> > diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
> > index fd71d5a..42eed34 100644
> > --- a/drivers/power/avs/smartreflex.c
> > +++ b/drivers/power/avs/smartreflex.c
> > @@ -650,8 +650,6 @@ void sr_disable(struct voltagedomain *voltdm)
> >   */
> >  int sr_register_class(struct omap_sr_class_data *class_data)
> >  {
> > -	struct omap_sr *sr_info;
> > -
> >  	if (!class_data) {
> >  		pr_warning("%s:, Smartreflex class data passed is NULL\n",
> >  			__func__);
> > @@ -666,13 +664,6 @@ int sr_register_class(struct omap_sr_class_data *class_data)
> >  
> >  	sr_class = class_data;
> >  
> > -	/*
> > -	 * Call into late init to do intializations that require
> > -	 * both sr driver and sr class driver to be initiallized.
> > -	 */
> > -	list_for_each_entry(sr_info, &sr_list, node)
> > -		sr_late_init(sr_info);
> > -
> >  	return 0;
> >  }
