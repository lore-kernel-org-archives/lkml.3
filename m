Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab3JIR0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:26:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55958 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761Ab3JIR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:26:09 -0400
Date: Wed, 9 Oct 2013 10:25:32 -0700
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-e920e14ca29b0b2a981cfc90e4e20edd6f078d19@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, hannes@cmpxchg.org, riel@redhat.com,
        aarcange@redhat.com, srikar@linux.vnet.ibm.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1381141781-10992-11-git-send-email-mgorman@suse.de>
References: <1381141781-10992-11-git-send-email-mgorman@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] mm:
  Do not flush TLB during protection change if !pte_present && !migration_entry
Git-Commit-ID: e920e14ca29b0b2a981cfc90e4e20edd6f078d19
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 09 Oct 2013 10:25:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e920e14ca29b0b2a981cfc90e4e20edd6f078d19
Gitweb:     http://git.kernel.org/tip/e920e14ca29b0b2a981cfc90e4e20edd6f078d19
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 7 Oct 2013 11:28:48 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 Oct 2013 12:39:48 +0200

mm: Do not flush TLB during protection change if !pte_present && !migration_entry

NUMA PTE scanning is expensive both in terms of the scanning itself and
the TLB flush if there are any updates. Currently non-present PTEs are
accounted for as an update and incurring a TLB flush where it is only
necessary for anonymous migration entries. This patch addresses the
problem and should reduce TLB flushes.

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381141781-10992-11-git-send-email-mgorman@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 mm/mprotect.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2bbb648..7bdbd4b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -101,8 +101,9 @@ static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 				make_migration_entry_read(&entry);
 				set_pte_at(mm, addr, pte,
 					swp_entry_to_pte(entry));
+
+				pages++;
 			}
-			pages++;
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
