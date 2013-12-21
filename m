Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab3LUGPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 01:15:54 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44597 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3LUGPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 01:15:51 -0500
Date: Fri, 20 Dec 2013 22:15:49 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH v3 04/12] clk: Add regmap core helpers for
 enable/disable/is_enabled
Message-ID: <20131221061549.GD31766@codeaurora.org>
References: <1381909214-12693-1-git-send-email-sboyd@codeaurora.org>
 <1381909214-12693-5-git-send-email-sboyd@codeaurora.org>
 <20131219045050.23538.94293@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219045050.23538.94293@quantum>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18, Mike Turquette wrote:
> Quoting Stephen Boyd (2013-10-16 00:40:06)
> >  struct clk_hw {
> >         struct clk *clk;
> >         const struct clk_init_data *init;
> >         struct regmap *regmap;
> > +       unsigned int enable_reg;
> > +       unsigned int enable_mask;
> > +       bool enable_is_inverted;
> 
> Thanks for submitting this patch.
> 
> Adding all of this stuff to struct clk_hw makes me a sad panda. You are
> essentially sharing a common set of ops for clocks that use regmap as
> their io operation back-end, and that is a good thing.
> 
> However, why not just do this as drivers/clk/clk-regmap.c, or
> drivers/clk/clk-gate-regmap.c?

These new members aren't exclusively for use by the regmap code.
For example, we could extend the gate clock implementation to
store the enable bit in the 'enable_mask' member. They also
aren't used exclusively by simple gates. If you look at this
patch series you'll see that I call the helpers from hardware
specific ops when I want to do the gate operation in addition to
something else like polling a status bit.

What is the concern though? I can only guess that perhaps not
every clock type will have a bit to toggle and so putting the
information here would unnecessarily penalize those clocks? How
many clocks in a particular system don't have an on/off
capability? On MSM hardware I can only count 5 or so out of 200
that don't have on/off capabilities so it didn't seem worth the
effort to have a struct inside a struct inside a struct just to
save a 100 bytes of data.

If I understand you, I could make clk-regmap.c and struct
clk_regmap like so:

	struct clk_regmap {
		struct regmap *regmap;
		unsigned int enable_reg;
		unsigned int enable_mask;
		bool enable_is_inverted;
		struct clk_hw hw;
	};

	int clk_is_enabled_regmap(struct clk_hw *hw)
	{
		...

That certainly avoids adding members to struct clk_hw, but it
also means that if we want to use this structure and augment it
with something like a status bit poll we need to make a third
structure to wrap the clk_regmap struct. That makes me a sad
panda.

The reason is because we'll need to add a registration function
like clk_regmap_register(). I would like to just have an array of
clk_hw pointers that I iterate through and call clk_register()
on, without having to think/worry that this clock is a basic
clock that doesn't use a regmap so I should call clk_register()
and this other clock is wrapping a clk_regmap struct so I need to
call clk_regmap_register(). I guess I could have more arrays or
pair the clk_hw pointers with some registration function pointer,
but that doesn't make me feel much better.

> Putting the clk_ops callback functions in
> drivers/clk/clk.c is a little weird and putting those struct members
> into struct clk_hw is definitely strange.

In the regulator framework we have helpers.c. I could make a
similar file for these very similar helpers.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
