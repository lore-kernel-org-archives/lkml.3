Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab3CGVH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:07:59 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13148 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab3CGVH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:07:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Mar 2013 13:07:52 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Alex Courbot <acourbot@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 7 Mar 2013 13:07:51 -0800
Subject: RE: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable
 regulator
Thread-Topic: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable
 regulator
Thread-Index: Ac4bJsOiibX6QtZCQl6bBV0+UlpylgAR6sRQ
Message-ID: <643E69AA4436674C8F39DCC2C05F7638629CA50EB4@HQMAIL03.nvidia.com>
References: <1362590238-27692-1-git-send-email-achew@nvidia.com>
 <20130307071102.GB3451@avionic-0098.mockup.avionic-design.de>
 <513867CD.4030201@nvidia.com>
 <20130307112723.GA2593@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130307112723.GA2593@avionic-0098.mockup.avionic-design.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thierry Reding [mailto:thierry.reding@avionic-design.de]
> Sent: Thursday, March 07, 2013 3:27 AM
> To: Alex Courbot
> Cc: Andrew Chew; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/1 v4] pwm_bl: Add support for backlight enable
> regulator
> 
> * PGP Signed by an unknown key
> 
> On Thu, Mar 07, 2013 at 07:11:25PM +0900, Alex Courbot wrote:
> > On 03/07/2013 04:11 PM, Thierry Reding wrote:
> > >>+	bool			en_supply_enabled;
> > >
> > >This boolean can be dropped. As discussed in a previous thread, the
> > >pwm-backlight driver shouldn't need to know about any other uses of
> > >the regulator.
> >
> > Sorry for being obstinate - but I'm still not convinced we can get rid
> > of it. I checked the regulator code, and as you mentioned in the
> > previous version, calls to regulator_enable() and
> > regulator_disable() *must* be balanced in this driver.
> >
> > Without this variable we would call regulator_enable() every time
> > pwm_backlight_enable() is called (and same thing when disabling).
> > Now imagine the driver is asked to set the following intensities: 5,
> > 12, then 0. You would have two calls to regulator_enable() but only
> > one to regulator_disable(), which would result in the enable GPIO
> > remaining active even though it would be shut down. Or I missed
> > something obvious.
> >
> > The regulator must be enabled/disabled on transitions from/to 0, and
> > AFAICT there is no way for this driver to detect them.
> 
> Yes, that's true, but I don't think it should be solved for just this one
> regulator. Instead if we need to track the enable state we might as well track
> it for *any* resource so that the PWM isn't enabled/disabled twice either.

That makes sense, but I'm confused due to previous comments.  The most
obvious way to do this seems to be to have a bool track the enable state.
Do you still want me to do away with this bool?  I can satisfy your very
last comment by keeping the bool (renaming it to something more generic)
and encapsulating the pwm_enable()/pwm_disable() call within.
I'll send out v5 today to show what I mean.

> > >This effectively makes the regulator mandatory, so the board files
> > >that use pwm-backlight need to be updated or otherwise will break.
> >
> > Yes. Btw, should such changes go into the same patch? This seems
> > difficult to split without breaking things at some point.
> 
> I expect that if the changes are split up then the board-setup code changes
> need to be done prior to the driver change. Using the lookup tables should
> make this easy because they aren't tied to the platform data and can be
> added independently. The patches should probably go through the same
> subsystem tree to take care of the dependencies.
> 
> Keeping everything in one patch would work too, but it's certainly more
> chaotic.

Am I supposed to handle those patches?  I'm concerned that I don't have
hardware to test properly, but I can give it a shot if it's my responsibility.
