Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaCDDPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:15:18 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:46442 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbaCDDPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:15:14 -0500
MIME-Version: 1.0
In-Reply-To: <1393586675-14628-3-git-send-email-gdjakov@mm-sol.com>
References: <1393586675-14628-1-git-send-email-gdjakov@mm-sol.com>
	<1393586675-14628-3-git-send-email-gdjakov@mm-sol.com>
Date: Mon, 3 Mar 2014 19:15:13 -0800
Message-ID: <CAJAp7Oi=iJ08JU8PfUQOU8cJM8aCrSKhTvzQFqfsLE7x1qaBoQ@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] mmc: sdhci-msm: Initial support for Qualcomm chipsets
From: Bjorn Andersson <bjorn@kryo.se>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        ulf.hansson@linaro.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 3:24 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:
> This platform driver adds the initial support of Secure
> Digital Host Controller Interface compliant controller
> found in Qualcomm chipsets.
>

Hi Georgi,

Sorry for reposting this, I have no idea how I managed to send this as an answer
to patch 1/3...


When testing this I was confused by the warnings from sdhci not finding vmmc
and vqmmc. Is the power irq something Qualcomm specific or is there any other
reason why the sdhci provided regulator functionality can't be used?

Regarding the usage of the regulator api here, I think you should call
regulator_set_voltage() with your default voltage when you acquire the
regulator handles; then your power enable/disable functions will be simpler and
you should be able to clean up the power irq function further.

