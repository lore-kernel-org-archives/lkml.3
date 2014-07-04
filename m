Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaGDLwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:52:55 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19675 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaGDLwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:52:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 04 Jul 2014 04:46:11 -0700
Message-ID: <53B69590.6070004@nvidia.com>
Date: Fri, 4 Jul 2014 14:52:48 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>, "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "edubezval@gmail.com" <edubezval@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 6/6] thermal: Add Tegra SOCTHERM thermal management driver
References: <1403856699-2140-1-git-send-email-mperttunen@nvidia.com> <1403856699-2140-7-git-send-email-mperttunen@nvidia.com> <53B66915.4040309@nvidia.com>
In-Reply-To: <53B66915.4040309@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/14 11:43, Wei Ni wrote:
> On 06/27/2014 04:11 PM, Mikko Perttunen wrote:
>> This adds support for the Tegra SOCTHERM thermal sensing and management
>> system found in the Tegra124 system-on-chip. This initial driver supports
>> the four thermal zones with hardware-tracked trip points.
>
>> diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_soctherm.c
>
>> +static int calculate_shared_calibration(struct tsensor_shared_calibration *r)
>> +{
>> +       u32 val;
>> +       u32 shifted_cp, shifted_ft;
>> +       int err;
>> +
>> +       err = tegra_fuse_readl(FUSE_TSENSOR8_CALIB, &val);
>> +       if (err)
>> +               return err;
>> +       r->base_cp = val & 0x3ff;
>> +       r->base_ft = (val & (0x7ff << 10)) >> 10;
>> +
>> +       err = tegra_fuse_readl(FUSE_SPARE_REALIGNMENT_REG_0, &val);
>> +       if (err)
>> +               return err;
>> +       /* Sign extend from 6 bits to 32 bits */
>> +       shifted_cp = (s32)((val & 0x1f) | ((val & 0x20) ? 0xffffffe0 : 0x0));
>> +       val = ((val & (0x1f << 21)) >> 21);
>> +       /* Sign extend from 5 bits to 32 bits */
>> +       shifted_ft = (s32)((val & 0xf) | ((val & 0x10) ? 0xfffffff0 : 0x0));
>> +
>> +       r->actual_temp_cp = 2 * 25 + shifted_cp;
> Do we need to define the "25" as constant, just like below line.

I believe downstream just uses "25" which is the reason I used it, but 
yes, a constant would be nicer.

>
>> +       r->actual_temp_ft = 2 * NOMINAL_CALIB_FT_T124 + shifted_ft;
>> +
>> +       return 0;
>> +}
>
>> +
>> +static irqreturn_t soctherm_isr(int irq, void *dev_id)
>> +{
>> +       struct tegra_thermctl_zone *zone = dev_id;
>> +       u32 val;
>> +       u32 intr_mask = 0x03 << t124_thermctl_shifts[zone->sensor];
>> +
>> +       val = readl(zone->tegra->regs + THERMCTL_INTR_STATUS);
>> +
>> +       if ((val & intr_mask) == 0)
>> +               return IRQ_NONE;
>> +
>> +       writel(val & intr_mask, zone->tegra->regs + THERMCTL_INTR_STATUS);
> I think we need to disable the interrupt here, and enable it again after
> updating the high/low limited values. If not, there will trigger mass of
> interrupts.
>

Good point. It works now because of-thermal will set up the new trip 
points during soctherm_thread_isr, and apparently the interrupt is kept 
disabled until after that.

>> +
>> +static struct platform_driver tegra_soctherm_driver = {
>> +       .probe = tegra_soctherm_probe,
>> +       .remove = tegra_soctherm_remove,
>> +       .driver = {
>> +               .name = "tegra_soctherm",
>> +               .owner = THIS_MODULE,
>> +               .of_match_table = tegra_soctherm_of_match,
>> +       },
>> +};
> Will you consider to add suspend/resume support?

I guess for this one it should be simple; same driver probe and teardown 
as normally. Although currently suspend doesn't support LP0 so no-op is 
enough.

>
> Thanks.
> Wei.
>

Thanks
