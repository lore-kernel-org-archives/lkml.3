Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3HAAgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 20:36:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36434 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3HAAgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 20:36:43 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1375292732-7627-5-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1307311833040.4893@kaball.uk.xensource.com> <1375292732-7627-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH RFC 5/8] xen: introduce XENMEM_get_dma_buf and xen_put_dma_buf
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 31 Jul 2013 20:36:03 -0400
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stefano.Stabellini@eu.citrix.com, Ian.Campbell@citrix.com
Message-ID: <22032fc7-81f5-4271-81b6-cd2bee277fb5@email.android.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
>Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>---
>include/xen/interface/memory.h |   62
>++++++++++++++++++++++++++++++++++++++++
> 1 files changed, 62 insertions(+), 0 deletions(-)
>
>diff --git a/include/xen/interface/memory.h
>b/include/xen/interface/memory.h
>index 2ecfe4f..ffd7f4e 100644
>--- a/include/xen/interface/memory.h
>+++ b/include/xen/interface/memory.h
>@@ -263,4 +263,66 @@ struct xen_remove_from_physmap {
> };
> DEFINE_GUEST_HANDLE_STRUCT(xen_remove_from_physmap);
> 
>+#define XENMEM_get_dma_buf             26
>+/*
>+ * This hypercall is similar to XENMEM_exchange: it exchanges the
>pages

Could you elaborate why the existing hyper call won't work? 

>+ * passed in with a new set of pages, contiguous and under 4G if so
>+ * requested. The new pages are going to be "pinned": it's guaranteed
>+ * that their p2m mapping won't be changed until explicitly
>"unpinned".
>+ * If return code is zero then @out.extent_list provides the MFNs of
>the
>+ * newly-allocated memory.  Returns zero on complete success,
>otherwise
>+ * a negative error code.
>+ * On complete success then always @nr_exchanged == @in.nr_extents. 
>On
>+ * partial success @nr_exchanged indicates how much work was done.
>+ */
>+struct xen_get_dma_buf {
>+    /*
>+     * [IN] Details of memory extents to be exchanged (GMFN bases).
>+     * Note that @in.address_bits is ignored and unused.
>+     */
>+    struct xen_memory_reservation in;
>+
>+    /*
>+     * [IN/OUT] Details of new memory extents.
>+     * We require that:
>+     *  1. @in.domid == @out.domid
>+     *  2. @in.nr_extents  << @in.extent_order == 
>+     *     @out.nr_extents << @out.extent_order
>+     *  3. @in.extent_start and @out.extent_start lists must not
>overlap
>+     *  4. @out.extent_start lists GPFN bases to be populated
>+     *  5. @out.extent_start is overwritten with allocated GMFN bases
>+     */
>+    struct xen_memory_reservation out;
>+
>+    /*
>+     * [OUT] Number of input extents that were successfully exchanged:
>+     *  1. The first @nr_exchanged input extents were successfully
>+     *     deallocated.
>+     *  2. The corresponding first entries in the output extent list
>correctly
>+     *     indicate the GMFNs that were successfully exchanged.
>+     *  3. All other input and output extents are untouched.
>+     *  4. If not all input exents are exchanged then the return code
>of this
>+     *     command will be non-zero.
>+     *  5. THIS FIELD MUST BE INITIALISED TO ZERO BY THE CALLER!
>+     */
>+    xen_ulong_t nr_exchanged;
>+};
>+DEFINE_GUEST_HANDLE_STRUCT(xen_get_dma_buf);
>+
>+#define XENMEM_put_dma_buf             27
>+/*
>+ * XENMEM_put_dma_buf unpins a set of pages, previously pinned by
>+ * XENMEM_get_dma_buf. After this call the p2m mapping of the pages
>can
>+ * be transparently changed by the hypervisor, as usual. The pages are
>+ * still accessible from the guest.
>+ */
>+struct xen_put_dma_buf {
>+    /*
>+     * [IN] Details of memory extents to be exchanged (GMFN bases).
>+     * Note that @in.address_bits is ignored and unused.
>+     */
>+    struct xen_memory_reservation in;
>+};
>+DEFINE_GUEST_HANDLE_STRUCT(xen_put_dma_buf);
>+
> #endif /* __XEN_PUBLIC_MEMORY_H__ */


