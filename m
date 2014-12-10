Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721AbaLJOr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:47:57 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43968 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbaLJOr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:47:56 -0500
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:224:8cff:fe66:7f7e]
In-Reply-To: <1417109154-10331-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1417109154-10331-1-git-send-email-a.motakis@virtualopensystems.com>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Wed, 10 Dec 2014 15:47:35 +0100
Message-ID: <CAG8rG2w=0C=r9WjsyxrGG=6i=Ww1-tD7Q2sLvHWYCN9xwnz1AA@mail.gmail.com>
Subject: Re: [REPORT PATCH] driver core: amba: add device binding path 'driver_override'
To: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Eric Auger <eric.auger@linaro.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        kvm-arm <kvmarm@lists.cs.columbia.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russel,

Do you think this patch can be included eventually?

If not, what would we still need to change, or is there another
approach you would accept?

Thanks and best regards,
Antonios

On Thu, Nov 27, 2014 at 6:25 PM, Antonios Motakis
<a.motakis@virtualopensystems.com> wrote:
> As already demonstrated with PCI [1] and the platform bus [2], a
> driver_override property in sysfs can be used to bypass the id matching
> of a device to a AMBA driver. This can be used by VFIO to bind to any AMBA
> device requested by the user.
>
> [1] http://lists-archives.com/linux-kernel/28030441-pci-introduce-new-device-binding-path-using-pci_dev-driver_override.html
> [2] https://www.redhat.com/archives/libvir-list/2014-April/msg00382.html
>
> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> Reviewed-by: Kim Phillips <kim.phillips@freescale.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-amba | 20 ++++++++++++++
>  drivers/amba/bus.c                       | 47 ++++++++++++++++++++++++++++++++
>  include/linux/amba/bus.h                 |  1 +
>  3 files changed, 68 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-bus-amba
>
> diff --git a/Documentation/ABI/testing/sysfs-bus-amba b/Documentation/ABI/testing/sysfs-bus-amba
> new file mode 100644
> index 0000000..e7b5467
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-bus-amba
> @@ -0,0 +1,20 @@
> +What:          /sys/bus/amba/devices/.../driver_override
> +Date:          September 2014
> +Contact:       Antonios Motakis <a.motakis@virtualopensystems.com>
> +Description:
> +               This file allows the driver for a device to be specified which
> +               will override standard OF, ACPI, ID table, and name matching.
> +               When specified, only a driver with a name matching the value
> +               written to driver_override will have an opportunity to bind to
> +               the device. The override is specified by writing a string to the
> +               driver_override file (echo vfio-amba > driver_override) and may
> +               be cleared with an empty string (echo > driver_override).
> +               This returns the device to standard matching rules binding.
> +               Writing to driver_override does not automatically unbind the
> +               device from its current driver or make any attempt to
> +               automatically load the specified driver. If no driver with a
> +               matching name is currently loaded in the kernel, the device will
> +               not bind to any driver. This also allows devices to opt-out of
> +               driver binding using a driver_override name such as "none".
> +               Only a single driver may be specified in the override, there is
> +               no support for parsing delimiters.
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index 47bbdc1..14bb08b 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -18,6 +18,7 @@
>  #include <linux/pm_domain.h>
>  #include <linux/amba/bus.h>
>  #include <linux/sizes.h>
> +#include <linux/limits.h>
>
>  #include <asm/irq.h>
>
> @@ -43,6 +44,10 @@ static int amba_match(struct device *dev, struct device_driver *drv)
>         struct amba_device *pcdev = to_amba_device(dev);
>         struct amba_driver *pcdrv = to_amba_driver(drv);
>
> +       /* When driver_override is set, only bind to the matching driver */
> +       if (pcdev->driver_override)
> +               return !strcmp(pcdev->driver_override, drv->name);
> +
>         return amba_lookup(pcdrv->id_table, pcdev) != NULL;
>  }
>
> @@ -59,6 +64,47 @@ static int amba_uevent(struct device *dev, struct kobj_uevent_env *env)
>         return retval;
>  }
>
> +static ssize_t driver_override_show(struct device *_dev,
> +                                   struct device_attribute *attr, char *buf)
> +{
> +       struct amba_device *dev = to_amba_device(_dev);
> +
> +       if (!dev->driver_override)
> +               return 0;
> +
> +       return sprintf(buf, "%s\n", dev->driver_override);
> +}
> +
> +static ssize_t driver_override_store(struct device *_dev,
> +                                    struct device_attribute *attr,
> +                                    const char *buf, size_t count)
> +{
> +       struct amba_device *dev = to_amba_device(_dev);
> +       char *driver_override, *old = dev->driver_override, *cp;
> +
> +       if (count > PATH_MAX)
> +               return -EINVAL;
> +
> +       driver_override = kstrndup(buf, count, GFP_KERNEL);
> +       if (!driver_override)
> +               return -ENOMEM;
> +
> +       cp = strchr(driver_override, '\n');
> +       if (cp)
> +               *cp = '\0';
> +
> +       if (strlen(driver_override)) {
> +               dev->driver_override = driver_override;
> +       } else {
> +              kfree(driver_override);
> +              dev->driver_override = NULL;
> +       }
> +
> +       kfree(old);
> +
> +       return count;
> +}
> +
>  #define amba_attr_func(name,fmt,arg...)                                        \
>  static ssize_t name##_show(struct device *_dev,                                \
>                            struct device_attribute *attr, char *buf)    \
> @@ -81,6 +127,7 @@ amba_attr_func(resource, "\t%016llx\t%016llx\t%016lx\n",
>  static struct device_attribute amba_dev_attrs[] = {
>         __ATTR_RO(id),
>         __ATTR_RO(resource),
> +       __ATTR_RW(driver_override),
>         __ATTR_NULL,
>  };
>
> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
> index c324f57..34a7004 100644
> --- a/include/linux/amba/bus.h
> +++ b/include/linux/amba/bus.h
> @@ -32,6 +32,7 @@ struct amba_device {
>         struct clk              *pclk;
>         unsigned int            periphid;
>         unsigned int            irq[AMBA_NR_IRQS];
> +       char                    *driver_override;
>  };
>
>  struct amba_driver {
> --
> 2.1.3
>
