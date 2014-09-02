Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaIBQNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:13:32 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44552 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaIBQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:13:30 -0400
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] powerpc/kvm/cma: Fix panic introduces by signed shift operation
Date: Tue,  2 Sep 2014 18:13:01 +0200
Message-Id: <1409674381-29465-1-git-send-email-ldufour@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090216-2966-0000-0000-000000FF83D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fc95ca7284bc54953165cba76c3228bd2cdb9591 introduces a memset in
kvmppc_alloc_hpt since the general CMA doesn't clear the memory it
allocates.

However, the size argument passed to memset is computed from a signed value
and its signed bit is extended by the cast the compiler is doing. This lead
to extremely large size value when dealing with order value >= 31, and
almost all the memory following the allocated space is cleaned. As a
consequence, the system is panicing and may even fail spawning the kdump
kernel.

This fix makes use of an unsigned value for the memset's size argument to
avoid sign extension. Among this fix, another shift operation which may
lead to signed extended value too is also fixed.

Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
---
 arch/powerpc/kvm/book3s_64_mmu_hv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 72c20bb16d26..79294c4c5015 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -62,10 +62,10 @@ long kvmppc_alloc_hpt(struct kvm *kvm, u32 *htab_orderp)
 	}
 
 	kvm->arch.hpt_cma_alloc = 0;
-	page = kvm_alloc_hpt(1 << (order - PAGE_SHIFT));
+	page = kvm_alloc_hpt(1ul << (order - PAGE_SHIFT));
 	if (page) {
 		hpt = (unsigned long)pfn_to_kaddr(page_to_pfn(page));
-		memset((void *)hpt, 0, (1 << order));
+		memset((void *)hpt, 0, (1ul << order));
 		kvm->arch.hpt_cma_alloc = 1;
 	}
 
-- 
1.9.1

