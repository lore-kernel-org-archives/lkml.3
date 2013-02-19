Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab3BSSMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:12:05 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:45007 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758883Ab3BSSMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:12:03 -0500
Date: Tue, 19 Feb 2013 19:11:57 +0100
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH 7/7] ACPI / scan: Make memory hotplug driver use struct
 acpi_scan_handler
Message-ID: <20130219181157.GA4366@dhcp-192-168-178-175.profitbricks.localdomain>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
 <2200731.3okUfey51A@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2200731.3okUfey51A@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Feb 17, 2013 at 04:27:18PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Make the ACPI memory hotplug driver use struct acpi_scan_handler
> for representing the object used to set up ACPI memory hotplug
> functionality and to remove hotplug memory ranges and data
> structures used by the driver before unregistering ACPI device
> nodes representing memory.  Register the new struct acpi_scan_handler
> object with the help of acpi_scan_add_handler_with_hotplug() to allow
> user space to manipulate the attributes of the memory hotplug
> profile.

Let's consider an example where we want acpi memory device ejection to be safely
handled by userspace. We do the following:

echo 0 > /sys/firmware/acpi/hotplug/memory/autoeject
echo 1 > /sys/firmware/acpi/hotplug/memory/uevents

We succesfully hotplug acpi device:
/sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:00
and its corresponding memblocks /sys/devices/system/memory/memoryXX are
also successfully onlined.

On an eject request, since uevents == 1, the kernel will emit KOBJ_OFFLINE for:
/sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:00

Can userspace know which memblocks in /sys/devices/system/memory/memoryXX/
correspond to the acpi device /sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:00 ?
This will be needed so that userspace tries to offline the memblocks (and only
if successful, issue the eject operation on the acpi device). As far as I see,
we don't create any sysfs links or files for this scenario - can userspace get
this info somehow?

/sys/devices/system/memory/memoryXX/phys_device needs to be properly implemented
for this to work I think, see Documentation/ABI/testing/sysfs-memory

The following test patch works toward that direction. Let me know if it's of
interest or if there are better ideas /comments.

From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Date: Tue, 19 Feb 2013 18:36:25 +0100
Subject: [RFC PATCH] acpi / memory-hotplug: implement phys_device

In order for userspace to know which memblocks in:
/sys/devices/system/memory/memoryXX correspond to which acpi memory devices in:
/sys/devices/LNXSYSTM:00/LNXSYSBUS:00/PNP0C80:YY,
/sys/devices/system/memory/memoryXX/phys_device should return a name (or index
YY) of the memory device each memblock XX belongs to.

WIth this patch, the acpi mem_hotplug driver keeps a global list of acpi memory
devices (inserted in hotplug_order). The base memory driver checks against this
list in arch_get_memory_phys_device to determine the zero-based index of the
physical memory device each new memblock belongs to.

For initial memory or for non-acpi/hotplug enabled systems, phys_device is
always -1.

Signed-off-by: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
---
 Documentation/ABI/testing/sysfs-devices-memory |    8 ++++++-
 drivers/acpi/acpi_memhotplug.c                 |   27 ++++++++++++++++++++++++
 drivers/base/memory.c                          |    7 +++++-
 include/linux/acpi.h                           |    2 +
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
index 7405de2..290c62a 100644
--- a/Documentation/ABI/testing/sysfs-devices-memory
+++ b/Documentation/ABI/testing/sysfs-devices-memory
@@ -27,7 +27,13 @@ Contact:	Badari Pulavarty <pbadari@us.ibm.com>
 Description:
 		The file /sys/devices/system/memory/memoryX/phys_device
 		is read-only and is designed to show the name of physical
