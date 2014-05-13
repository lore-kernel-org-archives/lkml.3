Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaEMFx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:53:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36824 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbaEMFx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:53:56 -0400
Message-ID: <5371B36E.5030309@marvell.com>
Date: Tue, 13 May 2014 13:53:50 +0800
From: FanWu <fwu@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [Pinctrl] A suggestion to avoid duplicated enabling operation
 on a pin's setting
References: <534B558A.3040504@marvell.com> <534F8B35.7090103@marvell.com> <5366F387.4060402@marvell.com> <5367CD62.7030205@wwwdotorg.org> <5369E891.2020309@marvell.com> <53712D10.40003@wwwdotorg.org>
In-Reply-To: <53712D10.40003@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_02:2014-05-13,2014-05-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405130079
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 04:20 AM, Stephen Warren wrote:
> On 05/07/2014 02:02 AM, FanWu wrote:
> ...
>> I think the glitch you mentioned is indeed a problem for the vendors who
>> define the "pinctrl-single,function-off" which will be activated when
>> disabling setting.
>
> "pinctrl-single,function-off" is one specific driver's way of
> configuring what happens when a mux option is disabled. The issue
> applies to all drivers that implement a mux option disable function.
>
> ...
>> I considered my previous option 1 of avoiding duplicated calling
>> enable_setting. If we want to avoid too much iteration in this solution,
>> some mark variables need to be introduced, which may make code more
>> complicated than the previous one.
>
> Probably the best thing is to just remove the concept of "disable a mux
> option". It doesn't make sense. All you can do with mux options is to
> select some specific mux option. Disabling a mux option isn't something
> that's logically possible. On some HW, perhaps you can do something
> similar by tri-stating the pin or something, but that should be an
> explicit part of the pinctrl state definition rather than an automatic
> side-effect.
>
> ...
>> Maybe another topic:
>> In the original code, the Pin setting will be changed to the
>> disabled/safe state when Pin state is switched if the old setting is not
>> existed in new state rather than directly switched to the new Pin
>> setting. Also a possible glitch?
>
> That's not a glitch, since it's not a temporary state. The mux setting
> starts out as configured by the old state, then switches one time to
> whatever the disable function sets it to. After that, it won't switch
> again, unless there's an explicit SW action to enable a new state.
>

Dear, Stephen,

Thanks a lot for your reviewing!

I think the solution you mentioned about removing disable_pinmux 
function may introduce other possible code logic change, like change on 
enable_pinmux and "pinctrl-single,function-off" usage, which may be 
complicated thing. I cannot say whether that is a acceptable solution 
for Pinmux/pinctrl subsystem owner and user.

Thus, I think the patch I filed recently may be more easier way to solve 
this case.


About the glitch I mentioned before, I want to make myself clear.
If there is a case like the following one:
pinctrl-0 = <&a_grp_settingA>;
pinctrl-1 = <&a_grp_settingB>;
"a_grp_settingA" and "a_grp_settingB" are used to described the same 
Pin's different mux and function configuration
In my understanding,
When there is a need to switch Pin group state, the current code will 
disable "a_grp_settingA" first ahead of enabling "a_grp_settingB", right ?

Do you mean the case I mentioned will not be a glitch ?

If I got anything wrong, feel free to correct me.

