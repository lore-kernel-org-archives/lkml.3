Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaJHBJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 21:09:25 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59065 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaJHBJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 21:09:24 -0400
Message-ID: <54348EC2.3040300@codeaurora.org>
Date: Tue, 07 Oct 2014 18:09:22 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ccross@android.com
Subject: Re: [PATCH v2 4/4] clk: Use ww_mutexes for clk_prepare_{lock/unlock}
References: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org> <1409792466-5092-5-git-send-email-sboyd@codeaurora.org> <20140928024131.19023.40641@quantum> <5429F555.9030108@codeaurora.org>
In-Reply-To: <5429F555.9030108@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2014 05:12 PM, Stephen Boyd wrote:
>   I'm also auditing clock
> drivers to find potential brokenness.
>

These are places where we re-enter the framework under drivers/clk/. It 
looks like sirf can be ported to use determine_rate() and something like 
my "safe parent" patch. Tegra is concerning given that they call 
clk_get_rate() in atomic context which is bad because that 
clk_get_rate() can sleep on the prepare mutex. Otherwise we can probably 
just convert that to use the unlocked variants. I'm aware of the qcom 
one, maybe we need a framework flag that indicates that all parent 
clocks must be enabled to switch this clock's parent. The last one is 
versatile which I hope we can convert to use assigned-rates?

drivers/clk/sirf/clk-common.c:409:        ret1 = clk_set_parent(hw->clk, 
clk_pll1.hw.clk);
drivers/clk/sirf/clk-common.c:414:        ret1 = clk_set_parent(hw->clk, 
clk_pll2.hw.clk);
drivers/clk/sirf/clk-common.c:419:        ret1 = clk_set_parent(hw->clk, 
clk_pll3.hw.clk);
drivers/clk/sirf/clk-common.c:427:        ret1 = clk_set_parent(hw->clk, 
clk_pll2.hw.clk);
drivers/clk/sirf/clk-common.c:433:    ret1 = clk_set_parent(hw->clk, 
clk_pll1.hw.clk);
drivers/clk/versatile/clk-sp810.c:103: clk_set_parent(hw->clk, new_parent);
drivers/clk/sirf/clk-common.c:431:    ret2 = 
clk_set_rate(clk_pll1.hw.clk, rate);
drivers/clk/qcom/mmcc-msm8960.c:520:        ret = 
clk_prepare_enable(clk_get_parent_by_index(clk, i));
drivers/clk/qcom/mmcc-msm8960.c:549: 
clk_disable_unprepare(clk_get_parent_by_index(clk, i));
Not necessary? drivers/clk/sirf/clk-common.c:168:    struct clk 
*parent_clk = clk_get_parent(hw->clk);
Not necessary? drivers/clk/sirf/clk-common.c:169:    struct clk 
*pll_parent_clk = clk_get_parent(parent_clk);
Not necessary! drivers/clk/sirf/clk-common.c:181:    struct clk 
*parent_clk = clk_get_parent(hw->clk);
drivers/clk/sirf/clk-common.c:423:    cur_parent = clk_get_parent(hw->clk);
drivers/clk/spear/clk-vco-pll.c:90: 
__clk_get_rate(__clk_get_parent(__clk_get_parent(hw->clk)));
drivers/clk/tegra/clk-pll.c:732:    unsigned long input_rate = 
clk_get_rate(clk_get_parent(hw->clk));
drivers/clk/tegra/clk-pll.c:1288:    unsigned long input_rate = 
clk_get_rate(clk_get_parent(hw->clk));
drivers/clk/versatile/clk-sp810.c:82:    struct clk *old_parent = 
__clk_get_parent(hw->clk);
drivers/clk/qcom/mmcc-msm8960.c:520:        ret = 
clk_prepare_enable(clk_get_parent_by_index(clk, i));
drivers/clk/versatile/clk-sp810.c:102: clk_prepare(new_parent);
drivers/clk/versatile/clk-sp810.c:104: clk_unprepare(old_parent);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

