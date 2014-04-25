Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaDYAh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:37:58 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:20539 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaDYAg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:36:59 -0400
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com, jerry.hoemann@hp.com
Subject: [PATCH 1/8] iommu/vt-d: Fix a few existing lines for checkpatch.pl
Date: Thu, 24 Apr 2014 18:36:31 -0600
Message-Id: <1398386198-19304-2-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
References: <1398386198-19304-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things like:
1. no space before tabs
2. no initialization of static variables to 0 or NULL
3. no extra parentheses around the value on the 'return' statement
4. no line over 80-characters

The first three patches in this set enable the intel-iommu driver to consist
of multiple *.c source files by moving many of the existing definitions,
prototypes, and structure definitions from the front of intel-iommu.c into
a new intel-iommu-private.h file -- and replacing them with a #include
of that file.  


The last five patches in this set use the above enablement to implement,
within the new source file intel-iommu-kdump.c, a fix for:

A kdump problem about DMA that has been discussed for a long time.
That is, when a kernel panics and boots into the kdump kernel, DMA that was
started by the panicked kernel is not stopped before the kdump kernel is booted;
and the kdump kernel disables the IOMMU while this DMA continues.
This causes the IOMMU to stop translating the DMA addresses as IOVAs and
begin to treat them as physical memory addresses -- which causes the DMA to either:
1. generate DMAR errors or
2. generate PCI SERR errors or
3. transfer data to or from incorrect areas of memory.
Often this causes the dump to fail.

This patch set modifies the behavior of the Intel iommu in the crashdump kernel: 
1. to accept the iommu hardware in an active state,
2. to leave the current translations in-place so that legacy DMA will continue
   using its current buffers until the device drivers in the crashdump kernel
   initialize and initialize their devices,
3. to use different portions of the iova address ranges for the device drivers
   in the crashdump kernel than the iova ranges that were in-use at the time
   of the panic.  

Advantages of this approach:
1. All manipulation of the IO-device is done by the Linux device-driver
   for that device.
2. This approach behaves in a manner very similar to operation without an
   active iommu.
3. Any activity between the IO-device and its RMRR areas is handled by the
   device-driver in the same manner as during a non-kdump boot.
4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
   This supports the practice of creating a special kdump kernel without
   drivers for any devices that are not required for taking a crashdump. 
5. Minimal code-changes among the existing mainline intel-iommu code.


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 69fa7da..f80b4bb 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -69,7 +69,8 @@
    to match. That way, we can use 'unsigned long' for PFNs with impunity. */
 #define DOMAIN_MAX_PFN(gaw)	((unsigned long) min_t(uint64_t, \
 				__DOMAIN_MAX_PFN(gaw), (unsigned long)-1))
-#define DOMAIN_MAX_ADDR(gaw)	(((uint64_t)__DOMAIN_MAX_PFN(gaw)) << VTD_PAGE_SHIFT)
+#define DOMAIN_MAX_ADDR(gaw) (((uint64_t)__DOMAIN_MAX_PFN(gaw)) << \
+					VTD_PAGE_SHIFT)
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT)
 #define DMA_32BIT_PFN		IOVA_PFN(DMA_BIT_MASK(32))
@@ -172,7 +173,7 @@ static int rwbf_quirk;
  * set to 1 to panic kernel if can't successfully enable VT-d
  * (used when kernel is launched w/ TXT)
  */
-static int force_on = 0;
+static int force_on;
 
 /*
  * 0: Present
@@ -187,7 +188,7 @@ struct root_entry {
 #define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
 static inline bool root_present(struct root_entry *root)
 {
-	return (root->val & 1);
+	return root->val & 1;
 }
 static inline void set_root_present(struct root_entry *root)
 {
@@ -225,7 +226,7 @@ struct context_entry {
 
 static inline bool context_present(struct context_entry *context)
 {
-	return (context->lo & 1);
+	return context->lo & 1;
 }
 static inline void context_set_present(struct context_entry *context)
 {
@@ -303,7 +304,7 @@ static inline bool dma_pte_present(struct dma_pte *pte)
 
 static inline bool dma_pte_superpage(struct dma_pte *pte)
 {
-	return (pte->val & (1 << 7));
+	return pte->val & (1 << 7);
 }
 
 static inline int first_pte_in_page(struct dma_pte *pte)
@@ -314,7 +315,7 @@ static inline int first_pte_in_page(struct dma_pte *pte)
 /*
  * This domain is a statically identity mapping domain.
  *	1. This domain creats a static 1:1 mapping to all usable memory.
- * 	2. It maps to each iommu if successful.
+ *	2. It maps to each iommu if successful.
  *	3. Each iommu mapps to this domain if successful.
  */
 static struct dmar_domain *si_domain;
@@ -344,7 +345,7 @@ struct dmar_domain {
 	DECLARE_BITMAP(iommu_bmp, IOMMU_UNITS_SUPPORTED);
 					/* bitmap of iommus this domain uses*/
 
-	struct list_head devices; 	/* all devices' list */
+	struct list_head devices;	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
 
 	struct dma_pte	*pgd;		/* virtual address */
-- 
Bill Sumner <bill.sumner@hp.com>

