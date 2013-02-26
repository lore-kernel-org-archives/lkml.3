Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891Ab3BZW5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:57:07 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37771 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab3BZW5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:57:05 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
Date: Tue, 26 Feb 2013 17:56:10 -0500
Message-Id: <1361919370-18058-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_DEBUG_PAGEALLOC is set page table updates made by
kernel_map_pages() are not made visible (via TLB flush) immediately if lazy
MMU is on. In environments that support lazy MMU (e.g. Xen) this may lead to
fatal page faults, for example, when zap_pte_range() needs to allocate pages
in __tlb_remove_page() -> tlb_next_batch().

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/mm/pageattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index ca1f1c2..7b3216e 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1369,6 +1369,8 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 	 * but that can deadlock->flush only current cpu:
 	 */
 	__flush_tlb_all();
+
+	arch_flush_lazy_mmu_mode();
 }
 
 #ifdef CONFIG_HIBERNATION
-- 
1.8.1.2

