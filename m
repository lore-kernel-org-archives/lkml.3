Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab3EPELr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:11:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2187 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3EPELo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:11:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="47676365"
Message-ID: <51945C7F.2030605@codeaurora.org>
Date: Wed, 15 May 2013 21:11:43 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] clk: implement remuxing during set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
In-Reply-To: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2013 09:28 AM, James Hogan wrote:
> This patchset adds support for automatic selection of the best parent
> for a clock mux, i.e. the one which can provide the closest clock rate
> to that requested. It can be controlled by a new CLK_SET_RATE_REMUX flag
> so that it doesn't happen unless explicitly allowed.
>
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
>    to round_rate.
> * moved mux implementation into a single helper which should be usable
>    from more complex clocks which can mux.
> * rewrite main implementation so that no changes are made until after
>    the PRE notifications have been sent, and in a way that should ensure
>    correct notifications without duplicates, and I think should be safe
>    in the event of a notification failing.
> * various tidy ups and fixes.
>
> James Hogan (3):
>    clk: abstract parent cache
>    clk: add support for clock reparent on set_rate
>    clk: clk-mux: implement remuxing on set_rate
>
>   Documentation/clk.txt        |   4 +
>   drivers/clk/clk-mux.c        |   1 +
>   drivers/clk/clk.c            | 216 +++++++++++++++++++++++++++++++++----------
>   include/linux/clk-private.h  |   2 +
>   include/linux/clk-provider.h |  12 +++
>   5 files changed, 185 insertions(+), 50 deletions(-)
>

I really want to review this because I solved the same problem in our 
internal clock framework and want to make sure upstream doesn't go 
through the same mistakes. But haven't had the time. Hopefully, I'll go 
it before this gets accepted by Mike. I'll try to do it this week/weekend.

Thanks,
Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
