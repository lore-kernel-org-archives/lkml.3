Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbaAGJAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:00:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:3277 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756549AbaAGJAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:00:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,617,1384329600"; 
   d="scan'208";a="454739996"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Tony Luck <tony.luck@intel.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch Part2 V1 10/14] iommu/vt-d: use RCU to protect global resources in interrupt context
Date: Tue,  7 Jan 2014 17:00:30 +0800
Message-Id: <1389085234-22296-11-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
References: <1389085234-22296-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Global DMA and interrupt remapping resources may be accessed in
interrupt context, so use RCU instead of rwsem to protect them
in such cases.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c        |   33 ++++++++++++++++++++-------------
 drivers/iommu/intel-iommu.c |   22 ++++++++++++++++++----
 include/linux/dmar.h        |   30 ++++++++++++++++++++----------
 3 files changed, 58 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 2831442..31c72d5 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -71,13 +71,13 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 	 * the very end.
 	 */
 	if (drhd->include_all)
-		list_add_tail(&drhd->list, &dmar_drhd_units);
+		list_add_tail_rcu(&drhd->list, &dmar_drhd_units);
 	else
-		list_add(&drhd->list, &dmar_drhd_units);
+		list_add_rcu(&drhd->list, &dmar_drhd_units);
 }
 
 static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
-					   struct pci_dev **dev, u16 segment)
+					   struct pci_dev __rcu **dev, u16 segment)
 {
 	struct pci_bus *bus;
 	struct pci_dev *pdev = NULL;
@@ -122,7 +122,9 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 			pci_name(pdev));
 		return -EINVAL;
 	}
-	*dev = pdev;
+
+	rcu_assign_pointer(*dev, pdev);
+
 	return 0;
 }
 
@@ -149,7 +151,7 @@ void *dmar_alloc_dev_scope(void *start, void *end, int *cnt)
 }
 
 int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				struct pci_dev ***devices, u16 segment)
+				struct pci_dev __rcu ***devices, u16 segment)
 {
 	struct acpi_dmar_device_scope *scope;
 	int index, ret;
@@ -177,7 +179,7 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 	return 0;
 }
 
-void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt)
+void dmar_free_dev_scope(struct pci_dev __rcu ***devices, int *cnt)
 {
 	int i;
 	struct pci_dev *tmp_dev;
@@ -186,9 +188,10 @@ void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt)
 		for_each_active_dev_scope(*devices, *cnt, i, tmp_dev)
 			pci_dev_put(tmp_dev);
 		kfree(*devices);
-		*devices = NULL;
-		*cnt = 0;
 	}
+
+	*devices = NULL;
+	*cnt = 0;
 }
 
 /**
@@ -410,7 +413,7 @@ parse_dmar_table(void)
 	return ret;
 }
 
-static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
+static int dmar_pci_device_match(struct pci_dev __rcu *devices[], int cnt,
 			  struct pci_dev *dev)
 {
 	int index;
@@ -431,11 +434,12 @@ static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
 struct dmar_drhd_unit *
 dmar_find_matched_drhd_unit(struct pci_dev *dev)
 {
-	struct dmar_drhd_unit *dmaru = NULL;
+	struct dmar_drhd_unit *dmaru;
 	struct acpi_dmar_hardware_unit *drhd;
 
 	dev = pci_physfn(dev);
 
+	rcu_read_lock();
 	for_each_drhd_unit(dmaru) {
 		drhd = container_of(dmaru->hdr,
 				    struct acpi_dmar_hardware_unit,
@@ -443,14 +447,17 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
 
 		if (dmaru->include_all &&
 		    drhd->segment == pci_domain_nr(dev->bus))
-			return dmaru;
+			goto out;
 
 		if (dmar_pci_device_match(dmaru->devices,
 					  dmaru->devices_cnt, dev))
-			return dmaru;
+			goto out;
 	}
+	dmaru = NULL;
+out:
+	rcu_read_unlock();
 
-	return NULL;
+	return dmaru;
 }
 
 int __init dmar_dev_scope_init(void)
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 25e9b84..91ecb95 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -385,14 +385,14 @@ struct dmar_rmrr_unit {
 	struct acpi_dmar_header *hdr;	/* ACPI header		*/
 	u64	base_address;		/* reserved base address*/
 	u64	end_address;		/* reserved end address */
