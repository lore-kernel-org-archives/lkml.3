Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbaDKNfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 09:35:15 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:46245 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522AbaDKNfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 09:35:12 -0400
Message-ID: <5347EF8A.8040600@gmail.com>
Date: Fri, 11 Apr 2014 15:35:06 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>
CC: linus.walleij@linaro.org, alexandre.belloni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/5] pinctrl: berlin: add a pinctrl driver for
 Marvell Berlin SoCs
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com> <1397135274-10764-3-git-send-email-antoine.tenart@free-electrons.com> <5347AFF4.3050607@gmail.com> <20140411123737.GA5903@kwain>
In-Reply-To: <20140411123737.GA5903@kwain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 02:37 PM, Antoine Ténart wrote:
> On Fri, Apr 11, 2014 at 11:03:48AM +0200, Sebastian Hesselbarth wrote:
>> On 04/10/2014 03:07 PM, Antoine Ténart wrote:
>>> The Marvell Berlin boards have a group based pinmuxing mechanism. This
>>> driver adds the support for the BG2CD, BG2 and BG2Q. We actually do not
>>> need any information about the pins here and only have the definition
>>> of the groups.
>>
[...]
>>> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
>>> index 4b835880cf80..fd5a01d4475f 100644
>>> --- a/drivers/pinctrl/Makefile
>>> +++ b/drivers/pinctrl/Makefile
>>> @@ -21,6 +21,7 @@ obj-$(CONFIG_PINCTRL_BF60x)	+= pinctrl-adi2-bf60x.o
>>>   obj-$(CONFIG_PINCTRL_AT91)	+= pinctrl-at91.o
>>>   obj-$(CONFIG_PINCTRL_BCM2835)	+= pinctrl-bcm2835.o
>>>   obj-$(CONFIG_PINCTRL_BAYTRAIL)	+= pinctrl-baytrail.o
>>> +obj-$(CONFIG_PINCTRL_BERLIN)	+= pinctrl-berlin.o
>>
>> Please split the driver into common and soc-specific parts, and if
>> you do please put it into a subfolder berlin, too.
>
> The only SoC specific part is the group structure. I'll need to have
> functions in each SoC specific part calling ... only the common ones.
> Do you have a better solution in mind ?

We have a similar structure for mvebu, control is common, structure is
not. You'll have one common driver to register pinctrl and switch a
specific mux, and one file for each SoC holding the group structure
and function table.

If bg2 and bg2cd have the same group layout but different functions
assigned to it, you can either strictly separate by SoC or separate
by similarity. Have a look at e.g. pinctrl/mvebu/pinctrl-kirkwood.c,
although SoCs are different with respect to individual functions, we
have a variant mask to determine if a specific function is available
on that SoC.

But if bg2 and bg2cd are _very_ different from the functions assigned
to each group, I'd rather have two separate files, too.

Basically, folder structure will look like this:
drivers/pinctrl
   +- berlin/
      +- common.c : common code (pinctrl register, pinmux)
      +- common.h : common include (group structure, common callbacks)
      +- bg2.c    : BG2 specific group/function tables
      +- bg2cd.c  : BG2CD specific group/function tables
      +- bg2q.c   : BG2Q specific group/function tables
      +- ...

(BTW, as we know we are beneath drivers/pinctrl, drop the pinctrl-
prefix)

If we consider bg2cd as a variant of bg2, join the two files above
and have a variant mask as we have for Kirkwood.

[...]
>>> +	function_name = kzalloc(strlen(group_name) + 7, GFP_KERNEL);
>>> +	if (!function_name)
>>> +		return -ENOMEM;
>>> +	snprintf(function_name, strlen(group_name) + 7, "%s_mode%d", group_name,
>>> +			function);
>>
>> With proper mode tables above, this can refer to a const char* and you
>> can get rid of allocation here. Also, below you already allocated
>> function_names, how is this one different from the below?
>
> The one below is used to describe the available functions for a given group
> while this one describe a function found in the device tree. It is used to check
> the function we want to use in the device is provided by the driver. The

Ah, ok. With numeric values for marvell,function and proper function 
tables for each of the groups, you can just look up the group and loop
over the available functions. Or if you prefer strings, give a proper
name to each function in the table and use that string as DT match.

> function name used here may not actually exist. We could check the function
> actually exists here (and find the previously allocated function name), but this
> check is handled by the pinctrl framework. This would end up in a different
> behaviour than the expected one, imho.
[...]
>>> +static int berlin_pinctrl_build_state(struct platform_device *pdev,
>>> +			      struct berlin_pinctrl_reg_base *bases,
>>> +			      unsigned nbases)
>>> +{
>>> +	struct berlin_pinctrl *pctrl = platform_get_drvdata(pdev);
>>> +	int i, j, cur_fct = 0;
>>> +
>>> +	pctrl->ngroups = pctrl->desc->ngroups;
>>> +	pctrl->nfunctions = 0;
>>> +
>>> +	for (i = 0; i < pctrl->ngroups; i++) {
>>> +		struct berlin_desc_group const *desc = pctrl->desc->groups + i;
>>> +		pctrl->nfunctions += NFCTS(desc->bit_width);
>>> +	}
>>
>> As you need desc later on, make it global to this function. Then you
>> can also walk through it with desc++
>>
>> desc = pctrl->desc->groups;
>> for (i = 0; i < pctl->ngroups; i++, desc++)
>> 	pctrl->nfunctions = ...
>>
>> Having said that, the above assumes that each function is unique
>> but IIRC the idea of the function table was to group pins/groups
>> with the same function, e.g. function "gpio", groups 1,7,25,...
>
> Most of the functions you can use on the Berlin they will be unique and would
> only be used in one group, except for the 'gpio' one.

Yeah, I had a similar discussion about it back then for mvebu. IIRC, the
correct answer is: Have a list of functions with groups assigned to it
no matter if there is only one group per function (or 40 per function as
it will be for gpio).

Maybe Linus can give an update on how to deal with it?

Sebastian

