Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaBQGSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 01:18:02 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:8622 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaBQGR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 01:17:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 16 Feb 2014 22:15:49 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>
Subject: [PATCH v3] drm/nouveau: support for platform devices
Date: Mon, 17 Feb 2014 15:17:26 +0900
Message-ID: <1392617846-13978-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <52FC2798.8030901@nvidia.com>
References: <52FC2798.8030901@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcoming mobile Kepler GPUs (such as GK20A) use the platform bus instead
of PCI to which Nouveau is tightly dependent. This patch allows Nouveau
to handle platform devices by:

- abstracting PCI-dependent functions that were typically used for
  resource querying and page mapping,
- introducing a nv_device_is_pci() function that allows to make
  PCI-dependent code conditional,
- providing a nouveau_drm_platform_probe() function that takes a GPU
  platform device to be probed.

Core code as well as engine/subdev drivers are updated wherever possible
to make use of these functions. Some older drivers are too dependent on
PCI to be properly updated, but all newer code on which future chips may
depend should at least be runnable with platform devices.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Changes since v2:
- Moved MSI code under PCI-conditioned blocks in mc/base.c, as suggested by
  Emil Velikov. This makes more sense with respect to how MSI is used and
  allows us to get rid of a couple extra conditional statements.

 drivers/gpu/drm/nouveau/core/engine/device/base.c  | 83 ++++++++++++++++++++--
 drivers/gpu/drm/nouveau/core/engine/falcon.c       |  6 +-
 drivers/gpu/drm/nouveau/core/engine/fifo/base.c    |  2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv20.c   |  2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.c   |  2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  4 +-
 drivers/gpu/drm/nouveau/core/engine/xtensa.c       |  2 +-
 drivers/gpu/drm/nouveau/core/include/core/device.h | 30 ++++++++
 .../gpu/drm/nouveau/core/include/engine/device.h   | 17 +++--
 drivers/gpu/drm/nouveau/core/include/subdev/mc.h   |  1 +
 drivers/gpu/drm/nouveau/core/os.h                  |  1 +
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |  4 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c     |  4 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     | 15 ++--
 .../gpu/drm/nouveau/core/subdev/devinit/fbmem.h    |  8 ++-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c      |  9 +--
 drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c      |  9 +--
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c     |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c |  7 +-
 drivers/gpu/drm/nouveau/core/subdev/mc/base.c      | 55 ++++++++------
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c     |  2 +-
 drivers/gpu/drm/nouveau/nouveau_abi16.c            | 13 +++-
 drivers/gpu/drm/nouveau/nouveau_agp.c              |  2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |  4 ++
 drivers/gpu/drm/nouveau/nouveau_bo.c               | 22 +++---
 drivers/gpu/drm/nouveau/nouveau_chan.c             |  2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c          |  3 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              | 59 ++++++++++++---
 drivers/gpu/drm/nouveau/nouveau_sysfs.c            |  8 ++-
 drivers/gpu/drm/nouveau/nouveau_ttm.c              | 31 ++++----
 drivers/gpu/drm/nouveau/nouveau_vga.c              |  5 ++
 35 files changed, 306 insertions(+), 116 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/device/base.c b/drivers/gpu/drm/nouveau/core/engine/device/base.c
index dd01c6c435d6..8a8f5f2d0eb5 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/base.c
@@ -131,8 +131,8 @@ nouveau_devobj_ctor(struct nouveau_object *parent,
 	if (ret)
 		return ret;
 
-	mmio_base = pci_resource_start(device->pdev, 0);
-	mmio_size = pci_resource_len(device->pdev, 0);
+	mmio_base = nv_device_resource_start(device, 0);
+	mmio_size = nv_device_resource_len(device, 0);
 
 	/* translate api disable mask into internal mapping */
 	disable = args->debug0;
@@ -446,6 +446,72 @@ nouveau_device_dtor(struct nouveau_object *object)
 	nouveau_engine_destroy(&device->base);
 }
 
