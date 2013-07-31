Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3GaFsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 01:48:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33320 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3GaFr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 01:47:59 -0400
Message-ID: <51F8A4FF.8020803@ti.com>
Date: Wed, 31 Jul 2013 11:17:43 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH v3 6/6] ARM: davinci: da850: configure system configuration
 chip(CFGCHIP3) for emac
References: <1371999607-6483-1-git-send-email-prabhakar.csengg@gmail.com> <1371999607-6483-7-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1371999607-6483-7-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 June 2013 08:30 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch makes a common function for to configure emac and calls
> it appropriately in DT and non DT boot mode. The system configuration
> chip CFGCHIP3, controls the emac module. This patch appropriately
> configures this register for emac and sets DA850_MII_MDIO_CLKEN_PIN
> GPIO pin appropriately.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Cc: netdev@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Heiko Schocher <hs@denx.de>
> ---
>  Changes for v2: none
>  Changes for v3:
>   a> added a common function in da850.c to configure
>      the CFGCHIP3 chip.
>      
>  arch/arm/mach-davinci/board-da850-evm.c    |   36 ++--------------------
>  arch/arm/mach-davinci/da850.c              |   45 ++++++++++++++++++++++++++++
>  arch/arm/mach-davinci/da8xx-dt.c           |   16 ++++++++++
>  arch/arm/mach-davinci/include/mach/da8xx.h |    1 +
>  4 files changed, 64 insertions(+), 34 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 8a24b6c..03dd1df 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -50,7 +50,6 @@
>  #include <media/tvp514x.h>
>  #include <media/adv7343.h>
>  
> -#define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
>  #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
>  #define DA850_LCD_BL_PIN		GPIO_TO_PIN(2, 15)
>  
> @@ -60,8 +59,6 @@
>  #define DA850_WLAN_EN			GPIO_TO_PIN(6, 9)
>  #define DA850_WLAN_IRQ			GPIO_TO_PIN(6, 10)
>  
> -#define DA850_MII_MDIO_CLKEN_PIN	GPIO_TO_PIN(2, 6)
> -
>  static struct mtd_partition da850evm_spiflash_part[] = {
>  	[0] = {
>  		.name = "UBL",
> @@ -1033,26 +1030,18 @@ static const short da850_evm_rmii_pins[] = {
>  
>  static int __init da850_evm_config_emac(void)
>  {
> -	void __iomem *cfg_chip3_base;
> -	int ret;
> -	u32 val;
>  	struct davinci_soc_info *soc_info = &davinci_soc_info;
>  	u8 rmii_en = soc_info->emac_pdata->rmii_en;
> +	int ret;
>  
>  	if (!machine_is_davinci_da850_evm())
>  		return 0;
>  
> -	cfg_chip3_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG);
> -
> -	val = __raw_readl(cfg_chip3_base);
> -
>  	if (rmii_en) {
> -		val |= BIT(8);
>  		ret = davinci_cfg_reg_list(da850_evm_rmii_pins);
>  		pr_info("EMAC: RMII PHY configured, MII PHY will not be"
>  							" functional\n");
>  	} else {
> -		val &= ~BIT(8);
>  		ret = davinci_cfg_reg_list(da850_evm_mii_pins);
>  		pr_info("EMAC: MII PHY configured, RMII PHY will not be"
>  							" functional\n");
> @@ -1062,28 +1051,7 @@ static int __init da850_evm_config_emac(void)
>  		pr_warn("%s: CPGMAC/RMII mux setup failed: %d\n",
>  			__func__, ret);
>  
> -	/* configure the CFGCHIP3 register for RMII or MII */
> -	__raw_writel(val, cfg_chip3_base);
> -
> -	ret = davinci_cfg_reg(DA850_GPIO2_6);
> -	if (ret)
> -		pr_warn("%s:GPIO(2,6) mux setup failed\n", __func__);
> -
> -	ret = gpio_request(DA850_MII_MDIO_CLKEN_PIN, "mdio_clk_en");
> -	if (ret) {
> -		pr_warn("Cannot open GPIO %d\n", DA850_MII_MDIO_CLKEN_PIN);
> -		return ret;
> -	}
> -
> -	/* Enable/Disable MII MDIO clock */
> -	gpio_direction_output(DA850_MII_MDIO_CLKEN_PIN, rmii_en);
> -
> -	soc_info->emac_pdata->phy_id = DA850_EVM_PHY_ID;
> -
> -	ret = da8xx_register_emac();
> -	if (ret)
> -		pr_warn("%s: EMAC registration failed: %d\n", __func__, ret);
> -
> +	da850_config_emac(0, rmii_en);
>  	return 0;
>  }
>  device_initcall(da850_evm_config_emac);
> diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
> index c43abee..d8021bb 100644
> --- a/arch/arm/mach-davinci/da850.c
> +++ b/arch/arm/mach-davinci/da850.c
> @@ -1197,6 +1197,51 @@ no_ddrpll_mem:
>  	return ret;
>  }
>  
> +void __init da850_config_emac(u32 dt_mode, u32 rmii_enabled)
> +{
> +#define DA850_MII_MDIO_CLKEN_PIN	GPIO_TO_PIN(2, 6)
> +#define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
> +
> +	void __iomem *cfg_chip3_base;
> +	int ret;
> +	u32 val;
> +
> +	cfg_chip3_base = DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG);
> +
> +	val = readl(cfg_chip3_base);
> +
> +	if (rmii_enabled)
> +		val |= BIT(8);
> +	else
> +		val &= ~BIT(8);
> +
> +	/* configure the CFGCHIP3 register for RMII or MII */
> +	writel(val, cfg_chip3_base);
> +
> +	ret = davinci_cfg_reg(DA850_GPIO2_6);
> +	if (ret)
> +		pr_warn("%s:GPIO(2,6) mux setup failed\n", __func__);
> +
> +	ret = gpio_request(DA850_MII_MDIO_CLKEN_PIN, "mdio_clk_en");
> +	if (ret) {
> +		pr_warn("Cannot open GPIO %d\n", DA850_MII_MDIO_CLKEN_PIN);
> +		return;
> +	}

You cannot do this in SoC specific code. All boards wont use a GPIO to
choose between MII/RMII. You need to do this in a EVM specific manner.
This just means you retain the GPIO part of code in board-da850-evm.c
and for the DT case use a board specific GPIO node. See a similar
example in arch/arm/boot/dts/ste-nomadik-s8815.dts and how the code uses
it in arch/arm/mach-nomadik/cpu-8815.c.

Thanks,
Sekhar
