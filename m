Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaIJBoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:44:34 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:56588 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaIJBod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:44:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAJuA9aj-N0UUYBq=7nJuaC+jC1M8AzkoQ2bXrhwVRYEsBd+qfA@mail.gmail.com>
References: <1403654783-7176-1-git-send-email-sboyd@codeaurora.org>
	<1403654783-7176-3-git-send-email-sboyd@codeaurora.org>
	<20140729060529.4906.66639@quantum>
	<CAJuA9aj-N0UUYBq=7nJuaC+jC1M8AzkoQ2bXrhwVRYEsBd+qfA@mail.gmail.com>
Date: Tue, 9 Sep 2014 18:44:31 -0700
X-Google-Sender-Auth: 28w5EYPU6s795m9ftpidfxiAIak
Message-ID: <CAGAzgsrdaRvvUwowLB2DJRd3kgrA_kFSONnyNZ-K70ShHVMLxQ@mail.gmail.com>
Subject: Re: [RFC/PATCH 02/12] clk: Add safe switch hook
From: "dbasehore ." <dbasehore@chromium.org>
To: Thomas Abraham <ta.omasab@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on what Thomas pointed out and my own thoughts, as long as we don't
plan on changing the rate of the safe parent, but changing our own dividers, we
should be able to use set_rate_and_parent to solve the issue on Samsung's
SoCs. If we can think of a reason that we might need to change the rate of the
safe parent, this would have to be setup to make a recursive call to
clk_set_rate.

