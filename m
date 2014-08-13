Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaHMIFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:05:17 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15943 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbaHMIFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:05:13 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 13 Aug 2014 00:56:00 -0700
Message-ID: <53EB1C35.1080104@nvidia.com>
Date: Wed, 13 Aug 2014 11:05:09 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: tegra: Add thermal reset (thermtrip) support
 to PMC
References: <1407226380-747-1-git-send-email-mperttunen@nvidia.com> <1407226380-747-4-git-send-email-mperttunen@nvidia.com> <20140813075353.GA7735@ulmo>
In-Reply-To: <20140813075353.GA7735@ulmo>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/14 10:53, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Tue, Aug 05, 2014 at 11:13:00AM +0300, Mikko Perttunen wrote:
>> This adds a device tree controlled option to enable PMC-based
>> thermal reset in overheating situations. Thermtrip is supported on
>> Tegra114 and Tegra124. The thermal reset only works when the thermal
>
> The binding updates in patch 1/3 say that Tegra30 supports thermtrip as
> well.

Oops, forgot to update the commit message when adding Tegra30. 
Originally I wasn't sure if it was supported.

>
>> +void tegra_pmc_init_thermal_reset(struct device_node *np)
>
> It would be good for this to take a struct device * so that dev_*() can
> be used instead of pr_*().

Good point.

>
>> +{
>> +	u32 pmu_i2c_addr, i2c_ctrl_id, reg_addr, reg_data, pinmux;
>> +	bool pmu_16bit_ops;
>> +	u32 val, checksum;
>
> Nit: All other register accesses use "value" instead of "val" as the
> name for this variable.

Will fix.

>
>> +	const struct of_device_id *match = of_match_node(tegra_pmc_match, np);
>> +	const struct tegra_pmc_soc *data = match->data;
>> +
>> +	if (!data->has_thermal_reset)
>> +		return;
>> +
>> +	pmu_16bit_ops =
>> +		of_property_read_bool(np, "nvidia,thermtrip-pmu-16bit-ops");
>
> The formatting here (and below) is weird. I think this could be made
> more readable by shortening both property name and/or variable name:
>
> 	pmu_16bit = of_property_read_bool(np, "nvidia,thermtrip-pmu-16bit");
>
> And similarily for below.

Yeah, it's suboptimal. The problem will probably go away once I add the
thermtrip subnode.

>
>> +	if (of_property_read_u32(
>> +		np, "nvidia,thermtrip-pmu-i2c-addr", &pmu_i2c_addr))
>> +		goto disabled;
>> +	if (of_property_read_u32(
>> +		np, "nvidia,thermtrip-i2c-controller", &i2c_ctrl_id))
>> +		goto disabled;
>> +	if (of_property_read_u32(
>> +		np, "nvidia,thermtrip-reg-addr", &reg_addr))
>> +		goto disabled;
>> +	if (of_property_read_u32(
>> +		np, "nvidia,thermtrip-reg-data", &reg_data))
>> +		goto disabled;
>> +	if (of_property_read_u32(
>> +		np, "nvidia,thermtrip-pinmux", &pinmux))
>> +		pinmux = 0;
>> +
>> +	val = tegra_pmc_readl(PMC_SENSOR_CTRL);
>> +	val |= PMC_SENSOR_CTRL_SCRATCH_WRITE | PMC_SENSOR_CTRL_ENABLE_RST;
>> +	tegra_pmc_writel(val, PMC_SENSOR_CTRL);
>
> It's not immediately clear to me what this does (therefore it would be
> good to annotate it with a comment), but if this enables thermal
> tripping, shouldn't this be done *after* the registers below have been
> set up?

I'll move this.

>
>> +
>> +	val = (reg_data << PMC_SCRATCH54_DATA_SHIFT) |
>> +	      (reg_addr << PMC_SCRATCH54_ADDR_SHIFT);
>> +	tegra_pmc_writel(val, PMC_SCRATCH54);
>> +
>> +	val = 0;
>> +	val |= PMC_SCRATCH55_RESET_TEGRA;
>> +	val |= i2c_ctrl_id << PMC_SCRATCH55_CNTRL_ID_SHIFT;
>> +	val |= pinmux << PMC_SCRATCH55_PINMUX_SHIFT;
>> +	if (pmu_16bit_ops)
>> +		val |= PMC_SCRATCH55_16BITOP;
>> +	val |= pmu_i2c_addr << PMC_SCRATCH55_I2CSLV1_SHIFT;
>> +
>> +	checksum = reg_addr + reg_data + (val & 0xFF) + ((val >> 8) & 0xFF) +
>> +		((val >> 24) & 0xFF);
>> +	checksum &= 0xFF;
>
> I'd prefer lower-case hexadecimals. Also, what about bits 23:16? Are
> they not needed for the checksum? Again, a comment may help to explain
> this.

Yes, bits 23:16 will contain the checksum itself. I'll add a comment.

>
>> +	checksum = 0x100 - checksum;
>> +
>> +	val |= checksum << PMC_SCRATCH55_CHECKSUM_SHIFT;
>> +
>> +	tegra_pmc_writel(val, PMC_SCRATCH55);
>> +
>> +	pr_info("Tegra: PMC thermal reset enabled\n");
>> +
>> +	return;
>> +
>> +disabled:
>> +	pr_warn("Tegra: PMC thermal reset disabled\n");
>
> You're not giving anyone a clue about what went wrong, so when they see
> this warning they don't know what to do about it. Maybe all paths
> leading here should have a more specific warning message themselves.

I'll add better error messages. Adding the thermtrip node will make this 
look nicer as well, since I can just error out if the thermtrip node 
exists but a required property doesn't.

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>

Thanks,
Mikko
