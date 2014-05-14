Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaENCM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 22:12:26 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50385 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231AbaENCMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 22:12:24 -0400
Message-ID: <5372D102.8070806@marvell.com>
Date: Wed, 14 May 2014 10:12:18 +0800
From: FanWu <fwu@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: <linus.walleij@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH] pinctrl: add params in disable_setting to differ difference
 usage
References: <1400032485-3319-1-git-send-email-fwu@marvell.com>
In-Reply-To: <1400032485-3319-1-git-send-email-fwu@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_07:2014-05-13,2014-05-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=29
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405140029
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 09:54 AM, fwu@marvell.com wrote:
> From: Fan Wu <fwu@marvell.com>
>
> The patch added params in disable_setting to differ the two possible usage,
> 1.Only want to disable the pin setting in SW aspect, param can be set to "0"
> 2.Want to disable the pin setting in both HW and SW aspect, param can be set to "1";
>
> The reason why to do this is that:
> To avoid duplicated enable_setting operation without disabling operation which will
> let Pin's desc->mux_usecount keep being added.
>
> In the following case, the issue can be reproduced:
> 1)There is a driver need to switch Pin state dynamicly, E.g. b/t "sleep" and
> "default" state
> 2)The Pin setting configuration in the two state is same, like the following one:
> component a {
> 	pinctrl-names = "default", "sleep";
> 	pinctrl-0 = <&a_grp_setting &c_grp_setting>;
> 	pinctrl-1 = <&b_grp_setting &c_grp_setting>;
> }
> The "c_grp_setting" config node is totaly same, maybe like following one:
> c_grp_setting: c_grp_setting {
> 	pinctrl-single,pins = <GPIO48 AF6>;
> 	MFP_DEFAULT;
> }
> 3)When switch the Pin state in the following official Pinctrl sequence:
> 	pin = pinctrl_get();
> 	state = pinctrl_lookup_state(wanted_state);
> 	pinctrl_select_state(state);
> 	pinctrl_put();
>
> Test Result:
> 1)The switch change is completed as expectation, that is: component's
> Pins configuration are changed according to the description in the
> "wanted_state" group setting
> 2)The "desc->mux_usecount" of corresponding Pins in "c_group" is added without being
> decreased, due to the original reason mentioned in this patch.
>
> According to the comments in the original code, only the setting, in old state
> but not in new state, will be "disable"(calling pinmux_disable_setting), which
> is correct logic but not intact. We still need consider case that the setting
> is in both old state and new state.
> We can do this in the following two ways:
> 1) Avoid "enable"(calling pinmux_enable_setting) the Same Pins setting repeatedly.
> 2) "Disable"(calling pinmux_disable_setting) the Same Pins setting ahead of enable them.
>
> Analysis:
> 1.The solution 2# is better because it can avoid too much iteration.
> 2.If we disable all of the setting in the old state and one/ones of the setting(s) is/are
> existed in the new state, the Pin's mux function change may happen when
> some SoC vendors defined the "pinctrl-single,function-off" in their DTS file.
> old_setting=>disabled_setting=>new_setting.
> 3.In the pinmux framework, when Pin state is switched, the setting in the old state should be
> marked as "disabled" in my understanding.
>
> Conclusion:
> Thus, the patch handle the issue mentioned above by disabling the c_grp_setting in SW asepct without
> touch the HW corresponding register to avoid unnecessary Pin's mux
> function change.
>
> Change-Id: Ib3f7e7b6d4b401796733f5fbf52da73973f2efff
> Signed-off-by: Fan Wu <fwu@marvell.com>
> ---
>   drivers/pinctrl/core.c   |   17 +++--------------
>   drivers/pinctrl/pinmux.c |    4 ++--
>   drivers/pinctrl/pinmux.h |    2 +-
>   3 files changed, 6 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index c0fe609..42877c3 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -891,7 +891,7 @@ static void pinctrl_free_setting(bool disable_setting,
>   	switch (setting->type) {
>   	case PIN_MAP_TYPE_MUX_GROUP:
>   		if (disable_setting)
> -			pinmux_disable_setting(setting);
> +			pinmux_disable_setting(setting, 1);
>   		pinmux_free_setting(setting);
>   		break;
>   	case PIN_MAP_TYPE_CONFIGS_PIN:
> @@ -998,20 +998,9 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>   		 * safe/disabled state.
>   		 */
>   		list_for_each_entry(setting, &p->state->settings, node) {
> -			bool found = false;
>   			if (setting->type != PIN_MAP_TYPE_MUX_GROUP)
>   				continue;
> -			list_for_each_entry(setting2, &state->settings, node) {
> -				if (setting2->type != PIN_MAP_TYPE_MUX_GROUP)
> -					continue;
> -				if (setting2->data.mux.group ==
> -						setting->data.mux.group) {
> -					found = true;
> -					break;
> -				}
> -			}
> -			if (!found)
> -				pinmux_disable_setting(setting);
> +			pinmux_disable_setting(setting, 0);
>   		}
>   	}
>
> @@ -1055,7 +1044,7 @@ unapply_new_state:
>   		 * are free to be muxed by another apply_setting.
>   		 */
>   		if (setting2->type == PIN_MAP_TYPE_MUX_GROUP)
> -			pinmux_disable_setting(setting2);
> +			pinmux_disable_setting(setting2, 1);
>   	}
>
>   	/* There's no infinite recursive loop here because p->state is NULL */
> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> index 9248ce4..88544d4 100644
> --- a/drivers/pinctrl/pinmux.c
> +++ b/drivers/pinctrl/pinmux.c
> @@ -465,7 +465,7 @@ err_pin_request:
>   	return ret;
>   }
>
> -void pinmux_disable_setting(struct pinctrl_setting const *setting)
> +void pinmux_disable_setting(struct pinctrl_setting const *setting, int hwops)
>   {
>   	struct pinctrl_dev *pctldev = setting->pctldev;
>   	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
> @@ -516,7 +516,7 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>   		}
>   	}
>
> -	if (ops->disable)
> +	if (ops->disable && hwops)
>   		ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
>   }
>
> diff --git a/drivers/pinctrl/pinmux.h b/drivers/pinctrl/pinmux.h
> index d1a98b1..cd3a4af 100644
> --- a/drivers/pinctrl/pinmux.h
> +++ b/drivers/pinctrl/pinmux.h
> @@ -29,7 +29,7 @@ int pinmux_map_to_setting(struct pinctrl_map const *map,
>   			  struct pinctrl_setting *setting);
>   void pinmux_free_setting(struct pinctrl_setting const *setting);
>   int pinmux_enable_setting(struct pinctrl_setting const *setting);
> -void pinmux_disable_setting(struct pinctrl_setting const *setting);
> +void pinmux_disable_setting(struct pinctrl_setting const *setting, int hwops);
>
>   #else
>
>

Dear Stephen,

I think we reach agreement on this topic that it is possible that a 
Pin's mux function may be changed if we disable the old setting. We can 
ignore the understanding about the "glitch" because the glitch I 
mentioned just means that the unexpected Pin's mux function change.

Just as the above patch expressed, I think we need to do SW pinmux 
setting disabling for all of the setting in old state ahead enabling 
setting in new state in pinctrl_select_state function.
Only when the user really wants to disable Pin's setting, like the 
disabling operation in "pinctrl_free_setting" function, we can disable 
the pin's mux setting in HW aspect.

Do you think this is a acceptable solution for the topic we discussed ?

Great thanks for this !

