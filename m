Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaLDLty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:49:54 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30194 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaLDLtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:49:52 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-65-54804a5e1d11
Message-id: <54804A50.60509@samsung.com>
Date: Thu, 04 Dec 2014 12:49:36 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v3 1/3] clk: samsung: Fix clock disable failure because
 domain being gated
References: <1417690075-13483-1-git-send-email-k.kozlowski@samsung.com>
 <1417690075-13483-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1417690075-13483-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xa7pxXg0hBq+OiVlsnLGe1aLtykF2
	i6O/CyxevzC06H/8mtni6ebHTBZnm96wW2x6fI3V4vKuOWwWM87vY7JYe+Quu8XTCRfZLFbt
	+sPowOvx9/l1Fo+ds+6ye2xa1cnmcefaHjaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8u
	gStjQ98CloIN5hV9DSvZGhjPaHcxcnJICJhI/OjYwQphi0lcuLeerYuRi0NIYCmjxJUT91gh
	nE+MEifOrwOr4hXQkHh+oYUJxGYRUJU4dHApWJxNwFCi92gfI4gtKhAhcfLuHnaIekGJH5Pv
	sYDYIkA1B3dvB+tlFvjNLDH1R1wXIweHsECCxNqrKhC7WhklHjxvB6vnFPCQaNiwnB2khllA
	T+L+RS2IVnmJzWveMk9gFJiFZMMshKpZSKoWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/d
	xAiJlq87GJceszrEKMDBqMTDO+F6fYgQa2JZcWXuIUYJDmYlEd5T1g0hQrwpiZVVqUX58UWl
	OanFhxiZODilGhizLtXHuAux9h3uyVHL+LHGeMWUfIV0pQud8Zs8l5z3rzDafCNqz6yLz/3N
	ylNFBDtebnSZelHJ0WtjAv8Uwblmnr3sccvUThyMXmR0t/O7TJqT9pZoiz8u/xh7pVv/z548
	95Z43tPemxHcf32MlyVYzuT5KSVwjGfCvQ//dz1tnug488WJ4molluKMREMt5qLiRADq8OxD
	dAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/14 11:47, Krzysztof Kozlowski wrote:
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
> clk_register_*() functions.
> 
> Additionally this patch fixes memory leak of clock gate/divider/mux
> structures. The leak exists in generic clk_register_*() functions. Patch
> replaces them with custom code with managed allocation.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reported-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reported-by: Kevin Hilman <khilman@kernel.org>
> ---
>  drivers/clk/samsung/clk-exynos-audss.c | 357 +++++++++++++++++++++++++++++----
>  1 file changed, 321 insertions(+), 36 deletions(-)

In general I'm not happy with this as we are more than doubling LOC in this
driver.  I don't have a better idea though ATM on how to address the issue for
v3.19.  I suspect we will need a regmap based clocks for some Exynos clocks
controllers in near future and then we could refactor this driver by using
the common code.

A few style comments below...

> +/*
> + * A simplified copy of clk-gate.c:clk_register_gate() to mimic
> + * clk-gate behavior while using customized ops.
> + */
> +static struct clk *audss_clk_register_gate(struct device *dev, const char *name,
> +		const char *parent_name, unsigned long flags,
> +		void __iomem *reg, u8 bit_idx)
> +{
> +	struct clk_gate *gate;
> +	struct clk *clk;
> +	struct clk_init_data init;
> +
> +	/* allocate the gate */
> +	gate = devm_kzalloc(dev, sizeof(struct clk_gate), GFP_KERNEL);
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
> +	gate->reg = reg;
> +	gate->bit_idx = bit_idx;
> +	gate->flags = 0;

The assignment here redundant, since the data structure has been allocated
with kzalloc().

> +	gate->lock = &lock;
> +	gate->hw.init = &init;
> +
> +	clk = clk_register(dev, &gate->hw);
> +
> +	return clk;

Just do
	return clk_register(dev, &gate->hw);

> +}
> +
> +static unsigned long audss_clk_divider_recalc_rate(struct clk_hw *hw,
> +		unsigned long parent_rate)
> +{
> +	unsigned long ret;
> +
> +	ret = pll_clk_enable();
> +	if (ret) {
> +		WARN(ret, "Could not enable epll clock\n");
> +		return parent_rate;
> +	}

How about moving the error log to pll_clk_enable() and making this

	ret = pll_clk_enable();
	if (ret < 0)
		return parent_rate;
?
> +
> +	ret = clk_divider_ops.recalc_rate(hw, parent_rate);
> +
> +	pll_clk_disable();
> +
> +	return ret;
> +}
> +

