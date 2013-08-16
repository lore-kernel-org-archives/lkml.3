Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3HPIMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:12:48 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:46224 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab3HPIKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:10:51 -0400
Message-ID: <520DDEBA.4050107@mm-sol.com>
Date: Fri, 16 Aug 2013 11:11:38 +0300
From: Georgi Djakov <gdjakov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: linux-mmc@vger.kernel.org, cjb@laptop.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, bjorn@kryo.se,
        davidb@codeaurora.org, Asutosh Das <asutoshd@codeaurora.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Sahitya Tummala <stummala@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH RFC v2] mmc: sdhci-msm: Add support for MSM chipsets
References: <1375201355-26906-1-git-send-email-gdjakov@mm-sol.com>  <1376402790-16864-1-git-send-email-gdjakov@mm-sol.com> <1376551341.7311.43.camel@iivanov-dev.int.mm-sol.com>
In-Reply-To: <1376551341.7311.43.camel@iivanov-dev.int.mm-sol.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

On 08/15/2013 10:22 AM, Ivan T. Ivanov wrote:
>
> Hi Georgi,
>
> I have several comments below.
>
<snip>
>
> Shouldn't we add required clocks here? It looks that some of them
> are optional and others mandatory.
>

Yes, there are various clocks for MMC, SD/SDIO and at least 400mhz must 
be provided for the initialization process.
I'll create a device-tree properties for clocks. Thanks!

>> +#include <linux/types.h>
>> +#include <linux/input.h>
>
> It seems that this is not required.

Correct, many of them are not required. Thanks!

>> +#define CORE_PWRCTL_STATUS	0xDC
>
> Please use lower chars for hex numbers

Ok.

