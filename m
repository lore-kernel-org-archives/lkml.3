Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254Ab3K0Bry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:47:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118Ab3K0A5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:57:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Greg Edwards <gedwards@ddn.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: [PATCH 3.10 59/80] KVM: IOMMU: hva align mapping page size
Date: Tue, 26 Nov 2013 16:57:28 -0800
Message-Id: <20131127005645.041646428@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/iommu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -103,6 +103,10 @@ int kvm_iommu_map_pages(struct kvm *kvm,
 		while ((gfn << PAGE_SHIFT) & (page_size - 1))
 			page_size >>= 1;
 
+		/* Make sure hva is aligned to the page size we want to map */
+		while (__gfn_to_hva_memslot(slot, gfn) & (page_size - 1))
+			page_size >>= 1;
+
 		/*
 		 * Pin all pages we are about to map in memory. This is
 		 * important because we unmap and unpin in 4kb steps later.