+resource_size_t
+nv_device_resource_start(struct nouveau_device *device, unsigned int bar)
+{
+	if (nv_device_is_pci(device)) {
+		return pci_resource_start(device->pdev, bar);
+	} else {
+		struct resource *res;
+		res = platform_get_resource(device->platformdev,
+					    IORESOURCE_MEM, bar);
+		if (!res)
+			return 0;
+		return res->start;
+	}
+}
+
+resource_size_t
+nv_device_resource_len(struct nouveau_device *device, unsigned int bar)
+{
+	if (nv_device_is_pci(device)) {
+		return pci_resource_len(device->pdev, bar);
+	} else {
+		struct resource *res;
+		res = platform_get_resource(device->platformdev,
+					    IORESOURCE_MEM, bar);
+		if (!res)
+			return 0;
+		return resource_size(res);
+	}
+}
+
+dma_addr_t
+nv_device_map_page(struct nouveau_device *device, struct page *page)
+{
+	dma_addr_t ret;
+
+	if (nv_device_is_pci(device)) {
+		ret = pci_map_page(device->pdev, page, 0, PAGE_SIZE,
+				   PCI_DMA_BIDIRECTIONAL);
+		if (pci_dma_mapping_error(device->pdev, ret))
+			ret = 0;
+	} else {
+		ret = page_to_phys(page);
+	}
+
+	return ret;
+}
+
+void
+nv_device_unmap_page(struct nouveau_device *device, dma_addr_t addr)
+{
+	if (nv_device_is_pci(device))
+		pci_unmap_page(device->pdev, addr, PAGE_SIZE,
+			       PCI_DMA_BIDIRECTIONAL);
+}
+
+int
+nv_device_get_irq(struct nouveau_device *device, bool stall)
+{
+	if (nv_device_is_pci(device)) {
+		return device->pdev->irq;
+	} else {
+		return platform_get_irq_byname(device->platformdev,
+					       stall ? "stall" : "nonstall");
+	}
+}
+
 static struct nouveau_oclass
 nouveau_device_oclass = {
 	.handle = NV_ENGINE(DEVICE, 0x00),
@@ -457,8 +523,8 @@ nouveau_device_oclass = {
 };
 
 int
-nouveau_device_create_(struct pci_dev *pdev, u64 name, const char *sname,
-		       const char *cfg, const char *dbg,
+nouveau_device_create_(void *dev, enum nv_bus_type type, u64 name,
+		       const char *sname, const char *cfg, const char *dbg,
 		       int length, void **pobject)
 {
 	struct nouveau_device *device;
@@ -476,7 +542,14 @@ nouveau_device_create_(struct pci_dev *pdev, u64 name, const char *sname,
 	if (ret)
 		goto done;
 
-	device->pdev = pdev;
+	switch (type) {
+	case NOUVEAU_BUS_PCI:
+		device->pdev = dev;
+		break;
+	case NOUVEAU_BUS_PLATFORM:
+		device->platformdev = dev;
+		break;
+	}
 	device->handle = name;
 	device->cfgopt = cfg;
 	device->dbgopt = dbg;
diff --git a/drivers/gpu/drm/nouveau/core/engine/falcon.c b/drivers/gpu/drm/nouveau/core/engine/falcon.c
index 5e077e4ed7f6..2914646c8709 100644
--- a/drivers/gpu/drm/nouveau/core/engine/falcon.c
+++ b/drivers/gpu/drm/nouveau/core/engine/falcon.c
@@ -119,7 +119,7 @@ _nouveau_falcon_init(struct nouveau_object *object)
 		snprintf(name, sizeof(name), "nouveau/nv%02x_fuc%03x",
 			 device->chipset, falcon->addr >> 12);
 
-		ret = request_firmware(&fw, name, &device->pdev->dev);
+		ret = request_firmware(&fw, name, nv_device_base(device));
 		if (ret == 0) {
 			falcon->code.data = vmemdup(fw->data, fw->size);
 			falcon->code.size = fw->size;
@@ -138,7 +138,7 @@ _nouveau_falcon_init(struct nouveau_object *object)
 		snprintf(name, sizeof(name), "nouveau/nv%02x_fuc%03xd",
 			 device->chipset, falcon->addr >> 12);
 
-		ret = request_firmware(&fw, name, &device->pdev->dev);
+		ret = request_firmware(&fw, name, nv_device_base(device));
 		if (ret) {
 			nv_error(falcon, "unable to load firmware data\n");
 			return ret;
@@ -153,7 +153,7 @@ _nouveau_falcon_init(struct nouveau_object *object)
 		snprintf(name, sizeof(name), "nouveau/nv%02x_fuc%03xc",
 			 device->chipset, falcon->addr >> 12);
 
-		ret = request_firmware(&fw, name, &device->pdev->dev);
+		ret = request_firmware(&fw, name, nv_device_base(device));
 		if (ret) {
 			nv_error(falcon, "unable to load firmware code\n");
 			return ret;
diff --git a/drivers/gpu/drm/nouveau/core/engine/fifo/base.c b/drivers/gpu/drm/nouveau/core/engine/fifo/base.c
index d3ec436d9cb5..6f9041ced9a2 100644
--- a/drivers/gpu/drm/nouveau/core/engine/fifo/base.c
+++ b/drivers/gpu/drm/nouveau/core/engine/fifo/base.c
@@ -86,7 +86,7 @@ nouveau_fifo_channel_create_(struct nouveau_object *parent,
 	}
 
 	/* map fifo control registers */
-	chan->user = ioremap(pci_resource_start(device->pdev, bar) + addr +
+	chan->user = ioremap(nv_device_resource_start(device, bar) + addr +
 			     (chan->chid * size), size);
 	if (!chan->user)
 		return -EFAULT;
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c b/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c
index b24559315903..d145e080899a 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nv20.c
@@ -349,7 +349,7 @@ nv20_graph_init(struct nouveau_object *object)
 	nv_wr32(priv, NV10_PGRAPH_SURFACE, tmp);
 
 	/* begin RAM config */
-	vramsz = pci_resource_len(nv_device(priv)->pdev, 0) - 1;
+	vramsz = nv_device_resource_len(nv_device(priv), 0) - 1;
 	nv_wr32(priv, 0x4009A4, nv_rd32(priv, 0x100200));
 	nv_wr32(priv, 0x4009A8, nv_rd32(priv, 0x100204));
 	nv_wr32(priv, NV10_PGRAPH_RDI_INDEX, 0x00EA0000);
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nv40.c b/drivers/gpu/drm/nouveau/core/engine/graph/nv40.c
index 193a5de1b482..6477fbf6a550 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nv40.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nv40.c
@@ -484,7 +484,7 @@ nv40_graph_init(struct nouveau_object *object)
 		engine->tile_prog(engine, i);
 
 	/* begin RAM config */
-	vramsz = pci_resource_len(nv_device(priv)->pdev, 0) - 1;
+	vramsz = nv_device_resource_len(nv_device(priv), 0) - 1;
 	switch (nv_device(priv)->chipset) {
 	case 0x40:
 		nv_wr32(priv, 0x4009A4, nv_rd32(priv, 0x100200));
diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
index a73ab209ea88..6ef8bf181b2d 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
@@ -1091,10 +1091,10 @@ nvc0_graph_ctor_fw(struct nvc0_graph_priv *priv, const char *fwname,
 	int ret;
 
 	snprintf(f, sizeof(f), "nouveau/nv%02x_%s", device->chipset, fwname);
-	ret = request_firmware(&fw, f, &device->pdev->dev);
+	ret = request_firmware(&fw, f, nv_device_base(device));
 	if (ret) {
 		snprintf(f, sizeof(f), "nouveau/%s", fwname);
-		ret = request_firmware(&fw, f, &device->pdev->dev);
+		ret = request_firmware(&fw, f, nv_device_base(device));
 		if (ret) {
 			nv_error(priv, "failed to load %s\n", fwname);
 			return ret;
diff --git a/drivers/gpu/drm/nouveau/core/engine/xtensa.c b/drivers/gpu/drm/nouveau/core/engine/xtensa.c
index 5f6ede7c4892..92384759d2f5 100644
--- a/drivers/gpu/drm/nouveau/core/engine/xtensa.c
+++ b/drivers/gpu/drm/nouveau/core/engine/xtensa.c
@@ -112,7 +112,7 @@ _nouveau_xtensa_init(struct nouveau_object *object)
 		snprintf(name, sizeof(name), "nouveau/nv84_xuc%03x",
 			 xtensa->addr >> 12);
 
-		ret = request_firmware(&fw, name, &device->pdev->dev);
+		ret = request_firmware(&fw, name, nv_device_base(device));
 		if (ret) {
 			nv_warn(xtensa, "unable to load firmware %s\n", name);
 			return ret;
diff --git a/drivers/gpu/drm/nouveau/core/include/core/device.h b/drivers/gpu/drm/nouveau/core/include/core/device.h
index 7b8ea221b00d..2a3e24e1d392 100644
--- a/drivers/gpu/drm/nouveau/core/include/core/device.h
+++ b/drivers/gpu/drm/nouveau/core/include/core/device.h
@@ -65,6 +65,7 @@ struct nouveau_device {
 	struct list_head head;
 
 	struct pci_dev *pdev;
+	struct platform_device *platformdev;
 	u64 handle;
 
 	const char *cfgopt;
@@ -140,4 +141,33 @@ nv_device_match(struct nouveau_object *object, u16 dev, u16 ven, u16 sub)
 	       device->pdev->subsystem_device == sub;
 }
 
+static inline bool
+nv_device_is_pci(struct nouveau_device *device)
+{
+	return device->pdev != NULL;
+}
+
+static inline struct device *
+nv_device_base(struct nouveau_device *device)
+{
+	return nv_device_is_pci(device) ? &device->pdev->dev :
+					  &device->platformdev->dev;
+}
+
+resource_size_t
+nv_device_resource_start(struct nouveau_device *device, unsigned int bar);
+
+resource_size_t
+nv_device_resource_len(struct nouveau_device *device, unsigned int bar);
+
+dma_addr_t
+nv_device_map_page(struct nouveau_device *device, struct page *page);
+
+void
+nv_device_unmap_page(struct nouveau_device *device, dma_addr_t addr);
+
+int
+nv_device_get_irq(struct nouveau_device *device, bool stall);
+
 #endif
+
diff --git a/drivers/gpu/drm/nouveau/core/include/engine/device.h b/drivers/gpu/drm/nouveau/core/include/engine/device.h
index b3dd2c4c2f1e..00c2f4f2dd2f 100644
--- a/drivers/gpu/drm/nouveau/core/include/engine/device.h
+++ b/drivers/gpu/drm/nouveau/core/include/engine/device.h
@@ -3,11 +3,20 @@
 
 #include <core/device.h>
 
-#define nouveau_device_create(p,n,s,c,d,u)                                     \
-	nouveau_device_create_((p), (n), (s), (c), (d), sizeof(**u), (void **)u)
+struct platform_device;
 
-int  nouveau_device_create_(struct pci_dev *, u64 name, const char *sname,
-			    const char *cfg, const char *dbg, int, void **);
+enum nv_bus_type {
+	NOUVEAU_BUS_PCI,
+	NOUVEAU_BUS_PLATFORM,
+};
+
+#define nouveau_device_create(p,t,n,s,c,d,u)                                   \
+	nouveau_device_create_((void *)(p), (t), (n), (s), (c), (d),           \
+			       sizeof(**u), (void **)u)
+
+int  nouveau_device_create_(void *, enum nv_bus_type type, u64 name,
+			    const char *sname, const char *cfg, const char *dbg,
+			    int, void **);
 
 int nv04_identify(struct nouveau_device *);
 int nv10_identify(struct nouveau_device *);
diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/mc.h b/drivers/gpu/drm/nouveau/core/include/subdev/mc.h
index adc88b73d911..7c551b59038f 100644
--- a/drivers/gpu/drm/nouveau/core/include/subdev/mc.h
+++ b/drivers/gpu/drm/nouveau/core/include/subdev/mc.h
@@ -12,6 +12,7 @@ struct nouveau_mc_intr {
 struct nouveau_mc {
 	struct nouveau_subdev base;
 	bool use_msi;
+	unsigned int irq;
 };
 
 static inline struct nouveau_mc *
diff --git a/drivers/gpu/drm/nouveau/core/os.h b/drivers/gpu/drm/nouveau/core/os.h
index 191e739f30d1..90a6c904db5b 100644
--- a/drivers/gpu/drm/nouveau/core/os.h
+++ b/drivers/gpu/drm/nouveau/core/os.h
@@ -5,6 +5,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/pci.h>
+#include <linux/platform_device.h>
 #include <linux/printk.h>
 #include <linux/bitops.h>
 #include <linux/firmware.h>
diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
index 7098ddd54678..bdf594116f3f 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/base.c
@@ -118,8 +118,8 @@ nouveau_bar_create_(struct nouveau_object *parent,
 	if (ret)
 		return ret;
 
-	bar->iomem = ioremap(pci_resource_start(device->pdev, 3),
-			     pci_resource_len(device->pdev, 3));
+	bar->iomem = ioremap(nv_device_resource_start(device, 3),
+			     nv_device_resource_len(device, 3));
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c b/drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c
index 090d594a21b3..baa2b62bd40f 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/nv50.c
@@ -139,7 +139,7 @@ nv50_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 
 	/* BAR3 */
 	start = 0x0100000000ULL;
-	limit = start + pci_resource_len(device->pdev, 3);
+	limit = start + nv_device_resource_len(device, 3);
 
 	ret = nouveau_vm_new(device, start, limit, start, &vm);
 	if (ret)
@@ -173,7 +173,7 @@ nv50_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 
 	/* BAR1 */
 	start = 0x0000000000ULL;
-	limit = start + pci_resource_len(device->pdev, 1);
+	limit = start + nv_device_resource_len(device, 1);
 
 	ret = nouveau_vm_new(device, start, limit--, start, &vm);
 	if (ret)
diff --git a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
index bac5e754de35..3f30db62e656 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c
@@ -84,7 +84,6 @@ nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	      struct nouveau_object **pobject)
 {
 	struct nouveau_device *device = nv_device(parent);
-	struct pci_dev *pdev = device->pdev;
 	struct nvc0_bar_priv *priv;
 	struct nouveau_gpuobj *mem;
 	struct nouveau_vm *vm;
@@ -107,14 +106,14 @@ nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	if (ret)
 		return ret;
 
-	ret = nouveau_vm_new(device, 0, pci_resource_len(pdev, 3), 0, &vm);
+	ret = nouveau_vm_new(device, 0, nv_device_resource_len(device, 3), 0, &vm);
 	if (ret)
 		return ret;
 
 	atomic_inc(&vm->engref[NVDEV_SUBDEV_BAR]);
 
 	ret = nouveau_gpuobj_new(nv_object(priv), NULL,
-				 (pci_resource_len(pdev, 3) >> 12) * 8,
+				 (nv_device_resource_len(device, 3) >> 12) * 8,
 				 0x1000, NVOBJ_FLAG_ZERO_ALLOC,
 				 &vm->pgt[0].obj[0]);
 	vm->pgt[0].refcount[0] = 1;
@@ -128,8 +127,8 @@ nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 
 	nv_wo32(mem, 0x0200, lower_32_bits(priv->bar[0].pgd->addr));
 	nv_wo32(mem, 0x0204, upper_32_bits(priv->bar[0].pgd->addr));
-	nv_wo32(mem, 0x0208, lower_32_bits(pci_resource_len(pdev, 3) - 1));
-	nv_wo32(mem, 0x020c, upper_32_bits(pci_resource_len(pdev, 3) - 1));
+	nv_wo32(mem, 0x0208, lower_32_bits(nv_device_resource_len(device, 3) - 1));
+	nv_wo32(mem, 0x020c, upper_32_bits(nv_device_resource_len(device, 3) - 1));
 
 	/* BAR1 */
 	ret = nouveau_gpuobj_new(nv_object(priv), NULL, 0x1000, 0, 0,
@@ -143,7 +142,7 @@ nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	if (ret)
 		return ret;
 
-	ret = nouveau_vm_new(device, 0, pci_resource_len(pdev, 1), 0, &vm);
+	ret = nouveau_vm_new(device, 0, nv_device_resource_len(device, 1), 0, &vm);
 	if (ret)
 		return ret;
 
@@ -156,8 +155,8 @@ nvc0_bar_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 
 	nv_wo32(mem, 0x0200, lower_32_bits(priv->bar[1].pgd->addr));
 	nv_wo32(mem, 0x0204, upper_32_bits(priv->bar[1].pgd->addr));
-	nv_wo32(mem, 0x0208, lower_32_bits(pci_resource_len(pdev, 1) - 1));
-	nv_wo32(mem, 0x020c, upper_32_bits(pci_resource_len(pdev, 1) - 1));
+	nv_wo32(mem, 0x0208, lower_32_bits(nv_device_resource_len(device, 1) - 1));
+	nv_wo32(mem, 0x020c, upper_32_bits(nv_device_resource_len(device, 1) - 1));
 
 	priv->base.alloc = nouveau_bar_alloc;
 	priv->base.kmap = nvc0_bar_kmap;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/devinit/fbmem.h b/drivers/gpu/drm/nouveau/core/subdev/devinit/fbmem.h
index 6b56a0f4cb40..4fe49cf4c99a 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/devinit/fbmem.h
+++ b/drivers/gpu/drm/nouveau/core/subdev/devinit/fbmem.h
@@ -24,6 +24,8 @@
  *
  */
 
+#include <core/device.h>
+
 #define NV04_PFB_BOOT_0						0x00100000
 #	define NV04_PFB_BOOT_0_RAM_AMOUNT			0x00000003
 #	define NV04_PFB_BOOT_0_RAM_AMOUNT_32MB			0x00000000
@@ -60,10 +62,10 @@
 #	define NV10_PFB_REFCTRL_VALID_1				(1 << 31)
 
 static inline struct io_mapping *
-fbmem_init(struct pci_dev *pdev)
+fbmem_init(struct nouveau_device *dev)
 {
-	return io_mapping_create_wc(pci_resource_start(pdev, 1),
-				    pci_resource_len(pdev, 1));
+	return io_mapping_create_wc(nv_device_resource_start(dev, 1),
+				    nv_device_resource_len(dev, 1));
 }
 
 static inline void
diff --git a/drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c b/drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c
index 7037eae46e44..052ad690b468 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/devinit/nv04.c
@@ -38,7 +38,7 @@ nv04_devinit_meminit(struct nouveau_devinit *devinit)
 	int i;
 
 	/* Map the framebuffer aperture */
-	fb = fbmem_init(nv_device(priv)->pdev);
+	fb = fbmem_init(nv_device(priv));
 	if (!fb) {
 		nv_error(priv, "failed to map fb\n");
 		return;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c b/drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c
index 98b7e6780dc7..4a19c10e5178 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/devinit/nv05.c
@@ -53,7 +53,7 @@ nv05_devinit_meminit(struct nouveau_devinit *devinit)
 	int i, v;
 
 	/* Map the framebuffer aperture */
-	fb = fbmem_init(nv_device(priv)->pdev);
+	fb = fbmem_init(nv_device(priv));
 	if (!fb) {
 		nv_error(priv, "failed to map fb\n");
 		return;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c b/drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c
index 32b3d2131a7f..3b8d657da279 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/devinit/nv10.c
@@ -46,7 +46,7 @@ nv10_devinit_meminit(struct nouveau_devinit *devinit)
 		mem_width_count = 2;
 
 	/* Map the framebuffer aperture */
-	fb = fbmem_init(nv_device(priv)->pdev);
+	fb = fbmem_init(nv_device(priv));
 	if (!fb) {
 		nv_error(priv, "failed to map fb\n");
 		return;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c b/drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c
index 4689ba303b0b..04bc9732644c 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/devinit/nv20.c
@@ -37,7 +37,7 @@ nv20_devinit_meminit(struct nouveau_devinit *devinit)
 	struct io_mapping *fb;
 
 	/* Map the framebuffer aperture */
-	fb = fbmem_init(nv_device(priv)->pdev);
+	fb = fbmem_init(nv_device(priv));
 	if (!fb) {
 		nv_error(priv, "failed to map fb\n");
 		return;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c b/drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c
index cbc7f00c1278..1fc55c1e91a1 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c
@@ -250,10 +250,8 @@ nv50_fb_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 
 	priv->r100c08_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (priv->r100c08_page) {
-		priv->r100c08 = pci_map_page(device->pdev, priv->r100c08_page,
-					     0, PAGE_SIZE,
-					     PCI_DMA_BIDIRECTIONAL);
-		if (pci_dma_mapping_error(device->pdev, priv->r100c08))
+		priv->r100c08 = nv_device_map_page(device, priv->r100c08_page);
+		if (!priv->r100c08)
 			nv_warn(priv, "failed 0x100c08 page map\n");
 	} else {
 		nv_warn(priv, "failed 0x100c08 page alloc\n");
@@ -270,8 +268,7 @@ nv50_fb_dtor(struct nouveau_object *object)
 	struct nv50_fb_priv *priv = (void *)object;
 
 	if (priv->r100c08_page) {
-		pci_unmap_page(device->pdev, priv->r100c08, PAGE_SIZE,
-			       PCI_DMA_BIDIRECTIONAL);
+		nv_device_unmap_page(device, priv->r100c08);
 		__free_page(priv->r100c08_page);
 	}
 
diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
index 45470e1f0385..0670ae33ee45 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/nvc0.c
@@ -70,8 +70,7 @@ nvc0_fb_dtor(struct nouveau_object *object)
 	struct nvc0_fb_priv *priv = (void *)object;
 
 	if (priv->r100c10_page) {
-		pci_unmap_page(device->pdev, priv->r100c10, PAGE_SIZE,
-			       PCI_DMA_BIDIRECTIONAL);
+		nv_device_unmap_page(device, priv->r100c10);
 		__free_page(priv->r100c10_page);
 	}
 
@@ -94,10 +93,8 @@ nvc0_fb_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 
 	priv->r100c10_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (priv->r100c10_page) {
-		priv->r100c10 = pci_map_page(device->pdev, priv->r100c10_page,
-					     0, PAGE_SIZE,
-					     PCI_DMA_BIDIRECTIONAL);
-		if (pci_dma_mapping_error(device->pdev, priv->r100c10))
+		priv->r100c10 = nv_device_map_page(device, priv->r100c10_page);
+		if (!priv->r100c10)
 			return -EFAULT;
 	}
 
diff --git a/drivers/gpu/drm/nouveau/core/subdev/i2c/base.c b/drivers/gpu/drm/nouveau/core/subdev/i2c/base.c
index c33c03d2f4af..378e05b88e6f 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/i2c/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/i2c/base.c
@@ -111,7 +111,7 @@ nouveau_i2c_port_create_(struct nouveau_object *parent,
 	snprintf(port->adapter.name, sizeof(port->adapter.name),
 		 "nouveau-%s-%d", device->name, index);
 	port->adapter.owner = THIS_MODULE;
-	port->adapter.dev.parent = &device->pdev->dev;
+	port->adapter.dev.parent = nv_device_base(device);
 	port->index = index;
 	port->func = func;
 	i2c_set_adapdata(&port->adapter, i2c);
diff --git a/drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c b/drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c
index ec0b9661d614..8803809f9fc5 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/instmem/nv40.c
@@ -50,7 +50,6 @@ nv40_instmem_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 		  struct nouveau_object **pobject)
 {
 	struct nouveau_device *device = nv_device(parent);
-	struct pci_dev *pdev = device->pdev;
 	struct nv04_instmem_priv *priv;
 	int ret, bar, vs;
 
@@ -60,13 +59,13 @@ nv40_instmem_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 		return ret;
 
 	/* map bar */
-	if (pci_resource_len(pdev, 2))
+	if (nv_device_resource_len(device, 2))
 		bar = 2;
 	else
 		bar = 3;
 
-	priv->iomem = ioremap(pci_resource_start(pdev, bar),
-			      pci_resource_len(pdev, bar));
+	priv->iomem = ioremap(nv_device_resource_start(device, bar),
+			      nv_device_resource_len(device, bar));
 	if (!priv->iomem) {
 		nv_error(priv, "unable to map PRAMIN BAR\n");
 		return -EFAULT;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/mc/base.c b/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
index b4b9943773bc..8a5555192fa5 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mc/base.c
@@ -93,7 +93,7 @@ _nouveau_mc_dtor(struct nouveau_object *object)
 {
 	struct nouveau_device *device = nv_device(object);
 	struct nouveau_mc *pmc = (void *)object;
-	free_irq(device->pdev->irq, pmc);
+	free_irq(pmc->irq, pmc);
 	if (pmc->use_msi)
 		pci_disable_msi(device->pdev);
 	nouveau_subdev_destroy(&pmc->base);
@@ -114,33 +114,44 @@ nouveau_mc_create_(struct nouveau_object *parent, struct nouveau_object *engine,
 	if (ret)
 		return ret;
 
-	switch (device->pdev->device & 0x0ff0) {
-	case 0x00f0:
-	case 0x02e0:
-		/* BR02? NFI how these would be handled yet exactly */
-		break;
-	default:
-		switch (device->chipset) {
-		case 0xaa: break; /* reported broken, nv also disable it */
-		default:
-			pmc->use_msi = true;
+	if (nv_device_is_pci(device))
+		switch (device->pdev->device & 0x0ff0) {
+		case 0x00f0:
+		case 0x02e0:
+			/* BR02? NFI how these would be handled yet exactly */
 			break;
+		default:
+			switch (device->chipset) {
+			case 0xaa:
+				/* reported broken, nv also disable it */
+				break;
+			default:
+				pmc->use_msi = true;
+				break;
 		}
-	}
 
-	pmc->use_msi = nouveau_boolopt(device->cfgopt, "NvMSI", pmc->use_msi);
-	if (pmc->use_msi && oclass->msi_rearm) {
-		pmc->use_msi = pci_enable_msi(device->pdev) == 0;
-		if (pmc->use_msi) {
-			nv_info(pmc, "MSI interrupts enabled\n");
-			oclass->msi_rearm(pmc);
+		pmc->use_msi = nouveau_boolopt(device->cfgopt, "NvMSI",
+					       pmc->use_msi);
+
+		if (pmc->use_msi && oclass->msi_rearm) {
+			pmc->use_msi = pci_enable_msi(device->pdev) == 0;
+			if (pmc->use_msi) {
+				nv_info(pmc, "MSI interrupts enabled\n");
+				oclass->msi_rearm(pmc);
+			}
+		} else {
+			pmc->use_msi = false;
 		}
-	} else {
-		pmc->use_msi = false;
 	}
 
-	ret = request_irq(device->pdev->irq, nouveau_mc_intr,
-			  IRQF_SHARED, "nouveau", pmc);
+	ret = nv_device_get_irq(device, true);
+	if (ret < 0)
+		return ret;
+	pmc->irq = ret;
+
+	ret = request_irq(pmc->irq, nouveau_mc_intr, IRQF_SHARED, "nouveau",
+			  pmc);
+
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
index 13c5af88a601..51fcf7960417 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
@@ -96,7 +96,7 @@ mxm_shadow_dsm(struct nouveau_mxm *mxm, u8 version)
 	acpi_handle handle;
 	int rev;
 
-	handle = ACPI_HANDLE(&device->pdev->dev);
+	handle = ACPI_HANDLE(nv_device_base(device));
 	if (!handle)
 		return false;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/nouveau/nouveau_abi16.c
index 900fae01793e..a28422bc1122 100644
--- a/drivers/gpu/drm/nouveau/nouveau_abi16.c
+++ b/drivers/gpu/drm/nouveau/nouveau_abi16.c
@@ -179,12 +179,21 @@ nouveau_abi16_ioctl_getparam(ABI16_IOCTL_ARGS)
 		getparam->value = device->chipset;
 		break;
 	case NOUVEAU_GETPARAM_PCI_VENDOR:
-		getparam->value = dev->pdev->vendor;
+		if (nv_device_is_pci(device))
+			getparam->value = dev->pdev->vendor;
+		else
+			getparam->value = 0;
 		break;
 	case NOUVEAU_GETPARAM_PCI_DEVICE:
-		getparam->value = dev->pdev->device;
+		if (nv_device_is_pci(device))
+			getparam->value = dev->pdev->device;
+		else
+			getparam->value = 0;
 		break;
 	case NOUVEAU_GETPARAM_BUS_TYPE:
+		if (!nv_device_is_pci(device))
+			getparam->value = 3;
+		else
 		if (drm_pci_device_is_agp(dev))
 			getparam->value = 0;
 		else
diff --git a/drivers/gpu/drm/nouveau/nouveau_agp.c b/drivers/gpu/drm/nouveau/nouveau_agp.c
index 2953c4e91e1a..51666daddb94 100644
--- a/drivers/gpu/drm/nouveau/nouveau_agp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_agp.c
@@ -75,7 +75,7 @@ nouveau_agp_enabled(struct nouveau_drm *drm)
 {
 	struct drm_device *dev = drm->dev;
 
-	if (!drm_pci_device_is_agp(dev) || !dev->agp)
+	if (!dev->pdev || !drm_pci_device_is_agp(dev) || !dev->agp)
 		return false;
 
 	if (drm->agp.stat == UNKNOWN) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index 4c3feaaa1037..04564dcd7956 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -2069,6 +2069,10 @@ nouveau_bios_init(struct drm_device *dev)
 	struct nvbios *bios = &drm->vbios;
 	int ret;
 
+	/* only relevant for PCI devices */
+	if (!dev->pdev)
+		return 0;
+
 	if (!NVInitVBIOS(dev))
 		return -ENODEV;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 488686d490c0..0e3391683469 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1255,7 +1255,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo_device *bdev, struct ttm_mem_reg *mem)
 		/* fallthrough, tiled memory */
 	case TTM_PL_VRAM:
 		mem->bus.offset = mem->start << PAGE_SHIFT;
-		mem->bus.base = pci_resource_start(dev->pdev, 1);
+		mem->bus.base = nv_device_resource_start(nouveau_dev(dev), 1);
 		mem->bus.is_iomem = true;
 		if (nv_device(drm->device)->card_type >= NV_50) {
 			struct nouveau_bar *bar = nouveau_bar(drm->device);
@@ -1293,7 +1293,7 @@ nouveau_ttm_fault_reserve_notify(struct ttm_buffer_object *bo)
 	struct nouveau_drm *drm = nouveau_bdev(bo->bdev);
 	struct nouveau_bo *nvbo = nouveau_bo(bo);
 	struct nouveau_device *device = nv_device(drm->device);
-	u32 mappable = pci_resource_len(device->pdev, 1) >> PAGE_SHIFT;
+	u32 mappable = nv_device_resource_len(device, 1) >> PAGE_SHIFT;
 	int ret;
 
 	/* as long as the bo isn't in vram, and isn't tiled, we've got
@@ -1331,6 +1331,7 @@ nouveau_ttm_tt_populate(struct ttm_tt *ttm)
 {
 	struct ttm_dma_tt *ttm_dma = (void *)ttm;
 	struct nouveau_drm *drm;
+	struct nouveau_device *device;
 	struct drm_device *dev;
 	unsigned i;
 	int r;
@@ -1348,6 +1349,7 @@ nouveau_ttm_tt_populate(struct ttm_tt *ttm)
 	}
 
 	drm = nouveau_bdev(ttm->bdev);
+	device = nv_device(drm->device);
 	dev = drm->dev;
 
 #if __OS_HAS_AGP
@@ -1368,13 +1370,12 @@ nouveau_ttm_tt_populate(struct ttm_tt *ttm)
 	}
 
 	for (i = 0; i < ttm->num_pages; i++) {
-		ttm_dma->dma_address[i] = pci_map_page(dev->pdev, ttm->pages[i],
-						   0, PAGE_SIZE,
-						   PCI_DMA_BIDIRECTIONAL);
-		if (pci_dma_mapping_error(dev->pdev, ttm_dma->dma_address[i])) {
+		ttm_dma->dma_address[i] = nv_device_map_page(device,
+							     ttm->pages[i]);
+		if (!ttm_dma->dma_address[i]) {
 			while (--i) {
-				pci_unmap_page(dev->pdev, ttm_dma->dma_address[i],
-					       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
+				nv_device_unmap_page(device,
+						     ttm_dma->dma_address[i]);
 				ttm_dma->dma_address[i] = 0;
 			}
 			ttm_pool_unpopulate(ttm);
@@ -1389,6 +1390,7 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt *ttm)
 {
 	struct ttm_dma_tt *ttm_dma = (void *)ttm;
 	struct nouveau_drm *drm;
+	struct nouveau_device *device;
 	struct drm_device *dev;
 	unsigned i;
 	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
@@ -1397,6 +1399,7 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt *ttm)
 		return;
 
 	drm = nouveau_bdev(ttm->bdev);
+	device = nv_device(drm->device);
 	dev = drm->dev;
 
 #if __OS_HAS_AGP
@@ -1415,8 +1418,7 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt *ttm)
 
 	for (i = 0; i < ttm->num_pages; i++) {
 		if (ttm_dma->dma_address[i]) {
-			pci_unmap_page(dev->pdev, ttm_dma->dma_address[i],
-				       PAGE_SIZE, PCI_DMA_BIDIRECTIONAL);
+			nv_device_unmap_page(device, ttm_dma->dma_address[i]);
 		}
 	}
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_chan.c b/drivers/gpu/drm/nouveau/nouveau_chan.c
index cc5152be2cf1..ccb6b452d6d0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_chan.c
+++ b/drivers/gpu/drm/nouveau/nouveau_chan.c
@@ -154,7 +154,7 @@ nouveau_channel_prep(struct nouveau_drm *drm, struct nouveau_cli *cli,
 			 * nfi why this exists, it came from the -nv ddx.
 			 */
 			args.flags = NV_DMA_TARGET_PCI | NV_DMA_ACCESS_RDWR;
-			args.start = pci_resource_start(device->pdev, 1);
+			args.start = nv_device_resource_start(device, 1);
 			args.limit = args.start + limit;
 		} else {
 			args.flags = NV_DMA_TARGET_VRAM | NV_DMA_ACCESS_RDWR;
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index b4262ad66b18..bc392412f14f 100644
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -339,6 +339,7 @@ int
 nouveau_display_create(struct drm_device *dev)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
+	struct nouveau_device *device = nouveau_dev(dev);
 	struct nouveau_display *disp;
 	int ret, gen;
 
@@ -379,7 +380,7 @@ nouveau_display_create(struct drm_device *dev)
 	}
 
 	dev->mode_config.funcs = &nouveau_mode_config_funcs;
-	dev->mode_config.fb_base = pci_resource_start(dev->pdev, 1);
+	dev->mode_config.fb_base = nv_device_resource_start(device, 1);
 
 	dev->mode_config.min_width = 0;
 	dev->mode_config.min_height = 0;
diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 23299cadbf91..17ff5c0f1a7d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -81,7 +81,7 @@ module_param_named(runpm, nouveau_runtime_pm, int, 0400);
 static struct drm_driver driver;
 
 static u64
-nouveau_name(struct pci_dev *pdev)
+nouveau_pci_name(struct pci_dev *pdev)
 {
 	u64 name = (u64)pci_domain_nr(pdev->bus) << 32;
 	name |= pdev->bus->number << 16;
@@ -89,15 +89,30 @@ nouveau_name(struct pci_dev *pdev)
 	return name | PCI_FUNC(pdev->devfn);
 }
 
+static u64
+nouveau_platform_name(struct platform_device *platformdev)
+{
+	return platformdev->id;
+}
+
+static u64
+nouveau_name(struct drm_device *dev)
+{
+	if (dev->pdev)
+		return nouveau_pci_name(dev->pdev);
+	else
+		return nouveau_platform_name(dev->platformdev);
+}
+
 static int
-nouveau_cli_create(struct pci_dev *pdev, const char *name,
+nouveau_cli_create(u64 name, const char *sname,
 		   int size, void **pcli)
 {
 	struct nouveau_cli *cli;
 	int ret;
 
 	*pcli = NULL;
-	ret = nouveau_client_create_(name, nouveau_name(pdev), nouveau_config,
+	ret = nouveau_client_create_(sname, name, nouveau_config,
 				     nouveau_debug, size, pcli);
 	cli = *pcli;
 	if (ret) {
@@ -281,7 +296,8 @@ static int nouveau_drm_probe(struct pci_dev *pdev,
 	remove_conflicting_framebuffers(aper, "nouveaufb", boot);
 	kfree(aper);
 
-	ret = nouveau_device_create(pdev, nouveau_name(pdev), pci_name(pdev),
+	ret = nouveau_device_create(pdev, NOUVEAU_BUS_PCI,
+				    nouveau_pci_name(pdev), pci_name(pdev),
 				    nouveau_config, nouveau_debug, &device);
 	if (ret)
 		return ret;
@@ -305,6 +321,12 @@ nouveau_get_hdmi_dev(struct drm_device *dev)
 	struct nouveau_drm *drm = dev->dev_private;
 	struct pci_dev *pdev = dev->pdev;
 
+	if (!pdev) {
+		DRM_INFO("not a PCI device; no HDMI");
+		drm->hdmi_device = NULL;
+		return;
+	}
+
 	/* subfunction one is a hdmi audio device? */
 	drm->hdmi_device = pci_get_bus_and_slot((unsigned int)pdev->bus->number,
 						PCI_DEVFN(PCI_SLOT(pdev->devfn), 1));
@@ -330,7 +352,8 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 	struct nouveau_drm *drm;
 	int ret;
 
-	ret = nouveau_cli_create(pdev, "DRM", sizeof(*drm), (void**)&drm);
+	ret = nouveau_cli_create(nouveau_name(dev), "DRM", sizeof(*drm),
+				 (void **)&drm);
 	if (ret)
 		return ret;
 
@@ -345,7 +368,7 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 	/* make sure AGP controller is in a consistent state before we
 	 * (possibly) execute vbios init tables (see nouveau_agp.h)
 	 */
-	if (drm_pci_device_is_agp(dev) && dev->agp) {
+	if (pdev && drm_pci_device_is_agp(dev) && dev->agp) {
 		/* dummy device object, doesn't init anything, but allows
 		 * agp code access to registers
 		 */
@@ -662,7 +685,6 @@ static int nouveau_pmops_thaw(struct device *dev)
 static int
 nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 {
-	struct pci_dev *pdev = dev->pdev;
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_cli *cli;
 	char name[32], tmpname[TASK_COMM_LEN];
@@ -676,7 +698,9 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 	get_task_comm(tmpname, current);
 	snprintf(name, sizeof(name), "%s[%d]", tmpname, pid_nr(fpriv->pid));
 
-	ret = nouveau_cli_create(pdev, name, sizeof(*cli), (void **)&cli);
+	ret = nouveau_cli_create(nouveau_name(dev), name, sizeof(*cli),
+			(void **)&cli);
+
 	if (ret)
 		goto out_suspend;
 
@@ -963,6 +987,25 @@ nouveau_drm_pci_driver = {
 	.driver.pm = &nouveau_pm_ops,
 };
 
+int nouveau_drm_platform_probe(struct platform_device *pdev)
+{
+	struct nouveau_device *device;
+	int ret;
+
+	ret = nouveau_device_create(pdev, NOUVEAU_BUS_PLATFORM,
+				    nouveau_platform_name(pdev),
+				    dev_name(&pdev->dev), nouveau_config,
+				    nouveau_debug, &device);
+
+	ret = drm_platform_init(&driver, pdev);
+	if (ret) {
+		nouveau_object_ref(NULL, (struct nouveau_object **)&device);
+		return ret;
+	}
+
+	return ret;
+}
+
 static int __init
 nouveau_drm_init(void)
 {
diff --git a/drivers/gpu/drm/nouveau/nouveau_sysfs.c b/drivers/gpu/drm/nouveau/nouveau_sysfs.c
index 89201a17ce75..75dda2b07176 100644
--- a/drivers/gpu/drm/nouveau/nouveau_sysfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sysfs.c
@@ -30,7 +30,7 @@
 static inline struct drm_device *
 drm_device(struct device *d)
 {
-	return pci_get_drvdata(to_pci_dev(d));
+	return dev_get_drvdata(d);
 }
 
 #define snappendf(p,r,f,a...) do {                                             \
@@ -132,9 +132,10 @@ nouveau_sysfs_fini(struct drm_device *dev)
 {
 	struct nouveau_sysfs *sysfs = nouveau_sysfs(dev);
 	struct nouveau_drm *drm = nouveau_drm(dev);
+	struct nouveau_device *device = nv_device(drm->device);
 
 	if (sysfs->ctrl) {
-		device_remove_file(&dev->pdev->dev, &dev_attr_pstate);
+		device_remove_file(nv_device_base(device), &dev_attr_pstate);
 		nouveau_object_del(nv_object(drm), NVDRM_DEVICE, NVDRM_CONTROL);
 	}
 
@@ -146,6 +147,7 @@ int
 nouveau_sysfs_init(struct drm_device *dev)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
+	struct nouveau_device *device = nv_device(drm->device);
 	struct nouveau_sysfs *sysfs;
 	int ret;
 
@@ -156,7 +158,7 @@ nouveau_sysfs_init(struct drm_device *dev)
 	ret = nouveau_object_new(nv_object(drm), NVDRM_DEVICE, NVDRM_CONTROL,
 				 NV_CONTROL_CLASS, NULL, 0, &sysfs->ctrl);
 	if (ret == 0)
-		device_create_file(&dev->pdev->dev, &dev_attr_pstate);
+		device_create_file(nv_device_base(device), &dev_attr_pstate);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_ttm.c b/drivers/gpu/drm/nouveau/nouveau_ttm.c
index d45d50da978f..9574f87bf31e 100644
--- a/drivers/gpu/drm/nouveau/nouveau_ttm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_ttm.c
@@ -354,21 +354,26 @@ int
 nouveau_ttm_init(struct nouveau_drm *drm)
 {
 	struct drm_device *dev = drm->dev;
+	struct nouveau_device *device = nv_device(drm->device);
 	u32 bits;
 	int ret;
 
 	bits = nouveau_vmmgr(drm->device)->dma_bits;
-	if ( drm->agp.stat == ENABLED ||
-	    !pci_dma_supported(dev->pdev, DMA_BIT_MASK(bits)))
-		bits = 32;
-
-	ret = pci_set_dma_mask(dev->pdev, DMA_BIT_MASK(bits));
-	if (ret)
-		return ret;
-
-	ret = pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(bits));
-	if (ret)
-		pci_set_consistent_dma_mask(dev->pdev, DMA_BIT_MASK(32));
+	if (nv_device_is_pci(device)) {
+		if (drm->agp.stat == ENABLED ||
+		     !pci_dma_supported(dev->pdev, DMA_BIT_MASK(bits)))
+			bits = 32;
+
+		ret = pci_set_dma_mask(dev->pdev, DMA_BIT_MASK(bits));
+		if (ret)
+			return ret;
+
+		ret = pci_set_consistent_dma_mask(dev->pdev,
+						  DMA_BIT_MASK(bits));
+		if (ret)
+			pci_set_consistent_dma_mask(dev->pdev,
+						    DMA_BIT_MASK(32));
+	}
 
 	ret = nouveau_ttm_global_init(drm);
 	if (ret)
@@ -394,8 +399,8 @@ nouveau_ttm_init(struct nouveau_drm *drm)
 		return ret;
 	}
 
-	drm->ttm.mtrr = arch_phys_wc_add(pci_resource_start(dev->pdev, 1),
-					 pci_resource_len(dev->pdev, 1));
+	drm->ttm.mtrr = arch_phys_wc_add(nv_device_resource_start(device, 1),
+					 nv_device_resource_len(device, 1));
 
 	/* GART init */
 	if (drm->agp.stat != ENABLED) {
diff --git a/drivers/gpu/drm/nouveau/nouveau_vga.c b/drivers/gpu/drm/nouveau/nouveau_vga.c
index 81638d7f2eff..cb0824b875c7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_vga.c
+++ b/drivers/gpu/drm/nouveau/nouveau_vga.c
@@ -82,6 +82,11 @@ nouveau_vga_init(struct nouveau_drm *drm)
 {
 	struct drm_device *dev = drm->dev;
 	bool runtime = false;
+
+	/* only relevant for PCI devices */
+	if (!dev->pdev)
+		return;
+
 	vga_client_register(dev->pdev, dev, NULL, nouveau_vga_set_decode);
 
 	if (nouveau_runtime_pm == 1)
-- 
1.9.0

