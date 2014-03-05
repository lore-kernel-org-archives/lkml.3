Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbaCEElT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 23:41:19 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:44732 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbaCEElP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 23:41:15 -0500
MIME-Version: 1.0
In-Reply-To: <1393961226-25618-3-git-send-email-gdjakov@mm-sol.com>
References: <1393961226-25618-1-git-send-email-gdjakov@mm-sol.com>
	<1393961226-25618-3-git-send-email-gdjakov@mm-sol.com>
Date: Wed, 5 Mar 2014 05:41:14 +0100
Message-ID: <CAPDyKFoQ3GW_Xw-x0+-Ohg8ZKFo9wmrFvePdGQqe1MLEaaJx7g@mail.gmail.com>
Subject: Re: [PATCH v10 2/3] mmc: sdhci-msm: Initial support for Qualcomm chipsets
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2014 20:27, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> This platform driver adds the initial support of Secure
> Digital Host Controller Interface compliant controller
> found in Qualcomm chipsets.
>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
> Tested-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
>  drivers/mmc/host/Kconfig     |   13 ++
>  drivers/mmc/host/Makefile    |    1 +
>  drivers/mmc/host/sdhci-msm.c |  427 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 441 insertions(+)
>  create mode 100644 drivers/mmc/host/sdhci-msm.c
>
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index 82cc34d..66ef8b9 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -334,6 +334,19 @@ config MMC_ATMELMCI
>
>           If unsure, say N.
>
> +config MMC_SDHCI_MSM
> +       tristate "Qualcomm SDHCI Controller Support"
> +       depends on ARCH_QCOM
> +       depends on MMC_SDHCI_PLTFM
> +       help
> +         This selects the Secure Digital Host Controller Interface (SDHCI)
> +         support present in Qualcomm SOCs. The controller supports
> +         SD/MMC/SDIO devices.
> +
> +         If you have a controller with this interface, say Y or M here.
> +
> +         If unsure, say N.
> +
>  config MMC_MSM
>         tristate "Qualcomm SDCC Controller Support"
>         depends on MMC && (ARCH_MSM7X00A || ARCH_MSM7X30 || ARCH_QSD8X50)
> diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
> index f162f87a0..0c8aa5e 100644
> --- a/drivers/mmc/host/Makefile
> +++ b/drivers/mmc/host/Makefile
> @@ -63,6 +63,7 @@ obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)      += sdhci-of-esdhc.o
>  obj-$(CONFIG_MMC_SDHCI_OF_HLWD)                += sdhci-of-hlwd.o
>  obj-$(CONFIG_MMC_SDHCI_BCM_KONA)       += sdhci-bcm-kona.o
>  obj-$(CONFIG_MMC_SDHCI_BCM2835)                += sdhci-bcm2835.o
> +obj-$(CONFIG_MMC_SDHCI_MSM)            += sdhci-msm.o
>
>  ifeq ($(CONFIG_CB710_DEBUG),y)
>         CFLAGS-cb710-mmc        += -DDEBUG
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> new file mode 100644
> index 0000000..46e4e0b
> --- /dev/null
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -0,0 +1,427 @@
> +/*
> + * drivers/mmc/host/sdhci-msm.c - Qualcomm SDHCI Platform driver
> + *
> + * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/delay.h>
> +
> +#include "sdhci-pltfm.h"
> +
> +#define CORE_HC_MODE           0x78
> +#define HC_MODE_EN             0x1
> +
> +#define CORE_POWER             0x0
> +#define CORE_SW_RST            BIT(7)
> +
> +#define CORE_PWRCTL_STATUS     0xdc
> +#define CORE_PWRCTL_MASK       0xe0
> +#define CORE_PWRCTL_CLEAR      0xe4
> +#define CORE_PWRCTL_CTL                0xe8
> +
> +#define CORE_PWRCTL_BUS_OFF    BIT(0)
> +#define CORE_PWRCTL_BUS_ON     BIT(1)
> +#define CORE_PWRCTL_IO_LOW     BIT(2)
> +#define CORE_PWRCTL_IO_HIGH    BIT(3)
> +
> +#define CORE_PWRCTL_BUS_SUCCESS        BIT(0)
> +#define CORE_PWRCTL_BUS_FAIL   BIT(1)
> +#define CORE_PWRCTL_IO_SUCCESS BIT(2)
> +#define CORE_PWRCTL_IO_FAIL    BIT(3)
> +
> +#define INT_MASK               0xf
> +
> +#define QCOM_SDHCI_VOLTAGE_LOW 1800000
> +#define QCOM_SDHCI_VOLTAGE_HIGH        2950000
> +
> +
> +struct sdhci_msm_pltfm_data {
> +       u32 caps;                               /* Supported UHS-I Modes */
> +       u32 caps2;                              /* More capabilities */

