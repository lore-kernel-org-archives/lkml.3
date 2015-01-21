Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbbAUJxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:53:03 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:49099 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbbAUJw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:52:57 -0500
Message-ID: <54BF76F2.4030604@mm-sol.com>
Date: Wed, 21 Jan 2015 11:52:50 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/5] phy: qcom: Add Qualcomm PCIe PHY
References: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com> <1418404441-5518-3-git-send-email-svarbanov@mm-sol.com> <54BF6D5B.1010700@ti.com>
In-Reply-To: <54BF6D5B.1010700@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

Thanks for the comments!

On 01/21/2015 11:11 AM, Kishon Vijay Abraham I wrote:
> Hi,
> 
> On Friday 12 December 2014 10:43 PM, Stanimir Varbanov wrote:
>> Add a PCIe PHY driver used by PCIe host controller driver
>> on Qualcomm SoCs like Snapdragon 805.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
>>  drivers/phy/Kconfig         |    7 +
>>  drivers/phy/Makefile        |    1 +
>>  drivers/phy/phy-qcom-pcie.c |  311 +++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 319 insertions(+), 0 deletions(-)
>>  create mode 100644 drivers/phy/phy-qcom-pcie.c
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index 2a436e6..135bdcc 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -218,6 +218,13 @@ config PHY_QCOM_IPQ806X_SATA
>>  	depends on OF
>>  	select GENERIC_PHY
>>  
>> +config PHY_QCOM_PCIE
>> +	tristate "Qualcomm PCIe SerDes/PHY driver"
>> +	depends on ARCH_QCOM
>> +	depends on HAS_IOMEM
>> +	depends on OF
>> +	select GENERIC_PHY
> 
> Please add a small description about the driver here.

Sure I will.

<snip>

