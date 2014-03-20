Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbaCTNXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:23:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57218 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610AbaCTNXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:23:48 -0400
Message-ID: <532AEBBD.80707@ti.com>
Date: Thu, 20 Mar 2014 18:53:09 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Tejun Heo <tj@kernel.org>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, <linux-ide@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <spear-devel@list.st.com>
Subject: Re: [PATCH 3/4] ata: add new-style AHCI platform driver for DaVinci
 DA850 AHCI controller
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com> <1395081118-15248-4-git-send-email-b.zolnierkie@samsung.com> <532AA2B0.1060103@ti.com> <2662651.GJX9HVKij5@amdc1032>
In-Reply-To: <2662651.GJX9HVKij5@amdc1032>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 March 2014 06:27 PM, Bartlomiej Zolnierkiewicz wrote:

>>> diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c

>>> +extern void __iomem *da8xx_syscfg1_base;
>>
>> This platform specific extern symbol should not be used in drivers and
>> in fact checkpatch complains about it too. Can you instead get the
>> addresses you need as part of the device resources?
> 
> This is problematic because it is system resource not particular device
> resource.  I would prefer to wait with fixing it until the conversion to
> the device tree.

The way you have it now, module build will fail because the symbol isn't
exported from platform code (and it should not be). The register is
"system level" but it is SATA specific and I see no problem in passing
it to the driver.

Conversion to device tree will not change anything until we throw out
the platform device code. That may or may not ever happen.

>>> +static int da850_sata_init(struct device *dev, void __iomem *addr)
>>> +{
>>> +	int i, ret;
>>> +	unsigned int val;
>>> +
>>> +	da850_sata_clk = clk_get(dev, NULL);
>>> +	if (IS_ERR(da850_sata_clk))
>>> +		return PTR_ERR(da850_sata_clk);
>>> +
>>> +	ret = clk_prepare_enable(da850_sata_clk);
>>> +	if (ret)
>>> +		goto err0;
>>
>> Please switch to pm_runtime instead of using the clock APIs directly.
> 
> Could you please elaborate a bit more on this?

I meant using pm_runtime_get_sync() to enable the clocks. There are many
examples in the kernel. drivers/watchdog/omap_wdt.c is one.
Documentation is available in Documentation/power/runtime_pm.txt

>>> +static struct platform_device_id ahci_da850_platform_ids[] = {
>>> +	{ .name = "ahci" },
>>
>> I was not able to get this driver probed with this name (I guess that
>> was because the generic driver was picked instead?). Can you please
> 
> Yes, the generic driver should be disabled to use this one.

>> change it to "da850-sata"?
> 
> I prefer to remove the ids table (so the "ahci_da850" driver name is
> used) and update the platform device name accordingly.  This would also
> allow me to remove the old ahci_platform_data code in this patch.
> 
> Is this OK with you?

Fine with me. Sounds good.

Thanks,
Sekhar

