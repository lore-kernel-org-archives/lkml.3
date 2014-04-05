Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaDECHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 22:07:50 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50638 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaDECHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 22:07:40 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <533F6561.2090205@roeck-us.net>
Date: Fri, 04 Apr 2014 19:07:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kim Phillips <kim.phillips@freescale.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC: Kim Phillips <kim.phillips@linaro.org>, gregkh@linuxfoundation.org,
        stuart.yoder@freescale.com, kvm@vger.kernel.org,
        jan.kiszka@siemens.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, bhelgaas@google.com,
        Varun.Sethi@freescale.com, kvmarm@lists.cs.columbia.edu,
        rafael.j.wysocki@intel.com, agraf@suse.de, linux-pci@vger.kernel.org,
        konrad.wilk@oracle.com, d.kasatkin@samsung.com, tj@kernel.org,
        scottwood@freescale.com, a.motakis@virtualopensystems.com,
        tech@virtualopensystems.com, Bharat.Bhushan@freescale.com,
        toshi.kani@hp.com, a.rigo@virtualopensystems.com,
        iommu@lists.linux-foundation.org, joe@perches.com,
        christoffer.dall@linaro.org
Subject: Re: [RFC PATCH] PCI: Introduce new device binding path using pci_dev.driver_override
References: <20140401161851.18815.31108.stgit@bling.home>	<20140401185212.7229f2c114c7e95089f00e90@linaro.org>	<20140402002324.GA2662@kroah.com>	<20140402170638.51745f5c231a7632422e4cc5@linaro.org>	<1396479728.476.410.camel@ul30vt.home> <20140404203512.5b5ac8a134a71065518712c3@freescale.com>
In-Reply-To: <20140404203512.5b5ac8a134a71065518712c3@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2014 06:35 PM, Kim Phillips wrote:
> Needed by platform device drivers, such as the vfio-platform driver [1],
> in order to bypass the existing OF, ACPI, id_table and name string matches,
> and successfully be able to be bound to any device, like so:
>
> echo vfio-platform > /sys/bus/platform/devices/fff51000.ethernet/driver_override
> echo fff51000.ethernet > /sys/bus/platform/devices/fff51000.ethernet/driver/unbind
> echo fff51000.ethernet > /sys/bus/platform/drivers_probe
>
> This mimics "PCI: Introduce new device binding path using
> pci_dev.driver_override" [2], which is an interface enhancement
> for more deterministic PCI device binding, e.g., when in the
> presence of hotplug.
>
> [1] http://lkml.iu.edu/hypermail/linux/kernel/1402.1/00177.html
> [2] http://thread.gmane.org/gmane.linux.kernel.iommu/4605
>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---
> if this looks ok, should it be included in the next version of the
> vfio-platform submission series, like last time ([1] above)?
>
>   Documentation/ABI/testing/sysfs-bus-platform | 17 ++++++++++
>   drivers/base/platform.c                      | 46 ++++++++++++++++++++++++++++
>   include/linux/platform_device.h              |  1 +
>   3 files changed, 64 insertions(+)
>   create mode 100644 Documentation/ABI/testing/sysfs-bus-platform
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-platform b/Documentation/ABI/testing/sysfs-bus-platform
> new file mode 100644
> index 0000000..6b14a6a
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-platform
> @@ -0,0 +1,17 @@
> +What:		/sys/bus/platform/devices/.../driver_override
> +Date:		April 2014
> +Contact:	Kim Phillips <kim.phillips@freescale.com>
> +Description:
> +		This file allows the driver for a device to be specified
> +		which will override standard OF, ACPI, ID table, and name
> +		matching.  When specified, only a driver with a name matching
> +		the value written to driver_override will have an opportunity
> +		to bind to the device.  The override may be cleared by
> +		writing an empty string (ex. echo > driver_override), returning
> +		the device to standard matching rules binding.  Writing to
> +		driver_override does not automatically unbind the device from
> +		its current driver or make any attempt to automatically load
> +		the specified driver name.  If no driver with a matching name
> +		is currently loaded in the kernel, no match will be found.
> +		This also allows devices to opt-out of driver binding using
> +		a driver_override name such as "none".
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index e714709..ded1db1 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -22,6 +22,7 @@
>   #include <linux/pm_runtime.h>
>   #include <linux/idr.h>
>   #include <linux/acpi.h>
> +#include <linux/limits.h>
>
>   #include "base.h"
>   #include "power/power.h"
> @@ -690,8 +691,49 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
>   }
>   static DEVICE_ATTR_RO(modalias);
>
> +static ssize_t driver_override_store(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	char *driver_override, *old = pdev->driver_override;
> +
> +	if (count > PATH_MAX)
> +		return -EINVAL;
> +
> +	driver_override = kstrndup(buf, count, GFP_KERNEL);
> +	if (!driver_override)
> +		return -ENOMEM;
> +
> +	while (strlen(driver_override) &&
> +	       driver_override[strlen(driver_override) - 1] == '\n')
> +		driver_override[strlen(driver_override) - 1] = '\0';
> +

Seems to me that something like

	cp = strchr(driver_override, '\n');
	if (cp)
		*cp = '\0';

would be much simpler.

Guenter

