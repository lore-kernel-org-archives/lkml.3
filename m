Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaDUQ5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:57:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55225 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDUQ5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:57:18 -0400
Date: Mon, 21 Apr 2014 11:54:00 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Kumar Gala <galak@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/4] soc: qcom: Add GSBI driver
Message-ID: <20140421165400.GA11778@joshc.qualcomm.com>
References: <1398058244-14099-1-git-send-email-agross@codeaurora.org>
 <1398058244-14099-3-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398058244-14099-3-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 12:30:42AM -0500, Andy Gross wrote:
> The GSBI (General Serial Bus Interface) driver controls the overarching
> configuration of the shared serial bus infrastructure on APQ8064, IPQ8064, and
> earlier QCOM processors.  The GSBI supports UART, I2C, SPI, and UIM
> functionality in various combinations.
> 
> Signed-off-by: Andy Gross <agross@codeaurora.org>
[..]
> +++ b/drivers/soc/qcom/qcom_gsbi.c
[..]
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +
> +#define GSBI_CTRL_REG		0x0000
> +#define GSBI_PROTOCOL_SHIFT	4
> +
> +struct gsbi_dev {
> +	struct device	*dev;
> +	void __iomem	*base;

You don't really need these.

> +
> +	struct clk	*hclk;
> +};
> +
> +static int gsbi_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	struct gsbi_dev *gsbi;
> +	struct resource *res;
> +	u32 mode;
> +
> +	gsbi = devm_kzalloc(&pdev->dev, sizeof(*gsbi), GFP_KERNEL);
> +	if (!gsbi)
> +		return -ENOMEM;
> +
> +	gsbi->dev = &pdev->dev;
> +	platform_set_drvdata(pdev, gsbi);
> +
> +	if (of_property_read_u32(node, "qcom,mode", &mode)) {
> +		dev_err(gsbi->dev, "missing mode configuration\n");
> +		return -EINVAL;
> +	}

I'm wondering if you should really be a (very simple) pinctrl driver
proper.

> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	gsbi->base = devm_ioremap_resource(gsbi->dev, res);
> +	if (IS_ERR(gsbi->base))
> +		return PTR_ERR(gsbi->base);
> +
> +	gsbi->hclk = devm_clk_get(gsbi->dev, "iface");
> +	if (IS_ERR(gsbi->hclk)) {
> +		dev_err(gsbi->dev, "Could not get core clock\n");
> +		return PTR_ERR(gsbi->hclk);
> +	}
> +	clk_prepare_enable(gsbi->hclk);
> +
> +	writel_relaxed((mode << GSBI_PROTOCOL_SHIFT), gsbi + GSBI_CTRL_REG);

Did you mean: gsbi->base + GSBI_CTRL_REG ?

> +
> +	/* make sure the gsbi control write is not reordered */
> +	wmb();
> +
> +	return of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
> +}
> +
> +static int gsbi_remove(struct platform_device *pdev)
> +{
> +	struct gsbi_dev *gsbi = platform_get_drvdata(pdev);
> +
> +	clk_disable_unprepare(gsbi->hclk);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id gsbi_dt_match[] = {

const

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
