Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaKPMKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:10:13 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:44464 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaKPMKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:10:10 -0500
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
Subject: [PATCH] ACPI / WAKEUP : enable wakeup power for physical child devices
Date: Sun, 16 Nov 2014 15:10:01 +0300
Message-Id: <1416139801-6537-1-git-send-email-Andrej.Skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit f2b56bc808addb908a5bf435d9b942c02af9a7c4
("ACPI / PM: Use device wakeup flags for handling ACPI wakeup devices")
broke wake-on-lan for Broadcom BCM4401 Ethernet card (b44) on Dell Vostro 1500 laptop.
device_may_wakeup for main ACPI device (PCIE) returns false, because it has
can_wakeup = 0. Therefore any physical devices connected to this parent
were not prepared for wakeup/suspend. But physical device is capable to
wakeup the system.

To fix this issue device_may_wakeup was replaced with acpi_device_may_wakeup.
acpi_device_may_wakeup was written based on function
acpi_system_wakeup_device_seq_show

Signed-off-by: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
---
 drivers/acpi/wakeup.c |   45 +++++++++++++++++++++++++++++++++++++--------
 1 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/wakeup.c b/drivers/acpi/wakeup.c
index 1638401..0da7e70 100644
--- a/drivers/acpi/wakeup.c
+++ b/drivers/acpi/wakeup.c
@@ -19,6 +19,34 @@
 #define _COMPONENT		ACPI_SYSTEM_COMPONENT
 ACPI_MODULE_NAME("wakeup_devices")
 
+
+bool acpi_device_may_wakeup(struct acpi_device *dev)
+{
+	struct acpi_device_physical_node *entry;
+	bool may_wakeup = false;
+
+	mutex_lock(&dev->physical_node_lock);
+	if (!dev->physical_node_count)
+		may_wakeup = device_may_wakeup(&dev->dev);
+	else {
+		struct device *ldev;
+
+		list_for_each_entry(entry, &dev->physical_node_list, node) {
+			ldev = get_device(entry->dev);
+			if (!ldev)
+				continue;
+
+			may_wakeup = device_may_wakeup(&dev->dev) ||
+				device_may_wakeup(ldev);
+
+			put_device(ldev);
+		}
+	}
+
+	mutex_unlock(&dev->physical_node_lock);
+	return may_wakeup;
+}
+
 /**
  * acpi_enable_wakeup_devices - Enable wake-up device GPEs.
  * @sleep_state: ACPI system sleep state.
@@ -35,13 +63,14 @@ void acpi_enable_wakeup_devices(u8 sleep_state)
 		struct acpi_device *dev =
 			container_of(node, struct acpi_device, wakeup_list);
 
+
 		if (!dev->wakeup.flags.valid
-		    || sleep_state > (u32) dev->wakeup.sleep_state
-		    || !(device_may_wakeup(&dev->dev)
-		        || dev->wakeup.prepare_count))
+			|| sleep_state > (u32) dev->wakeup.sleep_state
+			|| !(acpi_device_may_wakeup(dev)
+			    || dev->wakeup.prepare_count))
 			continue;
 
-		if (device_may_wakeup(&dev->dev))
+		if (acpi_device_may_wakeup(dev))
 			acpi_enable_wakeup_device_power(dev, sleep_state);
 
 		/* The wake-up power should have been enabled already. */
@@ -63,15 +92,15 @@ void acpi_disable_wakeup_devices(u8 sleep_state)
 			container_of(node, struct acpi_device, wakeup_list);
 
 		if (!dev->wakeup.flags.valid
-		    || sleep_state > (u32) dev->wakeup.sleep_state
-		    || !(device_may_wakeup(&dev->dev)
-		        || dev->wakeup.prepare_count))
+			|| sleep_state > (u32) dev->wakeup.sleep_state
+			|| !(acpi_device_may_wakeup(dev)
+				|| dev->wakeup.prepare_count))
 			continue;
 
 		acpi_set_gpe_wake_mask(dev->wakeup.gpe_device, dev->wakeup.gpe_number,
 				ACPI_GPE_DISABLE);
 
-		if (device_may_wakeup(&dev->dev))
+		if (acpi_device_may_wakeup(dev))
 			acpi_disable_wakeup_device_power(dev);
 	}
 }
-- 
1.7.2.5

