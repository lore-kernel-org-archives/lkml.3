Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbaLDMD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:03:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43679 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbaLDMD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:03:56 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-58-54804da9b40f
Message-id: <1417694631.15300.5.camel@AMDC1943>
Subject: Re: [PATCH v3 1/3] clk: samsung: Fix clock disable failure because
 domain being gated
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
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
Date: Thu, 04 Dec 2014 13:03:51 +0100
In-reply-to: <54804A50.60509@samsung.com>
References: <1417690075-13483-1-git-send-email-k.kozlowski@samsung.com>
 <1417690075-13483-2-git-send-email-k.kozlowski@samsung.com>
 <54804A50.60509@samsung.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xa7orfRtCDA5ulLfYOGM9q0XblYPs
	Fkd/F1j0P37NbPF082Mmi7NNb9gtNj2+xmpxedccNosZ5/cxWaw9cpfd4umEi2wWh9+0s1qs
	2vWH0YHX4+/z6yweO2fdZffYtKqTzePOtT1sHpuX1Hv0bVnF6PF5k1wAexSXTUpqTmZZapG+
	XQJXxtbNs1gL+hwrdj7rZG1gfG3YxcjJISFgIrHw9y4mCFtM4sK99WxdjFwcQgJLGSUmdKxl
	hHA+M0psffSVFaSKV0Bf4nDXB6AqDg5hgQSJtVdVQMJsAsYSm5cvYQOxRYBKlqy6CGYzC/xm
	lpj6Iw7EZhFQlVja8YUFxOYU0JTo3juRCWL+EkaJg98/QjWoS0yat4gZZL6EgLJEY78bxFpB
	iR+T77FAlMhLbF7zlnkCo8AsJB2zkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7u
	JkZIxHzdwbj0mNUhRgEORiUe3gnX60OEWBPLiitzDzFKcDArifBqAeNNiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA2PqltlrzjTVbdvNlhT8YqWbrs2fpFVPpb1TvgX9VazhFJkuOu/+lDRf3ZM3
	5hy61S89lSUlPvfM84ez8gKXmS49v2NvaWdnMhvLioKVC3bOdOArfph7/X30r9h3q5eHqQfz
	zNA7cLDdin/F1TMp77fYtorbfV36SDgiT4GXk/vUjGv/dBoM10spsRRnJBpqMRcVJwIAsn4X
	rXYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-12-04 at 12:49 +0100, Sylwester Nawrocki wrote:
> On 04/12/14 11:47, Krzysztof Kozlowski wrote:
> > Audio subsystem clocks are located in separate block. If clock for this
> > block (from main clock domain) 'mau_epll' is gated then any read or
> > write to audss registers will block.
> > 
> > This was observed on Exynos 5420 platforms (Arndale Octa and Peach
> > Pi/Pit) after introducing runtime PM to pl330 DMA driver. After that
> > commit the 'mau_epll' was gated, because the "amba" clock was disabled
> > and there were no more users of mau_epll. The system hang on disabling
> > unused clocks from audss block.
> > 
> > Unfortunately the 'mau_epll' clock is not parent of some of audss clocks.
> > 
> > Whenever system wants to operate on audss clocks it has to enable epll
> > clock. The solution reuses common clk-gate/divider/mux code and duplicates
> > clk_register_*() functions.
> > 
> > Additionally this patch fixes memory leak of clock gate/divider/mux
> > structures. The leak exists in generic clk_register_*() functions. Patch
> > replaces them with custom code with managed allocation.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Reported-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > Reported-by: Kevin Hilman <khilman@kernel.org>
> > ---
> >  drivers/clk/samsung/clk-exynos-audss.c | 357 +++++++++++++++++++++++++++++----
> >  1 file changed, 321 insertions(+), 36 deletions(-)
> 
> In general I'm not happy with this as we are more than doubling LOC in this
> driver.  I don't have a better idea though ATM on how to address the issue for
> v3.19.  I suspect we will need a regmap based clocks for some Exynos clocks
> controllers in near future and then we could refactor this driver by using
> the common code.

The regmap-mmio could solve it in a cleaner way but that would be much
bigger task.

