Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaIZIJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:09:59 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:45570 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbaIZIJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:09:26 -0400
Message-ID: <54251F30.8080303@collabora.com>
Date: Fri, 26 Sep 2014 10:09:20 +0200
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com, rabin@rab.in,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v13 0/9] Per-user clock constraints
References: <1411497613-24049-1-git-send-email-tomeu.vizoso@collabora.com> <5421DF46.2010107@codeaurora.org> <54228067.3090600@collabora.com> <5424C182.5000906@codeaurora.org>
In-Reply-To: <5424C182.5000906@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2014 03:29 AM, Stephen Boyd wrote:
> On 09/24/14 01:27, Tomeu Vizoso wrote:
>> On 09/23/2014 10:59 PM, Stephen Boyd wrote:
>>>
>>> Any thoughts on my comments on patch set #10[1]? It seems like we can
>>> avoid having a flag day to support this.
>> I cannot say that I fully understand your proposal, but IMO the most
>> valuable thing in this patchset is precisely the API split (and thus,
>> the flag day is inherent to it).
>>
>> I see a lot of value in clk consumers to use a defined set of functions
>> that all take and/or return struct clk, and for providers to use the
>> functions that take and/or return struct clk_core. Makes the API clearer
>> and allows it to have a more scalable growth in the future.
> 
> I see a lot of non-value. It's hugely invasive needing every driver to
> change.

There's obviously a trade-off to be made by the maintainer, and I don't
think that Mike has taken this lightly. He has already stated what his
opinion is and I have acted accordingly.

> Invariably we're going to break something.

Given all the build tests that these series have passed and the nature
of the changes (you can also check the script that does the
refactoring), I don't expect that much breakage.

> Back porting things
> across this is a real pain (good luck stable trees!). Reviewing the
> patches aren't feasible given their size. There's a reason why we don't
> do flag days. They suck.

Flag days are sometimes needed and is up to each maintainer to decide
what is better for the subsystem since they are the ones dealing with
the issues that may arise anyway.

> We already have the consumer/provider split in the struct clk_hw and
> struct clk separation. Why don't we just use struct clk_hw throughout
> the provider APIs? The only op that isn't doing this is determine_rate()
> which might be able to accept a flag day. Otherwise we rename it to
> something else and migrate everyone over to a different named function
> that doesn't take a struct clk **. Then we introduce new APIs for the
> providers to use that are struct clk_hw focused instead of struct clk
> focused and migrate them too. The benefit being that we get proper
> review of this stuff because the patches are small. We can let
> coccinelle do it too.

Really, the bulk of it is just a plain function rename that is in its
own commit. And we have a simple script that can be reviewed. And it has
passed the kbuild tests. Given that, and if we don't focus on just the
line count of that patch, I don't see your proposal as being
significantly better.

>> A less important feature of the patchset are per-user clocks, which (if
>> I understand correctly) your proposal would address without requiring a
>> flag day.
> 
> The subject of this thread seems to imply that it's the most important
> part. I'm confused.

Sorry about that, I agree that it could be improved.

>> And then we have clock constraints, which is probably the least
>> important feature in the grand scheme of things, but it's actually what
>> I personally care about.
>>
>> If we wanted to add a way for clk users to specify clock constraints
>> without any refactoring, we could easily do so by reusing the request
>> pattern that pm_qos uses:
>>
>> void clk_add_constraint(struct clk_request *req,
>>                         int constraint_type,
>>                         unsigned long value);
>>
>> void clk_update_constraint(struct clk_request *req,
>>                            unsigned long new_value);
>>
>> void clk_remove_constraint(struct clk_request *req);
>>
>> It wouldn't be that bad IMO, but the API refactoring was something that
>> was long desired and this was seen as a good opportunity to tackle it
>> before it gets worst.
>>
> 
> Sure. Maybe we should just do that so we don't break things.

That hasn't been what Mike has stated in the past, but I actually have
such a patch somewhere that I can dust off and send for review.

Cheers,

Tomeu

