Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab3EMT5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:57:52 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44968 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab3EMT5v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:57:51 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: James Hogan <james.hogan@imgtec.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, James Hogan <james.hogan@imgtec.com>
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
Message-ID: <20130513195746.10068.92303@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v2 0/3] clk: implement remuxing during set_rate
Date: Mon, 13 May 2013 12:57:46 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Hogan (2013-04-19 09:28:21)
> This patchset adds support for automatic selection of the best parent
> for a clock mux, i.e. the one which can provide the closest clock rate
> to that requested. It can be controlled by a new CLK_SET_RATE_REMUX flag
> so that it doesn't happen unless explicitly allowed.
> 

I'm not sure about the new flag.  One of my regrets during the early
development of the common struct clk is the CLK_SET_RATE_PARENT flag.
In hindsight I would have preferred to make parent-propagation of rate
changes the default behavior, and instead provide a flag to prevent that
behavior, such as CLK_SET_RATE_NO_PROPAGATE.

One reason for this is the difficulty some have had with setting flags
from DT bindings.  Another reason is that a core goal of the framework
is to remove topology info from drivers; having to set a flag explicitly
on each clock to propagate rate changes is an impediment to that goal.

So perhaps CLK_SET_RATE_REMUX is a similar situation.  What do you think
about making remuxing the default and providing a flag to prevent it?
And also we can assume for the immediate future that users of
.determine_rate WANT to remux, since .round_rate won't do it.  Though
eventually it might be wise to convert all users of .round_rate over to
.determine_rate and deprecate .round_rate entirely.

Regards,
Mike

> This works by way of adding a new op, determine_rate, similar to
> round_rate but with an extra parameter to allow the clock driver to
> optionally select a different parent clock. This is used in
> clk_calc_new_rates to decide whether to initiate a set_parent operation.
> 
> Changes in v2:
> 
> I've moved the mux determine_rate implementation into a core helper, but
> I haven't pushed it fully into the core, as I think it just wouldn't
> work correctly for more complex clocks, e.g. if you (theoretically) had
> a combined mux and divide, you'd want to intercept the determine_rate
> and ask for a larger rate from the parent clocks, then return the
> divided rate. This should be possible by wrapping the mux determine_rate
> helper.
> 
> Patch 1 still exports the __clk_get_parent_by_index as it seems like it
> might be a useful thing for clock implementations to have access to if
> they ever wanted to do something more fancy with changing clock parents.
> 
> I haven't made any attempt to implement the atomic set_parent+set_rate
> as I don't have hardware that could take proper advantage of it, but it
> shouldn't be too difficult for others to implement if they wanted since
> they're fairly close to one another (in clk_change_rate()).
> 
> * switched to using new determine_rate op rather than adding an argument
>   to round_rate.
> * moved mux implementation into a single helper which should be usable
>   from more complex clocks which can mux.
> * rewrite main implementation so that no changes are made until after
>   the PRE notifications have been sent, and in a way that should ensure
>   correct notifications without duplicates, and I think should be safe
>   in the event of a notification failing.
> * various tidy ups and fixes.
> 
> James Hogan (3):
>   clk: abstract parent cache
>   clk: add support for clock reparent on set_rate
>   clk: clk-mux: implement remuxing on set_rate
> 
>  Documentation/clk.txt        |   4 +
>  drivers/clk/clk-mux.c        |   1 +
>  drivers/clk/clk.c            | 216 +++++++++++++++++++++++++++++++++----------
>  include/linux/clk-private.h  |   2 +
>  include/linux/clk-provider.h |  12 +++
>  5 files changed, 185 insertions(+), 50 deletions(-)
> 
> -- 
> 1.8.1.2
