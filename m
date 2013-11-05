Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3KEXPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:15:13 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53631 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755563Ab3KEXPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:15:08 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [fixup][PATCH 2/6] ACPI / hotplug: Refuse to hot-remove all objects with disabled hotplug
Date: Wed, 06 Nov 2013 00:27:26 +0100
Message-ID: <5195965.AgE9G8aXP3@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1842331.UHR0XPv1jo@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <2970389.SeMGM45Qln@vostro.rjw.lan> <1842331.UHR0XPv1jo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

In theory, an ACPI device object may be the parent of another
device object whose hotplug is disabled by user space through its
scan handler.  In that case, the eject operation targeting the
parent should fail as though the parent's own hotplug was disabled,
but currently this is not the case, because acpi_scan_hot_remove()
doesn't check the disable/enable hotplug status of the children
of the top-most object passed to it.

To fix this, modify acpi_bus_offline_companions() to return an
error code if hotplug is disabled for the given device object.
[Also change the name of the function to acpi_bus_offline(),
because it is not only about companions any more, and change
the name of acpi_bus_online_companions() accordingly.]  Make
acpi_scan_hot_remove() propagate that error to its callers.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

acpi_force_hot_remove has to be honored by the new code.

Thanks,
Rafael

---
 drivers/acpi/scan.c |   58 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 21 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -125,8 +125,8 @@ acpi_device_modalias_show(struct device
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
-static acpi_status acpi_bus_offline_companions(acpi_handle handle, u32 lvl,
-					       void *data, void **ret_p)
+static acpi_status acpi_bus_offline(acpi_handle handle, u32 lvl, void *data,
+				    void **ret_p)
 {
 	struct acpi_device *device = NULL;
 	struct acpi_device_physical_node *pn;
@@ -136,6 +136,12 @@ static acpi_status acpi_bus_offline_comp
 	if (acpi_bus_get_device(handle, &device))
 		return AE_OK;
 
+	if (device->handler && !device->handler->hotplug.enabled
+	    && !acpi_force_hot_remove) {
+		*ret_p = &device->dev;
+		return AE_SUPPORT;
+	}
+
 	mutex_lock(&device->physical_node_lock);
 
 	list_for_each_entry(pn, &device->physical_node_list, node) {
@@ -168,8 +174,8 @@ static acpi_status acpi_bus_offline_comp
 	return status;
 }
 
-static acpi_status acpi_bus_online_companions(acpi_handle handle, u32 lvl,
-					      void *data, void **ret_p)
+static acpi_status acpi_bus_online(acpi_handle handle, u32 lvl, void *data,
+				   void **ret_p)
 {
 	struct acpi_device *device = NULL;
 	struct acpi_device_physical_node *pn;
@@ -214,26 +220,32 @@ static int acpi_scan_hot_remove(struct a
 	 * If the first pass is successful, the second one isn't needed, though.
 	 */
 	errdev = NULL;
-	acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-			    NULL, acpi_bus_offline_companions,
-			    (void *)false, (void **)&errdev);
-	acpi_bus_offline_companions(handle, 0, (void *)false, (void **)&errdev);
+	status = acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				     NULL, acpi_bus_offline, (void *)false,
+				     (void **)&errdev);
+	if (status == AE_SUPPORT) {
+		dev_warn(errdev, "Offline disabled.\n");
+		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				    acpi_bus_online, NULL, NULL, NULL);
+		put_device(&device->dev);
+		return -EPERM;
+	}
+	acpi_bus_offline(handle, 0, (void *)false, (void **)&errdev);
 	if (errdev) {
 		errdev = NULL;
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-				    NULL, acpi_bus_offline_companions,
-				    (void *)true , (void **)&errdev);
+				    NULL, acpi_bus_offline, (void *)true,
+				    (void **)&errdev);
 		if (!errdev || acpi_force_hot_remove)
-			acpi_bus_offline_companions(handle, 0, (void *)true,
-						    (void **)&errdev);
+			acpi_bus_offline(handle, 0, (void *)true,
+					 (void **)&errdev);
 
 		if (errdev && !acpi_force_hot_remove) {
 			dev_warn(errdev, "Offline failed.\n");
-			acpi_bus_online_companions(handle, 0, NULL, NULL);
+			acpi_bus_online(handle, 0, NULL, NULL);
 			acpi_walk_namespace(ACPI_TYPE_ANY, handle,
-					    ACPI_UINT32_MAX,
-					    acpi_bus_online_companions, NULL,
-					    NULL, NULL);
+					    ACPI_UINT32_MAX, acpi_bus_online,
+					    NULL, NULL, NULL);
 			put_device(&device->dev);
 			return -EBUSY;
 		}
@@ -290,10 +302,9 @@ static void acpi_bus_device_eject(void *
 		goto err_out;
 
 	handler = device->handler;
-	if (!handler || !handler->hotplug.enabled) {
-		ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
-		goto err_out;
-	}
+	if (!handler || !handler->hotplug.enabled)
+		goto err_support;
+
 	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
 				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 	if (handler->hotplug.mode == AHM_CONTAINER)
@@ -301,14 +312,19 @@ static void acpi_bus_device_eject(void *
 
 	get_device(&device->dev);
 	error = acpi_scan_hot_remove(device);
-	if (error)
+	if (error == -EPERM) {
+		goto err_support;
+	} else if (error) {
 		goto err_out;
+	}
 
  out:
 	mutex_unlock(&acpi_scan_lock);
 	unlock_device_hotplug();
 	return;
 
+ err_support:
+	ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
  err_out:
 	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST, ost_code,
 				  NULL);

