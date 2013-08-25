Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab3HYT7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 15:59:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33560 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756555Ab3HYT7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 15:59:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: [PATCH] driver core / ACPI: Avoid device removal locking problems
Date: Sun, 25 Aug 2013 22:09:47 +0200
Message-ID: <1543475.L7gSB7lLAu@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There are two mutexes, device_hotplug_lock and acpi_scan_lock, held
around the acpi_bus_trim() call in acpi_scan_hot_remove() which
generally removes devices (it removes ACPI device objects at least,
but it may also remove "physical" device objects through .detach()
callbacks of ACPI scan handlers).  Thus, potentially, device sysfs
attributes are removed under these locks and to remove those
attributes it is necessary to hold the s_active references of their
directory entries for writing.

On the other hand, the execution of a .show() or .store() callback
from a sysfs attribute is carried out with that attribute's s_active
reference held for reading.  Consequently, if any device sysfs
attribute that may be removed from within acpi_scan_hot_remove()
through acpi_bus_trim() has a .store() or .show() callback which
acquires either acpi_scan_lock or device_hotplug_lock, the execution
of that callback may deadlock with the removal of the attribute.
[Unfortunately, the "online" device attribute of CPUs and memory
blocks and the "eject" attribute of ACPI device objects are affected
by this issue.]

To avoid those deadlocks introduce a new protection mechanism that
can be used by the device sysfs attributes in question.  Namely,
if a device sysfs attribute's .store() or .show() callback routine
is about to acquire device_hotplug_lock or acpi_scan_lock, it can
first execute read_lock_device_remove() and return an error code if
that function returns false.  If true is returned, the lock in
question may be acquired and read_unlock_device_remove() must be
called.  [This mechanism is implemented by means of an additional
rwsem in drivers/base/core.c.]

Make the affected sysfs attributes in the driver core and ACPI core
use read_lock_device_remove() and read_unlock_device_remove() as
described above.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---

For 3.12, applies on top of linux-pm.git/linux-next.

Thanks,
Rafael

---
 drivers/acpi/scan.c    |    8 ++++++++
 drivers/base/core.c    |   29 +++++++++++++++++++++++++++++
 include/linux/device.h |    4 ++++
 3 files changed, 41 insertions(+)

Index: linux-pm/drivers/base/core.c
===================================================================
--- linux-pm.orig/drivers/base/core.c
+++ linux-pm/drivers/base/core.c
@@ -408,7 +408,11 @@ static ssize_t show_online(struct device
 {
 	bool val;
 
+	if (!read_lock_device_remove())
+		return -EBUSY;
+
 	lock_device_hotplug();
+	read_unlock_device_remove();
 	val = !dev->offline;
 	unlock_device_hotplug();
 	return sprintf(buf, "%u\n", val);
@@ -424,7 +428,11 @@ static ssize_t store_online(struct devic
 	if (ret < 0)
 		return ret;
 
+	if (!read_lock_device_remove())
+		return -EBUSY;
+
 	lock_device_hotplug();
+	read_unlock_device_remove();
 	ret = val ? device_online(dev) : device_offline(dev);
 	unlock_device_hotplug();
 	return ret < 0 ? ret : count;
@@ -1479,8 +1487,29 @@ EXPORT_SYMBOL_GPL(put_device);
 EXPORT_SYMBOL_GPL(device_create_file);
 EXPORT_SYMBOL_GPL(device_remove_file);
 
+static DECLARE_RWSEM(device_remove_rwsem);
 static DEFINE_MUTEX(device_hotplug_lock);
 
+bool __must_check read_lock_device_remove(void)
+{
+	return down_read_trylock(&device_remove_rwsem);
+}
+
+void read_unlock_device_remove(void)
+{
+	up_read(&device_remove_rwsem);
+}
+
+void device_remove_begin(void)
+{
+	down_write(&device_remove_rwsem);
+}
+
+void device_remove_end(void)
+{
+	up_write(&device_remove_rwsem);
+}
+
 void lock_device_hotplug(void)
 {
 	mutex_lock(&device_hotplug_lock);
Index: linux-pm/include/linux/device.h
===================================================================
--- linux-pm.orig/include/linux/device.h
+++ linux-pm/include/linux/device.h
@@ -893,6 +893,10 @@ static inline bool device_supports_offli
 	return dev->bus && dev->bus->offline && dev->bus->online;
 }
 
+extern bool __must_check read_lock_device_remove(void);
+extern void read_unlock_device_remove(void);
+extern void device_remove_begin(void);
+extern void device_remove_end(void);
 extern void lock_device_hotplug(void);
 extern void unlock_device_hotplug(void);
 extern int device_offline(struct device *dev);
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -288,6 +288,7 @@ static void acpi_bus_device_eject(void *
 	struct acpi_scan_handler *handler;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 
+	device_remove_begin();
 	mutex_lock(&acpi_scan_lock);
 
 	acpi_bus_get_device(handle, &device);
@@ -315,6 +316,7 @@ static void acpi_bus_device_eject(void *
 
  out:
 	mutex_unlock(&acpi_scan_lock);
+	device_remove_end();
 	return;
 
  err_out:
@@ -449,6 +451,7 @@ void acpi_bus_hot_remove_device(void *co
 	acpi_handle handle = device->handle;
 	int error;
 
+	device_remove_begin();
 	mutex_lock(&acpi_scan_lock);
 
 	error = acpi_scan_hot_remove(device);
@@ -458,6 +461,7 @@ void acpi_bus_hot_remove_device(void *co
 					  NULL);
 
 	mutex_unlock(&acpi_scan_lock);
+	device_remove_end();
 	kfree(context);
 }
 EXPORT_SYMBOL(acpi_bus_hot_remove_device);
@@ -510,7 +514,11 @@ acpi_eject_store(struct device *d, struc
 	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
 		return -ENODEV;
 
+	if (!read_lock_device_remove())
+		return -EBUSY;
+
 	mutex_lock(&acpi_scan_lock);
+	read_unlock_device_remove();
 
 	if (acpi_device->flags.eject_pending) {
 		/* ACPI eject notification event. */

