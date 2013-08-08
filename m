Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966828Ab3HHWX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 18:23:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419Ab3HHWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 18:23:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 3/3] driver core: bus_type: add bus_groups
Date: Thu,  8 Aug 2013 15:22:57 -0700
Message-Id: <1376000577-29866-3-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1376000577-29866-1-git-send-email-gregkh@linuxfoundation.org>
References: <1376000577-29866-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

attribute groups are much more flexible than just a list of attributes,
due to their support for visibility of the attributes, and binary
attributes. Add bus_groups to struct bus_type which should be used
instead of bus_attrs.

bus_attrs will be removed from the structure soon.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/bus.c     | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  4 +++-
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index de5ce22d..5ee5d3c1 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -881,6 +881,37 @@ static void bus_remove_attrs(struct bus_type *bus)
 	}
 }
 
+static int bus_add_groups(struct bus_type *bus,
+			  const struct attribute_group **groups)
+{
+	int error = 0;
+	int i;
+
+	if (groups) {
+		for (i = 0; groups[i]; i++) {
+			error = sysfs_create_group(&bus->p->subsys.kobj,
+						   groups[i]);
+			if (error) {
+				while (--i >= 0)
+					sysfs_remove_group(&bus->p->subsys.kobj,
+							   groups[i]);
+				break;
+			}
+		}
+	}
+	return error;
+}
+
+static void bus_remove_groups(struct bus_type *bus,
+			      const struct attribute_group **groups)
+{
+	int i;
+
+	if (groups)
+		for (i = 0; groups[i]; i++)
+			sysfs_remove_group(&bus->p->subsys.kobj, groups[i]);
+}
+
 static void klist_devices_get(struct klist_node *n)
 {
 	struct device_private *dev_prv = to_device_private_bus(n);
@@ -973,10 +1004,15 @@ int bus_register(struct bus_type *bus)
 	retval = bus_add_attrs(bus);
 	if (retval)
 		goto bus_attrs_fail;
+	retval = bus_add_groups(bus, bus->bus_groups);
+	if (retval)
+		goto bus_groups_fail;
 
 	pr_debug("bus: '%s': registered\n", bus->name);
 	return 0;
 
+bus_groups_fail:
+	bus_remove_attrs(bus);
 bus_attrs_fail:
 	remove_probe_files(bus);
 bus_probe_files_fail:
@@ -1007,6 +1043,7 @@ void bus_unregister(struct bus_type *bus)
 	if (bus->dev_root)
 		device_unregister(bus->dev_root);
 	bus_remove_attrs(bus);
+	bus_remove_groups(bus, bus->bus_groups);
 	remove_probe_files(bus);
 	kset_unregister(bus->p->drivers_kset);
 	kset_unregister(bus->p->devices_kset);
diff --git a/include/linux/device.h b/include/linux/device.h
index 94d987f1..26e23b22 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -66,6 +66,7 @@ extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
  * @bus_attrs:	Default attributes of the bus.
  * @dev_attrs:	Default attributes of the devices on the bus.
  * @drv_attrs:	Default attributes of the device drivers on the bus.
+ * @bus_groups:	Default attributes of the bus.
  * @dev_groups:	Default attributes of the devices on the bus.
  * @drv_groups: Default attributes of the device drivers on the bus.
  * @match:	Called, perhaps multiple times, whenever a new device or driver
@@ -105,9 +106,10 @@ struct bus_type {
 	const char		*name;
 	const char		*dev_name;
 	struct device		*dev_root;
-	struct bus_attribute	*bus_attrs;
+	struct bus_attribute	*bus_attrs;	/* use bus_groups instead */
 	struct device_attribute	*dev_attrs;	/* use dev_groups instead */
 	struct driver_attribute	*drv_attrs;	/* use drv_groups instead */
+	const struct attribute_group **bus_groups;
 	const struct attribute_group **dev_groups;
 	const struct attribute_group **drv_groups;
 
-- 
1.8.3.rc0.20.gb99dd2e

