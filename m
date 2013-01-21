Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3AUVVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:21:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19873 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab3AUVVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:21:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v10 09/11] PCI, acpiphp: Don't bailout even no slots found yet.
Date: Mon, 21 Jan 2013 13:20:50 -0800
Message-Id: <1358803252-20639-10-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
References: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could have root bus hot added later and there may be slots that need acpiphp.

The result returned by acpiphp_get_num_slots() is meaningless, because
the bridge the slots are under may be added after this function has been
called, so drop acpiphp_get_num_slots() and the code using it.

-v2: add changelog about why we could get rid of acpiphp_get_name_slots()
     from Rafael.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    1 -
 drivers/pci/hotplug/acpiphp_core.c |   23 ++---------------------
 drivers/pci/hotplug/acpiphp_glue.c |   22 ----------------------
 3 files changed, 2 insertions(+), 44 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index a1afb5b..b3ead7a 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -193,7 +193,6 @@ extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
 /* acpiphp_glue.c */
 extern int acpiphp_glue_init (void);
 extern void acpiphp_glue_exit (void);
-extern int acpiphp_get_num_slots (void);
 typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
 
 extern int acpiphp_enable_slot (struct acpiphp_slot *slot);
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 96316b7..c2fd309 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -50,7 +50,6 @@
 bool acpiphp_debug;
 
 /* local variables */
-static int num_slots;
 static struct acpiphp_attention_info *attention_info;
 
 #define DRIVER_VERSION	"0.5"
@@ -272,25 +271,6 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	return 0;
 }
 
-static int __init init_acpi(void)
-{
-	int retval;
-
-	/* initialize internal data structure etc. */
-	retval = acpiphp_glue_init();
-
-	/* read initial number of slots */
-	if (!retval) {
-		num_slots = acpiphp_get_num_slots();
-		if (num_slots == 0) {
-			acpiphp_glue_exit();
-			retval = -ENODEV;
-		}
-	}
-
-	return retval;
-}
-
 /**
  * release_slot - free up the memory used by a slot
  * @hotplug_slot: slot to free
@@ -379,7 +359,8 @@ static int __init acpiphp_init(void)
 		return 0;
 
 	/* read all the ACPI info from the system */
-	return init_acpi();
+	/* initialize internal data structure etc. */
+	return acpiphp_glue_init();
 }
 
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index c4a6301..bd784ff 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1416,28 +1416,6 @@ void  acpiphp_glue_exit(void)
 	acpi_pci_unregister_driver(&acpi_pci_hp_driver);
 }
 
-
-/**
- * acpiphp_get_num_slots - count number of slots in a system
- */
-int __init acpiphp_get_num_slots(void)
-{
-	struct acpiphp_bridge *bridge;
-	int num_slots = 0;
-
-	list_for_each_entry(bridge, &bridge_list, list) {
-		dbg("Bus %04x:%02x has %d slot%s\n",
-				pci_domain_nr(bridge->pci_bus),
-				bridge->pci_bus->number, bridge->nr_slots,
-				bridge->nr_slots == 1 ? "" : "s");
-		num_slots += bridge->nr_slots;
-	}
-
-	dbg("Total %d slots\n", num_slots);
-	return num_slots;
-}
-
-
 /**
  * acpiphp_enable_slot - power on slot
  * @slot: ACPI PHP slot
-- 
1.7.10.4

