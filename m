Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3LBT4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:56:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab3LBTSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 111/212] ACPI / hotplug: Fix conflicted PCI bridge notify handlers
Date: Mon,  2 Dec 2013 11:15:02 -0800
Message-Id: <20131202191259.627566364@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/pci_root.c |    3 +++
 drivers/acpi/scan.c     |    2 +-
 include/acpi/acpi_bus.h |    1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -63,6 +63,9 @@ static struct acpi_scan_handler pci_root
 	.ids = root_device_ids,
 	.attach = acpi_pci_root_add,
 	.detach = acpi_pci_root_remove,
+	.hotplug = {
+		.ignore = true,
+	},
 };
 
 static DEFINE_MUTEX(osc_lock);
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1812,7 +1812,7 @@ static void acpi_scan_init_hotplug(acpi_
 	 */
 	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
-		if (handler) {
+		if (handler && !handler->hotplug.ignore) {
 			acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					acpi_hotplug_notify_cb, handler);
 			break;
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -100,6 +100,7 @@ enum acpi_hotplug_mode {
 struct acpi_hotplug_profile {
 	struct kobject kobj;
 	bool enabled:1;
+	bool ignore:1;
 	enum acpi_hotplug_mode mode;
 };
 


