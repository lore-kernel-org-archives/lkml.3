Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbbAWKPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:15:17 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:32137 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAWKPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:15:09 -0500
From: Bob Liu <bob.liu@oracle.com>
To: xen-devel@lists.xen.org
Cc: david.vrabel@citrix.com, linux-kernel@vger.kernel.org,
        roger.pau@citrix.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, wei.liu2@citrix.com,
        Bob Liu <bob.liu@oracle.com>
Subject: [PATCH 1/2] xenbus_client: extend interface to suppurt multi-page ring
Date: Fri, 23 Jan 2015 18:14:30 +0800
Message-Id: <1422008071-27643-1-git-send-email-bob.liu@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Liu <wei.liu2@citrix.com>

Originally Xen PV drivers only use single-page ring to pass along
information. This might limit the throughput between frontend and
backend.

The patch extends Xenbus driver to support multi-page ring, which in
general should improve throughput if ring is the bottleneck. Changes to
various frontend / backend to adapt to the new interface are also
included.

Affected Xen drivers:
* blkfront/back
* netfront/back
* pcifront/back
* tpmfront

The interface is documented, as before, in xenbus_client.c.

Change in V2:
* allow ring has arbitrary number of pages <= XENBUS_MAX_RING_PAGES

Change in V3:
* update function prototypes
* carefully deal with types of different sizes

Change in V4:
* use PAGE_KERNEL instead of PAGE_KERNEL_IO to avoid breakage on Arm

Change in V5:
* fix off-by-one error and other minor glitches spotted by Mathew Daley

Signed-off-by: Wei Liu <wei.liu2@citrix.com>
Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/block/xen-blkback/xenbus.c |    5 +-
 drivers/block/xen-blkfront.c       |    5 +-
 drivers/char/tpm/xen-tpmfront.c    |    5 +-
 drivers/net/xen-netback/netback.c  |    4 +-
 drivers/net/xen-netfront.c         |    9 +-
 drivers/pci/xen-pcifront.c         |    5 +-
 drivers/xen/xen-pciback/xenbus.c   |    2 +-
 drivers/xen/xenbus/xenbus_client.c |  390 ++++++++++++++++++++++++++----------
 include/xen/xenbus.h               |   20 +-
 9 files changed, 318 insertions(+), 127 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 630a489..cbd13c9 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -193,7 +193,7 @@ fail:
 	return ERR_PTR(-ENOMEM);
 }
 
