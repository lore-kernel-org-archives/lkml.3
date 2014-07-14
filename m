Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbaGNPWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:22:17 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:53684 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755615AbaGNPWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:22:11 -0400
Date: Mon, 14 Jul 2014 10:22:08 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <20140714113911.GM16041@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1407141014390.25436@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <20140612153426.GV4581@linux.vnet.ibm.com> <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org> <87lhs35p0v.fsf@rustcorp.com.au>
 <20140714113911.GM16041@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Paul E. McKenney wrote:

> Here is the sort of thing that I would be concerned about:
>
> 	p = alloc_percpu(struct foo);
> 	for_each_possible_cpu(cpu)
> 		initialize(per_cpu_ptr(p, cpu);
> 	gp = p;
>
> We clearly need a memory barrier in there somewhere, and it cannot
> be buried in alloc_percpu().  Some cases avoid trouble due to locking,
> for example, initialize() might acquire a per-CPU lock and later uses
> might acquire that same lock.  Clearly, use of a global lock would not
> be helpful from a scalability viewpoint.

The knowledge about the offset p is not available before gp is assigned
to.

gp usually is part of a struct that contains some form of serialization.
F.e. in the slab allocators there is a kmem_cache structure that contains
gp.

After alloc_percpu() and other preparatory work the structure is inserted
into a linked list while holding the global semaphore (slab_mutex). After
release of the semaphore the kmem_cache address is passed to the
subsystem. Then other processors can potentially use that new kmem_cache
structure to access new percpu data related to the new cache.

There is no scalability issue for the initialization since there cannot
be a concurrent access since the offset of the percpu value is not known
by other processors at that point.



