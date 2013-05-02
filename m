Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab3EBXYW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:24:22 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:33304 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3EBXYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:24:20 -0400
Message-ID: <1367536287.16154.171.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/4] Driver core: Add offline/online device operations
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com, Len Brown <lenb@kernel.org>
Date: Thu, 02 May 2013 17:11:27 -0600
In-Reply-To: <1647668.odH0HuOGZ9@vostro.rjw.lan>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan>
	 <3166726.elbgrUIZ0L@vostro.rjw.lan> <1647668.odH0HuOGZ9@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-02 at 14:27 +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> In some cases, graceful hot-removal of devices is not possible,
> although in principle the devices in question support hotplug.
> For example, that may happen for the last CPU in the system or
> for memory modules holding kernel memory.
> 
> In those cases it is nice to be able to check if the given device
> can be gracefully hot-removed before triggering a removal procedure
> that cannot be aborted or reversed.  Unfortunately, however, the
> kernel currently doesn't provide any support for that.
> 
> To address that deficiency, introduce support for offline and
> online operations that can be performed on devices, respectively,
> before a hot-removal and in case when it is necessary (or convenient)
> to put a device back online after a successful offline (that has not
> been followed by removal).  The idea is that the offline will fail
> whenever the given device cannot be gracefully removed from the
> system and it will not be allowed to use the device after a
> successful offline (until a subsequent online) in analogy with the
> existing CPU offline/online mechanism.
> 
> For now, the offline and online operations are introduced at the
> bus type level, as that should be sufficient for the most urgent use
> cases (CPUs and memory modules).  In the future, however, the
> approach may be extended to cover some more complicated device
> offline/online scenarios involving device drivers etc.
> 
> The lock_device_hotplug() and unlock_device_hotplug() functions are
> introduced because subsequent patches need to put larger pieces of
> code under device_hotplug_lock to prevent race conditions between
> device offline and removal from happening.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Looks good.  For patch 1/4 to 3/4:

Reviewed-by: Toshi Kani <toshi.kani@hp.com>

I have one minor comment below.

> ---
>  Documentation/ABI/testing/sysfs-devices-online |   20 +++
>  drivers/base/core.c                            |  130 +++++++++++++++++++++++++
>  include/linux/device.h                         |   21 ++++
>  3 files changed, 171 insertions(+)
> 
> Index: linux-pm/include/linux/device.h
> ===================================================================
> --- linux-pm.orig/include/linux/device.h
> +++ linux-pm/include/linux/device.h
> @@ -70,6 +70,10 @@ extern void bus_remove_file(struct bus_t
>   *		the specific driver's probe to initial the matched device.
>   * @remove:	Called when a device removed from this bus.
>   * @shutdown:	Called at shut-down time to quiesce the device.
> + *
> + * @online:	Called to put the device back online (after offlining it).
> + * @offline:	Called to put the device offline for hot-removal. May fail.
> + *
>   * @suspend:	Called when a device on this bus wants to go to sleep mode.
>   * @resume:	Called to bring a device on this bus out of sleep mode.
>   * @pm:		Power management operations of this bus, callback the specific
> @@ -103,6 +107,9 @@ struct bus_type {
>  	int (*remove)(struct device *dev);
>  	void (*shutdown)(struct device *dev);
>  
> +	int (*online)(struct device *dev);
> +	int (*offline)(struct device *dev);
> +
>  	int (*suspend)(struct device *dev, pm_message_t state);
>  	int (*resume)(struct device *dev);
>  
> @@ -646,6 +653,8 @@ struct acpi_dev_node {
>   * @release:	Callback to free the device after all references have
>   * 		gone away. This should be set by the allocator of the
>   * 		device (i.e. the bus driver that discovered the device).
> + * @offline_disabled: If set, the device is permanently online.
> + * @offline:	Set after successful invocation of bus type's .offline().
>   *
>   * At the lowest level, every device in a Linux system is represented by an
>   * instance of struct device. The device structure contains the information
> @@ -718,6 +727,9 @@ struct device {
>  
>  	void	(*release)(struct device *dev);
>  	struct iommu_group	*iommu_group;
> +
> +	bool			offline_disabled:1;
> +	bool			offline:1;
>  };
>  
>  static inline struct device *kobj_to_dev(struct kobject *kobj)
> @@ -853,6 +865,15 @@ extern const char *device_get_devnode(st
>  extern void *dev_get_drvdata(const struct device *dev);
>  extern int dev_set_drvdata(struct device *dev, void *data);
>  
> +static inline bool device_supports_offline(struct device *dev)

Since we renamed "offline" to "hotplug" for the lock interfaces, should
this function be renamed to device_supports_hotplug() as well?

Thanks,
-Toshi

> +{
> +	return dev->bus && dev->bus->offline && dev->bus->online;
> +}
> +


