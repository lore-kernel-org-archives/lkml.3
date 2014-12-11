Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbaLKAUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 19:20:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45656 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268AbaLKAUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 19:20:04 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Marek=20Kord=C3=ADk?= <kordikmarek@gmail.com>,
        Alexey Voronkov <zermond@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v2] PCI: Clear all bridge res MEM_64 if host bridge has non mem64
Date: Wed, 10 Dec 2014 16:19:42 -0800
Message-Id: <1418257182-6345-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we could use bridge 64bit mem pref for children mem pref instead of
forcing them into bridge mem.

Could help Marek's system as his system is using _CRS, and all mem res is under
4G.

-v2: fix checking logic problem found by Gravin and Wei.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/host-bridge.c |    7 +++++++
 drivers/pci/pci.h         |    1 +
 drivers/pci/probe.c       |    9 +++++++++
 drivers/pci/setup-bus.c   |    3 +++
 include/linux/pci.h       |    1 +
 5 files changed, 21 insertions(+)

Index: linux-2.6/drivers/pci/host-bridge.c
===================================================================
--- linux-2.6.orig/drivers/pci/host-bridge.c
+++ linux-2.6/drivers/pci/host-bridge.c
@@ -31,6 +31,13 @@ void pci_set_host_bridge_release(struct
 	bridge->release_data = release_data;
 }
 
+bool pcibios_host_bridge_has_mem64_res(struct pci_bus *bus)
+{
+	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
+
+	return bridge->has_mem64_res;
+}
+
 void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
 			     struct resource *res)
 {
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -196,6 +196,7 @@ enum pci_bar_type {
 	pci_bar_mem64,		/* A 64-bit memory BAR */
 };
 
+bool pcibios_host_bridge_has_mem64_res(struct pci_bus *bus);
 bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *pl,
 				int crs_timeout);
 int pci_setup_device(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -1980,6 +1980,15 @@ struct pci_bus *pci_create_root_bus(stru
 		dev_info(&b->dev, "root bus resource %pR%s\n", res, bus_addr);
 	}
 
+	list_for_each_entry(window, &bridge->windows, list) {
+		res = window->res;
+		if (resource_type(res) == IORESOURCE_MEM &&
+		    (res->end - window->offset) > 0xffffffff) {
+			bridge->has_mem64_res = true;
+			break;
+		}
+	}
+
 	down_write(&pci_bus_sem);
 	list_add_tail(&b->node, &pci_root_buses);
 	up_write(&pci_bus_sem);
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -407,6 +407,7 @@ struct pci_host_bridge {
 	struct list_head windows;	/* pci_host_bridge_windows */
 	void (*release_fn)(struct pci_host_bridge *);
 	void *release_data;
+	bool has_mem64_res;
 };
 
 #define	to_pci_host_bridge(n) container_of(n, struct pci_host_bridge, dev)
Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -693,6 +693,9 @@ static void pci_bridge_check_ranges(stru
 		}
 	}
 
+        if (!pcibios_host_bridge_has_mem64_res(bus))
+                b_res[2].flags &= ~IORESOURCE_MEM_64;
+
 	/* double check if bridge does support 64 bit pref */
 	if (b_res[2].flags & IORESOURCE_MEM_64) {
 		u32 mem_base_hi, tmp;
