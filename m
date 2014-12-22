Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbaLVSie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 13:38:34 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:39203 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaLVSic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 13:38:32 -0500
Message-ID: <54986525.3070305@codeaurora.org>
Date: Mon, 22 Dec 2014 10:38:29 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
CC: Rajendra Nayak <rnayak@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] clk: Fix __GFP_FS allocation with irqs disabled
References: <1419248747-3367-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1419248747-3367-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2014 03:45 AM, Krzysztof Kozlowski wrote:
> Allocation of memory for cached clock parents during s3c-sdhci probe was
> done with interrupts disabled which lead to lockdep warning:
>
> [    2.254980] s3c-sdhci 12530000.sdhci: clock source 2: mmc_busclk.2 (50000000 Hz)
> [    2.560726] ------------[ cut here ]------------
> [    2.565341] WARNING: CPU: 0 PID: 1 at kernel/locking/lockdep.c:2744 lockdep_trace_alloc+0xec/0x118()
> [    2.574439] DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
> [    2.579821] Modules linked in:
> [    2.583038] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W      3.18.0-next-20141216-00002-g4ff197fc1902-dirty #1318
> [    2.593796] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> [    2.599892] [<c0014c44>] (unwind_backtrace) from [<c0011bbc>] (show_stack+0x10/0x14)
> [    2.607612] [<c0011bbc>] (show_stack) from [<c04953b8>] (dump_stack+0x70/0xbc)
> [    2.614822] [<c04953b8>] (dump_stack) from [<c0023444>] (warn_slowpath_common+0x74/0xb0)
> [    2.622885] [<c0023444>] (warn_slowpath_common) from [<c0023514>] (warn_slowpath_fmt+0x30/0x40)
> [    2.631569] [<c0023514>] (warn_slowpath_fmt) from [<c0063644>] (lockdep_trace_alloc+0xec/0x118)
> [    2.640246] [<c0063644>] (lockdep_trace_alloc) from [<c00df52c>] (__kmalloc+0x3c/0x1cc)
> [    2.648240] [<c00df52c>] (__kmalloc) from [<c0394970>] (clk_fetch_parent_index+0xb8/0xd4)
> [    2.656390] [<c0394970>] (clk_fetch_parent_index) from [<c0394a6c>] (clk_calc_new_rates+0xe0/0x1fc)
> [    2.665415] [<c0394a6c>] (clk_calc_new_rates) from [<c0394b40>] (clk_calc_new_rates+0x1b4/0x1fc)
> [    2.674181] [<c0394b40>] (clk_calc_new_rates) from [<c0395408>] (clk_set_rate+0x50/0xc8)
> [    2.682265] [<c0395408>] (clk_set_rate) from [<c0377708>] (sdhci_cmu_set_clock+0x68/0x16c)

clk_set_rate() takes a mutex, so that looks to be the real problem here.
Don't call clk_set_rate() in a context where irqs are disabled.

> [    2.690503] [<c0377708>] (sdhci_cmu_set_clock) from [<c03735cc>] (sdhci_do_set_ios+0xf0/0x64c)
> [    2.699095] [<c03735cc>] (sdhci_do_set_ios) from [<c0373b48>] (sdhci_set_ios+0x20/0x2c)
> [    2.707080] [<c0373b48>] (sdhci_set_ios) from [<c035ddf0>] (mmc_power_up+0x118/0x1fc)
> [    2.714889] [<c035ddf0>] (mmc_power_up) from [<c035ecd0>] (mmc_start_host+0x44/0x6c)
> [    2.722615] [<c035ecd0>] (mmc_start_host) from [<c035fd60>] (mmc_add_host+0x58/0x7c)
> [    2.730341] [<c035fd60>] (mmc_add_host) from [<c037454c>] (sdhci_add_host+0x968/0xd94)
> [    2.738240] [<c037454c>] (sdhci_add_host) from [<c0377b60>] (sdhci_s3c_probe+0x354/0x52c)
> [    2.746406] [<c0377b60>] (sdhci_s3c_probe) from [<c0283b58>] (platform_drv_probe+0x48/0xa4)
> [    2.754733] [<c0283b58>] (platform_drv_probe) from [<c02824e8>] (driver_probe_device+0x13c/0x37c)
> [    2.763585] [<c02824e8>] (driver_probe_device) from [<c02827bc>] (__driver_attach+0x94/0x98)
> [    2.772003] [<c02827bc>] (__driver_attach) from [<c0280a60>] (bus_for_each_dev+0x54/0x88)
> [    2.780163] [<c0280a60>] (bus_for_each_dev) from [<c0281b48>] (bus_add_driver+0xe4/0x200)
> [    2.788322] [<c0281b48>] (bus_add_driver) from [<c0282dfc>] (driver_register+0x78/0xf4)
> [    2.796308] [<c0282dfc>] (driver_register) from [<c00089b0>] (do_one_initcall+0xac/0x1f0)
> [    2.804473] [<c00089b0>] (do_one_initcall) from [<c0673d94>] (kernel_init_freeable+0x10c/0x1d8)
> [    2.813153] [<c0673d94>] (kernel_init_freeable) from [<c0490058>] (kernel_init+0x28/0x108)
> [    2.821398] [<c0490058>] (kernel_init) from [<c000f268>] (ret_from_fork+0x14/0x2c)
> [    2.828939] ---[ end trace 03cc00e539849d1f ]---
>
> The memory for cached parents was not allocated during __clk_init()
> because the clock has only one parent and commit 9ca1c5a4bf41 ("clk:
> cache parent clocks only for muxes") made allocation skipped in such case.
>
> Be consequent also in clk_fetch_parent_index(): don't cache parents if
> there is only one.
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Fixes: 9ca1c5a4bf41 ("clk: cache parent clocks only for muxes")
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/clk/clk.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index f4963b7d4e17..35079302a650 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1150,6 +1150,12 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
>  {
>  	int i;
>  
> +	if (clk->num_parents == 1) {
> +		if (IS_ERR_OR_NULL(clk->parent))
> +			clk->parent = __clk_lookup(clk->parent_names[0]);
> +		return 0;
> +	}
> +
>  	if (!clk->parents) {
>  		clk->parents = kcalloc(clk->num_parents,
>  					sizeof(struct clk *), GFP_KERNEL);

This may be a worthwhile optimization, but I wonder why the clk_ops for
this clock need to fetch the parent index at all? Which clock are we
actually dealing with here?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

