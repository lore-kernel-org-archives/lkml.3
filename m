Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaHNFDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 01:03:35 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49580 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaHNFDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 01:03:32 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2] PC, KVM, CMA: Fix regression caused by wrong get_order() use
Date: Thu, 14 Aug 2014 15:03:07 +1000
Message-Id: <1407992587-9164-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081405-0260-0000-0000-000000126AAF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fc95ca7284bc54953165cba76c3228bd2cdb9591 claims that there is no
functional change but this is not true as it calls get_order() (which
takes bytes) where it should have called ilog2() and the kernel stops
on VM_BUG_ON().

This replaces get_order() with order_base_2() (round-up version of ilog2).

Suggested-by: Paul Mackerras <paulus@samba.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

Changes:
v2:
* s/ilog2/order_base_2/
* removed cc: <stable@vger.kernel.org> as I got wrong impression that v3.16 is
broken

---
 arch/powerpc/kvm/book3s_hv_builtin.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_builtin.c b/arch/powerpc/kvm/book3s_hv_builtin.c
index 329d7fd..b9615ba 100644
--- a/arch/powerpc/kvm/book3s_hv_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_builtin.c
@@ -101,7 +101,7 @@ struct kvm_rma_info *kvm_alloc_rma()
 	ri = kmalloc(sizeof(struct kvm_rma_info), GFP_KERNEL);
 	if (!ri)
 		return NULL;
-	page = cma_alloc(kvm_cma, kvm_rma_pages, get_order(kvm_rma_pages));
+	page = cma_alloc(kvm_cma, kvm_rma_pages, order_base_2(kvm_rma_pages));
 	if (!page)
 		goto err_out;
 	atomic_set(&ri->use_count, 1);
@@ -135,12 +135,12 @@ struct page *kvm_alloc_hpt(unsigned long nr_pages)
 {
 	unsigned long align_pages = HPT_ALIGN_PAGES;
 
-	VM_BUG_ON(get_order(nr_pages) < KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
+	VM_BUG_ON(order_base_2(nr_pages) < KVM_CMA_CHUNK_ORDER - PAGE_SHIFT);
 
 	/* Old CPUs require HPT aligned on a multiple of its size */
 	if (!cpu_has_feature(CPU_FTR_ARCH_206))
 		align_pages = nr_pages;
-	return cma_alloc(kvm_cma, nr_pages, get_order(align_pages));
+	return cma_alloc(kvm_cma, nr_pages, order_base_2(align_pages));
 }
 EXPORT_SYMBOL_GPL(kvm_alloc_hpt);
 
-- 
2.0.0

