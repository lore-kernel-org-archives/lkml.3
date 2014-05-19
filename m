Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaESUzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:55:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55737 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaESUzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:55:21 -0400
Message-ID: <537A6FB5.80905@wwwdotorg.org>
Date: Mon, 19 May 2014 14:55:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: FanWu <fwu@marvell.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Chao Xie <cxie4@marvell.com>,
        Yilu Mao <ylmao@marvell.com>, Ning Jiang <njiang1@marvell.com>,
        Xiaofan Tian <tianxf@marvell.com>, Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH] pinctrl: add params in disable_setting for different
 usage
References: <1400032874-3423-1-git-send-email-fwu@marvell.com> <CACRpkdaTX_SyWXrpysaJGLee+SnLPxdQQkvE-5Xy+OmHCcseVw@mail.gmail.com> <53766CA7.8000507@wwwdotorg.org> <53797279.1010109@marvell.com>
In-Reply-To: <53797279.1010109@marvell.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2014 08:54 PM, FanWu wrote:
> On 05/17/2014 03:53 AM, Stephen Warren wrote:
>> On 05/16/2014 10:21 AM, Linus Walleij wrote:
>>> On Wed, May 14, 2014 at 4:01 AM,  <fwu@marvell.com> wrote:
>>>
>>>> From: Fan Wu <fwu@marvell.com>
>>>>
>>>> The patch added params in disable_setting to differ the two possible
>>>> usage,
>>>> 1.Only want to disable the pin setting in SW aspect, param can be
>>>> set to "0"
>>>> 2.Want to disable the pin setting in both HW and SW aspect, param
>>>> can be set to "1";
>>>>
>>>> The reason why to do this is that:
>>>> To avoid duplicated enable_setting operation without disabling
>>>> operation which will
>>>> let Pin's desc->mux_usecount keep being added.
>>>>
>>>> In the following case, the issue can be reproduced:
>>>> 1)There is a driver need to switch Pin state dynamicly, E.g. b/t
>>>> "sleep" and
>>>> "default" state
>>>> 2)The Pin setting configuration in the two state is same, like the
>>>> following one:
>>>> component a {
>>>>          pinctrl-names = "default", "sleep";
>>>>          pinctrl-0 = <&a_grp_setting &c_grp_setting>;
>>>>          pinctrl-1 = <&b_grp_setting &c_grp_setting>;
>>>> }
>>>> The "c_grp_setting" config node is totaly same, maybe like following
>>>> one:
>>>
>>> Hm this is a quite interesting thing if we can get it in place, but
>>> I need Stephen's consent, also Tony should have a look at this as
>>> I know he's had the same problem as you in pinctrl-single.
>>
>> I only briefly looked at the patch, but it probably solves/hides the
>> immediate problem.
>>
>> However, rather than doing this, why not just remove
>> pinmux_disable_setting() completely. It doesn't make sense to "disable a
>> mux selection" (some value is always selected in the mux register field)
>> any more than it does to "disable a drive strength selection". We don't
>> have a pinconf_disable_setting(), and couldn't really add one if we
>> wanted. For consistency, let's just remove pinmux_disable_setting(). Do
>> you agree?
>>
> 
> Dear, Stephen and Guys,
> 
> Sorry for late due to some personal affairs in Weekend time.
> 
> I don't think it is a proper way to remove pinmux_disable_setting
> directly without changing any other code, like no change on the code in
> pinmux_enable_setting.
> 
> Talking about the pinmux_disable_operation, in SW aspect, we also need
> to consider the "pinmux_enable_setting" operation.
> For the "pinmux_enable_setting" operation, there is some SW level code
> logic, like pin_request.
> Do you think it is a acceptable way to remove the SW level code logic
> from the "pinmux_enable_setting" path, because there will be no
> corresponding operation in reverse order in pinmux_disable_setting after
> applying our possible change?

No, I don't think we should remove the SW aspects of
pinmux_enable_setting(). The pinctrl core currently tracks which pinctrl
state "owns" each pingroup's mux, so that different pinctrl states can't
both attempt to configure a pingroup's mux setting. We need to keep all
the SW aspects of mux enable/disable. All I'm proposing removing is the
HW-programming parts of pinmux_disable_setting().

> At least, I think this way may be a considerable change in Pinmux
> framework, right?

Yes, removing all of pinmux_en/disable_setting would be a considerable
and likely inappropriate change.

> Talking about HW aspect,
> I think the solution you mentioned is indeed a good way to solve the
> problem for some HW vendor's SoC chip, but may be not that intact solution.
> 
> In my understanding, the pinmux operation, like enabling and disabling,
> is to change pin's(pins') multi-function from funcion_M to function_N.
> And, the "pinconf" enabling function is used to change the attributes of
> the pin, like Pull_Up/Down, DriveStrength(Low/Medium/Fast) and etc.
> 
> The pinmux disabling operation will be called in the following case in
> current pinmux framework:
> 1. when pin(s) is/are freed or error handler when configure it(them) and
> finally the pin will be changed to a disabled/safe state if defined by
> vendor.
> 2. in the pinctrl_select_state function
> 
> The item 2# is just the thing we talked about in this loop and we reach
> agreement that the item 2# is not useful.
> 
> I think the item 1# is still useful for some vendor if they defined the
> disabled/safe multi-function for a pin. They may expect the pin is
> changed to the disabled/safe state for saving power or some security
> reason.

The only time item #1 above would happen is an error case. If there's an
error, there shouldn't be any expectation for the specific state of the
pinmux. If this intermediate state is illegal, then that's a problem in
an of itself; the HW is going to be in that state for some (admittedly
small) amount of time while the pinmux is being programmed, error or no
error, hence all the intermediate states had better be legal. I think
it's fine if the HW programming is simply left in whatever partial state
the code managed to get to. It's quite unlikely there's any "safe" state
that's /meaningfully/ better for a pin to be in once an error is detected.

> Thus, I think we should keep the disable_pinmux_setting in pinmux code.
> 
> Do you think what I mentioned is an acceptable and not that aggressive
> solution?

Not really.

> Please correct me if anything wrong.
> 
> 
> 
> For another topics:
> 1. There is no disable_pinconf: I think this is a issue. When the pin's
> mux setting is changed, the pinconf setting should also be changed, at
> least, the pinmux code here should offer the user a chance(interface) to
> decide whether to change the pinconf setting. Thus, we may need to add
> pinconf disable function.

pinctrl already allows any config options to be changed along with the
mux option.

The only reason any mux or config option is ever changed is in response
to selecting a new pinctrl state. Hence, I don't think you ever want to
"disable" either a mux or config option. Rather, you simply want to
"enable" or "select" or "program" the mux/config options in the new
state. Any mux/config option that needs to differ between states should
simply be listed in all the states, so that when the state is entered,
the appropriate HW programming is performed.

> 2. If the vendor use pinctrl-single driver, the
> "pinctrl-single,function-off" implementation is not useful in practical
> usage. The "pinctrl-single,function-off" is parsed when pinctrl-single
> driver probe phase and the instance setting of
> "pinctrl-single,function-off" will be used for all pins setting.
> Practically, I think different pins may have different disabled/safe.

I'm not sure what you're asking here.