Why do you need these caps, there are already a part of the mmc host.

> +       struct regulator *vdd;                  /* VDD/VCC regulator */
> +       struct regulator *vdd_io;               /* VDD IO regulator */

Why do you need to duplicate the regulators for sdhci_msm? sdhci core
is already taking care of regulators, I suppose you should adopt to
that!?

> +};
> +
> +struct sdhci_msm_host {
> +       struct platform_device *pdev;
> +       void __iomem *core_mem; /* MSM SDCC mapped address */
> +       int pwr_irq;            /* power irq */
> +       struct clk *clk;        /* main SD/MMC bus clock */
> +       struct clk *pclk;       /* SDHC peripheral bus clock */
> +       struct clk *bus_clk;    /* SDHC bus voter clock */
> +       struct sdhci_msm_pltfm_data pdata;
> +       struct mmc_host *mmc;
> +       struct sdhci_pltfm_data sdhci_msm_pdata;
> +};
> +
> +/* MSM platform specific tuning */
> +int sdhci_msm_execute_tuning(struct sdhci_host *host, u32 opcode)
> +{
> +       /*
> +        * Tuning is required for SDR104, HS200 and HS400 cards and if the clock
> +        * frequency greater than 100MHz in those modes. The standard tuning
> +        * procedure should not be executed, but a custom implementation will be
> +        * added here instead.
> +        */
> +       return 0;
> +}
> +
> +static int sdhci_msm_vreg_enable(struct device *dev, struct regulator *vreg)
> +{
> +       int ret = 0;
> +
> +       if (!regulator_is_enabled(vreg)) {
> +               /* Set voltage level */
> +               ret = regulator_set_voltage(vreg, QCOM_SDHCI_VOLTAGE_HIGH,
> +                                           QCOM_SDHCI_VOLTAGE_HIGH);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       ret = regulator_enable(vreg);
> +       if (ret)
> +               dev_err(dev, "Failed to enable regulator (%d)\n", ret);
> +
> +       return ret;
> +}
> +
> +static int sdhci_msm_vreg_disable(struct device *dev, struct regulator *vreg)
> +{
> +       int ret = 0;
> +
> +       if (!regulator_is_enabled(vreg))
> +               return ret;
> +
> +       /* Set min. voltage to 0 */
> +       ret = regulator_set_voltage(vreg, 0, QCOM_SDHCI_VOLTAGE_HIGH);
> +       if (ret)
> +               return ret;
> +
> +       ret = regulator_disable(vreg);
> +       if (ret)
> +               dev_err(dev, "Failed to disable regulator (%d)\n", ret);
> +
> +       return ret;
> +}
> +
> +static int sdhci_msm_setup_vreg(struct sdhci_msm_host *msm_host, bool enable)
> +{
> +       int ret;
> +
> +       if (enable) {
> +               ret = sdhci_msm_vreg_enable(&msm_host->pdev->dev,
> +                               msm_host->pdata.vdd);
> +               ret |= sdhci_msm_vreg_enable(&msm_host->pdev->dev,
> +                               msm_host->pdata.vdd_io);
> +       } else {
> +               ret = sdhci_msm_vreg_disable(&msm_host->pdev->dev,
> +                               msm_host->pdata.vdd);
> +               ret |= sdhci_msm_vreg_disable(&msm_host->pdev->dev,
> +                               msm_host->pdata.vdd_io);
> +       }
> +
> +       return ret;
> +}
> +
> +static int sdhci_msm_vreg_init(struct device *dev,
> +                              struct sdhci_msm_pltfm_data *pdata)
> +{
> +       pdata->vdd = devm_regulator_get(dev, "vdd-supply");
> +       if (IS_ERR(pdata->vdd))
> +               return PTR_ERR(pdata->vdd);
> +
> +       pdata->vdd_io = devm_regulator_get(dev, "vdd-io-supply");
> +       if (IS_ERR(pdata->vdd_io))
> +               return PTR_ERR(pdata->vdd_io);
> +
> +       return 0;
> +}
> +

The hole regulator handling seems like it's being duplicated from the
sdhci core. If the regulator handling from the sdhci core don't suite
your need I guess you should extend that instead - to prevent the
duplication of code and structs.

Moreover I think it's time for sdhci core to move on to use the
mmc_regulator_get_supply() API. Additionally it should be able to use
mmc_regulator_set_ocr() API to change voltage. I guess that's not
related to this patch though, but just wanted to provide you my view
on it.


> +static irqreturn_t sdhci_msm_pwr_irq(int irq, void *data)
> +{
> +       struct sdhci_host *host = (struct sdhci_host *)data;
> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +       struct sdhci_msm_host *msm_host = pltfm_host->priv;
> +       u8 irq_status;
> +       u8 irq_ack = 0;
> +       int ret = 0;
> +
> +       irq_status = readb_relaxed(msm_host->core_mem + CORE_PWRCTL_STATUS);
> +       dev_dbg(mmc_dev(msm_host->mmc), "%s: Received IRQ(%d), status=0x%x\n",
> +               mmc_hostname(msm_host->mmc), irq, irq_status);
> +
> +       /* Clear the interrupt */
> +       writeb_relaxed(irq_status, (msm_host->core_mem + CORE_PWRCTL_CLEAR));
> +
> +       /* Ensure that the write has reached the device */
> +       mb();
> +
> +       if (irq_status & (CORE_PWRCTL_BUS_ON | CORE_PWRCTL_BUS_OFF)) {
> +               /* Handle BUS ON/OFF */
> +               bool bus_on = (irq_status & CORE_PWRCTL_BUS_ON) ? 1 : 0;
> +
> +               ret = sdhci_msm_setup_vreg(msm_host, bus_on);
> +       } else if (irq_status & (CORE_PWRCTL_IO_LOW | CORE_PWRCTL_IO_HIGH)) {
> +               /* Handle IO LOW/HIGH */
> +               int io_high = (irq_status & CORE_PWRCTL_IO_HIGH) ? 1 : 0;
> +
> +               if (io_high) {
> +                       ret = regulator_set_voltage(msm_host->pdata.vdd_io,
> +                                       QCOM_SDHCI_VOLTAGE_HIGH,
> +                                       QCOM_SDHCI_VOLTAGE_HIGH);
> +               } else {
> +                       ret = regulator_set_voltage(msm_host->pdata.vdd_io,
> +                                       QCOM_SDHCI_VOLTAGE_LOW,
> +                                       QCOM_SDHCI_VOLTAGE_LOW);
> +               }
> +       }
> +
> +       if (ret)
> +               irq_ack = CORE_PWRCTL_BUS_FAIL;
> +       else
> +               irq_ack = CORE_PWRCTL_BUS_SUCCESS;
> +
> +       /* ACK status to the core */
> +       writeb_relaxed(irq_ack, (msm_host->core_mem + CORE_PWRCTL_CTL));
> +
> +       /* Commit the write to the device */
> +       mb();
> +
> +       dev_dbg(mmc_dev(msm_host->mmc), "%s: Handled IRQ(%d), ret=%d, ack=0x%x\n",
> +                mmc_hostname(msm_host->mmc), irq, ret, irq_ack);
> +       return IRQ_HANDLED;
> +}
> +
> +static const struct of_device_id sdhci_msm_dt_match[] = {
> +       { .compatible = "qcom,sdhci-msm-v4" },
> +       {},
> +};
> +
> +MODULE_DEVICE_TABLE(of, sdhci_msm_dt_match);
> +
> +static struct sdhci_ops sdhci_msm_ops = {
> +       .platform_execute_tuning = sdhci_msm_execute_tuning,
> +};
> +
> +static int sdhci_msm_probe(struct platform_device *pdev)
> +{
> +       struct sdhci_host *host;
> +       struct sdhci_pltfm_host *pltfm_host;
> +       struct sdhci_msm_host *msm_host;
> +       struct resource *core_memres;
> +       int ret, dead;
> +       u16 host_version;
> +
> +       if (!pdev->dev.of_node) {
> +               dev_err(&pdev->dev, "No device tree data\n");
> +               return -ENOENT;
> +       }
> +
> +       msm_host = devm_kzalloc(&pdev->dev, sizeof(*msm_host), GFP_KERNEL);
> +       if (!msm_host)
> +               return -ENOMEM;
> +
> +       msm_host->sdhci_msm_pdata.ops = &sdhci_msm_ops;
> +       host = sdhci_pltfm_init(pdev, &msm_host->sdhci_msm_pdata, 0);
> +       if (IS_ERR(host))
> +               return PTR_ERR(host);
> +
> +       pltfm_host = sdhci_priv(host);
> +       pltfm_host->priv = msm_host;
> +       msm_host->mmc = host->mmc;
> +       msm_host->pdev = pdev;
> +
> +       ret = mmc_of_parse(host->mmc);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Failed parsing mmc device tree\n");
> +               goto pltfm_free;
> +       }
> +
> +       sdhci_get_of_property(pdev);
> +
> +       /* Setup SDCC bus voter clock. */
> +       msm_host->bus_clk = devm_clk_get(&pdev->dev, "bus");
> +       if (!IS_ERR(msm_host->bus_clk)) {
> +               /* Vote for max. clk rate for max. performance */
> +               ret = clk_set_rate(msm_host->bus_clk, INT_MAX);
> +               if (ret)
> +                       goto pltfm_free;
> +               ret = clk_prepare_enable(msm_host->bus_clk);
> +               if (ret)
> +                       goto pltfm_free;
> +       }
> +
> +       /* Setup main peripheral bus clock */
> +       msm_host->pclk = devm_clk_get(&pdev->dev, "iface");
> +       if (IS_ERR(msm_host->pclk)) {
> +               ret = PTR_ERR(msm_host->pclk);
> +               dev_err(&pdev->dev, "Perpheral clk setup failed (%d)\n", ret);
> +               goto bus_clk_disable;
> +       }
> +
> +       ret = clk_prepare_enable(msm_host->pclk);
> +       if (ret)
> +               goto bus_clk_disable;
> +
> +       /* Setup SDC MMC clock */
> +       msm_host->clk = devm_clk_get(&pdev->dev, "core");
> +       if (IS_ERR(msm_host->clk)) {
> +               ret = PTR_ERR(msm_host->clk);
> +               dev_err(&pdev->dev, "SDC MMC clk setup failed (%d)\n", ret);
> +               goto pclk_disable;
> +       }
> +
> +       ret = clk_prepare_enable(msm_host->clk);
> +       if (ret)
> +               goto pclk_disable;
> +
> +       /* Setup regulators */
> +       ret = sdhci_msm_vreg_init(&pdev->dev, &msm_host->pdata);
> +       if (ret) {
> +               if (ret != -EPROBE_DEFER)
> +                       dev_err(&pdev->dev,
> +                               "Regulator setup failed (%d)\n", ret);
> +               goto clk_disable;
> +       }
> +
> +       core_memres = platform_get_resource_byname(pdev,
> +                                                  IORESOURCE_MEM, "core_mem");
> +       msm_host->core_mem = devm_ioremap_resource(&pdev->dev, core_memres);
> +
> +       if (IS_ERR(msm_host->core_mem)) {
> +               dev_err(&pdev->dev, "Failed to remap registers\n");
> +               ret = PTR_ERR(msm_host->core_mem);
> +               goto clk_disable;
> +       }
> +
> +       /* Reset the core and Enable SDHC mode */
> +       writel_relaxed(readl_relaxed(msm_host->core_mem + CORE_POWER) |
> +                      CORE_SW_RST, msm_host->core_mem + CORE_POWER);
> +
> +       /* SW reset can take upto 10HCLK + 15MCLK cycles. (min 40us) */
> +       usleep_range(1000, 5000);
> +       if (readl(msm_host->core_mem + CORE_POWER) & CORE_SW_RST) {
> +               dev_err(&pdev->dev, "Stuck in reset\n");
> +               ret = -ETIMEDOUT;
> +               goto clk_disable;
> +       }
> +
> +       /* Set HC_MODE_EN bit in HC_MODE register */
> +       writel_relaxed(HC_MODE_EN, (msm_host->core_mem + CORE_HC_MODE));
> +
> +       /*
> +        * Following are the deviations from SDHC spec v3.0 -
> +        * 1. Card detection is handled using separate GPIO.
> +        * 2. Bus power control is handled by interacting with PMIC.
> +        */
> +       host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
> +       host->quirks |= SDHCI_QUIRK_SINGLE_POWER_WRITE;
> +
> +       host_version = readw_relaxed((host->ioaddr + SDHCI_HOST_VERSION));
> +       dev_dbg(&pdev->dev, "Host Version: 0x%x Vendor Version 0x%x\n",
> +               host_version, ((host_version & SDHCI_VENDOR_VER_MASK) >>
> +                              SDHCI_VENDOR_VER_SHIFT));
> +
> +       /* Setup PWRCTL irq */
> +       msm_host->pwr_irq = platform_get_irq_byname(pdev, "pwr_irq");
> +       if (msm_host->pwr_irq < 0) {
> +               dev_err(&pdev->dev, "Failed to get pwr_irq by name (%d)\n",
> +                       msm_host->pwr_irq);
> +               goto clk_disable;
> +       }
> +       ret = devm_request_threaded_irq(&pdev->dev, msm_host->pwr_irq, NULL,
> +                                       sdhci_msm_pwr_irq, IRQF_ONESHOT,
> +                                       dev_name(&pdev->dev), host);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Request threaded irq(%d) failed (%d)\n",
> +                       msm_host->pwr_irq, ret);
> +               goto clk_disable;
> +       }
> +
> +       /* Enable power irq */
> +       writel_relaxed(INT_MASK, (msm_host->core_mem + CORE_PWRCTL_MASK));
> +
> +       msm_host->mmc->caps |= msm_host->pdata.caps;
> +       msm_host->mmc->caps2 |= msm_host->pdata.caps2;
> +
> +       ret = sdhci_add_host(host);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Add host failed (%d)\n", ret);
> +               goto vreg_disable;
> +       }
> +
> +       ret = clk_set_rate(msm_host->clk, host->max_clk);

