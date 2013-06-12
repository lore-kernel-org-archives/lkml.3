Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab3FLXTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:19:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35469 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab3FLXS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:18:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 4/5] ACPI / scan: Use container hotplug profile for matching device objects
Date: Thu, 13 Jun 2013 01:26:08 +0200
Message-ID: <2271890.fO4Egl60hq@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1417592.vuSG0cUIGo@vostro.rjw.lan>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

On some systems (ia64 HP rx2600 in particular) the ACPI namespace
contains device objects with container compatibility IDs in addition
to some other hardware IDs.  This means that those devices are
containers and if an ACPI scan handler without a hotplug profile is
attached to one of them, the container hotplug profile should be used
for that device.

Moreover, the container hotplug profile should be used for handling
bus check and device check notifications targeted at device handles
with matching scan handlers that don't provide hotplug profiles.

Modify the ACPI namespace scan code to ensure that the above will
happen.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1855,11 +1855,26 @@ void acpi_scan_hotplug_enabled(struct ac
 	mutex_unlock(&acpi_scan_lock);
 }
 
+static struct acpi_hotplug_profile *acpi_container_hotplug(
+						struct acpi_device_pnp *pnp)
+{
+	if (acpi_container_scan_handler()) {
+		struct acpi_scan_handler *handler;
+		struct acpi_hardware_id *hwid;
+
+		handler = acpi_container_scan_handler();
+		list_for_each_entry(hwid, &pnp->ids, list)
+			if (acpi_scan_handler_matching(handler, hwid->id, NULL))
+				return handler->hotplug;
+	}
+	return NULL;
+}
+
 static void acpi_scan_init_hotplug(acpi_handle handle, int type)
 {
 	struct acpi_device_pnp pnp = {};
 	struct acpi_hardware_id *hwid;
-	struct acpi_scan_handler *handler;
+	struct acpi_hotplug_profile *hotplug = NULL;
 
 	INIT_LIST_HEAD(&pnp.ids);
 	acpi_set_pnp_ids(handle, &pnp, type);
@@ -1872,14 +1887,20 @@ static void acpi_scan_init_hotplug(acpi_
 	 * install the same notify handler routine twice for the same handle.
 	 */
 	list_for_each_entry(hwid, &pnp.ids, list) {
+		struct acpi_scan_handler *handler;
+
 		handler = acpi_scan_match_handler(hwid->id, NULL);
 		if (handler && handler->hotplug) {
-			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-						    acpi_hotplug_notify_cb,
-						    handler->hotplug);
+			hotplug = handler->hotplug;
 			break;
 		}
 	}
+	if (!hotplug)
+		hotplug = acpi_container_hotplug(&pnp);
+
+	if (hotplug)
+		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					    acpi_hotplug_notify_cb, hotplug);
 
 out:
 	acpi_free_pnp_ids(&pnp);
@@ -1948,7 +1969,9 @@ static int acpi_scan_attach_handler(stru
 			ret = handler->attach(device, devid);
 			if (ret > 0) {
 				device->handler = handler;
-				device->hotplug = handler->hotplug;
+				device->hotplug = handler->hotplug ?
+					handler->hotplug :
+					acpi_container_hotplug(&device->pnp);
 				break;
 			} else if (ret < 0) {
 				break;

