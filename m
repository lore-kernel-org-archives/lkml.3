Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaFCHtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:49:22 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51278 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932203AbaFCHtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:49:20 -0400
Message-ID: <538D7DEB.7020000@marvell.com>
Date: Tue, 3 Jun 2014 15:48:59 +0800
From: FanWu <fwu@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "tony@atomide.com" <tony@atomide.com>
CC: "fwu@marvell.com" <fwu@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH v4] pinctrl: to avoid duplicated calling enable_pinmux_setting
 for a pin
References: <1401781077-31150-1-git-send-email-fwu@marvell.com>
In-Reply-To: <1401781077-31150-1-git-send-email-fwu@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-02_03:2014-06-02,2014-06-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406030099
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 03:37 PM, fwu@marvell.com wrote:
> From: Fan Wu <fwu@marvell.com>
>
> What the patch did:
> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in each time of
>    calling pinctrl_select_state
> 2.Remove the HW disable operation in in pinmux_disable_setting function.
> 3.Remove the disable ops in struct pinmux_ops
>
> The reason why to do this is that:
> 1.To avoid duplicated calling enable_setting operation without disabling
>    operation which will let Pin's desc->mux_usecount keep being added.
> 2.The HW pin disable operation is not useful for most of the vendors' platform.
>    And this can be used to avoid the HW glitch after using the item 1#
>    modification.
>
> In the following case, the issue can be reproduced:
> 1)There is a driver need to switch Pin state dynamicly, E.g. b/t "sleep" and
> "default" state
> 2)The Pin setting configuration in DTS node may be like the following one:
> component a {
> 	pinctrl-names = "default", "sleep";
> 	pinctrl-0 = <&a_grp_setting &c_grp_setting>;
> 	pinctrl-1 = <&b_grp_setting &c_grp_setting>;
> }
> The "c_grp_setting" config node is totaly same, maybe like following one:
> c_grp_setting: c_grp_setting {
> 	pinctrl-single,pins = <GPIO48 AF6>;
> }
> 3)When switching the Pin state in the following official Pinctrl sequence:
> 	pin = pinctrl_get();
> 	state = pinctrl_lookup_state(wanted_state);
> 	pinctrl_select_state(state);
> 	pinctrl_put();
>
> According to the comments in the original code, only the setting, in old state
> but not in new state, will be "disable"(calling pinmux_disable_setting), which
> is correct logic but not intact. We still need consider case that the setting
> is in both old state and new state.
> We can do this in the following two ways:
> 1) Avoid "enable"(calling pinmux_enable_setting) the Same Pins setting repeatedly.
> 2) "Disable"(calling pinmux_disable_setting) the "Same Pins setting", actually
> two setting instance, ahead of enabling them.
>
> Analysis:
> 1.The solution 2# is better because it can avoid too much iteration.
> 2.If we choose 2# solution, we need to
> 1) Should mark all the setting in disable state as disabled ahead of enabling.
> 2) Avoid the possible HW glitch by removing the HW disable ops in
> in the pinmux_disable_setting
> If we disable all of the settings in the old state and one/ones of the
> setting(s) is/are existed in the new state, the Pin's mux function change
> may happen when some SoC vendors defined the "pinctrl-single,function-off"
> in their DTS file:
> old_setting=>disabled_setting=>new_setting.(HW glitch)
>
> Signed-off-by: Fan Wu <fwu@marvell.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>   drivers/pinctrl/core.c         |   24 +++++-------------------
>   drivers/pinctrl/pinmux.c       |    4 ----
>   include/linux/pinctrl/pinmux.h |    2 --
>   3 files changed, 5 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index c0fe609..4445a67 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -989,29 +989,15 @@ int pinctrl_select_state(struct pinctrl *p, struct pinctrl_state *state)
>
>   	if (p->state) {
>   		/*
> -		 * The set of groups with a mux configuration in the old state
> -		 * may not be identical to the set of groups with a mux setting
> -		 * in the new state. While this might be unusual, it's entirely
> -		 * possible for the "user"-supplied mapping table to be written
> -		 * that way. For each group that was configured in the old state
> -		 * but not in the new state, this code puts that group into a
> -		 * safe/disabled state.
> +		 * For each pinmux setting in the old state, forget SW's record
> +		 * of mux owner for that pingroup. Any pingroups which are
> +		 * still owned by the new state will be re-acquired by the call
> +		 * to pinmux_enable_setting() in the loop below.
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
> +			pinmux_disable_setting(setting);
>   		}
>   	}
>
> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> index 9248ce4..c2c4aff 100644
> --- a/drivers/pinctrl/pinmux.c
> +++ b/drivers/pinctrl/pinmux.c
> @@ -469,7 +469,6 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>   {
>   	struct pinctrl_dev *pctldev = setting->pctldev;
>   	const struct pinctrl_ops *pctlops = pctldev->desc->pctlops;
> -	const struct pinmux_ops *ops = pctldev->desc->pmxops;
>   	int ret;
>   	const unsigned *pins;
>   	unsigned num_pins;
> @@ -515,9 +514,6 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>   				 pins[i], desc->name, gname);
>   		}
>   	}
> -
> -	if (ops->disable)
> -		ops->disable(pctldev, setting->data.mux.func, setting->data.mux.group);
>   }
>
>   #ifdef CONFIG_DEBUG_FS
> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
> index c153950..3097aaf 100644
> --- a/include/linux/pinctrl/pinmux.h
> +++ b/include/linux/pinctrl/pinmux.h
> @@ -70,8 +70,6 @@ struct pinmux_ops {
>   				  unsigned * const num_groups);
>   	int (*enable) (struct pinctrl_dev *pctldev, unsigned func_selector,
>   		       unsigned group_selector);
> -	void (*disable) (struct pinctrl_dev *pctldev, unsigned func_selector,
> -			 unsigned group_selector);
>   	int (*gpio_request_enable) (struct pinctrl_dev *pctldev,
>   				    struct pinctrl_gpio_range *range,
>   				    unsigned offset);
>

Dear All,

I have updated the patch and the main modification includes:
1.To remove the disable ops in the struct pinmux_ops.
2.To short the patch comments.

Please help to review.

For the "signed-off" part, I added the "Stephen" because I change the 
code inline comments according to the suggestion from Stephen.

Please share your suggestion about the new version patch.

Great thanks for this!
