Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaFFHyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:54:18 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:45116 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbaFFHyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:54:16 -0400
Message-ID: <5391733B.7050107@st.com>
Date: Fri, 6 Jun 2014 09:52:27 +0200
From: Patrice Chotard <patrice.chotard@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <fwu@marvell.com>, <linus.walleij@linaro.org>, <swarren@wwwdotorg.org>,
        <tony@atomide.com>, <plagnioj@jcrosoft.com>, <kgene.kim@samsung.com>,
        <heiko@sntech.de>, <t.figa@samsung.com>, <thomas.abraham@linaro.org>,
        <srinivas.kandagatla@gmail.com>, <maxime.coquelin@st.com>,
        <thierry.reding@gmail.com>, <baohua@kernel.org>,
        <viresh.linux@gmail.com>, <matt.porter@linaro.org>,
        <syin@broadcom.com>, <jg1.han@samsung.com>, <Rongjun.Ying@csr.com>,
        <Rong.Wang@csr.com>, <linux@prisktech.co.nz>,
        <yongjun_wei@trendmicro.com.cn>, <laurent.navet@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>, <cxie4@marvell.com>,
        <ylmao@marvell.com>, <njiang1@marvell.com>, <tianxf@marvell.com>,
        <fswu@marvell.com>
Subject: Re: [PATCH v5] pinctrl: to avoid duplicated calling enable_pinmux_setting
 for a pin
References: <1401951040-17403-1-git-send-email-fwu@marvell.com>
In-Reply-To: <1401951040-17403-1-git-send-email-fwu@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.18]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-06_03:2014-06-05,2014-06-06,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fan

