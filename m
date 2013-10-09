Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab3JIRai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:30:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab3JIRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:30:34 -0400
Date: Wed, 9 Oct 2013 10:29:53 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-25cbbef1924299249756bc4030fcb2436c019813@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-37-git-send-email-mgorman@suse.de>
References: <1381141781-10992-37-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm: numa:
  Trap pmd hinting faults only if we would otherwise trap PTE faults
Git-Commit-ID: 25cbbef1924299249756bc4030fcb2436c019813
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:30:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25cbbef1924299249756bc4030fcb2436c019813
Gitweb:     http://git.kernel.org/tip/25cbbef1924299249756bc4030fcb2436c019813
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:29:14 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:40:44 +0200

mm: numa: Trap pmd hinting faults only if we would otherwise trap PTE faults

Base page PMD faulting is meant to batch handle NUMA hinting faults from
PTEs. However, even is no PTE faults would ever be handled within a
range the kernel still traps PMD hinting faults. This patch avoids the
overhead.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-37-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mprotect.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index f0b087d..5aae390 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -146,6 +146,8 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 
 	pmd = pmd_offset(pud, addr);
 	do {
+		unsigned long this_pages;
+
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE)
@@ -165,8 +167,9 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		}
 		if (pmd_none_or_clear_bad(pmd))
 			continue;
-		pages += change_pte_range(vma, pmd, addr, next, newprot,
+		this_pages = change_pte_range(vma, pmd, addr, next, newprot,
 				 dirty_accountable, prot_numa, &all_same_nidpid);
+		pages += this_pages;
 
 		/*
 		 * If we are changing protections for NUMA hinting faults then
@@ -174,7 +177,7 @@ static inline unsigned long change_pmd_range(struct vm_area_struct *vma,
 		 * node. This allows a regular PMD to be handled as one fault
 		 * and effectively batches the taking of the PTL
 		 */
-		if (prot_numa && all_same_nidpid)
+		if (prot_numa && this_pages && all_same_nidpid)
 			change_pmd_protnuma(vma->vm_mm, addr, pmd);
 	} while (pmd++, addr = next, addr != end);
 
