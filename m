Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3AXWEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:04:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099Ab3AXWEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:04:13 -0500
Subject: [PATCH 2/2] kvm: Obey read-only mappings in iommu
To: gleb@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: yoshikawa_takuya_b1@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Date: Thu, 24 Jan 2013 15:04:09 -0700
Message-ID: <20130124220409.11061.85576.stgit@bling.home>
In-Reply-To: <20130124220027.11061.76400.stgit@bling.home>
References: <20130124220027.11061.76400.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been ignoring read-only mappings and programming everything
into the iommu as read-write.  Fix this to only include the write
access flag when read-only is not set.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 virt/kvm/iommu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 4a340cb..72a130b 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -76,7 +76,9 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 	gfn     = slot->base_gfn;
 	end_gfn = gfn + slot->npages;
 
-	flags = IOMMU_READ | IOMMU_WRITE;
+	flags = IOMMU_READ;
+	if (!(slot->flags & KVM_MEM_READONLY))
+		flags |= IOMMU_WRITE;
 	if (kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY)
 		flags |= IOMMU_CACHE;
 

