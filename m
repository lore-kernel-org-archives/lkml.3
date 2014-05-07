Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaEGICe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:02:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31778 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341AbaEGICb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:02:31 -0400
Message-ID: <5369E891.2020309@marvell.com>
Date: Wed, 7 May 2014 16:02:25 +0800
From: FanWu <fwu@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [Pinctrl] A suggestion to avoid duplicated enabling operation
 on a pin's setting
References: <534B558A.3040504@marvell.com> <534F8B35.7090103@marvell.com> <5366F387.4060402@marvell.com> <5367CD62.7030205@wwwdotorg.org>
In-Reply-To: <5367CD62.7030205@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-07_02:2014-05-06,2014-05-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405070099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 01:41 AM, Stephen Warren wrote:
> FanWu,
>
> Questions about the Linux kernel should be sent to the public mailing
> lists so that anyone can see the discussion, join in, and/or see the
> result of the discussion in the list archives. Also, please use
> plain-text email, since that makes it easier to read and reply.
>
> The problem with simply calling pinmux_disable_setting() in all cases as
> you propose is that (at least on some HW), calling
> pinmux_disable_setting() may cause the HW to be programmed, and that may
> glitch the pin. In other words, the current code does this:
>
> old mux function -> new mux function
>
> Presumably the board/SoC HW designers have validated that such
> transitions don't cause invalid signals to be emitted.
>
> However, your proposal might do:
>
> old mux function -> disabled state -> new mux function
>
> That introduces a potential extra HW state (whatever
> pinmux_disable_state() programs) which could cause glitches on the pin,
> which could cause problems.
>
> So, I think what we need is your option (1), although some care will be
> needed to avoid too much nested iteration.
>
> On 05/04/2014 08:12 PM, FanWu wrote:
>> On 04/17/2014 04:05 PM, Will Wu wrote:
>>> On 04/14/2014 11:27 AM, FanWu wrote:
>>>>
>>>> Dear, Linus Walleij
>>>>
>>>> Sorry to bother you. I am a Linux Kernel developer in Marvell.
>>>> Recently, I am focusing on the Pinctrl related driver development and
>>>> found there seems a possible issue lying in Pinctrl related framework.
>>>> I will try to make myself clear and please help to review the
>>>> following statement.
>>>>
>>>> In the following I will listed what I found and the suggested code
>>>> change in the mentioned part.
>>>>
>>>> If there is a DTS node is similar to the following one(only the
>>>> pinctrl related part is listed in the node content), in current
>>>> Kernel Pinctrl solution, it is possible that the "desc->mux_usecount"
>>>> for each physical pin is kept being added without any chance to be
>>>> decreased, when the Pin's owner wants to do Pin's state switching in
>>>> their user scenario.
>>>>      component a {
>>>>          ...
>>>>          pinctrl-names = "default", "sleep";
>>>>          pinctrl-0 = <&a_grp_setting_a &*c_grp_setting*>;
>>>>          pinctrl-1 = <&a_grp_setting_b &*c_grp_setting*>;
>>>>          ...
>>>>      }
>>>> The "c_grp_setting" config node is totally same in two pinctrl state.
>>>> The only difference b/t the two Pinctrl states is the
>>>> "a_group_setting". Pinctrl-0 uses "a_grp_setting_a" setting while
>>>> pinctrl-1 uses "a_grp_setting_b" setting.
>>>>
>>>> If the pins' owner wants to switch the pins' state in some cases, he
>>>> needs to do the following sequence:
>>>>      pin = pinctrl_get();
>>>>      state = pinctrl_lookup_state(wanted_state);
>>>>      pinctrl_select_state(state);
>>>>      pinctrl_put();
>>>>
>>>> In pinctrl_select_state function, with current code logic, the
>>>> setting, existing in old state but not in new state, will be
>>>> disabled(put to safe state) ahead of enabling it.
>>>> However, for the state, existing in both old state and new state,
>>>> will not be disabled ahead of enabling it, i.e, the pins' owner only
>>>> wants to change part of the related pins state.
>>>> So the Physical Pin's "desc->mux_usecount" will be increased without
>>>> any chance to be decreased.
>>>>
>>>>
>>>> Thus, there seems two ways to solve the issue I mentioned above:
>>>> 1. Avoid "enable"(calling pinmux_enable_setting) the Same Pins
>>>> setting repeatedly
>>>> 2. "Disable"(calling pinmux_disable_setting) the Same Pins setting
>>>> ahead of enable them in any case.
>>>>
>>>> I think the 2nd way is easy for code change, shown as the following
>>>> one. Please help to review this.
>>>>
>>>> If there is anything wrong, feel free to correct me and share your
>>>> suggestion for this topic.
>>>>
>>>> Great thanks for this !
>>>>
>>>>
>>>> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c index
>>>> 2f4edfa..c9b97ae 100644
>>>> --- a/drivers/pinctrl/core.c
>>>> +++ b/drivers/pinctrl/core.c
>>>> @@ -944,30 +944,10 @@ int pinctrl_select_state(struct pinctrl *p,
>>>> struct pinctrl_state *state)
>>>>                  return 0;
>>>>
>>>>          if (p->state) {
>>>> -               /*
>>>> -                * The set of groups with a mux configuration in the
>>>> old state
>>>> -                * may not be identical to the set of groups with a
>>>> mux setting
>>>> -                * in the new state. While this might be unusual,
>>>> it's entirely
>>>> -                * possible for the "user"-supplied mapping table to
>>>> be written
>>>> -                * that way. For each group that was configured in
>>>> the old state
>>>> -                * but not in the new state, this code puts that
>>>> group into a
>>>> -                * safe/disabled state.
>>>> -                */
>>>>                   list_for_each_entry(setting, &p->state->settings,
>>>> node) {
>>>> -                        bool found = false;
>>>>                           if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
>>>>                                   continue;
>>>> -                        list_for_each_entry(setting2,
>>>> &state->settings, node) {
>>>> -                                if (setting2->type !=
>>>> PIN_MAP_TYPE_MUX_GROUP)
>>>> -                                        continue;
>>>> -                                if (setting2->data.mux.group ==
>>>> -
>>>> setting->data.mux.group) {
>>>> -                                        found = true;
>>>> -                                        break;
>>>> -                                }
>>>> -                        }
>>>> -                        if (!found)
>>>> -                                pinmux_disable_setting(setting);
>>>> +                        pinmux_disable_setting(setting);
>>>>                   }
>>>>           }
>>> Dear, Linus Walleij
>>>
>>> Do you think what I said above is OK for the possible code change ?
>>>
>>> Looking forward your reply.
>>> Great thanks !
>>>
>> Dear Linus,
>>
>> Great thanks for your reply and your suggestion.
>> Just add Stephen Warren to review what mentioned before
>>
>>
>>
>>
>> Dear Stephen,
>>
>> I am Will, from Marvell, BSP developer, focusing on Pinctrl part recently.
>>
>> I just filed patch to do some code changes in the file of
>> drivers/pinctrl/core.c.
>> The reason why I did this and some possible issue are described in the
>> early mail.
>>
>> Could you please help to review the mail and previous mail.
>>
>> Great thanks for this !
>>
>> Looking forward your reply !
>

