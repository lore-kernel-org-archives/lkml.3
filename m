Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015Ab3B1SUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:20:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:45823 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3B1SUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:20:35 -0500
Message-ID: <512F9FEF.4010304@wwwdotorg.org>
Date: Thu, 28 Feb 2013 11:20:31 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: Tomasz Figa <t.figa@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] clk: Add composite clock type
References: <1359965482-29655-1-git-send-email-pgaikwad@nvidia.com> <2204463.8bhhYZbxqK@amdc1227> <5111C840.3000003@nvidia.com> <1405953.njFh3JJd1A@amdc1227> <512F0E2F.4000104@nvidia.com>
In-Reply-To: <512F0E2F.4000104@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 12:58 AM, Prashant Gaikwad wrote:
> On Wednesday 06 February 2013 03:36 PM, Tomasz Figa wrote:
>> On Wednesday 06 of February 2013 08:34:32 Prashant Gaikwad wrote:
>>> On Tuesday 05 February 2013 03:45 PM, Tomasz Figa wrote:
>>>> Hi Prashant,
>>>>
>>>> Thank you for your patch. Please see some comments inline.
>>>>
>>>> On Monday 04 of February 2013 13:41:22 Prashant Gaikwad wrote:
>>>>> Not all clocks are required to be decomposed into basic clock
>>>>> types but at the same time want to use the functionality
>>>>> provided by these basic clock types instead of duplicating.
>>>>>
>>>>> For example, Tegra SoC has ~100 clocks which can be decomposed
>>>>> into Mux -> Div -> Gate clock types making the clock count to
>>>>> ~300. Also, parent change operation can not be performed on gate
>>>>> clock which forces to use mux clock in driver if want to change
>>>>> the parent.
>>>>>
>>>>> Instead aggregate the basic clock types functionality into one
>>>>> clock and just use this clock for all operations. This clock
>>>>> type re-uses the functionality of basic clock types and not
>>>>> limited to basic clock types but any hardware-specific
>>>>> implementation.

>>>>> diff --git a/drivers/clk/clk-composite.c

>>>>> +static u8 clk_composite_get_parent(struct clk_hw *hw)
>>>>> +{
>>>>> +     struct clk_composite *composite = to_clk_composite(hw);
>>>>> +     const struct clk_ops *mux_ops = composite->mux_ops;
>>>>> +     struct clk_hw *mux_hw = composite->mux_hw;
>>>>> +
>>>>> +     mux_hw->clk = hw->clk;
>>>>
>>>> Why is this needed? Looks like this filed is already being initialized
>>>> in clk_register_composite.
>>>
>>> Some ops will get called during clk_init where this clk is not populated
>>> hence doing here. I have done it for all ops to make sure that any
>>> future change in clock framework don't break this clock.
>>> Now, why duplicate it in clk_register_composite? It is possible that
>>> none of these ops get called in clk_init.
>>> For example, recalc_rate is called during init and this ops is supported
>>> by div clock type, but what if div clock is not added.
>>>
>>> I hope this explains the need.
>>
>> Sorry, I don't understand your explanation.
>>
>> I have asked why mux_hw->clk field has to be reinitialized in all the
>> ops.
>>
>> In other words, is it even possible that this clk pointer changes since
>> calling clk_register from clk_register_composite and if yes, why?
> 
> Tomasz,
> 
> calling sequence is as
> 
> clk_register(struct clk_hw *hw)
>     clk_init(struct clk_hw *hw)
>         .
>         .
>         hw->clk = clk;
>         clk->ops.recalc_rate(hw) => clk_composite_recalc_rate(hw) =>
> composite->div_ops.recalc_rate(div_hw) => clk_divider_recalc_rate(hw)
> 
> Now if clk_divider_recalc_rate tries to access clk from hw then it will
> get NULL since this is not assigned yet and that is what I am doing in
> clk_composite_recalc_rate.
> 
> I am doing it in all ops because I can not assume which one will get
> called first and always. If in future something changes the calling
> sequence in ccf framework then it will break this clock.

Surely the CCF core should be taking care of this as part of
clk_register() or clk_init()?
