Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025AbaDIUww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:52:52 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35155 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933590AbaDIUws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:52:48 -0400
Date: Wed, 9 Apr 2014 22:52:46 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-sh@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] pwm: add period and polarity to struct pwm_lookup
Message-ID: <20140409205246.GA2879@piout.net>
References: <1397066649-3767-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1397066649-3767-2-git-send-email-alexandre.belloni@free-electrons.com>
 <20140409193705.GJ27282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409193705.GJ27282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2014 at 20:37:06 +0100, Russell King - ARM Linux wrote :
> On Wed, Apr 09, 2014 at 08:04:08PM +0200, Alexandre Belloni wrote:
> > Adds a period and a polarity member to struct pwm_lookup so that when performing
> > a lookup using the lookup table instead of device tree, we are able to set the
> > period and the polarity accordingly like what is done in
> > of_pwm_xlate_with_flags.
> > 
> > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > ---
> >  drivers/pwm/core.c  | 5 +++++
> >  include/linux/pwm.h | 2 ++
> >  2 files changed, 7 insertions(+)
> > 
> > diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
> > index a80471399c20..206e5996359c 100644
> > --- a/drivers/pwm/core.c
> > +++ b/drivers/pwm/core.c
> > @@ -663,6 +663,11 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
> >  
> >  	if (chip)
> >  		pwm = pwm_request_from_chip(chip, index, con_id ?: dev_id);
> > +	if (IS_ERR(pwm))
> > +		return pwm;
> > +
> > +	pwm_set_period(pwm, p->period);
> > +	pwm_set_polarity(pwm, p->polarity);
> >  
> >  	mutex_unlock(&pwm_lookup_lock);
> 
> Clearly, this is not right.  Returning while leaving the mutex locked?
> No.
> 

Sure, I will fix that crap, sorry about that and thanks for pointing it
out.

> The second issue is... with _just_ this patch applied, we end up with
> "period" and "polarity" presumably initialised to zero, which means we
> now end up with the above explicitly setting the period and polarity as
> such.  Isn't that going to change the behaviour of this?
> 

I actually checked that.

For the polarity, for now, it is assumed that it is normal unless
specified otherwise.
The only driver that was supporting inverting it using platform_data is
pwm-renesas-tpu. It is used by board-armadillo800eva.c that I am
modifying now (and I just now realise that I forgot to invert it).

The only PWM controller that I know of that by default has its polarity
inversed is the allwinner one and in the driver I submitted, I actually
switch it to normal polarity in the probe instead of e.g. doing
pwm->polarity = PWM_POLARITY_INVERSED;

For the period, all the driver are assuming 0 after initialization.

I think this is not specified. If you think that may be a concern then I
suggest creating another macro and using a bitfield to know which value
is set.

I would also argue that when using device tree,
of_pwm_xlate_with_flags() will set the period and the polarity
unconditionally, this is replicating that behaviour.

However, I could agree that we may need to test for
pwm->chip->ops->set_polarity before calling pwm_set_polarity as we will
get an error if it is NULL (but we actually discard that return value).

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
