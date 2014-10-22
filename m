Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbaJVTPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:15:50 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58656 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaJVTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:22 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] eeepc-laptop: flatten control flow
Date: Wed, 22 Oct 2014 21:12:36 +0200
Message-Id: <1414005163-3461-2-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In eeepc_rfkill_hotplug there's an if statement with a big tail that
ends right before the out_unlock label. We might as well invert the
condition and jump to out_unlock in that case, pretty much like the rest
of the code does. This removes an indentation level for a large chunk of
code and also stops suggesting there might be an else clause.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 89 +++++++++++++++++++------------------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index db79902..bb098e5 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -580,59 +580,60 @@ static void eeepc_rfkill_hotplug(struct eeepc_laptop *eeepc, acpi_handle handle)
 	mutex_lock(&eeepc->hotplug_lock);
 	pci_lock_rescan_remove();
 
-	if (eeepc->hotplug_slot) {
-		port = acpi_get_pci_dev(handle);
-		if (!port) {
-			pr_warning("Unable to find port\n");
-			goto out_unlock;
-		}
+	if (!eeepc->hotplug_slot)
+		goto out_unlock;
 
-		bus = port->subordinate;
+	port = acpi_get_pci_dev(handle);
+	if (!port) {
+		pr_warning("Unable to find port\n");
+		goto out_unlock;
+	}
 
-		if (!bus) {
-			pr_warn("Unable to find PCI bus 1?\n");
-			goto out_put_dev;
-		}
+	bus = port->subordinate;
 
-		if (pci_bus_read_config_dword(bus, 0, PCI_VENDOR_ID, &l)) {
-			pr_err("Unable to read PCI config space?\n");
-			goto out_put_dev;
-		}
+	if (!bus) {
+		pr_warn("Unable to find PCI bus 1?\n");
+		goto out_put_dev;
+	}
+
+	if (pci_bus_read_config_dword(bus, 0, PCI_VENDOR_ID, &l)) {
+		pr_err("Unable to read PCI config space?\n");
+		goto out_put_dev;
+	}
 
-		absent = (l == 0xffffffff);
+	absent = (l == 0xffffffff);
 
-		if (blocked != absent) {
-			pr_warn("BIOS says wireless lan is %s, "
-				"but the pci device is %s\n",
-				blocked ? "blocked" : "unblocked",
-				absent ? "absent" : "present");
-			pr_warn("skipped wireless hotplug as probably "
-				"inappropriate for this model\n");
+	if (blocked != absent) {
+		pr_warn("BIOS says wireless lan is %s, "
+			"but the pci device is %s\n",
+			blocked ? "blocked" : "unblocked",
+			absent ? "absent" : "present");
+		pr_warn("skipped wireless hotplug as probably "
+			"inappropriate for this model\n");
+		goto out_put_dev;
+	}
+
+	if (!blocked) {
+		dev = pci_get_slot(bus, 0);
+		if (dev) {
+			/* Device already present */
+			pci_dev_put(dev);
 			goto out_put_dev;
 		}
-
-		if (!blocked) {
-			dev = pci_get_slot(bus, 0);
-			if (dev) {
-				/* Device already present */
-				pci_dev_put(dev);
-				goto out_put_dev;
-			}
-			dev = pci_scan_single_device(bus, 0);
-			if (dev) {
-				pci_bus_assign_resources(bus);
-				pci_bus_add_device(dev);
-			}
-		} else {
-			dev = pci_get_slot(bus, 0);
-			if (dev) {
-				pci_stop_and_remove_bus_device(dev);
-				pci_dev_put(dev);
-			}
+		dev = pci_scan_single_device(bus, 0);
+		if (dev) {
+			pci_bus_assign_resources(bus);
+			pci_bus_add_device(dev);
+		}
+	} else {
+		dev = pci_get_slot(bus, 0);
+		if (dev) {
+			pci_stop_and_remove_bus_device(dev);
+			pci_dev_put(dev);
 		}
-out_put_dev:
-		pci_dev_put(port);
 	}
+out_put_dev:
+	pci_dev_put(port);
 
 out_unlock:
 	pci_unlock_rescan_remove();
-- 
2.1.0

