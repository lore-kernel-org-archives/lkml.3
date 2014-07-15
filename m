Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaGOQaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:30:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45729 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaGOQaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:30:14 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v5 1/2] phy: qcom: Add driver for QCOM IPQ806x SATA PHY
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <53C54497.4010704@ti.com>
Date: Tue, 15 Jul 2014 11:30:04 -0500
Cc: linux-ide@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, sboyd@codeaurora.org,
        b.zolnierkie@samsung.com
Content-Transfer-Encoding: 7BIT
Message-Id: <1B4D2ECA-7CD4-4E5D-97EC-375E92015ECC@codeaurora.org>
References: <1403030008-20675-1-git-send-email-galak@codeaurora.org> <53C54497.4010704@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 15, 2014, at 10:11 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:

> Hi,
> 
> On Wednesday 18 June 2014 12:03 AM, Kumar Gala wrote:
>> Add a PHY driver for uses with AHCI based SATA controller driver on the
>> IPQ806x family of SoCs.
>> 
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> v5:
>> * Fix copy/paste error when killing qcom_ipq806x_sata_delay_us
>> 
>> v4:
>> * removed qcom_ipq806x_sata_delay_us as it was only used one
>> 
>> v3:
>> * Added Kconfig HAS_IOMEM dep
>> * re-ordered probe function so phy_provider_register is last
>> 
>> v2:
>> * dropped unused dev pointer in struct qcom_ipq806x_sata_phy
>> * remove unnecessary reg initializaiton
>> * Removed unneeded error message
>> * Added remove function to disable the clock
>> 
>> drivers/phy/Kconfig                 |   7 ++
>> drivers/phy/Makefile                |   1 +
>> drivers/phy/phy-qcom-ipq806x-sata.c | 206 ++++++++++++++++++++++++++++++++++++
>> 3 files changed, 214 insertions(+)
>> create mode 100644 drivers/phy/phy-qcom-ipq806x-sata.c
>> 
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 16a2f06..b7b6bce 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -178,4 +178,11 @@ config PHY_XGENE
>> 	help
>> 	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>> 
> .
> .
> <snip>
> .
> .
>> +
>> +static int qcom_ipq806x_sata_phy_probe(struct platform_device *pdev)
>> +{
>> +	struct qcom_ipq806x_sata_phy *phy;
>> +	struct device *dev = &pdev->dev;
>> +	struct resource *res;
>> +	struct phy_provider *phy_provider;
>> +	struct phy *generic_phy;
>> +	int ret;
>> +
>> +	phy = devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
>> +	if (!phy) {
>> +		dev_err(dev, "%s: failed to allocate phy\n", __func__);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	phy->mmio = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(phy->mmio))
>> +		return PTR_ERR(phy->mmio);
>> +
>> +	generic_phy = devm_phy_create(dev, &qcom_ipq806x_sata_phy_ops, NULL);
>> +	if (IS_ERR(generic_phy)) {
>> +		dev_err(dev, "%s: failed to create phy\n", __func__);
>> +		return PTR_ERR(generic_phy);
>> +	}
>> +
>> +	phy_set_drvdata(generic_phy, phy);
>> +
>> +	phy->cfg_clk = devm_clk_get(dev, "cfg");
>> +	if (IS_ERR(phy->cfg_clk)) {
>> +		dev_err(dev, "Failed to get sata cfg clock\n");
>> +		return PTR_ERR(phy->cfg_clk);
>> +	}
>> +
>> +	ret = clk_prepare_enable(phy->cfg_clk);
>> +	if (ret)
>> +		return ret;
>> +
>> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
>> +	if (IS_ERR(phy_provider)) {
>> +		clk_disable_unprepare(phy->cfg_clk);
>> +		dev_err(dev, "%s: failed to register phy\n", __func__);
>> +		return PTR_ERR(phy_provider);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int qcom_ipq806x_sata_phy_remove(struct platform_device *pdev)
>> +{
>> +	struct qcom_ipq806x_sata_phy *phy = platform_get_drvdata(pdev);
> 
> Where is platform_set_drvdata()?

Fixed in v6

- k


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

