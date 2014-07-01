Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579AbaGAIGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:06:36 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17892 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757485AbaGAIGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:06:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 01 Jul 2014 00:55:59 -0700
Message-ID: <53B26BF2.7090009@nvidia.com>
Date: Tue, 1 Jul 2014 11:06:10 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] thermal: Add Tegra SOCTHERM thermal management driver
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-7-git-send-email-mperttunen@nvidia.com> <53B1D538.6000704@wwwdotorg.org>
In-Reply-To: <53B1D538.6000704@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inline.

On 01/07/14 00:23, Stephen Warren wrote:
> On 06/27/2014 02:11 AM, Mikko Perttunen wrote:
>> This adds support for the Tegra SOCTHERM thermal sensing and management
>> system found in the Tegra124 system-on-chip. This initial driver supports
>> the four thermal zones with hardware-tracked trip points.
>
>> diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_soctherm.c
>
>> +static struct tegra_tsensor t124_tsensors[] = {
>> +	{
>> +		.base = 0xc0,
>> +		.name = "cpu0",
>> +		.config = &t124_tsensor_config,
>> +		.calib_fuse_offset = 0x098,
>> +		.fuse_corr_alpha = 1135400,
>> +		.fuse_corr_beta = -6266900,
>> +	},
>
> I wonder why some of those fields are named "fuse_xxx" when the values
> are hard-coded in these tables rather than read from fuses? These values
> don't seem to be used to adjust values read from fuses.

They are used to when calculating the thermal calibration in 
calculate_tsensor_calibration, which is based on the value read from the 
fuse. Downstream calls them fuse correction values, so I kept that. (I 
guess the meaning of corr might not be obvious..) On downstream there is 
another set of these correction values used depending on the fuse 
revision, but I believe the older revision is only found internally.

>
>> +static int tegra_thermctl_get_temp(void *data, long *out_temp)
>
>> +	switch (zone->sensor) {
>> +	case 0:
>> +		val = readl(zone->tegra->regs + SENSOR_TEMP1)
>> +			>> SENSOR_TEMP1_CPU_TEMP_SHIFT;
>
> Can't the register offset and shift be stored in *zone, so that this
> whole switch can be replaced with something generic:
>
> val = readl(zone->tegra->regs + zone->reg_offset) >> zone->value_shift;

Yes, certainly doable.

>
>> +static int tegra_soctherm_probe(struct platform_device *pdev)
>
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq <= 0) {
>> +		dev_err(&pdev->dev, "can't get interrupt\n");
>> +		return -EINVAL;
>> +	}
>
> irq is assigned once here ... (see later)
>
>> +	for (i = 0; i < 4; ++i) {
>
> Why "4"? Should the loop count be the ARRAY_SIZE(some array)? At the
> very least, a named constant that describes the value would be useful...

The thermctl sensors have been unchanged for a few chip generations, so 
I was thinking that just hardcoding this wouldn't be so bad. But I guess
an array would look nicer here. Will fix.

>
>> +		err = devm_request_threaded_irq(&pdev->dev, irq, soctherm_isr,
>> +						soctherm_isr_thread,
>> +						IRQF_SHARED, "tegra_soctherm",
>> +						zone);
>
> Why request the same IRQ 4 times here. Rather, shouldn't the IRQ be
> requested once, and the ISR simply loop over the status register (or
> whatever there are 4 of)?
>

I had that variant as well, but since we need to pass the list of 
tripped sensors to soctherm_isr_thread somehow, I guess some kind of 
locking or atomic is needed. This version doesn't need that, so I went 
with it.
