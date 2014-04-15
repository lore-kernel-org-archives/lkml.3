Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbaDOUKH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:10:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:10263 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaDOUKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,866,1389772800"; 
   d="scan'208";a="521557067"
Date: Tue, 15 Apr 2014 13:09:00 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v4 2/2] x86: intel-mid: add watchdog platform code for
 Merrifield
Message-ID: <20140415200900.GJ5986@psi-dev26.jf.intel.com>
References: <1397587272-31152-1-git-send-email-david.a.cohen@linux.intel.com>
 <1397592366-3899-1-git-send-email-david.a.cohen@linux.intel.com>
 <1397592366-3899-3-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397592366-3899-3-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 01:06:06PM -0700, David Cohen wrote:
> This patch adds platform code for Intel Merrifield.
> Since the watchdog is not part of SFI table, we have no other option but
> to manually register watchdog's platform device (argh!).
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  arch/x86/platform/intel-mid/device_libs/Makefile   |  1 +
>  .../platform/intel-mid/device_libs/platform_wdt.c  | 66 ++++++++++++++++++++++
>  2 files changed, 67 insertions(+)
>  create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_wdt.c
> 
> diff --git a/arch/x86/platform/intel-mid/device_libs/Makefile b/arch/x86/platform/intel-mid/device_libs/Makefile
> index 097e7a7940d8..af9307f2cc28 100644
> --- a/arch/x86/platform/intel-mid/device_libs/Makefile
> +++ b/arch/x86/platform/intel-mid/device_libs/Makefile
> @@ -20,3 +20,4 @@ obj-$(subst m,y,$(CONFIG_DRM_MEDFIELD)) += platform_tc35876x.o
>  obj-$(subst m,y,$(CONFIG_SERIAL_MRST_MAX3110)) += platform_max3111.o
>  # MISC Devices
>  obj-$(subst m,y,$(CONFIG_KEYBOARD_GPIO)) += platform_gpio_keys.o
> +obj-$(subst m,y,$(CONFIG_INTEL_MID_WATCHDOG)) += platform_wdt.o
> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
> new file mode 100644
> index 000000000000..4b0434b54aff
> --- /dev/null
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
> @@ -0,0 +1,66 @@
> +/*
> + * platform_wdt.c: Watchdog platform library file
> + *
> + * (C) Copyright 2014 Intel Corporation
> + * Author: David Cohen <david.a.cohen@linux.intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/platform_data/intel-mid_wdt.h>
> +#include <asm/intel-mid.h>
> +
> +#define TANGIER_EXT_TIMER0_MSI 15
> +
> +static struct platform_device wdt_dev = {
> +	.name = "intel_mid_wdt",
> +	.id = -1,
> +};
> +
> +static int tangier_probe(struct platform_device *pdev)
> +{
> +	int ioapic;
> +	struct io_apic_irq_attr irq_attr = { 0 };
> +
> +	ioapic = mp_find_ioapic(TANGIER_EXT_TIMER0_MSI);

Forgot remove this hardcoded irq number. I'll send v4.1 of this patch.

BR, David

> +	if (ioapic >= 0) {
> +		int ret;
> +		irq_attr.ioapic = ioapic;
> +		irq_attr.ioapic_pin = TANGIER_EXT_TIMER0_MSI;
> +		irq_attr.trigger = 1;
> +		irq_attr.polarity = 0; /* Active high */
> +		ret = io_apic_set_pci_routing(NULL, TANGIER_EXT_TIMER0_MSI,
> +					      &irq_attr);
> +		if (ret)
> +			return ret;
> +	} else {
> +		dev_warn(&pdev->dev, "cannot find interrupt %d in ioapic\n",
> +			 TANGIER_EXT_TIMER0_MSI);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static struct intel_mid_wdt_pdata tangier_pdata = {
> +	.irq = TANGIER_EXT_TIMER0_MSI,
> +	.probe = tangier_probe,
> +};
> +
> +static int __init register_mid_wdt(void)
> +{
> +	if (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_TANGIER) {
> +		wdt_dev.dev.platform_data = &tangier_pdata;
> +		return platform_device_register(&wdt_dev);
> +	}
> +
> +	return -ENODEV;
> +}
> +
> +rootfs_initcall(register_mid_wdt);
> -- 
> 1.9.1
> 
