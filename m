Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab3LBDDQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 22:03:16 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:28378 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752575Ab3LBDDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 22:03:13 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/mvmI0FemA8dgkJrd/l8HUugPQIa29JZs=
Date: Sun, 1 Dec 2013 22:02:39 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: boris brezillon <b.brezillon@overkiz.com>
Cc: Rob Landley <rob@landley.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] clk: add accuracy support for fixed clock
Message-ID: <20131202030239.GA29282@titan.lakedaemon.net>
References: <1385556285-19180-1-git-send-email-b.brezillon@overkiz.com>
 <1385556285-19180-3-git-send-email-b.brezillon@overkiz.com>
 <20131127145620.GR2879@titan.lakedaemon.net>
 <5296298C.9040300@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5296298C.9040300@overkiz.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

Sorry for the delay.

On Wed, Nov 27, 2013 at 06:19:08PM +0100, boris brezillon wrote:
> On 27/11/2013 15:56, Jason Cooper wrote:
> >On Wed, Nov 27, 2013 at 01:44:45PM +0100, Boris BREZILLON wrote:
> >>This patch adds support for accuracy retrieval on fixed clocks.
> >>It also adds a new dt property called 'clock-accuracy' to define the clock
> >>accuracy.
> >>
> >>This can be usefull for oscillator (RC, crystal, ...) definitions which are
> >>always given an accuracy characteristic.
> >
> >I think we need to be more explicit in the binding and the API,
> >especially when providing a method to recalculate the accuracy.  I
> >presume this recalculated value would be relative against the root
> >clock?
> 
> Yes, indirectly.
> Actually the clk accuracy depends on the whole clock chain, and is
> calculated either by comparing the real clk rate to the theorical clk
> rate
> (accuracy = absolute_value((theorical_clk_rate - real_clk_rate)) /
> theorical_clk_rate),
> or by adding all the accuracies (expressed in ppm, ppb or ppt) of
> the clk chain
> (accuracy = current_clk_accuracy + parent_clk_accuracy).
> 
> Say you have a root clk with a +-10000 ppb accuracy, then a pll multiplying
> this root clk by 40 and introducing a possible drift of +- 1000 ppb and
> eventually a system clk based on this pll with a perfect div by 2 prescaler
> (accuracy = 0 ppb).
> 
> If I understand correctly how accuracy propagates accross the clk tree,
> you'll end up with a system clk with a +- 11000 ppb accuracy.
> 
> e.g.:
>  root clk = 12MHz +- 10000 ppb => 12 MHz * (1 - (10000 / 10^9)) <
> root clk < 12 MHz * (1 + (10000 / 10^9))
>                                                     => 11,99988 MHz
> < root clk < 12,00012 MHz
>  pll clk = ((root clk) * 40) +- 1000 ppb =>  (11,99988 MHz * 40) *
> (1 - (1000 / 10^9)) < pll clk < (12,00012 MHz * 40) * (1 + (1000 /
> 10^9))
>                                                            =>
> 479,994720005 MHz < pll clk < 480,005280005 MHz
> 
>  system clk = ((pll clk) / 2) +- XXX ppb => 479,994720005 MHz / 2 <
> system clk < 480,005280005 MHz / 2
>                                                               =>
> 239,997360002 MHz < system clk < 240,002640002 MHz
>                                                               =>
> system clk accuracy = 0,002640002 / 240 = 11000 ppb
> 
> Please tell me if my assumptions are false.

Nope, it looks fine by me afaict.  Thanks for the clear walk through.

> >There really needs to be two attributes here:  the rated accuracy from
> >the manufacturer, and the calculated accuracy wrt another clock in the
> >system.  We only need a binding for the manufacturer rating since the
> >calculated accuracy is determined at runtime.
> 
> Actually when I proposed this new functionnality I only had the theorical
> (or manufacturer rated) accuracy in mind.

Yes, I see we are concerned about two different things.  You need to get
the theoretical accuracy to assist with clock selection.  I was
concerned that the recalc function was attempting to measure the real
accuracy of a given clock from a tree.

Since we're only talking theoretical accuracy, that makes things a lot
simpler.  :)

> But providing an estimated accuracy (based on another clk) sounds
> interresting if your reference clk is an extremly accurate one.

Yes, I was thinking against a GPS PPS signal, but again, not relevant to
this patch series.  Also, it would be complicated by the fact that there
is no high-speed counter on ARM.

> >I would also prefer to see an unknown accuracy be -1.
> I decided to keep 0 as a default value for unimplemented recalc_accuracy
> (or unspecified fixed accuracy) to keep existing implementation coherent.
> 
> 0 means the clk is perfect, and I thought it would be easier to handle a
> perfect clk (even if this is not really the case) than handling an
> error case.
> 
> Another aspect is the propagation of the clk accuracy accross the clk tree.
> Returning -1 in the middle of the clk chain will drop the previous
> clk accuracy
> calculation.
> 
> Anyway, I can change this if you think this is more appropriate.

No, in light of this being purely theoretical accuracy, I'm fine with it
if Mike is.

> >There are already
> >clocks on the market (PPS reference clocks) with accuracies of
> >0.1ppb/day [1].  Obviously, these aren't system clocks.  So the limit on
> >accuracy may be a non-issue.  However, it may be worth changing the
> >binding property to express the units.
> Wow, 0.1 ppb, this is impressive :-).
> 
> 
> This needs more than changing the dt bindings: I currently store the
> accuracy value in an unsigned long field, and expressing this in ppt
> (parts per trillion) may implies storing this in an u64 field (or store a
> unit field).

No, let's not derail this series.  ;-)  You've addressed my concerns.
Thanks for taking the time to bring me up to speed.

thx,

Jason.
