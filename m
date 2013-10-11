Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab3JKKs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:48:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932336Ab3JKKoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nishanth Aravamudan <nacc@us.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 089/100] powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()
Date: Fri, 11 Oct 2013 11:41:59 +0100
Message-Id: <1381488130-30235-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 359f078..b2f4a8ed 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -501,7 +501,7 @@ struct iommu_table *iommu_init_table(struct iommu_table *tbl, int nid)
 	/* number of bytes needed for the bitmap */
 	sz = (tbl->it_size + 7) >> 3;
 
-	page = alloc_pages_node(nid, GFP_ATOMIC, get_order(sz));
+	page = alloc_pages_node(nid, GFP_KERNEL, get_order(sz));
 	if (!page)
 		panic("iommu_init_table: Can't allocate %ld bytes\n", sz);
 	tbl->it_map = page_address(page);
-- 
1.8.3.2

