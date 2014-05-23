Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaEWByn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 21:54:43 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57394 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbaEWByl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 21:54:41 -0400
Message-ID: <537EAA46.8010409@marvell.com>
Date: Fri, 23 May 2014 09:54:14 +0800
From: FanWu <fwu@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH v2] pinctrl: add params in disable_setting for different
 usage
References: <1400728210-17863-1-git-send-email-fwu@marvell.com> <537E848C.5010204@wwwdotorg.org>
In-Reply-To: <537E848C.5010204@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-22_07:2014-05-22,2014-05-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405230026
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 07:13 AM, Stephen Warren wrote:
> On 05/21/2014 09:10 PM, fwu@marvell.com wrote:
>> From: Fan Wu <fwu@marvell.com>
>>
>> What the patch did:
>> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in each time of
>>    calling pinctrl_select_state
>> 2.Remove the HW disable operation in in pinmux_disable_setting function.
>>
> ...
>> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
>> index c0fe609..c97491a 100644
>> --- a/drivers/pinctrl/core.c
>> +++ b/drivers/pinctrl/core.c
>> @@ -993,25 +993,13 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>>   		 * may not be identical to the set of groups with a mux setting
>>   		 * in the new state. While this might be unusual, it's entirely
>>   		 * possible for the "user"-supplied mapping table to be written
>> -		 * that way. For each group that was configured in the old state
>> -		 * but not in the new state, this code puts that group into a
>> -		 * safe/disabled state.
>> +		 * that way. This code is used for each group that was
>> +		 * configured in the old state but not in the new state
>
>
> Looking at the code, it's run for every group in the state, not "each
> group that was configured in the old state but not in the new state"
>
>> @@ -515,9 +514,6 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>>   				 pins[i], desc->name, gname);
>>   		}
>>   	}
>> -
>> -	if (ops->disable)
>> -		ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
>>   }
>
> Should that op be removed from the header file and all drivers too?
>

Dear Stephen,

For you question 1:
The disable_pinmux_setting is for the all of the setting in old state. 
This is what we really need to do, ahead of enable setting in new state.
In the first patch I filed, which still includes the HW ops in 
disable_pinmux_setting, to disable each setting in old state and then to 
enable the setting in new state will introduce HW glitch.
But in the current solution, the glitch will not be there, because there 
is no HW ops in disable_pinmux_setting.
And please notice the patch is mainly used to avoid the duplicated 
enable operation for the same pin.

For your question 2:
the pinctrl-single driver is still using ops->disable, if I remove the 
"disable" in ops, there will be build error in the vendor's code base 
who is using pinctrl-single driver.

Just as I said in the last mail,
the next plan for this topic:

1. To remove the disable ops registration when defining the
"include/linux/pinctrl/pinmux.h" in inctrl-single driver.
Meanwhile, the related things, like "pinctrl-single,function-off"
property and corresponding flag in "pcs_device", will be also removed.

2. To remove the disable ops in "pinmux_ops" in the file of 
include/linux/pinctrl/pinmux.h

Are you OK for this ?
