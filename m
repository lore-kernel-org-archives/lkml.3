Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3I0QgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:36:07 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7960 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab3I0QgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:36:03 -0400
X-IronPort-AV: E=Sophos;i="4.90,994,1371081600"; 
   d="scan'208";a="58131108"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v6 17/19] xen: introduce XENMEM_pin
Date: Fri, 27 Sep 2013 17:10:05 +0100
Message-ID: <1380298207-29151-17-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new hypercall to pin one or more pages whose machine
addresses respect a dma_mask passed as an argument

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/mm.c              |   16 ++++++++++++++++
 arch/x86/xen/mmu.c             |    7 +++++++
 include/xen/interface/memory.h |   32 ++++++++++++++++++++++++++++++++
 include/xen/xen-ops.h          |    1 +
 4 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
index b305b94..146c1c3 100644
--- a/arch/arm/xen/mm.c
+++ b/arch/arm/xen/mm.c
@@ -55,6 +55,22 @@ static int xen_exchange_memory(xen_ulong_t extents_in,
 	return success;
 }
 
+int xen_pin_page(xen_pfn_t *in_frame, unsigned int address_bits)
+{
+	struct xen_pin pin = {
+		.in = {
+			.nr_extents   = 1,
+			.extent_order = 0,
+			.domid        = DOMID_SELF,
+			.address_bits = address_bits
+		},
+	};
+	set_xen_guest_handle(pin.in.extent_start, in_frame);
+
+	return HYPERVISOR_memory_op(XENMEM_pin, &pin);
+}
+EXPORT_SYMBOL_GPL(xen_pin_page);
+
 int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 				 unsigned int address_bits,
 				 dma_addr_t *dma_handle)
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 8830883..8f76ce2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2568,3 +2568,10 @@ int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
 	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
+
+int xen_pin_page(xen_pfn_t *in_frame, unsigned int address_bits)
+{
+	return -ENOSYS;
+}
+EXPORT_SYMBOL_GPL(xen_pin_page);
+
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 49db252..66ab578 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -314,4 +314,36 @@ struct xen_unpin {
 };
 DEFINE_GUEST_HANDLE_STRUCT(xen_unpin);
 
+/*
+ * XENMEM_pin pins a set of pages to make sure that the hypervisor does
+ * not change the p2m mappings for them.
+ *
+ */
+#define XENMEM_pin               28
+struct xen_pin {
+    /*
+     * [IN/OUT] Details of memory extents to be pinned (GMFN bases).
+     * Xen copies back the MFNs corresponding to the GMFNs passed in as
+     * argument.
+     * @in.address_bits contains the maximum number of bits addressable
+     * by the caller. If the machine addresses of the pages to be pinned
+     * are not addressable according to @in.address_bits, the hypercall
+     * fails and returns an errors. The pages are not pinned. Otherwise
+     * the hypercall succeeds.
+     */
+    struct xen_memory_reservation in;
+
+    /*
+     * [OUT] Number of input extents that were successfully pinned.
+     *  1. The first @nr_pinned input extents were successfully
+     *     pinned.
+     *  2. All other input extents are untouched.
+     *  3. If not all input extents are pinned then the return code of this
+     *     command will be non-zero.
+     */
+    xen_ulong_t nr_pinned;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_pin);
+
+
 #endif /* __XEN_PUBLIC_MEMORY_H__ */
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index fb2ea8f..4cf4fc5 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -22,6 +22,7 @@ extern unsigned long *xen_contiguous_bitmap;
 int xen_create_contiguous_region(phys_addr_t pstart, unsigned int order,
 				unsigned int address_bits,
 				dma_addr_t *dma_handle);
+int xen_pin_page(xen_pfn_t *in_frame, unsigned int address_bits);
 
 void xen_destroy_contiguous_region(phys_addr_t pstart, unsigned int order);
 
-- 
1.7.2.5

