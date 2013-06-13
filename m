Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab3FMPCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:02:33 -0400
Received: from multi.imgtec.com ([194.200.65.239]:46471 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756987Ab3FMPCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:02:30 -0400
Message-ID: <51B9DF02.6040609@imgtec.com>
Date: Thu, 13 Jun 2013 16:02:26 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Saravana Kannan <skannan@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] clk: clk-mux: implement remuxing on set_rate
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com> <1369056507-32521-6-git-send-email-james.hogan@imgtec.com> <519AFBB6.90700@codeaurora.org>
In-Reply-To: <519AFBB6.90700@codeaurora.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_13_16_02_27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/05/13 05:44, Saravana Kannan wrote:
> On 05/20/2013 06:28 AM, James Hogan wrote:
>> Implement clk-mux remuxing if the CLK_SET_RATE_NO_REPARENT flag isn't
>> set. This implements determine_rate for clk-mux to propagate to each
>> parent and to choose the best one (like clk-divider this chooses the
>> parent which provides the fastest rate <= the requested rate).
>>
>> The determine_rate op is implemented as a core helper function so that
>> it can be easily used by more complex clocks which incorporate muxes.
>>
>> Signed-off-by: James Hogan <james.hogan@imgtec.com>
>> Cc: Mike Turquette <mturquette@linaro.org>
>> Cc: linux-arm-kernel@lists.infradead.org
>> ---
>> Changes in v4:
>>
>> * never pass NULL to determine_rate's best_parent_clk parameter.
>>
>> Changes in v3:
>>
>> * rename/invert CLK_SET_RATE_REMUX to CLK_SET_RATE_NO_REPARENT and move
>>    to patch 3.
>>
>>   drivers/clk/clk-mux.c        |  1 +
>>   drivers/clk/clk.c            | 49
>> ++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/clk-provider.h |  3 +++
>>   3 files changed, 53 insertions(+)
>>
>> diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
>> index 25b1734..cecfa01 100644
>> --- a/drivers/clk/clk-mux.c
>> +++ b/drivers/clk/clk-mux.c
>> @@ -100,6 +100,7 @@ static int clk_mux_set_parent(struct clk_hw *hw,
>> u8 index)
>>   const struct clk_ops clk_mux_ops = {
>>       .get_parent = clk_mux_get_parent,
>>       .set_parent = clk_mux_set_parent,
>> +    .determine_rate = __clk_mux_determine_rate,
>>   };
>>   EXPORT_SYMBOL_GPL(clk_mux_ops);
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index 3ce4810..85b661d 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -692,6 +692,55 @@ struct clk *__clk_lookup(const char *name)
>>       return NULL;
>>   }
>>
>> +/*
>> + * Helper for finding best parent to provide a given frequency. This
>> can be used
>> + * directly as a determine_rate callback (e.g. for a mux), or from a
>> more
>> + * complex clock that may combine a mux with other operations.
>> + */
>> +long __clk_mux_determine_rate(struct clk_hw *hw, unsigned long rate,
>> +                  unsigned long *best_parent_rate,
>> +                  struct clk **best_parent_p)
>> +{
>> +    struct clk *clk = hw->clk, *parent, *best_parent = NULL;
>> +    int i, num_parents;
>> +    unsigned long parent_rate, best = 0;
>> +
>> +    /* if NO_REPARENT flag set, pass through to current parent */
>> +    if (clk->flags & CLK_SET_RATE_NO_REPARENT) {
>> +        parent = clk->parent;
>> +        if (clk->flags & CLK_SET_RATE_PARENT)
>> +            best = __clk_round_rate(parent, rate);
>> +        else if (parent)
>> +            best = __clk_get_rate(parent);
>> +        else
>> +            best = __clk_get_rate(clk);
>> +        goto out;
>> +    }
>> +
>> +    /* find the parent that can provide the fastest rate <= rate */
>> +    num_parents = clk->num_parents;
>> +    for (i = 0; i < num_parents; i++) {
> 
> While writing a similar code for our internal tree, I quickly came to
> the realization that, "all parents are equal, but some are more equal
> than others". The simplest example is a clock tree like this:
> 
> Source -> Divider -> Mux
> Source -> Mux
> 
> A rate of Y can be achieved for Mux by either running Source at Y and
> picking that input or running Source at Y * 2 and Divider set to div-2
> and picking the Divider input.
> 
> The solution seems to be a priority list of parents. I'm sure there
> would be other reason (jitter, clock quality, etc) for a mux to pick one
> parent vs. another when both of them can provide the required rate.
> 
> I think this loop should loop over parents based on their priority
> order. So, parents should become a struct of { clk, index } and have the
> parents listed in the order of priority. Well, at least in that long run
> that would be better to avoid messing up parent/index values. But for
> now, you could just have a priority array of index or parents.
> 
> It might not fit 100% of the cases where two parents can provide the
> same rate, but it should fit most use cases.

Sorry for the delay replying.

What you say sounds reasonable. As Stephen Boyd suggested though, I'd
like to omit this from this patchset as its something that can be
tackled later.

Cheers
James

