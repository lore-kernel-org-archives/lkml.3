Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbbAISvn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:51:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42794 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbbAISvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:51:42 -0500
Message-ID: <54B0233C.60201@codeaurora.org>
Date: Fri, 09 Jan 2015 10:51:40 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] clk: Do not complain about correctly set read-only
 muxes when assigning clock parents from device tree
References: <1420559120-17405-1-git-send-email-p.zabel@pengutronix.de>	 <54AEF788.3060401@codeaurora.org> <1420815016.3914.16.camel@pengutronix.de>
In-Reply-To: <1420815016.3914.16.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 06:50 AM, Philipp Zabel wrote:
> Hi Stephen,
>
> Am Donnerstag, den 08.01.2015, 13:32 -0800 schrieb Stephen Boyd:
> [...]
>> Why not do this in the core? As far as I can tell other drivers could
>> run into the same problem, no? Does this work?
>>
>> -----8<-------
>>
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index f4963b7d4e17..3278645f4729 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -1677,16 +1677,18 @@ int clk_set_parent(struct clk *clk, struct clk *parent)
>>  	if (!clk)
>>  		return 0;
>>  
>> -	/* verify ops for for multi-parent clks */
>> -	if ((clk->num_parents > 1) && (!clk->ops->set_parent))
>> -		return -ENOSYS;
>> -
>>  	/* prevent racing with updates to the clock topology */
>>  	clk_prepare_lock();
>>  
>>  	if (clk->parent == parent)
>>  		goto out;
>>  
>> +	/* verify ops for for multi-parent clks */
>> +	if ((clk->num_parents > 1) && (!clk->ops->set_parent)) {
>> +		ret = -ENOSYS;
>> +		goto out;
>> +	}
>> +
>>  	/* check that we are allowed to re-parent if the clock is in use */
>>  	if ((clk->flags & CLK_SET_PARENT_GATE) && clk->prepare_count) {
>>  		ret = -EBUSY;
> "[PATCH] clk: make set_parent succeed for any clock if the parent to be
> set is the same as the current parent" ?
>
> It works, but it also changes the API, as it makes
>    clk_set_parent(some_non_mux, its_current_parent)
> succeed instead of return -ENOSYS.

I would think a non_mux clk would have clk->num_parents == 1, so I don't
see how it would return -ENOSYS here. What you mention should succeed
today. Otherwise we have a bug.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

