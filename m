Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895AbaFQTkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:40:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42284 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933509AbaFQTkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:40:23 -0400
Date: Tue, 17 Jun 2014 12:40:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140617194017.GO4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140612135630.GA23606@htj.dyndns.org>
 <alpine.DEB.2.11.1406171401350.22064@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406171401350.22064@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061719-9332-0000-0000-0000011F1CE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 02:27:43PM -0500, Christoph Lameter wrote:
> On Thu, 12 Jun 2014, Tejun Heo wrote:
> 
> > percpu areas are zeroed on allocation and, by its nature, accessed
> > from multiple cpus.  Consider the following scenario.
> 
> I am not sure that the premise is actually right. Percpu areas are
> designed to be accessed from a single cpu and we provide instances
> of variables for each cpu.
> 
> There is no synchronization guarantee for accesses from other cpu. If
> these accesses occur then we tolerate some fuzziness and usualy only do
> read accesses. F.e. for statistics if we loop over all cpus to get a sum
> of percpu counters (which is a classic use case for percpu data).
> 
> But there are numerous uses where no accesses from other cpus are required
> (mostly when percpu stuff is not used for statistics but for cpu local
> lists and status).
> 
> Cross cpu write accesses typically occur only after the allocation and
> before the code that actually does something is aware of the existence of
> the percpu area allocated or if the processor is being offlines/onlines.
> 
>  > >  p = NULL; >
> > 	CPU-1				CPU-2
> >  p = alloc_percpu()		if (p)
> > 					WARN_ON(this_cpu_read(*p));
> 
> p is an offset into the per cpu area of the processor. The value of P
> first has to be made available to cpu2 somehow and this usually provides
> the opportunity for synchronization that avoids the above scenario.
> 
> And so it is typical that these offsets are stored in larger structs that
> also have other means of synchronization.
> 
> F.e. Allocators take a global lock and then instantiate a new
> structure with the associated per cpu area allocation which is added to a
> global list after it is ready. The address of the allocator structure
> is then made available to other processors.
> 
> Another method is to perform this allocation on bootup which then also
> does not require synchronization (page allocator).
> 
> Similar in swapon(). The percpu allocation is performed before access to
> the containing structure (via enable_swap_info).

Those are indeed common use cases.  However...

There is code where one CPU writes to another CPU's per-CPU variables.
One example is RCU callback offloading, where a kernel thread (which
might be running anywhere) dequeues a given CPU's RCU callbacks and
processes them.  The act of dequeuing requires write access to that
CPU's per-CPU rcu_data structure.  And yes, atomic operations and memory
barriers are of course required to make this work.

							Thanx, Paul

