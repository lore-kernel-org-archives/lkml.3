Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788Ab3GaTyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 15:54:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60461 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760756Ab3GaTyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 15:54:32 -0400
X-IronPort-AV: E=Sophos;i="4.89,789,1367971200"; 
   d="scan'208";a="38620690"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 RFC 5/8] xen: introduce XENMEM_get_dma_buf and xen_put_dma_buf
Date: Wed, 31 Jul 2013 20:54:09 +0100
Message-ID: <1375300452-12545-5-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1307312048511.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307312048511.4893@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 include/xen/interface/memory.h |   62 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 2ecfe4f..ffd7f4e 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -263,4 +263,66 @@ struct xen_remove_from_physmap {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
 
+#define XENMEM_get_dma_buf             26
+/*
+ * This hypercall is similar to XENMEM_exchange: it exchanges the pages
+ * passed in with a new set of pages, contiguous and under 4G if so
+ * requested. The new pages are going to be "pinned": it's guaranteed
+ * that their p2m mapping won't be changed until explicitly "unpinned".
+ * If return code is zero then @out.extent_list provides the MFNs of the
+ * newly-allocated memory.  Returns zero on complete success, otherwise
+ * a negative error code.
+ * On complete success then always @nr_exchanged == @in.nr_extents.  On
+ * partial success @nr_exchanged indicates how much work was done.
+ */
+struct xen_get_dma_buf {
+    /*
+     * [IN] Details of memory extents to be exchanged (GMFN bases).
+     * Note that @in.address_bits is ignored and unused.
+     */
+    struct xen_memory_reservation in;
+
+    /*
+     * [IN/OUT] Details of new memory extents.
+     * We require that:
+     *  1. @in.domid == @out.domid
+     *  2. @in.nr_extents  << @in.extent_order == 
+     *     @out.nr_extents << @out.extent_order
+     *  3. @in.extent_start and @out.extent_start lists must not overlap
+     *  4. @out.extent_start lists GPFN bases to be populated
+     *  5. @out.extent_start is overwritten with allocated GMFN bases
+     */
+    struct xen_memory_reservation out;
+
+    /*
+     * [OUT] Number of input extents that were successfully exchanged:
+     *  1. The first @nr_exchanged input extents were successfully
+     *     deallocated.
+     *  2. The corresponding first entries in the output extent list correctly
+     *     indicate the GMFNs that were successfully exchanged.
+     *  3. All other input and output extents are untouched.
+     *  4. If not all input exents are exchanged then the return code of this
+     *     command will be non-zero.
+     *  5. THIS FIELD MUST BE INITIALISED TO ZERO BY THE CALLER!
+     */
+    xen_ulong_t nr_exchanged;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_get_dma_buf);
+
+#define XENMEM_put_dma_buf             27
+/*
+ * XENMEM_put_dma_buf unpins a set of pages, previously pinned by
+ * XENMEM_get_dma_buf. After this call the p2m mapping of the pages can
+ * be transparently changed by the hypervisor, as usual. The pages are
+ * still accessible from the guest.
+ */
+struct xen_put_dma_buf {
+    /*
+     * [IN] Details of memory extents to be exchanged (GMFN bases).
+     * Note that @in.address_bits is ignored and unused.
+     */
+    struct xen_memory_reservation in;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_put_dma_buf);
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
-- 
1.7.2.5

