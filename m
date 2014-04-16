Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaDPHlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:41:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39373 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaDPHlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:41:02 -0400
Date: Wed, 16 Apr 2014 00:40:27 -0700
From: tip-bot for Shaohua Li <tipbot@zytor.com>
Message-ID: <tip-b13b1d2d8692b437203de7a404c6b809d2cc4d99@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        hannes@cmpxchg.org, hughd@google.com, riel@redhat.com,
        shli@fusionio.com, mgorman@suse.de, tglx@linutronix.de,
        shli@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        hannes@cmpxchg.org, hughd@google.com, riel@redhat.com,
        shli@fusionio.com, mgorman@suse.de, shli@kernel.org,
        tglx@linutronix.de
In-Reply-To: <20140408075809.GA1764@kernel.org>
References: <20140408075809.GA1764@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm:
  In the PTE swapout page reclaim case clear the accessed bit instead of flushing the TLB
Git-Commit-ID: b13b1d2d8692b437203de7a404c6b809d2cc4d99
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b13b1d2d8692b437203de7a404c6b809d2cc4d99
Gitweb:     http://git.kernel.org/tip/b13b1d2d8692b437203de7a404c6b809d2cc4d99
Author:     Shaohua Li <shli@kernel.org>
AuthorDate: Tue, 8 Apr 2014 15:58:09 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Apr 2014 08:57:08 +0200

x86/mm: In the PTE swapout page reclaim case clear the accessed bit instead of flushing the TLB

We use the accessed bit to age a page at page reclaim time,
and currently we also flush the TLB when doing so.

But in some workloads TLB flush overhead is very heavy. In my
simple multithreaded app with a lot of swap to several pcie
SSDs, removing the tlb flush gives about 20% ~ 30% swapout
speedup.

Fortunately just removing the TLB flush is a valid optimization:
on x86 CPUs, clearing the accessed bit without a TLB flush
doesn't cause data corruption.

It could cause incorrect page aging and the (mistaken) reclaim of
hot pages, but the chance of that should be relatively low.

So as a performance optimization don't flush the TLB when
clearing the accessed bit, it will eventually be flushed by
a context switch or a VM operation anyway. [ In the rare
event of it not getting flushed for a long time the delay
shouldn't really matter because there's no real memory
pressure for swapout to react to. ]

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140408075809.GA1764@kernel.org
[ Rewrote the changelog and the code comments. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pgtable.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index c96314a..0004ac7 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -399,13 +399,20 @@ int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 int ptep_clear_flush_young(struct vm_area_struct *vma,
 			   unsigned long address, pte_t *ptep)
 {
-	int young;
-
-	young = ptep_test_and_clear_young(vma, address, ptep);
-	if (young)
-		flush_tlb_page(vma, address);
-
-	return young;
+	/*
+	 * On x86 CPUs, clearing the accessed bit without a TLB flush
+	 * doesn't cause data corruption. [ It could cause incorrect
+	 * page aging and the (mistaken) reclaim of hot pages, but the
+	 * chance of that should be relatively low. ]
+	 *
+	 * So as a performance optimization don't flush the TLB when
+	 * clearing the accessed bit, it will eventually be flushed by
+	 * a context switch or a VM operation anyway. [ In the rare
+	 * event of it not getting flushed for a long time the delay
+	 * shouldn't really matter because there's no real memory
+	 * pressure for swapout to react to. ]
+	 */
+	return ptep_test_and_clear_young(vma, address, ptep);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
