Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162280Ab3LFNMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:12:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44743 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162108Ab3LFNFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:05:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Greg Edwards <gedwards@ddn.com>, Gleb Natapov <gleb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 248/272] KVM: IOMMU: hva align mapping page size
Date: Fri,  6 Dec 2013 12:58:57 +0000
Message-Id: <1386334761-25517-249-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Edwards <gedwards@ddn.com>

commit 27ef63c7e97d1e5dddd85051c03f8d44cc887f34 upstream.

When determining the page size we could use to map with the IOMMU, the
page size should also be aligned with the hva, not just the gfn.  The
gfn may not reflect the real alignment within the hugetlbfs file.

Most of the time, this works fine.  However, if the hugetlbfs file is
backed by non-contiguous huge pages, a multi-huge page memslot starts at
an unaligned offset within the hugetlbfs file, and the gfn is aligned
with respect to the huge page size, kvm_host_page_size() will return the
huge page size and we will use that to map with the IOMMU.

When we later unpin that same memslot, the IOMMU returns the unmap size
as the huge page size, and we happily unpin that many pfns in
monotonically increasing order, not realizing we are spanning
non-contiguous huge pages and partially unpin the wrong huge page.

Ensure the IOMMU mapping page size is aligned with the hva corresponding
to the gfn, which does reflect the alignment within the hugetlbfs file.

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Edwards <gedwards@ddn.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 virt/kvm/iommu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 72a130b..c329c8f 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -103,6 +103,10 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 		while ((gfn << PAGE_SHIFT) & (page_size - 1))
 			page_size >>= 1;
 
+		/* Make sure hva is aligned to the page size we want to map */
+		while (__gfn_to_hva_memslot(slot, gfn) & (page_size - 1))
+			page_size >>= 1;
+
 		/*
 		 * Pin all pages we are about to map in memory. This is
 		 * important because we unmap and unpin in 4kb steps later.
-- 
1.8.3.2

