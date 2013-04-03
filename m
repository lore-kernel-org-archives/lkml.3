Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab3DCVeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 17:34:19 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33715 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760497Ab3DCVeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 17:34:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: James Hogan <james.hogan@imgtec.com>, Stephen Boyd <sboyd@codeaurora.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAAG0J99i-AwbGoerTzQvJ+JC9yj-3Owm3e5+6xTijo4Gihcx-Q@mail.gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Chao Xie <xiechao.mail@gmail.com>,
        James Hogan <james.hogan@imgtec.com>
References: <1363967031-22781-1-git-send-email-james.hogan@imgtec.com>
 <515B8EAD.8020109@codeaurora.org>
 <CAAG0J99i-AwbGoerTzQvJ+JC9yj-3Owm3e5+6xTijo4Gihcx-Q@mail.gmail.com>
Message-ID: <20130403213412.3383.84823@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [RFC PATCH v1 0/3] clk: implement remuxing during set_rate
Date: Wed, 03 Apr 2013 14:34:12 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Hogan (2013-04-03 14:08:17)
> On 3 April 2013 03:06, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >
> > On 03/22/13 08:43, James Hogan wrote:
> > > This patchset adds support for automatic selection of the best parent
> > > for a clock mux, i.e. the one which can provide the closest clock rate
> > > to that requested. It can be controlled by a new CLK_SET_RATE_REMUX flag
> > > so that it doesn't happen unless explicitly allowed.
> > >
> > > This works by way of adding a parameter to the round_rate clock op which
> > > allows the clock driver to optionally select a different parent index.
> > > This is used in clk_calc_new_rates to decide whether to initiate a
> > > set_parent operation. This would obviously require the argument to be
> > > added to all users of round_rate, something this patchset doesn't do as
> > > I'm not sure if it's really the preferred method (hence the RFC).
> > >
> > > An alternative would be to add a new callback, but that would complicate
> > > the code in clk.c somewhat. I suppose it would also be possible for the
> > > round_rate callback to call a function to set a struct clk member to
> > > mark that the parent should change (it's all within mutex protected
> > > code after all). Comments anyone?
> >
> > It seems like you want to be able to call clk_set_rate() on a mux?
> 
> Yes, that's right.
> 
> > Usually when this comes up people say you should use clk_set_parent()
> > but I have a real use case (see below) and maybe you do too.
> 
> Agreed, it shouldn't be up to generic drivers to know what clocks to
> reparent to in order to get a given frequency.
> 
> >
> > This patch set caught my eye because we need to be able to switch
> > parents during clk_set_rate() on MSM. We usually have two or three PLLs
> > feed into a mux that might feed into a divider that feeds into one or
> > two gates. I want clk_set_rate() on these gates to propagate up through
> > the divider to the mux and then have the mux switch depending on the rate.
> 
> We have a similar sort of thing here too. With the hardware I'm
> working on, various clocks can be sourced from external oscillators,
> the system clock (usually derived form a PLL), or in some cases from
> other more complex clocks and PLLs, and are often fed into dividers
> and gates which are the clocks that drivers are provided with.
> 
> >
> > I would like to get away without writing any new code beyond the ops
> > that are already there though. Well, I may have to write one new op
> > because I have hardware that can change the mux and divider at the same
> > time.
> >
> > Can we push the code into the core? Perhaps by doing what you do in
> > clk-mux.c directly in clk_calc_new_rates()? We could store a new_parent
> > pointer in struct clk along with the new_rate when we find the best rate
> > and then when we propagate rates we can propagate the parent switch.
> > This part would be a little tricky if a clock has both a set_parent and
> > a set_rate op; what do you call first? The set_rate op? The set_parent
> > op? It matters for my hardware. We probably need to introduce a new
> > set_rate_and_parent op in case both parts of the equation change so that
> > the driver can do it atomically if desired (for my hardware) or in the
> > correct order (this part could be two generic functions like
> > generic_clk_rate_parent() and generic_clk_parent_rate() for the two
> > different orders, or two flags and the logic in the core, whatever).
> >

This has been discussed several times in the past and the core
definitely should handle this in a similar fashion to the way
clk->ops->recalc_rate can request a better parent rate.

One thought to not break compatibility might be something like:

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 0230c9d..0708fa3 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1043,12 +1043,17 @@ static struct clk *clk_calc_new_rates(struct clk *clk, unsigned long rate)
 
 	/* never propagate up to the parent */
 	if (!(clk->flags & CLK_SET_RATE_PARENT)) {
-		if (!clk->ops->round_rate) {
+		if (clk->ops->determine_rate) {
+			new_rate = clk->ops->determine_rate(clk->hw, rate,
+					&best_parent_rate, &best_parent_clk);
+			goto out;
+		} else if (clk->ops->round_rate) {
+			new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
+			goto out;
+		} else {
 			clk->new_rate = clk->rate;
 			return NULL;
 		}
-		new_rate = clk->ops->round_rate(clk->hw, rate, &best_parent_rate);
-		goto out;
 	}
 
 	/* need clk->parent from here on out */
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 9fdfae7..1a19186 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -126,6 +126,9 @@ struct clk_ops {
 					unsigned long parent_rate);
 	long		(*round_rate)(struct clk_hw *hw, unsigned long,
 					unsigned long *);
+	s64		(*determine_rate)(struct clk_hw *hw, unsigned long rate,
+					unsigned long *best_parent_rate,
+					struct clk *best_parent_clk);
 	int		(*set_parent)(struct clk_hw *hw, u8 index);
 	u8		(*get_parent)(struct clk_hw *hw);
 	int		(*set_rate)(struct clk_hw *hw, unsigned long,

Obviously lots of stuff is missing there, but it would not force every
user of .round_rate to add a new best_parent_clk parameter.  Perhaps
.round_rate could be phased out in the future... or perhaps it would be
better to just do a mass update of all .round_rate implementations.  It
is worth pointing out that the top-level clk_round_rate api would not be
changed; the idea above only affects clk drivers using the common struct
clk.

> > I like keeping it in the core because we wouldn't need to change the
> > round_rate() function signature, it would be called in a loop with
> > different parent rates, and we wouldn't have to touch the clk-mux code
> > at all because it would all be done generically. Plus I get almost
> > everything for free for my hardware, I just need to write a new op that
> > does that atomic mux and rate switch. What do you think?
> 

Flags might be necessary to favor rate-change versus reparent, but that
is a small detail.

> I like this idea a lot. It feels cleaner, and as far as I can tell at
> a glance it should be possible. Thanks for the feedback, and comments
> about atomic changes, I'll certainly bear those issues in mind so I
> don't make it difficult to add that callback. I think it's probably
> best in the non-atomic case to default to the existing behaviour (set
> parent rate before child rate, which translates to setting parent
> before setting rate), and if somebody comes along with a different use
> case they can add the necessary flag or whatever to alter the
> behaviour.
> 
> I won't get any time to try this out for a couple of weeks as I'm on
> paternity leave at the moment.
> 

Congratulations!  Enjoy your leave, or at least try to not become sleep
deprived.

I'll add this to my stack but it's pretty far and away compared to other
items.  Feel free to beat me to it if you like.

Regards,
Mike

> Cheers
> James
