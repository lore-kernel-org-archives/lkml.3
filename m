Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3G2JpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:45:09 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:58411 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3G2JpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:45:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19QTxuW1phhyKdR/6OwyoYh
Date: Mon, 29 Jul 2013 02:45:02 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/4] pinctrl: Allow pinctrl to have multiple active
 states
Message-ID: <20130729094501.GC7656@atomide.com>
References: <20130718151213.30990.45828.stgit@localhost>
 <20130718151507.30990.67174.stgit@localhost>
 <CACRpkdY5-OFN4YQywPj06jkf493BhwgJGMEnmKmbovTh+co2Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY5-OFN4YQywPj06jkf493BhwgJGMEnmKmbovTh+co2Yg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130722 16:01]:
> On Thu, Jul 18, 2013 at 5:15 PM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > It's quite common that we need to dynamically change some pins for a
> > device for runtime PM, or toggle a pin between rx and tx. Changing all
> 
> What does "change" mean above?
> 
> Please reword to "remux" if that is what is meant.

Yes remux or reconfigure the pinconf depending on the hardware.
And possibly based on the board specific configuration if both
options are available.
 
> > the pins for a device is not efficient way of doing it.
> >
> > So let's allow setting up multiple active states for pinctrl.
> 
> Do you mean multiple default states?
> 
> I have a hard time understanding so please help me out :-/

One default state, which should only contain the static pins that
don't need to be remuxed or reconfigured during runtime PM.

It should probably say "support for multiple currently activated
states", does that make it clearer?
 
> > Currently
> > we only need PINCTRL_STATIC and PINCTRL_DYNAMIC, where PINCTRL_STATIC
> > covers the current default pins, and PINCTRL_DYNAMIC holds the dynamic
> > pins that need to be toggled.
> 
> Toggled when?

Remuxed or reconfigured constantly for runtime PM.
 
> When changing state to another one? Any other state? Or back to
> this state? Sorry not following ... this needs to be more verbose.

How about "toggle dynamic pins between active and idle state
for runtime PM"?
 
> > --- a/drivers/pinctrl/core.h
> > +++ b/drivers/pinctrl/core.h
> > @@ -53,12 +53,18 @@ struct pinctrl_dev {
> >  #endif
> >  };
> >
> > +enum pinctrl_states {
> > +       PINCTRL_STATIC,
> > +       PINCTRL_DYNAMIC,
> > +       PINCTRL_NR_STATES,
> > +};
> 
> This needs some very precise kerneldoc so it is chrystal clear what these
> states are all about. "pinctrl_states" is not a good name for this enum,
> please find some more precise name, because we have functions
> with names like pinctrl_select_state() which is not related to this.
> 
> Is this substates or?

This lists the sets of pins that can be activated the same
time. So after this, we support two sets of pins that a
pinctrl consumer driver can have activated the same time:
static pins and dynamic pins. There can be any number of
named modes for dynamic pins, but typically only active and
idle.

Then if for some reason we need more than two sets activated
the same time, we can expand the array as needed. So that's
mostly to try to keep things future proof and not limit things
to two sets as noted by Stephen earlier.
 
> > +
> >  /**
> >   * struct pinctrl - per-device pin control state holder
> >   * @node: global list node
> >   * @dev: the device using this pin control handle
> >   * @states: a list of states for this device
> > - * @state: the current state
> > + * @state: the current state(s)
> 
> How can more than one state be the current state? Sorry I don't get this.
> This needs to be more precise I think.

Hopefully the explanation above helps with that, if not,
let me know.
 
Regards,

Tony
