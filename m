Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbaBRCKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:10:33 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51484 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbaBRCK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:10:28 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: horms@verge.net.au, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk,
        geert@linux-m68k.org, bhelgaas@google.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 18 Feb 2014 11:11:42 +0900
Message-Id: <20140218021142.14164.17124.sendpatchset@w520>
In-Reply-To: <20140218021041.14164.56411.sendpatchset@w520>
References: <20140218021041.14164.56411.sendpatchset@w520>
Subject: [PATCH v2 06/08] PCI: rcar: Add DMABOUNCE support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add DMABOUNCE support together with a local memory area for
all PCI devices hanging off this bridge. 4MiB of memory is
set aside for coherent allocations which is shared between
the on-chip OHCI and EHCI devices that are hanging off the
PCI bridge. With this patch the driver will work for all
CONFIG_VMSPLIT settings.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

Changes since V1:
 - Updated to fit on top of patches by Ben Dooks.
 - Break out code into rcar_pci_init_bounce()

 drivers/pci/host/Kconfig         |    2 
 drivers/pci/host/pci-rcar-gen2.c |  269 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 268 insertions(+), 3 deletions(-)

--- 0001/drivers/pci/host/Kconfig
+++ work/drivers/pci/host/Kconfig	2014-02-13 10:52:48.000000000 +0900
@@ -28,6 +28,8 @@ config PCI_TEGRA
 config PCI_RCAR_GEN2
 	bool "Renesas R-Car Gen2 Internal PCI controller"
 	depends on ARM && (ARCH_R8A7790 || ARCH_R8A7791 || COMPILE_TEST)
+	select GENERIC_ALLOCATOR
+	select DMABOUNCE
 	help
 	  Say Y here if you want internal PCI support on R-Car Gen2 SoC.
 	  There are 3 internal PCI controllers available with a single
--- 0008/drivers/pci/host/pci-rcar-gen2.c
+++ work/drivers/pci/host/pci-rcar-gen2.c	2014-02-13 11:12:38.000000000 +0900
@@ -15,11 +15,14 @@
 #include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/genalloc.h>
 
 /* AHB-PCI Bridge PCI communication registers */
 #define RCAR_AHBPCI_PCICOM_OFFSET	0x800
@@ -100,6 +103,11 @@ struct rcar_pci_priv {
 	struct resource *cfg_res;
 	int irq;
 	unsigned long window_size;
+	u32 window_base;
+	struct notifier_block bus_notifier;
+	struct gen_pool *dma_pool;
+	unsigned long dma_size;
+	dma_addr_t dma_phys;
 };
 
 /* PCI configuration space operations */