> +/*
> + * A simplified copy of clk-divider.c:clk_register_divider() to mimic
> + * clk-divider behavior while using customized ops.
> + */
> +static struct clk *audss_clk_register_divider(struct device *dev,
> +		const char *name, const char *parent_name, unsigned long flags,
> +		void __iomem *reg, u8 shift, u8 width)
> +{
> +	struct clk_divider *div;
> +	struct clk *clk;
> +	struct clk_init_data init;
> +
> +	/* allocate the divider */

Not sure if this comment helps in anything.

> +	div = devm_kzalloc(dev, sizeof(struct clk_divider), GFP_KERNEL);
> +	if (!div)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init.name = name;
> +	init.ops = &audss_clk_divider_ops;
> +	init.flags = flags | CLK_IS_BASIC;
> +	init.parent_names = (parent_name ? &parent_name : NULL);
> +	init.num_parents = (parent_name ? 1 : 0);
> +
> +	/* struct clk_divider assignments */
> +	div->reg = reg;
> +	div->shift = shift;
> +	div->width = width;
> +	div->flags = 0;

Redundant assignment.

> +	div->lock = &lock;
> +	div->hw.init = &init;
> +	div->table = NULL;

This could be safely removed as well, but up to you.

> +	/* register the clock */

That comment has really no value, I'd remove it.

> +	clk = clk_register(dev, &div->hw);
> +
> +	return clk;

Please change it to:

	return clk_register(dev, &div->hw);
> +}
> +
> +static u8 audss_clk_mux_get_parent(struct clk_hw *hw)
> +{
> +	u8 parent;
> +	int ret;
> +
> +	ret = pll_clk_enable();
> +	if (ret) {
> +		WARN(ret, "Could not enable epll clock\n");
> +		return -EINVAL; /* Just like clk_mux_get_parent() */

Do we need to overwrite the error code ? The error log could be moved
inside pll_clk_enable() and it all would become:

	ret = pll_clk_enable();
	if (ret < 0)
		return ret;

> +	}
> +
> +	parent = clk_mux_ops.get_parent(hw);
> +
> +	pll_clk_disable();
> +
> +	return parent;
> +}

> +/*
> + * A simplified copy of clk-mux.c:clk_register_mux_table() to mimic
> + * clk-mux behavior while using customized ops.
> + */
> +static struct clk *audss_clk_register_mux(struct device *dev, const char *name,
> +		const char **parent_names, u8 num_parents, unsigned long flags,
> +		void __iomem *reg, u8 shift, u8 width)
> +{
> +	struct clk_mux *mux;
> +	struct clk *clk;
> +	struct clk_init_data init;
> +	u32 mask = BIT(width) - 1;
> +
> +	/* allocate the mux */

I'd remove this comment.

> +	mux = devm_kzalloc(dev, sizeof(struct clk_mux), GFP_KERNEL);
> +	if (!mux)
> +		return ERR_PTR(-ENOMEM);
> +
> +	init.name = name;
> +	init.ops = &audss_clk_mux_ops;
> +	init.flags = flags | CLK_IS_BASIC;
> +	init.parent_names = parent_names;
> +	init.num_parents = num_parents;
> +
> +	/* struct clk_mux assignments */
> +	mux->reg = reg;
> +	mux->shift = shift;
> +	mux->mask = mask;
> +	mux->flags = 0;

Redundant assignment.

> +	mux->lock = &lock;
> +	mux->table = NULL;

Ditto.

> +	mux->hw.init = &init;
> +
> +	clk = clk_register(dev, &mux->hw);
> +
> +	return clk;

	return clk_register(dev, &mux->hw);
> +}
> +
>  /* register exynos_audss clocks */
>  static int exynos_audss_clk_probe(struct platform_device *pdev)
>  {
> @@ -98,6 +364,8 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "failed to map audss registers\n");
>  		return PTR_ERR(reg_base);
>  	}
> +	/* epll don't have to be enabled for boards != Exynos5420 */

s/!=/other than/ ?
s/epll/EPLL ?

> +	epll = ERR_PTR(-ENODEV);
>  
>  	clk_table = devm_kzalloc(&pdev->dev,
>  				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,

-- 
Thanks,
Sylwester