On 06/05/2014 08:50 AM, fwu@marvell.com wrote:
> From: Fan Wu <fwu@marvell.com>
>
> What the patch did:
> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in each time of
>    calling pinctrl_select_state
> 2.Remove the HW disable operation in in pinmux_disable_setting function.
> 3.Remove the disable ops in struct pinmux_ops
> 4.Remove all the disable ops users in current code base.
>
> Notes:
> 1.Great thanks for the suggestion from Linus, Tony Lindgren and Stephen Warren.
> 2.The patch also includes comment fixes from Stephen Warren.
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
> 	MFP_DEFAULT;
> }
> 3)When switching the Pin state in the following official Pinctrl sequence:
> 	pin = pinctrl_get();
> 	state = pinctrl_lookup_state(wanted_state);
> 	pinctrl_select_state(state);
> 	pinctrl_put();
>
> Test Result:
> 1)The switch is completed as expectation, that is: component's
> Pins configuration are changed according to the description in the
> "wanted_state" group setting
> 2)The "desc->mux_usecount" of corresponding Pins in "c_group" is added without being
> decreased, because the "desc" is for each physical pin while the "setting" is
> for each setting node in the DTS.
> Thus, if the "c_grp_setting" in pinctrl-0 is not disabled ahead of enabling
> "c_grp_setting" in pinctrl-1, the desc->mux_usecount will be kept added without
> any chance to be decreased.
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
> 2.If we disable all of the setting in the old state and one/ones of the setting(s) is/are
> existed in the new state, the Pin's mux function change may happen when
> some SoC vendors defined the "pinctrl-single,function-off" in their DTS file.
> old_setting=>disabled_setting=>new_setting.
> 3.In the pinmux framework, when Pin state is switched, the setting in the old state should be
> marked as "disabled".
>
> Conclusion:
> 1.To Remove the HW disabling operation to above the glitch mentioned above.
> 2.Handle the issue mentioned above by disabling all of the settings in old
> state and then enable the all of the settings in new state.
>
> Signed-off-by: Fan Wu <fwu@marvell.com>
> ---
>   drivers/pinctrl/core.c                |   24 +++-----------
>   drivers/pinctrl/pinctrl-abx500.c      |   15 ---------
>   drivers/pinctrl/pinctrl-adi2.c        |   30 -----------------
>   drivers/pinctrl/pinctrl-at91.c        |   21 ------------
>   drivers/pinctrl/pinctrl-bcm2835.c     |   11 -------
>   drivers/pinctrl/pinctrl-exynos5440.c  |    8 -----
>   drivers/pinctrl/pinctrl-msm.c         |   25 --------------
>   drivers/pinctrl/pinctrl-nomadik.c     |   16 ---------
>   drivers/pinctrl/pinctrl-rockchip.c    |   18 ----------
>   drivers/pinctrl/pinctrl-samsung.c     |    8 -----
>   drivers/pinctrl/pinctrl-single.c      |   56 -------------------------------
>   drivers/pinctrl/pinctrl-st.c          |    6 ----
>   drivers/pinctrl/pinctrl-tb10x.c       |   17 ----------
>   drivers/pinctrl/pinctrl-tegra.c       |   19 -----------
>   drivers/pinctrl/pinctrl-tz1090-pdc.c  |   28 ----------------
>   drivers/pinctrl/pinctrl-tz1090.c      |   58 ---------------------------------
>   drivers/pinctrl/pinctrl-u300.c        |   14 --------
>   drivers/pinctrl/pinmux.c              |    4 ---
>   drivers/pinctrl/sh-pfc/pinctrl.c      |   22 -------------
>   drivers/pinctrl/sirf/pinctrl-sirf.c   |   10 ------
>   drivers/pinctrl/spear/pinctrl-spear.c |    7 ----
>   drivers/pinctrl/vt8500/pinctrl-wmt.c  |   12 -------
>   include/linux/pinctrl/pinmux.h        |    2 --
>   23 files changed, 5 insertions(+), 426 deletions(-)
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
> diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
> index 163da9c..f3f8b24 100644
> --- a/drivers/pinctrl/pinctrl-abx500.c
> +++ b/drivers/pinctrl/pinctrl-abx500.c
> @@ -737,20 +737,6 @@ static int abx500_pmx_enable(struct pinctrl_dev *pctldev, unsigned function,
>   	return ret;
>   }
>   
> -static void abx500_pmx_disable(struct pinctrl_dev *pctldev,
> -			       unsigned function, unsigned group)
> -{
> -	struct abx500_pinctrl *pct = pinctrl_dev_get_drvdata(pctldev);
> -	const struct abx500_pingroup *g;
> -
> -	g = &pct->soc->groups[group];
> -	if (g->altsetting < 0)
> -		return;
> -
> -	/* FIXME: poke out the mux, set the pin to some default state? */
> -	dev_dbg(pct->dev, "disable group %s, %u pins\n", g->name, g->npins);
> -}
> -
>   static int abx500_gpio_request_enable(struct pinctrl_dev *pctldev,
>   			       struct pinctrl_gpio_range *range,
>   			       unsigned offset)
> @@ -799,7 +785,6 @@ static const struct pinmux_ops abx500_pinmux_ops = {
>   	.get_function_name = abx500_pmx_get_func_name,
>   	.get_function_groups = abx500_pmx_get_func_groups,
>   	.enable = abx500_pmx_enable,
> -	.disable = abx500_pmx_disable,
>   	.gpio_request_enable = abx500_gpio_request_enable,
>   	.gpio_disable_free = abx500_gpio_disable_free,
>   };
> diff --git a/drivers/pinctrl/pinctrl-adi2.c b/drivers/pinctrl/pinctrl-adi2.c
> index 0cc0eec..2d852cc 100644
> --- a/drivers/pinctrl/pinctrl-adi2.c
> +++ b/drivers/pinctrl/pinctrl-adi2.c
> @@ -652,35 +652,6 @@ static int adi_pinmux_enable(struct pinctrl_dev *pctldev, unsigned func_id,
>   	return 0;
>   }
>   
> -static void adi_pinmux_disable(struct pinctrl_dev *pctldev, unsigned func_id,
> -	unsigned group_id)
> -{
> -	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
> -	struct gpio_port *port;
> -	struct pinctrl_gpio_range *range;
> -	unsigned long flags;
> -	unsigned short *mux, pin;
> -
> -	mux = (unsigned short *)pinctrl->soc->groups[group_id].mux;
> -
> -	while (*mux) {
> -		pin = P_IDENT(*mux);
> -
> -		range = pinctrl_find_gpio_range_from_pin(pctldev, pin);
> -		if (range == NULL) /* should not happen */
> -			return;
> -
> -		port = container_of(range->gc, struct gpio_port, chip);
> -
> -		spin_lock_irqsave(&port->lock, flags);
> -
> -		port_setup(port, pin_to_offset(range, pin), true);
> -		mux++;
> -
> -		spin_unlock_irqrestore(&port->lock, flags);
> -	}
> -}
> -
>   static int adi_pinmux_get_funcs_count(struct pinctrl_dev *pctldev)
>   {
>   	struct adi_pinctrl *pinctrl = pinctrl_dev_get_drvdata(pctldev);
> @@ -728,7 +699,6 @@ static int adi_pinmux_request_gpio(struct pinctrl_dev *pctldev,
>   
>   static struct pinmux_ops adi_pinmux_ops = {
>   	.enable = adi_pinmux_enable,
> -	.disable = adi_pinmux_disable,
>   	.get_functions_count = adi_pinmux_get_funcs_count,
>   	.get_function_name = adi_pinmux_get_func_name,
>   	.get_function_groups = adi_pinmux_get_groups,
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 5d24aae..a0ad2ee 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -615,26 +615,6 @@ static int at91_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
>   	return 0;
>   }
>   
> -static void at91_pmx_disable(struct pinctrl_dev *pctldev, unsigned selector,
> -			   unsigned group)
> -{
> -	struct at91_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> -	const struct at91_pmx_pin *pins_conf = info->groups[group].pins_conf;
> -	const struct at91_pmx_pin *pin;
> -	uint32_t npins = info->groups[group].npins;
> -	int i;
> -	unsigned mask;
> -	void __iomem *pio;
> -
> -	for (i = 0; i < npins; i++) {
> -		pin = &pins_conf[i];
> -		at91_pin_dbg(info->dev, pin);
> -		pio = pin_to_controller(info, pin->bank);
> -		mask = pin_to_mask(pin->pin);
> -		at91_mux_gpio_enable(pio, mask, 1);
> -	}
> -}
> -
>   static int at91_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
>   {
>   	struct at91_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> @@ -709,7 +689,6 @@ static const struct pinmux_ops at91_pmx_ops = {
>   	.get_function_name	= at91_pmx_get_func_name,
>   	.get_function_groups	= at91_pmx_get_groups,
>   	.enable			= at91_pmx_enable,
> -	.disable		= at91_pmx_disable,
>   	.gpio_request_enable	= at91_gpio_request_enable,
>   	.gpio_disable_free	= at91_gpio_disable_free,
>   };
> diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
> index 3d907de..5bcfd7a 100644
> --- a/drivers/pinctrl/pinctrl-bcm2835.c
> +++ b/drivers/pinctrl/pinctrl-bcm2835.c
> @@ -841,16 +841,6 @@ static int bcm2835_pmx_enable(struct pinctrl_dev *pctldev,
>   	return 0;
>   }
>   
> -static void bcm2835_pmx_disable(struct pinctrl_dev *pctldev,
> -		unsigned func_selector,
> -		unsigned group_selector)
> -{
> -	struct bcm2835_pinctrl *pc = pinctrl_dev_get_drvdata(pctldev);
> -
> -	/* disable by setting to GPIO_IN */
> -	bcm2835_pinctrl_fsel_set(pc, group_selector, BCM2835_FSEL_GPIO_IN);
> -}
> -
>   static void bcm2835_pmx_gpio_disable_free(struct pinctrl_dev *pctldev,
>   		struct pinctrl_gpio_range *range,
>   		unsigned offset)
> @@ -880,7 +870,6 @@ static const struct pinmux_ops bcm2835_pmx_ops = {
>   	.get_function_name = bcm2835_pmx_get_function_name,
>   	.get_function_groups = bcm2835_pmx_get_function_groups,
>   	.enable = bcm2835_pmx_enable,
> -	.disable = bcm2835_pmx_disable,
>   	.gpio_disable_free = bcm2835_pmx_gpio_disable_free,
>   	.gpio_set_direction = bcm2835_pmx_gpio_set_direction,
>   };
> diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
> index 8fe2ab0..4b145b5 100644
> --- a/drivers/pinctrl/pinctrl-exynos5440.c
> +++ b/drivers/pinctrl/pinctrl-exynos5440.c
> @@ -371,13 +371,6 @@ static int exynos5440_pinmux_enable(struct pinctrl_dev *pctldev, unsigned select
>   	return 0;
>   }
>   
> -/* disable a specified pinmux by writing to registers */
> -static void exynos5440_pinmux_disable(struct pinctrl_dev *pctldev,
> -					unsigned selector, unsigned group)
> -{
> -	exynos5440_pinmux_setup(pctldev, selector, group, false);
> -}
> -
>   /*
>    * The calls to gpio_direction_output() and gpio_direction_input()
>    * leads to this function call (via the pinctrl_gpio_direction_{input|output}()
> @@ -395,7 +388,6 @@ static const struct pinmux_ops exynos5440_pinmux_ops = {
>   	.get_function_name	= exynos5440_pinmux_get_fname,
>   	.get_function_groups	= exynos5440_pinmux_get_groups,
>   	.enable			= exynos5440_pinmux_enable,
> -	.disable		= exynos5440_pinmux_disable,
>   	.gpio_set_direction	= exynos5440_pinmux_gpio_set_direction,
>   };
>   
> diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
> index e43fbce..685ff72 100644
> --- a/drivers/pinctrl/pinctrl-msm.c
> +++ b/drivers/pinctrl/pinctrl-msm.c
> @@ -165,36 +165,11 @@ static int msm_pinmux_enable(struct pinctrl_dev *pctldev,
>   	return 0;
>   }
>   
> -static void msm_pinmux_disable(struct pinctrl_dev *pctldev,
> -			       unsigned function,
> -			       unsigned group)
> -{
> -	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
> -	const struct msm_pingroup *g;
> -	unsigned long flags;
> -	u32 val;
> -
> -	g = &pctrl->soc->groups[group];
> -
> -	if (WARN_ON(g->mux_bit < 0))
> -		return;
> -
> -	spin_lock_irqsave(&pctrl->lock, flags);
> -
> -	/* Clear the mux bits to select gpio mode */
> -	val = readl(pctrl->regs + g->ctl_reg);
> -	val &= ~(0x7 << g->mux_bit);
> -	writel(val, pctrl->regs + g->ctl_reg);
> -
> -	spin_unlock_irqrestore(&pctrl->lock, flags);
> -}
> -
>   static const struct pinmux_ops msm_pinmux_ops = {
>   	.get_functions_count	= msm_get_functions_count,
>   	.get_function_name	= msm_get_function_name,
>   	.get_function_groups	= msm_get_function_groups,
>   	.enable			= msm_pinmux_enable,
> -	.disable		= msm_pinmux_disable,
>   };
>   
>   static int msm_config_reg(struct msm_pinctrl *pctrl,
> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
> index 8f6f16e..a564251 100644
> --- a/drivers/pinctrl/pinctrl-nomadik.c
> +++ b/drivers/pinctrl/pinctrl-nomadik.c
> @@ -1765,21 +1765,6 @@ out_glitch:
>   	return ret;
>   }
>   
> -static void nmk_pmx_disable(struct pinctrl_dev *pctldev,
> -			    unsigned function, unsigned group)
> -{
> -	struct nmk_pinctrl *npct = pinctrl_dev_get_drvdata(pctldev);
> -	const struct nmk_pingroup *g;
> -
> -	g = &npct->soc->groups[group];
> -
> -	if (g->altsetting < 0)
> -		return;
> -
> -	/* Poke out the mux, set the pin to some default state? */
> -	dev_dbg(npct->dev, "disable group %s, %u pins\n", g->name, g->npins);
> -}
> -
>   static int nmk_gpio_request_enable(struct pinctrl_dev *pctldev,
>   				   struct pinctrl_gpio_range *range,
>   				   unsigned offset)
> @@ -1826,7 +1811,6 @@ static const struct pinmux_ops nmk_pinmux_ops = {
>   	.get_function_name = nmk_pmx_get_func_name,
>   	.get_function_groups = nmk_pmx_get_func_groups,
>   	.enable = nmk_pmx_enable,
> -	.disable = nmk_pmx_disable,
>   	.gpio_request_enable = nmk_gpio_request_enable,
>   	.gpio_disable_free = nmk_gpio_disable_free,
>   };
> diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
> index 96c60d2..5d2f611 100644
> --- a/drivers/pinctrl/pinctrl-rockchip.c
> +++ b/drivers/pinctrl/pinctrl-rockchip.c
> @@ -604,23 +604,6 @@ static int rockchip_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
>   	return 0;
>   }
>   
> -static void rockchip_pmx_disable(struct pinctrl_dev *pctldev,
> -					unsigned selector, unsigned group)
> -{
> -	struct rockchip_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
> -	const unsigned int *pins = info->groups[group].pins;
> -	struct rockchip_pin_bank *bank;
> -	int cnt;
> -
> -	dev_dbg(info->dev, "disable function %s group %s\n",
> -		info->functions[selector].name, info->groups[group].name);
> -
> -	for (cnt = 0; cnt < info->groups[group].npins; cnt++) {
> -		bank = pin_to_bank(info, pins[cnt]);
> -		rockchip_set_mux(bank, pins[cnt] - bank->pin_base, 0);
> -	}
> -}
> -
>   /*
>    * The calls to gpio_direction_output() and gpio_direction_input()
>    * leads to this function call (via the pinctrl_gpio_direction_{input|output}()
> @@ -663,7 +646,6 @@ static const struct pinmux_ops rockchip_pmx_ops = {
>   	.get_function_name	= rockchip_pmx_get_func_name,
>   	.get_function_groups	= rockchip_pmx_get_groups,
>   	.enable			= rockchip_pmx_enable,
> -	.disable		= rockchip_pmx_disable,
>   	.gpio_set_direction	= rockchip_pmx_gpio_set_direction,
>   };
>   
> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
> index 0324d4c..8b23419 100644
> --- a/drivers/pinctrl/pinctrl-samsung.c
> +++ b/drivers/pinctrl/pinctrl-samsung.c
> @@ -333,13 +333,6 @@ static int samsung_pinmux_enable(struct pinctrl_dev *pctldev, unsigned selector,
>   	return 0;
>   }
>   
> -/* disable a specified pinmux by writing to registers */
> -static void samsung_pinmux_disable(struct pinctrl_dev *pctldev,
> -					unsigned selector, unsigned group)
> -{
> -	samsung_pinmux_setup(pctldev, selector, group, false);
> -}
> -
>   /*
>    * The calls to gpio_direction_output() and gpio_direction_input()
>    * leads to this function call (via the pinctrl_gpio_direction_{input|output}()
> @@ -390,7 +383,6 @@ static const struct pinmux_ops samsung_pinmux_ops = {
>   	.get_function_name	= samsung_pinmux_get_fname,
>   	.get_function_groups	= samsung_pinmux_get_groups,
>   	.enable			= samsung_pinmux_enable,
> -	.disable		= samsung_pinmux_disable,
>   	.gpio_set_direction	= samsung_pinmux_gpio_set_direction,
>   };
>   
> diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
> index 2960557..ff6a2bd 100644
> --- a/drivers/pinctrl/pinctrl-single.c
> +++ b/drivers/pinctrl/pinctrl-single.c
> @@ -488,61 +488,6 @@ static int pcs_enable(struct pinctrl_dev *pctldev, unsigned fselector,
>   	return 0;
>   }
>   
> -static void pcs_disable(struct pinctrl_dev *pctldev, unsigned fselector,
> -					unsigned group)
> -{
> -	struct pcs_device *pcs;
> -	struct pcs_function *func;
> -	int i;
> -
> -	pcs = pinctrl_dev_get_drvdata(pctldev);
> -	/* If function mask is null, needn't disable it. */
> -	if (!pcs->fmask)
> -		return;
> -
> -	func = radix_tree_lookup(&pcs->ftree, fselector);
> -	if (!func) {
> -		dev_err(pcs->dev, "%s could not find function%i\n",
> -			__func__, fselector);
> -		return;
> -	}
> -
> -	/*
> -	 * Ignore disable if function-off is not specified. Some hardware
> -	 * does not have clearly defined disable function. For pin specific
> -	 * off modes, you can use alternate named states as described in
> -	 * pinctrl-bindings.txt.
> -	 */
> -	if (pcs->foff == PCS_OFF_DISABLED) {
> -		dev_dbg(pcs->dev, "ignoring disable for %s function%i\n",
> -			func->name, fselector);
> -		return;
> -	}
> -
> -	dev_dbg(pcs->dev, "disabling function%i %s\n",
> -		fselector, func->name);
> -
> -	for (i = 0; i < func->nvals; i++) {
> -		struct pcs_func_vals *vals;
> -		unsigned long flags;
> -		unsigned val, mask;
> -
> -		vals = &func->vals[i];
> -		raw_spin_lock_irqsave(&pcs->lock, flags);
> -		val = pcs->read(vals->reg);
> -
> -		if (pcs->bits_per_mux)
> -			mask = vals->mask;
> -		else
> -			mask = pcs->fmask;
> -
> -		val &= ~mask;
> -		val |= pcs->foff << pcs->fshift;
> -		pcs->write(val, vals->reg);
> -		raw_spin_unlock_irqrestore(&pcs->lock, flags);
> -	}
> -}
> -
>   static int pcs_request_gpio(struct pinctrl_dev *pctldev,
>   			    struct pinctrl_gpio_range *range, unsigned pin)
>   {
> @@ -575,7 +520,6 @@ static const struct pinmux_ops pcs_pinmux_ops = {
>   	.get_function_name = pcs_get_function_name,
>   	.get_function_groups = pcs_get_function_groups,
>   	.enable = pcs_enable,
> -	.disable = pcs_disable,
>   	.gpio_request_enable = pcs_request_gpio,
>   };
>   
> diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
> index bd725b0..67c2eb4 100644
> --- a/drivers/pinctrl/pinctrl-st.c
> +++ b/drivers/pinctrl/pinctrl-st.c
> @@ -935,11 +935,6 @@ static int st_pmx_enable(struct pinctrl_dev *pctldev, unsigned fselector,
>   	return 0;
>   }
>   
> -static void st_pmx_disable(struct pinctrl_dev *pctldev, unsigned selector,
> -		unsigned group)
> -{
> -}
> -
>   static int st_pmx_set_gpio_direction(struct pinctrl_dev *pctldev,
>   			struct pinctrl_gpio_range *range, unsigned gpio,
>   			bool input)
> @@ -962,7 +957,6 @@ static struct pinmux_ops st_pmxops = {
>   	.get_function_name	= st_pmx_get_fname,
>   	.get_function_groups	= st_pmx_get_groups,
>   	.enable			= st_pmx_enable,
> -	.disable		= st_pmx_disable,
>   	.gpio_set_direction	= st_pmx_set_gpio_direction,
>   };
>   
> diff --git a/drivers/pinctrl/pinctrl-tb10x.c b/drivers/pinctrl/pinctrl-tb10x.c
> index 26ca685..71c5d4f 100644
> --- a/drivers/pinctrl/pinctrl-tb10x.c
> +++ b/drivers/pinctrl/pinctrl-tb10x.c
> @@ -738,22 +738,6 @@ static int tb10x_pctl_enable(struct pinctrl_dev *pctl,
>   	return 0;
>   }
>   
> -static void tb10x_pctl_disable(struct pinctrl_dev *pctl,
> -			unsigned func_selector, unsigned group_selector)
> -{
> -	struct tb10x_pinctrl *state = pinctrl_dev_get_drvdata(pctl);
> -	const struct tb10x_pinfuncgrp *grp = &state->pingroups[group_selector];
> -
> -	if (grp->port < 0)
> -		return;
> -
> -	mutex_lock(&state->mutex);
> -
> -	state->ports[grp->port].count--;
> -
> -	mutex_unlock(&state->mutex);
> -}
> -
>   static struct pinmux_ops tb10x_pinmux_ops = {
>   	.get_functions_count = tb10x_get_functions_count,
>   	.get_function_name = tb10x_get_function_name,
> @@ -761,7 +745,6 @@ static struct pinmux_ops tb10x_pinmux_ops = {
>   	.gpio_request_enable = tb10x_gpio_request_enable,
>   	.gpio_disable_free = tb10x_gpio_disable_free,
>   	.enable = tb10x_pctl_enable,
> -	.disable = tb10x_pctl_disable,
>   };
>   
>   static struct pinctrl_desc tb10x_pindesc = {
> diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
> index 6545809..a7e6087 100644
> --- a/drivers/pinctrl/pinctrl-tegra.c
> +++ b/drivers/pinctrl/pinctrl-tegra.c
> @@ -290,30 +290,11 @@ static int tegra_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
>   	return 0;
>   }
>   
> -static void tegra_pinctrl_disable(struct pinctrl_dev *pctldev,
> -				  unsigned function, unsigned group)
> -{
> -	struct tegra_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
> -	const struct tegra_pingroup *g;
> -	u32 val;
> -
> -	g = &pmx->soc->groups[group];
> -
> -	if (WARN_ON(g->mux_reg < 0))
> -		return;
> -
> -	val = pmx_readl(pmx, g->mux_bank, g->mux_reg);
> -	val &= ~(0x3 << g->mux_bit);
> -	val |= g->func_safe << g->mux_bit;
> -	pmx_writel(pmx, val, g->mux_bank, g->mux_reg);
> -}
> -
>   static const struct pinmux_ops tegra_pinmux_ops = {
>   	.get_functions_count = tegra_pinctrl_get_funcs_count,
>   	.get_function_name = tegra_pinctrl_get_func_name,
>   	.get_function_groups = tegra_pinctrl_get_func_groups,
>   	.enable = tegra_pinctrl_enable,
> -	.disable = tegra_pinctrl_disable,
>   };
>   
>   static int tegra_pinconf_reg(struct tegra_pmx *pmx,
> diff --git a/drivers/pinctrl/pinctrl-tz1090-pdc.c b/drivers/pinctrl/pinctrl-tz1090-pdc.c
> index 5bf01c2..41e81a3 100644
> --- a/drivers/pinctrl/pinctrl-tz1090-pdc.c
> +++ b/drivers/pinctrl/pinctrl-tz1090-pdc.c
> @@ -574,33 +574,6 @@ static int tz1090_pdc_pinctrl_enable(struct pinctrl_dev *pctldev,
>   	return 0;
>   }
>   
> -static void tz1090_pdc_pinctrl_disable(struct pinctrl_dev *pctldev,
> -				       unsigned int function,
> -				       unsigned int group)
> -{
> -	struct tz1090_pdc_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
> -	const struct tz1090_pdc_pingroup *grp = &tz1090_pdc_groups[group];
> -
> -	dev_dbg(pctldev->dev, "%s(func=%u (%s), group=%u (%s))\n",
> -		__func__,
> -		function, tz1090_pdc_functions[function].name,
> -		group, tz1090_pdc_groups[group].name);
> -
> -	/* is it even a mux? */
> -	if (grp->drv)
> -		return;
> -
> -	/* does this group even control the function? */
> -	if (function != grp->func)
> -		return;
> -
> -	/* record the pin being unmuxed and update mux bit */
> -	spin_lock(&pmx->lock);
> -	pmx->mux_en &= ~BIT(grp->pins[0]);
> -	tz1090_pdc_pinctrl_mux(pmx, grp);
> -	spin_unlock(&pmx->lock);
> -}
> -
>   static const struct tz1090_pdc_pingroup *find_mux_group(
>   						struct tz1090_pdc_pmx *pmx,
>   						unsigned int pin)
> @@ -662,7 +635,6 @@ static struct pinmux_ops tz1090_pdc_pinmux_ops = {
>   	.get_function_name	= tz1090_pdc_pinctrl_get_func_name,
>   	.get_function_groups	= tz1090_pdc_pinctrl_get_func_groups,
>   	.enable			= tz1090_pdc_pinctrl_enable,
> -	.disable		= tz1090_pdc_pinctrl_disable,
>   	.gpio_request_enable	= tz1090_pdc_pinctrl_gpio_request_enable,
>   	.gpio_disable_free	= tz1090_pdc_pinctrl_gpio_disable_free,
>   };
> diff --git a/drivers/pinctrl/pinctrl-tz1090.c b/drivers/pinctrl/pinctrl-tz1090.c
> index bc9cd7a..2408221 100644
> --- a/drivers/pinctrl/pinctrl-tz1090.c
> +++ b/drivers/pinctrl/pinctrl-tz1090.c
> @@ -1479,63 +1479,6 @@ mux_pins:
>   }
>   
>   /**
> - * tz1090_pinctrl_disable() - Disable a function on a pin group.
> - * @pctldev:		Pin control data
> - * @function:		Function index to disable
> - * @group:		Group index to disable
> - *
> - * Disable a particular function on a group of pins. The per GPIO pin pseudo pin
> - * groups can be used (in which case the pin will be taken out of peripheral
> - * mode. Some convenience pin groups can also be used in which case the effect
> - * is the same as enabling the function on each individual pin in the group.
> - */
> -static void tz1090_pinctrl_disable(struct pinctrl_dev *pctldev,
> -				   unsigned int function, unsigned int group)
> -{
> -	struct tz1090_pmx *pmx = pinctrl_dev_get_drvdata(pctldev);
> -	struct tz1090_pingroup *grp;
> -	unsigned int pin_num, mux_group, i, npins;
> -	const unsigned int *pins;
> -
> -	/* group of pins? */
> -	if (group < ARRAY_SIZE(tz1090_groups)) {
> -		grp = &tz1090_groups[group];
> -		npins = grp->npins;
> -		pins = grp->pins;
> -		/*
> -		 * All pins in the group must belong to the same mux group,
> -		 * which allows us to just use the mux group of the first pin.
> -		 * By explicitly listing permitted pingroups for each function
> -		 * the pinmux core should ensure this is always the case.
> -		 */
> -	} else {
> -		pin_num = group - ARRAY_SIZE(tz1090_groups);
> -		npins = 1;
> -		pins = &pin_num;
> -	}
> -	mux_group = tz1090_mux_pins[*pins];
> -
> -	/* no mux group, but can still be individually muxed to peripheral */
> -	if (mux_group >= TZ1090_MUX_GROUP_MAX) {
> -		if (function == TZ1090_MUX_PERIP)
> -			goto unmux_pins;
> -		return;
> -	}
> -
> -	/* mux group already set to a different function? */
> -	grp = &tz1090_mux_groups[mux_group];
> -	dev_dbg(pctldev->dev, "%s: unmuxing %u pin(s) in '%s' from '%s'\n",
> -		__func__, npins, grp->name, tz1090_functions[function].name);
> -
> -	/* subtract pins from ref count and unmux individually */
> -	WARN_ON(grp->func_count < npins);
> -	grp->func_count -= npins;
> -unmux_pins:
> -	for (i = 0; i < npins; ++i)
> -		tz1090_pinctrl_perip_select(pmx, pins[i], false);
> -}
> -
> -/**
>    * tz1090_pinctrl_gpio_request_enable() - Put pin in GPIO mode.
>    * @pctldev:		Pin control data
>    * @range:		GPIO range
> @@ -1575,7 +1518,6 @@ static struct pinmux_ops tz1090_pinmux_ops = {
>   	.get_function_name	= tz1090_pinctrl_get_func_name,
>   	.get_function_groups	= tz1090_pinctrl_get_func_groups,
>   	.enable			= tz1090_pinctrl_enable,
> -	.disable		= tz1090_pinctrl_disable,
>   	.gpio_request_enable	= tz1090_pinctrl_gpio_request_enable,
>   	.gpio_disable_free	= tz1090_pinctrl_gpio_disable_free,
>   };
> diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
> index 209a01b..0959bb3 100644
> --- a/drivers/pinctrl/pinctrl-u300.c
> +++ b/drivers/pinctrl/pinctrl-u300.c
> @@ -970,19 +970,6 @@ static int u300_pmx_enable(struct pinctrl_dev *pctldev, unsigned selector,
>   	return 0;
>   }
>   
> -static void u300_pmx_disable(struct pinctrl_dev *pctldev, unsigned selector,
> -			     unsigned group)
> -{
> -	struct u300_pmx *upmx;
> -
> -	/* There is nothing to do with the power pins */
> -	if (selector == 0)
> -		return;
> -
> -	upmx = pinctrl_dev_get_drvdata(pctldev);
> -	u300_pmx_endisable(upmx, selector, false);
> -}
> -
>   static int u300_pmx_get_funcs_count(struct pinctrl_dev *pctldev)
>   {
>   	return ARRAY_SIZE(u300_pmx_functions);
> @@ -1008,7 +995,6 @@ static const struct pinmux_ops u300_pmx_ops = {
>   	.get_function_name = u300_pmx_get_func_name,
>   	.get_function_groups = u300_pmx_get_groups,
>   	.enable = u300_pmx_enable,
> -	.disable = u300_pmx_disable,
>   };
>   
>   static int u300_pin_config_get(struct pinctrl_dev *pctldev, unsigned pin,
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
> diff --git a/drivers/pinctrl/sh-pfc/pinctrl.c b/drivers/pinctrl/sh-pfc/pinctrl.c
> index e758af9..11db3ee 100644
> --- a/drivers/pinctrl/sh-pfc/pinctrl.c
> +++ b/drivers/pinctrl/sh-pfc/pinctrl.c
> @@ -345,27 +345,6 @@ done:
>   	return ret;
>   }
>   
> -static void sh_pfc_func_disable(struct pinctrl_dev *pctldev, unsigned selector,
> -				unsigned group)
> -{
> -	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
> -	struct sh_pfc *pfc = pmx->pfc;
> -	const struct sh_pfc_pin_group *grp = &pfc->info->groups[group];
> -	unsigned long flags;
> -	unsigned int i;
> -
> -	spin_lock_irqsave(&pfc->lock, flags);
> -
> -	for (i = 0; i < grp->nr_pins; ++i) {
> -		int idx = sh_pfc_get_pin_index(pfc, grp->pins[i]);
> -		struct sh_pfc_pin_config *cfg = &pmx->configs[idx];
> -
> -		cfg->type = PINMUX_TYPE_NONE;
> -	}
> -
> -	spin_unlock_irqrestore(&pfc->lock, flags);
> -}
> -
>   static int sh_pfc_gpio_request_enable(struct pinctrl_dev *pctldev,
>   				      struct pinctrl_gpio_range *range,
>   				      unsigned offset)
> @@ -464,7 +443,6 @@ static const struct pinmux_ops sh_pfc_pinmux_ops = {
>   	.get_function_name	= sh_pfc_get_function_name,
>   	.get_function_groups	= sh_pfc_get_function_groups,
>   	.enable			= sh_pfc_func_enable,
> -	.disable		= sh_pfc_func_disable,
>   	.gpio_request_enable	= sh_pfc_gpio_request_enable,
>   	.gpio_disable_free	= sh_pfc_gpio_disable_free,
>   	.gpio_set_direction	= sh_pfc_gpio_set_direction,
> diff --git a/drivers/pinctrl/sirf/pinctrl-sirf.c b/drivers/pinctrl/sirf/pinctrl-sirf.c
> index 76502aa..b01889c 100644
> --- a/drivers/pinctrl/sirf/pinctrl-sirf.c
> +++ b/drivers/pinctrl/sirf/pinctrl-sirf.c
> @@ -187,15 +187,6 @@ static int sirfsoc_pinmux_enable(struct pinctrl_dev *pmxdev, unsigned selector,
>   	return 0;
>   }
>   
> -static void sirfsoc_pinmux_disable(struct pinctrl_dev *pmxdev, unsigned selector,
> -	unsigned group)
> -{
> -	struct sirfsoc_pmx *spmx;
> -
> -	spmx = pinctrl_dev_get_drvdata(pmxdev);
> -	sirfsoc_pinmux_endisable(spmx, selector, false);
> -}
> -
>   static int sirfsoc_pinmux_get_funcs_count(struct pinctrl_dev *pmxdev)
>   {
>   	return sirfsoc_pmxfunc_cnt;
> @@ -241,7 +232,6 @@ static int sirfsoc_pinmux_request_gpio(struct pinctrl_dev *pmxdev,
>   
>   static struct pinmux_ops sirfsoc_pinmux_ops = {
>   	.enable = sirfsoc_pinmux_enable,
> -	.disable = sirfsoc_pinmux_disable,
>   	.get_functions_count = sirfsoc_pinmux_get_funcs_count,
>   	.get_function_name = sirfsoc_pinmux_get_func_name,
>   	.get_function_groups = sirfsoc_pinmux_get_groups,
> diff --git a/drivers/pinctrl/spear/pinctrl-spear.c b/drivers/pinctrl/spear/pinctrl-spear.c
> index 58bf686..f72cc4e 100644
> --- a/drivers/pinctrl/spear/pinctrl-spear.c
> +++ b/drivers/pinctrl/spear/pinctrl-spear.c
> @@ -274,12 +274,6 @@ static int spear_pinctrl_enable(struct pinctrl_dev *pctldev, unsigned function,
>   	return spear_pinctrl_endisable(pctldev, function, group, true);
>   }
>   
> -static void spear_pinctrl_disable(struct pinctrl_dev *pctldev,
> -		unsigned function, unsigned group)
> -{
> -	spear_pinctrl_endisable(pctldev, function, group, false);
> -}
> -
>   /* gpio with pinmux */
>   static struct spear_gpio_pingroup *get_gpio_pingroup(struct spear_pmx *pmx,
>   		unsigned pin)
> @@ -345,7 +339,6 @@ static const struct pinmux_ops spear_pinmux_ops = {
>   	.get_function_name = spear_pinctrl_get_func_name,
>   	.get_function_groups = spear_pinctrl_get_func_groups,
>   	.enable = spear_pinctrl_enable,
> -	.disable = spear_pinctrl_disable,
>   	.gpio_request_enable = gpio_request_enable,
>   	.gpio_disable_free = gpio_disable_free,
>   };
> diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> index 9802b67..0248008 100644
> --- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
> +++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
> @@ -141,17 +141,6 @@ static int wmt_pmx_enable(struct pinctrl_dev *pctldev,
>   	return wmt_set_pinmux(data, func_selector, pinnum);
>   }
>   
> -static void wmt_pmx_disable(struct pinctrl_dev *pctldev,
> -			    unsigned func_selector,
> -			    unsigned group_selector)
> -{
> -	struct wmt_pinctrl_data *data = pinctrl_dev_get_drvdata(pctldev);
> -	u32 pinnum = data->pins[group_selector].number;
> -
> -	/* disable by setting GPIO_IN */
> -	wmt_set_pinmux(data, WMT_FSEL_GPIO_IN, pinnum);
> -}
> -
>   static void wmt_pmx_gpio_disable_free(struct pinctrl_dev *pctldev,
>   				      struct pinctrl_gpio_range *range,
>   				      unsigned offset)
> @@ -180,7 +169,6 @@ static struct pinmux_ops wmt_pinmux_ops = {
>   	.get_function_name = wmt_pmx_get_function_name,
>   	.get_function_groups = wmt_pmx_get_function_groups,
>   	.enable = wmt_pmx_enable,
> -	.disable = wmt_pmx_disable,
>   	.gpio_disable_free = wmt_pmx_gpio_disable_free,
>   	.gpio_set_direction = wmt_pmx_gpio_set_direction,
>   };
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
For the pinctrl-ax500.c

Acked-by : Patrice Chotard <patrice.chotard@st.com>

Thanks
