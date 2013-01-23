Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3AWR5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:57:33 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:52136 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3AWR4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:56:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [Update][PATCH 3/5] ACPI / PM: Expose current status of ACPI power resources
Date: Wed, 23 Jan 2013 19:00:10 +0100
Message-ID: <1551140.LKaQ2sxfTJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1551140.kO91IOVbjI@vostro.rjw.lan>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <2760421.6nE3tkh92K@vostro.rjw.lan> <1551140.kO91IOVbjI@vostro.rjw.lan>
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

For this reason, expose the current status of each ACPI power
resource to user space via sysfs by adding a new resource_in_use
attribute to the sysfs directory representing the given power
resource.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/ABI/testing/sysfs-devices-resource_in_use |   12 +++++++
 drivers/acpi/power.c                                    |   26 +++++++++++++++-
 drivers/acpi/scan.c                                     |    3 +
 include/acpi/acpi_bus.h                                 |    1 
 4 files changed, 41 insertions(+), 1 deletion(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -278,6 +278,7 @@ struct acpi_device {
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
@@ -790,6 +790,9 @@ static void acpi_device_unregister(struc
 
 	acpi_power_add_remove_device(device, false);
 	acpi_device_remove_files(device);
+	if (device->remove)
+		device->remove(device);
+
 	device_del(&device->dev);
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
@@ -676,6 +682,21 @@ static void acpi_release_power_resource(
 	kfree(resource);
 }
 
+static ssize_t acpi_power_in_use_show(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf) {
+	struct acpi_power_resource *resource;
+
+	resource = to_power_resource(to_acpi_device(dev));
+	return sprintf(buf, "%u\n", !!resource->ref_count);
+}
+static DEVICE_ATTR(resource_in_use, 0444, acpi_power_in_use_show, NULL);
+
+static void acpi_power_sysfs_remove(struct acpi_device *device)
+{
+	device_remove_file(&device->dev, &dev_attr_resource_in_use);
+}
+
 int acpi_add_power_resource(acpi_handle handle)
 {
 	struct acpi_power_resource *resource;
@@ -723,6 +744,9 @@ int acpi_add_power_resource(acpi_handle
 	if (result)
 		goto err;
 
+	if (!device_create_file(&device->dev, &dev_attr_resource_in_use))
+		device->remove = acpi_power_sysfs_remove;
+
 	mutex_lock(&power_resource_list_lock);
 	list_add(&resource->list_node, &acpi_power_resource_list);
 	mutex_unlock(&power_resource_list_lock);
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-resource_in_use
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-resource_in_use
@@ -0,0 +1,12 @@
+What:		/sys/devices/.../resource_in_use
+Date:		January 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../resource_in_use attribute is only present
+		for device objects representing ACPI power resources.
+
+		If present, it contains a number (0 or 1) representing the
+		current status of the given power resource (0 means that the
+		resource is not in use and therefore it has been turned off).
+
+		This attribute is read-only.

