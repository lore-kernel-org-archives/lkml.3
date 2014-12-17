Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751108AbaLQTlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:41:04 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:35442 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQTlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:41:02 -0500
MIME-Version: 1.0
In-Reply-To: <20141217182241.GA4821@redhat.com>
References: <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
	<20141211145408.GB16800@redhat.com>
	<CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
	<20141212185454.GB4716@redhat.com>
	<CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
	<20141213165915.GA12756@redhat.com>
	<20141213223616.GA22559@redhat.com>
	<CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
	<20141214234654.GA396@redhat.com>
	<CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
	<20141217182241.GA4821@redhat.com>
Date: Wed, 17 Dec 2014 11:41:00 -0800
X-Google-Sender-Auth: dXs1RpLxUZuwCQz9MbLhyWvnrYA
Message-ID: <CA+55aFxj7cZaJRkzmOG=0kbqDpeggOw0hdLdcKiT+KDGjE7YTQ@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 10:22 AM, Dave Jones <davej@redhat.com> wrote:
>
> Here's save_xstate_sig:

Ok, that just confirmed that it was the call to __clear_user and the
"xsave64" instruction like expected. And the offset in __clear_user()
was just the return address after the call to "might_fault", so this
all matches with __clear_user and/or the xsave64 instruction taking
infinite page-faults.

.. which also kind of matches with your old "pipe/page fault oddness"
report, where it was the single-byte write in
"fault_in_pages_writable()" that kept taking infinite page faults.

However.

I'm back looking at your old trace for the pipe/page fault oddness
report, and it goes like this (simplified):

    __do_page_fault() {
      down_read_trylock();
      __might_sleep();
      find_vma();
      handle_mm_fault() {
        _raw_spin_lock();
        ptep_set_access_flags();
        _raw_spin_unlock();
      }
      up_read();
    }

which is a bit hard to read because it doesn't trace all functions -
it only traces the ones that didn't get inlined.

But "didn't get inlined" already means that we know the
handle_mm_fault() codepath it didn't go outside of mm/memory.c apart
from the quoted parts. So no hugetlb.c code, and no mm/filemap.c code.
So there are no lock_page_or_retry() failures, for example.

There are only two ptep_set_access_flags() calls in mm/memory.c - in
do_wp_page() for the page re-use case, and in handle_pte_fault() for
the "pte was present and already writable".

And it's almost certainly not the do_wp_page() one, because that is
not something that gcc inlines at least for me (it has two different
call sites).

So I'm a bit less optimistic about the VM_FAULT_RETRY +
fatal_signal_pending() scenario, because it simply doesn't match your
earlier odd page fault thing.

Your earlier page fault problem really looks like the VM is confused
about the page table contents. The kernel thinks the page is already
perfectly writable, and just marks it accessed and returns. But the
page fault just kept happening. And from that thread, you had
"error-code=0", which means "not present page, write fault".

So that earlier "infinite page fault" bug really smells like something
else went wrong. One of:

 - we're using the wrong "mm". The x86 fault code uses "tsk->mm",
rather than "tsk->active_mm", which is somewhat dubious. At the same
time, they should always match, unless "mm" is NULL. And we know mm
isn't NULL, because __do_page_fault checks for that lack of user
context..

   There's also small areas in the scheduler where the current task
itself is kind of a gray area, and the CPU hasn't been switched to the
new cr3 yet, but those are all irq-off. They don't match your stack
trace anyway.

 - we walk the page table directories without necessarily checking
that they are writable.  So maybe the PTE itself is writable, but the
PMD isn't. We do have read-only PMD's (see pmd_wrprotect). But that
*should* only trigger for hugepage entries. And again, your old error
code really said that the CPU thinks it is "not present".

 - the whole NUMA protnone mess. That's what I suspected back then,
and I keep coming back to it. That's the code that makes the kernel
think that "pte_present is set", even though the CPU sees that the
actual PTE_PRESENT bit is clear.

Ugh. I'd have loved for the VM_FAULT_RETRY thing to explain all your
problems, but it doesn't.

                        Linus
