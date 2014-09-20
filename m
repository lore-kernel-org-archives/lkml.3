Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaITWWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 18:22:34 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:61601 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaITWWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 18:22:32 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] eeepc-laptop: clean up control flow in *_rfkill_notifier
Date: Sun, 21 Sep 2014 00:22:17 +0200
Message-Id: <1411251737-16072-1-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle errors immediately in eeepc_register_rfkill_notifier and
eeepc_unregister_rfkill_notifier. This clears up the control flow for the
reader. It also removes unnecessary indentation.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
This depends on the earlier eeepc cleanup series [1] to apply cleanly.

[1] https://lkml.org/lkml/2014/9/17/654

 drivers/platform/x86/eeepc-laptop.c | 57 ++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 3f6c762..db79902 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -668,23 +668,21 @@ static int eeepc_register_rfkill_notifier(struct eeepc_laptop *eeepc,
 
 	status = acpi_get_handle(NULL, node, &handle);
 
-	if (ACPI_SUCCESS(status)) {
-		status = acpi_install_notify_handler(handle,
-						     ACPI_SYSTEM_NOTIFY,
-						     eeepc_rfkill_notify,
-						     eeepc);
-		if (ACPI_FAILURE(status))
-			pr_warn("Failed to register notify on %s\n", node);
-
-		/*
-		 * Refresh pci hotplug in case the rfkill state was
-		 * changed during setup.
-		 */
-		eeepc_rfkill_hotplug(eeepc, handle);
-	} else {
+	if (ACPI_FAILURE(status))
 		return -ENODEV;
-	}
 
+	status = acpi_install_notify_handler(handle,
+					     ACPI_SYSTEM_NOTIFY,
+					     eeepc_rfkill_notify,
+					     eeepc);
+	if (ACPI_FAILURE(status))
+		pr_warn("Failed to register notify on %s\n", node);
+
+	/*
+	 * Refresh pci hotplug in case the rfkill state was
+	 * changed during setup.
+	 */
+	eeepc_rfkill_hotplug(eeepc, handle);
 	return 0;
 }
 
@@ -696,20 +694,21 @@ static void eeepc_unregister_rfkill_notifier(struct eeepc_laptop *eeepc,
 
 	status = acpi_get_handle(NULL, node, &handle);
 
-	if (ACPI_SUCCESS(status)) {
-		status = acpi_remove_notify_handler(handle,
-						     ACPI_SYSTEM_NOTIFY,
-						     eeepc_rfkill_notify);
-		if (ACPI_FAILURE(status))
-			pr_err("Error removing rfkill notify handler %s\n",
-				node);
-			/*
-			 * Refresh pci hotplug in case the rfkill
-			 * state was changed after
-			 * eeepc_unregister_rfkill_notifier()
-			 */
-		eeepc_rfkill_hotplug(eeepc, handle);
-	}
+	if (ACPI_FAILURE(status))
+		return;
+
+	status = acpi_remove_notify_handler(handle,
+					     ACPI_SYSTEM_NOTIFY,
+					     eeepc_rfkill_notify);
+	if (ACPI_FAILURE(status))
+		pr_err("Error removing rfkill notify handler %s\n",
+			node);
+		/*
+		 * Refresh pci hotplug in case the rfkill
+		 * state was changed after
+		 * eeepc_unregister_rfkill_notifier()
+		 */
+	eeepc_rfkill_hotplug(eeepc, handle);
 }
 
 static int eeepc_get_adapter_status(struct hotplug_slot *hotplug_slot,
-- 
2.1.0

