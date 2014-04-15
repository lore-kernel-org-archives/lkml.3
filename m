Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbaDOTJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:09:18 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:43209 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbaDOTJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:09:11 -0400
Date: Tue, 15 Apr 2014 12:09:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v3 2/2] x86: intel-mid: add watchdog platform code for
 Merrifield
Message-ID: <20140415190902.GB7940@roeck-us.net>
References: <1397249407-5417-1-git-send-email-david.a.cohen@linux.intel.com>
 <1397587272-31152-1-git-send-email-david.a.cohen@linux.intel.com>
 <1397587272-31152-3-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397587272-31152-3-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 11:41:12AM -0700, David Cohen wrote:
> This patch adds platform code for Intel Merrifield.
> Since the watchdog is not part of SFI table, we have no other option but
> to manually register watchdog's platform device (argh!).
> 
argh ... does this really belong into the commit log ?

> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  arch/x86/platform/intel-mid/device_libs/Makefile   |  1 +
>  .../platform/intel-mid/device_libs/platform_wdt.c  | 63 ++++++++++++++++++++++
>  2 files changed, 64 insertions(+)
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
> index 000000000000..653242110d57
> --- /dev/null
> +++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
> @@ -0,0 +1,63 @@
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
> +#include <linux/intel-mid_wdt.h>

	/platform_data/...

> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <asm/intel-mid.h>
> +
> +#define TANGIER_EXT_TIMER0_MSI 15
> +
> +static struct platform_device wdt_dev = {
> +	.name = "intel_mid_wdt",
> +	.id = -1,
> +};
> +
> +static int tangier_probe(void)
> +{
> +	int ioapic;
> +	struct io_apic_irq_attr irq_attr;
> +
				= { };
would ensure that there are no un-initialized variables
if the structure definition ever changes.

Or just pre-initialize the entire structure as much as possible.

> +	ioapic = mp_find_ioapic(TANGIER_EXT_TIMER0_MSI);
> +	if (ioapic >= 0) {
> +		irq_attr.ioapic = ioapic;
> +		irq_attr.ioapic_pin = TANGIER_EXT_TIMER0_MSI;
> +		irq_attr.trigger = 1;
> +		irq_attr.polarity = 0; /* Active high */
> +		io_apic_set_pci_routing(NULL, TANGIER_EXT_TIMER0_MSI,
> +					&irq_attr);

No need for an error check ? I understand no one else does,
but why does the function return an error if no one cares about it ?

> +	} else {
> +		pr_warn("intel_mid_wdt: can not find interrupt %d in ioapic\n",
> +			TANGIER_EXT_TIMER0_MSI);

As mentioned earlier, I think it would pake sense to pass
struct platform_device * as argument and use dev_warn.

It would also enable you to use the irq passed from the parameter
instead of checking for the hard-coded define.

> +		return -EINVAL;

Why not return the error returned by mp_find_ioapic() ?

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
