Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaLCONH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:13:07 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31763 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaLCONE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:13:04 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b8-547f1a6cf85d
Message-id: <547F1A5F.8000502@samsung.com>
Date: Wed, 03 Dec 2014 15:12:47 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 2/5] clk: samsung: Fix clock disable failure because
 domain being gated
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
 <1417011857-10419-3-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1417011857-10419-3-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xa7o5UvUhBqu3KFpsnLGe1aLtykF2
	i6O/CyxevzC06H/8mtni6ebHTBZnm96wW2x6fI3V4vKuOWwWM87vY7K4fZnXYu2Ru+wWTydc
	ZLNYtesPowOfR0tzD5vH3+fXWTx2zrrL7rFpVSebx51re9g8Ni+p9+jbsorR4/MmuQCOKC6b
	lNSczLLUIn27BK6Mmw9PMBXsN6mY8+wAcwPjTK0uRk4OCQETiVvrnrBA2GISF+6tZ+ti5OIQ
	EljKKHHvwUUo5xOQc2sGI0gVr4CWxKUb15hAbBYBVYnNE/+DxdkEDCV6j/aB2aICERIn7+5h
	h6gXlPgx+R7YBhGgmoO7t4P1MgssYZH4s5MVxBYWSJCYsGwOE8SyVkaJlRt2sIEkOAU8JLb8
	/wOU4ABq0JO4f1ELoldeYvOat8wTGAVmIVkxC6FqFpKqBYzMqxhFU0uTC4qT0nON9IoTc4tL
	89L1kvNzNzFCIujrDsalx6wOMQpwMCrx8Dq8qwkRYk0sK67MPcQowcGsJML77FtdiBBvSmJl
	VWpRfnxRaU5q8SFGJg5OqQbGkPvyB7O0FjGyfovdf1xj89uAuPjgiA1HZXZ8Fl+rsdKp/I23
	9cqzqzlNWZ9nzXv0sNF67Y3u0ivlKZVrFA4zXan4YZE0wzLGM+u7yd5Dh+64B4ioe01hUl57
	qjS63f9IxLndn48JXjHl0Hj7rjp6yvkez1PFm3mefz2bXvxNSqZ7aadT5qlPSizFGYmGWsxF
	xYkAL9P06H4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 15:24, Krzysztof Kozlowski wrote:
> Audio subsystem clocks are located in separate block. If clock for this
> block (from main clock domain) 'mau_epll' is gated then any read or
> write to audss registers will block.
> 
> This was observed on Exynos 5420 platforms (Arndale Octa and Peach
> Pi/Pit) after introducing runtime PM to pl330 DMA driver. After that
> commit the 'mau_epll' was gated, because the "amba" clock was disabled
> and there were no more users of mau_epll. The system hang on disabling
> unused clocks from audss block.
> 
> Unfortunately the 'mau_epll' clock is not parent of some of audss clocks.
> 
> Whenever system wants to operate on audss clocks it has to enable epll
> clock. The solution reuses common clk-gate/divider/mux code and duplicates
> clk_register_*() functions. In the same time the patch tries to limit
> functional changes of the driver so it does not fix minor issues with existing
> code (like leaking memory allocated for clk-gate/clk-mux/clk-divider code).
> This is addressed later.

It seems we need separate functions for unregistering the standard
mux/gate/div clocks.

> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reported-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reported-by: Kevin Hilman <khilman@kernel.org>
> ---
>  drivers/clk/samsung/clk-exynos-audss.c | 346 +++++++++++++++++++++++++++++----
>  1 file changed, 311 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
> index 7c4368e75ede..9ec7de866ab4 100644
> --- a/drivers/clk/samsung/clk-exynos-audss.c
> +++ b/drivers/clk/samsung/clk-exynos-audss.c
> @@ -29,6 +29,7 @@ static DEFINE_SPINLOCK(lock);
>  static struct clk **clk_table;
>  static void __iomem *reg_base;
>  static struct clk_onecell_data clk_data;
> +static struct clk *pll_in;
>  
>  #define ASS_CLK_SRC 0x0
>  #define ASS_CLK_DIV 0x4
> @@ -75,6 +76,276 @@ static const struct of_device_id exynos_audss_clk_of_match[] = {
>  	{},
>  };
>  
> +static int pll_clk_enable(void)
> +{
> +	if (!IS_ERR(pll_in))
> +		return clk_enable(pll_in);
> +
> +	return 0;
> +}
> +
> +static void pll_clk_disable(void)
> +{
> +	if (!IS_ERR(pll_in))
> +		clk_disable(pll_in);
> +}
> +
> +static int audss_clk_gate_enable(struct clk_hw *hw)
> +{
> +	int ret;
> +
> +	ret = pll_clk_enable();
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_gate_ops.enable(hw);
> +
> +	pll_clk_disable();
> +
> +	return ret;
> +}
> +
> +static void audss_clk_gate_disable(struct clk_hw *hw)
> +{
> +	int ret;
> +
> +	ret = pll_clk_enable();
> +	if (ret)
> +		return;
> +
> +	clk_gate_ops.disable(hw);
> +
> +	pll_clk_disable();
> +}
> +
> +static int audss_clk_gate_is_enabled(struct clk_hw *hw)
> +{
> +	int ret;
> +
> +	ret = pll_clk_enable();
> +	if (ret)
> +		return ret;
> +
> +	ret = clk_gate_ops.is_enabled(hw);
> +
> +	pll_clk_disable();
> +
> +	return ret;
> +}
> +
> +static const struct clk_ops audss_clk_gate_ops = {
> +	.enable = audss_clk_gate_enable,
> +	.disable = audss_clk_gate_disable,
> +	.is_enabled = audss_clk_gate_is_enabled,
> +};

