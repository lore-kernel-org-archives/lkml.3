Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaCXN2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:28:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43112 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbaCXN2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:28:46 -0400
Message-ID: <533032E5.2090004@ti.com>
Date: Mon, 24 Mar 2014 18:58:05 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tejun Heo <tj@kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, <linux-ide@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <spear-devel@list.st.com>
Subject: Re: [PATCH v2 3/3] ata: add new-style AHCI platform driver for DaVinci
 DA850 AHCI controller
References: <1395340026-3969-1-git-send-email-b.zolnierkie@samsung.com> <1395340026-3969-4-git-send-email-b.zolnierkie@samsung.com>
In-Reply-To: <1395340026-3969-4-git-send-email-b.zolnierkie@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014 11:57 PM, Bartlomiej Zolnierkiewicz wrote:
> Add the new ahci_da850 host driver and remove the deprecated
> ahci_platform_data platform code.
> 
> Please note that the new driver doesn't have the superfluous
> clock control code as clock is already handled by the generic
> AHCI platform library code.
> 
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Looks much better now and re-tested it on DA850 EVM. Few issues 
pointed out below.

> ---
> v2:
> - dropped the experimental tag from the config option help
> - fixed SYSCFG1 memory resource handling
> - hardcoded the multiplier data and added a note about it
> - used readl()/writel() instead of __raw_readl()/__raw_writel()
> - dropped the superflous clock control
> - cleaned up da850_sata_init()
> - changed the platform device name and removed the platform ids table
> - removed the deprecated ahci_platform_data platform code
> - updated the patch description
> 
>  arch/arm/mach-davinci/devices-da8xx.c |  99 +++--------------------------
>  drivers/ata/Kconfig                   |   9 +++
>  drivers/ata/Makefile                  |   1 +
>  drivers/ata/ahci_da850.c              | 116 ++++++++++++++++++++++++++++++++++
>  4 files changed, 134 insertions(+), 91 deletions(-)

I prefer not to mix platform and driver together in one patch. If you 
separate out the platform changes, I can take then through my tree with 
out risk of conflicts. The platform changes can come after the driver 
is introduced so there is no breakage.

>  create mode 100644 drivers/ata/ahci_da850.c
> 
> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> index 0486cdf2..72bb8d6 100644
> --- a/arch/arm/mach-davinci/devices-da8xx.c
> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> @@ -1020,7 +1020,6 @@ int __init da8xx_register_spi_bus(int instance, unsigned num_chipselect)
>  }
>  
>  #ifdef CONFIG_ARCH_DAVINCI_DA850
> -
>  static struct resource da850_sata_resources[] = {
>  	{
>  		.start	= DA850_SATA_BASE,
> @@ -1028,103 +1027,22 @@ static struct resource da850_sata_resources[] = {
>  		.flags	= IORESOURCE_MEM,
>  	},
>  	{
> +		.start	= DA8XX_SYSCFG1_BASE,
> +		.end	= DA8XX_SYSCFG1_BASE + SZ_4K - 1,
> +		.flags	= IORESOURCE_MEM,

This is not correct. The entire SYSCFG is not owned by SATA driver.
Its just that one PWRDN register. Here is a patch which applies on
top of your patch patch fixing it. Feel free to roll it in.

---8<---
diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index 72bb8d6..56ea41d 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -1027,8 +1027,8 @@ static struct resource da850_sata_resources[] = {
 		.flags	= IORESOURCE_MEM,
 	},
 	{
-		.start	= DA8XX_SYSCFG1_BASE,
-		.end	= DA8XX_SYSCFG1_BASE + SZ_4K - 1,
+		.start	= DA8XX_SYSCFG1_BASE + DA8XX_PWRDN_REG,
+		.end	= DA8XX_SYSCFG1_BASE + DA8XX_PWRDN_REG + 0x3,
 		.flags	= IORESOURCE_MEM,
 	},
 	{
diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
index 899270a..2c83613 100644
--- a/drivers/ata/ahci_da850.c
+++ b/drivers/ata/ahci_da850.c
@@ -16,8 +16,6 @@
 #include <linux/ahci_platform.h>
 #include "ahci.h"
 
-#define DA8XX_PWRDN_REG		0x18
-
 /* SATA PHY Control Register offset from AHCI base */
 #define SATA_P0PHYCR_REG	0x178
 
@@ -37,15 +35,15 @@
  */
 #define DA850_SATA_CLK_MULTIPLIER	7
 
-static void da850_sata_init(struct device *dev, void __iomem *syscfg1_base,
+static void da850_sata_init(struct device *dev, void __iomem *pwrdn_reg,
 			    void __iomem *ahci_base)
 {
 	unsigned int val;
 
 	/* Enable SATA clock receiver */
-	val = readl(syscfg1_base + DA8XX_PWRDN_REG);
+	val = readl(pwrdn_reg);
 	val &= ~BIT(0);
-	writel(val, syscfg1_base + DA8XX_PWRDN_REG);
+	writel(val, pwrdn_reg);
 
 	val = SATA_PHY_MPY(DA850_SATA_CLK_MULTIPLIER + 1) | SATA_PHY_LOS(1) |
 	      SATA_PHY_RXCDR(4) | SATA_PHY_RXEQ(1) | SATA_PHY_TXSWING(3) |
@@ -66,7 +64,7 @@ static int ahci_da850_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
 	struct resource *res;
-	void __iomem *syscfg1_base;
+	void __iomem *pwrdn_reg;
 	int rc;
 
 	hpriv = ahci_platform_get_resources(pdev);
@@ -81,11 +79,11 @@ static int ahci_da850_probe(struct platform_device *pdev)
 	if (!res)
 		goto disable_resources;
 
-	syscfg1_base = devm_ioremap(dev, res->start, resource_size(res));
-	if (!syscfg1_base)
+	pwrdn_reg = devm_ioremap(dev, res->start, resource_size(res));
+	if (!pwrdn_reg)
 		goto disable_resources;
 
-	da850_sata_init(dev, syscfg1_base, hpriv->mmio);
+	da850_sata_init(dev, pwrdn_reg, hpriv->mmio);
 
 	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info, 0, 0);
 	if (rc)
---

Also, there is an additional change required in platform side
to make sure clock look-up succeeds. Here is the change needed,
please roll it into your platform changes patch.

---8<---
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index 2ab0043..85399c9 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -472,7 +472,7 @@ static struct clk_lookup da850_clks[] = {
 	CLK("spi_davinci.0",	NULL,		&spi0_clk),
 	CLK("spi_davinci.1",	NULL,		&spi1_clk),
 	CLK("vpif",		NULL,		&vpif_clk),
-	CLK("ahci",		NULL,		&sata_clk),
+	CLK("ahci_da850",		NULL,		&sata_clk),
 	CLK("davinci-rproc.0",	NULL,		&dsp_clk),
 	CLK("ehrpwm",		"fck",		&ehrpwm_clk),
 	CLK("ehrpwm",		"tbclk",	&ehrpwm_tbclk),
---

Thanks,
Sekhar

