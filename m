Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbaIWNiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:38:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:47609 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbaIWNiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:38:18 -0400
Message-ID: <542177E5.9060606@ti.com>
Date: Tue, 23 Sep 2014 16:38:45 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <tony@atomide.com>, <nm@ti.com>, <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: prevent erronous parsing of children during rate
 change
References: <1408628866-32351-1-git-send-email-t-kristo@ti.com> <20140922191816.GF10233@codeaurora.org>
In-Reply-To: <20140922191816.GF10233@codeaurora.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 10:18 PM, Stephen Boyd wrote:
> On 08/21, Tero Kristo wrote:
>> In some cases, clocks can switch their parent with clk_set_rate, for
>> example clk_mux can do this in some cases. Current implementation of
>> clk_change_rate uses un-safe list iteration on the clock children, which
>> will cause wrong clocks to be parsed in case any of the clock children
>> change their parents during the change rate operation. Fixed by using
>> the safe list iterator instead.
>>
>> The problem was detected due to some divide by zero errors generated
>> by clock init on dra7-evm board, see discussion under
>> http://article.gmane.org/gmane.linux.ports.arm.kernel/349180 for details.
>>
>> Signed-off-by: Tero Kristo <t-kristo@ti.com>
>> To: Mike Turquette <mturquette@linaro.org>
>> Reported-by: Nishanth Menon <nm@ti.com>
>> ---
>>   drivers/clk/clk.c |    7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index b76fa69..bacc06f 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -1467,6 +1467,7 @@ static struct clk *clk_propagate_rate_change(struct clk *clk, unsigned long even
>>   static void clk_change_rate(struct clk *clk)
>>   {
>>   	struct clk *child;
>> +	struct hlist_node *tmp;
>>   	unsigned long old_rate;
>>   	unsigned long best_parent_rate = 0;
>>   	bool skip_set_rate = false;
>> @@ -1502,7 +1503,11 @@ static void clk_change_rate(struct clk *clk)
>>   	if (clk->notifier_count && old_rate != clk->rate)
>>   		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
>>
>> -	hlist_for_each_entry(child, &clk->children, child_node) {
>> +	/*
>> +	 * Use safe iteration, as change_rate can actually swap parents
>> +	 * for certain clock types.
>> +	 */
>> +	hlist_for_each_entry_safe(child, tmp, &clk->children, child_node) {
>>   		/* Skip children who will be reparented to another clock */
>>   		if (child->new_parent && child->new_parent != clk)
>>   			continue;
>
> Are we not hitting the new_parent check here? I don't understand
> how we can be changing parents here unless the check is being
> avoided, in which case I wonder why determine_rate isn't being
> used.
>

It depends how the clock underneath handles the situation. The error I 
am seeing actually happens with a SoC specific compound clock (DPLL) 
which integrates set_rate + mux functionality into a single clock node. 
A call to the clk_set_rate changes the parent of this clock (from bypass 
clock to reference clock), in addition to changing the rate (tune the 
mul+div.) I looked at using the determine rate call with this type but 
it breaks everything up... the parent gets changed but not the clock 
rate, in addition to some other issues.

-Tero