>> +static const struct phy_regs pcie_phy_regs[] = {
>> +	{ PCIE_PHY_POWER_DOWN_CONTROL,			0x03 },
>> +	{ QSERDES_COM_SYSCLK_EN_SEL,			0x08 },
>> +	{ QSERDES_COM_DEC_START1,			0x82 },
>> +	{ QSERDES_COM_DEC_START2,			0x03 },
>> +	{ QSERDES_COM_DIV_FRAC_START1,			0xd5 },
>> +	{ QSERDES_COM_DIV_FRAC_START2,			0xaa },
>> +	{ QSERDES_COM_DIV_FRAC_START3,			0x13 },
>> +	{ QSERDES_COM_PLLLOCK_CMP_EN,			0x01 },
>> +	{ QSERDES_COM_PLLLOCK_CMP1,			0x2b },
>> +	{ QSERDES_COM_PLLLOCK_CMP2,			0x68 },
>> +	{ QSERDES_COM_PLL_CRCTRL,			0xff },
>> +	{ QSERDES_COM_PLL_CP_SETI,			0x3f },
>> +	{ QSERDES_COM_PLL_IP_SETP,			0x07 },
>> +	{ QSERDES_COM_PLL_CP_SETP,			0x03 },
>> +	{ QSERDES_RX_CDR_CONTROL,			0xf3 },
>> +	{ QSERDES_RX_CDR_CONTROL2,			0x6b },
>> +	{ QSERDES_COM_RESETSM_CNTRL,			0x10 },
>> +	{ QSERDES_RX_RX_TERM_HIGHZ_CM_AC_COUPLE,	0x87 },
>> +	{ QSERDES_RX_RX_EQ_GAIN12,			0x54 },
>> +	{ PCIE_PHY_POWER_STATE_CONFIG1,			0xa3 },
>> +	{ PCIE_PHY_POWER_STATE_CONFIG2,			0xcb },
>> +	{ QSERDES_COM_PLL_RXTXEPCLK_EN,			0x10 },
>> +	{ PCIE_PHY_ENDPOINT_REFCLK_DRIVE,		0x10 },
>> +	{ PCIE_PHY_SW_RESET,				0x00 },
>> +	{ PCIE_PHY_START,				0x03 },
> 
> No magic values for register writes.

Unfortunately these register values are taken as they are in CAF
downstream kernel and there are no bit/fields description for them.

>> +};
>> +
>> +static void qcom_pcie_phy_init(struct qcom_pcie_phy *pcie)
>> +{
>> +	const struct phy_regs *regs = pcie_phy_regs;
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(pcie_phy_regs); i++)
>> +		writel(regs[i].val, pcie->base + regs[i].reg_offset);
>> +}
>> +
>> +static bool qcom_pcie_phy_is_ready(struct qcom_pcie_phy *pcie)
>> +{
>> +	u32 val = readl(pcie->base + PCIE_PHY_PCS_STATUS);
>> +
>> +	return val & BIT(6) ? false : true;
>> +}
>> +
>> +static int qcom_pcie_phy_power_on(struct phy *phy)
>> +{
>> +	struct qcom_pcie_phy *pcie = phy_get_drvdata(phy);
>> +	struct device *dev = pcie->dev;
>> +	int ret, retries;
>> +
>> +	ret = regulator_enable(pcie->vdda_pll);
>> +	if (ret) {
>> +		dev_err(dev, "cannot enable vdda_pll regulator\n");
>> +		return ret;
>> +	}
>> +
>> +	ret = regulator_enable(pcie->vdda);
>> +	if (ret) {
>> +		dev_err(dev, "cannot enable vdda regulator\n");
>> +		goto fail_vdda_pll;
>> +	}
>> +
>> +	ret = reset_control_deassert(pcie->res_phy);
>> +	if (ret) {
>> +		dev_err(dev, "cannot deassert phy reset\n");
>> +		goto fail_vdda;
>> +	}
>> +
>> +	qcom_pcie_phy_init(pcie);
>> +
>> +	usleep_range(PHY_DELAY_MIN_US, PHY_DELAY_MAX_US);
> 
> add a comment on why this delay is required.

Actually this delay is not required anymore and I will remove it in next
version. The delay which is important here is the delay between
clk_set_rate and clk_prepare_enable.

>> +
>> +	ret = clk_set_rate(pcie->clk, ~0);
> 
> What is the actual clock rate?

According to clk freq table in clock driver it could be 125Mhz or 250Mhz.

>> +	if (ret) {
>> +		dev_err(dev, "cannot set pipe clk rate\n");
>> +		goto fail_res;
>> +	}
>> +
>> +	/*
>> +	 * setting pipe rate takes time, try arbitrary delay before enabling
>> +	 * the clock
>> +	 */
>> +	retries = PIPE_CLK_RETRIES_COUNT;
>> +	do {
>> +		usleep_range(PIPE_CLK_DELAY_MIN_US, PIPE_CLK_DELAY_MAX_US);
>> +
>> +		ret = clk_prepare_enable(pcie->clk);
>> +		if (!ret)
>> +			break;
>> +	} while (retries--);
>> +
>> +	if (retries < 0) {
>> +		dev_err(dev, "cannot enable phy clock\n");
>> +		goto fail_res;
>> +	}
>> +
>> +	retries = PHY_RETRIES_COUNT;
>> +	do {
>> +		ret = qcom_pcie_phy_is_ready(pcie);
>> +		if (ret)
>> +			break;
>> +		usleep_range(PHY_DELAY_MIN_US, PHY_DELAY_MAX_US);
>> +	} while (retries--);
>> +
>> +	if (retries < 0) {
>> +		dev_err(dev, "phy failed to come up\n");
>> +		ret = -ETIMEDOUT;
>> +		goto fail;
>> +	}
>> +
>> +	return 0;
>> +
>> +fail:
>> +	clk_disable_unprepare(pcie->clk);
>> +fail_res:
>> +	reset_control_assert(pcie->res_phy);
>> +fail_vdda:
>> +	regulator_disable(pcie->vdda);
>> +fail_vdda_pll:
>> +	regulator_disable(pcie->vdda_pll);
>> +
>> +	return ret;
>> +}
>> +

<snip>

>> +
>> +	phy = devm_phy_create(dev, NULL, &qcom_pcie_phy_ops, NULL);
> 
> Please rebase it to the latest kernel.

Already done.

-- 
regards,
Stan
