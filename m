Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaESCzL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:55:11 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38992 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbaESCzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:55:09 -0400
Message-ID: <53797279.1010109@marvell.com>
Date: Mon, 19 May 2014 10:54:49 +0800
From: FanWu <fwu@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Chao Xie <cxie4@marvell.com>,
        Yilu Mao <ylmao@marvell.com>, Ning Jiang <njiang1@marvell.com>,
        Xiaofan Tian <tianxf@marvell.com>, Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH] pinctrl: add params in disable_setting for different
 usage
References: <1400032874-3423-1-git-send-email-fwu@marvell.com> <CACRpkdaTX_SyWXrpysaJGLee+SnLPxdQQkvE-5Xy+OmHCcseVw@mail.gmail.com> <53766CA7.8000507@wwwdotorg.org>
In-Reply-To: <53766CA7.8000507@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-18_03:2014-05-17,2014-05-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405190041
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2014 03:53 AM, Stephen Warren wrote:
> On 05/16/2014 10:21 AM, Linus Walleij wrote:
>> On Wed, May 14, 2014 at 4:01 AM,  <fwu@marvell.com> wrote:
>>
>>> From: Fan Wu <fwu@marvell.com>
>>>
>>> The patch added params in disable_setting to differ the two possible usage,
>>> 1.Only want to disable the pin setting in SW aspect, param can be set to "0"
>>> 2.Want to disable the pin setting in both HW and SW aspect, param can be set to "1";
>>>
>>> The reason why to do this is that:
>>> To avoid duplicated enable_setting operation without disabling operation which will
>>> let Pin's desc->mux_usecount keep being added.
>>>
>>> In the following case, the issue can be reproduced:
>>> 1)There is a driver need to switch Pin state dynamicly, E.g. b/t "sleep" and
>>> "default" state
>>> 2)The Pin setting configuration in the two state is same, like the following one:
>>> component a {
>>>          pinctrl-names = "default", "sleep";
>>>          pinctrl-0 = <&a_grp_setting &c_grp_setting>;
>>>          pinctrl-1 = <&b_grp_setting &c_grp_setting>;
>>> }
>>> The "c_grp_setting" config node is totaly same, maybe like following one:
>>
>> Hm this is a quite interesting thing if we can get it in place, but
>> I need Stephen's consent, also Tony should have a look at this as
>> I know he's had the same problem as you in pinctrl-single.
>
> I only briefly looked at the patch, but it probably solves/hides the
> immediate problem.
>
> However, rather than doing this, why not just remove
> pinmux_disable_setting() completely. It doesn't make sense to "disable a
> mux selection" (some value is always selected in the mux register field)
> any more than it does to "disable a drive strength selection". We don't
> have a pinconf_disable_setting(), and couldn't really add one if we
> wanted. For consistency, let's just remove pinmux_disable_setting(). Do
> you agree?
>

Dear, Stephen and Guys,

Sorry for late due to some personal affairs in Weekend time.

I don't think it is a proper way to remove pinmux_disable_setting 
directly without changing any other code, like no change on the code in 
pinmux_enable_setting.

Talking about the pinmux_disable_operation, in SW aspect, we also need 
to consider the "pinmux_enable_setting" operation.
For the "pinmux_enable_setting" operation, there is some SW level code 
logic, like pin_request.
Do you think it is a acceptable way to remove the SW level code logic 
from the "pinmux_enable_setting" path, because there will be no 
corresponding operation in reverse order in pinmux_disable_setting after 
applying our possible change?
At least, I think this way may be a considerable change in Pinmux 
framework, right?

Talking about HW aspect,
I think the solution you mentioned is indeed a good way to solve the 
problem for some HW vendor's SoC chip, but may be not that intact solution.

In my understanding, the pinmux operation, like enabling and disabling, 
is to change pin's(pins') multi-function from funcion_M to function_N.
And, the "pinconf" enabling function is used to change the attributes of 
the pin, like Pull_Up/Down, DriveStrength(Low/Medium/Fast) and etc.

The pinmux disabling operation will be called in the following case in 
current pinmux framework:
1. when pin(s) is/are freed or error handler when configure it(them) and 
finally the pin will be changed to a disabled/safe state if defined by 
vendor.
2. in the pinctrl_select_state function

The item 2# is just the thing we talked about in this loop and we reach 
agreement that the item 2# is not useful.

I think the item 1# is still useful for some vendor if they defined the 
disabled/safe multi-function for a pin. They may expect the pin is 
changed to the disabled/safe state for saving power or some security 
reason.

Thus, I think we should keep the disable_pinmux_setting in pinmux code.

Do you think what I mentioned is an acceptable and not that aggressive 
solution?

Please correct me if anything wrong.



For another topics:
1. There is no disable_pinconf: I think this is a issue. When the pin's 
mux setting is changed, the pinconf setting should also be changed, at 
least, the pinmux code here should offer the user a chance(interface) to 
decide whether to change the pinconf setting. Thus, we may need to add 
pinconf disable function.
2. If the vendor use pinctrl-single driver, the 
"pinctrl-single,function-off" implementation is not useful in practical 
usage. The "pinctrl-single,function-off" is parsed when pinctrl-single 
driver probe phase and the instance setting of 
"pinctrl-single,function-off" will be used for all pins setting. 
Practically, I think different pins may have different disabled/safe.

Great thanks for this long term discussion :)



