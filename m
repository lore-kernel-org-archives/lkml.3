Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaEFWse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:48:34 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:35056 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbaEFWsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:48:30 -0400
Subject: [PATCH v2 4/5] iommu: Use dma_addr_t for IOVA arguments
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 06 May 2014 16:48:40 -0600
Message-ID: <20140506224840.17968.29010.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the "iova" arguments of iommu_map(), iommu_unmap(), etc., from
"unsigned long" to dma_addr_t.

bb5547acfcd8 ("iommu/fsl: Make iova dma_addr_t in the iommu_iova_to_phys
API") did this for iommu_iova_to_phys(), but didn't fix the rest of the
IOMMU API.

This changes the following generic functions and function pointer types:

  iommu_map()
  iommu_unmap()
  struct iommu_ops.map
  struct iommu_ops.unmap
  iommu_fault_handler_t
  report_iommu_fault()

and the following implementations and users of them:

  amd_iommu_map(), amd_iommu_unmap()
  arm_smmu_map(), arm_smmu_unmap()
  exynos_iommu_map(), exynos_iommu_unmap()
  intel_iommu_map(), intel_iommu_unmap()
  msm_iommu_map(), msm_iommu_unmap()
  omap_iommu_map(), omap_iommu_unmap()
  shmobile_iommu_map(), shmobile_iommu_unmap()
  gart_iommu_map(), gart_iommu_unmap() (tegra)
  smmu_iommu_map(), smmu_iommu_unmap() (tegra)

  msm_fault_handler()
  usnic_uiom_dma_fault()
  rproc_iommu_fault()

There are many internal places that use "unsigned long", u32, u64, etc.  I
left those alone because they probably use types appropriate for their
hardware.  My intent is to make the generic interfaces consistent.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/gpu/drm/msm/msm_iommu.c          |    2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c |    2 +-
 drivers/iommu/amd_iommu.c                |    4 ++--
 drivers/iommu/arm-smmu.c                 |    4 ++--
 drivers/iommu/exynos-iommu.c             |    4 ++--
 drivers/iommu/intel-iommu.c              |    4 ++--
 drivers/iommu/iommu.c                    |    6 +++---
 drivers/iommu/msm_iommu.c                |    6 +++---
 drivers/iommu/omap-iommu.c               |    4 ++--
 drivers/iommu/shmobile-iommu.c           |    4 ++--
 drivers/iommu/tegra-gart.c               |    4 ++--
 drivers/iommu/tegra-smmu.c               |    4 ++--
 drivers/remoteproc/remoteproc_core.c     |    2 +-
 include/linux/iommu.h                    |   16 ++++++++--------
 14 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iommu.c
index 92b745986231..efe4aaf3f5ce 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -25,7 +25,7 @@ struct msm_iommu {
 #define to_msm_iommu(x) container_of(x, struct msm_iommu, base)
 
 static int msm_fault_handler(struct iommu_domain *iommu, struct device *dev,
-		unsigned long iova, int flags, void *arg)
+		dma_addr_t iova, int flags, void *arg)
 {
 	DBG("*** fault: iova=%08lx, flags=%d", iova, flags);
 	return 0;
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
index 801a1d6937e4..6c87970a359f 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -67,7 +67,7 @@ static void usnic_uiom_reg_account(struct work_struct *work)
 
 static int usnic_uiom_dma_fault(struct iommu_domain *domain,
 				struct device *dev,
-				unsigned long iova, int flags,
+				dma_addr_t iova, int flags,
 				void *token)
 {
 	usnic_err("Device %s iommu fault domain 0x%pK va 0x%lx flags 0x%x\n",
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c949520bd196..d1bcf05e5577 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3393,7 +3393,7 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	return ret;
 }
 
-static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
+static int amd_iommu_map(struct iommu_domain *dom, dma_addr_t iova,
 			 phys_addr_t paddr, size_t page_size, int iommu_prot)
 {
 	struct protection_domain *domain = dom->priv;
@@ -3415,7 +3415,7 @@ static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
 	return ret;
 }
 
-static size_t amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
+static size_t amd_iommu_unmap(struct iommu_domain *dom, dma_addr_t iova,
 			   size_t page_size)
 {
 	struct protection_domain *domain = dom->priv;
diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 8b89e33a89fe..69e8246b2241 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1476,7 +1476,7 @@ out_unlock:
 	return ret;
 }
 
-static int arm_smmu_map(struct iommu_domain *domain, unsigned long iova,
+static int arm_smmu_map(struct iommu_domain *domain, dma_addr_t iova,
 			phys_addr_t paddr, size_t size, int prot)
 {
 	struct arm_smmu_domain *smmu_domain = domain->priv;
@@ -1491,7 +1491,7 @@ static int arm_smmu_map(struct iommu_domain *domain, unsigned long iova,
 	return arm_smmu_handle_mapping(smmu_domain, iova, paddr, size, prot);
 }
 
-static size_t arm_smmu_unmap(struct iommu_domain *domain, unsigned long iova,
+static size_t arm_smmu_unmap(struct iommu_domain *domain, dma_addr_t iova,
 			     size_t size)
 {
 	int ret;
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 074018979cdf..573247097715 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -878,7 +878,7 @@ static int lv2set_page(unsigned long *pent, phys_addr_t paddr, size_t size,
 	return 0;
 }
 
-static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
+static int exynos_iommu_map(struct iommu_domain *domain, dma_addr_t iova,
 			 phys_addr_t paddr, size_t size, int prot)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
@@ -919,7 +919,7 @@ static int exynos_iommu_map(struct iommu_domain *domain, unsigned long iova,
 }
 
 static size_t exynos_iommu_unmap(struct iommu_domain *domain,
-					       unsigned long iova, size_t size)
+					       dma_addr_t iova, size_t size)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
 	struct sysmmu_drvdata *data;
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 69fa7da5e48b..683cdab05d3d 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4242,7 +4242,7 @@ static void intel_iommu_detach_device(struct iommu_domain *domain,
 }
 
 static int intel_iommu_map(struct iommu_domain *domain,
-			   unsigned long iova, phys_addr_t hpa,
+			   dma_addr_t iova, phys_addr_t hpa,
 			   size_t size, int iommu_prot)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
@@ -4280,7 +4280,7 @@ static int intel_iommu_map(struct iommu_domain *domain,
 }
 
 static size_t intel_iommu_unmap(struct iommu_domain *domain,
-				unsigned long iova, size_t size)
+				dma_addr_t iova, size_t size)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	struct page *freelist = NULL;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e5555fcfe703..5c4f2e07b579 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -796,10 +796,10 @@ static size_t iommu_pgsize(struct iommu_domain *domain,
 	return pgsize;
 }
 
-int iommu_map(struct iommu_domain *domain, unsigned long iova,
+int iommu_map(struct iommu_domain *domain, dma_addr_t iova,
 	      phys_addr_t paddr, size_t size, int prot)
 {
-	unsigned long orig_iova = iova;
+	dma_addr_t orig_iova = iova;
 	unsigned int min_pagesz;
 	size_t orig_size = size;
 	int ret = 0;
@@ -849,7 +849,7 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
-size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
+size_t iommu_unmap(struct iommu_domain *domain, dma_addr_t iova, size_t size)
 {
 	size_t unmapped_page, unmapped = 0;
 	unsigned int min_pagesz;
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index f5ff657f49fa..5159ad6b79e7 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -359,7 +359,7 @@ fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 }
 
-static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
+static int msm_iommu_map(struct iommu_domain *domain, dma_addr_t va,
 			 phys_addr_t pa, size_t len, int prot)
 {
 	struct msm_priv *priv;
@@ -470,8 +470,8 @@ fail:
 	return ret;
 }
 
-static size_t msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
-			    size_t len)
+static size_t msm_iommu_unmap(struct iommu_domain *domain, dma_addr_t va,
+			      size_t len)
 {
 	struct msm_priv *priv;
 	unsigned long flags;
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 7fcbfc498fa9..76a34af53190 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1054,7 +1054,7 @@ static u32 iotlb_init_entry(struct iotlb_entry *e, u32 da, u32 pa,
 	return iopgsz_to_bytes(e->pgsz);
 }
 
-static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
+static int omap_iommu_map(struct iommu_domain *domain, dma_addr_t da,
 			 phys_addr_t pa, size_t bytes, int prot)
 {
 	struct omap_iommu_domain *omap_domain = domain->priv;
@@ -1084,7 +1084,7 @@ static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
 	return ret;
 }
 
-static size_t omap_iommu_unmap(struct iommu_domain *domain, unsigned long da,
+static size_t omap_iommu_unmap(struct iommu_domain *domain, dma_addr_t da,
 			    size_t size)
 {
 	struct omap_iommu_domain *omap_domain = domain->priv;
diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index 464acda0bbc4..037bf65e8ac2 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -210,7 +210,7 @@ static void l2free(struct shmobile_iommu_domain *sh_domain,
 	}
 }
 
-static int shmobile_iommu_map(struct iommu_domain *domain, unsigned long iova,
+static int shmobile_iommu_map(struct iommu_domain *domain, dma_addr_t iova,
 			      phys_addr_t paddr, size_t size, int prot)
 {
 	struct shmobile_iommu_domain_pgtable l2 = { .pgtable = NULL };
@@ -255,7 +255,7 @@ static int shmobile_iommu_map(struct iommu_domain *domain, unsigned long iova,
 }
 
 static size_t shmobile_iommu_unmap(struct iommu_domain *domain,
-				   unsigned long iova, size_t size)
+				   dma_addr_t iova, size_t size)
 {
 	struct shmobile_iommu_domain_pgtable l2 = { .pgtable = NULL };
 	struct shmobile_iommu_domain *sh_domain = domain->priv;
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index dba1a9fd5070..1ac5fa0d2f13 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -239,7 +239,7 @@ static void gart_iommu_domain_destroy(struct iommu_domain *domain)
 	domain->priv = NULL;
 }
 
-static int gart_iommu_map(struct iommu_domain *domain, unsigned long iova,
+static int gart_iommu_map(struct iommu_domain *domain, dma_addr_t iova,
 			  phys_addr_t pa, size_t bytes, int prot)
 {
 	struct gart_device *gart = domain->priv;
@@ -262,7 +262,7 @@ static int gart_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return 0;
 }
 
-static size_t gart_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+static size_t gart_iommu_unmap(struct iommu_domain *domain, dma_addr_t iova,
 			       size_t bytes)
 {
 	struct gart_device *gart = domain->priv;
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 605b5b46a903..bdac538d8bef 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -724,7 +724,7 @@ static void __smmu_iommu_map_pfn(struct smmu_as *as, dma_addr_t iova,
 	put_signature(as, iova, pfn);
 }
 
-static int smmu_iommu_map(struct iommu_domain *domain, unsigned long iova,
+static int smmu_iommu_map(struct iommu_domain *domain, dma_addr_t iova,
 			  phys_addr_t pa, size_t bytes, int prot)
 {
 	struct smmu_as *as = domain->priv;
@@ -742,7 +742,7 @@ static int smmu_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	return 0;
 }
 
-static size_t smmu_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+static size_t smmu_iommu_unmap(struct iommu_domain *domain, dma_addr_t iova,
 			       size_t bytes)
 {
 	struct smmu_as *as = domain->priv;
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 3cd85a638afa..ed22d6c6f204 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -73,7 +73,7 @@ static const char *rproc_crash_to_string(enum rproc_crash_type type)
  * will try to access an unmapped device address.
  */
 static int rproc_iommu_fault(struct iommu_domain *domain, struct device *dev,
-		unsigned long iova, int flags, void *token)
+		dma_addr_t iova, int flags, void *token)
 {
 	struct rproc *rproc = token;
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index b96a5b2136e4..5877aa7720b2 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -41,7 +41,7 @@ struct notifier_block;
 #define IOMMU_FAULT_WRITE	0x1
 
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
-			struct device *, unsigned long, int, void *);
+			struct device *, dma_addr_t, int, void *);
 
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
@@ -106,9 +106,9 @@ struct iommu_ops {
 	void (*domain_destroy)(struct iommu_domain *domain);
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
 	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
-	int (*map)(struct iommu_domain *domain, unsigned long iova,
+	int (*map)(struct iommu_domain *domain, dma_addr_t iova,
 		   phys_addr_t paddr, size_t size, int prot);
-	size_t (*unmap)(struct iommu_domain *domain, unsigned long iova,
+	size_t (*unmap)(struct iommu_domain *domain, dma_addr_t iova,
 		     size_t size);
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain, dma_addr_t iova);
 	int (*domain_has_cap)(struct iommu_domain *domain,
@@ -149,9 +149,9 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
-extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
+extern int iommu_map(struct iommu_domain *domain, dma_addr_t iova,
 		     phys_addr_t paddr, size_t size, int prot);
-extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+extern size_t iommu_unmap(struct iommu_domain *domain, dma_addr_t iova,
 		       size_t size);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, dma_addr_t iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
@@ -217,7 +217,7 @@ extern void iommu_domain_window_disable(struct iommu_domain *domain, u32 wnd_nr)
  * elicit the default behavior of the IOMMU drivers).
  */
 static inline int report_iommu_fault(struct iommu_domain *domain,
-		struct device *dev, unsigned long iova, int flags)
+		struct device *dev, dma_addr_t iova, int flags)
 {
 	int ret = -ENOSYS;
 
@@ -268,13 +268,13 @@ static inline void iommu_detach_device(struct iommu_domain *domain,
 {
 }
 
-static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
+static inline int iommu_map(struct iommu_domain *domain, dma_addr_t iova,
 			    phys_addr_t paddr, int gfp_order, int prot)
 {
 	return -ENODEV;
 }
 
-static inline int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+static inline int iommu_unmap(struct iommu_domain *domain, dma_addr_t iova,
 			      int gfp_order)
 {
 	return -ENODEV;

