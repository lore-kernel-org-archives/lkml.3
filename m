Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaGOPlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:41:53 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:58399 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaGOPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:41:51 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1407150952580.10593@gentwo.org>
References: <20140612135630.GA23606@htj.dyndns.org>
	<20140612153426.GV4581@linux.vnet.ibm.com>
	<20140612155227.GB23606@htj.dyndns.org>
	<20140617144151.GD4669@linux.vnet.ibm.com>
	<20140617152752.GC31819@htj.dyndns.org>
	<87lhs35p0v.fsf@rustcorp.com.au>
	<20140714113911.GM16041@linux.vnet.ibm.com>
	<alpine.DEB.2.11.1407141014390.25436@gentwo.org>
	<20140715101150.GA8690@linux.vnet.ibm.com>
	<alpine.DEB.2.11.1407150903570.10593@gentwo.org>
	<20140715143225.GC8690@linux.vnet.ibm.com>
	<alpine.DEB.2.11.1407150952580.10593@gentwo.org>
Date: Tue, 15 Jul 2014 08:41:49 -0700
X-Google-Sender-Auth: SYaEO3sqtD1KVG4XIXrlC4UD6Rc
Message-ID: <CA+55aFzP_GZaTYcUg7CN+Sz5ZeWX2CgxX3hig2gyBxhCCayamA@mail.gmail.com>
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph, stop arguing. Trust me, Paul knows memory ordering. You
clearly do *not*.

On Tue, Jul 15, 2014 at 8:06 AM, Christoph Lameter <cl@gentwo.org> wrote:
>
> The cachelines will be evicted from the other processors at
> initialization. alloc_percpu *itself* zeroes all data on each percpu areas
> before returning the offset to the percpu data structure. See
> pcpu_populate_chunk(). At that point *all* other processors have those
> cachelines no longer in their caches. The initialization done with values
> specific to the subsystem is not that important.

In practice, with enough instructions in the CPU queues and
sufficiently small write buffers etc (or with a sufficiently ordered
CPU core, like x86), that may often be true. But there is absolutely
zero reason to think it's always true.

On the writer side, if there isn't a write barrier, the actual writes
can be visible to other CPU's in arbitrary order. *Including* the
visibility of the offset before the zeroing. Really.

On the reader side, for all sane CPU's, reading the offset and then
reading data from that offset is an implicit barrier. But "all sane"
is not "all". On alpha, reading the offset does NOT guarantee that you
see later data when you use that offset to read data. In theory, it
could be due to value prediction, but in practice it's actually due to
segmented caches, so that one part of the cache has seen data that
arrived "later" (ie written _after_ the wmb on the writing CPU)
_before_ it sees data that arrived earlier. That's what the
"smp_read_barrier_depends()" protects against.

> The return value of the function is only available after
> pcpu_populate_chunk() returns.

Really, "before" and "after" have ABSOLUTELY NO MEANING unless you
have a barrier. And you're arguing against those barriers. So you
cannot use "before" as an argument, since in your world, no such thing
even exists!

There are other arguments, but they basically boil down to "no other
CPU ever accesses the per-cpu data of *this* CPU" (wrong) or "the
users will do their own barriers" (maybe true, maybe not). Your "value
is only available after" argument really isn't an argument. Not
without those barriers.

            Linus
