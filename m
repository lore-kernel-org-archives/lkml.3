Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418Ab3JPNNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:13:17 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51588 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934157Ab3JPNNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:13:15 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH] ACPI / power: Drop automaitc resume of power resource dependent devices
Date: Wed, 16 Oct 2013 15:25:05 +0200
Message-ID: <4814451.BPLed2xxbP@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The mechanism causing devices depending on a given power resource
(that is, devices that can be in D0 only if that power resource is
on) to be resumed automatically when the power resource is turned
on (and their "inferred" power state becomes D0 as a result) is
inherently racy and in fact unnecessary.

It is racy, because if the power resources is turned on and then
immediately off, the device resume triggered by the first transition
to "on" may still happen, causing the power resource to be turned
on again.  That again will trigger the "resume of dependent devices"
mechanism, but if the devices in question are not in use, they will
be suspended in the meantime causing the power resource to be turned
off.  However, the "resume of dependent devices" will next resume
them again and so on.  In some cases (USB port PM in particular) that
leads to an endless busy loop of flipping the resource on and off
continuously.

It is needless, because whoever turns a power resource on will most
likely turn it off at some point and the devices that go into "D0"
as a result of turning it on will then go back into D3cold.
Moreover, turning all power resources a device needs to go into
D0 is not sufficient for a full transition into D0 in general.
Namely, _PS0 may need to be executed in addition to that in some
cases.  This means that the whole rationale of the "resume of
dependent devices" mechanism was incorrect to begin with and it's
best to remove it entirely.

Reported-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/power.c |  100 ---------------------------------------------------
 1 file changed, 1 insertion(+), 99 deletions(-)

Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -59,16 +59,9 @@ ACPI_MODULE_NAME("power");
 #define ACPI_POWER_RESOURCE_STATE_ON	0x01
 #define ACPI_POWER_RESOURCE_STATE_UNKNOWN 0xFF
 
-struct acpi_power_dependent_device {
-	struct list_head node;
-	struct acpi_device *adev;
-	struct work_struct work;
-};
-
 struct acpi_power_resource {
 	struct acpi_device device;
 	struct list_head list_node;
-	struct list_head dependent;
 	char *name;
 	u32 system_level;
 	u32 order;
@@ -233,32 +226,6 @@ static int acpi_power_get_list_state(str
 	return 0;
 }
 
-static void acpi_power_resume_dependent(struct work_struct *work)
-{
-	struct acpi_power_dependent_device *dep;
-	struct acpi_device_physical_node *pn;
-	struct acpi_device *adev;
-	int state;
-
-	dep = container_of(work, struct acpi_power_dependent_device, work);
-	adev = dep->adev;
-	if (acpi_power_get_inferred_state(adev, &state))
-		return;
-
-	if (state > ACPI_STATE_D0)
-		return;
-
-	mutex_lock(&adev->physical_node_lock);
-
-	list_for_each_entry(pn, &adev->physical_node_list, node)
-		pm_request_resume(pn->dev);
-
-	list_for_each_entry(pn, &adev->power_dependent, node)
-		pm_request_resume(pn->dev);
-
-	mutex_unlock(&adev->physical_node_lock);
-}
-
 static int __acpi_power_on(struct acpi_power_resource *resource)
 {
 	acpi_status status = AE_OK;
@@ -283,14 +250,8 @@ static int acpi_power_on_unlocked(struct
 				  resource->name));
 	} else {
 		result = __acpi_power_on(resource);
-		if (result) {
+		if (result)
 			resource->ref_count--;
-		} else {
-			struct acpi_power_dependent_device *dep;
-
-			list_for_each_entry(dep, &resource->dependent, node)
-				schedule_work(&dep->work);
-		}
 	}
 	return result;
 }
@@ -390,52 +351,6 @@ static int acpi_power_on_list(struct lis
 	return result;
 }
 
-static void acpi_power_add_dependent(struct acpi_power_resource *resource,
-				     struct acpi_device *adev)
-{
-	struct acpi_power_dependent_device *dep;
-
-	mutex_lock(&resource->resource_lock);
-
-	list_for_each_entry(dep, &resource->dependent, node)
-		if (dep->adev == adev)
-			goto out;
-
-	dep = kzalloc(sizeof(*dep), GFP_KERNEL);
-	if (!dep)
-		goto out;
-
-	dep->adev = adev;
-	INIT_WORK(&dep->work, acpi_power_resume_dependent);
-	list_add_tail(&dep->node, &resource->dependent);
-
- out:
-	mutex_unlock(&resource->resource_lock);
-}
-
-static void acpi_power_remove_dependent(struct acpi_power_resource *resource,
-					struct acpi_device *adev)
-{
-	struct acpi_power_dependent_device *dep;
-	struct work_struct *work = NULL;
-
-	mutex_lock(&resource->resource_lock);
-
-	list_for_each_entry(dep, &resource->dependent, node)
-		if (dep->adev == adev) {
-			list_del(&dep->node);
-			work = &dep->work;
-			break;
-		}
-
-	mutex_unlock(&resource->resource_lock);
-
-	if (work) {
-		cancel_work_sync(work);
-		kfree(dep);
-	}
-}
-
 static struct attribute *attrs[] = {
 	NULL,
 };
@@ -524,8 +439,6 @@ static void acpi_power_expose_hide(struc
 
 void acpi_power_add_remove_device(struct acpi_device *adev, bool add)
 {
-	struct acpi_device_power_state *ps;
-	struct acpi_power_resource_entry *entry;
 	int state;
 
 	if (adev->wakeup.flags.valid)
@@ -535,16 +448,6 @@ void acpi_power_add_remove_device(struct
 	if (!adev->power.flags.power_resources)
 		return;
 
-	ps = &adev->power.states[ACPI_STATE_D0];
-	list_for_each_entry(entry, &ps->resources, node) {
-		struct acpi_power_resource *resource = entry->resource;
-
-		if (add)
-			acpi_power_add_dependent(resource, adev);
-		else
-			acpi_power_remove_dependent(resource, adev);
-	}
-
 	for (state = ACPI_STATE_D0; state <= ACPI_STATE_D3_HOT; state++)
 		acpi_power_expose_hide(adev,
 				       &adev->power.states[state].resources,
@@ -882,7 +785,6 @@ int acpi_add_power_resource(acpi_handle
 	acpi_init_device_object(device, handle, ACPI_BUS_TYPE_POWER,
 				ACPI_STA_DEFAULT);
 	mutex_init(&resource->resource_lock);
-	INIT_LIST_HEAD(&resource->dependent);
 	INIT_LIST_HEAD(&resource->list_node);
 	resource->name = device->pnp.bus_id;
 	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);

