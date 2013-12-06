Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858Ab3LFOSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:18:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43655 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161140Ab3LFNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 029/272] ACPI / hotplug: Fix conflicted PCI bridge notify handlers
Date: Fri,  6 Dec 2013 12:55:18 +0000
Message-Id: <1386334761-25517-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshi Kani <toshi.kani@hp.com>

commit ca499fc87ed945094d952da0eb7eea7dbeb1feec upstream.

The PCI host bridge scan handler installs its own notify handler,
handle_hotplug_event_root(), by itself.  Nevertheless, the ACPI
hotplug framework also installs the common notify handler,
acpi_hotplug_notify_cb(), for PCI root bridges.  This causes
acpi_hotplug_notify_cb() to call _OST method with unsupported
error as hotplug.enabled is not set.

To address this issue, introduce hotplug.ignore flag, which
indicates that the scan handler installs its own notify handler by
itself.  The ACPI hotplug framework does not install the common
notify handler when this flag is set.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
[rjw: Changed the name of the new flag]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/pci_root.c | 3 +++
 drivers/acpi/scan.c     | 2 +-
 include/acpi/acpi_bus.h | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 7dbe92c..fa2881b 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -63,6 +63,9 @@ static struct acpi_scan_handler pci_root_handler = {
 	.ids = root_device_ids,
 	.attach = acpi_pci_root_add,
 	.detach = acpi_pci_root_remove,
+	.hotplug = {
+		.ignore = true,
+	},
 };
 
 static DEFINE_MUTEX(osc_lock);
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 0ebb955..2487853 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1881,7 +1881,7 @@ static void acpi_scan_init_hotplug(acpi_handle handle, int type)
 	 */
 	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
-		if (handler) {
+		if (handler && !handler->hotplug.ignore) {
 			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					acpi_hotplug_notify_cb, handler);
 			break;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 94383a7..fea538b 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -90,6 +90,7 @@ enum acpi_hotplug_mode {
 struct acpi_hotplug_profile {
 	struct kobject kobj;
 	bool enabled:1;
+	bool ignore:1;
 	enum acpi_hotplug_mode mode;
 };
 
-- 
1.8.3.2

