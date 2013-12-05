Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab3LEK1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:27:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40415 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327Ab3LEK1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:27:44 -0500
Date: Thu, 5 Dec 2013 10:27:40 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "subhashj@codeaurora.org" <subhashj@codeaurora.org>
Subject: Re: [PATCH v7 2/2] mmc: sdhci-msm: Initial support for MSM chipsets
Message-ID: <20131205102740.GI29200@e106331-lin.cambridge.arm.com>
References: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
 <1383753405-23631-3-git-send-email-gdjakov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383753405-23631-3-git-send-email-gdjakov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:56:45PM +0000, Georgi Djakov wrote:
> This platform driver adds the initial support of Secure
> Digital Host Controller Interface compliant controller
> found in Qualcomm MSM chipsets.
> 
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
>  drivers/mmc/host/Kconfig     |   13 +
>  drivers/mmc/host/Makefile    |    1 +
>  drivers/mmc/host/sdhci-msm.c |  651 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 665 insertions(+)
>  create mode 100644 drivers/mmc/host/sdhci-msm.c

[...]

> +static int sdhci_msm_dt_parse_vreg_info(struct device *dev,
> +                                       struct sdhci_msm_reg_data *vreg,
> +                                       const char *vreg_name)
> +{
> +       int len;
> +       const __be32 *prop;

Seeing raw property handling in drivers worries me. If there's a reason
to touch the raw DTB we should add helpers to do it rather than leaking
binary format issues into drivers.

> +       char prop_name[MAX_PROP_SIZE];
> +       struct device_node *np = dev->of_node;
> +
> +       snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", vreg_name);
> +       if (!of_parse_phandle(np, prop_name, 0)) {
> +               dev_info(dev, "No vreg data found for %s\n", vreg_name);
> +               return -EINVAL;
> +       }
> +
> +       vreg->name = vreg_name;
> +
> +       snprintf(prop_name, MAX_PROP_SIZE, "qcom,%s-lpm-sup", vreg_name);
> +       if (of_get_property(np, prop_name, NULL))
> +               vreg->lpm_sup = true;
> +
> +       snprintf(prop_name, MAX_PROP_SIZE, "qcom,%s-voltage-level", vreg_name);
> +       prop = of_get_property(np, prop_name, &len);
> +       if (!prop || (len != (2 * sizeof(__be32)))) {
> +               dev_warn(dev, "%s %s property\n",
> +               prop ? "invalid format" : "no", prop_name);
> +       } else {
> +               vreg->low_vol_level = be32_to_cpup(&prop[0]);
> +               vreg->high_vol_level = be32_to_cpup(&prop[1]);
> +       }

You can use of_property_read_u32_array here.

> +
> +       snprintf(prop_name, MAX_PROP_SIZE, "qcom,%s-current-level", vreg_name);
> +       prop = of_get_property(np, prop_name, &len);
> +       if (!prop || (len != (2 * sizeof(__be32)))) {
> +               dev_warn(dev, "%s %s property\n",
> +                        prop ? "invalid format" : "no", prop_name);
> +       } else {
> +               vreg->lpm_uA = be32_to_cpup(&prop[0]);
> +               vreg->hpm_uA = be32_to_cpup(&prop[1]);
> +       }

Likewise.

[...]

> +       /*
> +        * CORE_SW_RST above may trigger power irq if previous status of PWRCTL
> +        * was either BUS_ON or IO_HIGH_V. So before we enable the power irq
> +        * interrupt in GIC (by registering the interrupt handler), we need to
> +        * ensure that any pending power irq interrupt status is acknowledged
> +        * otherwise power irq interrupt handler would be fired prematurely.
> +        */
> +       irq_status = readl_relaxed(msm_host->core_mem + CORE_PWRCTL_STATUS);
> +       writel_relaxed(irq_status, (msm_host->core_mem + CORE_PWRCTL_CLEAR));
> +       irq_ctl = readl_relaxed(msm_host->core_mem + CORE_PWRCTL_CTL);
> +       if (irq_status & (CORE_PWRCTL_BUS_ON | CORE_PWRCTL_BUS_OFF))
> +               irq_ctl |= CORE_PWRCTL_BUS_SUCCESS;
> +       if (irq_status & (CORE_PWRCTL_IO_HIGH | CORE_PWRCTL_IO_LOW))
> +               irq_ctl |= CORE_PWRCTL_IO_SUCCESS;
> +       writel_relaxed(irq_ctl, (msm_host->core_mem + CORE_PWRCTL_CTL));
> +       /*
> +        * Ensure that above writes are propogated before interrupt enablement
> +        * in GIC.
> +        */
> +       mb();

Does this guarantee that the device has finished responding to the write
and deasserted the interrupt line (i.e. does the device only acknowledge
the write once that is true)?

Thanks,
Mark.
