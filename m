Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaDDSPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:15:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57315 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbaDDSPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:15:00 -0400
Message-ID: <533EF6A3.9010003@codeaurora.org>
Date: Fri, 04 Apr 2014 11:14:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, Mike Turquette <mturquette@linaro.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] clk: qcom: Add support for IPQ8064's global clock controller
 (GCC)
References: <1396629001-6656-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1396629001-6656-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/14 09:30, Kumar Gala wrote:
> Add a driver for the global clock controller found on IPQ8064 based
> platforms. This should allow most non-multimedia device drivers to probe
> and control their clocks.
>
> This is currently missing clocks for SATA, USB, audio and networking
> devices.
>

There shouldn't be any audio clocks in GCC.

> diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc.txt b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
> index 767401f..74974d6 100644
> --- a/Documentation/devicetree/bindings/clock/qcom,gcc.txt
> +++ b/Documentation/devicetree/bindings/clock/qcom,gcc.txt
> @@ -4,6 +4,7 @@ Qualcomm Global Clock & Reset Controller Binding
>  Required properties :
>  - compatible : shall contain only one of the following:
>  
> +			"qcom,gcc-ipq8064"
>  			"qcom,gcc-msm8660"
>  			"qcom,gcc-msm8960"
>  			"qcom,gcc-msm8974"
> diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
> index 995bcfa..5d81f7d 100644
> --- a/drivers/clk/qcom/Kconfig
> +++ b/drivers/clk/qcom/Kconfig
> @@ -4,6 +4,14 @@ config COMMON_CLK_QCOM
>  	select REGMAP_MMIO
>  	select RESET_CONTROLLER
>  
> +config MSM_GCC_806X

It would be better to say IPQ_GCC_806X here instead of MSM.

> +	tristate "IPQ806x Global Clock Controller"
> +	depends on COMMON_CLK_QCOM
> +	help
> +	  Support for the global clock controller on ipq806x devices.
> +	  Say Y if you want to use peripheral devices such as UART, SPI,
> +	  i2c, USB, SD/eMMC, etc.
> +
>
> diff --git a/drivers/clk/qcom/gcc-ipq806x.c b/drivers/clk/qcom/gcc-ipq806x.c
> new file mode 100644
> index 0000000..cc5b6c8
> --- /dev/null
> +++ b/drivers/clk/qcom/gcc-ipq806x.c
[...]
> +static int gcc_ipq806x_probe(struct platform_device *pdev)
> +{
> +	struct clk *clk;
> +	struct device *dev = &pdev->dev;
> +
> +	/* Temporary until RPM clocks supported */
> +	clk = clk_register_fixed_rate(dev, "cxo", NULL, CLK_IS_ROOT, 19200000);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +
> +	clk = clk_register_fixed_rate(dev, "pxo", NULL, CLK_IS_ROOT, 27000000);

I thought PXO was 25MHz. Is there even a CXO present? It may just be PXO.

> diff --git a/include/dt-bindings/clock/qcom,gcc-ipq806x.h b/include/dt-bindings/clock/qcom,gcc-ipq806x.h
> new file mode 100644
> index 0000000..50a640e
> --- /dev/null
> +++ b/include/dt-bindings/clock/qcom,gcc-ipq806x.h

One thing I've been considering is moving the reset defines into the
same dt-binding include as the clocks. That way we cut down on the
number of files that are all related to the same thing. What do you think?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