>> +/* This structure keeps information per regulator */
>> +struct sdhci_msm_reg_data {
>> +	/* voltage regulator handle */
>> +	struct regulator *reg;
>> +	/* regulator name */
>> +	const char *name;
>> +	/* voltage level to be set */
>> +	u32 low_vol_level;
>> +	u32 high_vol_level;
>> +	/* Load values for low power and high power mode */
>> +	u32 lpm_uA;
>> +	u32 hpm_uA;
>> +
>> +	/* is this regulator enabled? */
>> +	bool is_enabled;
>> +	/* is this regulator needs to be always on? */
>> +	bool is_always_on;
>> +	/* is low power mode setting required for this regulator? */
>> +	bool lpm_sup;
>> +};
>> +
>> +/*
>> + * This structure keeps information for all the
>> + * regulators required for a SDCC slot.
>> + */
>> +struct sdhci_msm_slot_reg_data {
>> +	/* keeps VDD/VCC regulator info */
>> +	struct sdhci_msm_reg_data *vdd_data;
>> +	/* keeps VDD IO regulator info */
>> +	struct sdhci_msm_reg_data *vdd_io_data;
>
> Why not allocate memory at once? I looks like both of
> them are required.
>

Agree. I'll merge all of them into one structure. Thanks!

>> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +	if (!pdata) {
>> +		dev_err(dev, "failed to allocate memory for platform data\n");
>> +		goto out;
>
> Just return immediately? Here and bellow.

Ok.

>> +	/* Get the regulator handle */
>> +	vreg->reg = devm_regulator_get(dev, vreg->name);
>> +	if (IS_ERR(vreg->reg)) {
>> +		ret = PTR_ERR(vreg->reg);
>> +		pr_err("%s: devm_regulator_get(%s) failed. ret=%d\n",
>> +		       __func__, vreg->name, ret);
>
> __func__ did not bring any additional info. Please remove it.

Ok.

>
>> +		goto out;
>> +	}
>> +
>> +	/* sanity check */
>> +	if (!vreg->high_vol_level || !vreg->hpm_uA) {
>> +		pr_err("%s: %s invalid constraints specified\n",
>> +		       __func__, vreg->name);
>
> same thing ...
>
>> +		ret = -EINVAL;
>> +	}
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +static void sdhci_msm_vreg_deinit_reg(struct sdhci_msm_reg_data *vreg)
>> +{
>> +	if (vreg->reg)
>
> If regulator reference has to be checked it should be IS_ERR(vreg->reg).
>
>> +		devm_regulator_put(vreg->reg);
>
> There is no need for this with device managed resources.
>

Ok.

>> +}
>> +
>> +static int sdhci_msm_vreg_set_optimum_mode(struct sdhci_msm_reg_data
>> +					   *vreg, int uA_load)
>> +{
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * regulators that do not support regulator_set_voltage also
>> +	 * do not support regulator_set_optimum_mode
>> +	 */
>> +	ret = regulator_set_optimum_mode(vreg->reg, uA_load);
>> +	if (ret < 0)
>> +		pr_err
>> +		    ("%s: regulator_set_optimum_mode(%s,uA_load=%d) fail(%d)\n",
>> +		     __func__, vreg->name, uA_load, ret);
>> +	else
>> +		/*
>> +		 * regulator_set_optimum_mode() can return non zero
>> +		 * value even for success case.
>> +		 */
>> +		ret = 0;
>> +	return ret;
>
> Is it really necessary to have function wrapper?
>

Will clean it.

>> +/* This init function should be called only once for each SDHC slot */
>> +static int sdhci_msm_vreg_init(struct device *dev,
>> +			       struct sdhci_msm_pltfm_data *pdata, bool is_init)
>> +{
>> +	int ret = 0;
>> +	struct sdhci_msm_slot_reg_data *curr_slot;
>> +	struct sdhci_msm_reg_data *curr_vdd_reg, *curr_vdd_io_reg;
>> +
>> +	curr_slot = pdata->vreg_data;
>> +	if (!curr_slot)
>
> This could not happen.
>
>> +		goto out;
>> +
>> +	curr_vdd_reg = curr_slot->vdd_data;
>> +	curr_vdd_io_reg = curr_slot->vdd_io_data;
>> +
>> +	if (!is_init)
>> +		/* Deregister all regulators from regulator framework */
>> +		goto vdd_io_reg_deinit;
>> +
>> +	/*
>> +	 * Get the regulator handle from voltage regulator framework
>> +	 * and then try to set the voltage level for the regulator
>> +	 */
>> +	if (curr_vdd_reg) {
>
> Why you check for this? It is alway true.
>
>> +		ret = sdhci_msm_vreg_init_reg(dev, curr_vdd_reg);
>> +		if (ret)
>> +			goto out;
>> +	}
>> +	if (curr_vdd_io_reg) {
>> +		ret = sdhci_msm_vreg_init_reg(dev, curr_vdd_io_reg);
>> +		if (ret)
>> +			goto vdd_reg_deinit;
>> +	}
>> +	ret = sdhci_msm_vreg_reset(pdata);
>> +	if (ret)
>> +		dev_err(dev, "vreg reset failed (%d)\n", ret);
>> +	goto out;
>> +
>> +vdd_io_reg_deinit:
>> +	if (curr_vdd_io_reg)
>> +		sdhci_msm_vreg_deinit_reg(curr_vdd_io_reg);
>> +vdd_reg_deinit:
>> +	if (curr_vdd_reg)
>> +		sdhci_msm_vreg_deinit_reg(curr_vdd_reg);
>> +out:
>> +	return ret;
>> +}
>> +
>> +static int sdhci_msm_set_vdd_io_vol(struct sdhci_msm_pltfm_data *pdata,
>> +				    enum vdd_io_level level,
>> +				    unsigned int voltage_level)
>> +{
>> +	int ret = 0;
>> +	int set_level;
>> +
>> +	if (pdata->vreg_data) {
>
> When this will happen?
>
>> +		struct sdhci_msm_reg_data *vdd_io_reg =
>> +		    pdata->vreg_data->vdd_io_data;
>> +
>> +		if (vdd_io_reg && vdd_io_reg->is_enabled) {
>> +			switch (level) {
>> +			case VDD_IO_LOW:
>> +				set_level = vdd_io_reg->low_vol_level;
>> +				break;
>> +			case VDD_IO_HIGH:
>> +				set_level = vdd_io_reg->high_vol_level;
>> +				break;
>> +			case VDD_IO_SET_LEVEL:
>> +				set_level = voltage_level;
>> +				break;
>> +			default:
>> +				pr_err("%s: invalid argument level = %d",
>> +				       __func__, level);
>> +				ret = -EINVAL;
>> +				goto out;
>> +			}
>> +			ret = sdhci_msm_vreg_set_voltage(vdd_io_reg,
>> +							 set_level, set_level);
>> +		}
>> +	}
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +static irqreturn_t sdhci_msm_pwr_irq(int irq, void *data)
>> +{
>> +	struct sdhci_msm_host *msm_host = (struct sdhci_msm_host *)data;
>> +	u8 irq_status = 0;
>> +	u8 irq_ack = 0;
>> +	int ret = 0;
>> +
>> +	irq_status = readb_relaxed(msm_host->core_mem + CORE_PWRCTL_STATUS);
>> +	pr_debug("%s: Received IRQ(%d), status=0x%x\n",
>> +		 mmc_hostname(msm_host->mmc), irq, irq_status);
>> +
>> +	/* Clear the interrupt */
>> +	writeb_relaxed(irq_status, (msm_host->core_mem + CORE_PWRCTL_CLEAR));
>> +	/*
>> +	 * SDHC has core_mem and hc_mem device memory and these memory
>> +	 * addresses do not fall within 1KB region. Hence, any update to
>> +	 * core_mem address space would require an mb() to ensure this gets
>> +	 * completed before its next update to registers within hc_mem.
>> +	 */
>> +	mb();
>> +
>> +	/* Handle BUS ON/OFF */
>> +	if (irq_status & (CORE_PWRCTL_BUS_ON | CORE_PWRCTL_BUS_OFF)) {
>> +		bool flag = (irq_status & CORE_PWRCTL_BUS_ON) ? 1 : 0;
>> +		ret = sdhci_msm_setup_vreg(msm_host->pdata, flag, false);
>> +		if (ret)
>> +			irq_ack |= CORE_PWRCTL_BUS_FAIL;
>> +		else
>> +			irq_ack |= CORE_PWRCTL_BUS_SUCCESS;
>> +		goto out;
>
> goto out?
>
>> +	}
>> +	/* Handle IO LOW/HIGH */
>> +	if (irq_status & (CORE_PWRCTL_IO_LOW | CORE_PWRCTL_IO_HIGH)) {
>> +		/* Switch voltage */
>> +		int io_status = (irq_status & CORE_PWRCTL_IO_LOW) ?
>> +		    VDD_IO_LOW : VDD_IO_HIGH;
>> +		ret = sdhci_msm_set_vdd_io_vol(msm_host->pdata, io_status, 0);
>> +		if (ret)
>> +			irq_ack |= CORE_PWRCTL_IO_FAIL;
>> +		else
>> +			irq_ack |= CORE_PWRCTL_IO_SUCCESS;
>> +		goto out;
>
> Ditto.
>
>> +	}
>> +
>> +out:
>
>> +	/* ACK status to the core */
>> +	writeb_relaxed(irq_ack, (msm_host->core_mem + CORE_PWRCTL_CTL));
>> +	/*
>> +	 * SDHC has core_mem and hc_mem device memory and these memory
>> +	 * addresses do not fall within 1KB region. Hence, any update to
>> +	 * core_mem address space would require an mb() to ensure this gets
>> +	 * completed before its next update to registers within hc_mem.
>> +	 */
>> +	mb();
>> +
>> +	pr_debug("%s: Handled IRQ(%d), ret=%d, ack=0x%x\n",
>> +		 mmc_hostname(msm_host->mmc), irq, ret, irq_ack);
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +/* This function returns the max. current supported by VDD rail in mA */
>> +static unsigned int sdhci_msm_get_vreg_vdd_max_current(struct sdhci_msm_host
>> +						       *host)
>> +{
>> +	struct sdhci_msm_slot_reg_data *curr_slot = host->pdata->vreg_data;
>> +	if (!curr_slot)
>> +		return 0;
>> +	if (curr_slot->vdd_data)
>> +		return curr_slot->vdd_data->hpm_uA / 1000;
>> +	else
>
> Is this possible?
>> +		return 0;
>> +}
>> +
>> +static const struct of_device_id sdhci_msm_dt_match[] = {
>> +	{.compatible = "qcom,sdhci-msm"},
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, sdhci_msm_dt_match);
>> +
>> +static int sdhci_msm_probe(struct platform_device *pdev)
>> +{
>> +	const struct of_device_id *match;
>> +	struct sdhci_host *host;
>> +	struct sdhci_pltfm_host *pltfm_host;
>> +	struct sdhci_msm_host *msm_host;
>> +	struct resource *core_memres = NULL;
>> +	int ret = 0, dead = 0;
>> +	struct pinctrl	*pinctrl;
>> +
>> +	match = of_match_device(of_match_ptr(sdhci_msm_dt_match), &pdev->dev);
>> +	if (!match)
>
> Is this possible?

No, it's not needed. Will remove it.

>
>> +		return -ENXIO;
>> +
>> +	msm_host = devm_kzalloc(&pdev->dev, sizeof(struct sdhci_msm_host),
>> +				GFP_KERNEL);
>> +	if (!msm_host) {
>> +		ret = -ENOMEM;
>
> Just return -ENOMEM?
>

Ok.

>> +	/* Setup Clocks */
>> +
>> +	/* Setup SDCC bus voter clock. */
>> +	msm_host->bus_clk = devm_clk_get(&pdev->dev, "bus_clk");
>> +	if (!IS_ERR_OR_NULL(msm_host->bus_clk)) {
>
> This should be !IS_ERR(). Is this clock optional?

Yes, it's optional.

>
>> +		/* Vote for max. clk rate for max. performance */
>> +		ret = clk_set_rate(msm_host->bus_clk, INT_MAX);
>> +		if (ret)
>> +			goto pltfm_free;
>> +		ret = clk_prepare_enable(msm_host->bus_clk);
>> +		if (ret)
>> +			goto pltfm_free;
>> +	}
>> +
>> +	/* Setup main peripheral bus clock */
>> +	msm_host->pclk = devm_clk_get(&pdev->dev, "iface_clk");
>
> Is this clock optional?

Yes, its optional.

>> +
>> +	host->mmc->max_current_180 =
>> +	    sdhci_msm_get_vreg_vdd_max_current(msm_host);
>> +	host->mmc->max_current_300 =
>> +	    sdhci_msm_get_vreg_vdd_max_current(msm_host);
>> +	host->mmc->max_current_330 =
>> +	    sdhci_msm_get_vreg_vdd_max_current(msm_host);
>
> Is it expected that this function to return different result
> after each call?

Very unlikely. Will review and change it.

>
>> +
>> +	/* Successful initialization */
>> +	goto out;
>> +
>> +remove_host:
>> +	dead = (readl_relaxed(host->ioaddr + SDHCI_INT_STATUS) == 0xffffffff);
>> +	sdhci_remove_host(host, dead);
>> +vreg_deinit:
>> +	sdhci_msm_vreg_init(&pdev->dev, msm_host->pdata, false);
>> +clk_disable:
>> +	if (!IS_ERR(msm_host->clk))
>> +		clk_disable_unprepare(msm_host->clk);
>> +pclk_disable:
>> +	if (!IS_ERR(msm_host->pclk))
>> +		clk_disable_unprepare(msm_host->pclk);
>> +bus_clk_disable:
>> +	if (!IS_ERR_OR_NULL(msm_host->bus_clk))
>> +		clk_disable_unprepare(msm_host->bus_clk);
>> +pltfm_free:
>> +	sdhci_pltfm_free(pdev);
>> +out:
>> +	return ret;
>> +}
>> +
>> +static int sdhci_msm_remove(struct platform_device *pdev)
>> +{
>> +	struct sdhci_host *host = platform_get_drvdata(pdev);
>> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>> +	struct sdhci_msm_host *msm_host = pltfm_host->priv;
>> +	int dead = (readl_relaxed(host->ioaddr + SDHCI_INT_STATUS) ==
>> +		    0xffffffff);
>> +
>> +	pr_debug("%s: %s\n", dev_name(&pdev->dev), __func__);
>> +	sdhci_remove_host(host, dead);
>> +	sdhci_pltfm_free(pdev);
>> +	sdhci_msm_vreg_init(&pdev->dev, msm_host->pdata, false);
>> +	if (!IS_ERR(msm_host->clk))
>
> This is always true.

It should be, otherwise we will fail at probe. I will review the sanity 
checks and clean-up where necessary. Thanks!

>
>> +		clk_disable_unprepare(msm_host->clk);
>> +	if (!IS_ERR(msm_host->pclk))
>> +		clk_disable_unprepare(msm_host->pclk);
>> +	if (!IS_ERR_OR_NULL(msm_host->bus_clk))
>
> !IS_ERR. And this could happen only if clock is optional.

Correct.

Thank you for detailed review and all the comments!

BR,
Georgi

