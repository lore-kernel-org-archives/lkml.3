Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaCIM6H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 08:58:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbaCIM6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 08:58:05 -0400
Date: Sun, 9 Mar 2014 13:57:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] mm: per-thread vma caching
Message-ID: <20140309125710.GA1829@redhat.com>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net> <20140308184040.GA29602@redhat.com> <CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com> <20140308194405.GA32403@redhat.com> <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Linus Torvalds wrote:
>
> On Sat, Mar 8, 2014 at 11:44 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Sure. But another thread or CLONE_VM task can do vmacache_invalidate(),
> > hit vmacache_seqnum == 0 and call vmacache_flush_all() to solve the
> > problem with potential overflow.
>
> How?
>
> Any invalidation is supposed to hold the mm semaphore for writing.

Yes,

> And
> we should have it for reading.

No, dup_task_struct() is obviously lockless. And the new child is not yet
visible to for_each_process_thread().

clone(CLONE_VM) can create a thread with the corrupted vmacache.




OK. Suppose we have a task T1 which has the valid vmacache,
T1->vmacache_seqnum == T1->mm->vmacache_seqnum == 0. Suppose it sleeps a lot.

Suppose that its subthread T2 does a lot munmap's, finally mm->vmacache_seqnum
becomes zero again and T2 calls vmacache_flush_all().

T1 wakes up and does clone(CLONE_VM). The new thread T3 gets the copy
of T2's ->vmacache_seqnum and ->vmacache[].

T2 continues, vmacache_flush_all() finds T1 and does vmacache_flush(T1).

But the new thread T3 is not on the list yet, vmacache_flush_all() can't
find it.

So T3 will run with vmacache_valid() == T (till the next invalidate(mm)
of course) but its ->vmacache[] points to nowhere.

Oleg.

