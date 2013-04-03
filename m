Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3DCVIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 17:08:19 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:44118 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759183Ab3DCVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 17:08:18 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <515B8EAD.8020109@codeaurora.org>
References: <1363967031-22781-1-git-send-email-james.hogan@imgtec.com>
	<515B8EAD.8020109@codeaurora.org>
Date: Wed, 3 Apr 2013 22:08:17 +0100
X-Google-Sender-Auth: 2Vf3Fz6-jcnK3CaTbvRkRP2x86g
Message-ID: <CAAG0J99i-AwbGoerTzQvJ+JC9yj-3Owm3e5+6xTijo4Gihcx-Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/3] clk: implement remuxing during set_rate
From: James Hogan <james.hogan@imgtec.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Chao Xie <xiechao.mail@gmail.com>,
        James Hogan <james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 April 2013 03:06, Stephen Boyd <sboyd@codeaurora.org> wrote:
>
> On 03/22/13 08:43, James Hogan wrote:
> > This patchset adds support for automatic selection of the best parent
> > for a clock mux, i.e. the one which can provide the closest clock rate
> > to that requested. It can be controlled by a new CLK_SET_RATE_REMUX flag
> > so that it doesn't happen unless explicitly allowed.
> >
> > This works by way of adding a parameter to the round_rate clock op which
> > allows the clock driver to optionally select a different parent index.
> > This is used in clk_calc_new_rates to decide whether to initiate a
> > set_parent operation. This would obviously require the argument to be
> > added to all users of round_rate, something this patchset doesn't do as
> > I'm not sure if it's really the preferred method (hence the RFC).
> >
> > An alternative would be to add a new callback, but that would complicate
> > the code in clk.c somewhat. I suppose it would also be possible for the
> > round_rate callback to call a function to set a struct clk member to
> > mark that the parent should change (it's all within mutex protected
> > code after all). Comments anyone?
>
> It seems like you want to be able to call clk_set_rate() on a mux?

Yes, that's right.

> Usually when this comes up people say you should use clk_set_parent()
> but I have a real use case (see below) and maybe you do too.

Agreed, it shouldn't be up to generic drivers to know what clocks to
reparent to in order to get a given frequency.

>
> This patch set caught my eye because we need to be able to switch
> parents during clk_set_rate() on MSM. We usually have two or three PLLs
> feed into a mux that might feed into a divider that feeds into one or
> two gates. I want clk_set_rate() on these gates to propagate up through
> the divider to the mux and then have the mux switch depending on the rate.

We have a similar sort of thing here too. With the hardware I'm
working on, various clocks can be sourced from external oscillators,
the system clock (usually derived form a PLL), or in some cases from
other more complex clocks and PLLs, and are often fed into dividers
and gates which are the clocks that drivers are provided with.

>
> I would like to get away without writing any new code beyond the ops
> that are already there though. Well, I may have to write one new op
> because I have hardware that can change the mux and divider at the same
> time.
>
> Can we push the code into the core? Perhaps by doing what you do in
> clk-mux.c directly in clk_calc_new_rates()? We could store a new_parent
> pointer in struct clk along with the new_rate when we find the best rate
> and then when we propagate rates we can propagate the parent switch.
> This part would be a little tricky if a clock has both a set_parent and
> a set_rate op; what do you call first? The set_rate op? The set_parent
> op? It matters for my hardware. We probably need to introduce a new
> set_rate_and_parent op in case both parts of the equation change so that
> the driver can do it atomically if desired (for my hardware) or in the
> correct order (this part could be two generic functions like
> generic_clk_rate_parent() and generic_clk_parent_rate() for the two
> different orders, or two flags and the logic in the core, whatever).
>
> I like keeping it in the core because we wouldn't need to change the
> round_rate() function signature, it would be called in a loop with
> different parent rates, and we wouldn't have to touch the clk-mux code
> at all because it would all be done generically. Plus I get almost
> everything for free for my hardware, I just need to write a new op that
> does that atomic mux and rate switch. What do you think?

I like this idea a lot. It feels cleaner, and as far as I can tell at
a glance it should be possible. Thanks for the feedback, and comments
about atomic changes, I'll certainly bear those issues in mind so I
don't make it difficult to add that callback. I think it's probably
best in the non-atomic case to default to the existing behaviour (set
parent rate before child rate, which translates to setting parent
before setting rate), and if somebody comes along with a different use
case they can add the necessary flag or whatever to alter the
behaviour.

I won't get any time to try this out for a couple of weeks as I'm on
paternity leave at the moment.

Cheers
James
