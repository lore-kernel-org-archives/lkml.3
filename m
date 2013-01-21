Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3AUAsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 19:48:10 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47927 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab3AUAsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 19:48:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [RFC][Update][PATCH 1/3] ACPI / PM: Expose reference count values of ACPI power resources
Date: Mon, 21 Jan 2013 01:50:23 +0100
Message-ID: <1472223.8t75QKOqIW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2096792.ELJ8WGVaaz@vostro.rjw.lan>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <2096792.ELJ8WGVaaz@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since ACPI power resources are going to be used more extensively on
new hardware platforms, it becomes necessary for user space (powertop
in particular) to observe some properties of those resources for
diagnostics purposes.

For this reason, export the reference counts of ACPI power resources
to user space by adding a new reference_count attribute to the sysfs
directory representing each power resource.  The value read from
that attribute represents the number of devices using the power
resource at the given time.  If that value is 0, it meas that the
power resource is not used and therefore it has been turned off.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-reference_count |   13 ++++++++
 drivers/acpi/power.c                                    |   26 +++++++++++++++-
 drivers/acpi/scan.c                                     |    3 +
 include/acpi/acpi_bus.h                                 |    1 
 4 files changed, 42 insertions(+), 1 deletion(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -280,6 +280,7 @@ struct acpi_device {
 	struct mutex physical_node_lock;
 	DECLARE_BITMAP(physical_node_id_bitmap, ACPI_MAX_PHYSICAL_NODE);
 	struct list_head power_dependent;
+	void (*remove)(struct acpi_device *);
 };
 
 static inline void *acpi_driver_data(struct acpi_device *d)
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -767,6 +767,9 @@ static void acpi_device_unregister(struc
 
 	acpi_power_add_remove_device(device, false);
 	acpi_device_remove_files(device);
+	if (device->remove)
+		device->remove(device);
+
 	device_unregister(&device->dev);
 	/*
 	 * Drop the reference counts of all power resources the device depends
Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -87,6 +87,12 @@ static DEFINE_MUTEX(power_resource_list_
                              Power Resource Management
    -------------------------------------------------------------------------- */
 
+static inline
+struct acpi_power_resource *to_power_resource(struct acpi_device *device)
+{
+	return container_of(device, struct acpi_power_resource, device);
+}
+
 static struct acpi_power_resource *acpi_power_get_context(acpi_handle handle)
 {
 	struct acpi_device *device;
@@ -94,7 +100,7 @@ static struct acpi_power_resource *acpi_
 	if (acpi_bus_get_device(handle, &device))
 		return NULL;
 
-	return container_of(device, struct acpi_power_resource, device);
+	return to_power_resource(device);
 }
 
 static int acpi_power_resources_list_add(acpi_handle handle,
@@ -679,6 +685,21 @@ static void acpi_release_power_resource(
 	kfree(resource);
 }
 
+static ssize_t acpi_power_refcount_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf) {
+	struct acpi_power_resource *resource;
+
+	resource = to_power_resource(to_acpi_device(dev));
+	return sprintf(buf, "%u\n", resource->ref_count);
+}
+static DEVICE_ATTR(reference_count, 0444, acpi_power_refcount_show, NULL);
+
+static void acpi_power_sysfs_remove(struct acpi_device *device)
+{
+	device_remove_file(&device->dev, &dev_attr_reference_count);
+}
+
 int acpi_add_power_resource(acpi_handle handle)
 {
 	struct acpi_power_resource *resource;
@@ -726,6 +747,9 @@ int acpi_add_power_resource(acpi_handle
 	if (result)
 		goto err;
 
+	if (!device_create_file(&device->dev, &dev_attr_reference_count))
+		device->remove = acpi_power_sysfs_remove;
+
 	mutex_lock(&power_resource_list_lock);
 	list_add(&resource->list_node, &acpi_power_resource_list);
 	mutex_unlock(&power_resource_list_lock);
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-reference_count
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-reference_count
@@ -0,0 +1,13 @@
+What:		/sys/devices/.../reference_count
+Date:		January 2012
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../reference_count attribute allows user
+		space to retrieve the current number of devices using the ACPI
+		power resource represented by the given device object (whose
+		directory contains that attribute).  If the read value is 0,
+		the power resource is currently not in use and therefore it
+		has been turned off.
+
+		This attribute is read-only.  It only is present for device
+		objects representing ACPI power resources.

