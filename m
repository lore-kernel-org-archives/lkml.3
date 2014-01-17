Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaAQUgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:36:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbaAQUgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:36:16 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RFC PATCH] vfio/iommu_type1: Multi-IOMMU domain support
To: Varun.Sethi@freescale.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Fri, 17 Jan 2014 13:36:11 -0700
Message-ID: <20140117203126.11429.25235.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC: This is not complete but I want to share with Varun the
dirrection I'm thinking about.  In particular, I'm really not
sure if we want to introduce a "v2" interface version with
slightly different unmap semantics.  QEMU doesn't care about
the difference, but other users might.  Be warned, I'm not even
sure if this code works at the moment.  Thanks,

Alex


We currently have a problem that we cannot support advanced features
of an IOMMU domain (ex. IOMMU_CACHE), because we have no guarantee
that those features will be supported by all of the hardware units
involved with the domain over its lifetime.  For instance, the Intel
VT-d architecture does not require that all DRHDs support snoop
control.  If we create a domain based on a device behind a DRHD that
does support snoop control and enable SNP support via the IOMMU_CACHE
mapping option, we cannot then add a device behind a DRHD which does
not support snoop control or we'll get reserved bit faults from the
SNP bit in the pagetables.  To add to the complexity, we can't know
the properties of a domain until a device is attached.

We could pass this problem off to userspace and require that a
separate vfio container be used, but we don't know how to handle page
accounting in that case.  How do we know that a page pinned in one
container is the same page as a different container and avoid double
billing the user for the page.

The solution is therefore to support multiple IOMMU domains per
container.  In the majority of cases, only one domain will be required
since hardware is typically consistent within a system.  However, this
provides us the ability to validate compatibility of domains and
support mixed environments where page table flags can be different
between domains.

To do this, our DMA tracking needs to change.  We currently try to
coalesce user mappings into as few tracking entries as possible.  The
problem then becomes that we lose granularity of user mappings.  We've
never guaranteed that a user is able to unmap at a finer granularity
than the original mapping, but we must honor the granularity of the
original mapping.  This coalescing code is therefore removed, allowing
only unmaps covering complete maps.  The change in accounting is
fairly small here, a typical QEMU VM will start out with roughly a
dozen entries, so it's arguable if this coalescing was ever needed.

We also move IOMMU domain creation to the point where a group is
attached to the container.  An interesting side-effect of this is that
we now have access to the device at the time of domain creation and
can probe the devices within the group to determine the bus_type.
This finally makes vfio_iommu_type1 completely device/bus agnostic.
In fact, each IOMMU domain can host devices on different buses managed
by different physical IOMMUs, and present a single DMA mapping
interface to the user.  When a new domain is created, mappings are
replayed to bring the IOMMU pagetables up to the state of the current
container.  And of course, DMA mapping and unmapping automatically
traverse all of the configured IOMMU domains.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/vfio_iommu_type1.c |  631 ++++++++++++++++++++-------------------
 include/uapi/linux/vfio.h       |    1 
 2 files changed, 329 insertions(+), 303 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 4fb7a8f..983aae5 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -30,7 +30,6 @@
 #include <linux/iommu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/pci.h>		/* pci_bus_type */
 #include <linux/rbtree.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -55,11 +54,18 @@ MODULE_PARM_DESC(disable_hugepages,
 		 "Disable VFIO IOMMU support for IOMMU hugepages.");
 
 struct vfio_iommu {
-	struct iommu_domain	*domain;
+	struct list_head	domain_list;
 	struct mutex		lock;
 	struct rb_root		dma_list;
+	bool v2;
+};
+
+struct vfio_domain {
+	struct iommu_domain	*domain;
+	struct bus_type		*bus;
+	struct list_head	next;
 	struct list_head	group_list;
-	bool			cache;
+	int			prot;		/* IOMMU_CACHE */
 };
 
 struct vfio_dma {
@@ -99,7 +105,7 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
 	return NULL;
 }
 
