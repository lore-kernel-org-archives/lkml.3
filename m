Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaJATFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:05:12 -0400
Received: from mail-bn1on0077.outbound.protection.outlook.com ([157.56.110.77]:32056
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751420AbaJATFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:05:11 -0400
Date: Wed, 1 Oct 2014 12:04:55 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devel@driverdev.osuosl.org>, Jason Wu <huanyu@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>, Chris Kohn <ckohn@xilinx.com>,
        <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] staging: Add Xilinx Clocking Wizard driver
References: <1412184108-16688-1-git-send-email-soren.brinkmann@xilinx.com>
 <20141001185835.GE23154@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141001185835.GE23154@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20984.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <673ac1aa-e105-4705-82f8-360fe98614a5@BN1AFFO11FD020.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(51704005)(377424004)(189002)(199003)(110136001)(50466002)(33646002)(1496007)(4396001)(85306004)(95666004)(106466001)(77096002)(87936001)(31696002)(85182001)(83506001)(86362001)(6806004)(92726001)(92566001)(85852003)(53416004)(23676002)(44976005)(70736001)(31966008)(20776003)(80022003)(76176999)(54356999)(10300001)(107046002)(50986999)(64706001)(47776003)(99396003)(46102003)(120916001)(85202003)(104016003)(19580395003)(76482002)(21056001)(102836001)(74316001)(107986001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB005;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0351D213B3
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 09:58PM +0300, Dan Carpenter wrote:
> On Wed, Oct 01, 2014 at 10:21:48AM -0700, Soren Brinkmann wrote:
> > +enum clk_wzrd_inp_clks {
> > +	wzrd_clk_in1,
> > +	wzrd_s_axi_aclk,
> > +	wzrd_clk_inp_max
> > +};
> > +
> > +enum clk_wzrd_int_clks {
> > +	wzrd_clk_mul,
> > +	wzrd_clk_mul_div,
> > +	wzrd_clk_int_max
> > +};
> > +
> > +/**
> > + * struct clk_wzrd:
> > + * @clk_data:		Clock data
> > + * @nb:			Notifier block
> > + * @base:		Memory base
> > + * @clkin:		Handle to input clocks
> > + * @clks_internal:	Internal clocks
> > + * @clkout:		Output clocks
> > + * @speed_grade:	Negated speed grade of the device
> > + * @suspended:		Flag indicating power state of the device
> > + */
> > +struct clk_wzrd {
> > +	struct clk_onecell_data clk_data;
> > +	struct notifier_block nb;
> > +	void __iomem *base;
> > +	struct clk *clkin[wzrd_clk_inp_max];
> > +	struct clk *clks_internal[wzrd_clk_int_max];
> 
> There is no advantage to using these arrays here.  It just makes the
> code more complicated to look at:
> 
> before:		clk_wzrd->clks_internal[wzrd_clk_mul_div] = ...
>  after:		clk_wzrd->mul_div = ...

Yeah, I was thinking about it, guess you're right.

> 
> > +	struct clk *clkout[WZRD_NUM_OUTPUTS];
> 
> This array makes sense, though.
> 
> > +	int speed_grade;
> > +	bool suspended;
> 
> suspended is always zero.  Delete it.

Right, because I forgot to implement the dev_pm_ops. It'll be fixed that
way.

[...]
> > +static int clk_wzrd_probe(struct platform_device *pdev)
> > +{
> > +	int i, ret;
> > +	u32 reg;
> > +	unsigned long rate;
> > +	const char *clk_name;
> > +	struct clk_wzrd *clk_wzrd;
> > +	struct resource *mem;
> > +	struct device_node *np = pdev->dev.of_node;
> > +
> > +	clk_wzrd = devm_kzalloc(&pdev->dev, sizeof(*clk_wzrd), GFP_KERNEL);
> > +	if (!clk_wzrd)
> > +		return -ENOMEM;
> > +	platform_set_drvdata(pdev, clk_wzrd);
> > +
> > +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	clk_wzrd->base = devm_ioremap_resource(&pdev->dev, mem);
> > +	if (IS_ERR(clk_wzrd->base))
> > +		return PTR_ERR(clk_wzrd->base);
> > +
> > +	ret = of_property_read_u32(np, "speed-grade", &clk_wzrd->speed_grade);
> > +	if (!ret) {
> > +		clk_wzrd->speed_grade = -clk_wzrd->speed_grade;
> > +		if (clk_wzrd->speed_grade < 1 || clk_wzrd->speed_grade > 3) {
> > +			dev_warn(&pdev->dev, "invalid speed grade\n");
> 
> Print what it was.
> 
> > +			clk_wzrd->speed_grade = 0;
> > +		}
> > +	}
> > +
> > +	clk_wzrd->clkin[wzrd_clk_in1] = devm_clk_get(&pdev->dev, "clk_in1");
> > +	if (IS_ERR(clk_wzrd->clkin[wzrd_clk_in1])) {
> > +		if (clk_wzrd->clkin[wzrd_clk_in1] != ERR_PTR(-EPROBE_DEFER))
> > +			dev_err(&pdev->dev, "clk_in1 not found\n");
> > +		return PTR_ERR(clk_wzrd->clkin[wzrd_clk_in1]);
> > +	}
> > +
> > +	clk_wzrd->clkin[wzrd_s_axi_aclk] = devm_clk_get(&pdev->dev, "s_axi_aclk");
> > +	if (IS_ERR(clk_wzrd->clkin[wzrd_s_axi_aclk])) {
> > +		if (clk_wzrd->clkin[wzrd_s_axi_aclk] != ERR_PTR(-EPROBE_DEFER))
> > +			dev_err(&pdev->dev, "s_axi_aclk not found\n");
> > +		return PTR_ERR(clk_wzrd->clkin[wzrd_s_axi_aclk]);
> > +	}
> > +	ret = clk_prepare_enable(clk_wzrd->clkin[wzrd_s_axi_aclk]);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "enabling s_axi_aclk failed\n");
> > +		return ret;
> > +	}
> > +	rate = clk_get_rate(clk_wzrd->clkin[wzrd_s_axi_aclk]);
> > +	if (rate > WZRD_ACLK_MAX_FREQ) {
> > +		dev_err(&pdev->dev, "s_axi_aclk frequency too high\n");
> 
> Print what it was.
> 
> > +		ret = -EINVAL;
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	/* we don't support fractional div/mul yet */
> > +	reg = readl(clk_wzrd->base + WZRD_CLK_CFG_REG(0)) & WZRD_CLkFBOUT_FRAC_EN;
> > +	reg |= readl(clk_wzrd->base + WZRD_CLK_CFG_REG(2)) & WZRD_CLkOUT0_FRAC_EN;
> > +	if (reg)
> > +		dev_warn(&pdev->dev, "fractional div/mul not supported\n");
> > +
> > +	/* register multiplier */
> > +	reg = (readl(clk_wzrd->base + WZRD_CLK_CFG_REG(0)) & WZRD_CLKFBOUT_MULT_MASK) >>
> > +				WZRD_CLKFBOUT_MULT_SHIFT;
> > +	clk_name = kasprintf(GFP_KERNEL, "%s_mul", dev_name(&pdev->dev));
> > +	if (!clk_name) {
> > +		ret = -ENOMEM;
> > +		goto err_disable_clk;
> > +	}
> > +	clk_wzrd->clks_internal[wzrd_clk_mul] = clk_register_fixed_factor(
> > +			&pdev->dev, clk_name,
> > +			__clk_get_name(clk_wzrd->clkin[wzrd_clk_in1]),
> > +			0, reg,1);
> > +	kfree(clk_name);
> > +	if (IS_ERR(clk_wzrd->clks_internal[wzrd_clk_mul])) {
> > +		dev_err(&pdev->dev, "unable to register fixed-factor clock\n");
> > +		ret = PTR_ERR(clk_wzrd->clks_internal[wzrd_clk_mul]);
> > +		goto err_disable_clk;
> > +	}
> > +
> > +	/* register div */
> > +	reg = (readl(clk_wzrd->base + WZRD_CLK_CFG_REG(0)) &
> > +			WZRD_DIVCLK_DIVIDE_MASK) >> WZRD_DIVCLK_DIVIDE_SHIFT;
> > +	clk_name = kasprintf(GFP_KERNEL, "%s_mul_div", dev_name(&pdev->dev));
> > +	clk_wzrd->clks_internal[wzrd_clk_mul_div] = clk_register_fixed_factor(
> > +			&pdev->dev, clk_name,
> > +			__clk_get_name(clk_wzrd->clks_internal[wzrd_clk_mul]),
> > +			0, 1, reg);
> > +	if (IS_ERR(clk_wzrd->clks_internal[wzrd_clk_mul_div])) {
> > +		dev_err(&pdev->dev, "unable to register divider clock\n");
> > +		ret = PTR_ERR(clk_wzrd->clks_internal[wzrd_clk_mul_div]);
> > +		goto err_rm_int_clk;
> > +	}
> > +
> > +	/* register div per output */
> > +	for (i = WZRD_NUM_OUTPUTS - 1; i >= 0 ; i--) {
> > +		const char *clkout_name;
> > +		if (of_property_read_string_index(np, "clock-output-names", i,
> > +					&clkout_name)) {
> > +			dev_err(&pdev->dev,
> > +					"clock output name not specified\n");
> 
> Run checkpatch.pl --strict over this code.
> 
> > +			ret = -EINVAL;
> > +			goto err_rm_int_clks;
> > +		}
> > +		reg = (readl(clk_wzrd->base + WZRD_CLK_CFG_REG(2) + i * 12) &
> > +				WZRD_CLKOUT_DIVIDE_MASK) >> WZRD_CLKOUT_DIVIDE_SHIFT;
> > +		clk_wzrd->clkout[i] = clk_register_fixed_factor(&pdev->dev,
> > +				clkout_name, clk_name, 0, 1, reg);
> 
> Alignment is hard to look at.
> 
> > +		if (IS_ERR(clk_wzrd->clkout[i])) {
> > +			dev_err(&pdev->dev, "unable to register divider clock\n");
> > +			ret = PTR_ERR(clk_wzrd->clkout[i]);
> > +			goto err_rm_int_clks;
> > +		}
> 
> The error handling for this loop should unregister ->clkout[i + 1] etc.
> Why is does this loop count backwards, just out of curiosity?

Yeah, lazy error handling :) I thought, if reading
clock-output-names[MAX] succeeds I'd could save checking some stuff
since it would guarantee that the other output-names existed too.
Unfortunately clk_register() can still fail.

	Sören
