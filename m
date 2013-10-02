Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3JBUcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 16:32:18 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:33004 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3JBUcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 16:32:16 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 2/6] clk: exynos5410: register clocks using common clock framework
Date: Wed, 02 Oct 2013 22:32:14 +0200
Message-ID: <5525634.OHrUpYtaZv@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <1380644227-12244-3-git-send-email-v.tyrtov@samsung.com>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com> <1380644227-12244-3-git-send-email-v.tyrtov@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vyacheslav, Tarek,

On Tuesday 01 of October 2013 20:17:03 Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> The EXYNOS5410 clocks are statically listed and registered
> using the Samsung specific common clock helper functions.
[snip]
> +Required Properties:
> +
> +- comptible: should be one of the following.
> +  - "samsung,exynos5410-clock" - controller compatible with Exynos5410
> SoC. +

nit: There is only one compatible value supported by this driver, so "one 
of the following" sounds a bit strange.

> +- reg: physical base address of the controller and length of memory
> mapped +  region.
> +
> +- #clock-cells: should be 1.
[snip]
> +  mct			315
> +  mmc0			351
> +  mmc1			352
> +  mmc2			353
> +

As Bart already mentioned, it would be better to use preprocessor macros 
to define all the clock IDs, like it is done in s3c64xx clock driver and 
after applying Andrzej Hajda's patchs on all Exynos clock drivers.

> +Example 1: An example of a clock controller node is listed below.
> +
> +	clock: clock-controller@0x10010000 {
> +		compatible = "samsung,exynos5410-clock";
> +		reg = <0x10010000 0x30000>;
> +		#clock-cells = <1>;
> +	};
[snip]
> +PNAME(mpll_user_p)	= { "fin_pll", "sclk_mpll", };
> +PNAME(bpll_user_p)	= { "fin_pll", "sclk_bpll", };
> +PNAME(mpll_bpll_p)	= { "sclk_mpll_muxed", "sclk_bpll_muxed", };
> +
> +
> +
> +PNAME(group_main)	= {	"fin_pll", "fin_pll",
> +				"sclk_hdmi27m", "sclk_dptxphty",
> +				"sclk_usbhost20phy", "sclk_hdmiphy",
> +				"sclk_mpll_bpll", "sclk_epll",
> +				"sclk_vpll", "sclk_cpll" };

All mux inputs must be specified in parent lists, even those unused. This 
is, if a mux has 4-bit selector, then all 2^4 inputs must be specified, 
with unused ones set to "none". Otherwise this would lead to out of bound 
accesses from clock code.

> +
> +/* fixed rate clocks generated outside the soc */
> +struct samsung_fixed_rate_clock exynos5410_fixed_rate_ext_clks[]
> __initdata = {

static

> +	FRATE(fin_pll, "fin_pll", NULL, CLK_IS_ROOT, 0),
> +};
> +
> +struct samsung_mux_clock exynos5410_mux_clks[] __initdata = {

static

> +	MUX_A(none, "mout_apll", apll_p, SRC_CPU, 0, 1, "mout_apll"),
> +	MUX_A(none, "mout_cpu", mout_cpu_p, SRC_CPU, 16, 1, "mout_cpu"),
> +
> +	MUX_A(none, "mout_kpll", kpll_p, SRC_KFC, 0, 1, "mout_kpll"),
> +	MUX_A(none, "mout_kfc", mout_kfc_p, SRC_KFC, 16, 1, "mout_kfc"),

Do you actually need aliases for the four clocks above?

> +	MUX(none, "sclk_mpll", mpll_p, SRC_CPERI1, 8, 1),
> +	MUX(none, "sclk_mpll_muxed", mpll_user_p, SRC_TOP2, 20, 1),
[snip]
> +	DIV_A(none, "div_acp", "div_arm2", DIV_CPU0, 8, 3, "cpu_arm_clk"),
> +	DIV_A(none, "div_cpud", "div_arm2", DIV_CPU0, 4, 3, 
"cpu_aclk_cpud"),
> +	DIV_A(none, "div_atb", "div_arm2", DIV_CPU0, 16, 3, "cpu_atclk"),
> +	DIV_A(none, "pclk_dbg", "div_arm2", DIV_CPU0, 20, 3, 
"cpu_pclk_dbg"),
> +
> +
> +	DIV_A(none, "div_kfc", "mout_kfc", DIV_KFC0, 0, 3, "kfc_arm_clk"),
> +	DIV_A(none, "div_aclk", "div_kfc", DIV_KFC0, 4, 3, 
"kfc_aclk_cpud"),
> +	DIV_A(none, "div_pclk", "div_kfc", DIV_KFC0, 20, 3, 
"kfc_pclk_dbg"),

Same here.

> +
> +
> +	DIV(none, "aclk66_pre", "sclk_mpll_muxed", DIV_TOP1, 24, 3),
> +	DIV(none, "aclk66", "aclk66_pre", DIV_TOP0, 0, 3),
[snip]
> +struct samsung_gate_clock exynos5410_gate_clks[] __initdata = {

static

> +
> +	GATE(mct, "mct", "aclk66", GATE_IP_PERIS, 18, 0, 0),
[snip]
> +static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
> +	[apll] = PLL(pll_35xx, fout_apll, "fout_apll", "fin_pll", 0x0,
> +		0x100, NULL),
> +	[cpll] = PLL(pll_35xx, fout_mpll, "fout_cpll", "fin_pll", 0x10020,
> +		0x10120, NULL),
> +	[mpll] = PLL(pll_35xx, fout_mpll, "fout_mpll", "fin_pll", 0x4000,
> +		0x4100, NULL),
> +	[bpll] = PLL(pll_35xx, fout_bpll, "fout_bpll", "fin_pll", 0x20010,
> +		0x20110, NULL),
> +	[kpll] = PLL(pll_35xx, fout_kpll, "fout_kpll", "fin_pll", 0x28000,
> +		0x28100, NULL),

nit: It would be better if the magic register offsets above were defined 
as preprocessor macros as other registers used in this driver.

> +};
> +
> +static struct of_device_id ext_clk_match[] __initdata = {
> +	{ .compatible = "samsung,exynos5410-oscclk", .data = (void *)0, },
> +	{ },
> +};

Please consider using generic fixed rate clock bindings.

> +DEFINE_SPINLOCK(int_div_lock);

This does not seem to be used anywhere.

> +
> +/* register exynos5410 clocks */
> +void __init exynos5410_clk_init(struct device_node *np)

static

> +{
> +	void __iomem *reg_base;
> +
> +	if (np) {

This check is redundant, since this function can be only called from 
of_clk_init() with a valid pointer to device tree node.

Best regards,
Tomasz

