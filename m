Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaHLQm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:42:26 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50835 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753213AbaHLQmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:42:24 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Jingoo Han <jg1.han@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] drivers: pci: convert generic host controller to DT host bridge creation API
Date: Tue, 12 Aug 2014 17:41:35 +0100
Message-Id: <1407861695-25549-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

In order to consolidate DT configuration for PCI host controllers in the
kernel, a new API was introduced that allows creating a host bridge
and its PCI bus from DT, removing duplicated code present in the
majority of pci host driver implementations.

This patch converts the existing PCI generic host controller driver to
the new API. Most of the code parsing ranges and creating resources is
now delegated to of_create_pci_host_bridge() API which also triggers
a scan of the root bus.

The setup hook passed by the host controller code to the generic DT
layer completes the initialization by performing resource filtering
(ie it checks that at least one non-prefetchable memory resource is
present), remapping IO and configuration regions and initializing
the required PCI flags.

Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Rob Herring <robh@kernel.org>
[ported to v9, fixed some bugs and refactored the code]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/pci/host/pci-host-generic.c | 244 ++++++++++--------------------------
 1 file changed, 66 insertions(+), 178 deletions(-)

diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
index 44fe6aa..24b519f 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -32,25 +32,21 @@ struct gen_pci_cfg_bus_ops {
 
 struct gen_pci_cfg_windows {
 	struct resource				res;
-	struct resource				bus_range;
 	void __iomem				**win;
 
 	const struct gen_pci_cfg_bus_ops	*ops;
 };
 
 struct gen_pci {
-	struct pci_host_bridge			host;
 	struct gen_pci_cfg_windows		cfg;
-	struct list_head			resources;
 };
 
 static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
 					     unsigned int devfn,
 					     int where)
 {
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
-	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
+	struct gen_pci *pci = bus->sysdata;
+	resource_size_t idx = bus->number - bus->busn_res.start;
 
 	return pci->cfg.win[idx] + ((devfn << 8) | where);
 }
@@ -64,9 +60,8 @@ static void __iomem *gen_pci_map_cfg_bus_ecam(struct pci_bus *bus,
 					      unsigned int devfn,
 					      int where)
 {
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
-	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
+	struct gen_pci *pci = bus->sysdata;
+	resource_size_t idx = bus->number - bus->busn_res.start;
 
 	return pci->cfg.win[idx] + ((devfn << 12) | where);
 }