-static void vfio_insert_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
+static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 {
 	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
 	struct vfio_dma *dma;
@@ -118,7 +124,7 @@ static void vfio_insert_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
 	rb_insert_color(&new->node, &iommu->dma_list);
 }
 
-static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
+static void vfio_unlink_dma(struct vfio_iommu *iommu, struct vfio_dma *old)
 {
 	rb_erase(&old->node, &iommu->dma_list);
 }
@@ -322,32 +328,39 @@ static long vfio_unpin_pages(unsigned long pfn, long npage,
 	return unlocked;
 }
 
-static int vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
-			    dma_addr_t iova, size_t *size)
+static void vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
-	dma_addr_t start = iova, end = iova + *size;
+	dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
+	struct vfio_domain *domain, *d;
 	long unlocked = 0;
 
+	if (!dma->size)
+		return;
+	/*
+	 * We use the IOMMU to track the physical addresses, otherwise we'd
+	 * need a much more complicated tracking system.  Unfortunately that
+	 * means we need to use one of the iommu domains to figure out the
+	 * pfns to unpin.  The rest need to be unmapped in advance so we have
+	 * no iommu translations remaining when the pages are unpinned.
+	 */
+	domain = d = list_first_entry(&iommu->domain_list,
+				      struct vfio_domain, next);
+
+	list_for_each_entry_continue(d, &iommu->domain_list, next)
+		iommu_unmap(d->domain, dma->iova, dma->size);
+
 	while (iova < end) {
 		size_t unmapped;
 		phys_addr_t phys;
 
-		/*
-		 * We use the IOMMU to track the physical address.  This
-		 * saves us from having a lot more entries in our mapping
-		 * tree.  The downside is that we don't track the size
-		 * used to do the mapping.  We request unmap of a single
-		 * page, but expect IOMMUs that support large pages to
-		 * unmap a larger chunk.
-		 */
-		phys = iommu_iova_to_phys(iommu->domain, iova);
+		phys = iommu_iova_to_phys(domain->domain, iova);
 		if (WARN_ON(!phys)) {
 			iova += PAGE_SIZE;
 			continue;
 		}
 
-		unmapped = iommu_unmap(iommu->domain, iova, PAGE_SIZE);
-		if (!unmapped)
+		unmapped = iommu_unmap(domain->domain, iova, PAGE_SIZE);
+		if (WARN_ON(!unmapped))
 			break;
 
 		unlocked += vfio_unpin_pages(phys >> PAGE_SHIFT,
@@ -357,119 +370,26 @@ static int vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 	}
 
 	vfio_lock_acct(-unlocked);
-
-	*size = iova - start;
-
-	return 0;
 }
 
