Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaD2ALA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:11:00 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:65102 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaD2AK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:10:58 -0400
Subject: [PATCH] PCI: Remove unnecessary __ref annotations
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 28 Apr 2014 18:10:55 -0600
Message-ID: <20140429001054.30927.32908.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PCI functions used to be marked __devinit.  When CONFIG_HOTPLUG was
not set, these functions were discarded after boot.  A few callers of these
__devinit functions were marked __ref to indicate that they could safely
call the __devinit functions even though the callers were not __devinit.

But CONFIG_HOTPLUG and __devinit are now gone, and the need for the __ref
annotations is also gone, so remove them.  Relevant historical commits:

  54b956b90360 Remove __dev* markings from init.h
  a8e4b9c101ae PCI: add generic pci_hp_add_bridge()
  0ab2b57f8db8 PCI: fix section mismatch warning in pci_scan_child_bus
  451124a7cc6c PCI: fix 4x section mismatch warnings

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/hotplug-pci.c              |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c     |    2 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c |    2 +-
 drivers/pci/hotplug/shpchp_pci.c       |    2 +-
 drivers/pci/pci.h                      |    8 ++++----
 drivers/pci/probe.c                    |    8 ++++----
 drivers/pci/setup-bus.c                |   25 ++++++++++++-------------
 7 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index 6258dc260d9f..c68366cee6b7 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -4,7 +4,7 @@
 #include <linux/export.h>
 #include "pci.h"
 
-int __ref pci_hp_add_bridge(struct pci_dev *dev)
+int pci_hp_add_bridge(struct pci_dev *dev)
 {
 	struct pci_bus *parent = dev->bus;
 	int pass, busnr, start = parent->busn_res.start;
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 0238a02b4cb3..bb945e33b1ec 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -500,7 +500,7 @@ static int acpiphp_rescan_slot(struct acpiphp_slot *slot)
  * This function should be called per *physical slot*,
  * not per each slot object in ACPI namespace.
  */
-static void __ref enable_slot(struct acpiphp_slot *slot)
+static void enable_slot(struct acpiphp_slot *slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bus;
diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index 8c1464851768..b238a1a28372 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -250,7 +250,7 @@ int cpci_led_off(struct slot* slot)
  * Device configuration functions
  */
 
-int __ref cpci_configure_slot(struct slot *slot)
+int cpci_configure_slot(struct slot *slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *parent;
diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
index 2bf69fe1926c..18209ebc0979 100644
--- a/drivers/pci/hotplug/shpchp_pci.c
+++ b/drivers/pci/hotplug/shpchp_pci.c
@@ -34,7 +34,7 @@
 #include "../pci.h"
 #include "shpchp.h"
 
-int __ref shpchp_configure_device(struct slot *p_slot)
+int shpchp_configure_device(struct slot *p_slot)
 {
 	struct pci_dev *dev;
 	struct controller *ctrl = p_slot->ctrl;
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 6bd082299e31..fe233a3099cf 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -201,11 +201,11 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		    struct resource *res, unsigned int reg);
 int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type);
 void pci_configure_ari(struct pci_dev *dev);
-void __ref __pci_bus_size_bridges(struct pci_bus *bus,
+void __pci_bus_size_bridges(struct pci_bus *bus,
 			struct list_head *realloc_head);
-void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
-				      struct list_head *realloc_head,
-				      struct list_head *fail_head);
+void __pci_bus_assign_resources(const struct pci_bus *bus,
+				struct list_head *realloc_head,
+				struct list_head *fail_head);
 
 /**
  * pci_ari_enabled - query ARI forwarding status
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ef09f5f2fe6c..fe89a982a3da 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -719,7 +719,7 @@ add_dev:
 	return child;
 }
 
-struct pci_bus *__ref pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
+struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr)
 {
 	struct pci_bus *child;
 
@@ -1369,7 +1369,7 @@ void pci_device_add(struct pci_dev *dev, struct pci_bus *bus)
 	WARN_ON(ret < 0);
 }
 
-struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
+struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
 
@@ -1958,7 +1958,7 @@ EXPORT_SYMBOL(pci_scan_bus);
  *
  * Returns the max number of subordinate bus discovered.
  */
-unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
+unsigned int pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
 {
 	unsigned int max;
 	struct pci_bus *bus = bridge->subordinate;
@@ -1981,7 +1981,7 @@ unsigned int __ref pci_rescan_bus_bridge_resize(struct pci_dev *bridge)
  *
  * Returns the max number of subordinate bus discovered.
  */
-unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
+unsigned int pci_rescan_bus(struct pci_bus *bus)
 {
 	unsigned int max;
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 138bdd6393be..d219d44709b2 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1113,8 +1113,7 @@ handle_done:
 	;
 }
 
-void __ref __pci_bus_size_bridges(struct pci_bus *bus,
-			struct list_head *realloc_head)
+void __pci_bus_size_bridges(struct pci_bus *bus, struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
 	unsigned long mask, prefmask;
@@ -1178,15 +1177,15 @@ void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 	}
 }
 
-void __ref pci_bus_size_bridges(struct pci_bus *bus)
+void pci_bus_size_bridges(struct pci_bus *bus)
 {
 	__pci_bus_size_bridges(bus, NULL);
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
-void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
-				      struct list_head *realloc_head,
-				      struct list_head *fail_head)
+void __pci_bus_assign_resources(const struct pci_bus *bus,
+				struct list_head *realloc_head,
+				struct list_head *fail_head)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
@@ -1218,15 +1217,15 @@ void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
 	}
 }
 
-void __ref pci_bus_assign_resources(const struct pci_bus *bus)
+void pci_bus_assign_resources(const struct pci_bus *bus)
 {
 	__pci_bus_assign_resources(bus, NULL, NULL);
 }
 EXPORT_SYMBOL(pci_bus_assign_resources);
 
-static void __ref __pci_bridge_assign_resources(const struct pci_dev *bridge,
-					 struct list_head *add_head,
-					 struct list_head *fail_head)
+static void __pci_bridge_assign_resources(const struct pci_dev *bridge,
+					  struct list_head *add_head,
+					  struct list_head *fail_head)
 {
 	struct pci_bus *b;
 
@@ -1304,9 +1303,9 @@ enum release_type {
  * try to release pci bridge resources that is from leaf bridge,
  * so we can allocate big new one later
  */
-static void __ref pci_bus_release_bridge_resources(struct pci_bus *bus,
-						   unsigned long type,
-						   enum release_type rel_type)
+static void pci_bus_release_bridge_resources(struct pci_bus *bus,
+					     unsigned long type,
+					     enum release_type rel_type)
 {
 	struct pci_dev *dev;
 	bool is_leaf_bridge = true;

