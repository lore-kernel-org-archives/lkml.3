Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab3LAQzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 11:55:49 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:47738 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3LAQzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 11:55:43 -0500
Date: Sun, 1 Dec 2013 17:55:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Jason Low <jason.low2@hp.com>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
Message-ID: <20131201165538.GA12864@gmail.com>
References: <20131125203358.156292370@linutronix.de>
 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
 <20131126085256.GD789@laptop.programming.kicks-ass.net>
 <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
 <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
 <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
 <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
 <20131128115946.GD13532@twins.programming.kicks-ass.net>
 <20131201121022.GB12115@gmail.com>
 <20131201125604.GH16796@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131201125604.GH16796@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, Dec 01, 2013 at 01:10:22PM +0100, Ingo Molnar wrote:
>
> > But more importantly, since these are all NUMA systems, would it 
> > make sense to create per node hashes on NUMA? Each futex would be 
> > enqueued into the hash belonging to its own page's node.
> 
> Can't do that; we hash on vaddr, the actual page can move between 
> nodes while a futex is queued.

Hm, indeed. We used to hash on the physical address - the very first 
futex version from Rusty did:

+static inline struct list_head *hash_futex(struct page *page,
+                                          unsigned long offset)
+{
+       unsigned long h;
+
+       /* struct page is shared, so we can hash on its address */
+       h = (unsigned long)page + offset;
+       return &futex_queues[hash_long(h, FUTEX_HASHBITS)];
+}

But this was changed to uaddr keying in:

  69e9c9b518fc [PATCH] Unpinned futexes v2: indexing changes

(commit from the linux historic git tree.)

I think this design aspect could perhaps be revisited/corrected - in 
what situations can a page move from under a futex? Only via the 
memory migration system calls, or are there other channels as well? 
Swapping should not affect the address, as the pages are pinned, 
right?

Keeping the page invariant would bring significant performance 
advantages to hashing.

> This would mean that the waiting futex is queued on another node 
> than the waker is looking.

Yeah, that cannot work.

Thanks,

	Ingo
