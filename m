Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3AUKyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:54:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41572 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3AUKyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:54:44 -0500
From: Hideki EIRAKU <hdk@igel.co.jp>
To: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        Hideki EIRAKU <hdk@igel.co.jp>
Subject: [PATCH v6 1/4] iommu/shmobile: Add iommu driver for Renesas IPMMU modules
Date: Mon, 21 Jan 2013 19:54:26 +0900
Message-Id: <1358765669-14567-2-git-send-email-hdk@igel.co.jp>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
References: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the Renesas IPMMU driver and IOMMU API implementation.

The IPMMU module supports the MMU function and the PMB function.  The
MMU function provides address translation by pagetable compatible with
ARMv6.  The PMB function provides address translation including
tile-linear translation.  This patch implements the MMU function.

The iommu driver does not register a platform driver directly because:
- the register space of the MMU function and the PMB function
  have a common register (used for settings flush), so they should ideally
  have a way to appropriately share this register.
- the MMU function uses the IOMMU API while the PMB function does not.
- the two functions may be used independently.

Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
---
 drivers/iommu/Kconfig                  |  74 ++++++
 drivers/iommu/Makefile                 |   2 +
 drivers/iommu/shmobile-iommu.c         | 395 +++++++++++++++++++++++++++++++++
 drivers/iommu/shmobile-ipmmu.c         | 136 ++++++++++++
 drivers/iommu/shmobile-ipmmu.h         |  34 +++
 include/linux/platform_data/sh_ipmmu.h |  18 ++
 6 files changed, 659 insertions(+)
 create mode 100644 drivers/iommu/shmobile-iommu.c
 create mode 100644 drivers/iommu/shmobile-ipmmu.c
 create mode 100644 drivers/iommu/shmobile-ipmmu.h
 create mode 100644 include/linux/platform_data/sh_ipmmu.h

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index e39f9db..d364494 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -187,4 +187,78 @@ config EXYNOS_IOMMU_DEBUG
 
 	  Say N unless you need kernel log message for IOMMU debugging
 
+config SHMOBILE_IPMMU
+	bool
+
+config SHMOBILE_IPMMU_TLB
+	bool
+
+config SHMOBILE_IOMMU
+	bool "IOMMU for Renesas IPMMU/IPMMUI"
+	default n
+	depends on (ARM && ARCH_SHMOBILE)
+	select IOMMU_API
+	select ARM_DMA_USE_IOMMU
+	select SHMOBILE_IPMMU
+	select SHMOBILE_IPMMU_TLB
+	help
+	  Support for Renesas IPMMU/IPMMUI. This option enables
+	  remapping of DMA memory accesses from all of the IP blocks
+	  on the ICB.
+
+	  Warning: Drivers (including userspace drivers of UIO
+	  devices) of the IP blocks on the ICB *must* use addresses
+	  allocated from the IPMMU (iova) for DMA with this option
+	  enabled.
+
+	  If unsure, say N.
+
+choice
+	prompt "IPMMU/IPMMUI address space size"
+	default SHMOBILE_IOMMU_ADDRSIZE_2048MB
+	depends on SHMOBILE_IOMMU
+	help
+	  This option sets IPMMU/IPMMUI address space size by
+	  adjusting the 1st level page table size. The page table size
+	  is calculated as follows:
+
+	      page table size = number of page table entries * 4 bytes
+	      number of page table entries = address space size / 1 MiB
+
+	  For example, when the address space size is 2048 MiB, the
+	  1st level page table size is 8192 bytes.
+
+	config SHMOBILE_IOMMU_ADDRSIZE_2048MB
+		bool "2 GiB"
+
+	config SHMOBILE_IOMMU_ADDRSIZE_1024MB
+		bool "1 GiB"
+
+	config SHMOBILE_IOMMU_ADDRSIZE_512MB
+		bool "512 MiB"
+
+	config SHMOBILE_IOMMU_ADDRSIZE_256MB
+		bool "256 MiB"
+
+	config SHMOBILE_IOMMU_ADDRSIZE_128MB
+		bool "128 MiB"
+
+	config SHMOBILE_IOMMU_ADDRSIZE_64MB
+		bool "64 MiB"
+
+	config SHMOBILE_IOMMU_ADDRSIZE_32MB
+		bool "32 MiB"
+
+endchoice
+
+config SHMOBILE_IOMMU_L1SIZE
+	int
+	default 8192 if SHMOBILE_IOMMU_ADDRSIZE_2048MB
+	default 4096 if SHMOBILE_IOMMU_ADDRSIZE_1024MB
+	default 2048 if SHMOBILE_IOMMU_ADDRSIZE_512MB
+	default 1024 if SHMOBILE_IOMMU_ADDRSIZE_256MB
+	default 512 if SHMOBILE_IOMMU_ADDRSIZE_128MB
+	default 256 if SHMOBILE_IOMMU_ADDRSIZE_64MB
+	default 128 if SHMOBILE_IOMMU_ADDRSIZE_32MB
+
 endif # IOMMU_SUPPORT
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index f66b816..ef0e520 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -13,3 +13,5 @@ obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
 obj-$(CONFIG_TEGRA_IOMMU_GART) += tegra-gart.o
 obj-$(CONFIG_TEGRA_IOMMU_SMMU) += tegra-smmu.o
 obj-$(CONFIG_EXYNOS_IOMMU) += exynos-iommu.o
