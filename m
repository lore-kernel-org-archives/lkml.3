Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbaFEHan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:30:43 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:46171 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbaFEHam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:30:42 -0400
Message-ID: <53901C42.9070100@st.com>
Date: Thu, 5 Jun 2014 09:29:06 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: <fwu@marvell.com>, <linus.walleij@linaro.org>, <swarren@wwwdotorg.org>,
        <tony@atomide.com>, <plagnioj@jcrosoft.com>, <kgene.kim@samsung.com>,
        <heiko@sntech.de>, <t.figa@samsung.com>, <thomas.abraham@linaro.org>,
        <srinivas.kandagatla@gmail.com>, <patrice.chotard@st.com>,
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
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-05_02:2014-06-04,2014-06-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fan,

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

I would have preferred this patch to be split in multiple ones.
Anyway, if Linus W. agrees for one patch, that's fine for me too.

For the pinctrl-st changes, you can add my:

Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Thanks,
Maxime
