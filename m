Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3F0XYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 19:24:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:22224 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3F0XYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 19:24:51 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: Gavin Guo <tuffkidtt@gmail.com>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3.9 stable] PCI: acpiphp: Re-enumerate devices when host bridge receives Bus Check
Date: Thu, 27 Jun 2013 16:24:20 -0700
Message-Id: <1372375460-13350-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <20130605223852.GA16729@kroah.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting for v3.9 for 3f327e39b4 (PCI: acpiphp: Re-enumerate devices when host bridge receives Bus Check).

When a PCI host bridge device receives a Bus Check notification, we
must re-enumerate starting with the bridge to discover changes (devices
that have been added or removed).

Prior to 668192b678 ("PCI: acpiphp: Move host bridge hotplug to
pci_root.c"), this happened in _handle_hotplug_event_bridge().  After that
commit, _handle_hotplug_event_bridge() is not installed for host bridges,
and the host bridge notify handler, _handle_hotplug_event_root() did not
re-enumerate.

This patch adds re-enumeration to _handle_hotplug_event_root().

This fixes cases where we don't notice the addition or removal of
PCI devices, e.g., the PCI-to-USB ExpressCard in the bugzilla below.

-v1: Backport of 3f327e39b4 to v3.9 by Bjorn Helgaas <bhelgaas@google.com>
-v2: use request_module("acpiphp") for acpiphp as module instead of built-in.
-v3: Add missing EXPORT_SYMBOL found by Greg.

[bhelgaas: changelog, references]
Reference: https://lkml.kernel.org/r/CAAh6nkmbKR3HTqm5ommevsBwhL_u0N8Rk7Wsms_LfP=nBgKNew@mail.gmail.com
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=57961
Reported-by: Gavin Guo <tuffkidtt@gmail.com>
Tested-by: Gavin Guo <tuffkidtt@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---
 drivers/acpi/pci_root.c            |    7 ++++++-
 drivers/pci/hotplug/acpiphp_glue.c |   14 ++++++++++++++
 include/linux/pci-acpi.h           |    2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

Index: linux-3.9.4/drivers/acpi/pci_root.c
===================================================================
--- linux-3.9.4.orig/drivers/acpi/pci_root.c
+++ linux-3.9.4/drivers/acpi/pci_root.c
@@ -665,6 +665,7 @@ static void handle_root_bridge_removal(s
 		kfree(ej_event);
 }
 
+void (*acpiphp_check_host_bridge)(acpi_handle handle);
 static void _handle_hotplug_event_root(struct work_struct *work)
 {
 	struct acpi_pci_root *root;
@@ -687,7 +688,11 @@ static void _handle_hotplug_event_root(s
 		/* bus enumerate */
 		printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
 				 (char *)buffer.pointer);
-		if (!root)
+		if (root) {
+			request_module("acpiphp");
+			if (acpiphp_check_host_bridge)
+				acpiphp_check_host_bridge(handle);
+		} else
 			handle_root_bridge_insertion(handle);
 
 		break;
Index: linux-3.9.4/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-3.9.4.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-3.9.4/drivers/pci/hotplug/acpiphp_glue.c
@@ -1122,6 +1122,18 @@ check_sub_bridges(acpi_handle handle, u3
 	return AE_OK ;
 }
 
+static void __acpiphp_check_host_bridge(acpi_handle handle)
+{
+	struct acpiphp_bridge *bridge;
+
+	bridge = acpiphp_handle_to_bridge(handle);
+	if (bridge)
+		acpiphp_check_bridge(bridge);
+
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
+		ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
+}
+
 static void _handle_hotplug_event_bridge(struct work_struct *work)
 {
 	struct acpiphp_bridge *bridge;
@@ -1305,6 +1317,7 @@ static struct acpi_pci_driver acpi_pci_h
 int __init acpiphp_glue_init(void)
 {
 	acpi_pci_register_driver(&acpi_pci_hp_driver);
+	acpiphp_check_host_bridge = __acpiphp_check_host_bridge;
 
 	return 0;
 }
@@ -1317,6 +1330,7 @@ int __init acpiphp_glue_init(void)
  */
 void  acpiphp_glue_exit(void)
 {
+	acpiphp_check_host_bridge = NULL;
 	acpi_pci_unregister_driver(&acpi_pci_hp_driver);
 }
 
Index: linux-3.9.4/include/linux/pci-acpi.h
===================================================================
--- linux-3.9.4.orig/include/linux/pci-acpi.h
+++ linux-3.9.4/include/linux/pci-acpi.h
@@ -43,6 +43,8 @@ static inline acpi_handle acpi_pci_get_b
 }
 #endif
 
+extern void (*acpiphp_check_host_bridge)(acpi_handle handle);
+
 #ifdef CONFIG_ACPI_APEI
 extern bool aer_acpi_firmware_first(void);
 #else

