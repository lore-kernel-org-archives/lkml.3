Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab3FVVRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 17:17:00 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47200 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065Ab3FVVQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 17:16:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-acpi@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] PCI / ACPI: Use boot-time resource allocation rules during hotplug
Date: Sat, 22 Jun 2013 23:22:53 +0200
Message-ID: <3239217.ynmdcqJzI5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2737587.I0nULev1kj@vostro.rjw.lan>
References: <2737587.I0nULev1kj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

On x86 platforms, the kernel respects PCI resource assignments from
the BIOS and only reassigns resources for unassigned BARs at boot
time.  However, with the ACPI-based hotplug (acpiphp), it ignores the
BIOS' PCI resource assignments completely and reassigns all resources
by itself.  This causes differences in PCI resource allocation
between boot time and runtime hotplug to occur, which is generally
undesirable and sometimes actively breaks things.

Namely, if there are enough resources, reassigning all PCI resources
during runtime hotplug should work, but it may fail if the resources
are constrained.  This may happen, for instance, when some PCI
devices with huge MMIO BARs are involved in the runtime hotplug
operations, because the current PCI MMIO alignment algorithm may
waste huge chunks of MMIO address space in those cases.

On the Alexander's Sony VAIO VPCZ23A4R the BIOS allocates limited
MMIO resources for the dock station which contains a device
(graphics adapter) with a 256MB MMIO BAR.  An attempt to reassign
that during runtime hotplug causes the dock station MMIO window to be
exhausted and acpiphp fails to allocate resources for the majority
of devices on the dock station as a result.

To prevent that from happening, modify acpiphp to follow the boot
time resources allocation behavior so that the BIOS' resource
assignments are respected during runtime hotplug too.

[rjw: Changelog]
References: https://bugzilla.kernel.org/show_bug.cgi?id=56531
Reported-and-tested-by: Alexander E. Patrakov <patrakov@gmail.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
drivers/pci/hotplug/acpiphp_glue.c | 7 +++++--
 drivers/pci/hotplug/acpiphp_glue.c |    7 +++++--
 drivers/pci/pci.h                  |    5 +++++
 drivers/pci/setup-bus.c            |    8 ++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -670,6 +670,7 @@ static int __ref enable_device(struct ac
 	struct pci_bus *bus = slot->bridge->pci_bus;
 	struct acpiphp_func *func;
 	int num, max, pass;
+	LIST_HEAD(add_list);
 
 	if (slot->flags & SLOT_ENABLED)
 		goto err_exit;
@@ -694,13 +695,15 @@ static int __ref enable_device(struct ac
 				max = pci_scan_bridge(bus, dev, max, pass);
 				if (pass && dev->subordinate) {
 					check_hotplug_bridge(slot, dev);
-					pci_bus_size_bridges(dev->subordinate);
+					pcibios_resource_survey_bus(dev->subordinate);
+					__pci_bus_size_bridges(dev->subordinate,
+							       &add_list);
 				}
 			}
 		}
 	}
 
-	pci_bus_assign_resources(bus);
+	__pci_bus_assign_resources(bus, &add_list, NULL);
 	acpiphp_sanitize_bus(bus);
 	acpiphp_set_hpp_values(bus);
 	acpiphp_set_acpi_region(slot);
Index: linux-pm/drivers/pci/pci.h
===================================================================
--- linux-pm.orig/drivers/pci/pci.h
+++ linux-pm/drivers/pci/pci.h
@@ -202,6 +202,11 @@ int __pci_read_base(struct pci_dev *dev,
 		    struct resource *res, unsigned int reg);
 int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type);
 void pci_configure_ari(struct pci_dev *dev);
+void __ref __pci_bus_size_bridges(struct pci_bus *bus,
+			struct list_head *realloc_head);
+void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
+				      struct list_head *realloc_head,
+				      struct list_head *fail_head);
 
 /**
  * pci_ari_enabled - query ARI forwarding status
Index: linux-pm/drivers/pci/setup-bus.c
===================================================================
--- linux-pm.orig/drivers/pci/setup-bus.c
+++ linux-pm/drivers/pci/setup-bus.c
@@ -1044,7 +1044,7 @@ handle_done:
 	;
 }
 
-static void __ref __pci_bus_size_bridges(struct pci_bus *bus,
+void __ref __pci_bus_size_bridges(struct pci_bus *bus,
 			struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
@@ -1115,9 +1115,9 @@ void __ref pci_bus_size_bridges(struct p
 }
 EXPORT_SYMBOL(pci_bus_size_bridges);
 
-static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
-					 struct list_head *realloc_head,
-					 struct list_head *fail_head)
+void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
+				      struct list_head *realloc_head,
+				      struct list_head *fail_head)
 {
 	struct pci_bus *b;
 	struct pci_dev *dev;
