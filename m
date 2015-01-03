Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbbACQWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 11:22:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59934 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbACQWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 11:22:44 -0500
Date: Sat, 3 Jan 2015 17:22:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com, rui.zhang@intel.com,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] ti-soc-thermal: implement eocz bit to make driver useful
 on omap3
Message-ID: <20150103162241.GA26680@amd>
References: <20150103114632.GA21883@amd>
 <20150103122634.GB22356@developer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150103122634.GB22356@developer>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > When periodic mode is not enabled, it is neccessary to force reads.
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 

> > --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> > @@ -43,6 +43,8 @@
> >  
> >  #include "ti-bandgap.h"
> >  
> > +static int ti_bandgap_force_single_read(struct ti_bandgap *bgp, int id);
> > +
> >  /***   Helper functions to access registers and their bitfields   ***/
> >  
> >  /**
> > @@ -852,14 +831,20 @@ int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
> >  	if (ret)
> >  		return ret;
> >  
> > +	if (!TI_BANDGAP_HAS(bgp, MODE_CONFIG)) {
> > +		ret = ti_bandgap_force_single_read(bgp, id);
> 
> not sure MODE_CONFIG is sufficient condition for single read on all OMAP
> versions.

Ok, what do you suggest? AFAICT, without MODE_CONFIG, continuous ADC
mode is not available, so we have to force it periodically, so this
should be correct.

> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> >  	spin_lock(&bgp->lock);
> >  	temp = ti_bandgap_read_temp(bgp, id);
> >  	spin_unlock(&bgp->lock);
> >  
> > -	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> > +	ret = ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
> 
> this one should be part of your clean up patch

Ok, can you apply the cleanup patch and I'll prepare one on the top of
it?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
