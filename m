Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaF0QP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:15:59 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35040 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaF0QP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:15:56 -0400
Message-ID: <53AD98B9.2020109@gmail.com>
Date: Fri, 27 Jun 2014 11:15:53 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jon Masters <jonathan@jonmasters.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v7 1/6] pci: Introduce pci_register_io_range() helper
 function.
References: <1394811272-1547-1-git-send-email-Liviu.Dudau@arm.com> <20140626085926.GB11244@arm.com> <CAL_JsqKCHf6VXR3FFcBSu1xuhP54dYsAJCZwT-X9p5iTZAOJfQ@mail.gmail.com> <6381366.2IfqZj1r0B@wuerfel> <20140627124949.GR26276@arm.com>
In-Reply-To: <20140627124949.GR26276@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 07:49 AM, Will Deacon wrote:
> On Fri, Jun 27, 2014 at 12:03:34PM +0100, Arnd Bergmann wrote:
>> On Thursday 26 June 2014 19:44:21 Rob Herring wrote:
>>> I don't agree arm32 is harder than microblaze. Yes, converting ALL of
>>> arm would be, but that is not necessary. With Liviu's latest branch
>>> the hacks I previously needed are gone (thanks!), and this is all I
>>> need to get Versatile PCI working (under QEMU):
>>
>> I meant converting all of arm32 would be harder, but I agree we don't
>> have to do it. It would be nice to convert all of the drivers/pci/host
>> drivers though, iow all multiplatform-enabled ones, and leaving the
>> current arm32 pci implementation for the platforms we don't want to
>> convert to multiplatform anyway (footbridge, iop, ixp4xx, ks8695 (?),
>> pxa, sa1100).
> 
> I'm more than happy to convert the generic host controller we merged
> recently, but I'd probably want the core changes merged first so that I
> know I'm not wasting my time!

Something like this untested patch...

Another issue I found still present is pci_ioremap_io needs some work 
to unify with the arm implementation. That's a matter of changing the 
function from an offset to i/o resource. That should be a pretty 
mechanical change.

Also, there is a potential for memory leak because there is no undo 
for of_create_pci_host_bridge.

Rob

8<------------------------------------------------------------------
>From 301b402631b2867ced38d5533586da0bd888045c Mon Sep 17 00:00:00 2001
From: Rob Herring <robh@kernel.org>
Date: Fri, 27 Jun 2014 09:46:09 -0500
Subject: [PATCH] pci: generic-host: refactor to use common range parsing

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/pci/host/pci-host-generic.c | 191 ++++++------------------------------
 1 file changed, 29 insertions(+), 162 deletions(-)