> 
> A few style comments below...
> 
> > +/*
> > + * A simplified copy of clk-gate.c:clk_register_gate() to mimic
> > + * clk-gate behavior while using customized ops.
> > + */
> > +static struct clk *audss_clk_register_gate(struct device *dev, const char *name,
> > +		const char *parent_name, unsigned long flags,
> > +		void __iomem *reg, u8 bit_idx)
> > +{
> > +	struct clk_gate *gate;
> > +	struct clk *clk;
> > +	struct clk_init_data init;
> > +
> > +	/* allocate the gate */
> > +	gate = devm_kzalloc(dev, sizeof(struct clk_gate), GFP_KERNEL);
> > +	if (!gate)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	init.name = name;
> > +	init.ops = &audss_clk_gate_ops;
> > +	init.flags = flags | CLK_IS_BASIC;
> > +	init.parent_names = (parent_name ? &parent_name : NULL);
> > +	init.num_parents = (parent_name ? 1 : 0);
> > +
> > +	/* struct clk_gate assignments */
> > +	gate->reg = reg;
> > +	gate->bit_idx = bit_idx;
> > +	gate->flags = 0;
> 
> The assignment here redundant, since the data structure has been allocated
> with kzalloc().

Sure. Most of these minor issues came from copying generic
clk_register_*().

> 
> > +	gate->lock = &lock;
> > +	gate->hw.init = &init;
> > +
> > +	clk = clk_register(dev, &gate->hw);
> > +
> > +	return clk;
> 
> Just do
> 	return clk_register(dev, &gate->hw);

OK.

> 
> > +}
> > +
> > +static unsigned long audss_clk_divider_recalc_rate(struct clk_hw *hw,
> > +		unsigned long parent_rate)
> > +{
> > +	unsigned long ret;
> > +
> > +	ret = pll_clk_enable();
> > +	if (ret) {
> > +		WARN(ret, "Could not enable epll clock\n");
> > +		return parent_rate;
> > +	}
> 
> How about moving the error log to pll_clk_enable() and making this
> 
> 	ret = pll_clk_enable();
> 	if (ret < 0)
> 		return parent_rate;
> ?

In other uses of pll_clk_enable(), the error is returned so I think
there is no need to print a warning. This is different because here
error cannot be returned.

> > +
> > +	ret = clk_divider_ops.recalc_rate(hw, parent_rate);
> > +
> > +	pll_clk_disable();
> > +
> > +	return ret;
> > +}
> > +
> 
> > +/*
> > + * A simplified copy of clk-divider.c:clk_register_divider() to mimic
> > + * clk-divider behavior while using customized ops.
> > + */
> > +static struct clk *audss_clk_register_divider(struct device *dev,
> > +		const char *name, const char *parent_name, unsigned long flags,
> > +		void __iomem *reg, u8 shift, u8 width)
> > +{
> > +	struct clk_divider *div;
> > +	struct clk *clk;
> > +	struct clk_init_data init;
> > +
> > +	/* allocate the divider */
> 
> Not sure if this comment helps in anything.

I'll remove it.

> 
> > +	div = devm_kzalloc(dev, sizeof(struct clk_divider), GFP_KERNEL);
> > +	if (!div)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	init.name = name;
> > +	init.ops = &audss_clk_divider_ops;
> > +	init.flags = flags | CLK_IS_BASIC;
> > +	init.parent_names = (parent_name ? &parent_name : NULL);
> > +	init.num_parents = (parent_name ? 1 : 0);
> > +
> > +	/* struct clk_divider assignments */
> > +	div->reg = reg;
> > +	div->shift = shift;
> > +	div->width = width;
> > +	div->flags = 0;
> 
> Redundant assignment.

OK.
> 
> > +	div->lock = &lock;
> > +	div->hw.init = &init;
> > +	div->table = NULL;
> 
> This could be safely removed as well, but up to you.

I'll remove it.

> 
> > +	/* register the clock */
> 
> That comment has really no value, I'd remove it.

OK.

> 
> > +	clk = clk_register(dev, &div->hw);
> > +
> > +	return clk;
> 
> Please change it to:
> 
> 	return clk_register(dev, &div->hw);

OK.

> > +}
> > +
> > +static u8 audss_clk_mux_get_parent(struct clk_hw *hw)
> > +{
> > +	u8 parent;
> > +	int ret;
> > +
> > +	ret = pll_clk_enable();
> > +	if (ret) {
> > +		WARN(ret, "Could not enable epll clock\n");
> > +		return -EINVAL; /* Just like clk_mux_get_parent() */
> 
> Do we need to overwrite the error code ? The error log could be moved
> inside pll_clk_enable() and it all would become:
> 
> 	ret = pll_clk_enable();
> 	if (ret < 0)
> 		return ret;
> 
Similar to previous case - the warning is here because return value does
not accept error condition. I'll re-use existing error code but if you
don't mind I think warning should stay here.

> > +	}
> > +
> > +	parent = clk_mux_ops.get_parent(hw);
> > +
> > +	pll_clk_disable();
> > +
> > +	return parent;
> > +}
> 
> > +/*
> > + * A simplified copy of clk-mux.c:clk_register_mux_table() to mimic
> > + * clk-mux behavior while using customized ops.
> > + */
> > +static struct clk *audss_clk_register_mux(struct device *dev, const char *name,
> > +		const char **parent_names, u8 num_parents, unsigned long flags,
> > +		void __iomem *reg, u8 shift, u8 width)
> > +{
> > +	struct clk_mux *mux;
> > +	struct clk *clk;
> > +	struct clk_init_data init;
> > +	u32 mask = BIT(width) - 1;
> > +
> > +	/* allocate the mux */
> 
> I'd remove this comment.

OK.

> 
> > +	mux = devm_kzalloc(dev, sizeof(struct clk_mux), GFP_KERNEL);
> > +	if (!mux)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	init.name = name;
> > +	init.ops = &audss_clk_mux_ops;
> > +	init.flags = flags | CLK_IS_BASIC;
> > +	init.parent_names = parent_names;
> > +	init.num_parents = num_parents;
> > +
> > +	/* struct clk_mux assignments */
> > +	mux->reg = reg;
> > +	mux->shift = shift;
> > +	mux->mask = mask;
> > +	mux->flags = 0;
> 
> Redundant assignment.

OK.

> 
> > +	mux->lock = &lock;
> > +	mux->table = NULL;
> 
> Ditto.

OK.

> 
> > +	mux->hw.init = &init;
> > +
> > +	clk = clk_register(dev, &mux->hw);
> > +
> > +	return clk;
> 
> 	return clk_register(dev, &mux->hw);

OK.

> > +}
> > +
> >  /* register exynos_audss clocks */
> >  static int exynos_audss_clk_probe(struct platform_device *pdev)
> >  {
> > @@ -98,6 +364,8 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
> >  		dev_err(&pdev->dev, "failed to map audss registers\n");
> >  		return PTR_ERR(reg_base);
> >  	}
> > +	/* epll don't have to be enabled for boards != Exynos5420 */
> 
> s/!=/other than/ ?
> s/epll/EPLL ?

OK.

Thanks for feedback!
Best regards,
Krzysztof

> 
> > +	epll = ERR_PTR(-ENODEV);
> >  
> >  	clk_table = devm_kzalloc(&pdev->dev,
> >  				sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
> 