Dear Stephen,

Thanks a lot for your suggestion for the patch and the mail!


I think the glitch you mentioned is indeed a problem for the vendors who 
define the "pinctrl-single,function-off" which will be activated when 
disabling setting.

I considered my previous option 1 of avoiding duplicated calling 
enable_setting. If we want to avoid too much iteration in this solution, 
some mark variables need to be introduced, which may make code more 
complicated than the previous one.

I also tried to add a member variable named "enabled" in "struct 
setting" to mark whether a setting has been enabled before. If the 
"enabled" is set, the setting_enable function will return and the same 
thing happens in setting_disable function.
However, this method seems still not that perfect. Although the 
c_grp_setting is the same device node to config the same Pin to same 
state, the "c_grp_setting" in the two states are two instance.
With this solution, when Pin state is switched from state0->state1, the 
c_grp_setting's two instances will be both enabled and corresponding 
Pin's mux_usecount will be incremented to "2".
I cannot sure whether the result with this solution is correct or not, 
because I am not quite sure the what's the meaning of enabled/disabled 
setting in pinmux framework.

	pinctrl-0 = <&a_grp_setting &c_grp_setting>;
	pinctrl-1 = <&b_grp_setting &c_grp_setting>;


Current patch and conclusion,
Thus, I am still inclined to use option 2, calling "disable" function 
ahead of enabling function. To avoid the possible HW glitch, it will be 
a good way only to do SW aspect disable operation for the setting which 
is existing in both old and new state, and do SW and HW disable 
operation for the setting only existing in old state, which can be 
implemented by adding a params in disable_setting function.

