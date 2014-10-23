Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaJWPX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:23:27 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49459 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaJWPXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:23:24 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: liviu.dudau@arm.com, Suravee.Suthikulpanit@amd.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH RFC 2/2] drivers: pci: convert generic host controller to DT resource parsing API
Date: Thu, 23 Oct 2014 16:23:07 +0100
Message-Id: <1414077787-20633-2-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
References: <1414077787-20633-1-git-send-email-lorenzo.pieralisi@arm.com>
X-OriginalArrivalTime: 23 Oct 2014 15:23:21.0882 (UTC) FILETIME=[47E74FA0:01CFEED5]
X-MC-Unique: 114102316232205301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id s9NFNYgr016952

In order to consolidate DT configuration for PCI host controllers in the
kernel, a new API (ie of_pci_get_host_bridge_resources()) was developed
to allow parsing and assigning IO/BUS/MEM resources from DT, removing
duplicated code present in the majority of pci host driver implementations.

This patch converts the existing PCI generic host controller driver to
the new API. Most of the code parsing ranges and creating resources is
now delegated to of_pci_get_host_bridge_resources() API.

The PCI host controller code carries out resources filtering on the
resulting resource list and maps IO space by using the newly introduced
pci_ioremap_iospace() API.

New code supports only one IO resource per generic host controller, which
should cater for all existing host controller configurations.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
 drivers/pci/host/pci-host-generic.c | 120 ++++++++----------------------------
 1 file changed, 27 insertions(+), 93 deletions(-)

diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
index 1e1a80f..1895907 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -32,7 +32,7 @@ struct gen_pci_cfg_bus_ops {
 
 struct gen_pci_cfg_windows {
 	struct resource				res;
-	struct resource				bus_range;
+	struct resource				*bus_range;
 	void __iomem				**win;
 
 	const struct gen_pci_cfg_bus_ops	*ops;
@@ -50,7 +50,7 @@ static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
 {
 	struct pci_sys_data *sys = bus->sysdata;
 	struct gen_pci *pci = sys->private_data;
-	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
+	resource_size_t idx = bus->number - pci->cfg.bus_range->start;
 
 	return pci->cfg.win[idx] + ((devfn << 8) | where);
 }
@@ -66,7 +66,7 @@ static void __iomem *gen_pci_map_cfg_bus_ecam(struct pci_bus *bus,
 {
 	struct pci_sys_data *sys = bus->sysdata;
 	struct gen_pci *pci = sys->private_data;
-	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
+	resource_size_t idx = bus->number - pci->cfg.bus_range->start;
 
 	return pci->cfg.win[idx] + ((devfn << 12) | where);
 }
@@ -138,106 +138,50 @@ static const struct of_device_id gen_pci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, gen_pci_of_match);
 
-static int gen_pci_calc_io_offset(struct device *dev,
-				  struct of_pci_range *range,
-				  struct resource *res,
-				  resource_size_t *offset)
-{
-	static atomic_t wins = ATOMIC_INIT(0);
-	int err, idx, max_win;
-	unsigned int window;
-
-	if (!PAGE_ALIGNED(range->cpu_addr))
-		return -EINVAL;
-
-	max_win = (IO_SPACE_LIMIT + 1) / SZ_64K;
-	idx = atomic_inc_return(&wins);
-	if (idx > max_win)
-		return -ENOSPC;
-
-	window = (idx - 1) * SZ_64K;
-	err = pci_ioremap_io(window, range->cpu_addr);
-	if (err)
-		return err;
-
-	of_pci_range_to_resource(range, dev->of_node, res);
-	res->start = window;
-	res->end = res->start + range->size - 1;
-	*offset = window - range->pci_addr;
-	return 0;
-}
-
-static int gen_pci_calc_mem_offset(struct device *dev,
-				   struct of_pci_range *range,
-				   struct resource *res,
-				   resource_size_t *offset)
-{
-	of_pci_range_to_resource(range, dev->of_node, res);
-	*offset = range->cpu_addr - range->pci_addr;
-	return 0;
-}
-
 static void gen_pci_release_of_pci_ranges(struct gen_pci *pci)
 {
-	struct pci_host_bridge_window *win;
-
-	list_for_each_entry(win, &pci->resources, list)
-		release_resource(win->res);
-
 	pci_free_resource_list(&pci->resources);
 }
 
 static int gen_pci_parse_request_of_pci_ranges(struct gen_pci *pci)
 {
-	struct of_pci_range range;
-	struct of_pci_range_parser parser;
 	int err, res_valid = 0;
 	struct device *dev = pci->host.dev.parent;
 	struct device_node *np = dev->of_node;
+	resource_size_t iobase;
+	struct pci_host_bridge_window *win;
 
-	if (of_pci_range_parser_init(&parser, np)) {
-		dev_err(dev, "missing \"ranges\" property\n");
-		return -EINVAL;
-	}
+	err = of_pci_get_host_bridge_resources(np, 0, 0xff, &pci->resources,
+					       &iobase);
+	if (err)
+		return err;
 
-	for_each_of_pci_range(&parser, &range) {
-		struct resource *parent, *res;
-		resource_size_t offset;
-		u32 restype = range.flags & IORESOURCE_TYPE_BITS;
+	list_for_each_entry(win, &pci->resources, list) {
+		struct resource *parent, *res = win->res;
 
-		res = devm_kmalloc(dev, sizeof(*res), GFP_KERNEL);
-		if (!res) {
-			err = -ENOMEM;
-			goto out_release_res;
-		}
-
-		switch (restype) {
+		switch (resource_type(res)) {
 		case IORESOURCE_IO:
 			parent = &ioport_resource;
-			err = gen_pci_calc_io_offset(dev, &range, res, &offset);
+			err = pci_remap_iospace(res, iobase);
+			if (err) {
+				dev_warn(dev, "error %d: failed to map resource %pR\n",
+					 err, res);
+				continue;
+			}
 			break;
 		case IORESOURCE_MEM:
 			parent = &iomem_resource;
-			err = gen_pci_calc_mem_offset(dev, &range, res, &offset);
-			res_valid |= !(res->flags & IORESOURCE_PREFETCH || err);
+			res_valid |= !(res->flags & IORESOURCE_PREFETCH);
 			break;
+		case IORESOURCE_BUS:
+			pci->cfg.bus_range = res;
 		default:
-			err = -EINVAL;
 			continue;
 		}
 
-		if (err) {
-			dev_warn(dev,
-				 "error %d: failed to add resource [type 0x%x, %lld bytes]\n",
-				 err, restype, range.size);
-			continue;
-		}
-
-		err = request_resource(parent, res);
+		err = devm_request_resource(dev, parent, res);
 		if (err)
 			goto out_release_res;
-
-		pci_add_resource_offset(&pci->resources, res, offset);
 	}
 
 	if (!res_valid) {
@@ -262,14 +206,6 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 	struct device *dev = pci->host.dev.parent;
 	struct device_node *np = dev->of_node;
 
-	if (of_pci_parse_bus_range(np, &pci->cfg.bus_range))
-		pci->cfg.bus_range = (struct resource) {
-			.name	= np->name,
-			.start	= 0,
-			.end	= 0xff,
-			.flags	= IORESOURCE_BUS,
-		};
-
 	err = of_address_to_resource(np, 0, &pci->cfg.res);
 	if (err) {
 		dev_err(dev, "missing \"reg\" property\n");
@@ -277,12 +213,12 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 	}
 
 	/* Limit the bus-range to fit within reg */
-	bus_max = pci->cfg.bus_range.start +
+	bus_max = pci->cfg.bus_range->start +
 		  (resource_size(&pci->cfg.res) >> pci->cfg.ops->bus_shift) - 1;
-	pci->cfg.bus_range.end = min_t(resource_size_t, pci->cfg.bus_range.end,
-				       bus_max);
+	pci->cfg.bus_range->end = min_t(resource_size_t,
+					pci->cfg.bus_range->end, bus_max);
 
-	pci->cfg.win = devm_kcalloc(dev, resource_size(&pci->cfg.bus_range),
+	pci->cfg.win = devm_kcalloc(dev, resource_size(pci->cfg.bus_range),
 				    sizeof(*pci->cfg.win), GFP_KERNEL);
 	if (!pci->cfg.win)
 		return -ENOMEM;
@@ -293,7 +229,7 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 				     "Configuration Space"))
 		return -ENOMEM;
 
-	bus_range = &pci->cfg.bus_range;
+	bus_range = pci->cfg.bus_range;
 	for (busn = bus_range->start; busn <= bus_range->end; ++busn) {
 		u32 idx = busn - bus_range->start;
 		u32 sz = 1 << pci->cfg.ops->bus_shift;
@@ -305,8 +241,6 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 			return -ENOMEM;
 	}
 
-	/* Register bus resource */
-	pci_add_resource(&pci->resources, bus_range);
 	return 0;
 }
 
-- 
2.1.2