-		memory device.  Implementation is currently incomplete.
+		memory device.  Implementation is currently incomplete. In a
+		system with CONFIG_ACPI_HOTPLUG_MEMORY=n, phys_device is always
+	     	-1. In a system with CONFIG_ACPI_HOTPLUG_MEMORY=y, phys_device
+		is -1 for all initial / non-hot-removable memory. For
+	       	memory that has been hot-plugged, phys_device will return the
+	       	zero-based index of the physical device that this memory block
+	       	belongs to. Indices are determined by hotplug order.
 
 What:		/sys/devices/system/memory/memoryX/phys_index
 Date:		September 2008
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index 3be9501..4154dc5 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -48,6 +48,7 @@ ACPI_MODULE_NAME("acpi_memhotplug");
 #define MEMORY_POWER_ON_STATE	1
 #define MEMORY_POWER_OFF_STATE	2
 
+static LIST_HEAD(acpi_mem_device_list);
 static int acpi_memory_device_add(struct acpi_device *device,
 				  const struct acpi_device_id *not_used);
 static void acpi_memory_device_remove(struct acpi_device *device);
@@ -81,6 +82,7 @@ struct acpi_memory_device {
 	struct acpi_device * device;
 	unsigned int state;	/* State of the memory device */
 	struct list_head res_list;
+	struct list_head mem_device_list;
 };
 
 static acpi_status
@@ -287,6 +289,7 @@ static int acpi_memory_device_add(struct acpi_device *device,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&mem_device->res_list);
+	INIT_LIST_HEAD(&mem_device->mem_device_list);
 	mem_device->device = device;
 	sprintf(acpi_device_name(device), "%s", ACPI_MEMORY_DEVICE_NAME);
 	sprintf(acpi_device_class(device), "%s", ACPI_MEMORY_DEVICE_CLASS);
@@ -308,9 +311,11 @@ static int acpi_memory_device_add(struct acpi_device *device,
 		return 0;
 	}
 
+	list_add_tail(&mem_device->mem_device_list, &acpi_mem_device_list);
 	result = acpi_memory_enable_device(mem_device);
 	if (result) {
 		dev_err(&device->dev, "acpi_memory_enable_device() error\n");
+		list_del(&mem_device->mem_device_list);
 		acpi_memory_device_free(mem_device);
 		return -ENODEV;
 	}
@@ -328,9 +333,31 @@ static void acpi_memory_device_remove(struct acpi_device *device)
 
 	mem_device = acpi_driver_data(device);
 	acpi_memory_remove_memory(mem_device);
+	list_del(&mem_device->mem_device_list);
 	acpi_memory_device_free(mem_device);
 }
 
+int acpi_memory_phys_device(unsigned long start_pfn)
+{
+	struct acpi_memory_device *mem_dev;
+	struct acpi_memory_info *info;
+	unsigned long start_addr = start_pfn << PAGE_SHIFT;
+	int id = 0;
+
+	list_for_each_entry(mem_dev, &acpi_mem_device_list, mem_device_list) {
+		list_for_each_entry(info, &mem_dev->res_list, list) {
+			if ((info->start_addr <= start_addr) &&
+				(info->start_addr + info->length > start_addr))
+				return id;
+		}
+		id++;
+	}
+
+	/* Memory not associated with a hot-pluggable device gets -1. For
+	 * example, initial memory. */
+	return -1;
+}
+
 void __init acpi_memory_hotplug_init(void)
 {
 	acpi_scan_add_handler_with_hotplug(&memory_device_handler, "memory");
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 8300a18..2cc98df 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -22,6 +22,7 @@
 #include <linux/mutex.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
 
 #include <linux/atomic.h>
 #include <asm/uaccess.h>
@@ -522,7 +523,11 @@ static inline int memory_fail_init(void)
  */
 int __weak arch_get_memory_phys_device(unsigned long start_pfn)
 {
-	return 0;
+#ifdef CONFIG_ACPI_HOTPLUG_MEMORY
+	return acpi_memory_phys_device(start_pfn);
+#else
+	return -1;
+#endif
 }
 
 /*
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index f46cfd7..00302fc 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -562,6 +562,8 @@ static inline __printf(3, 4) void
 acpi_handle_printk(const char *level, void *handle, const char *fmt, ...) {}
 #endif	/* !CONFIG_ACPI */
 
+int acpi_memory_phys_device(unsigned long start_pfn);
+
 /*
  * acpi_handle_<level>: Print message with ACPI prefix and object path
  *
-- 
1.7.9

