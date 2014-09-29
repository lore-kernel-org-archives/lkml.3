Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaI2IIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 04:08:44 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40780 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaI2IIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 04:08:42 -0400
Message-ID: <542913B4.2020808@ti.com>
Date: Mon, 29 Sep 2014 11:09:24 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <tony@atomide.com>, <nm@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: prevent erronous parsing of children during rate
 change
References: <1408628866-32351-1-git-send-email-t-kristo@ti.com> <20140922191816.GF10233@codeaurora.org> <542177E5.9060606@ti.com> <5424C2FA.4000508@codeaurora.org> <5425135F.2070809@ti.com> <20140926232453.19023.25483@quantum>
In-Reply-To: <20140926232453.19023.25483@quantum>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2014 02:24 AM, Mike Turquette wrote:
> Quoting Tero Kristo (2014-09-26 00:18:55)
>> On 09/26/2014 04:35 AM, Stephen Boyd wrote:
>>> On 09/23/14 06:38, Tero Kristo wrote:
>>>> On 09/22/2014 10:18 PM, Stephen Boyd wrote:
>>>>> On 08/21, Tero Kristo wrote:
>>>>>>             /* Skip children who will be reparented to another clock */
>>>>>>             if (child->new_parent && child->new_parent != clk)
>>>>>>                 continue;
>>>>>
>>>>> Are we not hitting the new_parent check here? I don't understand
>>>>> how we can be changing parents here unless the check is being
>>>>> avoided, in which case I wonder why determine_rate isn't being
>>>>> used.
>>>>>
>>>>
>>>> It depends how the clock underneath handles the situation. The error I
>>>> am seeing actually happens with a SoC specific compound clock (DPLL)
>>>> which integrates set_rate + mux functionality into a single clock
>>>> node. A call to the clk_set_rate changes the parent of this clock
>>>> (from bypass clock to reference clock), in addition to changing the
>>>> rate (tune the mul+div.) I looked at using the determine rate call
>>>> with this type but it breaks everything up... the parent gets changed
>>>> but not the clock rate, in addition to some other issues.
>>>
>>> Ok. Is this omap3_noncore_dpll_set_rate()?
>>
>> Yes.
>>
>>   > Can we use determine_rate +
>>> clk_set_parent_and_rate()? At least clk_set_parent_and_rate() would
>>> allow us to do the mult+div and the parent in the same op call, although
>>> I don't understand why setting the parent and then setting the rate is
>>> not going to work.
>>
>> Well, setting parent first, then rate later causes problems with the
>> DPLL ending up running with illegal (non-specified) rate, the M+N values
>> are most likely wrong if you just switch from bypass clock to reference
>> clock first without programming the M+N first.
>
> I took a quick look and it still seems to me that the OMAP DPLLs are
> still not modeled properly as mux clocks. Is this correct?

Yeah, they are not mux clocks, but rather a compound of mux + DPLL 
multiplier/divider logic. Changing the DPLL to be a separate mux + DPLL 
div/mult clock will still have overlapping usage of the DPLL_EN field, 
as the DPLL must be in bypass mode during M+N change. Or, should the 
DPLL rate change only be allowed if the mux is in bypass setting? 
Several drivers still depend on direct dpll clk_set_rate working 
'properly' (there are some other issues currently present also which 
have nothing to do with the mux behavior.)

> This issue has been lingering for a long time and we can't use
> determine_rate unless that clock has multiple parents. Simply hacking
> knowledge of the parent bypass clock into the .set_rate callback is not
> enough.

If you believe this _must_ be changed, I can take a look at this for 
next merge window, but this will cause a DT data compatibility break if 
nothing else (personally I don't care about this as I always rebuild DT 
blob with kernel, but lots of other people seem to do.)

-Tero

>
> Regards,
> Mike
>
>>
>>    I'm interested in the other issues that you mentioned
>>> too.
>>
>> Mostly these were side-effects from the illegal DPLL setup I guess, like
>> boot hang, failed drivers etc. I didn't really investigate this that
>> much as it is much more simpler just to use safe list iteration here.
>>
>> -Tero

