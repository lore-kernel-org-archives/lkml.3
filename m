Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaIZB3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:29:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55006 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbaIZB3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:29:41 -0400
Message-ID: <5424C182.5000906@codeaurora.org>
Date: Thu, 25 Sep 2014 18:29:38 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com, rabin@rab.in,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 0/9] Per-user clock constraints
References: <1411497613-24049-1-git-send-email-tomeu.vizoso@collabora.com> <5421DF46.2010107@codeaurora.org> <54228067.3090600@collabora.com>
In-Reply-To: <54228067.3090600@collabora.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/14 01:27, Tomeu Vizoso wrote:
> On 09/23/2014 10:59 PM, Stephen Boyd wrote:
>>
>> Any thoughts on my comments on patch set #10[1]? It seems like we can
>> avoid having a flag day to support this.
> I cannot say that I fully understand your proposal, but IMO the most
> valuable thing in this patchset is precisely the API split (and thus,
> the flag day is inherent to it).
>
> I see a lot of value in clk consumers to use a defined set of functions
> that all take and/or return struct clk, and for providers to use the
> functions that take and/or return struct clk_core. Makes the API clearer
> and allows it to have a more scalable growth in the future.

I see a lot of non-value. It's hugely invasive needing every driver to
change. Invariably we're going to break something. Back porting things
across this is a real pain (good luck stable trees!). Reviewing the
patches aren't feasible given their size. There's a reason why we don't
do flag days. They suck.

We already have the consumer/provider split in the struct clk_hw and
struct clk separation. Why don't we just use struct clk_hw throughout
the provider APIs? The only op that isn't doing this is determine_rate()
which might be able to accept a flag day. Otherwise we rename it to
something else and migrate everyone over to a different named function
that doesn't take a struct clk **. Then we introduce new APIs for the
providers to use that are struct clk_hw focused instead of struct clk
focused and migrate them too. The benefit being that we get proper
review of this stuff because the patches are small. We can let
coccinelle do it too.

>
> A less important feature of the patchset are per-user clocks, which (if
> I understand correctly) your proposal would address without requiring a
> flag day.

The subject of this thread seems to imply that it's the most important
part. I'm confused.

>
> And then we have clock constraints, which is probably the least
> important feature in the grand scheme of things, but it's actually what
> I personally care about.
>
> If we wanted to add a way for clk users to specify clock constraints
> without any refactoring, we could easily do so by reusing the request
> pattern that pm_qos uses:
>
> void clk_add_constraint(struct clk_request *req,
>                         int constraint_type,
>                         unsigned long value);
>
> void clk_update_constraint(struct clk_request *req,
>                            unsigned long new_value);
>
> void clk_remove_constraint(struct clk_request *req);
>
> It wouldn't be that bad IMO, but the API refactoring was something that
> was long desired and this was seen as a good opportunity to tackle it
> before it gets worst.
>

Sure. Maybe we should just do that so we don't break things.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

