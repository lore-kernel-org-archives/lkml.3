Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaCJT4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:56:20 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:57343 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaCJT4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:56:19 -0400
Message-ID: <1394481375.3867.1.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH -next] mm,vmacache: also flush cache for VM_CLONE
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 10 Mar 2014 12:56:15 -0700
In-Reply-To: <CA+55aFxEGj9poWNLAncvrrOTzjDtrwMnOM_d3ACqRkcvY86qHA@mail.gmail.com>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net>
	 <20140308184040.GA29602@redhat.com>
	 <CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com>
	 <20140308194405.GA32403@redhat.com>
	 <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
	 <20140309125710.GA1829@redhat.com>
	 <CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com>
	 <20140309170909.GA13335@redhat.com>
	 <CA+55aFxEGj9poWNLAncvrrOTzjDtrwMnOM_d3ACqRkcvY86qHA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg found that there is a potential race if we don't flush the task
for threads (VM_CLONE):

"Suppose we have a task T1 which has the valid vmacache,
T1->vmacache_seqnum == T1->mm->vmacache_seqnum == 0. Suppose it sleeps a lot.

Suppose that its subthread T2 does a lot munmap's, finally mm->vmacache_seqnum
becomes zero again and T2 calls vmacache_flush_all().

T1 wakes up and does clone(CLONE_VM). The new thread T3 gets the copy
of T2's ->vmacache_seqnum and ->vmacache[].

T2 continues, vmacache_flush_all() finds T1 and does vmacache_flush(T1).

But the new thread T3 is not on the list yet, vmacache_flush_all() can't
find it.

So T3 will run with vmacache_valid() == T (till the next invalidate(mm)
of course) but its ->vmacache[] points to nowhere."

Address this by moving the flush call into copy_mm(), instead of only
having it in dup_mm().

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/fork.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3e02737..45b6241 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -841,9 +841,6 @@ static struct mm_struct *dup_mm(struct task_struct *tsk)
 	if (mm->binfmt && !try_module_get(mm->binfmt->module))
 		goto free_pt;
 
-	/* initialize the new vmacache entries */
-	vmacache_flush(tsk);
-
 	return mm;
 
 free_pt:
@@ -887,6 +884,9 @@ static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 	if (!oldmm)
 		return 0;
 
+	/* initialize the new vmacache entries */
+	vmacache_flush(tsk);
+
 	if (clone_flags & CLONE_VM) {
 		atomic_inc(&oldmm->mm_users);
 		mm = oldmm;
-- 
1.8.1.4