On Tue, Jul 29, 2014 at 1:59 AM, Thomas Abraham <ta.omasab@gmail.com> wrote:
>
> On Tue, Jul 29, 2014 at 11:35 AM, Mike Turquette <mturquette@linaro.org> wrote:
> > Quoting Stephen Boyd (2014-06-24 17:06:13)
> >> Sometimes clocks can't accept their parent source turning off
> >> while the source is reprogrammed to a different rate. Most
> >> notably some CPU clocks require a way to switch away from the
> >> current PLL they're running on, reprogram that PLL to a new rate,
> >> and then switch back to the PLL with the new rate once they're
> >> done.  Add a hook that drivers can implement allowing them to
> >> return a 'safe parent' that they can switch their parent to while
> >> the upstream source is reprogrammed.
> >
> > Adding Thomas to Cc.
> >
> > Thomas,
> >
> > Does this generic hook help you out at all with your CPU frequency
> > transitions? I remember in my discussions with Chander K. that you have
> > something like safe dividers, safe parents and safe voltages to take
> > into account (but I might be misremembering some of that).
>
> Hi Mike,
>
> Samsung CPU clock implementation divides the alternate parent clock to
> lower permissible speeds when the old clock rate of the primary parent
> (PLL) is lower than the speed of the alternate parent. This step has
> to be completed prior to hook gets called.
>
> So though this hook takes care of re-parenting the clock, which is one
> of the steps handled in Samsung CPU clock, it is not a alternative to
> the current implementation of the Samsung CPU clock.
>
> Thanks,
> Thomas.
>
> >
> > Stephen,
> >
> > For reference, recent patches from Samsung to introduce cpu clocks[1]
> > which I am not wild about, but the generic infrastructure isn't really
> > there yet in the framework core to manage complex, pre-defined,
> > multi-clock transitions gracefully.
> >
> > Regards,
> > Mike
> >
> > [1] http://www.spinics.net/lists/arm-kernel/msg351137.html
> >
> >>
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> ---
> >>  drivers/clk/clk.c            | 53 ++++++++++++++++++++++++++++++++++++++------
> >>  include/linux/clk-private.h  |  2 ++
> >>  include/linux/clk-provider.h |  1 +
> >>  3 files changed, 49 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> >> index 8b73edef151d..5e32fa55032b 100644
> >> --- a/drivers/clk/clk.c
> >> +++ b/drivers/clk/clk.c
> >> @@ -1367,6 +1367,7 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
> >>                              struct clk *new_parent, u8 p_index)
> >>  {
> >>         struct clk *child;
> >> +       struct clk *parent;
> >>
> >>         clk->new_rate = new_rate;
> >>         clk->new_parent = new_parent;
> >> @@ -1376,6 +1377,17 @@ static void clk_calc_subtree(struct clk *clk, unsigned long new_rate,
> >>         if (new_parent && new_parent != clk->parent)
> >>                 new_parent->new_child = clk;
> >>
> >> +       if (clk->ops->get_safe_parent) {
> >> +               parent = clk->ops->get_safe_parent(clk->hw);
> >> +               if (parent) {
> >> +                       p_index = clk_fetch_parent_index(clk, parent);
> >> +                       clk->safe_parent_index = p_index;
> >> +                       clk->safe_parent = parent;
> >> +               }
>
> >> +       } else {
> >> +               clk->safe_parent = NULL;
> >> +       }
> >> +
> >>         hlist_for_each_entry(child, &clk->children, child_node) {
> >>                 child->new_rate = clk_recalc(child, new_rate);
> >>                 clk_calc_subtree(child, child->new_rate, NULL, 0);
> >> @@ -1458,14 +1470,42 @@ out:
> >>  static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long event)
> >>  {
> >>         struct clk *child, *tmp_clk, *fail_clk = NULL;
> >> +       struct clk *old_parent;
> >>         int ret = NOTIFY_DONE;
> >>
> >> -       if (clk->rate == clk->new_rate)
> >> +       if (clk->rate == clk->new_rate && event != POST_RATE_CHANGE)
> >>                 return NULL;
> >>
> >> +       switch (event) {
> >> +       case PRE_RATE_CHANGE:
> >> +               if (clk->safe_parent)
> >> +                       clk->ops->set_parent(clk->hw, clk->safe_parent_index);
> >> +               break;
> >> +       case POST_RATE_CHANGE:
> >> +               if (clk->safe_parent) {
> >> +                       old_parent = __clk_set_parent_before(clk,
> >> +                                                            clk->new_parent);
> >> +                       if (clk->ops->set_rate_and_parent) {
> >> +                               clk->ops->set_rate_and_parent(clk->hw,
> >> +                                               clk->new_rate,
> >> +                                               clk->new_parent ?
> >> +                                               clk->new_parent->rate : 0,
> >> +                                               clk->new_parent_index);
> >> +                       } else if (clk->ops->set_parent) {
> >> +                               clk->ops->set_parent(clk->hw,
> >> +                                               clk->new_parent_index);
> >> +                       }
> >> +                       __clk_set_parent_after(clk, clk->new_parent,
> >> +                                              old_parent);
> >> +               }
> >> +               break;
> >> +       }
> >> +

It might be less confusing to break out setting the safe parent into
it's own function.

>
> >>         if (clk->notifier_count) {
> >> -               ret = __clk_notify(clk, event, clk->rate, clk->new_rate);
> >> -               if (ret & NOTIFY_STOP_MASK)
> >> +               if (event != POST_RATE_CHANGE)

It seems like a bad merge happened here. This will prevent any
POST_RATE_CHANGE events from getting sent.

>
> >> +                       ret = __clk_notify(clk, event, clk->rate,
> >> +                                          clk->new_rate);
> >> +               if (ret & NOTIFY_STOP_MASK && event != POST_RATE_CHANGE)
> >>                         fail_clk = clk;
> >>         }
> >>
> >> @@ -1507,7 +1547,8 @@ static void clk_change_rate(struct clk *clk)
> >>         else if (clk->parent)
> >>                 best_parent_rate = clk->parent->rate;
> >>
> >> -       if (clk->new_parent && clk->new_parent != clk->parent) {
> >> +       if (clk->new_parent && clk->new_parent != clk->parent &&
> >> +                       !clk->safe_parent) {
> >>                 old_parent = __clk_set_parent_before(clk, clk->new_parent);
> >>
> >>                 if (clk->ops->set_rate_and_parent) {
> >> @@ -1527,9 +1568,6 @@ static void clk_change_rate(struct clk *clk)
> >>
> >>         clk->rate = clk_recalc(clk, best_parent_rate);
> >>
> >> -       if (clk->notifier_count && old_rate != clk->rate)
> >> -               __clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
> >> -
> >>         hlist_for_each_entry(child, &clk->children, child_node) {
> >>                 /* Skip children who will be reparented to another clock */
> >>                 if (child->new_parent && child->new_parent != clk)
> >> @@ -1603,6 +1641,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
> >>         /* change the rates */
> >>         clk_change_rate(top);
> >>
> >> +       clk_propagate_rate_change(top, POST_RATE_CHANGE);
> >>  out:
> >>         clk_prepare_unlock();
> >>
> >> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> >> index efbf70b9fd84..f48684af4d8f 100644
> >> --- a/include/linux/clk-private.h
> >> +++ b/include/linux/clk-private.h
> >> @@ -38,8 +38,10 @@ struct clk {
> >>         struct clk              **parents;
> >>         u8                      num_parents;
> >>         u8                      new_parent_index;
> >> +       u8                      safe_parent_index;
> >>         unsigned long           rate;
> >>         unsigned long           new_rate;
> >> +       struct clk              *safe_parent;
> >>         struct clk              *new_parent;
> >>         struct clk              *new_child;
> >>         unsigned long           flags;
> >> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> >> index 0c287dbbb144..7485911df4b6 100644
> >> --- a/include/linux/clk-provider.h
> >> +++ b/include/linux/clk-provider.h
> >> @@ -170,6 +170,7 @@ struct clk_ops {
> >>                                         struct clk **best_parent_clk);
> >>         int             (*set_parent)(struct clk_hw *hw, u8 index);
> >>         u8              (*get_parent)(struct clk_hw *hw);
> >> +       struct clk      *(*get_safe_parent)(struct clk_hw *hw);
> >>         int             (*set_rate)(struct clk_hw *hw, unsigned long rate,
> >>                                     unsigned long parent_rate);
> >>         int             (*set_rate_and_parent)(struct clk_hw *hw,
> >> --
> >> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> >> hosted by The Linux Foundation
> >>
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
