Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaEWQPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:15:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39202 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaEWQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:15:08 -0400
Message-ID: <537F7407.5080404@wwwdotorg.org>
Date: Fri, 23 May 2014 10:15:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: FanWu <fwu@marvell.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH v2] pinctrl: add params in disable_setting for different
 usage
References: <1400728210-17863-1-git-send-email-fwu@marvell.com> <537E848C.5010204@wwwdotorg.org> <537EAA46.8010409@marvell.com>
In-Reply-To: <537EAA46.8010409@marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 07:54 PM, FanWu wrote:
> On 05/23/2014 07:13 AM, Stephen Warren wrote:
>> On 05/21/2014 09:10 PM, fwu@marvell.com wrote:
>>> From: Fan Wu <fwu@marvell.com>
>>>
>>> What the patch did:
>>> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in
>>> each time of
>>>    calling pinctrl_select_state
>>> 2.Remove the HW disable operation in in pinmux_disable_setting function.
>>>
>> ...
>>> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
>>> index c0fe609..c97491a 100644
>>> --- a/drivers/pinctrl/core.c
>>> +++ b/drivers/pinctrl/core.c
>>> @@ -993,25 +993,13 @@ int pinctrl_select_state(struct pinctrl *p,
>>> struct pinctrl_state *state)
>>>            * may not be identical to the set of groups with a mux setting
>>>            * in the new state. While this might be unusual, it's entirely
>>>            * possible for the "user"-supplied mapping table to be written
>>> -         * that way. For each group that was configured in the old state
>>> -         * but not in the new state, this code puts that group into a
>>> -         * safe/disabled state.
>>> +         * that way. This code is used for each group that was
>>> +         * configured in the old state but not in the new state
>>
>>
>> Looking at the code, it's run for every group in the state, not "each
>> group that was configured in the old state but not in the new state"

> For you question 1:
> The disable_pinmux_setting is for the all of the setting in old state.
> This is what we really need to do, ahead of enable setting in new state.
> In the first patch I filed, which still includes the HW ops in
> disable_pinmux_setting, to disable each setting in old state and then to
> enable the setting in new state will introduce HW glitch.
> But in the current solution, the glitch will not be there, because there
> is no HW ops in disable_pinmux_setting.
> And please notice the patch is mainly used to avoid the duplicated
> enable operation for the same pin.

I think you missed the point of my comment. I think the new comment text
is incorrect. Instead, how about replacing the entire comment with:

/*
 * For each pinmux setting in the old state, forget SW's record of mux
 * owner for that pingroup. Any pingroups which are still owned by the
 * new state will be re-acquired by the call to pinmux_enable_setting()
 * in the loop below.
 */

>>> @@ -515,9 +514,6 @@ void pinmux_disable_setting(struct
>>> pinctrl_setting const *setting)
>>>                    pins[i], desc->name, gname);
>>>           }
>>>       }
>>> -
>>> -    if (ops->disable)
>>> -        ops->disable(pctldev, setting->data.mux.func,
>>> setting->data.mux.group);
>>>   }
>>
>> Should that op be removed from the header file and all drivers too?

> For your question 2:
> the pinctrl-single driver is still using ops->disable, if I remove the
> "disable" in ops, there will be build error in the vendor's code base
> who is using pinctrl-single driver.

I thought Tony said it was fine to simply remove pinctrl-single's
ops->disable code completeley.

> Just as I said in the last mail,
> the next plan for this topic:
> 
> 1. To remove the disable ops registration when defining the
> "include/linux/pinctrl/pinmux.h" in inctrl-single driver.
> Meanwhile, the related things, like "pinctrl-single,function-off"
> property and corresponding flag in "pcs_device", will be also removed.
> 
> 2. To remove the disable ops in "pinmux_ops" in the file of
> include/linux/pinctrl/pinmux.h
> 
> Are you OK for this ?

I guess splitting that into separate patches is fine.
