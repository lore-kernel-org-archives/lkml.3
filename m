Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993AbaLPPre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:47:34 -0500
Received: from 8bytes.org ([81.169.241.247]:55872 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaLPPrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:47:33 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH] kvm: iommu: Add cond_resched to legacy device assignment code
Date: Tue, 16 Dec 2014 16:47:26 +0100
Message-Id: <1418744846-12868-1-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

When assigning devices to large memory guests (>=128GB guest
memory in the failure case) the functions to create the
IOMMU page-tables for the whole guest might run for a very
long time. On non-preemptible kernels this might cause
Soft-Lockup warnings. Fix these by adding a cond_resched()
to the mapping and unmapping loops.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 virt/kvm/iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index c1e6ae9..ac427e8 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -137,7 +137,7 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 
 		gfn += page_size >> PAGE_SHIFT;
 
-
+		cond_resched();
 	}
 
 	return 0;
@@ -311,6 +311,8 @@ static void kvm_iommu_put_pages(struct kvm *kvm,
 		kvm_unpin_pages(kvm, pfn, unmap_pages);
 
 		gfn += unmap_pages;
+
+		cond_resched();
 	}
 }
 
-- 
1.9.1

