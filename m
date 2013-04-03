Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795Ab3DCCGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:06:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46189 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab3DCCGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:06:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,397,1363158000"; 
   d="scan'208";a="35266694"
Message-ID: <515B8EAD.8020109@codeaurora.org>
Date: Tue, 02 Apr 2013 19:06:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [RFC PATCH v1 0/3] clk: implement remuxing during set_rate
References: <1363967031-22781-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1363967031-22781-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/13 08:43, James Hogan wrote:
> This patchset adds support for automatic selection of the best parent
> for a clock mux, i.e. the one which can provide the closest clock rate
> to that requested. It can be controlled by a new CLK_SET_RATE_REMUX flag
> so that it doesn't happen unless explicitly allowed.
>
> This works by way of adding a parameter to the round_rate clock op which
> allows the clock driver to optionally select a different parent index.
> This is used in clk_calc_new_rates to decide whether to initiate a
> set_parent operation. This would obviously require the argument to be
> added to all users of round_rate, something this patchset doesn't do as
> I'm not sure if it's really the preferred method (hence the RFC).
>
> An alternative would be to add a new callback, but that would complicate
> the code in clk.c somewhat. I suppose it would also be possible for the
> round_rate callback to call a function to set a struct clk member to
> mark that the parent should change (it's all within mutex protected
> code after all). Comments anyone?

It seems like you want to be able to call clk_set_rate() on a mux?
Usually when this comes up people say you should use clk_set_parent()
but I have a real use case (see below) and maybe you do too.

This patch set caught my eye because we need to be able to switch
parents during clk_set_rate() on MSM. We usually have two or three PLLs
feed into a mux that might feed into a divider that feeds into one or
two gates. I want clk_set_rate() on these gates to propagate up through
the divider to the mux and then have the mux switch depending on the rate.

I would like to get away without writing any new code beyond the ops
that are already there though. Well, I may have to write one new op
because I have hardware that can change the mux and divider at the same
time.

Can we push the code into the core? Perhaps by doing what you do in
clk-mux.c directly in clk_calc_new_rates()? We could store a new_parent
pointer in struct clk along with the new_rate when we find the best rate
and then when we propagate rates we can propagate the parent switch.
This part would be a little tricky if a clock has both a set_parent and
a set_rate op; what do you call first? The set_rate op? The set_parent
op? It matters for my hardware. We probably need to introduce a new
set_rate_and_parent op in case both parts of the equation change so that
the driver can do it atomically if desired (for my hardware) or in the
correct order (this part could be two generic functions like
generic_clk_rate_parent() and generic_clk_parent_rate() for the two
different orders, or two flags and the logic in the core, whatever).

I like keeping it in the core because we wouldn't need to change the
round_rate() function signature, it would be called in a loop with
different parent rates, and we wouldn't have to touch the clk-mux code
at all because it would all be done generically. Plus I get almost
everything for free for my hardware, I just need to write a new op that
does that atomic mux and rate switch. What do you think?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

