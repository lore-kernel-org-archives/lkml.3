Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3CXPvd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab3CXPv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:51:29 -0400
Date: Sun, 24 Mar 2013 17:51:53 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
Message-ID: <20130324155153.GA8597@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment registering an MR breaks COW.  This breaks memory
overcommit for users such as KVM: we have a lot of COW pages, e.g.
instances of the zero page or pages shared using KSM.

If the application does not care that adapter sees stale data (for
example, it tracks writes reregisters and resends), it can use a new
IBV_ACCESS_GIFT flag to prevent registration from breaking COW.

The semantics are similar to that of SPLICE_F_GIFT thus the name.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Please review and consider for 3.10.

Changes from v1:
	rename APP_READONLY to _GIFT: similar to vmsplice's F_GIFT.

 drivers/infiniband/core/umem.c | 21 ++++++++++++---------
 include/rdma/ib_verbs.h        |  9 ++++++++-
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index a841123..5dee86d 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -89,6 +89,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	int ret;
 	int off;
 	int i;
+	bool gift, writable;
 	DEFINE_DMA_ATTRS(attrs);
 
 	if (dmasync)
@@ -96,6 +97,15 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 
 	if (!can_do_mlock())
 		return ERR_PTR(-EPERM);
+	/*
+	 * We ask for writable memory if any access flags other than
+	 * "remote read" or "gift" are set.  "Local write" and "remote write"
+	 * obviously require write access.  "Remote atomic" can do
+	 * things like fetch and add, which will modify memory, and
+	 * "MW bind" can change permissions by binding a window.
+	 */
+	gift  = access & IB_ACCESS_GIFT;
+	writable = access & ~(IB_ACCESS_REMOTE_READ | IB_ACCESS_GIFT);
 
 	umem = kmalloc(sizeof *umem, GFP_KERNEL);
 	if (!umem)
@@ -105,14 +115,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	umem->length    = size;
 	umem->offset    = addr & ~PAGE_MASK;
 	umem->page_size = PAGE_SIZE;
-	/*
-	 * We ask for writable memory if any access flags other than
-	 * "remote read" are set.  "Local write" and "remote write"
-	 * obviously require write access.  "Remote atomic" can do
-	 * things like fetch and add, which will modify memory, and
-	 * "MW bind" can change permissions by binding a window.
-	 */
-	umem->writable  = !!(access & ~IB_ACCESS_REMOTE_READ);
+	umem->writable  = writable;
 
 	/* We assume the memory is from hugetlb until proved otherwise */
 	umem->hugetlb   = 1;
@@ -152,7 +155,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 		ret = get_user_pages(current, current->mm, cur_base,
 				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
-				     1, !umem->writable, page_list, vma_list);
+				     !gift, !umem->writable, page_list, vma_list);
 
 		if (ret < 0)
 			goto out;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 98cc4b2..2e6e13c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -871,7 +871,14 @@ enum ib_access_flags {
 	IB_ACCESS_REMOTE_READ	= (1<<2),
 	IB_ACCESS_REMOTE_ATOMIC	= (1<<3),
 	IB_ACCESS_MW_BIND	= (1<<4),
-	IB_ZERO_BASED		= (1<<5)
+	IB_ZERO_BASED		= (1<<5),
+	/*
+	 * IB_ACCESS_GIFT: This memory is a gift to the adapter.  If memory is
+	 * modified after registration, the local version and data seen by the
+	 * adapter through this region rkey may differ.
+	 * Only legal with IB_ACCESS_REMOTE_READ or no permissions.
+	 */
+	IB_ACCESS_GIFT		= (1<<6)
 };
 
 struct ib_phys_buf {
-- 
MST
