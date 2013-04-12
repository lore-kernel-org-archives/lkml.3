Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab3DLPsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:48:09 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43719 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675Ab3DLPsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:48:04 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH v9 15/16] PCI/acpiphp: introduce a kernel option to disable the acpiphp driver
Date: Fri, 12 Apr 2013 23:44:29 +0800
Message-Id: <1365781470-32379-16-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the acpiphp driver has been converted as builtin, so introduce
a kernel boot option "acpiphp.disable" to disable the acpiphp driver
on boot.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 Documentation/kernel-parameters.txt |    3 +++
 drivers/pci/hotplug/acpiphp.h       |    1 +
 drivers/pci/hotplug/acpiphp_core.c  |    6 +++++-
 drivers/pci/hotplug/acpiphp_glue.c  |    6 ++++++
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..38baa0d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -290,6 +290,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			no: ACPI OperationRegions are not marked as reserved,
 			no further checks are performed.
 
+	acpiphp.disable
+			Disable the PCI acpiphp hotplug driver.
+
 	add_efi_memmap	[EFI; X86] Include EFI memory map in
 			kernel's map of available physical RAM.
 
diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 7577bb3..6a319f4 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -188,5 +188,6 @@ extern u8 acpiphp_get_adapter_status (struct acpiphp_slot *slot);
 
 /* variables */
 extern bool acpiphp_debug;
+extern bool acpiphp_disabled;
 
 #endif /* _ACPIPHP_H */
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 80d777c..cdbd983 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -49,6 +49,7 @@
 #define SLOT_NAME_SIZE  21              /* {_SUN} */
 
 bool acpiphp_debug;
+bool acpiphp_disabled;
 
 /* local variables */
 static struct acpiphp_attention_info *attention_info;
@@ -61,7 +62,9 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
+MODULE_PARM_DESC(disable, "disable acpiphp driver");
 module_param_named(debug, acpiphp_debug, bool, 0644);
+module_param_named(disable, acpiphp_disabled, bool, 0444);
 
 /* export the attention callback registration methods */
 EXPORT_SYMBOL_GPL(acpiphp_register_attention);
@@ -354,5 +357,6 @@ void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 
 void __init acpiphp_init(void)
 {
-	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	info(DRIVER_DESC " version: " DRIVER_VERSION "%s\n",
+	     acpiphp_disabled ? ", disabled by user" : "");
 }
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 896d680..96fed19 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1139,6 +1139,9 @@ void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle)
 	acpi_handle dummy_handle;
 	struct acpiphp_bridge *bridge;
 
+	if (acpiphp_disabled)
+		return;
+
 	if (detect_ejectable_slots(handle) <= 0)
 		return;
 
@@ -1177,6 +1180,9 @@ void acpiphp_remove_slots(struct pci_bus *bus)
 {
 	struct acpiphp_bridge *bridge, *tmp;
 
+	if (acpiphp_disabled)
+		return;
+
 	list_for_each_entry_safe(bridge, tmp, &bridge_list, list)
 		if (bridge->pci_bus == bus) {
 			cleanup_bridge(bridge);
-- 
1.7.9.5

