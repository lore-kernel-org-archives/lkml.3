Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab3JHJCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 05:02:51 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:34018 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab3JHJCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 05:02:40 -0400
Message-Id: <20131008090237.062907670@gmail.com>
User-Agent: quilt/0.60-1
Date: Tue, 08 Oct 2013 13:00:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [patch 2/3] [PATCH] mm: pagemap -- Inspect _PAGE_SOFT_DIRTY only on present pages
References: <20131008090019.527108154@gmail.com>
Content-Disposition: inline; filename=pte-sft-dirty-pagemap-fix-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case if a page we are inspecting is laying in swap we may
occasionally report it as having soft dirty bit (even if it
is clean). pte_soft_dirty helper should be called on present
pte only.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.git/fs/proc/task_mmu.c
===================================================================
--- linux-2.6.git.orig/fs/proc/task_mmu.c
+++ linux-2.6.git/fs/proc/task_mmu.c
@@ -941,6 +941,8 @@ static void pte_to_pagemap_entry(pagemap
 		frame = pte_pfn(pte);
 		flags = PM_PRESENT;
 		page = vm_normal_page(vma, addr, pte);
+		if (pte_soft_dirty(pte))
+			flags2 |= __PM_SOFT_DIRTY;
 	} else if (is_swap_pte(pte)) {
 		swp_entry_t entry;
 		if (pte_swp_soft_dirty(pte))
@@ -960,7 +962,7 @@ static void pte_to_pagemap_entry(pagemap
 
 	if (page && !PageAnon(page))
 		flags |= PM_FILE;
-	if ((vma->vm_flags & VM_SOFTDIRTY) || pte_soft_dirty(pte))
+	if ((vma->vm_flags & VM_SOFTDIRTY))
 		flags2 |= __PM_SOFT_DIRTY;
 
 	*pme = make_pme(PM_PFRAME(frame) | PM_STATUS2(pm->v2, flags2) | flags);

