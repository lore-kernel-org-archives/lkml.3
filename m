Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab3I3UBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:01:44 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:3208 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab3I3UBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:01:42 -0400
Message-ID: <5249D897.1010109@hp.com>
Date: Mon, 30 Sep 2013 16:01:27 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: Avoiding the dentry d_lock on final dput(), part deux: transactional
 memory
References: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
In-Reply-To: <CA+55aFwp-RAKEMVvbMG53C=kTMqS09NPXy1eP4xEUYZpvV8X5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 03:29 PM, Linus Torvalds wrote:
> So with all the lockref work, we now avoid the dentry d_lock for
> almost all normal cases.
>
> There is one single remaining common case, though: the final dput()
> when the dentry count goes down to zero, and we need to check if we
> are supposed to get rid of the dentry (or at least put it on the LRU
> lists etc).
>
> And that's something lockref itself cannot really help us with unless
> we start adding status bits to it (eg some kind of "enable slow-case"
> bit in the lock part of the lockref). Which sounds like a clever but
> very fragile approach.
>
> However, I did get myself a i7-4770S exactly because I was
> forward-thinking, and wanted to try using transactional memory for
> these kinds of things.
>
> Quite frankly, from all I've seen so far, the kernel is not going to
> have very good luck with things like lock elision, because we're
> really fine-grained already, and at least the Intel lock-elision
> (don't know about POWER8) basically requires software to do prediction
> on whether the transaction will succeed or not, dynamically based on
> aborts etc. And quite frankly, by the time you have to do things like
> that, you've already lost. We're better off just using our normal
> locks.
>
> So as far as I'm concerned, transactional memory is going to be useful
> - *if* it is useful - only for specialized code. Some of that might be
> architecture-internal lock implementations, other things might be
> exactly the dput() kind of situation.
>
> And the thing is, *normally* dput() doesn't need to do anything at
> all, except decrement the dentry reference count. However, for that
> normal case to be true, we need to atomically check:
>
>   - that the dentry lock isn't held (same as lockref)
>   - that we are already on the LRU list and don't need to add ourselves to it
>   - that we already have the DCACHE_REFERENCED bit set and don't need to set it
>   - that the dentry isn't unhashed and needs to be killed.
>
> Additionally, we need to check that it's not a dentry that has a
> "d_delete()" operation, but that's a static attribute of a dentry, so
> that's not something that we need to check atomically wrt the other
> things.
>
> ANYWAY. With all that out of the way, the basic point is that this is
> really simple, and fits very well with even very limited transactional
> memory. We literally need to do just a single write, and something
> like three reads from memory. And we already have a trivial fallback,
> namely the old code using the lockrefs.  IOW, it's literally ten
> straight-line instructions between the xbegin and the xend for me.
>
> So here's a patch that works for me. It requires gcc to know "asm
> goto", and it requires binutils that know about xbegin/xabort. And it
> requires a CPU that supports the intel RTM extensions.
>
> But I'm cc'ing the POWER people, because I don't know the POWER8
> interfaces, and I don't want to necessarily call this "xbegin"/"xend"
> when I actually wrap it in some helper functions.
>
> Anyway, profiles with this look beautiful (I'm using "make -j" on a
> fully built allmodconfig kernel tree as the source of profile data).
> There's no spinlocks from dput at all, and the dput() profile itself
> shows basically 1% in anything but the fastpath (probably the _very_
> occasional first accesses where we need to add things to the LRU
> lists).
>
> And the patch is small, but is obviously totally lacking any test for
> CPU support or anything like that. Or portability. But I thought I'd
> get the ball rolling, because I doubt the intel TSX patches are going
> to be useful (if they were, Intel would be crowing about performance
> numbers now that the CPU's are out, and they aren't).
>
> I don't know if the people doing HP performance testing have
> TSX-enabled machines, but hey, maybe. So you guys are cc'd too.

The Xeon class CPUs are typically about one year behind the consumer CPU 
chips. We are testing large NUMA machine with IvyBridge-EX CPUs right 
now. Haswell-EX has to be at least one year out. So we don't have the 
hardware to do the testing at the moment.

> I also didn't actually check if performance is affected. I doubt it is
> measurable on this machine, especially on "make -j" that spends 90% of
> its time in user space. But the profile comparison really does make it
> look good..
>
> Comments?
>
>                           Linus

I think this patch is worth a trial if relevant hardware is more widely 
available. The TSX code certainly need to be moved to an architecture 
specific area and should be runtime enabled using a static key. We also 
need more TSX support infrastructure in place first.

-Longman
