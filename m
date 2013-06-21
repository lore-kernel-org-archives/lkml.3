Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423071Ab3FUG0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:26:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:19285 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030278Ab3FUG0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:26:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18sVE01VHraq341eN/a7ymf
Date: Thu, 20 Jun 2013 23:25:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] pinctrl: document the pinctrl PM states
Message-ID: <20130621062552.GI5523@atomide.com>
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
 <51BA1FE7.4000900@wwwdotorg.org>
 <CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com>
 <51BB3A2C.608@wwwdotorg.org>
 <20130617072021.GB4465@atomide.com>
 <51C20E3A.8090304@wwwdotorg.org>
 <20130620063823.GD5523@atomide.com>
 <51C3577E.6040709@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C3577E.6040709@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130620 12:32]:
> On 06/20/2013 12:38 AM, Tony Lindgren wrote:
> > * Stephen Warren <swarren@wwwdotorg.org> [130619 13:08]:
> >> On 06/17/2013 01:20 AM, Tony Lindgren wrote:
> ...
> >>> Below are the pin remuxing cases I'm aware of:
> >> ...
> >>> Then for dealing with the above examples, I think we already have a
> >>> pretty good setup in pinctrl framework to deal with this with the
> >>> named modes. But I think that to do this properly with the named
> >>> modes we should have named modes like the following:
> >>>
> >>> "static" && ("active" || "idle")
> >>> "static" && ("rx" || "tx")
> >>>
> >>> Here the "static" pins would be set during driver probe and never
> >>> need to change until the driver is unloaded. This is close to what we
> >>> currently call "default". But we should probably make it clear that
> >>> these will not change to avoid confusion. See below for more info.
> >>>
> >>> The the non-static states like "active"/"idle", or "rx"/"tx", can
> >>> be set in addition to "static", but they should not be subsets of
> >>> "static" to avoid the issues Stephen described earlier. This way we
> >>> allow the named modes to do the work for us while protecting the
> >>> claimed pins.
> >>
> >> Yes, I think this can certainly work conceptually. It's equivalent to
> >> pre-computing which parts of the overall state don't change between the
> >> currently-defined "global" active/idle states and then applying the
> >> diffs at runtime - rather like what I suggested before, but without the
> >> pinctrl code having to do the diff at runtime. I'm not sure if I have
> >> (yet) a strong opinion on whether allowing multiple states to be active
> >> at once (i.e. static plus active) is the correct way to go. Maybe once
> >> I've finished reading the thread...
> > 
> > I don't think there's any issue for having multiple sets active the same
> > is an issue, we're already doing it quite a bit although for different
> > device drivers so we have the framework ready for that already.
> 
> I assume you mean there shouldn't be any issue *modifying* the pinctrl
> API to allow multiple states to be active at once? And where you're
> talking about having multiple sets active at once already, you're
> talking about some other API?

Nope, the standard pinctrl API. At least I have not seen issues with
having multiple states active the same time in a single driver.
 
> Right now, pinctrl_select_state() de-activates the old state while
> activating the new state, so it's not possible to have more than one
> active at once.

That should be fine if the hardware needs it. The "static" (or "default")
state can stay active continuously, and "active" and "idle" states are
not subsets of "static".

Then flipping between "active" and "idle" states is fine as they cover
the same pins, and only either "active" or "idle" state is selected at
a time.

If the hardware needs to de-activate the old state inbetween the change
from "active" to "idle", that should be just fine.

If there are other issues with de-activating pins, then let me know.
I'm not be seeing the issue with de-activating states as pinctrl-single
does not de-activate anything for omap. The disable call gets called
between the state changes though, so hardware needing de-activating
can specify it.

Regards,

Tony
