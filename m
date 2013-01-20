Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3ATOvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 09:51:41 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47586 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab3ATOvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 09:51:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: [RFC][PATCH 3/3] ACPI / PM: Expose lists of device power resources to user space
Date: Sun, 20 Jan 2013 15:57:07 +0100
Message-ID: <1722361.KAHhXWlusd@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3307415.pdOY6ovZLa@vostro.rjw.lan>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
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
 drivers/acpi/power.c |   96 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 83 insertions(+), 13 deletions(-)

Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -417,24 +417,94 @@ static void acpi_power_remove_dependent(
 	}
 }
 
-void acpi_power_add_remove_device(struct acpi_device *adev, bool add)
+static struct attribute *attrs[] = {
+	NULL,
+};
+
+static void acpi_power_hide_list(struct acpi_device *adev,
+				 struct acpi_device_power_state *ps,
+				 const char *group_name)
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
+	struct attribute_group attr_group = {
+		.name	= group_name,
+		.attrs	= attrs,
+	};
+	struct acpi_power_resource_entry *entry;
+
+	list_for_each_entry_reverse(entry, &ps->resources, node) {
+		struct acpi_device *res_dev = &entry->resource->device;
+
+		sysfs_remove_link_from_group(&adev->dev.kobj, group_name,
+					     dev_name(&res_dev->dev));
+	}
+	sysfs_remove_group(&adev->dev.kobj, &attr_group);
+}
+
+static void acpi_power_expose_list(struct acpi_device *adev,
+				   struct acpi_device_power_state *ps,
+				   const char *group_name)
+{
+	struct attribute_group attr_group = {
+		.name	= group_name,
+		.attrs	= attrs,
+	};
+	struct acpi_power_resource_entry *entry;
+	int ret;
+
+	ret = sysfs_create_group(&adev->dev.kobj, &attr_group);
+	if (ret)
+		return;
+
+	list_for_each_entry(entry, &ps->resources, node) {
+		struct acpi_device *res_dev = &entry->resource->device;
+
+		ret = sysfs_add_link_to_group(&adev->dev.kobj, group_name,
+					      &res_dev->dev.kobj,
+					      dev_name(&res_dev->dev));
+		if (ret) {
+			acpi_power_hide_list(adev, ps, group_name);
+			break;
 		}
 	}
 }
 
+void acpi_power_add_remove_device(struct acpi_device *adev, bool add)
+{
+	static const char *group_names[ACPI_D_STATE_COUNT] = {
+		[ACPI_STATE_D0] = "power_resources_D0",
+		[ACPI_STATE_D1] = "power_resources_D1",
+		[ACPI_STATE_D2] = "power_resources_D2",
+		[ACPI_STATE_D3_HOT] = "power_resources_D3hot",
+	};
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
+		ps = &adev->power.states[state];
+		if (list_empty(&ps->resources))
+			continue;
+
+		if (add)
+			acpi_power_expose_list(adev, ps, group_names[state]);
+		else
+			acpi_power_hide_list(adev, ps, group_names[state]);
+	}
+}
+
 int acpi_power_min_system_level(struct list_head *list)
 {
 	struct acpi_power_resource_entry *entry;

