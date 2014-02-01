Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbaBAD3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 22:29:12 -0500
Received: from gnurou.org ([207.192.72.5]:51802 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932385AbaBAD20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 22:28:26 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Cc: Terje Bergstrom <tbergstrom@nvidia.com>, Ken Adams <KAdams@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Eric Brower <ebrower@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 02/16] drm/nouveau: basic support for platform devices
Date: Sat,  1 Feb 2014 12:16:44 +0900
Message-Id: <1391224618-3794-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
References: <1391224618-3794-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The T124 generation of Tegra GPUs uses the Kepler architecture and can
thus be driven by Nouveau. However, they are declared as platform
devices using the Device Tree, and Nouveau has a very strong dependency
on PCI. This patch makes Nouveau core able to handle platform devices as
well as PCI devices.

Commonly-used PCI functions include resource range query and page
mapping. These functions are abstracted so the correct bus type is used
to perform them. Some PCI-dependent code is also disabled when probing a
non-PCI device.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/engine/device/base.c  | 58 +++++++++++++++++++++-
 drivers/gpu/drm/nouveau/core/include/core/device.h | 27 ++++++++++
 drivers/gpu/drm/nouveau/core/os.h                  |  1 +
 drivers/gpu/drm/nouveau/nouveau_abi16.c            | 13 ++++-
 drivers/gpu/drm/nouveau/nouveau_bo.c               | 22 ++++----
 drivers/gpu/drm/nouveau/nouveau_display.c          |  3 +-
 drivers/gpu/drm/nouveau/nouveau_drm.c              | 53 ++++++++++++++------
 drivers/gpu/drm/nouveau/nouveau_sysfs.c            |  8 +--
 drivers/gpu/drm/nouveau/nouveau_ttm.c              | 31 +++++++-----
 9 files changed, 170 insertions(+), 46 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/device/base.c b/drivers/gpu/drm/nouveau/core/engine/device/base.c
index dd01c6c..a6abb51 100644
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
@@ -446,6 +446,60 @@ nouveau_device_dtor(struct nouveau_object *object)
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
+nv_device_map_page(struct nouveau_device *device, struct page *page) {
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
 static struct nouveau_oclass
 nouveau_device_oclass = {
 	.handle = NV_ENGINE(DEVICE, 0x00),
diff --git a/drivers/gpu/drm/nouveau/core/include/core/device.h b/drivers/gpu/drm/nouveau/core/include/core/device.h
index 7b8ea22..23f4a25 100644
--- a/drivers/gpu/drm/nouveau/core/include/core/device.h
+++ b/drivers/gpu/drm/nouveau/core/include/core/device.h
@@ -65,6 +65,7 @@ struct nouveau_device {
 	struct list_head head;
 
 	struct pci_dev *pdev;
+	struct platform_device *platformdev;
 	u64 handle;
 
 	const char *cfgopt;
@@ -140,4 +141,30 @@ nv_device_match(struct nouveau_object *object, u16 dev, u16 ven, u16 sub)
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
 #endif
+
diff --git a/drivers/gpu/drm/nouveau/core/os.h b/drivers/gpu/drm/nouveau/core/os.h
index 191e739..90a6c90 100644
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
diff --git a/drivers/gpu/drm/nouveau/nouveau_abi16.c b/drivers/gpu/drm/nouveau/nouveau_abi16.c
index 900fae0..a28422b 100644
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
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 488686d..f8d43cf 100644
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
+		if (ttm_dma->dma_address[i] == 0) {
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
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_display.c b/drivers/gpu/drm/nouveau/nouveau_display.c
index b4262ad..bc39241 100644
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
index 23299ca..4cba4d8 100644
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
+nouveau_platform_name(struct platform_device *pdev)
+{
+	return pdev->id;
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
@@ -281,8 +296,9 @@ static int nouveau_drm_probe(struct pci_dev *pdev,
 	remove_conflicting_framebuffers(aper, "nouveaufb", boot);
 	kfree(aper);
 
-	ret = nouveau_device_create(pdev, nouveau_name(pdev), pci_name(pdev),
-				    nouveau_config, nouveau_debug, &device);
+	ret = nouveau_device_create(pdev, nouveau_pci_name(pdev),
+				    pci_name(pdev), nouveau_config,
+				    nouveau_debug, &device);
 	if (ret)
 		return ret;
 
@@ -330,7 +346,8 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 	struct nouveau_drm *drm;
 	int ret;
 
-	ret = nouveau_cli_create(pdev, "DRM", sizeof(*drm), (void**)&drm);
+	ret = nouveau_cli_create(nouveau_name(dev), "DRM", sizeof(*drm),
+				 (void **)&drm);
 	if (ret)
 		return ret;
 
@@ -340,12 +357,13 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 	INIT_LIST_HEAD(&drm->clients);
 	spin_lock_init(&drm->tile.lock);
 
-	nouveau_get_hdmi_dev(dev);
+	if (pdev)
+		nouveau_get_hdmi_dev(dev);
 
 	/* make sure AGP controller is in a consistent state before we
 	 * (possibly) execute vbios init tables (see nouveau_agp.h)
 	 */
-	if (drm_pci_device_is_agp(dev) && dev->agp) {
+	if (pdev && drm_pci_device_is_agp(dev) && dev->agp) {
 		/* dummy device object, doesn't init anything, but allows
 		 * agp code access to registers
 		 */
@@ -384,8 +402,10 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 	if (nv_device(drm->device)->chipset == 0xc1)
 		nv_mask(device, 0x00088080, 0x00000800, 0x00000000);
 
-	nouveau_vga_init(drm);
-	nouveau_agp_init(drm);
+	if (pdev) {
+		nouveau_vga_init(drm);
+		nouveau_agp_init(drm);
+	}
 
 	if (device->card_type >= NV_50) {
 		ret = nouveau_vm_new(nv_device(drm->device), 0, (1ULL << 40),
@@ -398,9 +418,11 @@ nouveau_drm_load(struct drm_device *dev, unsigned long flags)
 	if (ret)
 		goto fail_ttm;
 
-	ret = nouveau_bios_init(dev);
-	if (ret)
-		goto fail_bios;
+	if (pdev) {
+		ret = nouveau_bios_init(dev);
+		if (ret)
+			goto fail_bios;
+	}
 
 	ret = nouveau_display_create(dev);
 	if (ret)
@@ -662,7 +684,6 @@ static int nouveau_pmops_thaw(struct device *dev)
 static int
 nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 {
-	struct pci_dev *pdev = dev->pdev;
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nouveau_cli *cli;
 	char name[32], tmpname[TASK_COMM_LEN];
@@ -676,7 +697,9 @@ nouveau_drm_open(struct drm_device *dev, struct drm_file *fpriv)
 	get_task_comm(tmpname, current);
 	snprintf(name, sizeof(name), "%s[%d]", tmpname, pid_nr(fpriv->pid));
 
-	ret = nouveau_cli_create(pdev, name, sizeof(*cli), (void **)&cli);
+	ret = nouveau_cli_create(nouveau_name(dev), name, sizeof(*cli),
+			(void **)&cli);
+
 	if (ret)
 		goto out_suspend;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_sysfs.c b/drivers/gpu/drm/nouveau/nouveau_sysfs.c
index 89201a1..75dda2b 100644
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
index d45d50d..9574f87 100644
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
-- 
1.8.5.3