Please help to review what I mentioned above and the following patch.

Maybe another topic:
In the original code, the Pin setting will be changed to the 
disabled/safe state when Pin state is switched if the old setting is not 
existed in new state rather than directly switched to the new Pin 
setting. Also a possible glitch?
Do you think this is also a part can be refined ? Do you think it is OK 
to do SW disabled operation for all of the setting in old state?


Great thanks for this!
Looking forward your reply!


  drivers/pinctrl/core.c   | 7 ++++--- 
 

  drivers/pinctrl/pinmux.c | 4 ++--
  drivers/pinctrl/pinmux.h | 2 +-
  3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 2f4edfa..a5eae27ae 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -847,7 +847,7 @@ static void pinctrl_free_setting(bool disable_setting,
         switch (setting->type) {
         case PIN_MAP_TYPE_MUX_GROUP:
                 if (disable_setting)
-                       pinmux_disable_setting(setting);
+                       pinmux_disable_setting(setting, 1);
                 pinmux_free_setting(setting);
                 break;
         case PIN_MAP_TYPE_CONFIGS_PIN:
@@ -963,11 +963,12 @@ int pinctrl_select_state(struct pinctrl *p, struct 
pinctrl_state *state)
                                 if (setting2->data.mux.group ==
                                                 setting->data.mux.group) {
                                         found = true;
+                                       pinmux_disable_setting(setting, 0);
                                         break;
                                 }
                         }
                         if (!found)
-                               pinmux_disable_setting(setting);
+                               pinmux_disable_setting(setting, 1);
                 }
         }

@@ -1011,7 +1012,7 @@ unapply_new_state:
                  * are free to be muxed by another apply_setting.
                  */
                 if (setting2->type == PIN_MAP_TYPE_MUX_GROUP)
-                       pinmux_disable_setting(setting2);
+                       pinmux_disable_setting(setting2, 1);
         }

         /* There's no infinite recursive loop here because p->state is 
NULL */
diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
index 88cc509..5c9f953 100644
--- a/drivers/pinctrl/pinmux.c
@@ -452,7 +452,7 @@ err_pin_request: 
 

         return ret;
  }

-void pinmux_disable_setting(struct pinctrl_setting const *setting)
+void pinmux_disable_setting(struct pinctrl_setting const *setting, int 
hwops)
  {
         struct pinctrl_dev *pctldev = setting->pctldev;
         const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
@@ -489,7 +489,7 @@ void pinmux_disable_setting(struct pinctrl_setting 
const *setting)
         for (i = 0; i < num_pins; i++)
                 pin_free(pctldev, pins[i], NULL);

-       if (ops->disable)
+       if (ops->disable && hwops)
                 ops->disable(pctldev, setting->data.mux.func, 
setting->data.mux.group);
  }

diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
index d1a98b1..cd3a4af 100644
--- a/drivers/pinctrl/pinmux.h
+++ b/drivers/pinctrl/pinmux.h
@@ -29,7 +29,7 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
                           struct pinctrl_setting *setting);
  void pinmux_free_setting(struct pinctrl_setting const *setting);
  int pinmux_enable_setting(struct pinctrl_setting const *setting);
-void pinmux_disable_setting(struct pinctrl_setting const *setting);
+void pinmux_disable_setting(struct pinctrl_setting const *setting, int 
hwops);

  #else

-- 