Don't you need to set the rate before adding the host?

> +       if (ret) {
> +               dev_err(&pdev->dev, "MClk rate set failed (%d)\n", ret);
> +               goto remove_host;
> +       }
> +
> +       return 0;
> +
> +remove_host:
> +       dead = (readl_relaxed(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
> +       sdhci_remove_host(host, dead);
> +vreg_disable:
> +       sdhci_msm_vreg_disable(&pdev->dev, msm_host->pdata.vdd);
> +       sdhci_msm_vreg_disable(&pdev->dev, msm_host->pdata.vdd_io);
> +clk_disable:
> +       clk_disable_unprepare(msm_host->clk);
> +pclk_disable:
> +       clk_disable_unprepare(msm_host->pclk);
> +bus_clk_disable:
> +       if (!IS_ERR(msm_host->bus_clk))
> +               clk_disable_unprepare(msm_host->bus_clk);
> +pltfm_free:
> +       sdhci_pltfm_free(pdev);
> +       return ret;
> +}
> +
> +static int sdhci_msm_remove(struct platform_device *pdev)
> +{
> +       struct sdhci_host *host = platform_get_drvdata(pdev);
> +       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
> +       struct sdhci_msm_host *msm_host = pltfm_host->priv;
> +       int dead;
> +
> +       /* Disable power irq */
> +       writel_relaxed(~INT_MASK, (msm_host->core_mem + CORE_PWRCTL_MASK));
> +
> +       dead = (readl_relaxed(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
> +       sdhci_remove_host(host, dead);
> +       sdhci_pltfm_free(pdev);
> +       sdhci_msm_vreg_disable(&pdev->dev, msm_host->pdata.vdd);
> +       sdhci_msm_vreg_disable(&pdev->dev, msm_host->pdata.vdd_io);
> +       clk_disable_unprepare(msm_host->clk);
> +       clk_disable_unprepare(msm_host->pclk);
> +       if (!IS_ERR(msm_host->bus_clk))
> +               clk_disable_unprepare(msm_host->bus_clk);
> +       return 0;
> +}
> +
> +static struct platform_driver sdhci_msm_driver = {
> +       .probe = sdhci_msm_probe,
> +       .remove = sdhci_msm_remove,
> +       .driver = {
> +                  .name = "sdhci_msm",
> +                  .owner = THIS_MODULE,
> +                  .of_match_table = sdhci_msm_dt_match,
> +       },
> +};
> +
> +module_platform_driver(sdhci_msm_driver);
> +
> +MODULE_DESCRIPTION("Qualcomm Secure Digital Host Controller Interface driver");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.9.5
>

Kind regards
Ulf Hansson
