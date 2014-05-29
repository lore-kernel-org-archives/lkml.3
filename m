Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbaE2Cz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:55:29 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46770 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbaE2Cz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:55:27 -0400
Message-ID: <5386A195.2050208@marvell.com>
Date: Thu, 29 May 2014 10:55:17 +0800
From: FanWu <fwu@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "tony@atomide.com" <tony@atomide.com>
CC: FanWu <fwu@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>, <wwang27@marvell.com>,
        <jxiang@marvell.com>
Subject: Re: [PATCH v3] pinctrl: to avoid duplicated calling enable_pinmux_setting
 for a pin
References: <1401072217-3180-1-git-send-email-fwu@marvell.com> <5382AC5E.8090704@marvell.com>
In-Reply-To: <5382AC5E.8090704@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-29_01:2014-05-28,2014-05-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=9
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405290040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2014 10:52 AM, FanWu wrote:
> On 05/26/2014 10:43 AM, fwu@marvell.com wrote:
>> From: Fan Wu <fwu@marvell.com>
>>
>> What the patch did:
>> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in
>> each time of
>>    calling pinctrl_select_state
>> 2.Remove the HW disable operation in in pinmux_disable_setting function.
>>
>> The reason why to do this is that:
>> 1.To avoid duplicated calling enable_setting operation without disabling
>>    operation which will let Pin's desc->mux_usecount keep being added.
>> 2.The HW pin disable operation is not useful for most of the vendors'
>> platform.
>>    And this can be used to avoid the HW glitch after using the item 1#
>>    modification.
>>
>> In the following case, the issue can be reproduced:
>> 1)There is a driver need to switch Pin state dynamicly, E.g. b/t
>> "sleep" and
>> "default" state
>> 2)The Pin setting configuration in DTS node may be like the following
>> one:
>> component a {
>>     pinctrl-names = "default", "sleep";
>>     pinctrl-0 = <&a_grp_setting &c_grp_setting>;
>>     pinctrl-1 = <&b_grp_setting &c_grp_setting>;
>> }
>> The "c_grp_setting" config node is totaly same, maybe like following one:
>> c_grp_setting: c_grp_setting {
>>     pinctrl-single,pins = <GPIO48 AF6>;
>>     MFP_DEFAULT;
>> }
>> 3)When switching the Pin state in the following official Pinctrl
>> sequence:
>>     pin = pinctrl_get();
>>     state = pinctrl_lookup_state(wanted_state);
>>     pinctrl_select_state(state);
>>     pinctrl_put();
>>
>> Test Result:
>> 1)The switch is completed as expectation, that is: component's
>> Pins configuration are changed according to the description in the
>> "wanted_state" group setting
>> 2)The "desc->mux_usecount" of corresponding Pins in "c_group" is added
>> without being
>> decreased, because the "desc" is for each physical pin while the
>> "setting" is
>> for each setting node in the DTS.
>> Thus, if the "c_grp_setting" in pinctrl-0 is not disabled ahead of
>> enabling
>> "c_grp_setting" in pinctrl-1, the desc->mux_usecount will be kept
>> added without
>> any chance to be decreased.
>>
>> According to the comments in the original code, only the setting, in
>> old state
>> but not in new state, will be "disable"(calling
>> pinmux_disable_setting), which
>> is correct logic but not intact. We still need consider case that the
>> setting
>> is in both old state and new state.
>> We can do this in the following two ways:
>> 1) Avoid "enable"(calling pinmux_enable_setting) the Same Pins setting
>> repeatedly.
>> 2) "Disable"(calling pinmux_disable_setting) the "Same Pins setting",
>> actually
>> two setting instance, ahead of enabling them.
>>
>> Analysis:
>> 1.The solution 2# is better because it can avoid too much iteration.
>> 2.If we disable all of the setting in the old state and one/ones of
>> the setting(s) is/are
>> existed in the new state, the Pin's mux function change may happen when
>> some SoC vendors defined the "pinctrl-single,function-off" in their
>> DTS file.
>> old_setting=>disabled_setting=>new_setting.
>> 3.In the pinmux framework, when Pin state is switched, the setting in
>> the old state should be
>> marked as "disabled".
>>
>> Conclusion:
>> 1.To Remove the HW disabling operation to above the glitch mentioned
>> above.
>> 2.Handle the issue mentioned above by disabling all of the settings in
>> old
>> state and then enable the all of the settings in new state.
>>
>> Signed-off-by: Fan Wu <fwu@marvell.com>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>>   drivers/pinctrl/core.c   |   24 +++++-------------------
>>   drivers/pinctrl/pinmux.c |    4 ----
>>   2 files changed, 5 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
>> index c0fe609..4445a67 100644
>> --- a/drivers/pinctrl/core.c
>> +++ b/drivers/pinctrl/core.c
>> @@ -989,29 +989,15 @@ int pinctrl_select_state(struct pinctrl *p,
>> struct pinctrl_state *state)
>>
>>       if (p->state) {
>>           /*
>> -         * The set of groups with a mux configuration in the old state
>> -         * may not be identical to the set of groups with a mux setting
>> -         * in the new state. While this might be unusual, it's entirely
>> -         * possible for the "user"-supplied mapping table to be written
>> -         * that way. For each group that was configured in the old state
>> -         * but not in the new state, this code puts that group into a
>> -         * safe/disabled state.
>> +         * For each pinmux setting in the old state, forget SW's record
>> +         * of mux owner for that pingroup. Any pingroups which are
>> +         * still owned by the new state will be re-acquired by the call
>> +         * to pinmux_enable_setting() in the loop below.
>>            */
>>           list_for_each_entry(setting, &p->state->settings, node) {
>> -            bool found = false;
>>               if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
>>                   continue;
>> -            list_for_each_entry(setting2, &state->settings, node) {
>> -                if (setting2->type != PIN_MAP_TYPE_MUX_GROUP)
>> -                    continue;
>> -                if (setting2->data.mux.group ==
>> -                        setting->data.mux.group) {
>> -                    found = true;
>> -                    break;
>> -                }
>> -            }
>> -            if (!found)
>> -                pinmux_disable_setting(setting);
>> +            pinmux_disable_setting(setting);
>>           }
>>       }
>>
>> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
>> index 9248ce4..c2c4aff 100644
>> --- a/drivers/pinctrl/pinmux.c
>> +++ b/drivers/pinctrl/pinmux.c
>> @@ -469,7 +469,6 @@ void pinmux_disable_setting(struct pinctrl_setting
>> const *setting)
>>   {
>>       struct pinctrl_dev *pctldev = setting->pctldev;
>>       const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
>> -    const struct pinmux_ops *ops = pctldev->desc->pmxops;
>>       int ret;
>>       const unsigned *pins;
>>       unsigned num_pins;
>> @@ -515,9 +514,6 @@ void pinmux_disable_setting(struct pinctrl_setting
>> const *setting)
>>                    pins[i], desc->name, gname);
>>           }
>>       }
>> -
>> -    if (ops->disable)
>> -        ops->disable(pctldev, setting->data.mux.func,
>> setting->data.mux.group);
>>   }
>>
>>   #ifdef CONFIG_DEBUG_FS
>>
>
>
> Dear Stephen,
>
> Great thanks for your suggestion about the inline comments in the patch.
> I have updated the part you mentioned and the patch title.
> Please help to review again.
>
> Great to see that we almost get the goal of the long term discussion! :)
>
> After this patch is acknowledged by you Guys, I will submit the
> following two patches for you to review:
> 1.to remove the ops->disable registration in pinctrl-single
> 2.to remove the ops->disable function phandle in pinmux struct.
>
> Great thanks for this !
>

Dear Guys,

Do you have any comments about the new patch ?  Any suggestion is 
welcomed. :)

Looking forward your reply !
Great thanks for this !