+obj-$(CONFIG_SHMOBILE_IOMMU) += shmobile-iommu.o
+obj-$(CONFIG_SHMOBILE_IPMMU) += shmobile-ipmmu.o
diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
new file mode 100644
index 0000000..b6e8b57
--- /dev/null
+++ b/drivers/iommu/shmobile-iommu.c
@@ -0,0 +1,395 @@
+/*
+ * IOMMU for IPMMU/IPMMUI
+ * Copyright (C) 2012  Hideki EIRAKU
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/io.h>
+#include <linux/iommu.h>
+#include <linux/platform_device.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+#include <asm/dma-iommu.h>
+#include "shmobile-ipmmu.h"
+
+#define L1_SIZE CONFIG_SHMOBILE_IOMMU_L1SIZE
+#define L1_LEN (L1_SIZE / 4)
+#define L1_ALIGN L1_SIZE
+#define L2_SIZE SZ_1K
+#define L2_LEN (L2_SIZE / 4)
+#define L2_ALIGN L2_SIZE
+
+struct shmobile_iommu_domain_pgtable {
+	uint32_t *pgtable;
+	dma_addr_t handle;
+};
+
+struct shmobile_iommu_archdata {
+	struct list_head attached_list;
+	struct dma_iommu_mapping *iommu_mapping;
+	spinlock_t attach_lock;
+	struct shmobile_iommu_domain *attached;
+	int num_attached_devices;
+	struct shmobile_ipmmu *ipmmu;
+};
+
+struct shmobile_iommu_domain {
+	struct shmobile_iommu_domain_pgtable l1, l2[L1_LEN];
+	spinlock_t map_lock;
+	spinlock_t attached_list_lock;
+	struct list_head attached_list;
+};
+
+static struct shmobile_iommu_archdata *ipmmu_archdata;
+static struct kmem_cache *l1cache, *l2cache;
+
+static int pgtable_alloc(struct shmobile_iommu_domain_pgtable *pgtable,
+			 struct kmem_cache *cache, size_t size)
+{
+	pgtable->pgtable = kmem_cache_zalloc(cache, GFP_ATOMIC);
+	if (!pgtable->pgtable)
+		return -ENOMEM;
+	pgtable->handle = dma_map_single(NULL, pgtable->pgtable, size,
+					 DMA_TO_DEVICE);
+	return 0;
+}
+
+static void pgtable_free(struct shmobile_iommu_domain_pgtable *pgtable,
+			 struct kmem_cache *cache, size_t size)
+{
+	dma_unmap_single(NULL, pgtable->handle, size, DMA_TO_DEVICE);
+	kmem_cache_free(cache, pgtable->pgtable);
+}
+
+static uint32_t pgtable_read(struct shmobile_iommu_domain_pgtable *pgtable,
+			     unsigned int index)
+{
+	return pgtable->pgtable[index];
+}
+
+static void pgtable_write(struct shmobile_iommu_domain_pgtable *pgtable,
+			  unsigned int index, unsigned int count, uint32_t val)
+{
+	unsigned int i;
+
+	for (i = 0; i < count; i++)
+		pgtable->pgtable[index + i] = val;
+	dma_sync_single_for_device(NULL, pgtable->handle + index * sizeof(val),
+				   sizeof(val) * count, DMA_TO_DEVICE);
+}
+
+static int shmobile_iommu_domain_init(struct iommu_domain *domain)
+{
+	struct shmobile_iommu_domain *sh_domain;
+	int i, ret;
+
+	sh_domain = kmalloc(sizeof(*sh_domain), GFP_KERNEL);
+	if (!sh_domain)
+		return -ENOMEM;
+	ret = pgtable_alloc(&sh_domain->l1, l1cache, L1_SIZE);
+	if (ret < 0) {
+		kfree(sh_domain);
+		return ret;
+	}
+	for (i = 0; i < L1_LEN; i++)
+		sh_domain->l2[i].pgtable = NULL;
+	spin_lock_init(&sh_domain->map_lock);
+	spin_lock_init(&sh_domain->attached_list_lock);
+	INIT_LIST_HEAD(&sh_domain->attached_list);
+	domain->priv = sh_domain;
+	return 0;
+}
+
+static void shmobile_iommu_domain_destroy(struct iommu_domain *domain)
+{
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
+	int i;
+
+	for (i = 0; i < L1_LEN; i++) {
+		if (sh_domain->l2[i].pgtable)
+			pgtable_free(&sh_domain->l2[i], l2cache, L2_SIZE);
+	}
+	pgtable_free(&sh_domain->l1, l1cache, L1_SIZE);
+	kfree(sh_domain);
+	domain->priv = NULL;
+}
+
+static int shmobile_iommu_attach_device(struct iommu_domain *domain,
+					struct device *dev)
+{
+	struct shmobile_iommu_archdata *archdata = dev->archdata.iommu;
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
+	int ret = -EBUSY;
+
+	if (!archdata)
+		return -ENODEV;
+	spin_lock(&sh_domain->attached_list_lock);
+	spin_lock(&archdata->attach_lock);
+	if (archdata->attached != sh_domain) {
+		if (archdata->attached)
+			goto err;
+		ipmmu_tlb_set(archdata->ipmmu, sh_domain->l1.handle, L1_SIZE,
+			      0);
+		ipmmu_tlb_flush(archdata->ipmmu);
+		archdata->attached = sh_domain;
+		archdata->num_attached_devices = 0;
+		list_add(&archdata->attached_list, &sh_domain->attached_list);
+	}
+	archdata->num_attached_devices++;
+	ret = 0;
+err:
+	spin_unlock(&archdata->attach_lock);
+	spin_unlock(&sh_domain->attached_list_lock);
+	return ret;
+}
+
+static void shmobile_iommu_detach_device(struct iommu_domain *domain,
+					 struct device *dev)
+{
+	struct shmobile_iommu_archdata *archdata = dev->archdata.iommu;
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
+
+	if (!archdata)
+		return;
+	spin_lock(&sh_domain->attached_list_lock);
+	spin_lock(&archdata->attach_lock);
+	archdata->num_attached_devices--;
+	if (!archdata->num_attached_devices) {
+		ipmmu_tlb_set(archdata->ipmmu, 0, 0, 0);
+		ipmmu_tlb_flush(archdata->ipmmu);
+		archdata->attached = NULL;
+		list_del(&archdata->attached_list);
+	}
+	spin_unlock(&archdata->attach_lock);
+	spin_unlock(&sh_domain->attached_list_lock);
+}
+
+static void domain_tlb_flush(struct shmobile_iommu_domain *sh_domain)
+{
+	struct shmobile_iommu_archdata *archdata;
+
+	spin_lock(&sh_domain->attached_list_lock);
+	list_for_each_entry(archdata, &sh_domain->attached_list, attached_list)
+		ipmmu_tlb_flush(archdata->ipmmu);
+	spin_unlock(&sh_domain->attached_list_lock);
+}
+
+static int l2alloc(struct shmobile_iommu_domain *sh_domain,
+		   unsigned int l1index)
+{
+	int ret;
+
+	if (!sh_domain->l2[l1index].pgtable) {
+		ret = pgtable_alloc(&sh_domain->l2[l1index], l2cache, L2_SIZE);
+		if (ret < 0)
+			return ret;
+	}
+	pgtable_write(&sh_domain->l1, l1index, 1,
+		      sh_domain->l2[l1index].handle | 0x1);
+	return 0;
+}
+
+static void l2realfree(struct shmobile_iommu_domain_pgtable *l2)
+{
+	if (l2->pgtable)
+		pgtable_free(l2, l2cache, L2_SIZE);
+}
+
+static void l2free(struct shmobile_iommu_domain *sh_domain,
+		   unsigned int l1index,
+		   struct shmobile_iommu_domain_pgtable *l2)
+{
+	pgtable_write(&sh_domain->l1, l1index, 1, 0);
+	if (sh_domain->l2[l1index].pgtable) {
+		*l2 = sh_domain->l2[l1index];
+		sh_domain->l2[l1index].pgtable = NULL;
+	}
+}
+
+static int shmobile_iommu_map(struct iommu_domain *domain, unsigned long iova,
+			      phys_addr_t paddr, size_t size, int prot)
+{
+	struct shmobile_iommu_domain_pgtable l2 = { .pgtable = NULL };
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
+	unsigned int l1index, l2index;
+	int ret;
+
+	l1index = iova >> 20;
+	switch (size) {
+	case SZ_4K:
+		l2index = (iova >> 12) & 0xff;
+		spin_lock(&sh_domain->map_lock);
+		ret = l2alloc(sh_domain, l1index);
+		if (!ret)
+			pgtable_write(&sh_domain->l2[l1index], l2index, 1,
+				      paddr | 0xff2);
+		spin_unlock(&sh_domain->map_lock);
+		break;
+	case SZ_64K:
+		l2index = (iova >> 12) & 0xf0;
+		spin_lock(&sh_domain->map_lock);
+		ret = l2alloc(sh_domain, l1index);
+		if (!ret)
+			pgtable_write(&sh_domain->l2[l1index], l2index, 0x10,
+				      paddr | 0xff1);
+		spin_unlock(&sh_domain->map_lock);
+		break;
+	case SZ_1M:
+		spin_lock(&sh_domain->map_lock);
+		l2free(sh_domain, l1index, &l2);
+		pgtable_write(&sh_domain->l1, l1index, 1, paddr | 0xc02);
+		spin_unlock(&sh_domain->map_lock);
+		ret = 0;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	if (!ret)
+		domain_tlb_flush(sh_domain);
+	l2realfree(&l2);
+	return ret;
+}
+
+static size_t shmobile_iommu_unmap(struct iommu_domain *domain,
+				   unsigned long iova, size_t size)
+{
+	struct shmobile_iommu_domain_pgtable l2 = { .pgtable = NULL };
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
+	unsigned int l1index, l2index;
+	uint32_t l2entry = 0;
+	size_t ret = 0;
+
+	l1index = iova >> 20;
+	if (!(iova & 0xfffff) && size >= SZ_1M) {
+		spin_lock(&sh_domain->map_lock);
+		l2free(sh_domain, l1index, &l2);
+		spin_unlock(&sh_domain->map_lock);
+		ret = SZ_1M;
+		goto done;
+	}
+	l2index = (iova >> 12) & 0xff;
+	spin_lock(&sh_domain->map_lock);
+	if (sh_domain->l2[l1index].pgtable)
+		l2entry = pgtable_read(&sh_domain->l2[l1index], l2index);
+	switch (l2entry & 3) {
+	case 1:
+		if (l2index & 0xf)
+			break;
+		pgtable_write(&sh_domain->l2[l1index], l2index, 0x10, 0);
+		ret = SZ_64K;
+		break;
+	case 2:
+		pgtable_write(&sh_domain->l2[l1index], l2index, 1, 0);
+		ret = SZ_4K;
+		break;
+	}
+	spin_unlock(&sh_domain->map_lock);
+done:
+	if (ret)
+		domain_tlb_flush(sh_domain);
+	l2realfree(&l2);
+	return ret;
+}
+
+static phys_addr_t shmobile_iommu_iova_to_phys(struct iommu_domain *domain,
+					       unsigned long iova)
+{
+	struct shmobile_iommu_domain *sh_domain = domain->priv;
+	uint32_t l1entry = 0, l2entry = 0;
+	unsigned int l1index, l2index;
+
+	l1index = iova >> 20;
+	l2index = (iova >> 12) & 0xff;
+	spin_lock(&sh_domain->map_lock);
+	if (sh_domain->l2[l1index].pgtable)
+		l2entry = pgtable_read(&sh_domain->l2[l1index], l2index);
+	else
+		l1entry = pgtable_read(&sh_domain->l1, l1index);
+	spin_unlock(&sh_domain->map_lock);
+	switch (l2entry & 3) {
+	case 1:
+		return (l2entry & ~0xffff) | (iova & 0xffff);
+	case 2:
+		return (l2entry & ~0xfff) | (iova & 0xfff);
+	default:
+		if ((l1entry & 3) == 2)
+			return (l1entry & ~0xfffff) | (iova & 0xfffff);
+		return 0;
+	}
+}
+
+static int find_dev_name(struct shmobile_ipmmu *ipmmu, const char *dev_name)
+{
+	unsigned int i, n = ipmmu->num_dev_names;
+
+	for (i = 0; i < n; i++) {
+		if (strcmp(ipmmu->dev_names[i], dev_name) == 0)
+			return 1;
+	}
+	return 0;
+}
+
+static int shmobile_iommu_add_device(struct device *dev)
+{
+	struct shmobile_iommu_archdata *archdata = ipmmu_archdata;
+	struct dma_iommu_mapping *mapping;
+
+	if (!find_dev_name(archdata->ipmmu, dev_name(dev)))
+		return 0;
+	mapping = archdata->iommu_mapping;
+	if (!mapping) {
+		mapping = arm_iommu_create_mapping(&platform_bus_type, 0,
+						   L1_LEN << 20, 0);
+		if (IS_ERR(mapping))
+			return PTR_ERR(mapping);
+		archdata->iommu_mapping = mapping;
+	}
+	dev->archdata.iommu = archdata;
+	if (arm_iommu_attach_device(dev, mapping))
+		pr_err("arm_iommu_attach_device failed\n");
+	return 0;
+}
+
+static struct iommu_ops shmobile_iommu_ops = {
+	.domain_init = shmobile_iommu_domain_init,
+	.domain_destroy = shmobile_iommu_domain_destroy,
+	.attach_dev = shmobile_iommu_attach_device,
+	.detach_dev = shmobile_iommu_detach_device,
+	.map = shmobile_iommu_map,
+	.unmap = shmobile_iommu_unmap,
+	.iova_to_phys = shmobile_iommu_iova_to_phys,
+	.add_device = shmobile_iommu_add_device,
+	.pgsize_bitmap = SZ_1M | SZ_64K | SZ_4K,
+};
+
+int ipmmu_iommu_init(struct shmobile_ipmmu *ipmmu)
+{
+	static struct shmobile_iommu_archdata *archdata;
+
+	l1cache = kmem_cache_create("shmobile-iommu-pgtable1", L1_SIZE,
+				    L1_ALIGN, SLAB_HWCACHE_ALIGN, NULL);
+	if (!l1cache)
+		return -ENOMEM;
+	l2cache = kmem_cache_create("shmobile-iommu-pgtable2", L2_SIZE,
+				    L2_ALIGN, SLAB_HWCACHE_ALIGN, NULL);
+	if (!l2cache) {
+		kmem_cache_destroy(l1cache);
+		return -ENOMEM;
+	}
+	archdata = kmalloc(sizeof(*archdata), GFP_KERNEL);
+	if (!archdata) {
+		kmem_cache_destroy(l1cache);
+		kmem_cache_destroy(l2cache);
+		return -ENOMEM;
+	}
+	spin_lock_init(&archdata->attach_lock);
+	archdata->attached = NULL;
+	archdata->ipmmu = ipmmu;
+	ipmmu_archdata = archdata;
+	bus_set_iommu(&platform_bus_type, &shmobile_iommu_ops);
+	return 0;
+}
diff --git a/drivers/iommu/shmobile-ipmmu.c b/drivers/iommu/shmobile-ipmmu.c
new file mode 100644
index 0000000..8321f89
--- /dev/null
+++ b/drivers/iommu/shmobile-ipmmu.c
@@ -0,0 +1,136 @@
+/*
+ * IPMMU/IPMMUI
+ * Copyright (C) 2012  Hideki EIRAKU
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/platform_data/sh_ipmmu.h>
+#include "shmobile-ipmmu.h"
+
+#define IMCTR1 0x000
+#define IMCTR2 0x004
+#define IMASID 0x010
+#define IMTTBR 0x014
+#define IMTTBCR 0x018
+
+#define IMCTR1_TLBEN (1 << 0)
+#define IMCTR1_FLUSH (1 << 1)
+
+static void ipmmu_reg_write(struct shmobile_ipmmu *ipmmu, unsigned long reg_off,
+			    unsigned long data)
+{
+	iowrite32(data, ipmmu->ipmmu_base + reg_off);
+}
+
+void ipmmu_tlb_flush(struct shmobile_ipmmu *ipmmu)
+{
+	if (!ipmmu)
+		return;
+
+	mutex_lock(&ipmmu->flush_lock);
+	if (ipmmu->tlb_enabled)
+		ipmmu_reg_write(ipmmu, IMCTR1, IMCTR1_FLUSH | IMCTR1_TLBEN);
+	else
+		ipmmu_reg_write(ipmmu, IMCTR1, IMCTR1_FLUSH);
+	mutex_unlock(&ipmmu->flush_lock);
+}
+
+void ipmmu_tlb_set(struct shmobile_ipmmu *ipmmu, unsigned long phys, int size,
+		   int asid)
+{
+	if (!ipmmu)
+		return;
+
+	mutex_lock(&ipmmu->flush_lock);
+	switch (size) {
+	default:
+		ipmmu->tlb_enabled = 0;
+		break;
+	case 0x2000:
+		ipmmu_reg_write(ipmmu, IMTTBCR, 1);
+		ipmmu->tlb_enabled = 1;
+		break;
+	case 0x1000:
+		ipmmu_reg_write(ipmmu, IMTTBCR, 2);
+		ipmmu->tlb_enabled = 1;
+		break;
+	case 0x800:
+		ipmmu_reg_write(ipmmu, IMTTBCR, 3);
+		ipmmu->tlb_enabled = 1;
+		break;
+	case 0x400:
+		ipmmu_reg_write(ipmmu, IMTTBCR, 4);
+		ipmmu->tlb_enabled = 1;
+		break;
+	case 0x200:
+		ipmmu_reg_write(ipmmu, IMTTBCR, 5);
+		ipmmu->tlb_enabled = 1;
+		break;
+	case 0x100:
+		ipmmu_reg_write(ipmmu, IMTTBCR, 6);
+		ipmmu->tlb_enabled = 1;
+		break;
+	case 0x80:
+		ipmmu_reg_write(ipmmu, IMTTBCR, 7);
+		ipmmu->tlb_enabled = 1;
+		break;
+	}
+	ipmmu_reg_write(ipmmu, IMTTBR, phys);
+	ipmmu_reg_write(ipmmu, IMASID, asid);
+	mutex_unlock(&ipmmu->flush_lock);
+}
+
+static int ipmmu_probe(struct platform_device *pdev)
+{
+	struct shmobile_ipmmu *ipmmu;
+	struct resource *res;
+	struct shmobile_ipmmu_platform_data *pdata = pdev->dev.platform_data;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "cannot get platform resources\n");
+		return -ENOENT;
+	}
+	ipmmu = devm_kzalloc(&pdev->dev, sizeof(*ipmmu), GFP_KERNEL);
+	if (!ipmmu) {
+		dev_err(&pdev->dev, "cannot allocate device data\n");
+		return -ENOMEM;
+	}
+	mutex_init(&ipmmu->flush_lock);
+	ipmmu->dev = &pdev->dev;
+	ipmmu->ipmmu_base = devm_ioremap_nocache(&pdev->dev, res->start,
+						resource_size(res));
+	if (!ipmmu->ipmmu_base) {
+		dev_err(&pdev->dev, "ioremap_nocache failed\n");
+		return -ENOMEM;
+	}
+	ipmmu->dev_names = pdata->dev_names;
+	ipmmu->num_dev_names = pdata->num_dev_names;
+	platform_set_drvdata(pdev, ipmmu);
+	ipmmu_reg_write(ipmmu, IMCTR1, 0x0); /* disable TLB */
+	ipmmu_reg_write(ipmmu, IMCTR2, 0x0); /* disable PMB */
+	ipmmu_iommu_init(ipmmu);
+	return 0;
+}
+
+static struct platform_driver ipmmu_driver = {
+	.probe = ipmmu_probe,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "ipmmu",
+	},
+};
+
+static int __init ipmmu_init(void)
+{
+	return platform_driver_register(&ipmmu_driver);
+}
+subsys_initcall(ipmmu_init);
diff --git a/drivers/iommu/shmobile-ipmmu.h b/drivers/iommu/shmobile-ipmmu.h
new file mode 100644
index 0000000..4d53684
--- /dev/null
+++ b/drivers/iommu/shmobile-ipmmu.h
@@ -0,0 +1,34 @@
+/* shmobile-ipmmu.h
+ *
+ * Copyright (C) 2012  Hideki EIRAKU
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#ifndef __SHMOBILE_IPMMU_H__
+#define __SHMOBILE_IPMMU_H__
+
+struct shmobile_ipmmu {
+	struct device *dev;
+	void __iomem *ipmmu_base;
+	int tlb_enabled;
+	struct mutex flush_lock;
+	const char * const *dev_names;
+	unsigned int num_dev_names;
+};
+
+#ifdef CONFIG_SHMOBILE_IPMMU_TLB
+void ipmmu_tlb_flush(struct shmobile_ipmmu *ipmmu);
+void ipmmu_tlb_set(struct shmobile_ipmmu *ipmmu, unsigned long phys, int size,
+		   int asid);
+int ipmmu_iommu_init(struct shmobile_ipmmu *ipmmu);
+#else
+static inline int ipmmu_iommu_init(struct shmobile_ipmmu *ipmmu)
+{
+	return -EINVAL;
+}
+#endif
+
+#endif /* __SHMOBILE_IPMMU_H__ */
diff --git a/include/linux/platform_data/sh_ipmmu.h b/include/linux/platform_data/sh_ipmmu.h
new file mode 100644
index 0000000..39f7405
--- /dev/null
+++ b/include/linux/platform_data/sh_ipmmu.h
@@ -0,0 +1,18 @@
+/* sh_ipmmu.h
+ *
+ * Copyright (C) 2012  Hideki EIRAKU
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#ifndef __SH_IPMMU_H__
+#define __SH_IPMMU_H__
+
+struct shmobile_ipmmu_platform_data {
+	const char * const *dev_names;
+	unsigned int num_dev_names;
+};
+
+#endif /* __SH_IPMMU_H__ */
-- 
1.8.0

