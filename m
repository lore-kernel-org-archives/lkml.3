Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3A1UWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:22:21 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:46786 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3A1UWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:22:18 -0500
Date: Mon, 28 Jan 2013 12:22:14 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128202214.GD26407@google.com>
References: <20130124232024.GA584@google.com>
 <20130125180941.GA16896@redhat.com>
 <20130125191139.GA19247@redhat.com>
 <20130128181528.GA26407@google.com>
 <20130128182737.GC22465@mtj.dyndns.org>
 <20130128184933.GC26407@google.com>
 <20130128185552.GD22465@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128185552.GD22465@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 10:55:52AM -0800, Tejun Heo wrote:
> Hey, Kent.
> 
> On Mon, Jan 28, 2013 at 10:49:33AM -0800, Kent Overstreet wrote:
> > Yeah. It'd be really nice if it was doable without synchronize_rcu(),
> > but it'd definitely make get/put heavier.
> > 
> > Though, re. close() - considering we only need a synchronize_rcu() if
> > the ref was in percpu mode, I wonder if that would be a dealbreaker. I
> > have no clue myself.
> 
> The problem is that the performance drop (or latency increase) in
> patheological cases would be catastrophic.  We're talking about
> possibly quite a few millisecs of delay between each close().  When
> done sequentially for large number of files, it gets ugly.  It becomes
> a dangerous optimization to make.

Yeah, I tend to agree.

> > Getting rid of synchronize_rcu would basically require turning get and
> > put into cmpxchg() loops - even in the percpu fastpath. However, percpu
> > mode would still be getting rid of the shared cacheline contention, we'd
> > just be adding another branch that can be safely marked unlikely() - and
> > my current version has one of those already, so two branches instead of
> > one in the fast path.
> 
> Or offer an asynchrnous interface so that high-frequency users don't
> end up inserting synchronize_sched() between each call.  It makes the
> interface more complex and further away from simple atomic_t
> replacement tho.

Could do that too, but then teardown gets really messy for the user - we
need two synchronize_rcu()s:

state := dying

synchronize_rcu()

/* Now nothing's changing the per cpu counters */

Add per cpu counters to atomic counter counter

/* Atomic counter is now consistent */

state := dead

synchronize_rcu()

/* Now percpu_ref_put will check for ref == 0 */

/* Drop initial ref */

percpu_ref_put()

And note that the first synchronize_rcu() is only needed when we had
allocated per cpu counters, my current code skips it otherwise.

(which is a reason for keeping dynamic allocation I hadn't thought of -
if we don't ever allocate percpu counters, teardown is faster)