-static int vfio_remove_dma_overlap(struct vfio_iommu *iommu, dma_addr_t start,
-				   size_t *size, struct vfio_dma *dma)
+static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 {
-	size_t offset, overlap, tmp;
-	struct vfio_dma *split;
-	int ret;
-
-	if (!*size)
-		return 0;
-
-	/*
-	 * Existing dma region is completely covered, unmap all.  This is
-	 * the likely case since userspace tends to map and unmap buffers
-	 * in one shot rather than multiple mappings within a buffer.
-	 */
-	if (likely(start <= dma->iova &&
-		   start + *size >= dma->iova + dma->size)) {
-		*size = dma->size;
-		ret = vfio_unmap_unpin(iommu, dma, dma->iova, size);
-		if (ret)
-			return ret;
-
-		/*
-		 * Did we remove more than we have?  Should never happen
-		 * since a vfio_dma is contiguous in iova and vaddr.
-		 */
-		WARN_ON(*size != dma->size);
-
-		vfio_remove_dma(iommu, dma);
-		kfree(dma);
-		return 0;
-	}
-
-	/* Overlap low address of existing range */
-	if (start <= dma->iova) {
-		overlap = start + *size - dma->iova;
-		ret = vfio_unmap_unpin(iommu, dma, dma->iova, &overlap);
-		if (ret)
-			return ret;
-
-		vfio_remove_dma(iommu, dma);
-
-		/*
-		 * Check, we may have removed to whole vfio_dma.  If not
-		 * fixup and re-insert.
-		 */
-		if (overlap < dma->size) {
-			dma->iova += overlap;
-			dma->vaddr += overlap;
-			dma->size -= overlap;
-			vfio_insert_dma(iommu, dma);
-		} else
-			kfree(dma);
-
-		*size = overlap;
-		return 0;
-	}
-
-	/* Overlap high address of existing range */
-	if (start + *size >= dma->iova + dma->size) {
-		offset = start - dma->iova;
-		overlap = dma->size - offset;
-
-		ret = vfio_unmap_unpin(iommu, dma, start, &overlap);
-		if (ret)
-			return ret;
-
-		dma->size -= overlap;
-		*size = overlap;
-		return 0;
-	}
-
-	/* Split existing */
-
-	/*
-	 * Allocate our tracking structure early even though it may not
-	 * be used.  An Allocation failure later loses track of pages and
-	 * is more difficult to unwind.
-	 */
-	split = kzalloc(sizeof(*split), GFP_KERNEL);
-	if (!split)
-		return -ENOMEM;
-
-	offset = start - dma->iova;
-
-	ret = vfio_unmap_unpin(iommu, dma, start, size);
-	if (ret || !*size) {
-		kfree(split);
-		return ret;
-	}
-
-	tmp = dma->size;
+	vfio_unmap_unpin(iommu, dma);
+	vfio_unlink_dma(iommu, dma);
+	kfree(dma);
+}
 
-	/* Resize the lower vfio_dma in place, before the below insert */
-	dma->size = offset;
+static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *domain;
+	unsigned long bitmap = PAGE_MASK;
 
-	/* Insert new for remainder, assuming it didn't all get unmapped */
-	if (likely(offset + *size < tmp)) {
-		split->size = tmp - offset - *size;
-		split->iova = dma->iova + offset + *size;
-		split->vaddr = dma->vaddr + offset + *size;
-		split->prot = dma->prot;
-		vfio_insert_dma(iommu, split);
-	} else
-		kfree(split);
+	mutex_lock(&iommu->lock);
+	list_for_each_entry(domain, &iommu->domain_list, next)
+		bitmap &= domain->domain->ops->pgsize_bitmap;
+	mutex_unlock(&iommu->lock);
 
-	return 0;
+	return bitmap;
 }
 
 static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
