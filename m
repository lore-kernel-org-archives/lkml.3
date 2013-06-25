Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab3FYHi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:38:59 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14705 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3FYHi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:38:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/BJOAcdbK31D3y1GhIUPm6
Date: Tue, 25 Jun 2013 00:38:49 -0700
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
Message-ID: <20130625073849.GF5523@atomide.com>
References: <CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com>
 <51BB3A2C.608@wwwdotorg.org>
 <20130617072021.GB4465@atomide.com>
 <51C20E3A.8090304@wwwdotorg.org>
 <20130620063823.GD5523@atomide.com>
 <51C3577E.6040709@wwwdotorg.org>
 <20130621062552.GI5523@atomide.com>
 <51C4A593.6000900@wwwdotorg.org>
 <20130624101055.GT5523@atomide.com>
 <51C88B54.9000902@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C88B54.9000902@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130624 11:15]:
> On 06/24/2013 04:10 AM, Tony Lindgren wrote:
> > * Stephen Warren <swarren@wwwdotorg.org> [130621 12:18]:
> >> On 06/21/2013 12:25 AM, Tony Lindgren wrote:
> >>> * Stephen Warren <swarren@wwwdotorg.org> [130620 12:32]:
> >>>>
> >>>> I assume you mean there shouldn't be any issue *modifying* the pinctrl
> >>>> API to allow multiple states to be active at once? And where you're
> >>>> talking about having multiple sets active at once already, you're
> >>>> talking about some other API?
> >>>
> >>> Nope, the standard pinctrl API. At least I have not seen issues with
> >>> having multiple states active the same time in a single driver.
> >>
> >> Please take a look at the implementation of pinctrl_select_state(). It
> >> very explicitly performs the following steps:
> >>
> >> 1) Find all pins(groups) that are used in the current state but not the
> >> new state, and execute pinctrl_disable_setting() on them. (For mux
> >> settings only, not pin config, since the core doesn't have any idea how
> >> to reverse config settings).
> >>
> >> 2) For all settings in the new state, apply those settings.
> >>
> >> So, it very explicitly only allows a single state to be set at a time.
> >> Equally, p->state (the field which stores the currently selected state)
> >> is a single item, not a set/list/array.
> > 
> > OK thanks I get now what you're saying. I did not see the p->state
> > issue as the disable function won't do anything for the SoCs that I
> > mostly deal with.
> > 
> >> So, this code needs rework if you want the core to support the concept
> >> of having multiple states active at once, since it needs separate
> >> pinctrl_activate_state() and pinctrl_deactivate_state() APIs, in order
> >> to avoid step (1) above. And of course, p->state would need to be a
> >> set/list/array.
> > 
> > I'll think about it a bit and do a patch to fix this. It seems that
> > that we need just two entries in the p->state array: static (default),
> > and dynamic. Then the dynamic would be typically one of: active, idle,
> > rx, tx.
> 
> I'm not entirely convinced that "2" is the right number. If we start
> allowing drivers to "piece together" multiple different state names, why
> wouldn't you allow 3 (or n) different state names to be active at once?
> Off-hand, I don't have specific use-cases in mind for more than 2 state
> (or even 1 in my case I suspect) - it just seems like expecting to
> arbitrarily restrict the number of co-active states is unlikely to last
> for long, and it'll end up being a slippery slope.

Yes let's set it up so we can expand it if needed.

We probably don't want the consumer drivers to piece together various
named states directly though as that will lead to custom code in every
driver..

I think we can make it happen automaticall for the cases we've discussed.

Regards,

Tony
