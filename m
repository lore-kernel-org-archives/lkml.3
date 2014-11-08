Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaKHAO0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:14:26 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:44945 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKHAOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:14:25 -0500
MIME-Version: 1.0
In-Reply-To: <20141107233607.GS4042@n2100.arm.linux.org.uk>
References: <1415386312-23741-1-git-send-email-dianders@chromium.org>
	<20141107185844.GR4042@n2100.arm.linux.org.uk>
	<CAD=FV=WhWqMB=-ErD-59-z=y7OCZx4r7REkr3DpyYR=76SEJ6A@mail.gmail.com>
	<20141107233607.GS4042@n2100.arm.linux.org.uk>
Date: Fri, 7 Nov 2014 16:14:23 -0800
X-Google-Sender-Auth: sS6D-nWkgrjHbmgHcClsZbNs40c
Message-ID: <CAD=FV=WCwGjuLNFPANqqq-+rEN_jhqi+Bfss2ugDJEgjf3z_Gg@mail.gmail.com>
Subject: Re: [PATCH] clk: Propagate prepare and enable when reparenting orphans
From: Doug Anderson <dianders@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Fri, Nov 7, 2014 at 3:36 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> What I am saying is as follows.  Take this diagram - a mux.  clkc can
> be sourced from either clkp1 or clkp2.  Initially, it is set to clkp1:
>
> clkp1 -----o
>             \
>              o--------> clkc
>
> clkp2 -----o

OK.  This isn't my case at all.  In my case the clock being parented
is an orphan.  By definition it had no previous parent.  ...but let's
think about your scenario too.


> Let's assume that none of these clocks are requested, prepared or
> enabled.
>
> Now, if clkc is requested, and then prepared, clkp1 will be prepared,
> but not clkp2.
>
> When clkc is re-parented to clkp2 in this state, there are three things
> which must happen:
>
> 1. clkp2 needs to be prepared.
> 2. clkc needs to be switched from clkp1 to clkp2.
> 3. clkp1 needs to be unprepared.
>
> (the order is debatable.)
>
> The reason for step 3 is because of what happens if we unprepare clkc,
> or switch back to clkp1.
>
> If we unprepare clkc, we _should_ end up with clkp1, clkp2 and clkc
> _all_ back in their initial states - in other words, all unprepared.
> clkp1 should not be left prepared by this sequence of events.
>
> If we switch back to clkp1, then the same three things need to happen
> (just with the appropriate parent clocks):
>
> 1. clkp1 needs to be prepared.
> 2. clkc needs to be switched from clkp2 to clkp1.
> 3. clkp2 needs to be unprepared.
>
> And, having done that, we can see that we are in exactly the same state
> as we were when we first prepared clkc in the beginning.
>
> If we omit the unprepare stage, then at this point, we will have prepared
> clkp1 _twice_ and clkp2 _once_, which means when clkc is unprepared, both
> clkp1 and clkp2 are left with a preparation count of one - which is
> effectively a refcount leak.

All of the above is clear and matches my understanding of how
clk_set_parent() works.  You don't think it does?  ...or are you
talking about some other API call?

I see:

clk_set_parent()
-> __clk_set_parent()
----> __clk_set_parent_before()
------> prepare new parent
------> enable new parent
------> enable clk
------> actually do the reparent in CCF
----> call clk->ops->set_parent()
----> clk_set_parent_after()
------> disable clk
------> disable old parent
------> unprepare old parent

clk_set_parent() is documented to temporarily enable clk during its operation.


> Fixing the lack of prepare may fix the "clock not running" problem, but
> without addressing the unprepare side, you are introducing a new bug
> while fixing an existing bug.  Both issues need to be resolved together.

I guess I'm still confused.  My patch continues to be about orphans
and I don't see the bug you are pointing to.

-Doug
