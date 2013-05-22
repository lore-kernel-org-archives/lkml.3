Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3EVRnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:43:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab3EVRns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:43:48 -0400
Date: Wed, 22 May 2013 13:41:11 -0400
From: Rik van Riel <riel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Subject: [PATCH] mm: fix up a spurious page fault whenever it happens
Message-ID: <20130522134111.33a695c5@cuia.bos.redhat.com>
In-Reply-To: <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>
References: <5195ED8B.7060002@meduna.org>
	<1369183168.6828.168.camel@gandalf.local.home>
	<519CBB30.3060200@redhat.com>
	<CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 May 2013 08:01:43 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Wed, May 22, 2013 at 5:33 AM, Rik van Riel <riel@redhat.com> wrote:

> > Can you test the attached patch?
> 
> I think you should also remove the
> 
>         if (flags & FAULT_FLAG_WRITE)
> 
> test in handle_pte_fault(). Because if it's spurious, it might happen
> on reads too, I think.

Here you are. I wonder if the conditional was put in because we
originally did a global TLB flush (with IPIs) from the spurious
fault handler...

Stanislav, could you add this patch to your test?

---8<---
Subject: [PATCH] mm: fix up a spurious page fault whenever it happens

The kernel currently only handles spurious page faults when they
"should" happen, but potentially this is not the only situation
where they could happen.

The spurious fault handler only flushes an entry from the local
TLB; this should be a rare event with minimal side effects.

This patch removes the conditional, allowing the spurious fault
handler to execute whenever a spurious page fault happens, which
should eliminate infinite page fault loops.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Stanislav Meduna <stano@meduna.org>
---
 mm/memory.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6dc1882..962477d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3744,13 +3744,11 @@ int handle_pte_fault(struct mm_struct *mm,
 		update_mmu_cache(vma, address, pte);
 	} else {
 		/*
-		 * This is needed only for protection faults but the arch code
-		 * is not yet telling us if this is a protection fault or not.
-		 * This still avoids useless tlb flushes for .text page faults
-		 * with threads.
+		 * The page table entry is good, but the CPU generated a
+		 * spurious fault. Invalidate the corresponding TLB entry
+		 * on this CPU, so the next access can succeed.
 		 */
-		if (flags & FAULT_FLAG_WRITE)
-			flush_tlb_fix_spurious_fault(vma, address);
+		flush_tlb_fix_spurious_fault(vma, address);
 	}
 unlock:
 	pte_unmap_unlock(pte, ptl);
