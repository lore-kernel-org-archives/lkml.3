Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588Ab3JORtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:49:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32937 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933470Ab3JORtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:49:03 -0400
Message-ID: <525D8009.5040907@wwwdotorg.org>
Date: Tue, 15 Oct 2013 11:48:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 00/19] Introduce common infra for tegra clocks
References: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381848794-11761-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 08:52 AM, Peter De Schrijver wrote:
> This patchset introduces common infrastructure for clocks which exist in                                                                                       
> several Tegra SoCs. We also also move Tegra20, Tegra30 and Tegra114 to
> this new infrastructure.

I took my local branch based on next-20131014, and applied the following:

* Joseph's "ARM: tegra: add clock properties for devices of Tegra124".

* The patches from your "pull request for tegra clocks" of today (I just
cherry-picked the commits rather than merging the pull request).

* Your patch series "Introduce common infra for tegra clocks" of today.

* Your patch series "Tegra124 clock support" of today.

The resultant branch is at:
git://github.com:swarren/linux-tegra.git linux-next_common

When building, I see a number of section mismatches:

> WARNING: drivers/clk/tegra/built-in.o(.text+0x534): Section mismatch in reference from the function _tegra_clk_register_periph() to the function .init.text:get_reg_bank()
> The function _tegra_clk_register_periph() references
> the function __init get_reg_bank().
> This is often because _tegra_clk_register_periph lacks a __init 
> annotation or the annotation of get_reg_bank is wrong.
> 
> WARNING: drivers/clk/tegra/built-in.o(.text+0x9ec): Section mismatch in reference from the function tegra_clk_register_periph_gate() to the function .init.text:get_reg_bank()
> The function tegra_clk_register_periph_gate() references
> the function __init get_reg_bank().
> This is often because tegra_clk_register_periph_gate lacks a __init 
> annotation or the annotation of get_reg_bank is wrong.

There are more, but they refer to references from the same two
functions. You may need to add CONFIG_DEBUG_SECTION_MISMATCH=y to
.config to see these; I can't remember if that's included in
tegra_defconfig.

Testing on Venice2 (Tegra124): I see the following WARN during boot,
which I think is new relative to the internal branch you gave me yesterday:

> [    0.295386] ------------[ cut here ]------------
> [    0.300450] WARNING: CPU: 0 PID: 1 at drivers/clk/tegra/clk.c:187 tegra_init_from_table+0x78/0x158()
> [    0.310362] Modules linked in:
> [    0.313740] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc5-next-20131014-05418-g30b9d55 #48
> [    0.323397] [<c0016644>] (unwind_backtrace+0x0/0x138) from [<c001225c>] (show_stack+0x10/0x14)
> [    0.332753] [<c001225c>] (show_stack+0x10/0x14) from [<c0572274>] (dump_stack+0x80/0xc0)
> [    0.341559] [<c0572274>] (dump_stack+0x80/0xc0) from [<c0025d54>] (warn_slowpath_common+0x64/0x88)
> [    0.351283] [<c0025d54>] (warn_slowpath_common+0x64/0x88) from [<c0025d94>] (warn_slowpath_null+0x1c/0x24)
> [    0.361768] [<c0025d94>] (warn_slowpath_null+0x1c/0x24) from [<c07b4c1c>] (tegra_init_from_table+0x78/0x158)
> [    0.372440] [<c07b4c1c>] (tegra_init_from_table+0x78/0x158) from [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20)
> [    0.384138] [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20) from [<c079f9cc>] (tegra_dt_init+0xc/0xd8)
> [    0.394903] [<c079f9cc>] (tegra_dt_init+0xc/0xd8) from [<c079a580>] (customize_machine+0x1c/0x40)
> [    0.404535] [<c079a580>] (customize_machine+0x1c/0x40) from [<c00089e0>] (do_one_initcall+0xec/0x19c)
> [    0.414551] [<c00089e0>] (do_one_initcall+0xec/0x19c) from [<c0798ba8>] (kernel_init_freeable+0xfc/0x1c8)
> [    0.424944] [<c0798ba8>] (kernel_init_freeable+0xfc/0x1c8) from [<c056d5a8>] (kernel_init+0x8/0xe4)
> [    0.434764] [<c056d5a8>] (kernel_init+0x8/0xe4) from [<c000f0f8>] (ret_from_fork+0x14/0x3c)
> [    0.443850] ---[ end trace 98c2207379d4cf99 ]---

Testing on Cardhu (Tegra30): I see the following new WARNs during boot:

