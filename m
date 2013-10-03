Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab3JCTZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:25:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45828 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3JCTZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:25:39 -0400
Message-ID: <524DC4B1.4050100@codeaurora.org>
Date: Thu, 03 Oct 2013 12:25:37 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/2] hwrng: msm: Add PRNG support for MSM SoC's
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com> <1380811955-18085-3-git-send-email-svarbanov@mm-sol.com>
In-Reply-To: <1380811955-18085-3-git-send-email-svarbanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/13 07:52, Stanimir Varbanov wrote:
> +#define PRNG_CONFIG_MASK	0x00000002
> +#define PRNG_CONFIG_HW_ENABLE	BIT(1)

These two are the same so please drop the PRNG_CONFIG_MASK define and
just use the PRNG_CONFIG_HW_ENABLE define.

> +#define PRNG_STATUS_DATA_AVAIL	BIT(0)
> +
> +#define MAX_HW_FIFO_DEPTH	16
> +#define MAX_HW_FIFO_SIZE	(MAX_HW_FIFO_DEPTH * 4)
> +#define WORD_SZ			4
> +
> +struct msm_rng {
> +	void __iomem *base;
> +	struct clk *clk;
> +};
> +
> +static int msm_rng_enable(struct msm_rng *rng, int enable)
> +{
> +	u32 val;
> +	int ret;
> +
> +	ret = clk_prepare_enable(rng->clk);
> +	if (ret)
> +		return ret;
> +
> +	if (enable) {
> +		/* Enable PRNG only if it is not already enabled */
> +		val = readl_relaxed(rng->base + PRNG_CONFIG);
> +		if (val & PRNG_CONFIG_HW_ENABLE)
> +			goto already_enabled;
> +
> +		/* PRNG is not enabled */
> +		val = readl_relaxed(rng->base + PRNG_LFSR_CFG);
> +		val &= ~PRNG_LFSR_CFG_MASK;
> +		val |= PRNG_LFSR_CFG_CLOCKS;
> +		writel(val, rng->base + PRNG_LFSR_CFG);
> +
> +		val = readl_relaxed(rng->base + PRNG_CONFIG);
> +		val &= ~PRNG_CONFIG_MASK;
> +		val |= PRNG_CONFIG_HW_ENABLE;
> +		writel(val, rng->base + PRNG_CONFIG);

This could just be

		val = readl_relaxed(rng->base + PRNG_CONFIG);
		val |= PRNG_CONFIG_HW_ENABLE;
		writel(val, rng->base + PRNG_CONFIG);


> +	} else {
> +		val = readl_relaxed(rng->base + PRNG_CONFIG);
> +		val &= ~PRNG_CONFIG_MASK;
> +		writel(val, rng->base + PRNG_CONFIG);
> +	}
> +
> +already_enabled:
> +	clk_disable_unprepare(rng->clk);
> +	return 0;
> +}
> +
[...]
> +static int msm_rng_probe(struct platform_device *pdev)
> +{
> +	struct msm_rng *rng;
> +	struct device_node *np;
> +	struct resource res;
> +	int ret;
> +
> +	np = of_node_get(pdev->dev.of_node);
> +	if (!np)
> +		return -ENODEV;

This is unnecessary.

> +
> +	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
> +	if (!rng) {
> +		ret = -ENOMEM;
> +		goto err_exit;
> +	}
> +
> +	ret = of_address_to_resource(np, 0, &res);
> +	if (ret)
> +		goto err_exit;

We should just do

  res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
  rng->base = devm_ioremap_resource(&pdev->dev, res);
  if (IS_ERR(rng->base))
            return PTR_ERR(rng->base);

> +
> +	rng->base = devm_ioremap_resource(&pdev->dev, &res);
> +	if (IS_ERR(rng->base)) {
> +		ret = PTR_ERR(rng->base);
> +		goto err_exit;
> +	}
> +
> +	rng->clk = devm_clk_get(&pdev->dev, "prng");
> +	if (IS_ERR(rng->clk)) {
> +		ret = PTR_ERR(rng->clk);
> +		goto err_exit;
> +	}
> +
> +	msm_rng_ops.priv = (unsigned long) rng;
> +	ret = hwrng_register(&msm_rng_ops);
> +	if (ret)
> +		dev_err(&pdev->dev, "failed to register hwrng\n");
> +
> +err_exit:

Doing all that should make this goto exit path unnecessary.

> +	of_node_put(np);
> +	return ret;
> +}
> +
> +static int msm_rng_remove(struct platform_device *pdev)
> +{
> +	hwrng_unregister(&msm_rng_ops);
> +	return 0;
> +}
> +
> +static struct of_device_id msm_rng_of_match[] = {

const?

> +	{ .compatible = "qcom,prng", },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, msm_rng_of_match);
> +
> +static struct platform_driver msm_rng_driver = {
> +	.probe = msm_rng_probe,
> +	.remove = msm_rng_remove,
> +	.driver = {
> +		.name = KBUILD_MODNAME,
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(msm_rng_of_match),
> +	}
> +};
> +module_platform_driver(msm_rng_driver);
> +
> +MODULE_AUTHOR("The Linux Foundation");
> +MODULE_DESCRIPTION("Qualcomm MSM random number generator driver");
> +MODULE_LICENSE("GPL v2");


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