diff --git a/drivers/pci/host/pci-host-generic.c b/drivers/pci/host/pci-host-generic.c
index 44fe6aa..57fd1e1 100644
--- a/drivers/pci/host/pci-host-generic.c
+++ b/drivers/pci/host/pci-host-generic.c
@@ -32,16 +32,14 @@ struct gen_pci_cfg_bus_ops {
 
 struct gen_pci_cfg_windows {
 	struct resource				res;
-	struct resource				bus_range;
 	void __iomem				**win;
 
 	const struct gen_pci_cfg_bus_ops	*ops;
 };
 
 struct gen_pci {
-	struct pci_host_bridge			host;
+	struct pci_host_bridge			*host;
 	struct gen_pci_cfg_windows		cfg;
-	struct list_head			resources;
 };
 
 static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
@@ -50,7 +48,7 @@ static void __iomem *gen_pci_map_cfg_bus_cam(struct pci_bus *bus,
 {
 	struct pci_sys_data *sys = bus->sysdata;
 	struct gen_pci *pci = sys->private_data;
-	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
+	resource_size_t idx = bus->number - bus->busn_res.start;
 
 	return pci->cfg.win[idx] + ((devfn << 8) | where);
 }
@@ -66,7 +64,7 @@ static void __iomem *gen_pci_map_cfg_bus_ecam(struct pci_bus *bus,
 {
 	struct pci_sys_data *sys = bus->sysdata;
 	struct gen_pci *pci = sys->private_data;
-	resource_size_t idx = bus->number - pci->cfg.bus_range.start;
+	resource_size_t idx = bus->number - bus->busn_res.start;
 
 	return pci->cfg.win[idx] + ((devfn << 12) | where);
 }
@@ -138,154 +136,32 @@ static const struct of_device_id gen_pci_of_match[] = {
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
 static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 {
 	int err;
 	u8 bus_max;
 	resource_size_t busn;
-	struct resource *bus_range;
-	struct device *dev = pci->host.dev.parent;
+	struct pci_bus *bus = pci->host->bus;
+	struct resource *bus_range = &bus->busn_res;
+	struct device *dev = pci->host->dev.parent;
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
+	pci->cfg.win = devm_kcalloc(dev, resource_size(bus_range),
 				    sizeof(*pci->cfg.win), GFP_KERNEL);
 	if (!pci->cfg.win)
 		return -ENOMEM;
 
 	/* Limit the bus-range to fit within reg */
-	bus_max = pci->cfg.bus_range.start +
+	bus_max = bus_range->start +
 		  (resource_size(&pci->cfg.res) >> pci->cfg.ops->bus_shift) - 1;
-	pci->cfg.bus_range.end = min_t(resource_size_t, pci->cfg.bus_range.end,
-				       bus_max);
+	pci_bus_update_busn_res_end(bus, min_t(resource_size_t,
+				    bus_range->end, bus_max));
 
 	/* Map our Configuration Space windows */
 	if (!devm_request_mem_region(dev, pci->cfg.res.start,
@@ -293,7 +169,6 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 				     "Configuration Space"))
 		return -ENOMEM;
 
-	bus_range = &pci->cfg.bus_range;
 	for (busn = bus_range->start; busn <= bus_range->end; ++busn) {
 		u32 idx = busn - bus_range->start;
 		u32 sz = 1 << pci->cfg.ops->bus_shift;
@@ -305,34 +180,21 @@ static int gen_pci_parse_map_cfg_windows(struct gen_pci *pci)
 			return -ENOMEM;
 	}
 
-	/* Register bus resource */
-	pci_add_resource(&pci->resources, bus_range);
 	return 0;
 }
 
-static int gen_pci_setup(int nr, struct pci_sys_data *sys)
-{
-	struct gen_pci *pci = sys->private_data;
-	list_splice_init(&pci->resources, &sys->resources);
-	return 1;
-}
+/* Unused, temporary to satisfy ARM arch code */
+static struct pci_sys_data sys;
 
 static int gen_pci_probe(struct platform_device *pdev)
 {
-	int err;
+	int err, lastbus;
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
@@ -353,23 +215,28 @@ static int gen_pci_probe(struct platform_device *pdev)
 
 	of_id = of_match_node(gen_pci_of_match, np);
 	pci->cfg.ops = of_id->data;
-	pci->host.dev.parent = dev;
-	INIT_LIST_HEAD(&pci->host.windows);
-	INIT_LIST_HEAD(&pci->resources);
 
-	/* Parse our PCI ranges and request their resources */
-	err = gen_pci_parse_request_of_pci_ranges(pci);
-	if (err)
-		return err;
+	pci->host = of_create_pci_host_bridge(&pdev->dev, &gen_pci_ops, &sys);
+	if (PTR_ERR(pci->host))
+		return PTR_ERR(pci->host);
 
 	/* Parse and map our Configuration Space windows */
 	err = gen_pci_parse_map_cfg_windows(pci);
-	if (err) {
-		gen_pci_release_of_pci_ranges(pci);
+	if (err)
 		return err;
-	}
 
-	pci_common_init_dev(dev, &hw);
+	pci_ioremap_io(0, pci->host->io_base);
+
+	pci_add_flags(PCI_ENABLE_PROC_DOMAINS);
+	pci_add_flags(PCI_REASSIGN_ALL_BUS | PCI_REASSIGN_ALL_RSRC);
+
+	lastbus = pci_scan_child_bus(pci->host->bus);
+	pci_bus_update_busn_res_end(pci->host->bus, lastbus);
+
+	pci_assign_unassigned_bus_resources(pci->host->bus);
+
+	pci_bus_add_devices(pci->host->bus);
+
 	return 0;
 }
 
-- 
1.9.1

