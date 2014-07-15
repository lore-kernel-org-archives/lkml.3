Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaGOPS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:18:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59347 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaGOPSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:18:22 -0400
Message-ID: <53C5460E.8010306@ti.com>
Date: Tue, 15 Jul 2014 20:47:34 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: <linux-ide@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <sboyd@codeaurora.org>,
        <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v5 1/2] phy: qcom: Add driver for QCOM IPQ806x SATA PHY
References: <1403030008-20675-1-git-send-email-galak@codeaurora.org> <53C54497.4010704@ti.com>
In-Reply-To: <53C54497.4010704@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday 15 July 2014 08:41 PM, Kishon Vijay Abraham I wrote:
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
>>  drivers/phy/Kconfig                 |   7 ++
>>  drivers/phy/Makefile                |   1 +
>>  drivers/phy/phy-qcom-ipq806x-sata.c | 206 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 214 insertions(+)
>>  create mode 100644 drivers/phy/phy-qcom-ipq806x-sata.c
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 16a2f06..b7b6bce 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -178,4 +178,11 @@ config PHY_XGENE
>>  	help
>>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
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

Btw the patch subject says 1/2 but I couldn't find the second patch. Can you
re-send both the patches?

Thanks
Kishon
> 
> Thanks
> Kishon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
