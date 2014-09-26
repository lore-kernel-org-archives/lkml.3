Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbaIZPLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:11:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40092 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbaIZPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:11:13 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:aca4:bf5e:39c6:55e8]
In-Reply-To: <1411512325.24563.59.camel@ul30vt.home>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
 <1411483586-29304-8-git-send-email-a.motakis@virtualopensystems.com> <1411512325.24563.59.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Fri, 26 Sep 2014 17:10:52 +0200
Message-ID: <CAG8rG2zbiwhN3VPw4vgeVEU6EOxDVuHmT7e2bUjfmNUkFPxV6Q@mail.gmail.com>
Subject: Re: [PATCHv7 07/26] driver core: amba: add device binding path 'driver_override'
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Eric Auger <eric.auger@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, they will be posted separately.

Thanks

On Wed, Sep 24, 2014 at 12:45 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Tue, 2014-09-23 at 16:46 +0200, Antonios Motakis wrote:
>> As already demonstrated with PCI [1] and the platform bus [2], a
>> driver_override property in sysfs can be used to bypass the id matching
>> of a device to a AMBA driver. This can be used by VFIO to bind to any AMBA
>> device requested by the user.
>>
>> [1] http://lists-archives.com/linux-kernel/28030441-pci-introduce-new-device-binding-path-using-pci_dev-driver_override.html
>> [2] https://www.redhat.com/archives/libvir-list/2014-April/msg00382.html
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/amba/bus.c       | 44 ++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/amba/bus.h |  1 +
>>  2 files changed, 45 insertions(+)
>
> Why are 7 & 8 being dragged into this series?  Combine them into a
> single patch and post it separately.
>
>>
>> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
>> index 3cf61a1..473177c 100644
>> --- a/drivers/amba/bus.c
>> +++ b/drivers/amba/bus.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/pm_runtime.h>
>>  #include <linux/amba/bus.h>
>>  #include <linux/sizes.h>
>> +#include <linux/limits.h>
>>
>>  #include <asm/irq.h>
>>
>> @@ -42,6 +43,10 @@ static int amba_match(struct device *dev, struct device_driver *drv)
>>       struct amba_device *pcdev = to_amba_device(dev);
>>       struct amba_driver *pcdrv = to_amba_driver(drv);
>>
>> +     /* When driver_override is set, only bind to the matching driver */
>> +     if (pcdev->driver_override)
>> +             return !strcmp(pcdev->driver_override, drv->name);
>> +
>>       return amba_lookup(pcdrv->id_table, pcdev) != NULL;
>>  }
>>
>> @@ -58,6 +63,44 @@ static int amba_uevent(struct device *dev, struct kobj_uevent_env *env)
>>       return retval;
>>  }
>>
>> +static ssize_t driver_override_show(struct device *_dev,
>> +                                 struct device_attribute *attr, char *buf)
>> +{
>> +     struct amba_device *dev = to_amba_device(_dev);
>> +
>> +     return sprintf(buf, "%s\n", dev->driver_override);
>> +}
>> +
>> +static ssize_t driver_override_store(struct device *_dev,
>> +                                  struct device_attribute *attr,
>> +                                  const char *buf, size_t count)
>> +{
>> +     struct amba_device *dev = to_amba_device(_dev);
>> +     char *driver_override, *old = dev->driver_override, *cp;
>> +
>> +     if (count > PATH_MAX)
>> +             return -EINVAL;
>> +
>> +     driver_override = kstrndup(buf, count, GFP_KERNEL);
>> +     if (!driver_override)
>> +             return -ENOMEM;
>> +
>> +     cp = strchr(driver_override, '\n');
>> +     if (cp)
>> +             *cp = '\0';
>> +
>> +     if (strlen(driver_override)) {
>> +             dev->driver_override = driver_override;
>> +     } else {
>> +            kfree(driver_override);
>> +            dev->driver_override = NULL;
>> +     }
>> +
>> +     kfree(old);
>> +
>> +     return count;
>> +}
>> +
>>  #define amba_attr_func(name,fmt,arg...)                                      \
>>  static ssize_t name##_show(struct device *_dev,                              \
>>                          struct device_attribute *attr, char *buf)    \
>> @@ -80,6 +123,7 @@ amba_attr_func(resource, "\t%016llx\t%016llx\t%016lx\n",
>>  static struct device_attribute amba_dev_attrs[] = {
>>       __ATTR_RO(id),
>>       __ATTR_RO(resource),
>> +     __ATTR_RW(driver_override),
>>       __ATTR_NULL,
>>  };
>>
>> diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
>> index fdd7e1b..7c011e7 100644
>> --- a/include/linux/amba/bus.h
>> +++ b/include/linux/amba/bus.h
>> @@ -32,6 +32,7 @@ struct amba_device {
>>       struct clk              *pclk;
>>       unsigned int            periphid;
>>       unsigned int            irq[AMBA_NR_IRQS];
>> +     char                    *driver_override;
>>  };
>>
>>  struct amba_driver {
>
>
>



-- 
Antonios Motakis
Virtual Open Systems
