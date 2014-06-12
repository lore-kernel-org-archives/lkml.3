Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaFLUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:16:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48952 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaFLUQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:16:56 -0400
Message-ID: <539A0AB6.90200@codeaurora.org>
Date: Thu, 12 Jun 2014 13:16:54 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Kishon Vijay Abraham I <kishon@ti.com>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] phy: qcom: Add driver for QCOM IPQ806x SATA PHY
References: <1402600724-20651-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1402600724-20651-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/14 12:18, Kumar Gala wrote:
> +
> +struct qcom_ipq806x_sata_phy {
> +	struct device *dev;

Is this used?

> +	void __iomem *mmio;
> +	struct clk *cfg_clk;
[...]
> +
> +static int qcom_ipq806x_sata_phy_init(struct phy *generic_phy)
> +{
> +	struct qcom_ipq806x_sata_phy *phy = phy_get_drvdata(generic_phy);
> +	u32 reg = 0;

unnecessary initialization

> +
> +static int qcom_ipq806x_sata_phy_exit(struct phy *generic_phy)
> +{
> +	struct qcom_ipq806x_sata_phy *phy = phy_get_drvdata(generic_phy);
> +	u32 reg = 0;

unnecessary initialization

>
> +static int qcom_ipq806x_sata_phy_probe(struct platform_device *pdev)
> +{
> +	struct qcom_ipq806x_sata_phy *phy;
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	struct phy_provider *phy_provider;
> +	struct phy *generic_phy;
> +	int ret;
> +
> +	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> +	if (!phy) {
> +		dev_err(dev, "%s: failed to allocate phy\n", __func__);
> +		return -ENOMEM;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	phy->mmio = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(phy->mmio)) {
> +		dev_err(dev, "%s: phy mmio get resource failed\n", __func__);

Unnecessary error message.

> +		return PTR_ERR(phy->mmio);
> +	}
> +
> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider)) {
> +		dev_err(dev, "%s: failed to register phy\n", __func__);
> +		return PTR_ERR(phy_provider);
> +	}
> +
> +	generic_phy = devm_phy_create(dev, &qcom_ipq806x_sata_phy_ops, NULL);
> +	if (IS_ERR(generic_phy)) {
> +		dev_err(dev, "%s: failed to create phy\n", __func__);
> +		return PTR_ERR(generic_phy);
> +	}
> +
> +	phy->cfg_clk = devm_clk_get(dev, "cfg");
> +	if (IS_ERR(phy->cfg_clk)) {
> +		dev_err(dev, "Failed to get sata cfg clock\n");
> +		return PTR_ERR(phy->cfg_clk);
> +	}
> +
> +	ret = clk_prepare_enable(phy->cfg_clk);
> +	if (ret)
> +		return ret;

Shouldn't there be a remove that disables this clock?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

