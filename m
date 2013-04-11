Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161424Ab3DKSAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:00:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49963 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989Ab3DKSAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:00:14 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: konrad.wilk@oracle.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH RESEND] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
Date: Thu, 11 Apr 2013 13:59:52 -0400
Message-Id: <1365703192-2089-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_DEBUG_PAGEALLOC is set page table updates made by
kernel_map_pages() are not made visible (via TLB flush) immediately if lazy
MMU is on. In environments that support lazy MMU (e.g. Xen) this may lead
to fatal page faults, for example, when zap_pte_range() needs to allocate
pages in __tlb_remove_page() -> tlb_next_batch().

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/mm/pageattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 091934e..2ccbe0b 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1413,6 +1413,8 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 	 * but that can deadlock->flush only current cpu:
 	 */
 	__flush_tlb_all();
+
+	arch_flush_lazy_mmu_mode();
 }
 
 #ifdef CONFIG_HIBERNATION
-- 
1.8.1.4