-	struct pci_dev **devices;	/* target devices */
+	struct pci_dev __rcu **devices;	/* target devices */
 	int	devices_cnt;		/* target device count */
 };
 
 struct dmar_atsr_unit {
 	struct list_head list;		/* list of ATSR units */
 	struct acpi_dmar_header *hdr;	/* ACPI header */
-	struct pci_dev **devices;	/* target devices */
+	struct pci_dev __rcu **devices;	/* target devices */
 	int devices_cnt;		/* target device count */
 	u8 include_all:1;		/* include all ports */
 };
@@ -632,12 +632,15 @@ static void domain_update_iommu_superpage(struct dmar_domain *domain)
 	}
 
 	/* set iommu_superpage to the smallest common denominator */
+	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
 		mask &= cap_super_page_val(iommu->cap);
 		if (!mask) {
 			break;
 		}
 	}
+	rcu_read_unlock();
+
 	domain->iommu_superpage = fls(mask);
 }
 
@@ -656,6 +659,7 @@ static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
 	struct pci_dev *dev;
 	int i;
 
+	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
 		if (segment != drhd->segment)
 			continue;
@@ -675,6 +679,7 @@ static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
 	}
 	iommu = NULL;
 out:
+	rcu_read_unlock();
 
 	return iommu;
 }
@@ -1538,9 +1543,11 @@ static void domain_exit(struct dmar_domain *domain)
 	/* free page tables */
 	dma_pte_free_pagetable(domain, 0, DOMAIN_MAX_PFN(domain->gaw));
 
+	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd)
 		if (test_bit(iommu->seq_id, domain->iommu_bmp))
 			iommu_detach_domain(domain, iommu);
+	rcu_read_unlock();
 
 	free_domain_mem(domain);
 }
@@ -2334,6 +2341,7 @@ static bool device_has_rmrr(struct pci_dev *dev)
 	struct pci_dev *tmp;
 	int i;
 
+	rcu_read_lock();
 	for_each_rmrr_units(rmrr) {
 		/*
 		 * Return TRUE if this RMRR contains the device that
@@ -2342,9 +2350,11 @@ static bool device_has_rmrr(struct pci_dev *dev)
 		for_each_active_dev_scope(rmrr->devices,
 					  rmrr->devices_cnt, i, tmp)
 			if (tmp == dev) {
+				rcu_read_unlock();
 				return true;
 			}
 	}
+	rcu_read_unlock();
 	return false;
 }
 
@@ -3506,7 +3516,7 @@ int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
 	atsru->hdr = hdr;
 	atsru->include_all = atsr->flags & 0x1;
 
-	list_add(&atsru->list, &dmar_atsr_units);
+	list_add_rcu(&atsru->list, &dmar_atsr_units);
 
 	return 0;
 }
@@ -3568,6 +3578,7 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
 	if (!bridge)
 		return 0;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(atsru, &dmar_atsr_units, list) {
 		atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
 		if (atsr->segment != pci_domain_nr(dev->bus))
@@ -3582,6 +3593,7 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
 	}
 	ret = 0;
 out:
+	rcu_read_unlock();
 
 	return ret;
 }
@@ -3598,7 +3610,7 @@ int __init dmar_parse_rmrr_atsr_dev(void)
 			return ret;
 	}
 
-	list_for_each_entry(atsr, &dmar_atsr_units, list) {
+	list_for_each_entry_rcu(atsr, &dmar_atsr_units, list) {
 		ret = atsr_parse_dev(atsr);
 		if (ret)
 			return ret;
@@ -3915,6 +3927,7 @@ static void iommu_free_vm_domain(struct dmar_domain *domain)
 	unsigned long i;
 	unsigned long ndomains;
 
+	rcu_read_lock();
 	for_each_active_iommu(iommu, drhd) {
 		ndomains = cap_ndoms(iommu->cap);
 		for_each_set_bit(i, iommu->domain_ids, ndomains) {
@@ -3927,6 +3940,7 @@ static void iommu_free_vm_domain(struct dmar_domain *domain)
 			}
 		}
 	}
+	rcu_read_unlock();
 }
 
 static void vm_domain_exit(struct dmar_domain *domain)
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 9572a4f..3e42960 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -26,6 +26,7 @@
 #include <linux/msi.h>
 #include <linux/irqreturn.h>
 #include <linux/rwsem.h>
+#include <linux/rcupdate.h>
 
 struct acpi_dmar_header;
 
@@ -41,7 +42,7 @@ struct dmar_drhd_unit {
 	struct list_head list;		/* list of drhd units	*/
 	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
 	u64	reg_base_addr;		/* register base address*/
-	struct	pci_dev **devices; 	/* target device array	*/
+	struct	pci_dev __rcu **devices;/* target device array	*/
 	int	devices_cnt;		/* target device count	*/
 	u16	segment;		/* PCI domain		*/
 	u8	ignored:1; 		/* ignore drhd		*/
@@ -53,22 +54,31 @@ extern struct rw_semaphore dmar_global_lock;
 extern struct list_head dmar_drhd_units;
 
 #define for_each_drhd_unit(drhd) \
-	list_for_each_entry(drhd, &dmar_drhd_units, list)
+	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list)
 
 #define for_each_active_drhd_unit(drhd)					\
