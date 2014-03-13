Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaCMPdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:33:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbaCMPdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:33:12 -0400
Date: Thu, 13 Mar 2014 16:32:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mm,vmacache: also flush cache for VM_CLONE
Message-ID: <20140313153218.GA28278@redhat.com>
References: <20140308184040.GA29602@redhat.com> <CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com> <20140308194405.GA32403@redhat.com> <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com> <20140309125710.GA1829@redhat.com> <CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com> <20140309170909.GA13335@redhat.com> <CA+55aFxEGj9poWNLAncvrrOTzjDtrwMnOM_d3ACqRkcvY86qHA@mail.gmail.com> <1394481375.3867.1.camel@buesod1.americas.hpqcorp.net> <20140313145941.GA26215@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313145941.GA26215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13, Oleg Nesterov wrote:
>
> Yes. But it seems that use_mm() and unuse_mm() should invalidate vmacache too.
>
> Suppose that a kernel thread T does, say,
>
> 	use_mm(foreign_mm);
> 	get_user(...);
> 	unuse_mm();
>
> This can trigger a fault and populate T->vmacache[]. If this code is called
> again vmacache_find() can use the stale entries.
>
> Or, assuming that only a kernel thread can do use_mm(), we can change
> vmacache_valid() to also check !PF_KTHREAD.

Yes, I think we should check PF_KTHREAD, because

> Hmm. Another problem is that use_mm() doesn't take ->mmap_sem and thus
> it can race with vmacache_flush_all()...

this also closes this race. use_mm() users should not use vmacache at all.

> Finally. Shouldn't vmacache_update() check current->mm == mm as well?
> What if access_remote_vm/get_user_pages trigger find_vma() ??? Unless
> I missed something this is not theoretical at all and can lead to the
> corrupted vmacache, no?

Looks like a real problem or I am totally confused. I think we need
something like below (uncompiled).

Oleg.

--- x/mm/vmacache.c
+++ x/mm/vmacache.c
@@ -30,20 +30,24 @@ void vmacache_flush_all(struct mm_struct
 	rcu_read_unlock();
 }
 
+static bool vmacache_valid_mm(mm)
+{
+	return current->mm == mm && !(current->flags & PF_KTHREAD);
+}
+
 void vmacache_update(unsigned long addr, struct vm_area_struct *newvma)
 {
-	int idx = VMACACHE_HASH(addr);
-	current->vmacache[idx] = newvma;
+	if (vmacache_valid_mm(newvma->vm_mm))
+		current->vmacache[VMACACHE_HASH(addr)] = newvma;
 }
 
 static bool vmacache_valid(struct mm_struct *mm)
 {
-	struct task_struct *curr = current;
-
-	if (mm != curr->mm)
+	if (!vmacache_valid_mm(mm))
 		return false;
 
 	if (mm->vmacache_seqnum != curr->vmacache_seqnum) {
+		struct task_struct *curr = current;
 		/*
 		 * First attempt will always be invalid, initialize
 		 * the new cache for this task here.

