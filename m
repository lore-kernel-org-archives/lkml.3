Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaGOQM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 12:12:27 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:53338
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbaGOQMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 12:12:23 -0400
Date: Tue, 15 Jul 2014 11:12:20 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
In-Reply-To: <CA+55aFzP_GZaTYcUg7CN+Sz5ZeWX2CgxX3hig2gyBxhCCayamA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1407151054390.11327@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org> <20140612153426.GV4581@linux.vnet.ibm.com> <20140612155227.GB23606@htj.dyndns.org> <20140617144151.GD4669@linux.vnet.ibm.com> <20140617152752.GC31819@htj.dyndns.org> <87lhs35p0v.fsf@rustcorp.com.au>
 <20140714113911.GM16041@linux.vnet.ibm.com> <alpine.DEB.2.11.1407141014390.25436@gentwo.org> <20140715101150.GA8690@linux.vnet.ibm.com> <alpine.DEB.2.11.1407150903570.10593@gentwo.org> <20140715143225.GC8690@linux.vnet.ibm.com> <alpine.DEB.2.11.1407150952580.10593@gentwo.org>
 <CA+55aFzP_GZaTYcUg7CN+Sz5ZeWX2CgxX3hig2gyBxhCCayamA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Linus Torvalds wrote:

> Really, "before" and "after" have ABSOLUTELY NO MEANING unless you
> have a barrier. And you're arguing against those barriers. So you
> cannot use "before" as an argument, since in your world, no such thing
> even exists!

I mentioned that there is a barrier because the process of handing over
the offset to the other includes synchronization. In the slab case this is
a semaphore that is use to protect the structure and the list of
kmem_cache structures. The control struct containing the offset must be
entered somehow into something that tracks it for the future and thus
there is synchronization by the subsytem.

> > There are other arguments, but they basically boil down to "no other
> CPU ever accesses the per-cpu data of *this* CPU" (wrong) or "the
> users will do their own barriers" (maybe true, maybe not). Your "value
> is only available after" argument really isn't an argument. Not
> without those barriers.

Ok so what is happening is:

1. cacheline is zeroed on per_cpu_alloc but still exists in remote processor.

(we could actually insert code in alloc_percpu to ensure that the remote
caches are cleaned and not proceed unless that is complete. allocpercpu
is not performance critical).

2. cacheline is initialized with new values by the subsystem looping over
all percpu instances. Other processor still keeps the old data.

3. mutex is taken, list modifications occur, mutex is released. Remote
processor still keeps the old cacheline data.

4. Subsystem makes the percpu offset available.

5. The remote processor is processing using its instance of the per cpu
data for the first time using the offset to determine the percpu data for
its data. This typically means its updating the cacheline (and we hope
that the cacheline will be in exclusive state for good for performance reasons).

And now we still see the old data. The cacheline changes of the initial
processor are ignored?

Ok if this is the case then we have another way of dealing with this in
alloc_percpu. Either zap the relevant remote cpu caches after the areas
were zeroed or do an IPI to make the remote processor run the percpu area
initialization.




