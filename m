Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaJJIZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:25:08 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17973 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaJJIYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:24:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 10 Oct 2014 01:24:22 -0700
Date: Fri, 10 Oct 2014 11:24:34 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <ccross@android.com>,
        Barry Song <baohua@kernel.org>, Sachin Kamat <sachin.kamat@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: Re: [PATCH v2 4/4] clk: Use ww_mutexes for clk_prepare_{lock/unlock}
Message-ID: <20141010082434.GF29637@tbergstrom-lnx.Nvidia.com>
References: <1409792466-5092-1-git-send-email-sboyd@codeaurora.org>
 <1409792466-5092-5-git-send-email-sboyd@codeaurora.org>
 <20140928024131.19023.40641@quantum> <5429F555.9030108@codeaurora.org>
 <54348EC2.3040300@codeaurora.org> <20141009025923.4379.66113@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141009025923.4379.66113@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 07:59:23PM -0700, Mike Turquette wrote:
> Quoting Stephen Boyd (2014-10-07 18:09:22)
> > On 09/29/2014 05:12 PM, Stephen Boyd wrote:
> > >   I'm also auditing clock
> > > drivers to find potential brokenness.
> > >
> > 
> > These are places where we re-enter the framework under drivers/clk/. It 
> > looks like sirf can be ported to use determine_rate() and something like 
> > my "safe parent" patch. Tegra is concerning given that they call 
> > clk_get_rate() in atomic context which is bad because that 
> > clk_get_rate() can sleep on the prepare mutex. Otherwise we can probably 
> > just convert that to use the unlocked variants. I'm aware of the qcom 
> > one, maybe we need a framework flag that indicates that all parent 
> > clocks must be enabled to switch this clock's parent. The last one is 
> > versatile which I hope we can convert to use assigned-rates?
> 
> +Barry for SiRF
> +Sachin for Versatile
> +Viresh for SPEaR
> +Peter for Tegra
> 
> For those just joining the thread, Stephen's proposal to replace the
> global clk_prepare mutex with per-clock ww_mutexes breaks the reentrant
> behavior of the clock framework. He has identified the below spots where
> clock drivers rely on reentering into the framework. Can you take a look
> at them and see if it is possible to handle it another way?
> 
> I'm pretty happy to get rid of reentrancy for two reasons:
> 
> 1) Stephen's patch fixes the "spi deadlock problem", which reentrancy
> did not solve. Reentrancy only solved the "i2c deadlock problem" which
> the ww_mutex approach also solves nicely.
> 
> 2) The current reentrancy scheme does not take advantage of lockdep for
> checking correctness. It is very possible to silent hang yourself
> (though I've not seen any reports of that ... yet).
> 
> Regards,
> Mike
> 
> > 
> > drivers/clk/sirf/clk-common.c:409:        ret1 = clk_set_parent(hw->clk, 
> > clk_pll1.hw.clk);
> > drivers/clk/sirf/clk-common.c:414:        ret1 = clk_set_parent(hw->clk, 
> > clk_pll2.hw.clk);
> > drivers/clk/sirf/clk-common.c:419:        ret1 = clk_set_parent(hw->clk, 
> > clk_pll3.hw.clk);
> > drivers/clk/sirf/clk-common.c:427:        ret1 = clk_set_parent(hw->clk, 
> > clk_pll2.hw.clk);
> > drivers/clk/sirf/clk-common.c:433:    ret1 = clk_set_parent(hw->clk, 
> > clk_pll1.hw.clk);
> > drivers/clk/versatile/clk-sp810.c:103: clk_set_parent(hw->clk, new_parent);
> > drivers/clk/sirf/clk-common.c:431:    ret2 = 
> > clk_set_rate(clk_pll1.hw.clk, rate);
> > drivers/clk/qcom/mmcc-msm8960.c:520:        ret = 
> > clk_prepare_enable(clk_get_parent_by_index(clk, i));
> > drivers/clk/qcom/mmcc-msm8960.c:549: 
> > clk_disable_unprepare(clk_get_parent_by_index(clk, i));
> > Not necessary? drivers/clk/sirf/clk-common.c:168:    struct clk 
> > *parent_clk = clk_get_parent(hw->clk);
> > Not necessary? drivers/clk/sirf/clk-common.c:169:    struct clk 
> > *pll_parent_clk = clk_get_parent(parent_clk);
> > Not necessary! drivers/clk/sirf/clk-common.c:181:    struct clk 
> > *parent_clk = clk_get_parent(hw->clk);
> > drivers/clk/sirf/clk-common.c:423:    cur_parent = clk_get_parent(hw->clk);
> > drivers/clk/spear/clk-vco-pll.c:90: 
> > __clk_get_rate(__clk_get_parent(__clk_get_parent(hw->clk)));
> > drivers/clk/tegra/clk-pll.c:732:    unsigned long input_rate = 
> > clk_get_rate(clk_get_parent(hw->clk));
> > drivers/clk/tegra/clk-pll.c:1288:    unsigned long input_rate = 
> > clk_get_rate(clk_get_parent(hw->clk));

This is not so easy to change unfortunately. I will have to think of a solution.

Cheers,

Peter.