-static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
+static int xen_blkif_map(struct xen_blkif *blkif, grant_ref_t gref,
 			 unsigned int evtchn)
 {
 	int err;
@@ -202,7 +202,8 @@ static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
 	if (blkif->irq)
 		return 0;
 
-	err = xenbus_map_ring_valloc(blkif->be->dev, shared_page, &blkif->blk_ring);
+	err = xenbus_map_ring_valloc(blkif->be->dev, &gref, 1,
+			&blkif->blk_ring);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 2236c6f..2fcf75d 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1246,6 +1246,7 @@ static int setup_blkring(struct xenbus_device *dev,
 {
 	struct blkif_sring *sring;
 	int err;
+	grant_ref_t gref;
 
 	info->ring_ref = GRANT_INVALID_REF;
 
@@ -1257,13 +1258,13 @@ static int setup_blkring(struct xenbus_device *dev,
 	SHARED_RING_INIT(sring);
 	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
-	err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
+	err = xenbus_grant_ring(dev, info->ring.sring, 1, &gref);
 	if (err < 0) {
 		free_page((unsigned long)sring);
 		info->ring.sring = NULL;
 		goto fail;
 	}
-	info->ring_ref = err;
+	info->ring_ref = gref;
 
 	err = xenbus_alloc_evtchn(dev, &info->evtchn);
 	if (err)
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index 441b44e..d3df997 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -193,6 +193,7 @@ static int setup_ring(struct xenbus_device *dev, struct tpm_private *priv)
 	struct xenbus_transaction xbt;
 	const char *message = NULL;
 	int rv;
+	grant_ref_t gref;
 
 	priv->shr = (void *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
 	if (!priv->shr) {
@@ -200,11 +201,11 @@ static int setup_ring(struct xenbus_device *dev, struct tpm_private *priv)
 		return -ENOMEM;
 	}
 
-	rv = xenbus_grant_ring(dev, virt_to_mfn(priv->shr));
+	rv = xenbus_grant_ring(dev, &priv->shr, 1, &gref);
 	if (rv < 0)
 		return rv;
 
-	priv->ring_ref = rv;
+	priv->ring_ref = gref;
 
 	rv = xenbus_alloc_evtchn(dev, &priv->evtchn);
 	if (rv)
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 908e65e..8513764 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1955,7 +1955,7 @@ int xenvif_map_frontend_rings(struct xenvif_queue *queue,
 	int err = -ENOMEM;
 
 	err = xenbus_map_ring_valloc(xenvif_to_xenbus_device(queue->vif),
-				     tx_ring_ref, &addr);
+				&tx_ring_ref, 1, &addr);
 	if (err)
 		goto err;
 
@@ -1963,7 +1963,7 @@ int xenvif_map_frontend_rings(struct xenvif_queue *queue,
 	BACK_RING_INIT(&queue->tx, txs, PAGE_SIZE);
 
 	err = xenbus_map_ring_valloc(xenvif_to_xenbus_device(queue->vif),
-				     rx_ring_ref, &addr);
+				&rx_ring_ref, 1, &addr);
 	if (err)
 		goto err;
 
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 22bcb4e..b97d26a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1531,6 +1531,7 @@ static int setup_netfront(struct xenbus_device *dev,
 	struct xen_netif_tx_sring *txs;
 	struct xen_netif_rx_sring *rxs;
 	int err;
+	grant_ref_t gref;
 
 	queue->tx_ring_ref = GRANT_INVALID_REF;
 	queue->rx_ring_ref = GRANT_INVALID_REF;
@@ -1546,10 +1547,10 @@ static int setup_netfront(struct xenbus_device *dev,
 	SHARED_RING_INIT(txs);
 	FRONT_RING_INIT(&queue->tx, txs, PAGE_SIZE);
 
-	err = xenbus_grant_ring(dev, virt_to_mfn(txs));
+	err = xenbus_grant_ring(dev, txs, 1, &gref);
 	if (err < 0)
 		goto grant_tx_ring_fail;
-	queue->tx_ring_ref = err;
+	queue->tx_ring_ref = gref;
 
 	rxs = (struct xen_netif_rx_sring *)get_zeroed_page(GFP_NOIO | __GFP_HIGH);
 	if (!rxs) {
@@ -1560,10 +1561,10 @@ static int setup_netfront(struct xenbus_device *dev,
 	SHARED_RING_INIT(rxs);
 	FRONT_RING_INIT(&queue->rx, rxs, PAGE_SIZE);
 
-	err = xenbus_grant_ring(dev, virt_to_mfn(rxs));
+	err = xenbus_grant_ring(dev, rxs, 1, &gref);
 	if (err < 0)
 		goto grant_rx_ring_fail;
-	queue->rx_ring_ref = err;
+	queue->rx_ring_ref = gref;
 
 	if (feature_split_evtchn)
 		err = setup_netfront_split(queue);
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index b1ffebe..7cfd2db 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -777,12 +777,13 @@ static int pcifront_publish_info(struct pcifront_device *pdev)
 {
 	int err = 0;
 	struct xenbus_transaction trans;
+	grant_ref_t gref;
 
-	err = xenbus_grant_ring(pdev->xdev, virt_to_mfn(pdev->sh_info));
+	err = xenbus_grant_ring(pdev->xdev, pdev->sh_info, 1, &gref);
 	if (err < 0)
 		goto out;
 
-	pdev->gnt_ref = err;
+	pdev->gnt_ref = gref;
 
 	err = xenbus_alloc_evtchn(pdev->xdev, &pdev->evtchn);
 	if (err)
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index fe17c80..98bc345 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -113,7 +113,7 @@ static int xen_pcibk_do_attach(struct xen_pcibk_device *pdev, int gnt_ref,
 		"Attaching to frontend resources - gnt_ref=%d evtchn=%d\n",
 		gnt_ref, remote_evtchn);
 
-	err = xenbus_map_ring_valloc(pdev->xdev, gnt_ref, &vaddr);
+	err = xenbus_map_ring_valloc(pdev->xdev, &gnt_ref, 1, &vaddr);
 	if (err < 0) {
 		xenbus_dev_fatal(pdev->xdev, err,
 				"Error mapping other domain page in ours.");
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index ca74410..7ef161a 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -52,17 +52,24 @@
 struct xenbus_map_node {
 	struct list_head next;
 	union {
-		struct vm_struct *area; /* PV */
-		struct page *page;     /* HVM */
+		struct {
+			struct vm_struct *area;
+		} pv;
+		struct {
+			struct page *pages[XENBUS_MAX_RING_PAGES];
+			void *addr;
+		} hvm;
 	};
-	grant_handle_t handle;
+	grant_handle_t handles[XENBUS_MAX_RING_PAGES];
+	unsigned int   nr_handles;
 };
 
 static DEFINE_SPINLOCK(xenbus_valloc_lock);
 static LIST_HEAD(xenbus_valloc_pages);
 
 struct xenbus_ring_ops {
-	int (*map)(struct xenbus_device *dev, int gnt, void **vaddr);
+	int (*map)(struct xenbus_device *dev, grant_ref_t *gnt_refs,
+			unsigned int nr_grefs, void **vaddr);
 	int (*unmap)(struct xenbus_device *dev, void *vaddr);
 };
 
@@ -355,17 +362,39 @@ static void xenbus_switch_fatal(struct xenbus_device *dev, int depth, int err,
 /**
  * xenbus_grant_ring
  * @dev: xenbus device
- * @ring_mfn: mfn of ring to grant
-
- * Grant access to the given @ring_mfn to the peer of the given device.  Return
- * a grant reference on success, or -errno on error. On error, the device will
- * switch to XenbusStateClosing, and the error will be saved in the store.
+ * @vaddr: starting virtual address of the ring
+ * @nr_pages: number of pages to be granted
+ * @grefs: grant reference array to be filled in
+ *
+ * Grant access to the given @vaddr to the peer of the given device.
+ * Then fill in @grefs with grant references.  Return a grant reference on
+ * success, or -errno on error.  On error, the device will switch to
+ * XenbusStateClosing, and the error will be saved in the store.
  */
-int xenbus_grant_ring(struct xenbus_device *dev, unsigned long ring_mfn)
+int xenbus_grant_ring(struct xenbus_device *dev, void *vaddr,
+		unsigned int nr_pages, grant_ref_t *grefs)
 {
-	int err = gnttab_grant_foreign_access(dev->otherend_id, ring_mfn, 0);
-	if (err < 0)
-		xenbus_dev_fatal(dev, err, "granting access to ring page");
+	int err;
+	int i, j;
+
+	for (i = 0; i < nr_pages; i++) {
+		unsigned long addr = (unsigned long)vaddr +
+			(PAGE_SIZE * i);
+		err = gnttab_grant_foreign_access(dev->otherend_id,
+				virt_to_mfn(addr), 0);
+		if (err < 0) {
+			xenbus_dev_fatal(dev, err,
+					"granting access to ring page");
+			goto fail;
+		}
+		grefs[i] = err;
+	}
+
+	return 0;
+
+fail:
+	for (j = 0; j < i; j++)
+		gnttab_end_foreign_access_ref(grefs[j], 0);
 	return err;
 }
 EXPORT_SYMBOL_GPL(xenbus_grant_ring);
@@ -419,62 +448,129 @@ EXPORT_SYMBOL_GPL(xenbus_free_evtchn);
 /**
  * xenbus_map_ring_valloc
  * @dev: xenbus device
- * @gnt_ref: grant reference
+ * @gnt_refs: grant reference array
+ * @nr_grefs: number of grant references
  * @vaddr: pointer to address to be filled out by mapping
  *
- * Based on Rusty Russell's skeleton driver's map_page.
- * Map a page of memory into this domain from another domain's grant table.
- * xenbus_map_ring_valloc allocates a page of virtual address space, maps the
- * page to that address, and sets *vaddr to that address.
- * Returns 0 on success, and GNTST_* (see xen/include/interface/grant_table.h)
- * or -ENOMEM on error. If an error is returned, device will switch to
+ * Map @nr_grefs pages of memory into this domain from another
+ * domain's grant table.  xenbus_map_ring_valloc allocates @nr_grefs
+ * pages of virtual address space, maps the pages to that address, and
+ * sets *vaddr to that address.  Returns 0 on success, and GNTST_*
+ * (see xen/include/interface/grant_table.h) or -ENOMEM / -EINVAL on
+ * error. If an error is returned, device will switch to
  * XenbusStateClosing and the error message will be saved in XenStore.
  */
-int xenbus_map_ring_valloc(struct xenbus_device *dev, int gnt_ref, void **vaddr)
+int xenbus_map_ring_valloc(struct xenbus_device *dev, grant_ref_t *gnt_refs,
+		unsigned int nr_grefs, void **vaddr)
 {
-	return ring_ops->map(dev, gnt_ref, vaddr);
+	return ring_ops->map(dev, gnt_refs, nr_grefs, vaddr);
 }
 EXPORT_SYMBOL_GPL(xenbus_map_ring_valloc);
 
+/* N.B. sizeof(phys_addr_t) doesn't always equal to sizeof(unsigned
+ * long), e.g. 32-on-64.  Caller is responsible for preparing the
+ * right array to feed into this function */
+static int __xenbus_map_ring(struct xenbus_device *dev,
+		grant_ref_t *gnt_refs,
+		unsigned int nr_grefs,
+		grant_handle_t *handles,
+		phys_addr_t *addrs,
+		unsigned int flags,
+		bool *leaked)
+{
+	struct gnttab_map_grant_ref map[XENBUS_MAX_RING_PAGES];
+	struct gnttab_unmap_grant_ref unmap[XENBUS_MAX_RING_PAGES];
+	int i, j;
+	int err = GNTST_okay;
+
+	if (nr_grefs > XENBUS_MAX_RING_PAGES)
+		return -EINVAL;
+
+	for (i = 0; i < nr_grefs; i++) {
+		memset(&map[i], 0, sizeof(map[i]));
+		gnttab_set_map_op(&map[i], addrs[i], flags, gnt_refs[i],
+				dev->otherend_id);
+		handles[i] = INVALID_GRANT_HANDLE;
+	}
+
+	gnttab_batch_map(map, i);
+
+	for (i = 0; i < nr_grefs; i++) {
+		if (map[i].status != GNTST_okay) {
+			err = map[i].status;
+			xenbus_dev_fatal(dev, map[i].status,
+					"mapping in shared page %d from domain %d",
+					gnt_refs[i], dev->otherend_id);
+			goto fail;
+		} else
+			handles[i] = map[i].handle;
+	}
+
+	return GNTST_okay;
+
+fail:
+	for (i = j = 0; i < nr_grefs; i++) {
+		if (handles[i] != INVALID_GRANT_HANDLE) {
+			memset(&unmap[j], 0, sizeof(unmap[j]));
+			gnttab_set_unmap_op(&unmap[j], (phys_addr_t)addrs[i],
+					GNTMAP_host_map, handles[i]);
+			j++;
+		}
+	}
+
+	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap, j))
+		BUG();
+
+	*leaked = false;
+	for (i = 0; i < j; i++) {
+		if (unmap[i].status != GNTST_okay) {
+			*leaked = true;
+			break;
+		}
+	}
+
+	return err;
+}
+
 static int xenbus_map_ring_valloc_pv(struct xenbus_device *dev,
-				     int gnt_ref, void **vaddr)
+		grant_ref_t *gnt_refs, unsigned int nr_grefs, void **vaddr)
 {
-	struct gnttab_map_grant_ref op = {
-		.flags = GNTMAP_host_map | GNTMAP_contains_pte,
-		.ref   = gnt_ref,
-		.dom   = dev->otherend_id,
-	};
 	struct xenbus_map_node *node;
 	struct vm_struct *area;
-	pte_t *pte;
+	pte_t *ptes[XENBUS_MAX_RING_PAGES];
+	phys_addr_t phys_addrs[XENBUS_MAX_RING_PAGES];
+	int err = GNTST_okay;
+	int i;
+	bool leaked;
 
 	*vaddr = NULL;
 
+	if (nr_grefs > XENBUS_MAX_RING_PAGES)
+		return -EINVAL;
+
+
 	node = kzalloc(sizeof(*node), GFP_KERNEL);
 	if (!node)
 		return -ENOMEM;
 
-	area = alloc_vm_area(PAGE_SIZE, &pte);
+	area = alloc_vm_area(PAGE_SIZE * nr_grefs, ptes);
 	if (!area) {
 		kfree(node);
 		return -ENOMEM;
 	}
 
-	op.host_addr = arbitrary_virt_to_machine(pte).maddr;
-
-	gnttab_batch_map(&op, 1);
+	for (i = 0; i < nr_grefs; i++)
+		phys_addrs[i] = arbitrary_virt_to_machine(ptes[i]).maddr;
 
-	if (op.status != GNTST_okay) {
-		free_vm_area(area);
-		kfree(node);
-		xenbus_dev_fatal(dev, op.status,
-				 "mapping in shared page %d from domain %d",
-				 gnt_ref, dev->otherend_id);
-		return op.status;
-	}
+	err = __xenbus_map_ring(dev, gnt_refs, nr_grefs, node->handles,
+			phys_addrs,
+			GNTMAP_host_map | GNTMAP_contains_pte,
+			&leaked);
+	if (err)
+		goto failed;
 
-	node->handle = op.handle;
-	node->area = area;
+	node->nr_handles = nr_grefs;
+	node->pv.area = area;
 
 	spin_lock(&xenbus_valloc_lock);
 	list_add(&node->next, &xenbus_valloc_pages);
@@ -482,14 +578,30 @@ static int xenbus_map_ring_valloc_pv(struct xenbus_device *dev,
 
 	*vaddr = area->addr;
 	return 0;
+
+failed:
+	if (!leaked)
+		free_vm_area(area);
+	else
+		pr_alert("leaking VM area %p size %u page(s)", area, nr_grefs);
+
+	kfree(node);
+	return err;
 }
 
 static int xenbus_map_ring_valloc_hvm(struct xenbus_device *dev,
-				      int gnt_ref, void **vaddr)
+		grant_ref_t *gnt_ref, unsigned int nr_grefs, void **vaddr)
 {
 	struct xenbus_map_node *node;
-	int err;
+	int err, i;
 	void *addr;
+	bool leaked = false;
+	/* Why do we need two arrays? See comment of __xenbus_map_ring */
+	phys_addr_t phys_addrs[XENBUS_MAX_RING_PAGES];
+	unsigned long addrs[XENBUS_MAX_RING_PAGES];
+
+	if (nr_grefs > XENBUS_MAX_RING_PAGES)
+		return -EINVAL;
 
 	*vaddr = NULL;
 
@@ -497,15 +609,30 @@ static int xenbus_map_ring_valloc_hvm(struct xenbus_device *dev,
 	if (!node)
 		return -ENOMEM;
 
-	err = alloc_xenballooned_pages(1, &node->page, false /* lowmem */);
+	err = alloc_xenballooned_pages(nr_grefs, node->hvm.pages, false /* lowmem */);
 	if (err)
 		goto out_err;
 
-	addr = pfn_to_kaddr(page_to_pfn(node->page));
+	for (i = 0; i < nr_grefs; i++) {
+		unsigned long pfn = page_to_pfn(node->hvm.pages[i]);
+		phys_addrs[i] = (unsigned long)pfn_to_kaddr(pfn);
+		addrs[i] = (unsigned long)pfn_to_kaddr(pfn);
+	}
 
-	err = xenbus_map_ring(dev, gnt_ref, &node->handle, addr);
+	err = __xenbus_map_ring(dev, gnt_ref, nr_grefs, node->handles,
+			phys_addrs, GNTMAP_host_map, &leaked);
+	node->nr_handles = nr_grefs;
 	if (err)
-		goto out_err_free_ballooned_pages;
+		goto out_free_ballooned_pages;
+
+	addr = vmap(node->hvm.pages, nr_grefs, VM_MAP | VM_IOREMAP,
+			PAGE_KERNEL);
+	if (!addr) {
+		err = -ENOMEM;
+		goto out_xenbus_unmap_ring;
+	}
+
+	node->hvm.addr = addr;
 
 	spin_lock(&xenbus_valloc_lock);
 	list_add(&node->next, &xenbus_valloc_pages);
@@ -514,9 +641,17 @@ static int xenbus_map_ring_valloc_hvm(struct xenbus_device *dev,
 	*vaddr = addr;
 	return 0;
 
- out_err_free_ballooned_pages:
-	free_xenballooned_pages(1, &node->page);
- out_err:
+out_xenbus_unmap_ring:
+	if (!leaked)
+		xenbus_unmap_ring(dev, node->handles, node->nr_handles,
+				addrs);
+	else
+		pr_alert("leaking %p size %u page(s)",
+				addr, nr_grefs);
+out_free_ballooned_pages:
+	if (!leaked)
+		free_xenballooned_pages(nr_grefs, node->hvm.pages);
+out_err:
 	kfree(node);
 	return err;
 }
@@ -525,35 +660,37 @@ static int xenbus_map_ring_valloc_hvm(struct xenbus_device *dev,
 /**
  * xenbus_map_ring
  * @dev: xenbus device
- * @gnt_ref: grant reference
- * @handle: pointer to grant handle to be filled
- * @vaddr: address to be mapped to
+ * @gnt_refs: grant reference array
+ * @nr_grefs: number of grant reference
+ * @handles: pointer to grant handle to be filled
+ * @vaddrs: addresses to be mapped to
+ * @leaked: fail to clean up a failed map, caller should not free vaddr
  *
- * Map a page of memory into this domain from another domain's grant table.
+ * Map pages of memory into this domain from another domain's grant table.
  * xenbus_map_ring does not allocate the virtual address space (you must do
- * this yourself!). It only maps in the page to the specified address.
+ * this yourself!). It only maps in the pages to the specified address.
  * Returns 0 on success, and GNTST_* (see xen/include/interface/grant_table.h)
- * or -ENOMEM on error. If an error is returned, device will switch to
- * XenbusStateClosing and the error message will be saved in XenStore.
+ * or -ENOMEM / -EINVAL on error. If an error is returned, device will switch to
+ * XenbusStateClosing and the first error message will be saved in XenStore.
+ * Further more if we fail to map the ring, caller should check @leaked.
+ * If @leaked is not zero it means xenbus_map_ring fails to clean up, caller
+ * should not free the address space of @vaddr.
  */
-int xenbus_map_ring(struct xenbus_device *dev, int gnt_ref,
-		    grant_handle_t *handle, void *vaddr)
+int xenbus_map_ring(struct xenbus_device *dev, grant_ref_t *gnt_refs,
+		unsigned int nr_grefs, grant_handle_t *handles,
+		unsigned long *vaddrs, bool *leaked)
 {
-	struct gnttab_map_grant_ref op;
-
-	gnttab_set_map_op(&op, (unsigned long)vaddr, GNTMAP_host_map, gnt_ref,
-			  dev->otherend_id);
+	phys_addr_t phys_addrs[XENBUS_MAX_RING_PAGES];
+	int i;
 
-	gnttab_batch_map(&op, 1);
+	if (nr_grefs > XENBUS_MAX_RING_PAGES)
+		return -EINVAL;
 
-	if (op.status != GNTST_okay) {
-		xenbus_dev_fatal(dev, op.status,
-				 "mapping in shared page %d from domain %d",
-				 gnt_ref, dev->otherend_id);
-	} else
-		*handle = op.handle;
+	for (i = 0; i < nr_grefs; i++)
+		phys_addrs[i] = (unsigned long)vaddrs[i];
 
-	return op.status;
+	return __xenbus_map_ring(dev, gnt_refs, nr_grefs, handles,
+			phys_addrs, GNTMAP_host_map, leaked);
 }
 EXPORT_SYMBOL_GPL(xenbus_map_ring);
 
@@ -563,8 +700,7 @@ EXPORT_SYMBOL_GPL(xenbus_map_ring);
  * @dev: xenbus device
  * @vaddr: addr to unmap
  *
- * Based on Rusty Russell's skeleton driver's unmap_page.
- * Unmap a page of memory in this domain that was imported from another domain.
+ * Unmap memory in this domain that was imported from another domain.
  * Use xenbus_unmap_ring_vfree if you mapped in your memory with
  * xenbus_map_ring_valloc (it will free the virtual address space).
  * Returns 0 on success and returns GNTST_* on error
@@ -579,20 +715,21 @@ EXPORT_SYMBOL_GPL(xenbus_unmap_ring_vfree);
 static int xenbus_unmap_ring_vfree_pv(struct xenbus_device *dev, void *vaddr)
 {
 	struct xenbus_map_node *node;
-	struct gnttab_unmap_grant_ref op = {
-		.host_addr = (unsigned long)vaddr,
-	};
+	struct gnttab_unmap_grant_ref unmap[XENBUS_MAX_RING_PAGES];
 	unsigned int level;
+	int i;
+	bool leaked = false;
+	int err;
 
 	spin_lock(&xenbus_valloc_lock);
 	list_for_each_entry(node, &xenbus_valloc_pages, next) {
-		if (node->area->addr == vaddr) {
+		if (node->pv.area->addr == vaddr) {
 			list_del(&node->next);
 			goto found;
 		}
 	}
 	node = NULL;
- found:
+found:
 	spin_unlock(&xenbus_valloc_lock);
 
 	if (!node) {
@@ -601,22 +738,42 @@ static int xenbus_unmap_ring_vfree_pv(struct xenbus_device *dev, void *vaddr)
 		return GNTST_bad_virt_addr;
 	}
 
-	op.handle = node->handle;
-	op.host_addr = arbitrary_virt_to_machine(
-		lookup_address((unsigned long)vaddr, &level)).maddr;
+	for (i = 0; i < node->nr_handles; i++) {
+		unsigned long addr;
 
-	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, &op, 1))
+		memset(&unmap[i], 0, sizeof(unmap[i]));
+		addr = (unsigned long)vaddr + (PAGE_SIZE * i);
+		unmap[i].host_addr = arbitrary_virt_to_machine(
+				lookup_address(addr, &level)).maddr;
+		unmap[i].dev_bus_addr = 0;
+		unmap[i].handle = node->handles[i];
+	}
+
+	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap, i))
 		BUG();
 
-	if (op.status == GNTST_okay)
-		free_vm_area(node->area);
+	err = GNTST_okay;
+	leaked = false;
+	for (i = 0; i < node->nr_handles; i++) {
+		if (unmap[i].status != GNTST_okay) {
+			leaked = true;
+			xenbus_dev_error(dev, unmap[i].status,
+					"unmapping page at handle %d error %d",
+					node->handles[i], unmap[i].status);
+			err = unmap[i].status;
+			break;
+		}
+	}
+
+	if (!leaked)
+		free_vm_area(node->pv.area);
+
 	else
-		xenbus_dev_error(dev, op.status,
-				 "unmapping page at handle %d error %d",
-				 node->handle, op.status);
+		pr_alert("leaking VM area %p size %u page(s)",
+				node->pv.area, node->nr_handles);
 
 	kfree(node);
-	return op.status;
+	return err;
 }
 
 static int xenbus_unmap_ring_vfree_hvm(struct xenbus_device *dev, void *vaddr)
@@ -624,10 +781,12 @@ static int xenbus_unmap_ring_vfree_hvm(struct xenbus_device *dev, void *vaddr)
 	int rv;
 	struct xenbus_map_node *node;
 	void *addr;
+	unsigned long addrs[XENBUS_MAX_RING_PAGES];
+	int i;
 
 	spin_lock(&xenbus_valloc_lock);
 	list_for_each_entry(node, &xenbus_valloc_pages, next) {
-		addr = pfn_to_kaddr(page_to_pfn(node->page));
+		addr = node->hvm.addr;
 		if (addr == vaddr) {
 			list_del(&node->next);
 			goto found;
@@ -643,12 +802,16 @@ static int xenbus_unmap_ring_vfree_hvm(struct xenbus_device *dev, void *vaddr)
 		return GNTST_bad_virt_addr;
 	}
 
-	rv = xenbus_unmap_ring(dev, node->handle, addr);
+	for (i = 0; i < node->nr_handles; i++)
+		addrs[i] = (unsigned long)pfn_to_kaddr(page_to_pfn(node->hvm.pages[i]));
 
+	rv = xenbus_unmap_ring(dev, node->handles, node->nr_handles,
+			addrs);
 	if (!rv)
-		free_xenballooned_pages(1, &node->page);
+		vunmap(vaddr);
 	else
-		WARN(1, "Leaking %p\n", vaddr);
+		WARN(1, "Leaking %p, size %u page(s)\n", vaddr,
+				node->nr_handles);
 
 	kfree(node);
 	return rv;
@@ -657,29 +820,44 @@ static int xenbus_unmap_ring_vfree_hvm(struct xenbus_device *dev, void *vaddr)
 /**
  * xenbus_unmap_ring
  * @dev: xenbus device
- * @handle: grant handle
- * @vaddr: addr to unmap
+ * @handles: grant handle array
+ * @nr_handles: number of handles in the array
+ * @vaddrs: addresses to unmap
  *
- * Unmap a page of memory in this domain that was imported from another domain.
+ * Unmap memory in this domain that was imported from another domain.
  * Returns 0 on success and returns GNTST_* on error
  * (see xen/include/interface/grant_table.h).
  */
 int xenbus_unmap_ring(struct xenbus_device *dev,
-		      grant_handle_t handle, void *vaddr)
+		grant_handle_t *handles, unsigned int nr_handles,
+		unsigned long *vaddrs)
 {
-	struct gnttab_unmap_grant_ref op;
+	struct gnttab_unmap_grant_ref unmap[XENBUS_MAX_RING_PAGES];
+	int i;
+	int err;
 
-	gnttab_set_unmap_op(&op, (unsigned long)vaddr, GNTMAP_host_map, handle);
+	if (nr_handles > XENBUS_MAX_RING_PAGES)
+		return -EINVAL;
 
-	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, &op, 1))
+	for (i = 0; i < nr_handles; i++)
+		gnttab_set_unmap_op(&unmap[i], vaddrs[i],
+				GNTMAP_host_map, handles[i]);
+
+	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, unmap, i))
 		BUG();
 
-	if (op.status != GNTST_okay)
-		xenbus_dev_error(dev, op.status,
-				 "unmapping page at handle %d error %d",
-				 handle, op.status);
+	err = GNTST_okay;
+	for (i = 0; i < nr_handles; i++) {
+		if (unmap[i].status != GNTST_okay) {
+			xenbus_dev_error(dev, unmap[i].status,
+					"unmapping page at handle %d error %d",
+					handles[i], unmap[i].status);
+			err = unmap[i].status;
+			break;
+		}
+	}
 
-	return op.status;
+	return err;
 }
 EXPORT_SYMBOL_GPL(xenbus_unmap_ring);
 
diff --git a/include/xen/xenbus.h b/include/xen/xenbus.h
index b78f21c..84cd1e4 100644
--- a/include/xen/xenbus.h
+++ b/include/xen/xenbus.h
@@ -46,6 +46,10 @@
 #include <xen/interface/io/xenbus.h>
 #include <xen/interface/io/xs_wire.h>
 
+#define XENBUS_MAX_RING_PAGE_ORDER 4
+#define XENBUS_MAX_RING_PAGES      (1U << XENBUS_MAX_RING_PAGE_ORDER)
+#define INVALID_GRANT_HANDLE       (~0U)
+
 /* Register callback to watch this node. */
 struct xenbus_watch
 {
@@ -199,15 +203,19 @@ int xenbus_watch_pathfmt(struct xenbus_device *dev, struct xenbus_watch *watch,
 			 const char *pathfmt, ...);
 
 int xenbus_switch_state(struct xenbus_device *dev, enum xenbus_state new_state);
-int xenbus_grant_ring(struct xenbus_device *dev, unsigned long ring_mfn);
-int xenbus_map_ring_valloc(struct xenbus_device *dev,
-			   int gnt_ref, void **vaddr);
-int xenbus_map_ring(struct xenbus_device *dev, int gnt_ref,
-			   grant_handle_t *handle, void *vaddr);
+int xenbus_grant_ring(struct xenbus_device *dev, void *vaddr,
+		unsigned int nr_pages, grant_ref_t *grefs);
+int xenbus_map_ring_valloc(struct xenbus_device *dev, grant_ref_t *gnt_refs,
+		unsigned int nr_grefs, void **vaddr);
+int xenbus_map_ring(struct xenbus_device *dev,
+		grant_ref_t *gnt_refs, unsigned int nr_grefs,
+		grant_handle_t *handles, unsigned long *vaddrs,
+		bool *leaked);
 
 int xenbus_unmap_ring_vfree(struct xenbus_device *dev, void *vaddr);
 int xenbus_unmap_ring(struct xenbus_device *dev,
-		      grant_handle_t handle, void *vaddr);
+		grant_handle_t *handles, unsigned int nr_handles,
+		unsigned long *vaddrs);
 
 int xenbus_alloc_evtchn(struct xenbus_device *dev, int *port);
 int xenbus_free_evtchn(struct xenbus_device *dev, int port);
-- 
1.7.10.4

