Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbaCEUWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:22:36 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:48157 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbaCEUWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:22:34 -0500
Message-ID: <53178789.7020606@mm-sol.com>
Date: Wed, 05 Mar 2014 22:22:33 +0200
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <cjb@laptop.org>,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v10 2/3] mmc: sdhci-msm: Initial support for Qualcomm
 chipsets
References: <1393961226-25618-1-git-send-email-gdjakov@mm-sol.com>	<1393961226-25618-3-git-send-email-gdjakov@mm-sol.com> <CAPDyKFoQ3GW_Xw-x0+-Ohg8ZKFo9wmrFvePdGQqe1MLEaaJx7g@mail.gmail.com>
In-Reply-To: <CAPDyKFoQ3GW_Xw-x0+-Ohg8ZKFo9wmrFvePdGQqe1MLEaaJx7g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 06:41 AM, Ulf Hansson wrote:
> On 4 March 2014 20:27, Georgi Djakov <gdjakov@mm-sol.com> wrote:
[..]
>> +
>> +struct sdhci_msm_pltfm_data {
>> +       u32 caps;                               /* Supported UHS-I Modes */
>> +       u32 caps2;                              /* More capabilities */
>
> Why do you need these caps, there are already a part of the mmc host.
>

Thanks! Will remove.

>> +       struct regulator *vdd;                  /* VDD/VCC regulator */
>> +       struct regulator *vdd_io;               /* VDD IO regulator */
>
> Why do you need to duplicate the regulators for sdhci_msm? sdhci core
> is already taking care of regulators, I suppose you should adopt to
> that!?
>

Ok, I'll try to adopt this.

>> +};
>> +
>> +struct sdhci_msm_host {
>> +       struct platform_device *pdev;
>> +       void __iomem *core_mem; /* MSM SDCC mapped address */
>> +       int pwr_irq;            /* power irq */
>> +       struct clk *clk;        /* main SD/MMC bus clock */
>> +       struct clk *pclk;       /* SDHC peripheral bus clock */
>> +       struct clk *bus_clk;    /* SDHC bus voter clock */
>> +       struct sdhci_msm_pltfm_data pdata;
>> +       struct mmc_host *mmc;
>> +       struct sdhci_pltfm_data sdhci_msm_pdata;
>> +};
>> +
[..]
>> +static int sdhci_msm_vreg_init(struct device *dev,
>> +                              struct sdhci_msm_pltfm_data *pdata)
>> +{
>> +       pdata->vdd = devm_regulator_get(dev, "vdd-supply");
>> +       if (IS_ERR(pdata->vdd))
>> +               return PTR_ERR(pdata->vdd);
>> +
>> +       pdata->vdd_io = devm_regulator_get(dev, "vdd-io-supply");
>> +       if (IS_ERR(pdata->vdd_io))
>> +               return PTR_ERR(pdata->vdd_io);
>> +
>> +       return 0;
>> +}
>> +
>
> The hole regulator handling seems like it's being duplicated from the
> sdhci core. If the regulator handling from the sdhci core don't suite
> your need I guess you should extend that instead - to prevent the
> duplication of code and structs.
>
> Moreover I think it's time for sdhci core to move on to use the
> mmc_regulator_get_supply() API. Additionally it should be able to use
> mmc_regulator_set_ocr() API to change voltage. I guess that's not
> related to this patch though, but just wanted to provide you my view
> on it.

Ok, I see. Thanks for the hints!

[..]
>> +       ret = sdhci_add_host(host);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "Add host failed (%d)\n", ret);
>> +               goto vreg_disable;
>> +       }
>> +
>> +       ret = clk_set_rate(msm_host->clk, host->max_clk);
>
> Don't you need to set the rate before adding the host?
>

I will just make use of the sdhci core for clock setup too. Thanks for 
reviewing!

BR,
Georgi
