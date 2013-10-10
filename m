Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3JJPtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:49:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52976 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757483Ab3JJPtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:49:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nishanth Aravamudan <nacc@us.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 100/104] powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()
Date: Thu, 10 Oct 2013 08:42:28 -0700
Message-Id: <1381419752-29733-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>

commit 1cf389df090194a0976dc867b7fffe99d9d490cb upstream.

Under heavy (DLPAR?) stress, we tripped this panic() in
arch/powerpc/kernel/iommu.c::iommu_init_table():

	page = alloc_pages_node(nid, GFP_ATOMIC, get_order(sz));
	if (!page)
		panic("iommu_init_table: Can't allocate %ld bytes\n", sz);

Before the panic() we got a page allocation failure for an order-2
allocation. There appears to be memory free, but perhaps not in the
ATOMIC context. I looked through all the call-sites of
iommu_init_table() and didn't see any obvious reason to need an ATOMIC
allocation. Most call-sites in fact have an explicit GFP_KERNEL
allocation shortly before the call to iommu_init_table(), indicating we
are not in an atomic context. There is some indirection for some paths,
but I didn't see any locks indicating that GFP_KERNEL is inappropriate.

With this change under the same conditions, we have not been able to
reproduce the panic.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/kernel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index c862fd7..0eb8da2 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -658,7 +658,7 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 	/* number of bytes needed for the bitmap */
 	sz = BITS_TO_LONGS(tbl->it_size) * sizeof(unsigned long);
 
-	page = alloc_pages_node(nid, GFP_ATOMIC, get_order(sz));
+	page = alloc_pages_node(nid, GFP_KERNEL, get_order(sz));
 	if (!page)
 		panic("iommu_init_table: Can't allocate %ld bytes\n", sz);
 	tbl->it_map = page_address(page);
-- 
1.8.1.2

