Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3AWR4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:56:21 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:52126 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab3AWR4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:56:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [Update][PATCH 5/5] ACPI / PM: Expose lists of device power resources to user space
Date: Wed, 23 Jan 2013 19:01:37 +0100
Message-ID: <2472424.tpzyPyItMj@vostro.rjw.lan>
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
new hardware platforms, it is necessary to allow user space (powertop
in particular) to look at the lists of power resources corresponding
to different power states of devices for diagnostics and control
purposes.

For this reason, for each power state of an ACPI device node using
power resources create a special attribute group under the device
node's directory in sysfs containing links to sysfs directories
representing the power resources in that list.  The names of the
new attribute groups are "power_resources_<state>", where <state>
is the state name i.e. "D0", "D1", "D2", or "D3hot".

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-power_resources_D0    |   13 +
 Documentation/ABI/testing/sysfs-devices-power_resources_D1    |   14 +
 Documentation/ABI/testing/sysfs-devices-power_resources_D2    |   14 +
 Documentation/ABI/testing/sysfs-devices-power_resources_D3hot |   14 +
 drivers/acpi/power.c                                          |  104 ++++++++--
 5 files changed, 146 insertions(+), 13 deletions(-)

Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -41,6 +41,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/sysfs.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include "sleep.h"
@@ -417,24 +418,101 @@ static void acpi_power_remove_dependent(
 	}
 }
 
-void acpi_power_add_remove_device(struct acpi_device *adev, bool add)
+static struct attribute *attrs[] = {
+	NULL,
+};
+
+static struct attribute_group attr_groups[] = {
+	[ACPI_STATE_D0] = {
+		.name = "power_resources_D0",
+		.attrs = attrs,
+	},
+	[ACPI_STATE_D1] = {
+		.name = "power_resources_D1",
+		.attrs = attrs,
+	},
+	[ACPI_STATE_D2] = {
+		.name = "power_resources_D2",
+		.attrs = attrs,
+	},
+	[ACPI_STATE_D3_HOT] = {
+		.name = "power_resources_D3hot",
+		.attrs = attrs,
+	},
+};
+
+static void acpi_power_hide_list(struct acpi_device *adev, int state)
+{
+	struct acpi_device_power_state *ps = &adev->power.states[state];
+	struct acpi_power_resource_entry *entry;
+
+	if (list_empty(&ps->resources))
+		return;
+
+	list_for_each_entry_reverse(entry, &ps->resources, node) {
+		struct acpi_device *res_dev = &entry->resource->device;
+
+		sysfs_remove_link_from_group(&adev->dev.kobj,
+					     attr_groups[state].name,
+					     dev_name(&res_dev->dev));
+	}
+	sysfs_remove_group(&adev->dev.kobj, &attr_groups[state]);
+}
+
+static void acpi_power_expose_list(struct acpi_device *adev, int state)
 {
-	if (adev->power.flags.power_resources) {
-		struct acpi_device_power_state *ps;
-		struct acpi_power_resource_entry *entry;
-
-		ps = &adev->power.states[ACPI_STATE_D0];
-		list_for_each_entry(entry, &ps->resources, node) {
-			struct acpi_power_resource *resource = entry->resource;
-
-			if (add)
-				acpi_power_add_dependent(resource, adev);
-			else
-				acpi_power_remove_dependent(resource, adev);
+	struct acpi_device_power_state *ps = &adev->power.states[state];
+	struct acpi_power_resource_entry *entry;
+	int ret;
+
+	if (list_empty(&ps->resources))
+		return;
+
+	ret = sysfs_create_group(&adev->dev.kobj, &attr_groups[state]);
+	if (ret)
+		return;
+
+	list_for_each_entry(entry, &ps->resources, node) {
+		struct acpi_device *res_dev = &entry->resource->device;
+
+		ret = sysfs_add_link_to_group(&adev->dev.kobj,
+					      attr_groups[state].name,
+					      &res_dev->dev.kobj,
+					      dev_name(&res_dev->dev));
+		if (ret) {
+			acpi_power_hide_list(adev, state);
+			break;
 		}
 	}
 }
 
+void acpi_power_add_remove_device(struct acpi_device *adev, bool add)
+{
+	struct acpi_device_power_state *ps;
+	struct acpi_power_resource_entry *entry;
+	int state;
+
+	if (!adev->power.flags.power_resources)
+		return;
+
+	ps = &adev->power.states[ACPI_STATE_D0];
+	list_for_each_entry(entry, &ps->resources, node) {
+		struct acpi_power_resource *resource = entry->resource;
+
+		if (add)
+			acpi_power_add_dependent(resource, adev);
+		else
+			acpi_power_remove_dependent(resource, adev);
+	}
+
+	for (state = ACPI_STATE_D0; state <= ACPI_STATE_D3_HOT; state++) {
+		if (add)
+			acpi_power_expose_list(adev, state);
+		else
+			acpi_power_hide_list(adev, state);
+	}
+}
+
 int acpi_power_min_system_level(struct list_head *list)
 {
 	struct acpi_power_resource_entry *entry;
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-power_resources_D0
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-power_resources_D0
@@ -0,0 +1,13 @@
+What:		/sys/devices/.../power_resources_D0/
+Date:		January 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../power_resources_D0/ directory is only
+		present for device objects representing ACPI device nodes that
+		use ACPI power resources for power management.
+
+		If present, it contains symbolic links to device directories
+		representing ACPI power resources that need to be turned on for
+		the given device node to be in ACPI power state D0.  The names
+		of the links are the same as the names of the directories they
+		point to.
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-power_resources_D1
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-power_resources_D1
@@ -0,0 +1,14 @@
+What:		/sys/devices/.../power_resources_D1/
+Date:		January 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../power_resources_D1/ directory is only
+		present for device objects representing ACPI device nodes that
+		use ACPI power resources for power management and support ACPI
+		power state D1.
+
+		If present, it contains symbolic links to device directories
+		representing ACPI power resources that need to be turned on for
+		the given device node to be in ACPI power state D1.  The names
+		of the links are the same as the names of the directories they
+		point to.
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-power_resources_D2
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-power_resources_D2
@@ -0,0 +1,14 @@
+What:		/sys/devices/.../power_resources_D2/
+Date:		January 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../power_resources_D2/ directory is only
+		present for device objects representing ACPI device nodes that
+		use ACPI power resources for power management and support ACPI
+		power state D2.
+
+		If present, it contains symbolic links to device directories
+		representing ACPI power resources that need to be turned on for
+		the given device node to be in ACPI power state D2.  The names
+		of the links are the same as the names of the directories they
+		point to.
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-power_resources_D3hot
===================================================================
--- /dev/null
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-power_resources_D3hot
@@ -0,0 +1,14 @@
+What:		/sys/devices/.../power_resources_D3hot/
+Date:		January 2013
+Contact:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
+Description:
+		The /sys/devices/.../power_resources_D3hot/ directory is only
+		present for device objects representing ACPI device nodes that
+		use ACPI power resources for power management and support ACPI
+		power state D3hot.
+
+		If present, it contains symbolic links to device directories
+		representing ACPI power resources that need to be turned on for
+		the given device node to be in ACPI power state D3hot.  The
+		names of the links are the same as the names of the directories
+		they point to.