>
[...]
> +/* This structure keeps information per regulator */
> +struct sdhci_msm_reg_data {
> +       struct regulator *reg;
> +       const char *name;
> +       /* Voltage level values */
> +       u32 low_vol_level;
> +       u32 high_vol_level;

Is there a reason why these should be different? In your example and the other
cases I've seen they are always 2.95V and 1.8V.

>
[...]
> +
> +static int sdhci_msm_vreg_enable(struct device *dev,
> +                                struct sdhci_msm_reg_data *vreg)
> +{
> +       int ret = 0;
> +
> +       if (!regulator_is_enabled(vreg->reg)) {
> +               /* Set voltage level */
> +               ret = regulator_set_voltage(vreg->reg, vreg->high_vol_level,
> +                                           vreg->high_vol_level);
> +               if (ret)
> +                       return ret;

So when you enable voltage in the irq handler or in probe, you will go to "high
voltage", then you might lower this directly again.

> +       }
> +
> +       ret = regulator_enable(vreg->reg);
> +       if (ret) {
> +               dev_err(dev, "Failed to enable regulator %s (%d)\n",
> +                       vreg->name, ret);
> +       }
> +
> +       return ret;
> +}
> +
> +static int sdhci_msm_vreg_disable(struct device *dev,
> +                                 struct sdhci_msm_reg_data *vreg)
> +{
> +       int ret = 0;
> +
> +       if (!regulator_is_enabled(vreg->reg))
> +               return ret;
> +
> +       /* Set min. voltage to 0 */
> +       ret = regulator_set_voltage(vreg->reg, 0, vreg->high_vol_level);
> +       if (ret)
> +               return ret;

Why do you set the voltage to 0 here?

> +
> +       ret = regulator_disable(vreg->reg);
> +       if (ret) {
> +               dev_err(dev, "Failed to disable regulator %s (%d)\n",
> +                       vreg->name, ret);
> +       }
> +
> +       return ret;
> +}
> +
> +static int sdhci_msm_setup_vreg(struct sdhci_msm_host *msm_host, bool enable)
> +{

Instead of having a function with one big if statement of which path you came
from you should have two functions for this.

> +       int ret, i;
> +       struct sdhci_msm_reg_data *vreg_table[2];
> +
> +       vreg_table[0] = &msm_host->pdata.vdd;
> +       vreg_table[1] = &msm_host->pdata.vdd_io;
> +
> +       for (i = 0; i < ARRAY_SIZE(vreg_table); i++) {
> +               if (enable)
> +                       ret = sdhci_msm_vreg_enable(&msm_host->pdev->dev,
> +                                                   vreg_table[i]);
> +               else
> +                       ret = sdhci_msm_vreg_disable(&msm_host->pdev->dev,
> +                                                    vreg_table[i]);
> +               if (ret)
> +                       return ret;
> +       }

This seems to a complicated way of saying:

if (enable) {
sdhci_msm_vreg_enable(vdd)
sdhci_msm_vreg_enable(vdd_io)
} else {
sdhci_msm_vreg_disable(vdd)
sdhci_msm_vreg_disable(vdd_io)
}

Do you plan to add more regulators here?

> +
> +       return 0;
> +}
> +
> +static int sdhci_msm_vreg_init(struct device *dev,
> +                              struct sdhci_msm_pltfm_data *pdata)
> +{
> +       struct sdhci_msm_reg_data *vdd_reg = &pdata->vdd;
> +       struct sdhci_msm_reg_data *vdd_io_reg = &pdata->vdd_io;
> +
> +       vdd_reg->reg = devm_regulator_get(dev, vdd_reg->name);
> +       if (IS_ERR(vdd_reg->reg))
> +               return PTR_ERR(vdd_reg->reg);
> +
> +       vdd_io_reg->reg = devm_regulator_get(dev, vdd_io_reg->name);
> +       if (IS_ERR(vdd_io_reg->reg))
> +               return PTR_ERR(vdd_io_reg->reg);
> +
> +       return 0;
> +}
> +
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
> +       /*
> +        * SDHC has core_mem and hc_mem device memory and these memory
> +        * addresses do not fall within 1KB region. Hence, any update to
> +        * core_mem address space would require an mb() to ensure this gets
> +        * completed before its next update to registers within hc_mem.
> +        */

This is the standard Qualcomm disclaimer regarding memory barriers, but what
part of the system does actually touch hc_mem? As far as I can see this driver
does not go outside that 1K and if the core sdhci core does, it seems to all be
using the non-relaxed write*; so there would be an implicit sync there.

Is it so that we make sure to clear the interrupt here and now?

> +       mb();
> +
> +       /* Handle BUS ON/OFF */
> +       if (irq_status & CORE_PWRCTL_BUS_ON) {
> +               ret = sdhci_msm_setup_vreg(msm_host, true);
> +               if (!ret)
> +                       ret = regulator_set_voltage(msm_host->pdata.vdd_io.reg,
> +                                                   msm_host->pdata.
> +                                                   vdd_io.high_vol_level,
> +                                                   msm_host->pdata.
> +                                                   vdd_io.high_vol_level);

If sdhci_msm_setup_vreg succeeds, you've already set a voltage to vdd_io and
enabled it, why do this one more time?

> +               if (ret)
> +                       irq_ack |= CORE_PWRCTL_BUS_FAIL;
> +               else
> +                       irq_ack |= CORE_PWRCTL_BUS_SUCCESS;
> +       }
> +
> +       if (irq_status & CORE_PWRCTL_BUS_OFF) {
> +               ret = sdhci_msm_setup_vreg(msm_host, false);
> +               if (!ret)
> +                       ret = regulator_set_voltage(msm_host->pdata.vdd_io.reg,
> +                                                   msm_host->pdata.
> +                                                   vdd_io.low_vol_level,
> +                                                   msm_host->pdata.
> +                                                   vdd_io.low_vol_level);

Same here.

> +               if (ret)
> +                       irq_ack |= CORE_PWRCTL_BUS_FAIL;
> +               else
> +                       irq_ack |= CORE_PWRCTL_BUS_SUCCESS;
> +       }
> +
> +       /* Handle IO LOW/HIGH */
> +       if (irq_status & CORE_PWRCTL_IO_LOW) {
> +               ret = regulator_set_voltage(msm_host->pdata.vdd_io.reg,
> +                                           msm_host->pdata.
> +                                           vdd_io.low_vol_level,
> +                                           msm_host->pdata.
> +                                           vdd_io.low_vol_level);

I assume that LOW is xor HIGH here, or you sould set it low then high.

May I suggest that you restructure this to first figuring out what new voltage
(if any) you're aiming for and then call regulator_set_voltage(vdd_io) once and
based on that update the IO_{SUCCESS,FAIL} bits of irq_ack.

> +               if (ret)
> +                       irq_ack |= CORE_PWRCTL_IO_FAIL;
> +               else
> +                       irq_ack |= CORE_PWRCTL_IO_SUCCESS;
> +       }
> +
> +       if (irq_status & CORE_PWRCTL_IO_HIGH) {
> +               ret = regulator_set_voltage(msm_host->pdata.vdd_io.reg,
> +                                           msm_host->pdata.
> +                                           vdd_io.high_vol_level,
> +                                           msm_host->pdata.
> +                                           vdd_io.high_vol_level);
> +               if (ret)
> +                       irq_ack |= CORE_PWRCTL_IO_FAIL;
> +               else
> +                       irq_ack |= CORE_PWRCTL_IO_SUCCESS;
> +       }
> +
> +       /* ACK status to the core */
> +       writeb_relaxed(irq_ack, (msm_host->core_mem + CORE_PWRCTL_CTL));
> +       /*
> +        * SDHC has core_mem and hc_mem device memory and these memory
> +        * addresses do not fall within 1KB region. Hence, any update to
> +        * core_mem address space would require an mb() to ensure this gets
> +        * completed before its next update to registers within hc_mem.
> +        */

Like above, is this mb() to guard for re-ordering or to commit the write?

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
> +       struct resource *core_memres = NULL;

No need to initialize, as first reference is an assignment.

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
> +       ret = sdhci_msm_populate_pdata(&pdev->dev, &msm_host->pdata);
> +       if (ret) {
> +               dev_err(&pdev->dev, "DT parsing error\n");
> +               goto pltfm_free;
> +       }
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
> +       if (!IS_ERR(msm_host->pclk)) {

iface clock is marked required in the binding documentation, so you probably
don't want to fall through here on error.

> +               ret = clk_prepare_enable(msm_host->pclk);
> +               if (ret) {
> +                       dev_err(&pdev->dev,
> +                               "Peripheral clock setup failed (%d)\n", ret);
> +                       goto bus_clk_disable;
> +               }
> +       }
> +
> +       /* Setup SDC MMC clock */
> +       msm_host->clk = devm_clk_get(&pdev->dev, "core");
> +       if (IS_ERR(msm_host->clk)) {
> +               ret = PTR_ERR(msm_host->clk);
> +               dev_err(&pdev->dev, "SDC MMC clock setup failed (%d)\n", ret);
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
> +               goto vreg_disable;
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
> +               goto vreg_disable;

At this point you have only acquired a handle to the vregs, you have not
enabled them. So you don't need to disable them.

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
> +               goto vreg_disable;

At this point you have only acquired a handle to the vregs, you have not
enabled them. So you don't need to disable them.

> +       }
> +       ret = devm_request_threaded_irq(&pdev->dev, msm_host->pwr_irq, NULL,
> +                                       sdhci_msm_pwr_irq, IRQF_ONESHOT,
> +                                       dev_name(&pdev->dev), host);
> +       if (ret) {
> +               dev_err(&pdev->dev, "Request threaded irq(%d) failed (%d)\n",
> +                       msm_host->pwr_irq, ret);
> +               goto vreg_disable;

If this fails you haven't enabled the regulators, so no need to disable them
again.

> +       }
> +
> +       /* Enable pwr irq interrupts */
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
> +       if (ret) {
> +               dev_err(&pdev->dev, "MClk rate set failed (%d)\n", ret);
> +               goto remove_host;
> +       }

Why do you enable the clk further up in this function but wait with setting the
rate until the last thing in this function?

> +
> +       return 0;
> +
> +remove_host:
> +       dead = (readl_relaxed(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
> +       sdhci_remove_host(host, dead);
> +vreg_disable:
> +       if (!IS_ERR(msm_host->pdata.vdd.reg))

If IS_ERR(vdd) or IS_ERR(vdd_io) then you would end up in clk_disable.

> +               sdhci_msm_vreg_disable(&pdev->dev, &msm_host->pdata.vdd);
> +       if (!IS_ERR(msm_host->pdata.vdd_io.reg))
> +               sdhci_msm_vreg_disable(&pdev->dev, &msm_host->pdata.vdd_io);
> +clk_disable:
> +       if (!IS_ERR(msm_host->clk))

If IS_ERR(clk) then you would end up in pclk_disable.

> +               clk_disable_unprepare(msm_host->clk);
> +pclk_disable:
> +       if (!IS_ERR(msm_host->pclk))

Based on the assumption that the check for errors on pclk above is incorrect,
then you would end up in bus_clk_disable if IS_ERR(pclk).

> +               clk_disable_unprepare(msm_host->pclk);
> +bus_clk_disable:
> +       if (!IS_ERR(msm_host->bus_clk))

bus_clk might be IS_ERR() as it's optional, so this makes sense.

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
> +       int dead = (readl_relaxed(host->ioaddr + SDHCI_INT_STATUS) ==
> +                   0xffffffff);
> +

You should probably start with disabling the pwr_irq here, to make sure that it
doesn't kick in after you starting to free resources.

> +       sdhci_remove_host(host, dead);
> +       sdhci_pltfm_free(pdev);
> +       sdhci_msm_vreg_disable(&pdev->dev, &msm_host->pdata.vdd);
> +       sdhci_msm_vreg_disable(&pdev->dev, &msm_host->pdata.vdd_io);
> +       clk_disable_unprepare(msm_host->clk);
> +       clk_disable_unprepare(msm_host->pclk);
> +       if (!IS_ERR(msm_host->bus_clk))
> +               clk_disable_unprepare(msm_host->bus_clk);
> +       return 0;
> +}
> +

Regards,
Bjorn
