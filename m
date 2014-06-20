Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934890AbaFTPu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:50:28 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39844 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaFTPuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:50:23 -0400
Date: Fri, 20 Jun 2014 08:50:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] percpu: add data dependency barrier in percpu
 accessors and operations
Message-ID: <20140620155017.GD4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140612135630.GA23606@htj.dyndns.org>
 <alpine.DEB.2.11.1406171401350.22064@gentwo.org>
 <20140617194017.GO4669@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191540240.4002@gentwo.org>
 <20140619205137.GK4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406201024070.10810@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406201024070.10810@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062015-0928-0000-0000-000002D616FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 10:29:04AM -0500, Christoph Lameter wrote:
> On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> 
> > Or just keep doing what I am doing.  What exactly is the problem with it?
> > (Other than probably needing to clean up the cache alignment of some
> > of the per-CPU structures?)
> 
> Writing to a cacheline of another processor can impact performance of that
> other processor since the cacheline (which may contain other performance
> critical data) is evicted from that processors cache.

I believe that most of the people on this thread already understand this,
and that most of them also understand the used of alignment directives
to avoid false-sharing issues.

> The mechanisms for handling percpu data are not designed with the
> consideration of writes into foreign percpu data areas in mind. Surprises
> may result from such use.
> 
> In particular I see a danger in understanding what "atomic" percpu
> operations are. These are not to be confused with regular atomic ops.
> Percpu atomics are atomic for accesses that occur in a single specific
> hardware thread. Percpu "atomics" are atomic vs. interrupts or preemption
> occuring on that specific processor. No serialization is supported for
> accesses may it be read or write from foreign processors.

It sounds like you are thinking strictly in terms of machine-word
sized and aligned per-CPU data.  Much of the cross-CPU accesses are
to structs placed into per-CPU data.  You are not thinking in terms
of having all of the per-CPU data mapped to the same virtual address,
so that CPUs simply cannot access each others' per-CPU data, are you?
That would result in a re-proliferation of NR_CPUS-element arrays.

							Thanx, Paul