@@ -477,10 +397,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 {
 	uint64_t mask;
 	struct vfio_dma *dma;
-	size_t unmapped = 0, size;
+	size_t unmapped = 0;
 	int ret = 0;
 
-	mask = ((uint64_t)1 << __ffs(iommu->domain->ops->pgsize_bitmap)) - 1;
+	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
 
 	if (unmap->iova & mask)
 		return -EINVAL;
@@ -491,20 +411,61 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
 
 	mutex_lock(&iommu->lock);
 
+	/*
+	 * vfio-iommu-type1 (v1) - User mappings were coalesced together to
+	 * avoid tracking individual mappings.  This means that the granularity
+	 * of the original mapping was lost and the user was allowed to attempt
+	 * to unmap any range.  Depending on the contiguousness of physical
+	 * memory and page sizes supported by the IOMMU, arbitrary unmaps may
+	 * or may not have worked.  We only guaranteed unmap granularity
+	 * matching the original mapping; even though it was untracked here,
+	 * the original mappings are reflected in IOMMU mappings.  This
+	 * resulted in a couple unusual behaviors.  First, if a range is not
+	 * able to be unmapped, ex. a set of 4k pages that was mapped as a
+	 * 2M hugepage into the IOMMU, the unmap ioctl returns success but with
+	 * a zero sized unmap.  Also, if an unmap request overlaps the first
+	 * address of a hugepage, the IOMMU will unmap the entire hugepage.
+	 * This also returns success and the returned unmap size reflects the
+	 * actual size unmapped.
+	 *
+	 * We attempt to maintain compatibility with this interface, but we
+	 * take control out of the hands of the IOMMU.  An unmap request offset
+	 * from the beginning of the original mapping will return success with
+	 * zero sized unmap.  An unmap request covering the first iova of
+	 * mapping will unmap the entire range.
+	 *
+	 * The v2 version of this interface intends to be more deterministic.
+	 * Unmap requests must fully cover previous mappings.  Multiple
+	 * mappings may still be unmaped by specifying large ranges, but there
+	 * must not be any previous mappings bisected by the range.  An error
+	 * will be returned if these conditions are not met.  The v2 interface
+	 * will only return success and a size of zero if there were no
+	 * mappings within the range.
+	 */
+	if (iommu->v2 ) {
+		dma = vfio_find_dma(iommu, unmap->iova, 0);
+		if (dma && dma->iova != unmap->iova) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+		dma = vfio_find_dma(iommu, unmap->iova + unmap->size - 1, 0);
+		if (dma && dma->iova + dma->size != unmap->iova + unmap->size) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+	}
+
 	while ((dma = vfio_find_dma(iommu, unmap->iova, unmap->size))) {
-		size = unmap->size;
-		ret = vfio_remove_dma_overlap(iommu, unmap->iova, &size, dma);
-		if (ret || !size)
+		if (!iommu->v2 && unmap->iova > dma->iova)
 			break;
-		unmapped += size;
+		unmapped += dma->size;
+		vfio_remove_dma(iommu, dma);
 	}
 
+unlock:
 	mutex_unlock(&iommu->lock);
 
-	/*
-	 * We may unmap more than requested, update the unmap struct so
-	 * userspace can know.
-	 */
+	/* Report how much was unmapped */
 	unmap->size = unmapped;
 
 	return ret;
@@ -516,22 +477,47 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
  * soon, so this is just a temporary workaround to break mappings down into
  * PAGE_SIZE.  Better to map smaller pages than nothing.
  */
-static int map_try_harder(struct vfio_iommu *iommu, dma_addr_t iova,
+static int map_try_harder(struct vfio_domain *domain, dma_addr_t iova,
 			  unsigned long pfn, long npage, int prot)
 {
 	long i;
 	int ret;
 
 	for (i = 0; i < npage; i++, pfn++, iova += PAGE_SIZE) {
-		ret = iommu_map(iommu->domain, iova,
+		ret = iommu_map(domain->domain, iova,
 				(phys_addr_t)pfn << PAGE_SHIFT,
-				PAGE_SIZE, prot);
+				PAGE_SIZE, prot | domain->prot);
 		if (ret)
 			break;
 	}
 
 	for (; i < npage && i > 0; i--, iova -= PAGE_SIZE)
-		iommu_unmap(iommu->domain, iova, PAGE_SIZE);
+		iommu_unmap(domain->domain, iova, PAGE_SIZE);
+
+	return ret;
+}
+
+static int vfio_iommu_map(struct vfio_iommu *iommu, dma_addr_t iova,
+			  unsigned long pfn, long npage, int prot)
+{
+	struct vfio_domain *d;
+	int ret;
+
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		ret = iommu_map(d->domain, iova, (phys_addr_t)pfn << PAGE_SHIFT,
+				npage << PAGE_SHIFT, prot | d->prot);
+		if (ret) {
+			if (ret != -EBUSY ||
+			    map_try_harder(d, iova, pfn, npage, prot))
+				goto unwind;
+		}
+	}
+
+	return 0;
+
+unwind:
+	list_for_each_entry_continue_reverse(d, &iommu->domain_list, next)
+		iommu_unmap(d->domain, iova, npage << PAGE_SHIFT);
 
 	return ret;
 }
@@ -545,12 +531,12 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	long npage;
 	int ret = 0, prot = 0;
 	uint64_t mask;
-	struct vfio_dma *dma = NULL;
+	struct vfio_dma *dma;
 	unsigned long pfn;
 
 	end = map->iova + map->size;
 
-	mask = ((uint64_t)1 << __ffs(iommu->domain->ops->pgsize_bitmap)) - 1;
+	mask = ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
 
 	/* READ/WRITE from device perspective */
 	if (map->flags & VFIO_DMA_MAP_FLAG_WRITE)
@@ -561,9 +547,6 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	if (!prot)
 		return -EINVAL; /* No READ/WRITE? */
 
-	if (iommu->cache)
-		prot |= IOMMU_CACHE;
-
 	if (vaddr & mask)
 		return -EINVAL;
 	if (map->iova & mask)
@@ -588,180 +571,249 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 		return -EEXIST;
 	}
 
