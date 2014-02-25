Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaBYTby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 14:31:54 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:34349 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaBYTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 14:31:52 -0500
MIME-Version: 1.0
In-Reply-To: <1393355040.2577.52.camel@buesod1.americas.hpqcorp.net>
References: <1393352206.2577.36.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzPYZnkSQa=Y4Uo3zMVUVdchVxN2S266KyZLu-yJ314pw@mail.gmail.com>
	<1393355040.2577.52.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 25 Feb 2014 11:31:51 -0800
X-Google-Sender-Auth: n8Nu6YtQAP3VJcVnrdC2swdXcwU
Message-ID: <CA+55aFy-7J+f+ogdN8rbzfDp1yRiiNnX7cnmbAwnTXp2JLTS4Q@mail.gmail.com>
Subject: Re: [PATCH v2] mm: per-thread vma caching
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 11:04 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
>> So it walks completely the wrong list of threads.
>
> But we still need to deal with the rest of the tasks in the system, so
> anytime there's an overflow we need to nullify all cached vmas, not just
> current's. Am I missing something special about fork?

No, you're missing the much more fundamental issue: you are *not*
incrementing the current mm sequence number at all.

This code here:

    mm->vmacache_seqnum = oldmm->vmacache_seqnum + 1;

doesn't change the "oldmm" sequence number.

So invalidating the threads involved with the current sequence number
is totally bogus. It's a completely nonsensical operation. You didn't
do anything to their sequence numbers.

Your argument that "we still need to deal with the rest of the tasks"
is bogus. There is no "rest of the tasks". You're creating a new mm,
WHICH DOESN'T HAVE ANY TASKS YET!

(Well, there is the one half-formed task that is also in the process
of being created, but that you don't even have access to in
"dup_mmap()").

It's also not sensible to make the new vmacache_seqnum have anything
to do with the *old* vmacache seqnum. They are two totally unrelated
things, since they are separate mm's, and they are tied to independent
threads. They basically have nothing in common, so initializing the
new mm sequence number with a value that is related to the old
sequence number is not a sensible operation anyway.

So dup_mmap() should just clear the mm->seqnum, and not touch any
vmacache entries. There are no current vmacache entries associated
with that mm anyway.

And then you should clear the new vmacache entries in the thread
structure, and set vmacache_seqnum to 0 there too. You can do that in
"dup_mm()", which has access to the new task-struct.

And then you're done, as far as fork() is concerned.

Now, the *clone* case (CLONE_VM) is different. See "copy_mm()". For
that case, you should probably just copy the vma cache from the old
thread, and set the sequence number to be the same one. That's
correct, since you are re-using the mm. But in practice, you don't
actually need to do anything, since "dup_task_struct()" should have
done this all. So the CLONE_VM case doesn't actually require any
explicit code, because copying the cache and the sequence number is
already the right thing to do.

Btw, that all reminds me:

The one case you should make sure to double-check is the "exec" case,
which also creates a new mm. So that should clear the vmcache entries
and the seqnum.  Currently we clear mm->mmap_cache implicitly in
mm_alloc() because we do a memset(mm, 0) in it.

So in exec_mmap(), as you do the activate_mm(), you need to do that
same "clear vmacache and sequence number for *this* thread (and this
thread *only*)".

                 Linus
