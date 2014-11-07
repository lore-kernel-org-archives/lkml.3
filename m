Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaKGXgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 18:36:24 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59982 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751772AbaKGXgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 18:36:23 -0500
Date: Fri, 7 Nov 2014 23:36:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Doug Anderson <dianders@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: Propagate prepare and enable when reparenting
 orphans
Message-ID: <20141107233607.GS4042@n2100.arm.linux.org.uk>
References: <1415386312-23741-1-git-send-email-dianders@chromium.org>
 <20141107185844.GR4042@n2100.arm.linux.org.uk>
 <CAD=FV=WhWqMB=-ErD-59-z=y7OCZx4r7REkr3DpyYR=76SEJ6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=WhWqMB=-ErD-59-z=y7OCZx4r7REkr3DpyYR=76SEJ6A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 02:52:38PM -0800, Doug Anderson wrote:
> Russell,
> 
> On Fri, Nov 7, 2014 at 10:58 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Fri, Nov 07, 2014 at 10:51:52AM -0800, Doug Anderson wrote:
> >> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> >> index 4896ae9..a3d3d58 100644
> >> --- a/drivers/clk/clk.c
> >> +++ b/drivers/clk/clk.c
> >> @@ -1650,6 +1650,17 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
> >>       clk_reparent(clk, new_parent);
> >>       __clk_recalc_accuracies(clk);
> >>       __clk_recalc_rates(clk, POST_RATE_CHANGE);
> >> +
> >> +     if (clk->prepare_count) {
> >> +             unsigned long flags;
> >> +
> >> +             __clk_prepare(new_parent);
> >> +
> >> +             flags = clk_enable_lock();
> >> +             if (clk->enable_count)
> >> +                     __clk_enable(new_parent);
> >> +             clk_enable_unlock(flags);
> >> +     }
> >
> > I really don't understand why this isn't already done - I said this was
> > necessary a /long/ time ago.
> >
> > However, the above isn't sufficient.  Think about the old parent - this
> > should be disabled and unprepared if it was prepared and enabled by the
> > child.
> 
> You may be referring of a different bug than I am addressing.  I can
> think about the old parent, but it always a tear to my eyes since
> these clocks are orphans and had no old parents (unless you count the
> matron at the orphanage, but I doubt she was either prepared or
> enabled).  ;)
> 
> Ah, but I see!  There are other users of this function that are not
> part of "clk.c".  Doh!  Since this was a "__" function with no
> documentation I assumed it was "static", but I see that it is not.  I
> see two callers that are not part of the orphan code.
> 
> I'll happily move this code down so it's only called by the orphan
> code and not touch the two callers of __clk_reparent(), assuming that
> they don't need to deal with this scenario.

What I am saying is as follows.  Take this diagram - a mux.  clkc can
be sourced from either clkp1 or clkp2.  Initially, it is set to clkp1:

clkp1 -----o
            \
             o--------> clkc

clkp2 -----o

Let's assume that none of these clocks are requested, prepared or
enabled.

Now, if clkc is requested, and then prepared, clkp1 will be prepared,
but not clkp2.

When clkc is re-parented to clkp2 in this state, there are three things
which must happen:

1. clkp2 needs to be prepared.
2. clkc needs to be switched from clkp1 to clkp2.
3. clkp1 needs to be unprepared.

(the order is debatable.)

The reason for step 3 is because of what happens if we unprepare clkc,
or switch back to clkp1.

If we unprepare clkc, we _should_ end up with clkp1, clkp2 and clkc
_all_ back in their initial states - in other words, all unprepared.
clkp1 should not be left prepared by this sequence of events.

If we switch back to clkp1, then the same three things need to happen
(just with the appropriate parent clocks):

1. clkp1 needs to be prepared.
2. clkc needs to be switched from clkp2 to clkp1.
3. clkp2 needs to be unprepared.

And, having done that, we can see that we are in exactly the same state
as we were when we first prepared clkc in the beginning.

If we omit the unprepare stage, then at this point, we will have prepared
clkp1 _twice_ and clkp2 _once_, which means when clkc is unprepared, both
clkp1 and clkp2 are left with a preparation count of one - which is
effectively a refcount leak.

Fixing the lack of prepare may fix the "clock not running" problem, but
without addressing the unprepare side, you are introducing a new bug
while fixing an existing bug.  Both issues need to be resolved together.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
