Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029Ab3GSSwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:52:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47740 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3GSSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:52:30 -0400
Message-ID: <51E98AEC.5000802@wwwdotorg.org>
Date: Fri, 19 Jul 2013 12:52:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
References: <20130716090310.5541.36777.stgit@localhost> <20130716090536.5541.36289.stgit@localhost> <51E70953.1000601@wwwdotorg.org> <20130718072034.GO7656@atomide.com> <51E8401E.8040705@wwwdotorg.org> <20130719072927.GY7656@atomide.com>
In-Reply-To: <20130719072927.GY7656@atomide.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 01:29 AM, Tony Lindgren wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [130718 12:27]:
>> On 07/18/2013 01:25 AM, Tony Lindgren wrote:
>>> * Stephen Warren <swarren@wwwdotorg.org> [130717 14:21]:
>>>> On 07/16/2013 03:05 AM, Tony Lindgren wrote:
>>>>> To toggle dynamic states, let's add the optional active state in
>>>>> addition to the static default state. Then if the optional active
>>>>> state is defined, we can require that idle and sleep states cover
>>>>> the same pingroups as the active state.
>>>>>
>>>>> Then let's add pinctrl_check_dynamic() and pinctrl_select_dynamic()
>>>>> to use instead of pinctrl_select() to avoid breaking existing users.
>>>>>
>>>>> With pinctrl_check_dynamic() we can check that idle and sleep states
>>>>> match the active state for pingroups during init, and don't need to
>>>>> do it during runtime.
>>>>>
>>>>> Then with the states pre-validated, pinctrl_select_dynamic() can
>>>>> just toggle between the dynamic states without extra checks.
>>>>>
>>>>> Note that pinctr_select_state() still has valid use cases, such as
>>>>> changing states when the pins can be shared between two drivers
>>>>> and don't necessarily cover the same pingroups. For dynamic runtime
>>>>> toggling of pin states, we should eventually always use just
>>>>> pinctrl_select_dynamic().
>>
>>>>> @@ -1241,7 +1371,13 @@ static int pinctrl_pm_select_state(struct device *dev, struct pinctrl_state *sta
>>>>>  		return 0;
>>>>>  	if (IS_ERR(state))
>>>>>  		return 0; /* No such state */
>>>>> -	ret = pinctrl_select_state(pins->p, state);
>>>>> +
>>>>> +	/* Configured for proper dynamic muxing? */
>>>>> +	if (!IS_ERR(dev->pins->active_state))
>>>>> +		ret = pinctrl_select_dynamic(pins->p, state);
>>>>> +	else
>>>>> +		ret = pinctrl_select_state(pins->p, state);
>>>>
>>>> Hmmm. I'm not quite sure this is right... Surely this function should
>>>> just do nothing if the dynamic states aren't defined? The system should
>>>> just, and only, be in the "default" state and never do anything else.
>>>
>>> This keeps the existing behaviour. We should be able to drop the
>>> call to pinctrl_select_state() here after the existing use in
>>> drivers has been fixed.
>>
>> How many DT-based systems already have multiple of default/idle/sleep
>> states defined in DT? Right now, since the kernel code uses
>> pinctrl_select_state() to switch between those, the state definitions
>> need to define /all/ pins used by those states, not just the dynamic
>> ones. However, with this series in place, the default state should only
>> include the static pins, and the active/idle/sleep states should only
>> include the dynamic pins. That's a change to the DT bindings, since it
>> changes how the DT must be written, and causes older DTs to be
>> incompatible with newer kernels and vice-versa.
> 
> Well we can keep the current behaviour with pinctrl_select_state() around
> as long as needed. For the legacy cases, there is no active state defined
> and we fall back to pinctrl_select_state().
>  
>> So, do we just ignore this DT ABI change again, or insist on doing it in
>> some compatible way? DT ABI-ness is a PITA:-(
> 
> I'd vote for keeping the existing behaviour with pinctrl_select_state()
> when no active state is defined.

Yes, I think that will work, since the active state cannot exist before
this new scheme is in place.

But, this needs to be very clearly spell out in the DT binding
documentation: If you have states default/idle/sleep, they're complete
alternatives, whereas if you have states default/active/idle/sleep, the
latter 3 are alternatives that build on top of the first. I foresee mass
confusion, but perhaps I'm being pessimistic.
