Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbaF1RwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:52:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54222 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaF1RwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.15 069/139] ACPI / hotplug / PCI: Add hotplug contexts to PCI host bridges
Date: Sat, 28 Jun 2014 10:47:10 -0700
Message-Id: <20140628174608.579975577@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 882d18a702c66404fcb62b84748f719f9b47441c upstream.

After relatively recent changes in the ACPI-based PCI hotplug
(ACPIPHP) code, the acpiphp_check_host_bridge() executed for PCI
host bridges via acpi_pci_root_scan_dependent() doesn't do anything
useful, because those bridges do not have hotplug contexts.  That
happens by mistake, so fix it by making acpiphp_enumerate_slots()
add hotplug contexts to PCI host bridges too and modify
acpiphp_remove_slots() to drop those contexts for host bridges
as appropriate.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=76901
Fixes: 2d8b1d566a5f (ACPI / hotplug / PCI: Get rid of check_sub_bridges())
Reported-and-tested-by: Gavin Guo <gavin.guo@canonical.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/acpiphp.h      |   10 ++++++
 drivers/pci/hotplug/acpiphp_glue.c |   60 +++++++++++++++++++++++++------------
 2 files changed, 52 insertions(+), 18 deletions(-)

--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -142,6 +142,16 @@ static inline acpi_handle func_to_handle
 	return func_to_acpi_device(func)->handle;
 }
 
+struct acpiphp_root_context {
+	struct acpi_hotplug_context hp;
+	struct acpiphp_bridge *root_bridge;
+};
+
+static inline struct acpiphp_root_context *to_acpiphp_root_context(struct acpi_hotplug_context *hp)
+{
+	return container_of(hp, struct acpiphp_root_context, hp);
+}
+
 /*
  * struct acpiphp_attention_info - device specific attention registration
  *
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -374,17 +374,13 @@ static acpi_status acpiphp_add_context(a
 
 static struct acpiphp_bridge *acpiphp_dev_to_bridge(struct acpi_device *adev)
 {
-	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge = NULL;
 
 	acpi_lock_hp_context();
-	context = acpiphp_get_context(adev);
-	if (context) {
-		bridge = context->bridge;
+	if (adev->hp) {
+		bridge = to_acpiphp_root_context(adev->hp)->root_bridge;
 		if (bridge)
 			get_bridge(bridge);
-
-		acpiphp_put_context(context);
 	}
 	acpi_unlock_hp_context();
 	return bridge;
@@ -883,7 +879,17 @@ void acpiphp_enumerate_slots(struct pci_
 	 */
 	get_device(&bus->dev);
 
-	if (!pci_is_root_bus(bridge->pci_bus)) {
+	acpi_lock_hp_context();
+	if (pci_is_root_bus(bridge->pci_bus)) {
+		struct acpiphp_root_context *root_context;
+
+		root_context = kzalloc(sizeof(*root_context), GFP_KERNEL);
+		if (!root_context)
+			goto err;
+
+		root_context->root_bridge = bridge;
+		acpi_set_hp_context(adev, &root_context->hp, NULL, NULL, NULL);
+	} else {
 		struct acpiphp_context *context;
 
 		/*
@@ -892,21 +898,16 @@ void acpiphp_enumerate_slots(struct pci_
 		 * parent is going to be handled by pciehp, in which case this
 		 * bridge is not interesting to us either.
 		 */
-		acpi_lock_hp_context();
 		context = acpiphp_get_context(adev);
-		if (!context) {
-			acpi_unlock_hp_context();
-			put_device(&bus->dev);
-			pci_dev_put(bridge->pci_dev);
-			kfree(bridge);
-			return;
-		}
+		if (!context)
+			goto err;
+
 		bridge->context = context;
 		context->bridge = bridge;
 		/* Get a reference to the parent bridge. */
 		get_bridge(context->func.parent);
-		acpi_unlock_hp_context();
 	}
+	acpi_unlock_hp_context();
 
 	/* Must be added to the list prior to calling acpiphp_add_context(). */
 	mutex_lock(&bridge_mutex);
@@ -921,6 +922,30 @@ void acpiphp_enumerate_slots(struct pci_
 		cleanup_bridge(bridge);
 		put_bridge(bridge);
 	}
+	return;
+
+ err:
+	acpi_unlock_hp_context();
+	put_device(&bus->dev);
+	pci_dev_put(bridge->pci_dev);
+	kfree(bridge);
+}
+
+void acpiphp_drop_bridge(struct acpiphp_bridge *bridge)
+{
+	if (pci_is_root_bus(bridge->pci_bus)) {
+		struct acpiphp_root_context *root_context;
+		struct acpi_device *adev;
+
+		acpi_lock_hp_context();
+		adev = ACPI_COMPANION(bridge->pci_bus->bridge);
+		root_context = to_acpiphp_root_context(adev->hp);
+		adev->hp = NULL;
+		acpi_unlock_hp_context();
+		kfree(root_context);
+	}
+	cleanup_bridge(bridge);
+	put_bridge(bridge);
 }
 
 /**
@@ -938,8 +963,7 @@ void acpiphp_remove_slots(struct pci_bus
 	list_for_each_entry(bridge, &bridge_list, list)
 		if (bridge->pci_bus == bus) {
 			mutex_unlock(&bridge_mutex);
-			cleanup_bridge(bridge);
-			put_bridge(bridge);
+			acpiphp_drop_bridge(bridge);
 			return;
 		}
 


