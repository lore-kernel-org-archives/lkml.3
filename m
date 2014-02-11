Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaBKUYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:24:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbaBKTGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 005/107] intel-iommu: fix off-by-one in pagetable freeing
Date: Tue, 11 Feb 2014 11:04:31 -0800
Message-Id: <20140211184748.352259842@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 08336fd218e087cc4fcc458e6b6dcafe8702b098 upstream.

dma_pte_free_level() has an off-by-one error when checking whether a pte
is completely covered by a range.  Take for example the case of
attempting to free pfn 0x0 - 0x1ff, ie.  512 entries covering the first
2M superpage.

The level_size() is 0x200 and we test:

  static void dma_pte_free_level(...
	...

	if (!(0 > 0 || 0x1ff < 0 + 0x200)) {
		...
	}

Clearly the 2nd test is true, which means we fail to take the branch to
clear and free the pagetable entry.  As a result, we're leaking
pagetables and failing to install new pages over the range.

This was found with a PCI device assigned to a QEMU guest using vfio-pci
without a VGA device present.  The first 1M of guest address space is
mapped with various combinations of 4K pages, but eventually the range
is entirely freed and replaced with a 2M contiguous mapping.
intel-iommu errors out with something like:

  ERROR: DMA PTE for vPFN 0x0 already set (to 5c2b8003 not 849c00083)

In this case 5c2b8003 is the pointer to the previous leaf page that was
neither freed nor cleared and 849c00083 is the superpage entry that
we're trying to replace it with.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -917,7 +917,7 @@ static void dma_pte_free_level(struct dm
 
 		/* If range covers entire pagetable, free it */
 		if (!(start_pfn > level_pfn ||
-		      last_pfn < level_pfn + level_size(level))) {
+		      last_pfn < level_pfn + level_size(level) - 1)) {
 			dma_clear_pte(pte);
 			domain_flush_cache(domain, pte, sizeof(*pte));
 			free_pgtable_page(level_pte);


