Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaIERGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:06:00 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:56654
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752254AbaIERF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:05:59 -0400
Date: Thu, 4 Sep 2014 13:19:29 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] dynticks: dynticks_idle is only modified locally use
 this_cpu ops
In-Reply-To: <20140904161629.GF5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409041303250.14314@gentwo.org>
References: <20140902211517.GO5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409021819500.5437@gentwo.org> <20140903021152.GA14069@linux.vnet.ibm.com> <alpine.DEB.2.11.1409030846310.9372@gentwo.org> <20140903144349.GT5001@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1409031043540.24085@gentwo.org> <20140903171409.GZ5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409031226001.24691@gentwo.org> <20140903181931.GB5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409040944220.4565@gentwo.org>
 <20140904161629.GF5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014, Paul E. McKenney wrote:

> So in short, you don't see the potential for this use case actually
> breaking anything, correct?

In general its a performance impact but depending on how this_cpu_ops may
be implemented in a particular platform there may also be correctness
issues since the assumption there is that no remote writes occur.

There is a slight issue in th RCU code. It uses DEFINE_PER_CPU for
per cpu data which is used for true per cpu data where the
cachelines are not evicted. False aliasing RCU structure that are
remotely handled can cause issue for code that expects the per cpu data
to be not contended. I think it would be better to go to

DEFINE_PER_CPU_SHARED_ALIGNED

for your definitions in particular since there are still code pieces where
we are not sure if there are remote write accesses or not. This will give
you separate cachelines so that the false aliasing effect is not
occurring.

> Besides RCU is not the only place where atomics are used on per-CPU
> variables.  For one thing, there are a number of per-CPU spinlocks in use
> in various places throughout the kernel.  For another thing, there is also
> a large number of per-CPU structures (not pointers to structures, actual
> structures), and I bet that a fair number of these feature cross-CPU
> writes and cross-CPU atomics.  RCU's rcu_data structures certainly do.

Would be interested to see where that occurs.

> > the barrier issues, per cpu variables are updated always without the use
> > of atomics and the inspection of the per cpu state from remote cpus works
> > just fine also without them.
>
> Including the per-CPU spinlocks?  That seems a bit unlikely.  And again,
> I expect that a fair number of the per-CPU structures involve cross-CPU
> synchronization.

Where are those per cpu spinlocks? Cross cpu synchronization can be done
in a number of ways that often allow avoiding remote writes to percpu
areas.


> It already is consistent, just not in the manner that you want.  ;-)
>
> But -why- do you want these restrictions?  How does it help anything?

1. It allows potentially faster operations that allow to make the
assumption that no remote writes occur. The design of deterministic low
latency code often needs some assurances that another cpu is not simply
kicking the cacheline out which will then require off chip memory access
and remote cacheline eviction once the cacheline is touched again.

2. The use of atomic without a rationale is something that I frown upon
and it seems very likely that we have such a case here. People make
assumptions that the use of atomic has some reason, like a remote access
or contention, which is not occurring here.

3. this_cpu operations create instructions with reduced latency due tothe
lack of lock prefix. Remote operations at the same time could create
inconsistent results.

See also

linux/Documentation/this_cpu_ops.txt

