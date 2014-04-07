Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaDGPMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 11:12:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478AbaDGPKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 11:10:50 -0400
From: Mel Gorman <mgorman@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-X86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] mm: Allow FOLL_NUMA on FOLL_FORCE
Date: Mon,  7 Apr 2014 16:10:43 +0100
Message-Id: <1396883443-11696-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1396883443-11696-1-git-send-email-mgorman@suse.de>
References: <1396883443-11696-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As _PAGE_NUMA is no longer aliased to _PAGE_PROTNONE there should be no
confusion between them. It should be possible to kick away the special
casing in __get_user_pages.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/memory.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 22dfa61..b9c35a7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1714,18 +1714,6 @@ long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	vm_flags &= (gup_flags & FOLL_FORCE) ?
 			(VM_MAYREAD | VM_MAYWRITE) : (VM_READ | VM_WRITE);
 
-	/*
-	 * If FOLL_FORCE and FOLL_NUMA are both set, handle_mm_fault
-	 * would be called on PROT_NONE ranges. We must never invoke
-	 * handle_mm_fault on PROT_NONE ranges or the NUMA hinting
-	 * page faults would unprotect the PROT_NONE ranges if
-	 * _PAGE_NUMA and _PAGE_PROTNONE are sharing the same pte/pmd
-	 * bitflag. So to avoid that, don't set FOLL_NUMA if
-	 * FOLL_FORCE is set.
-	 */
-	if (!(gup_flags & FOLL_FORCE))
-		gup_flags |= FOLL_NUMA;
-
 	i = 0;
 
 	do {
-- 
1.8.4.5

