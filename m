Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaESIIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 04:08:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54137 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaESIII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 04:08:08 -0400
Message-ID: <5379BC0C.3070401@ti.com>
Date: Mon, 19 May 2014 11:08:44 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
CC: Mike Turquette <mturquette@linaro.org>, <kernel-janitors@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, J Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH 3/13] CLK: TI: DRA7: make return of 0 explicit
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr> <1400473875-22228-4-git-send-email-Julia.Lawall@lip6.fr> <20140519074155.GO15585@mwanda>
In-Reply-To: <20140519074155.GO15585@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 10:41 AM, Dan Carpenter wrote:
> This one does feel like a bug in the original code as you mention.  I
> have added the TI devs to the CC list so they can help us.

Yes this is a bug, the dra7_apll_enable() should return some sort of 
error code if the lock fails. EBUSY maybe?

-Tero

>
> regards,
> dan carpenter
>
> On Mon, May 19, 2014 at 06:31:05AM +0200, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Delete unnecessary local variable whose value is always 0 and that hides
>> the fact that the result is always 0.
>>
>> Additionally dropped some unneeded braces in an affected if.
>>
>> A simplified version of the semantic patch that fixes this problem is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @r exists@
>> local idexpression ret;
>> expression e;
>> position p;
>> @@
>>
>> -ret = 0;
>> ... when != ret = e
>> return
>> - ret
>> + 0
>>    ;
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> ---
>> Alternatively, is an error code wanted in either of the MAX_APLL_WAIT_TRIES
>> cases?
>>
>>   drivers/clk/ti/apll.c |   13 +++++--------
>>   1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
>> index b986f61..659032a 100644
>> --- a/drivers/clk/ti/apll.c
>> +++ b/drivers/clk/ti/apll.c
>> @@ -37,7 +37,7 @@
>>   static int dra7_apll_enable(struct clk_hw *hw)
>>   {
>>   	struct clk_hw_omap *clk = to_clk_hw_omap(hw);
>> -	int r = 0, i = 0;
>> +	int i = 0;
>>   	struct dpll_data *ad;
>>   	const char *clk_name;
>>   	u8 state = 1;
>> @@ -55,7 +55,7 @@ static int dra7_apll_enable(struct clk_hw *hw)
>>   	v = ti_clk_ll_ops->clk_readl(ad->idlest_reg);
>>
>>   	if ((v & ad->idlest_mask) == state)
>> -		return r;
>> +		return 0;
>>
>>   	v = ti_clk_ll_ops->clk_readl(ad->control_reg);
>>   	v &= ~ad->enable_mask;
>> @@ -74,17 +74,14 @@ static int dra7_apll_enable(struct clk_hw *hw)
>>   		udelay(1);
>>   	}
>>
>> -	if (i == MAX_APLL_WAIT_TRIES) {
>> +	if (i == MAX_APLL_WAIT_TRIES)
>>   		pr_warn("clock: %s failed transition to '%s'\n",
>>   			clk_name, (state) ? "locked" : "bypassed");
>> -	} else {
>> +	else
>>   		pr_debug("clock: %s transition to '%s' in %d loops\n",
>>   			 clk_name, (state) ? "locked" : "bypassed", i);
>>
>> -		r = 0;
>> -	}
>> -
>> -	return r;
>> +	return 0;
>>   }
>>
>>   static void dra7_apll_disable(struct clk_hw *hw)
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

