Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3JKU6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:58:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758054Ab3JKThO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Aravamudan <nacc@us.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 22/48] powerpc/iommu: Use GFP_KERNEL instead of GFP_ATOMIC in iommu_init_table()
Date: Fri, 11 Oct 2013 12:36:29 -0700
Message-Id: <20131011193639.658296572@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -501,7 +501,7 @@ struct iommu_table *iommu_init_table(str
 	/* number of bytes needed for the bitmap */
 	sz = (tbl->it_size + 7) >> 3;
 
-	page = alloc_pages_node(nid, GFP_ATOMIC, get_order(sz));
+	page = alloc_pages_node(nid, GFP_KERNEL, get_order(sz));
 	if (!page)
 		panic("iommu_init_table: Can't allocate %ld bytes\n", sz);
 	tbl->it_map = page_address(page);


