Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaA3RT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:19:27 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:52802 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbaA3RTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:19:25 -0500
Message-ID: <52EA8A07.6080008@mm-sol.com>
Date: Thu, 30 Jan 2014 19:21:11 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Courtney Cavin <courtney.cavin@sonymobile.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>
Subject: Re: [PATCH v7 2/2] mmc: sdhci-msm: Initial support for MSM chipsets
References: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com> <1383753405-23631-3-git-send-email-gdjakov@mm-sol.com> <20131209170002.GA15223@sonymobile.com>
In-Reply-To: <20131209170002.GA15223@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apologies for the delayed reply.

On 12/09/2013 07:00 PM, Courtney Cavin wrote:
> On Wed, Nov 06, 2013 at 04:56:45PM +0100, Georgi Djakov wrote:
>> This platform driver adds the initial support of Secure
>> Digital Host Controller Interface compliant controller
>> found in Qualcomm MSM chipsets.
>>
>> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> [...]
>> +static int sdhci_msm_probe(struct platform_device *pdev)
>> +{
>> +       struct sdhci_host *host;
>> +       struct sdhci_pltfm_host *pltfm_host;
>> +       struct sdhci_msm_host *msm_host;
>> +       struct resource *core_memres = NULL;
>> +       int ret, dead;
>> +       u16 host_version;
>> +       u32 irq_status, irq_ctl;
>> +
>> +       if (!pdev->dev.of_node) {
>> +               dev_err(&pdev->dev, "No device tree data\n");
>> +               return -ENOENT;
>> +       }
>> +
>> +       msm_host = devm_kzalloc(&pdev->dev, sizeof(*msm_host), GFP_KERNEL);
>> +       if (!msm_host)
>> +               return -ENOMEM;
>> +
>> +       msm_host->sdhci_msm_pdata.ops = &sdhci_msm_ops;
>> +       host = sdhci_pltfm_init(pdev, &msm_host->sdhci_msm_pdata, 0);
>> +       if (IS_ERR(host)) {
>> +               dev_err(mmc_dev(host->mmc), "sdhci_pltfm_init error\n");
>> +               return PTR_ERR(host);
>> +       }
>> +
>> +       pltfm_host = sdhci_priv(host);
>> +       pltfm_host->priv = msm_host;
>> +       msm_host->mmc = host->mmc;
>> +       msm_host->pdev = pdev;
>> +
>> +       ret = mmc_of_parse(host->mmc);
>
> Can we please add a call to sdhci_get_of_property(pdev) somewhere around
> here too?
>

Thanks, I have added it to v8.

>> +       if (ret) {
>> +               dev_err(&pdev->dev, "failed parsing mmc device tree\n");
>> +               goto pltfm_free;
>> +       }
>> +
>> +       ret = sdhci_msm_populate_pdata(&pdev->dev, &msm_host->pdata);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "DT parsing error\n");
>> +               goto pltfm_free;
>> +       }
>> +
>> +       /* Setup SDCC bus voter clock. */
>> +       msm_host->bus_clk = devm_clk_get(&pdev->dev, "bus");
>> +       if (!IS_ERR(msm_host->bus_clk)) {
>> +               /* Vote for max. clk rate for max. performance */
>> +               ret = clk_set_rate(msm_host->bus_clk, INT_MAX);
>> +               if (ret)
>> +                       goto pltfm_free;
>> +               ret = clk_prepare_enable(msm_host->bus_clk);
>> +               if (ret)
>> +                       goto pltfm_free;
>> +       }
>> +
>> +       /* Setup main peripheral bus clock */
>> +       msm_host->pclk = devm_clk_get(&pdev->dev, "iface");
>> +       if (!IS_ERR(msm_host->pclk)) {
>> +               ret = clk_prepare_enable(msm_host->pclk);
>> +               if (ret) {
>> +                       dev_err(&pdev->dev,
>> +                               "Main peripheral clock setup fail (%d)\n",
>> +                               ret);
>> +                       goto bus_clk_disable;
>> +               }
>> +       }
>> +
>> +       /* Setup SDC MMC clock */
>> +       msm_host->clk = devm_clk_get(&pdev->dev, "core");
>> +       if (IS_ERR(msm_host->clk)) {
>> +               ret = PTR_ERR(msm_host->clk);
>> +               dev_err(&pdev->dev, "SDC MMC clock setup fail (%d)\n", ret);
>> +               goto pclk_disable;
>> +       }
>> +
>> +       ret = clk_prepare_enable(msm_host->clk);
>> +       if (ret)
>> +               goto pclk_disable;
>> +
>> +       /* Setup regulators */
>> +       ret = sdhci_msm_vreg_init(&pdev->dev, &msm_host->pdata);
>> +       if (ret) {
>> +               if (ret != -EPROBE_DEFER)
>> +                       dev_err(&pdev->dev, "Regulator setup fail (%d)\n", ret);
>> +               goto clk_disable;
>> +       }
>> +
>> +       core_memres = platform_get_resource_byname(pdev,
>> +                                                  IORESOURCE_MEM, "core_mem");
>> +       msm_host->core_mem = devm_ioremap_resource(&pdev->dev, core_memres);
>> +
>> +       if (IS_ERR(msm_host->core_mem)) {
>> +               dev_err(&pdev->dev, "Failed to remap registers\n");
>> +               ret = PTR_ERR(msm_host->core_mem);
>> +               goto vreg_disable;
>> +       }
>> +
>> +       /* Reset the core and Enable SDHC mode */
>> +       writel_relaxed(readl_relaxed(msm_host->core_mem + CORE_POWER) |
>> +                       CORE_SW_RST, msm_host->core_mem + CORE_POWER);
>> +
>> +       /* SW reset can take upto 10HCLK + 15MCLK cycles. (min 40us) */
>> +       usleep_range(1000, 5000);
>> +       if (readl(msm_host->core_mem + CORE_POWER) & CORE_SW_RST) {
>> +               dev_err(&pdev->dev, "Stuck in reset\n");
>> +               ret = -ETIMEDOUT;
>> +               goto vreg_disable;
>> +       }
>> +
>> +       /* Set HC_MODE_EN bit in HC_MODE register */
>> +       writel_relaxed(HC_MODE_EN, (msm_host->core_mem + CORE_HC_MODE));
>> +
>> +       /*
>> +        * CORE_SW_RST above may trigger power irq if previous status of PWRCTL
>> +        * was either BUS_ON or IO_HIGH_V. So before we enable the power irq
>> +        * interrupt in GIC (by registering the interrupt handler), we need to
>> +        * ensure that any pending power irq interrupt status is acknowledged
>> +        * otherwise power irq interrupt handler would be fired prematurely.
>> +        */
>> +       irq_status = readl_relaxed(msm_host->core_mem + CORE_PWRCTL_STATUS);
>> +       writel_relaxed(irq_status, (msm_host->core_mem + CORE_PWRCTL_CLEAR));
>> +       irq_ctl = readl_relaxed(msm_host->core_mem + CORE_PWRCTL_CTL);
>> +       if (irq_status & (CORE_PWRCTL_BUS_ON | CORE_PWRCTL_BUS_OFF))
>> +               irq_ctl |= CORE_PWRCTL_BUS_SUCCESS;
>> +       if (irq_status & (CORE_PWRCTL_IO_HIGH | CORE_PWRCTL_IO_LOW))
>> +               irq_ctl |= CORE_PWRCTL_IO_SUCCESS;
>> +       writel_relaxed(irq_ctl, (msm_host->core_mem + CORE_PWRCTL_CTL));
>> +       /*
>> +        * Ensure that above writes are propogated before interrupt enablement
>> +        * in GIC.
>> +        */
>> +       mb();
>> +
>> +       /*
>> +        * Following are the deviations from SDHC spec v3.0 -
>> +        * 1. Card detection is handled using separate GPIO.
>> +        * 2. Bus power control is handled by interacting with PMIC.
>> +        */
>> +       host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
>> +       host->quirks |= SDHCI_QUIRK_SINGLE_POWER_WRITE;
>
> I couldn't get v6 running without the 5 quirks you submitted in [1].
> Aren't these also attributes of the controller itself? If so, shouldn't they
> be part of this patch series, and included here?
>

Most of the quirks are for older hardware revisions. On what board/chip 
are you trying to run it? I will post v8 shortly. Could you try with it 
please?

Thanks,
Georgi
