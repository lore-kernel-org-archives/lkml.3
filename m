Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934538Ab3AOW7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:59:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:48728 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934507Ab3AOW55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:57:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Woodhouse <David.Woodhouse@intel.com>,
        Ravi Murty <Ravi.Murty@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        CAI Qian <caiqian@redhat.com>
Subject: [ 67/71] intel-iommu: Free old page tables before creating superpage
Date: Tue, 15 Jan 2013 14:55:04 -0800
Message-Id: <20130115225345.235085702@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115225340.367496998@linuxfoundation.org>
References: <20130115225340.367496998@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Woodhouse, David" <david.woodhouse@intel.com>

commit 6491d4d02893d9787ba67279595990217177b351 upstream.

The dma_pte_free_pagetable() function will only free a page table page
if it is asked to free the *entire* 2MiB range that it covers. So if a
page table page was used for one or more small mappings, it's likely to
end up still present in the page tables... but with no valid PTEs.

This was fine when we'd only be repopulating it with 4KiB PTEs anyway
but the same virtual address range can end up being reused for a
*large-page* mapping. And in that case were were trying to insert the
large page into the second-level page table, and getting a complaint
from the sanity check in __domain_mapping() because there was already a
corresponding entry. This was *relatively* harmless; it led to a memory
leak of the old page table page, but no other ill-effects.

Fix it by calling dma_pte_clear_range (hopefully redundant) and
dma_pte_free_pagetable() before setting up the new large page.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Tested-by: Ravi Murty <Ravi.Murty@intel.com>
Tested-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/intel-iommu.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1793,10 +1793,17 @@ static int __domain_mapping(struct dmar_
 			if (!pte)
 				return -ENOMEM;
 			/* It is large page*/
-			if (largepage_lvl > 1)
+			if (largepage_lvl > 1) {
 				pteval |= DMA_PTE_LARGE_PAGE;
-			else
+				/* Ensure that old small page tables are removed to make room
+				   for superpage, if they exist. */
+				dma_pte_clear_range(domain, iov_pfn,
+						    iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+				dma_pte_free_pagetable(domain, iov_pfn,
+						       iov_pfn + lvl_to_nr_pages(largepage_lvl) - 1);
+			} else {
 				pteval &= ~(uint64_t)DMA_PTE_LARGE_PAGE;
+			}
 
 		}
 		/* We don't need lock here, nobody else


