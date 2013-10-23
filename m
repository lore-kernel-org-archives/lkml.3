Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab3JWKOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:14:01 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:48128 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3JWKOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <5266BBC7.9030207@mit.edu>
References: <1382057438-3306-1-git-send-email-davidlohr@hp.com>
	<20131022154802.GA25490@localhost>
	<5266BBC7.9030207@mit.edu>
Date: Wed, 23 Oct 2013 03:13:59 -0700
Message-ID: <CANN689GGTnkG1+=aH1PDxkEyN3VdCfHLjDfA3VErpOpT84rZTg@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm,vdso: preallocate new vmas
From: Michel Lespinasse <walken@google.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        aswin@hp.com, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 10:54 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 10/22/2013 08:48 AM, walken@google.com wrote:
>> Generally the problems I see with mmap_sem are related to long latency
>> operations. Specifically, the mmap_sem write side is currently held
>> during the entire munmap operation, which iterates over user pages to
>> free them, and can take hundreds of milliseconds for large VMAs.
>
> This is the leading cause of my "egads, something that should have been
> fast got delayed for several ms" detector firing.

Yes, I'm seeing such issues relatively frequently as well.

>  I've been wondering:
>
> Could we replace mmap_sem with some kind of efficient range lock?  The
> operations would be:
>
>  - mm_lock_all_write (drop-in replacement for down_write(&...->mmap_sem))
>  - mm_lock_all_read (same for down_read)
>  - mm_lock_write_range(mm, start, end)
>  - mm_lock_read_range(mm, start_end)
>
> and corresponding unlock functions (that maybe take a cookie that the
> lock functions return or that take a pointer to some small on-stack data
> structure).

That seems doable, however I believe we can get rid of the latencies
in the first place which seems to be a better direction. As I briefly
mentioned, I would like to tackle the munmap problem sometime; Jan
Kara also has a project to remove places where blocking FS functions
are called with mmap_sem held (he's doing it for lock ordering
purposes, so that FS can call in to MM functions that take mmap_sem,
but there are latency benefits as well if we can avoid blocking in FS
with mmap_sem held).

> The easiest way to implement this that I can think of is a doubly-linked
> list or even just an array, which should be fine for a handful of
> threads.  Beyond that, I don't really know.  Creating a whole trie for
> these things would be expensive, and fine-grained locking on rbtree-like
> things isn't so easy.

Jan also had an implementation of range locks using interval trees. To
take a range lock, you'd add the range you want to the interval tree,
count the conflicting range lock requests that were there before you,
and (if nonzero) block until that count goes to 0. When releasing the
range lock, you look for any conflicting requests in the interval tree
and decrement their conflict count, waking them up if the count goes
to 0.

But as I said earlier, I would prefer if we could avoid holding
mmap_sem during long-latency operations rather than working around
this issue with range locks.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
