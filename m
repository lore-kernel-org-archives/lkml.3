Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbaKLBdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:33:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbaKLBdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:33:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.17 258/319] zap_pte_range: update addr when forcing flush after TLB batching faiure
Date: Wed, 12 Nov 2014 10:16:36 +0900
Message-Id: <20141112011035.437820844@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit ce9ec37bddb633404a0c23e1acb181a264e7f7f2 upstream.

When unmapping a range of pages in zap_pte_range, the page being
unmapped is added to an mmu_gather_batch structure for asynchronous
freeing. If we run out of space in the batch structure before the range
has been completely unmapped, then we break out of the loop, force a
TLB flush and free the pages that we have batched so far. If there are
further pages to unmap, then we resume the loop where we left off.

Unfortunately, we forget to update addr when we break out of the loop,
which causes us to truncate the range being invalidated as the end
address is exclusive. When we re-enter the loop at the same address, the
page has already been freed and the pte_present test will fail, meaning
that we do not reconsider the address for invalidation.

This patch fixes the problem by incrementing addr by the PAGE_SIZE
before breaking out of the loop on batch failure.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1147,6 +1147,7 @@ again:
 				print_bad_pte(vma, addr, ptent, page);
 			if (unlikely(!__tlb_remove_page(tlb, page))) {
 				force_flush = 1;
+				addr += PAGE_SIZE;
 				break;
 			}
 			continue;


