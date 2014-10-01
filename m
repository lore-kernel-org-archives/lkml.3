Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaJAS6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:58:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350AbaJAS6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:58:49 -0400
Date: Wed, 1 Oct 2014 21:58:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jason Wu <huanyu@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, Chris Kohn <ckohn@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] staging: Add Xilinx Clocking Wizard driver
Message-ID: <20141001185835.GE23154@mwanda>
References: <1412184108-16688-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412184108-16688-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:21:48AM -0700, Soren Brinkmann wrote:
> +enum clk_wzrd_inp_clks {
> +	wzrd_clk_in1,
> +	wzrd_s_axi_aclk,
> +	wzrd_clk_inp_max
> +};
> +
> +enum clk_wzrd_int_clks {
> +	wzrd_clk_mul,
> +	wzrd_clk_mul_div,
> +	wzrd_clk_int_max
> +};
> +
> +/**
> + * struct clk_wzrd:
> + * @clk_data:		Clock data
> + * @nb:			Notifier block
> + * @base:		Memory base
> + * @clkin:		Handle to input clocks
> + * @clks_internal:	Internal clocks
> + * @clkout:		Output clocks
> + * @speed_grade:	Negated speed grade of the device
> + * @suspended:		Flag indicating power state of the device
> + */
> +struct clk_wzrd {
> +	struct clk_onecell_data clk_data;
> +	struct notifier_block nb;
> +	void __iomem *base;
> +	struct clk *clkin[wzrd_clk_inp_max];
> +	struct clk *clks_internal[wzrd_clk_int_max];

There is no advantage to using these arrays here.  It just makes the
code more complicated to look at:

before:		clk_wzrd->clks_internal[wzrd_clk_mul_div] = ...
 after:		clk_wzrd->mul_div = ...

> +	struct clk *clkout[WZRD_NUM_OUTPUTS];

This array makes sense, though.

> +	int speed_grade;
> +	bool suspended;

suspended is always zero.  Delete it.

> +};
> +#define to_clk_wzrd(_nb) container_of(_nb, struct clk_wzrd, nb);
> +
> +/* maximum frequencies for input/output clocks per speed grade */
> +static const unsigned long clk_wzrd_max_freq[] = {
> +	800000000UL,
> +	933000000UL,
> +	1066000000UL
> +};
> +
> +static int clk_wzrd_clk_notifier(struct notifier_block *nb, unsigned long event,
> +				 void *data)
> +{
> +	unsigned long max;
> +	struct clk_notifier_data *ndata = data;
> +	struct clk_wzrd *clk_wzrd = to_clk_wzrd(nb);
> +
> +	if (clk_wzrd->suspended)
> +		return NOTIFY_OK;
> +
> +	if (ndata->clk == clk_wzrd->clkin[wzrd_clk_in1])
> +		max = clk_wzrd_max_freq[clk_wzrd->speed_grade - 1];
> +	if (ndata->clk == clk_wzrd->clkin[wzrd_s_axi_aclk])
> +		max = WZRD_ACLK_MAX_FREQ;
> +
> +	switch (event) {
> +	case PRE_RATE_CHANGE:
> +		if (ndata->new_rate > max)
> +			return NOTIFY_BAD;
> +		return NOTIFY_OK;
> +	case POST_RATE_CHANGE:
> +	case ABORT_RATE_CHANGE:
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +}
> +
> +static int clk_wzrd_probe(struct platform_device *pdev)
> +{
> +	int i, ret;
> +	u32 reg;
> +	unsigned long rate;
> +	const char *clk_name;
> +	struct clk_wzrd *clk_wzrd;
> +	struct resource *mem;
> +	struct device_node *np = pdev->dev.of_node;
> +
> +	clk_wzrd = devm_kzalloc(&pdev->dev, sizeof(*clk_wzrd), GFP_KERNEL);
> +	if (!clk_wzrd)
> +		return -ENOMEM;
> +	platform_set_drvdata(pdev, clk_wzrd);
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	clk_wzrd->base = devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(clk_wzrd->base))
> +		return PTR_ERR(clk_wzrd->base);
> +
> +	ret = of_property_read_u32(np, "speed-grade", &clk_wzrd->speed_grade);
> +	if (!ret) {
> +		clk_wzrd->speed_grade = -clk_wzrd->speed_grade;
> +		if (clk_wzrd->speed_grade < 1 || clk_wzrd->speed_grade > 3) {
> +			dev_warn(&pdev->dev, "invalid speed grade\n");

Print what it was.

> +			clk_wzrd->speed_grade = 0;
> +		}
> +	}
> +
> +	clk_wzrd->clkin[wzrd_clk_in1] = devm_clk_get(&pdev->dev, "clk_in1");
> +	if (IS_ERR(clk_wzrd->clkin[wzrd_clk_in1])) {
> +		if (clk_wzrd->clkin[wzrd_clk_in1] != ERR_PTR(-EPROBE_DEFER))
> +			dev_err(&pdev->dev, "clk_in1 not found\n");
> +		return PTR_ERR(clk_wzrd->clkin[wzrd_clk_in1]);
> +	}
> +
> +	clk_wzrd->clkin[wzrd_s_axi_aclk] = devm_clk_get(&pdev->dev, "s_axi_aclk");
> +	if (IS_ERR(clk_wzrd->clkin[wzrd_s_axi_aclk])) {
> +		if (clk_wzrd->clkin[wzrd_s_axi_aclk] != ERR_PTR(-EPROBE_DEFER))
> +			dev_err(&pdev->dev, "s_axi_aclk not found\n");
> +		return PTR_ERR(clk_wzrd->clkin[wzrd_s_axi_aclk]);
> +	}
> +	ret = clk_prepare_enable(clk_wzrd->clkin[wzrd_s_axi_aclk]);
> +	if (ret) {
> +		dev_err(&pdev->dev, "enabling s_axi_aclk failed\n");
> +		return ret;
> +	}
> +	rate = clk_get_rate(clk_wzrd->clkin[wzrd_s_axi_aclk]);
> +	if (rate > WZRD_ACLK_MAX_FREQ) {
> +		dev_err(&pdev->dev, "s_axi_aclk frequency too high\n");

Print what it was.

> +		ret = -EINVAL;
> +		goto err_disable_clk;
> +	}
> +
> +	/* we don't support fractional div/mul yet */
> +	reg = readl(clk_wzrd->base + WZRD_CLK_CFG_REG(0)) & WZRD_CLkFBOUT_FRAC_EN;
> +	reg |= readl(clk_wzrd->base + WZRD_CLK_CFG_REG(2)) & WZRD_CLkOUT0_FRAC_EN;
> +	if (reg)
> +		dev_warn(&pdev->dev, "fractional div/mul not supported\n");
> +
> +	/* register multiplier */
> +	reg = (readl(clk_wzrd->base + WZRD_CLK_CFG_REG(0)) & WZRD_CLKFBOUT_MULT_MASK) >>
> +				WZRD_CLKFBOUT_MULT_SHIFT;
> +	clk_name = kasprintf(GFP_KERNEL, "%s_mul", dev_name(&pdev->dev));
> +	if (!clk_name) {
> +		ret = -ENOMEM;
> +		goto err_disable_clk;
> +	}
> +	clk_wzrd->clks_internal[wzrd_clk_mul] = clk_register_fixed_factor(
> +			&pdev->dev, clk_name,
> +			__clk_get_name(clk_wzrd->clkin[wzrd_clk_in1]),
> +			0, reg,1);
> +	kfree(clk_name);
> +	if (IS_ERR(clk_wzrd->clks_internal[wzrd_clk_mul])) {
> +		dev_err(&pdev->dev, "unable to register fixed-factor clock\n");
> +		ret = PTR_ERR(clk_wzrd->clks_internal[wzrd_clk_mul]);
> +		goto err_disable_clk;
> +	}
> +
> +	/* register div */
> +	reg = (readl(clk_wzrd->base + WZRD_CLK_CFG_REG(0)) &
> +			WZRD_DIVCLK_DIVIDE_MASK) >> WZRD_DIVCLK_DIVIDE_SHIFT;
> +	clk_name = kasprintf(GFP_KERNEL, "%s_mul_div", dev_name(&pdev->dev));
> +	clk_wzrd->clks_internal[wzrd_clk_mul_div] = clk_register_fixed_factor(
> +			&pdev->dev, clk_name,
> +			__clk_get_name(clk_wzrd->clks_internal[wzrd_clk_mul]),
> +			0, 1, reg);
> +	if (IS_ERR(clk_wzrd->clks_internal[wzrd_clk_mul_div])) {
> +		dev_err(&pdev->dev, "unable to register divider clock\n");
> +		ret = PTR_ERR(clk_wzrd->clks_internal[wzrd_clk_mul_div]);
> +		goto err_rm_int_clk;
> +	}
> +
> +	/* register div per output */
> +	for (i = WZRD_NUM_OUTPUTS - 1; i >= 0 ; i--) {
> +		const char *clkout_name;
> +		if (of_property_read_string_index(np, "clock-output-names", i,
> +					&clkout_name)) {
> +			dev_err(&pdev->dev,
> +					"clock output name not specified\n");

Run checkpatch.pl --strict over this code.

> +			ret = -EINVAL;
> +			goto err_rm_int_clks;
> +		}
> +		reg = (readl(clk_wzrd->base + WZRD_CLK_CFG_REG(2) + i * 12) &
> +				WZRD_CLKOUT_DIVIDE_MASK) >> WZRD_CLKOUT_DIVIDE_SHIFT;
> +		clk_wzrd->clkout[i] = clk_register_fixed_factor(&pdev->dev,
> +				clkout_name, clk_name, 0, 1, reg);

Alignment is hard to look at.

> +		if (IS_ERR(clk_wzrd->clkout[i])) {
> +			dev_err(&pdev->dev, "unable to register divider clock\n");
> +			ret = PTR_ERR(clk_wzrd->clkout[i]);
> +			goto err_rm_int_clks;
> +		}

The error handling for this loop should unregister ->clkout[i + 1] etc.
Why is does this loop count backwards, just out of curiosity?

regards,
dan carpenter