As Tomasz suggested a better approach could be to use regmap
and let it handle the PLL clock. Unfortunately there the regmap
is not supported for the base clock types in the clock core and
that would require even more work and more added code.

> +/*
> + * A simplified copy of clk-gate.c:clk_register_gate() to mimic
> + * clk-gate behavior while using customized ops.
> + *
> + * TODO: just like clk-gate it leaks memory for struct clk_gate.

Please squash patch 5/5 into this one for the next iteration.

> + */
> +static struct clk *audss_clk_register_gate(struct device *dev, const char *name,
> +		const char *parent_name, unsigned long flags, u8 bit_idx)
> +{
> +	struct clk_gate *gate;
> +	struct clk *clk;
> +	struct clk_init_data init;
> +
> +	/* allocate the gate */
> +	gate = kzalloc(sizeof(struct clk_gate), GFP_KERNEL);
> +	if (!gate)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init.name = name;
> +	init.ops = &audss_clk_gate_ops;
> +	init.flags = flags | CLK_IS_BASIC;
> +	init.parent_names = (parent_name ? &parent_name : NULL);
> +	init.num_parents = (parent_name ? 1 : 0);
> +
> +	/* struct clk_gate assignments */
> +	gate->reg = reg_base + ASS_CLK_GATE;
> +	gate->bit_idx = bit_idx;
> +	gate->flags = 0;
> +	gate->lock = &lock;
> +	gate->hw.init = &init;
> +
> +	clk = clk_register(dev, &gate->hw);
> +
> +	if (IS_ERR(clk))
> +		kfree(gate);
> +
> +	return clk;
> +}
> +

>  /* register exynos_audss clocks */
>  static int exynos_audss_clk_probe(struct platform_device *pdev)
>  {
> @@ -83,7 +354,7 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
>  	const char *mout_audss_p[] = {"fin_pll", "fout_epll"};
>  	const char *mout_i2s_p[] = {"mout_audss", "cdclk0", "sclk_audio0"};
>  	const char *sclk_pcm_p = "sclk_pcm0";
> -	struct clk *pll_ref, *pll_in, *cdclk, *sclk_audio, *sclk_pcm_in;

How about pll_in locally, using a different name for the global pointer
and ensuring the global pointer is properly initialized to ERR_PTR value
for cases where we don't need to touch the APLL clock ?

> +	struct clk *pll_ref, *cdclk, *sclk_audio, *sclk_pcm_in;
>  	const struct of_device_id *match;
>  	enum exynos_audss_clk_type variant;
>  
> @@ -115,12 +386,21 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
>  	pll_in = devm_clk_get(&pdev->dev, "pll_in");
>  	if (!IS_ERR(pll_ref))
>  		mout_audss_p[0] = __clk_get_name(pll_ref);
> -	if (!IS_ERR(pll_in))
> +	if (!IS_ERR(pll_in)) {
>  		mout_audss_p[1] = __clk_get_name(pll_in);
> -	clk_table[EXYNOS_MOUT_AUDSS] = clk_register_mux(NULL, "mout_audss",
> +
> +		ret = clk_prepare(pll_in);
> +		if (ret) {
> +			dev_err(&pdev->dev,
> +				"failed to prepare the pll_in clock\n");
> +			return ret;
> +		}

Let's introduce such chnages only for SoC's where that's really necessary,
AFAICS it seems to be needed only for "samsung,exynos5420-audss-clock"
compatible.

> +	}
> +
> +	clk_table[EXYNOS_MOUT_AUDSS] = audss_clk_register_mux(NULL, "mout_audss",
>  				mout_audss_p, ARRAY_SIZE(mout_audss_p),
> -				CLK_SET_RATE_NO_REPARENT,
> -				reg_base + ASS_CLK_SRC, 0, 1, 0, &lock);
> +				CLK_SET_RATE_NO_REPARENT, 0, 1);

I would prefer leaving the register's address in the arguments list.
Now you're passing the bit index but not the actual register.

>  	cdclk = devm_clk_get(&pdev->dev, "cdclk");
>  	sclk_audio = devm_clk_get(&pdev->dev, "sclk_audio");

--
Regards,
Sylwester