> [    0.495006] tegra_init_from_table: Failed to set rate 600000000 of disp1
> [    0.501960] ------------[ cut here ]------------
> [    0.506792] WARNING: CPU: 0 PID: 1 at drivers/clk/tegra/clk.c:196 tegra_init_from_table+0xc0/0x158()
> [    0.516233] Modules linked in:
> [    0.519446] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-rc5-next-20131014-05418-g30b9d55 #48
> [    0.528653] [<c0016644>] (unwind_backtrace+0x0/0x138) from [<c001225c>] (show_stack+0x10/0x14)
> [    0.537575] [<c001225c>] (show_stack+0x10/0x14) from [<c0572274>] (dump_stack+0x80/0xc0)
> [    0.545963] [<c0572274>] (dump_stack+0x80/0xc0) from [<c0025d54>] (warn_slowpath_common+0x64/0x88)
> [    0.555231] [<c0025d54>] (warn_slowpath_common+0x64/0x88) from [<c0025d94>] (warn_slowpath_null+0x1c/0x24)
> [    0.565213] [<c0025d94>] (warn_slowpath_null+0x1c/0x24) from [<c07b4c64>] (tegra_init_from_table+0xc0/0x158)
> [    0.575373] [<c07b4c64>] (tegra_init_from_table+0xc0/0x158) from [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20)
> [    0.586514] [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20) from [<c079f9cc>] (tegra_dt_init+0xc/0xd8)
> [    0.596770] [<c079f9cc>] (tegra_dt_init+0xc/0xd8) from [<c079a580>] (customize_machine+0x1c/0x40)
> [    0.605951] [<c079a580>] (customize_machine+0x1c/0x40) from [<c00089e0>] (do_one_initcall+0xec/0x19c)
> [    0.615486] [<c00089e0>] (do_one_initcall+0xec/0x19c) from [<c0798ba8>] (kernel_init_freeable+0xfc/0x1c8)
> [    0.625389] [<c0798ba8>] (kernel_init_freeable+0xfc/0x1c8) from [<c056d5a8>] (kernel_init+0x8/0xe4)
> [    0.634748] [<c056d5a8>] (kernel_init+0x8/0xe4) from [<c000f0f8>] (ret_from_fork+0x14/0x3c)
> [    0.643406] ---[ end trace 3b692d0aca5bdcbf ]---
> [    0.648221] tegra_init_from_table: Failed to set rate 600000000 of disp2
> [    0.655170] ------------[ cut here ]------------
> [    0.659985] WARNING: CPU: 0 PID: 1 at drivers/clk/tegra/clk.c:196 tegra_init_from_table+0xc0/0x158()
> [    0.669424] Modules linked in:
> [    0.672641] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.12.0-rc5-next-20131014-05418-g30b9d55 #48
> [    0.682801] [<c0016644>] (unwind_backtrace+0x0/0x138) from [<c001225c>] (show_stack+0x10/0x14)
> [    0.691716] [<c001225c>] (show_stack+0x10/0x14) from [<c0572274>] (dump_stack+0x80/0xc0)
> [    0.700089] [<c0572274>] (dump_stack+0x80/0xc0) from [<c0025d54>] (warn_slowpath_common+0x64/0x88)
> [    0.709356] [<c0025d54>] (warn_slowpath_common+0x64/0x88) from [<c0025d94>] (warn_slowpath_null+0x1c/0x24)
> [    0.719337] [<c0025d94>] (warn_slowpath_null+0x1c/0x24) from [<c07b4c64>] (tegra_init_from_table+0xc0/0x158)
> [    0.729496] [<c07b4c64>] (tegra_init_from_table+0xc0/0x158) from [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20)
> [    0.740633] [<c07b4e10>] (tegra_clocks_apply_init_table+0x18/0x20) from [<c079f9cc>] (tegra_dt_init+0xc/0xd8)
> [    0.750880] [<c079f9cc>] (tegra_dt_init+0xc/0xd8) from [<c079a580>] (customize_machine+0x1c/0x40)
> [    0.760058] [<c079a580>] (customize_machine+0x1c/0x40) from [<c00089e0>] (do_one_initcall+0xec/0x19c)
> [    0.769593] [<c00089e0>] (do_one_initcall+0xec/0x19c) from [<c0798ba8>] (kernel_init_freeable+0xfc/0x1c8)
> [    0.779485] [<c0798ba8>] (kernel_init_freeable+0xfc/0x1c8) from [<c056d5a8>] (kernel_init+0x8/0xe4)
> [    0.788843] [<c056d5a8>] (kernel_init+0x8/0xe4) from [<c000f0f8>] (ret_from_fork+0x14/0x3c)
> [    0.797483] ---[ end trace 3b692d0aca5bdcc0 ]---

Testing on Dalmore (Tegra114) and Harmony (Tegra20) seemed OK.