-	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
+	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list)		\
 		if (drhd->ignored) {} else
 
 #define for_each_active_iommu(i, drhd)					\
-	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
+	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list)		\
 		if (i=drhd->iommu, drhd->ignored) {} else
 
 #define for_each_iommu(i, drhd)						\
-	list_for_each_entry(drhd, &dmar_drhd_units, list)		\
+	list_for_each_entry_rcu(drhd, &dmar_drhd_units, list)		\
 		if (i=drhd->iommu, 0) {} else 
 
+static inline bool dmar_rcu_check(void)
+{
+	return rwsem_is_locked(&dmar_global_lock) ||
+	       system_state == SYSTEM_BOOTING;
+}
+
+#define	dmar_rcu_dereference(p)	rcu_dereference_check((p), dmar_rcu_check())
+
 #define	for_each_dev_scope(a, c, p, d)	\
-	for ((p) = 0; ((d) = (p) < (c) ? (a)[(p)] : NULL, (p) < (c)); (p)++)
+	for ((p) = 0; ((d) = (p) < (c) ? dmar_rcu_dereference((a)[(p)]) : \
+			NULL, (p) < (c)); (p)++)
 
 #define	for_each_active_dev_scope(a, c, p, d)	\
 	for_each_dev_scope((a), (c), (p), (d))	if (!(d)) { continue; } else
@@ -76,6 +86,10 @@ extern struct list_head dmar_drhd_units;
 extern int dmar_table_init(void);
 extern int dmar_dev_scope_init(void);
 extern int enable_drhd_fault_handling(void);
+extern void *dmar_alloc_dev_scope(void *start, void *end, int *cnt);
+extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
+				struct pci_dev __rcu ***devices, u16 segment);
+extern void dmar_free_dev_scope(struct pci_dev __rcu ***devices, int *cnt);
 #else
 static inline int dmar_table_init(void)
 {
@@ -138,10 +152,6 @@ extern int iommu_detected, no_iommu;
 extern int dmar_parse_rmrr_atsr_dev(void);
 extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
 extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
-extern void *dmar_alloc_dev_scope(void *start, void *end, int *cnt);
-extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
-				struct pci_dev ***devices, u16 segment);
-extern void dmar_free_dev_scope(struct pci_dev ***devices, int *cnt);
 extern int intel_iommu_init(void);
 #else /* !CONFIG_INTEL_IOMMU: */
 static inline int intel_iommu_init(void) { return -ENODEV; }
-- 
1.7.10.4