@@ -278,8 +286,8 @@ static int __init rcar_pci_setup(int nr,
 	       RCAR_PCI_ARBITER_PCIBP_MODE;
 	iowrite32(val, reg + RCAR_PCI_ARBITER_CTR_REG);
 
-	/* PCI-AHB mapping: 0x40000000 base */
-	iowrite32(0x40000000 | RCAR_PCIAHB_PREFETCH16,
+	/* PCI-AHB mapping: dynamic base */
+	iowrite32(priv->window_base | RCAR_PCIAHB_PREFETCH16,
 		  reg + RCAR_PCIAHB_WIN1_CTR_REG);
 
 	/* AHB-PCI mapping: OHCI/EHCI registers */
@@ -290,7 +298,7 @@ static int __init rcar_pci_setup(int nr,
 	iowrite32(RCAR_AHBPCI_WIN1_HOST | RCAR_AHBPCI_WIN_CTR_CFG,
 		  reg + RCAR_AHBPCI_WIN1_CTR_REG);
 	/* Set PCI-AHB Window1 address */
-	iowrite32(0x40000000 | PCI_BASE_ADDRESS_MEM_PREFETCH,
+	iowrite32(priv->window_base | PCI_BASE_ADDRESS_MEM_PREFETCH,
 		  reg + PCI_BASE_ADDRESS_1);
 	/* Set AHB-PCI bridge PCI communication area address */
 	val = priv->cfg_res->start + RCAR_AHBPCI_PCICOM_OFFSET;
@@ -322,6 +330,235 @@ static struct pci_ops rcar_pci_ops = {
 	.write	= rcar_pci_write_config,
 };
 
+static struct rcar_pci_priv *rcar_pci_dev_to_priv(struct device *dev)
+{
+	struct pci_sys_data *sys = to_pci_dev(dev)->sysdata;
+
+	return sys->private_data;
+}
+
+static void *rcar_pci_dma_alloc(struct device *dev, size_t size,
+				dma_addr_t *handle, gfp_t gfp,
+				struct dma_attrs *attrs)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	return (void *)gen_pool_dma_alloc(p->dma_pool, size, handle);
+}
+
+static void rcar_pci_dma_free(struct device *dev, size_t size, void *cpu_addr,
+			      dma_addr_t handle, struct dma_attrs *attrs)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	gen_pool_free(p->dma_pool, (unsigned long)cpu_addr, size);
+}
+
+static struct dma_map_ops rcar_pci_dma_ops_init = {
+	.alloc = rcar_pci_dma_alloc,
+	.free = rcar_pci_dma_free,
+};
+
+static int rcar_pci_dma_mmap(struct device *dev, struct vm_area_struct *vma,
+			     void *cpu_addr, dma_addr_t dma_addr, size_t size,
+			     struct dma_attrs *attrs)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	return get_dma_ops(p->dev)->mmap(p->dev, vma, cpu_addr,
+					 dma_addr, size, attrs);
+}
+
+static int rcar_pci_dma_get_sgtable(struct device *dev, struct sg_table *sgt,
+				    void *cpu_addr, dma_addr_t handle,
+				    size_t size, struct dma_attrs *attrs)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	return get_dma_ops(p->dev)->get_sgtable(p->dev, sgt, cpu_addr,
+						handle, size, attrs);
+}
+
+static dma_addr_t rcar_pci_dma_map_page(struct device *dev, struct page *page,
+					unsigned long offset, size_t size,
+					enum dma_data_direction dir,
+					struct dma_attrs *attrs)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	return get_dma_ops(p->dev)->map_page(p->dev, page, offset,
+					     size, dir, attrs);
+}
+
+static void rcar_pci_dma_unmap_page(struct device *dev, dma_addr_t dma_handle,
+				    size_t size, enum dma_data_direction dir,
+				    struct dma_attrs *attrs)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	get_dma_ops(p->dev)->unmap_page(p->dev, dma_handle, size, dir, attrs);
+}
+
+static int rcar_pci_dma_map_sg(struct device *dev, struct scatterlist *sg,
+			       int nents, enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	return get_dma_ops(p->dev)->map_sg(p->dev, sg, nents, dir, attrs);
+}
+
+static void rcar_pci_dma_unmap_sg(struct device *dev, struct scatterlist *sg,
+				  int nents, enum dma_data_direction dir,
+				  struct dma_attrs *attrs)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	get_dma_ops(p->dev)->unmap_sg(p->dev, sg, nents, dir, attrs);
+}
+
+static void rcar_pci_dma_sync_single_for_cpu(struct device *dev,
+					     dma_addr_t dma_handle,
+					     size_t size,
+					     enum dma_data_direction dir)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	get_dma_ops(p->dev)->sync_single_for_cpu(p->dev, dma_handle,
+						 size, dir);
+}
+
+static void rcar_pci_dma_sync_single_for_device(struct device *dev,
+						dma_addr_t dma_handle,
+						size_t size,
+						enum dma_data_direction dir)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	get_dma_ops(p->dev)->sync_single_for_device(p->dev, dma_handle,
+						    size, dir);
+}
+
+static void rcar_pci_dma_sync_sg_for_cpu(struct device *dev,
+					 struct scatterlist *sg,
+					 int nents,
+					 enum dma_data_direction dir)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	get_dma_ops(p->dev)->sync_sg_for_cpu(p->dev, sg, nents, dir);
+}
+
+static void rcar_pci_dma_sync_sg_for_device(struct device *dev,
+					    struct scatterlist *sg,
+					    int nents,
+					    enum dma_data_direction dir)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	get_dma_ops(p->dev)->sync_sg_for_device(p->dev, sg, nents, dir);
+}
+
+static int rcar_pci_dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	return get_dma_ops(p->dev)->mapping_error(p->dev, dma_addr);
+}
+
+static int rcar_pci_dma_supported(struct device *dev, u64 mask)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	return get_dma_ops(p->dev)->dma_supported(p->dev, mask);
+}
+
+static int rcar_pci_dma_set_dma_mask(struct device *dev, u64 mask)
+{
+	struct rcar_pci_priv *p = rcar_pci_dev_to_priv(dev);
+
+	return get_dma_ops(p->dev)->set_dma_mask(p->dev, mask);
+}
+
+static struct dma_map_ops rcar_pci_dma_ops = {
+	.alloc = rcar_pci_dma_alloc,
+	.free = rcar_pci_dma_free,
+	.mmap = rcar_pci_dma_mmap,
+	.get_sgtable = rcar_pci_dma_get_sgtable,
+	.map_page = rcar_pci_dma_map_page,
+	.unmap_page = rcar_pci_dma_unmap_page,
+	.map_sg = rcar_pci_dma_map_sg,
+	.unmap_sg = rcar_pci_dma_unmap_sg,
+	.sync_single_for_cpu = rcar_pci_dma_sync_single_for_cpu,
+	.sync_single_for_device = rcar_pci_dma_sync_single_for_device,
+	.sync_sg_for_cpu = rcar_pci_dma_sync_sg_for_cpu,
+	.sync_sg_for_device = rcar_pci_dma_sync_sg_for_device,
+	.mapping_error = rcar_pci_dma_mapping_error,
+	.dma_supported = rcar_pci_dma_supported,
+	.set_dma_mask = rcar_pci_dma_set_dma_mask,
+};
+
+static int rcar_pci_bus_notify(struct notifier_block *nb,
+			       unsigned long action, void *data)
+{
+	struct rcar_pci_priv *priv;
+	struct device *dev = data;
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+	struct pci_sys_data *sys = pci_dev->sysdata;
+
+	priv = container_of(nb, struct rcar_pci_priv, bus_notifier);
+	if (priv != sys->private_data)
+		return 0;
+
+	if (action == BUS_NOTIFY_BIND_DRIVER)
+		set_dma_ops(dev, &rcar_pci_dma_ops);
+
+	return 0;
+}
+
+static void rcar_pci_add_bus(struct pci_bus *bus)
+{
+	struct pci_sys_data *sys = bus->sysdata;
+	struct rcar_pci_priv *priv = sys->private_data;
+
+	bus_register_notifier(&pci_bus_type, &priv->bus_notifier);
+}
+
+static void rcar_pci_remove_bus(struct pci_bus *bus)
+{
+	struct pci_sys_data *sys = bus->sysdata;
+	struct rcar_pci_priv *priv = sys->private_data;
+
+	bus_unregister_notifier(&pci_bus_type, &priv->bus_notifier);
+}
+
+static int rcar_pci_needs_bounce(struct device *dev,
+				 dma_addr_t dma_addr, size_t size)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rcar_pci_priv *priv = platform_get_drvdata(pdev);
+
+	if (dma_addr < priv->window_base)
+		return 1;
+
+	if (dma_addr >= (priv->window_base + priv->window_size))
+		return 1;
+
+	return 0;
+}
+
+static void rcar_pci_init_bounce(struct rcar_pci_priv *priv)
+{
+	/* use notifier to hook pool allocator */
+	priv->bus_notifier.notifier_call = rcar_pci_bus_notify;
+
+	/* setup alloc()/free() to let dmabounce allocate from our pool */
+	set_dma_ops(priv->dev, &rcar_pci_dma_ops_init);
+
+	/* shared dmabounce for the PCI bridge */
+	dmabounce_register_dev(priv->dev, 2048, 4096, rcar_pci_needs_bounce);
+}
+
 static int rcar_pci_probe(struct platform_device *pdev)
 {
 	struct resource *cfg_res, *mem_res;
@@ -329,6 +566,8 @@ static int rcar_pci_probe(struct platfor
 	void __iomem *reg;
 	struct hw_pci hw;
 	void *hw_private[1];
+	void *dma_virt;
+	int ret;
 
 	cfg_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	reg = devm_ioremap_resource(&pdev->dev, cfg_res);
@@ -358,6 +597,7 @@ static int rcar_pci_probe(struct platfor
 	priv->irq = platform_get_irq(pdev, 0);
 	priv->reg = reg;
 	priv->dev = &pdev->dev;
+	platform_set_drvdata(pdev, priv);
 
 	if (priv->irq < 0) {
 		dev_err(&pdev->dev, "no valid irq found\n");
@@ -365,6 +605,27 @@ static int rcar_pci_probe(struct platfor
 	}
 
 	priv->window_size = SZ_1G;
+	priv->dma_size = SZ_4M;
+
+	/* allocate pool of memory guaranteed to be inside window */
+	priv->dma_pool = devm_gen_pool_create(&pdev->dev, 7, -1);
+	if (!priv->dma_pool)
+		return -ENOMEM;
+
+	dma_virt = dmam_alloc_coherent(&pdev->dev, priv->dma_size,
+				       &priv->dma_phys, GFP_KERNEL);
+	if (!dma_virt)
+		return -ENOMEM;
+
+	ret = gen_pool_add_virt(priv->dma_pool,	(unsigned long)dma_virt,
+				priv->dma_phys, priv->dma_size, -1);
+	if (ret)
+		return ret;
+
+	/* select window base address based on physical address for memory */
+	priv->window_base = priv->dma_phys & ~(priv->window_size - 1);
+
+	rcar_pci_init_bounce(priv);
 
 	hw_private[0] = priv;
 	memset(&hw, 0, sizeof(hw));
@@ -373,6 +634,8 @@ static int rcar_pci_probe(struct platfor
 	hw.map_irq = rcar_pci_map_irq;
 	hw.ops = &rcar_pci_ops;
 	hw.setup = rcar_pci_setup;
+	hw.add_bus = rcar_pci_add_bus;
+	hw.remove_bus = rcar_pci_remove_bus;
 	pci_common_init_dev(&pdev->dev, &hw);
 	return 0;
 }