@@ -80,8 +75,7 @@ static int gen_pci_config_read(struct pci_bus *bus, unsigned int devfn,
 				int where, int size, u32 *val)
 {
 	void __iomem *addr;
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = bus->sysdata;
 
 	addr = pci->cfg.ops->map_bus(bus, devfn, where);
 
@@ -103,8 +97,7 @@ static int gen_pci_config_write(struct pci_bus *bus, unsigned int devfn,
 				 int where, int size, u32 val)
 {
 	void __iomem *addr;
-	struct pci_sys_data *sys = bus->sysdata;
-	struct gen_pci *pci = sys->private_data;
+	struct gen_pci *pci = bus->sysdata;
 
 	addr = pci->cfg.ops->map_bus(bus, devfn, where);
 
@@ -138,162 +131,40 @@ static const struct of_device_id gen_pci_of_match[] = {
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
-static void gen_pci_release_of_pci_ranges(struct gen_pci *pci)
-{
-	struct pci_host_bridge_window *win;
-
-	list_for_each_entry(win, &pci->resources, list)
-		release_resource(win->res);
-
-	pci_free_resource_list(&pci->resources);
-}
-
-static int gen_pci_parse_request_of_pci_ranges(struct gen_pci *pci)
-{
-	struct of_pci_range range;
-	struct of_pci_range_parser parser;
-	int err, res_valid = 0;
-	struct device *dev = pci->host.dev.parent;
-	struct device_node *np = dev->of_node;
-
-	if (of_pci_range_parser_init(&parser, np)) {
-		dev_err(dev, "missing \"ranges\" property\n");
-		return -EINVAL;
-	}
-
-	for_each_of_pci_range(&parser, &range) {
-		struct resource *parent, *res;
-		resource_size_t offset;
-		u32 restype = range.flags & IORESOURCE_TYPE_BITS;
-
-		res = devm_kmalloc(dev, sizeof(*res), GFP_KERNEL);
-		if (!res) {
-			err = -ENOMEM;
-			goto out_release_res;
-		}
-
-		switch (restype) {
-		case IORESOURCE_IO:
-			parent = &ioport_resource;
-			err = gen_pci_calc_io_offset(dev, &range, res, &offset);
-			break;
-		case IORESOURCE_MEM:
-			parent = &iomem_resource;
-			err = gen_pci_calc_mem_offset(dev, &range, res, &offset);
-			res_valid |= !(res->flags & IORESOURCE_PREFETCH || err);
-			break;
-		default:
-			err = -EINVAL;
-			continue;
-		}
-
-		if (err) {
-			dev_warn(dev,
-				 "error %d: failed to add resource [type 0x%x, %lld bytes]\n",
-				 err, restype, range.size);
-			continue;
-		}
-
-		err = request_resource(parent, res);
-		if (err)
-			goto out_release_res;
-
-		pci_add_resource_offset(&pci->resources, res, offset);
-	}
-
-	if (!res_valid) {
-		dev_err(dev, "non-prefetchable memory resource required\n");
-		err = -EINVAL;
-		goto out_release_res;
-	}
-
-	return 0;
-
-out_release_res:
-	gen_pci_release_of_pci_ranges(pci);
-	return err;
-}
-
-static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
+static int gen_pci_parse_map_cfg_windows(struct pci_host_bridge *host)
 {
 	int err;
 	u8 bus_max;
 	resource_size_t busn;
-	struct resource *bus_range;
-	struct device *dev = pci->host.dev.parent;
+	struct pci_bus *bus = host->bus;
+	struct gen_pci *pci = bus->sysdata;
+	struct resource *bus_range = &bus->busn_res;
+	struct device *dev = host->dev.parent;
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
 		return err;
 	}
 
-	pci->cfg.win = devm_kcalloc(dev, resource_size(&pci->cfg.bus_range),
+	/* Limit the bus-range to fit within reg */
+	bus_max = bus_range->start +
+		  (resource_size(&pci->cfg.res) >> pci->cfg.ops->bus_shift) - 1;
+	pci_bus_update_busn_res_end(bus, min_t(resource_size_t,
+				    bus_range->end, bus_max));
+
+	pci->cfg.win = devm_kcalloc(dev, resource_size(bus_range),
 				    sizeof(*pci->cfg.win), GFP_KERNEL);
 	if (!pci->cfg.win)
 		return -ENOMEM;
 
-	/* Limit the bus-range to fit within reg */
-	bus_max = pci->cfg.bus_range.start +
-		  (resource_size(&pci->cfg.res) >> pci->cfg.ops->bus_shift) - 1;
-	pci->cfg.bus_range.end = min_t(resource_size_t, pci->cfg.bus_range.end,
-				       bus_max);
-
 	/* Map our Configuration Space windows */
 	if (!devm_request_mem_region(dev, pci->cfg.res.start,
 				     resource_size(&pci->cfg.res),
 				     "Configuration Space"))
 		return -ENOMEM;
 
-	bus_range = &pci->cfg.bus_range;
 	for (busn = bus_range->start; busn <= bus_range->end; ++busn) {
 		u32 idx = busn - bus_range->start;
 		u32 sz = 1 << pci->cfg.ops->bus_shift;
@@ -305,34 +176,66 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 			return -ENOMEM;
 	}
 
-	/* Register bus resource */
-	pci_add_resource(&pci->resources, bus_range);
 	return 0;
 }
 
-static int gen_pci_setup(int nr, struct pci_sys_data *sys)
+static int gen_pci_setup(struct pci_host_bridge *host,
+			 resource_size_t io_cpuaddr)
 {
-	struct gen_pci *pci = sys->private_data;
-	list_splice_init(&pci->resources, &sys->resources);
-	return 1;
+	int err;
+	struct pci_host_bridge_window *window;
+	u32 restype, prefetchable;
+	struct device *dev = host->dev.parent;
+	struct resource *iores = NULL;
+	bool res_valid = false;
+
+	list_for_each_entry(window, &host->windows, list) {
+		restype = window->res->flags & IORESOURCE_TYPE_BITS;
+		prefetchable = window->res->flags & IORESOURCE_PREFETCH;
+
+		/*
+		 * Require at least one non-prefetchable MEM resource
+		 */
+		if ((restype == IORESOURCE_MEM) && !prefetchable)
+			res_valid = true;
+
+		if (restype == IORESOURCE_IO)
+			iores = window->res;
+	}
+
+	if (!res_valid) {
+		dev_err(dev, "non-prefetchable memory resource required\n");
+		return -EINVAL;
+	}
+
+	if (iores) {
+		if (!PAGE_ALIGNED(io_cpuaddr))
+			return -EINVAL;
+
+		err = pci_remap_iospace(iores, io_cpuaddr);
+		if (err)
+			return err;
+	}
+
+	/* Parse and map our Configuration Space windows */
+	err = gen_pci_parse_map_cfg_windows(host);
+	if (err)
+		return err;
+
+	pci_add_flags(PCI_ENABLE_PROC_DOMAINS);
+	pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);
+
+	return 0;
 }
 
 static int gen_pci_probe(struct platform_device *pdev)
 {
-	int err;
 	const char *type;
 	const struct of_device_id *of_id;
 	const int *prop;
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct gen_pci *pci = devm_kzalloc(dev, sizeof(*pci), GFP_KERNEL);
-	struct hw_pci hw = {
-		.nr_controllers	= 1,
-		.private_data	= (void **)&pci,
-		.setup		= gen_pci_setup,
-		.map_irq	= of_irq_parse_and_map_pci,
-		.ops		= &gen_pci_ops,
-	};
 
 	if (!pci)
 		return -ENOMEM;
@@ -353,24 +256,9 @@ static int gen_pci_probe(struct platform_device *pdev)
 
 	of_id = of_match_node(gen_pci_of_match, np);
 	pci->cfg.ops = of_id->data;
-	pci->host.dev.parent = dev;
-	INIT_LIST_HEAD(&pci->host.windows);
-	INIT_LIST_HEAD(&pci->resources);
 
-	/* Parse our PCI ranges and request their resources */
-	err = gen_pci_parse_request_of_pci_ranges(pci);
-	if (err)
-		return err;
-
-	/* Parse and map our Configuration Space windows */
-	err = gen_pci_parse_map_cfg_windows(pci);
-	if (err) {
-		gen_pci_release_of_pci_ranges(pci);
-		return err;
-	}
-
-	pci_common_init_dev(dev, &hw);
-	return 0;
+	return of_create_pci_host_bridge(dev, 0, 0xff, &gen_pci_ops,
+					gen_pci_setup, pci);
 }
 
 static struct platform_driver gen_pci_driver = {
-- 
2.0.4

