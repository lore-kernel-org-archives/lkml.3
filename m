Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaCIRPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbaCIRPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:15:06 -0400
Date: Sun, 9 Mar 2014 18:09:09 +0100
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
Message-ID: <20140309170909.GA13335@redhat.com>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net> <20140308184040.GA29602@redhat.com> <CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com> <20140308194405.GA32403@redhat.com> <CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com> <20140309125710.GA1829@redhat.com> <CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09, Linus Torvalds wrote:
>
> On Sun, Mar 9, 2014 at 5:57 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > No, dup_task_struct() is obviously lockless. And the new child is not yet
> > visible to for_each_process_thread().
>
> Ok, then the siimple approach is to just do
>
>     /* Did we miss an invalidate event? *
>     if (mm->seqcount < tsk->seqcount)
>         clear_vma_cache();
>
> after making the new thread visible.
>
> Then the "race" becomes one of "we cannot have 4 billion mmap/munmap
> events in other threads while we're setting up a new thread",

But it's not the "while we're setting up a new thread", it is "since
vmacache_valid() was called list time". And the cloning task can just
sleep(A_LOT) and then do CLONE_VM.

Of course, of course, this race is pute theoretical anyway. But imho
makes sense to fix anyway, and the natural/trivial approach is just to
move vmacache_flush(tsk) from dup_mm() to copy_mm(), right after the
"if (!oldmm)" check.

Oleg.

