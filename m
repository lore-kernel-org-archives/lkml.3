Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3A1Stn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 13:49:43 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:37355 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab3A1Sth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 13:49:37 -0500
Date: Mon, 28 Jan 2013 10:49:33 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128184933.GC26407@google.com>
References: <20130124232024.GA584@google.com>
 <20130125180941.GA16896@redhat.com>
 <20130125191139.GA19247@redhat.com>
 <20130128181528.GA26407@google.com>
 <20130128182737.GC22465@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128182737.GC22465@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 10:27:37AM -0800, Tejun Heo wrote:
> Hello, guys.
> 
> On Mon, Jan 28, 2013 at 10:15:28AM -0800, Kent Overstreet wrote:
> > > 	percpu_ref_kill();
> > > 	put_and_dsetroy();
> > > 
> > > And this can race with another holder which drops the last reference,
> > > its put_and_dsetroy() can see PCPU_REF_DYING and return false.
> > > 
> > > Or I misunderstood the code/interface?
> > 
> > Nope, nailed it :) That should _definitely_ be in the documentation.
> 
> Can we just combine kill initiation and base ref put and make that the
> responsibility of the owner?  Extra features on basic constructs may
> seem good for certain use cases but tend to bring more confusion than
> good in the long run.  If a user needs to synchronize among multiple
> killers, let the user deal with the issue.

Don't follow...

Something I forgot to mention in the last mail though is that often the
caller will need its own synchronize_rcu()/call_rcu() -
percpu_ref_kill() corresponds to when you make the object unavailable
(i.e. deleting it from the rcu protected hash table in aio) and you need
a synchronize_rcu() before you drop your initial ref.

So letting the caller do it means the caller can merge the two
synchronize_rcu()s.

> 
> > Actually - I think it'd be better to have the default percpu_ref_kill()
> > do the second synchronize_rcu(), and have an unsafe version that skips
> > it.
> 
> Note that synchronize_rcu/sched() can be very slow and cause problems
> in paths which are frequently traveled and visible to userland.  It's
> fine for things like module destruction but can be a problem even
> during device destruction - blkcg had synchronize_rcu() in
> request_queue destruction which led to huge latencies during boot
> because SCSI wants to create and then destroy request_queues for all
> possible LUNs on certain configurations.  So, if you put
> synchronize_rcu/sched() in percpu_ref_kill(), that better not be used
> from e.g. close(2).

Yeah. It'd be really nice if it was doable without synchronize_rcu(),
but it'd definitely make get/put heavier.

Though, re. close() - considering we only need a synchronize_rcu() if
the ref was in percpu mode, I wonder if that would be a dealbreaker. I
have no clue myself.

Getting rid of synchronize_rcu would basically require turning get and
put into cmpxchg() loops - even in the percpu fastpath. However, percpu
mode would still be getting rid of the shared cacheline contention, we'd
just be adding another branch that can be safely marked unlikely() - and
my current version has one of those already, so two branches instead of
one in the fast path.

I suppose I should give it a shot.

As long as I'm going down that route I could probably make the bare non
percpu ref 8 bytes instead of 16, too...
