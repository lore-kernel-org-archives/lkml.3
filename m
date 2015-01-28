Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbbA1UaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:30:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:39114 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227AbbA1U3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:29:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677269277"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Will Deacon <will.deacon@arm.com>, Tanmay Inamdar <tinamdar@apm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Srikanth Thokala <sthokal@xilinx.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [Patch v2 18/22] PCI: Use common resource list management code instead of private implementation
Date: Wed, 28 Jan 2015 18:57:36 +0800
Message-Id: <1422442660-455-19-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common resource list management data structure and interfaces
instead of private implementation.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/arm/kernel/bios32.c            |    5 ++---
 arch/x86/pci/bus_numa.c             |    4 ++--
 drivers/pci/bus.c                   |   18 ++++++------------
 drivers/pci/host-bridge.c           |    8 ++++----
 drivers/pci/host/pci-host-generic.c |    4 ++--
 drivers/pci/host/pci-xgene.c        |    4 ++--
 drivers/pci/host/pcie-xilinx.c      |    4 ++--
 drivers/pci/probe.c                 |   10 +++++-----
 include/linux/pci.h                 |    9 ++-------
 9 files changed, 27 insertions(+), 39 deletions(-)

diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
index a4effd6d8f2f..968b03cb6376 100644
--- a/arch/arm/kernel/bios32.c
+++ b/arch/arm/kernel/bios32.c
@@ -422,17 +422,16 @@ static int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 static int pcibios_init_resources(int busnr, struct pci_sys_data *sys)
 {
 	int ret;
-	struct pci_host_bridge_window *window;
+	struct resource_list_entry *window;
 
 	if (list_empty(&sys->resources)) {
 		pci_add_resource_offset(&sys->resources,
 			 &iomem_resource, sys->mem_offset);
 	}
 
-	list_for_each_entry(window, &sys->resources, list) {
+	resource_list_for_each_entry(window, &sys->resources)
 		if (resource_type(window->res) == IORESOURCE_IO)
 			return 0;
-	}
 
 	sys->io_res.start = (busnr * SZ_64K) ?  : pcibios_min_io;
 	sys->io_res.end = (busnr + 1) * SZ_64K - 1;
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index f3a2cfc14125..6785af30ed39 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -31,7 +31,7 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 {
 	struct pci_root_info *info = x86_find_pci_root_info(bus);
 	struct pci_root_res *root_res;
-	struct pci_host_bridge_window *window;
+	struct resource_list_entry *window;
 	bool found = false;
 
 	if (!info)
@@ -41,7 +41,7 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 	       bus);
 
 	/* already added by acpi ? */
-	list_for_each_entry(window, resources, list)
+	resource_list_for_each_entry(window, resources)
 		if (window->res->flags & IORESOURCE_BUS) {
 			found = true;
 			break;
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 8fb16188cd82..c850c48d81d2 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -20,17 +20,16 @@
 void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 			     resource_size_t offset)
 {
-	struct pci_host_bridge_window *window;
+	struct resource_list_entry *entry;
 
-	window = kzalloc(sizeof(struct pci_host_bridge_window), GFP_KERNEL);
-	if (!window) {
+	entry = resource_list_create_entry(res, 0);
+	if (!entry) {
 		printk(KERN_ERR "PCI: can't add host bridge window %pR\n", res);
 		return;
 	}
 
-	window->res = res;
-	window->offset = offset;
-	list_add_tail(&window->list, resources);
+	entry->offset = offset;
+	resource_list_add_tail(entry, resources);
 }
 EXPORT_SYMBOL(pci_add_resource_offset);
 
@@ -42,12 +41,7 @@ EXPORT_SYMBOL(pci_add_resource);
 
 void pci_free_resource_list(struct list_head *resources)
 {
-	struct pci_host_bridge_window *window, *tmp;
-
-	list_for_each_entry_safe(window, tmp, resources, list) {
-		list_del(&window->list);
-		kfree(window);
-	}
+	resource_list_free(resources);
 }
 EXPORT_SYMBOL(pci_free_resource_list);
 
diff --git a/drivers/pci/host-bridge.c b/drivers/pci/host-bridge.c
index 0e5f3c95af5b..3ea13883e6a5 100644
--- a/drivers/pci/host-bridge.c
+++ b/drivers/pci/host-bridge.c
@@ -35,10 +35,10 @@ void pcibios_resource_to_bus(struct pci_bus *bus, struct pci_bus_region *region,
 			     struct resource *res)
 {
 	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
-	struct pci_host_bridge_window *window;
+	struct resource_list_entry *window;
 	resource_size_t offset = 0;
 
-	list_for_each_entry(window, &bridge->windows, list) {
+	resource_list_for_each_entry(window, &bridge->windows) {
 		if (resource_contains(window->res, res)) {
 			offset = window->offset;
 			break;
@@ -60,10 +60,10 @@ void pcibios_bus_to_resource(struct pci_bus *bus, struct resource *res,
 			     struct pci_bus_region *region)
 {
 	struct pci_host_bridge *bridge = find_pci_host_bridge(bus);
-	struct pci_host_bridge_window *window;
+	struct resource_list_entry *window;
 	resource_size_t offset = 0;
 
-	list_for_each_entry(window, &bridge->windows, list) {
+	resource_list_for_each_entry(window, &bridge->windows) {
 		struct pci_bus_region bus_region;
 
 		if (resource_type(res) != resource_type(window->res))
diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
index 6eb1aa75bd37..16d5d6eeb35a 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -149,14 +149,14 @@ static int gen_pci_parse_request_of_pci_ranges(struct gen_pci *pci)
 	struct device *dev = pci->host.dev.parent;
 	struct device_node *np = dev->of_node;
 	resource_size_t iobase;
-	struct pci_host_bridge_window *win;
+	struct resource_list_entry *win;
 
 	err = of_pci_get_host_bridge_resources(np, 0, 0xff, &pci->resources,
 					       &iobase);
 	if (err)
 		return err;
 
-	list_for_each_entry(win, &pci->resources, list) {
+	resource_list_for_each_entry(win, &pci->resources) {
 		struct resource *parent, *res = win->res;
 
 		switch (resource_type(res)) {
diff --git a/drivers/pci/host/pci-xgene.c b/drivers/pci/host/pci-xgene.c
index b1d0596457c5..e335b834f950 100644
--- a/drivers/pci/host/pci-xgene.c
+++ b/drivers/pci/host/pci-xgene.c
@@ -401,11 +401,11 @@ static int xgene_pcie_map_ranges(struct xgene_pcie_port *port,
 				 struct list_head *res,
 				 resource_size_t io_base)
 {
-	struct pci_host_bridge_window *window;
+	struct resource_list_entry *window;
 	struct device *dev = port->dev;
 	int ret;
 
-	list_for_each_entry(window, res, list) {
+	resource_list_for_each_entry(window, res) {
 		struct resource *res = window->res;
 		u64 restype = resource_type(res);
 
diff --git a/drivers/pci/host/pcie-xilinx.c b/drivers/pci/host/pcie-xilinx.c
index ef3ebaf9a738..253e993a111f 100644
--- a/drivers/pci/host/pcie-xilinx.c
+++ b/drivers/pci/host/pcie-xilinx.c
@@ -737,7 +737,7 @@ static int xilinx_pcie_parse_and_add_res(struct xilinx_pcie_port *port)
 	resource_size_t offset;
 	struct of_pci_range_parser parser;
 	struct of_pci_range range;
-	struct pci_host_bridge_window *win;
+	struct resource_list_entry *win;
 	int err = 0, mem_resno = 0;
 
 	/* Get the ranges */
@@ -807,7 +807,7 @@ static int xilinx_pcie_parse_and_add_res(struct xilinx_pcie_port *port)
 
 free_resources:
 	release_child_resources(&iomem_resource);
-	list_for_each_entry(win, &port->resources, list)
+	resource_list_for_each_entry(win, &port->resources)
 		devm_kfree(dev, win->res);
 	pci_free_resource_list(&port->resources);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 23212f8ae09b..df6a40932aa0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1895,7 +1895,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	int error;
 	struct pci_host_bridge *bridge;
 	struct pci_bus *b, *b2;
-	struct pci_host_bridge_window *window, *n;
+	struct resource_list_entry *window, *n;
 	struct resource *res;
 	resource_size_t offset;
 	char bus_addr[64];
@@ -1959,8 +1959,8 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 		printk(KERN_INFO "PCI host bridge to bus %s\n", dev_name(&b->dev));
 
 	/* Add initial resources to the bus */
-	list_for_each_entry_safe(window, n, resources, list) {
-		list_move_tail(&window->list, &bridge->windows);
+	resource_list_for_each_entry_safe(window, n, resources) {
+		list_move_tail(&window->node, &bridge->windows);
 		res = window->res;
 		offset = window->offset;
 		if (res->flags & IORESOURCE_BUS)
@@ -2060,12 +2060,12 @@ void pci_bus_release_busn_res(struct pci_bus *b)
 struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
 		struct pci_ops *ops, void *sysdata, struct list_head *resources)
 {
-	struct pci_host_bridge_window *window;
+	struct resource_list_entry *window;
 	bool found = false;
 	struct pci_bus *b;
 	int max;
 
-	list_for_each_entry(window, resources, list)
+	resource_list_for_each_entry(window, resources)
 		if (window->res->flags & IORESOURCE_BUS) {
 			found = true;
 			break;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9603094ed59b..6aa40d62cdab 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -29,6 +29,7 @@
 #include <linux/atomic.h>
 #include <linux/device.h>
 #include <linux/io.h>
+#include <linux/resource_ext.h>
 #include <uapi/linux/pci.h>
 
 #include <linux/pci_ids.h>
@@ -397,16 +398,10 @@ static inline int pci_channel_offline(struct pci_dev *pdev)
 	return (pdev->error_state != pci_channel_io_normal);
 }
 
-struct pci_host_bridge_window {
-	struct list_head list;
-	struct resource *res;		/* host bridge aperture (CPU address) */
-	resource_size_t offset;		/* bus address + offset = CPU address */
-};
-
 struct pci_host_bridge {
 	struct device dev;
 	struct pci_bus *bus;		/* root bus */
-	struct list_head windows;	/* pci_host_bridge_windows */
+	struct list_head windows;	/* resource_list_entry */
 	void (*release_fn)(struct pci_host_bridge *);
 	void *release_data;
 };
-- 
1.7.10.4