-	for (iova = map->iova; iova < end; iova += size, vaddr += size) {
-		long i;
+	dma = kzalloc(sizeof(*dma), GFP_KERNEL);
+	if (!dma) {
+		mutex_unlock(&iommu->lock);
+		return -ENOMEM;
+	}
 
+	dma->iova = map->iova;
+	dma->vaddr = map->vaddr;
+	dma->prot = prot;
+
+	/* Insert zero-sized and grow as we map chunks of it */
+	vfio_link_dma(iommu, dma);
+
+	for (iova = map->iova; iova < end; iova += size, vaddr += size) {
 		/* Pin a contiguous chunk of memory */
 		npage = vfio_pin_pages(vaddr, (end - iova) >> PAGE_SHIFT,
 				       prot, &pfn);
 		if (npage <= 0) {
 			WARN_ON(!npage);
 			ret = (int)npage;
-			goto out;
-		}
-
-		/* Verify pages are not already mapped */
-		for (i = 0; i < npage; i++) {
-			if (iommu_iova_to_phys(iommu->domain,
-					       iova + (i << PAGE_SHIFT))) {
-				ret = -EBUSY;
-				goto out_unpin;
-			}
+			break;
 		}
 
-		ret = iommu_map(iommu->domain, iova,
-				(phys_addr_t)pfn << PAGE_SHIFT,
-				npage << PAGE_SHIFT, prot);
+		/* Map it! */
+		ret = vfio_iommu_map(iommu, iova, pfn, npage, prot);
 		if (ret) {
-			if (ret != -EBUSY ||
-			    map_try_harder(iommu, iova, pfn, npage, prot)) {
-				goto out_unpin;
-			}
+			vfio_unpin_pages(pfn, npage, prot, true);
+			break;
 		}
 
 		size = npage << PAGE_SHIFT;
+		dma->size += size;
+	}
 
-		/*
-		 * Check if we abut a region below - nothing below 0.
-		 * This is the most likely case when mapping chunks of
-		 * physically contiguous regions within a virtual address
-		 * range.  Update the abutting entry in place since iova
-		 * doesn't change.
-		 */
-		if (likely(iova)) {
-			struct vfio_dma *tmp;
-			tmp = vfio_find_dma(iommu, iova - 1, 1);
-			if (tmp && tmp->prot == prot &&
-			    tmp->vaddr + tmp->size == vaddr) {
-				tmp->size += size;
-				iova = tmp->iova;
-				size = tmp->size;
-				vaddr = tmp->vaddr;
-				dma = tmp;
-			}
-		}
+	if (ret)
+		vfio_remove_dma(iommu, dma);
 
-		/*
-		 * Check if we abut a region above - nothing above ~0 + 1.
-		 * If we abut above and below, remove and free.  If only
-		 * abut above, remove, modify, reinsert.
-		 */
-		if (likely(iova + size)) {
-			struct vfio_dma *tmp;
-			tmp = vfio_find_dma(iommu, iova + size, 1);
-			if (tmp && tmp->prot == prot &&
-			    tmp->vaddr == vaddr + size) {
-				vfio_remove_dma(iommu, tmp);
-				if (dma) {
-					dma->size += tmp->size;
-					kfree(tmp);
-				} else {
-					size += tmp->size;
-					tmp->size = size;
-					tmp->iova = iova;
-					tmp->vaddr = vaddr;
-					vfio_insert_dma(iommu, tmp);
-					dma = tmp;
-				}
-			}
-		}
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static int vfio_bus_type(struct device *dev, void *data)
+{
+	struct vfio_domain *domain = data;
+
+	if (domain->bus && domain->bus != dev->bus)
+		return -EINVAL;
+
+	domain->bus = dev->bus;
+
+	return 0;
+}
+
+static int vfio_iommu_replay(struct vfio_iommu *iommu,
+			     struct vfio_domain *domain)
+{
+	struct vfio_domain *d;
+	struct rb_node *n;
+	int ret;
+
+	/* Arbitrarily pick the first domain in the list for lookups */
+	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
+	n = rb_first(&iommu->dma_list);
+
+	/* If there's not a domain, there better not be any mappings */
+	if (WARN_ON(n && !d))
+		return -EINVAL;
+
+	for (; n; n = rb_next(n)) {
+		struct vfio_dma *dma;
+		dma_addr_t iova;
+
+		dma = rb_entry(n, struct vfio_dma, node);
+		iova = dma->iova;
 
-		if (!dma) {
-			dma = kzalloc(sizeof(*dma), GFP_KERNEL);
-			if (!dma) {
-				iommu_unmap(iommu->domain, iova, size);
-				ret = -ENOMEM;
-				goto out_unpin;
+		while (iova < dma->iova + dma->size) {
+			phys_addr_t phys = iommu_iova_to_phys(d->domain, iova);
+			size_t size;
+
+			if (WARN_ON(!phys)) {
+				iova += PAGE_SIZE;
+				continue;
 			}
 
-			dma->size = size;
-			dma->iova = iova;
-			dma->vaddr = vaddr;
-			dma->prot = prot;
-			vfio_insert_dma(iommu, dma);
-		}
-	}
+			size = PAGE_SIZE;
 
-	WARN_ON(ret);
-	mutex_unlock(&iommu->lock);
-	return ret;
+			while (iova + size < dma->iova + dma->size &&
+			       phys + size == iommu_iova_to_phys(d->domain,
+								 iova + size))
+				size += PAGE_SIZE;
 
-out_unpin:
-	vfio_unpin_pages(pfn, npage, prot, true);
+			ret = iommu_map(domain->domain, iova, phys,
+					size, dma->prot | domain->prot);
+			if (ret)
+				return ret;
 
-out:
-	iova = map->iova;
-	size = map->size;
-	while ((dma = vfio_find_dma(iommu, iova, size))) {
-		int r = vfio_remove_dma_overlap(iommu, iova,
-						&size, dma);
-		if (WARN_ON(r || !size))
-			break;
+			iova += size;
+		}
 	}
 
-	mutex_unlock(&iommu->lock);
-	return ret;
+	return 0;
 }
 
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
 	struct vfio_iommu *iommu = iommu_data;
-	struct vfio_group *group, *tmp;
+	struct vfio_group *group, *g;
+	struct vfio_domain *domain, *d;
 	int ret;
 
-	group = kzalloc(sizeof(*group), GFP_KERNEL);
-	if (!group)
-		return -ENOMEM;
-
 	mutex_lock(&iommu->lock);
 
-	list_for_each_entry(tmp, &iommu->group_list, next) {
-		if (tmp->iommu_group == iommu_group) {
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		list_for_each_entry(g, &d->group_list, next) {
+			if (g->iommu_group != iommu_group)
+				continue;
+
 			mutex_unlock(&iommu->lock);
-			kfree(group);
 			return -EINVAL;
 		}
 	}
 
-	/*
-	 * TODO: Domain have capabilities that might change as we add
-	 * groups (see iommu->cache, currently never set).  Check for
-	 * them and potentially disallow groups to be attached when it
-	 * would change capabilities (ugh).
-	 */
-	ret = iommu_attach_group(iommu->domain, iommu_group);
-	if (ret) {
-		mutex_unlock(&iommu->lock);
-		kfree(group);
-		return ret;
+	group = kzalloc(sizeof(*group), GFP_KERNEL);
+	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
+	if (!group || !domain) {
+		ret = -ENOMEM;
+		goto out_free;
 	}
 
 	group->iommu_group = iommu_group;
-	list_add(&group->next, &iommu->group_list);
+
+	/* Determine bus_type in order to allocate a domain */
+	ret = iommu_group_for_each_dev(iommu_group, domain, vfio_bus_type);
+	if (ret)
+		goto out_free;
+
+	domain->domain = iommu_domain_alloc(domain->bus);
+	if (!domain->domain) {
+		ret = -EIO;
+		goto out_free;
+	}
+
+	ret = iommu_attach_group(domain->domain, iommu_group);
+	if (ret)
+		goto out_domain;
+
+	INIT_LIST_HEAD(&domain->group_list);
+	list_add(&group->next, &domain->group_list);
+
+	if (!allow_unsafe_interrupts &&
+	    !iommu_domain_has_cap(domain->domain, IOMMU_CAP_INTR_REMAP)) {
+		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
+		       __func__);
+		ret = -EPERM;
+		goto out_detach;
+	}
+
+	if (iommu_domain_has_cap(domain->domain, IOMMU_CAP_CACHE_COHERENCY))
+		domain->prot |= IOMMU_CACHE;
+
+	/* Try to match an existing compatible domain. */
+	list_for_each_entry(d, &iommu->domain_list, next) {
+		if (d->bus == domain->bus && d->prot == domain->prot) {
+			iommu_detach_group(domain->domain, iommu_group);
+			if (!iommu_attach_group(d->domain, iommu_group)) {
+				list_add(&group->next, &d->group_list);
+				iommu_domain_free(domain->domain);
+				kfree(domain);
+				mutex_unlock(&iommu->lock);
+				return 0;
+			}
+
+			ret = iommu_attach_group(domain->domain, iommu_group);
+			if (ret)
+				goto out_domain;
+		}
+	}
+
+	/* replay mappings on new domains */
+	ret = vfio_iommu_replay(iommu, domain);
+	if (ret)
+		goto out_detach;
+
+	list_add(&domain->next, &iommu->domain_list);
 
 	mutex_unlock(&iommu->lock);
 
 	return 0;
+
+out_detach:
+	iommu_detach_group(domain->domain, iommu_group);
+out_domain:
+	iommu_domain_free(domain->domain);
+out_free:
+	kfree(domain);
+	kfree(group);
+	mutex_unlock(&iommu->lock);
+	return ret;
+}
+
+static void vfio_iommu_unmap_unpin_all(struct vfio_iommu *iommu)
+{
+	struct rb_node *node;
+
+	while ((node = rb_first(&iommu->dma_list)))
+		vfio_remove_dma(iommu, rb_entry(node, struct vfio_dma, node));
 }
 
 static void vfio_iommu_type1_detach_group(void *iommu_data,
 					  struct iommu_group *iommu_group)
 {
 	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_domain *domain;
 	struct vfio_group *group;
 
 	mutex_lock(&iommu->lock);
 
-	list_for_each_entry(group, &iommu->group_list, next) {
-		if (group->iommu_group == iommu_group) {
-			iommu_detach_group(iommu->domain, iommu_group);
+	list_for_each_entry(domain, &iommu->domain_list, next) {
+		list_for_each_entry(group, &domain->group_list, next) {
+			if (group->iommu_group != iommu_group)
+				continue;
+
+			iommu_detach_group(domain->domain, iommu_group);
 			list_del(&group->next);
 			kfree(group);
-			break;
+			/*
+			 * Group ownership provides privilege, if the group
+			 * list is empty, the domain goes away.  If it's the
+			 * last domain, then all the mappings go away too.
+			 */
+			if (list_empty(&domain->group_list)) {
+				if (list_is_singular(&iommu->domain_list))
+					vfio_iommu_unmap_unpin_all(iommu);
+				iommu_domain_free(domain->domain);
+				list_del(&domain->next);
+				kfree(domain);
+			}
+			goto done;
 		}
 	}
 
+done:
 	mutex_unlock(&iommu->lock);
 }
 
@@ -769,40 +821,17 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 {
 	struct vfio_iommu *iommu;
 
-	if (arg != VFIO_TYPE1_IOMMU)
+	if (arg != VFIO_TYPE1_IOMMU || arg != VFIO_TYPE1v2_IOMMU)
 		return ERR_PTR(-EINVAL);
 
 	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
 	if (!iommu)
 		return ERR_PTR(-ENOMEM);
 
-	INIT_LIST_HEAD(&iommu->group_list);
+	INIT_LIST_HEAD(&iommu->domain_list);
 	iommu->dma_list = RB_ROOT;
 	mutex_init(&iommu->lock);
-
-	/*
-	 * Wish we didn't have to know about bus_type here.
-	 */
-	iommu->domain = iommu_domain_alloc(&pci_bus_type);
-	if (!iommu->domain) {
-		kfree(iommu);
-		return ERR_PTR(-EIO);
-	}
-
-	/*
-	 * Wish we could specify required capabilities rather than create
-	 * a domain, see what comes out and hope it doesn't change along
-	 * the way.  Fortunately we know interrupt remapping is global for
-	 * our iommus.
-	 */
-	if (!allow_unsafe_interrupts &&
-	    !iommu_domain_has_cap(iommu->domain, IOMMU_CAP_INTR_REMAP)) {
-		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
-		       __func__);
-		iommu_domain_free(iommu->domain);
-		kfree(iommu);
-		return ERR_PTR(-EPERM);
-	}
+	iommu->v2 = (arg == VFIO_TYPE1v2_IOMMU);
 
 	return iommu;
 }
@@ -810,25 +839,24 @@ static void *vfio_iommu_type1_open(unsigned long arg)
 static void vfio_iommu_type1_release(void *iommu_data)
 {
 	struct vfio_iommu *iommu = iommu_data;
+	struct vfio_domain *domain, *domain_tmp;
 	struct vfio_group *group, *group_tmp;
-	struct rb_node *node;
 
-	list_for_each_entry_safe(group, group_tmp, &iommu->group_list, next) {
-		iommu_detach_group(iommu->domain, group->iommu_group);
-		list_del(&group->next);
-		kfree(group);
-	}
+	vfio_iommu_unmap_unpin_all(iommu);
 
-	while ((node = rb_first(&iommu->dma_list))) {
-		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
-		size_t size = dma->size;
-		vfio_remove_dma_overlap(iommu, dma->iova, &size, dma);
-		if (WARN_ON(!size))
-			break;
+	list_for_each_entry_safe(domain, domain_tmp,
+				 &iommu->domain_list, next) {
+		list_for_each_entry_safe(group, group_tmp,
+					 &domain->group_list, next) {
+			iommu_detach_group(domain->domain, group->iommu_group);
+			list_del(&group->next);
+			kfree(group);
+		}
+		iommu_domain_free(domain->domain);
+		list_del(&domain->next);
+		kfree(domain);
 	}
 
-	iommu_domain_free(iommu->domain);
-	iommu->domain = NULL;
 	kfree(iommu);
 }
 
@@ -858,7 +886,7 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
 
 		info.flags = 0;
 
-		info.iova_pgsizes = iommu->domain->ops->pgsize_bitmap;
+		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
 
 		return copy_to_user((void __user *)arg, &info, minsz);
 
@@ -911,9 +939,6 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 
 static int __init vfio_iommu_type1_init(void)
 {
-	if (!iommu_present(&pci_bus_type))
-		return -ENODEV;
-
 	return vfio_register_iommu_driver(&vfio_iommu_driver_ops_type1);
 }
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 0fd47f5..460fdf2 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -23,6 +23,7 @@
 
 #define VFIO_TYPE1_IOMMU		1
 #define VFIO_SPAPR_TCE_IOMMU		2
+#define VFIO_TYPE1v2_IOMMU		3
 
 /*
  * The IOCTL interface is designed for extensibility by embedding the

