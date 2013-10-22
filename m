Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3JVQUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:20:42 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:61484 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab3JVQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:20:41 -0400
MIME-Version: 1.0
In-Reply-To: <20131022154802.GA25490@localhost>
References: <1382057438-3306-1-git-send-email-davidlohr@hp.com>
	<20131022154802.GA25490@localhost>
Date: Tue, 22 Oct 2013 17:20:40 +0100
X-Google-Sender-Auth: gd96B2V6H1gY6dSVs2-QNtdEfj4
Message-ID: <CA+55aFzwRoM4w8mGqSeeVuDGhQgnnomu=vxoWC6dbHD9w-9A+Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm,vdso: preallocate new vmas
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 4:48 PM,  <walken@google.com> wrote:

>
> Generally the problems I see with mmap_sem are related to long latency
> operations. Specifically, the mmap_sem write side is currently held
> during the entire munmap operation, which iterates over user pages to
> free them, and can take hundreds of milliseconds for large VMAs.

So this would be the *perfect* place to just downgrade the semaphore
from a write to a read.

Do the vma ops under the write semaphore, then downgrade it to a
read-sem, and do the page teardown with just mmap_sem held for
reading..

Comments? Anybody want to try that? It should be fairly
straightforward, and we had a somewhat similar issue when it came to
mmap() having to populate the mapping for mlock. For that case, it was
sufficient to just move the "populate" phase outside the lock entirely
(for that case, we actually drop the write lock and then take the
read-lock and re-lookup the vma, for unmap we'd have to do a proper
downgrade so that there is no window where the virtual address area
could be re-allocated)

The big issue is that we'd have to split up do_munmap() into those two
phases, since right now callers take the write semaphore before
calling it, and drop it afterwards. And some callers do it in a loop.
But we should be fairly easily able to make the *common* case (ie
normal "munmap()") do something like

    down_write(&mm->mmap_sem);
    phase1_munmap(..);
    downgrade_write(&mm->mmap_sem);
    phase2_munmap(..);
    up_read(&mm->mmap_sem);

instead of what it does now (which is to just do
down_write()/up_write() around do_munmap()).

I don't see any fundamental problems, but maybe there's some really
annoying detail that makes this nasty (right now we do
"remove_vma_list() -> remove_vma()" *after* tearing down the page
tables, and since that calls the ->close function, I think it has to
be done that way. I'm wondering if any of that code relies on the
mmap_sem() being held for exclusively for writing. I don't see why it
possibly could, but..

So maybe I'm being overly optimistic and it's not as easy as just
splitting do_mmap() into two phases, but it really *looks* like it
might be just a ten-liner or so.. And if a real munmap() is the common
case (as opposed to a do_munmap() that gets triggered by somebody
doing a "mmap()" on top of an old mapping), then we'd at least allow
page faults from other threads to be done concurrently with tearing
down the page tables for the unmapped vma..

             Linus
