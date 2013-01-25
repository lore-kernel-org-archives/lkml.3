Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3AYCDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:03:54 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:37840 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3AYCDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:03:48 -0500
Date: Thu, 24 Jan 2013 18:03:40 -0800
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        srivatsa.bhat@linux.vnet.ibm.com, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130125020340.GG2373@mtj.dyndns.org>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130125005136.GE2373@mtj.dyndns.org>
 <20130125011345.GT26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125011345.GT26407@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Regurgitating stuff which came up during chat for the record.

On Thu, Jan 24, 2013 at 05:13:45PM -0800, Kent Overstreet wrote:
> I was envisioning something with low enough overhead that we could use
> it for the refcounts in struct file and kref/kobject - I've seen both of
> those show up in profiles (admittedly with the kobject ref some of it
> was stupid usage, but it'd be nice if we could just hit it with a very
> big hammer and make the problem go away once and for all).
> 
> I'm not sure what the memory overhead would be like if we made all those
> refcounts percpu and whether people would find it acceptable.

Yeah, if we're aiming to replace refcnts in file and kobj, dynamic
alloc may be justified.  Hopefully, the accounting necessary to decide
whethre to use percpu isn't too burdensome.

> > Requiring rcu locking for refcnt is
> > very unusure and it would probably be better to use
> > synchronize_sched[_expedited]() instead in combination w/ preemp or
> > irq flipping.
> 
> I haven't come across synchronize_sched() before - is it less overhead
> than synchronize_rcu()? 

It's just for different context.  It flushes preemption disabled
regions instead of rcu read locked regions.  The advantage usually
being you don't have to do do rcu read locking if you already are
flipping preemption / irq.  It generally is more conventional to use
preempt_disable/enable() paired w/ synchronize_sched() when RCU itself
isn't being used.

> > It also makes the
> > interface prone to misuse.  It'll be easy to have mixed alloc and
> > noalloc sites and then lose alloc ones or just foget about the
> > distinction and end up with refcnts which never convert to percpu one
> > and there will be no way to easily identify those.
> 
> This is true, I'm not a huge fan of the interface.
> 
> The way percpu_ref_get() drops and retakes rcu_read_lock() is definitely
> ugly. I had an idea when I was last looking at the code for that -
> percpu_ref_get() could merely return whether the user should call
> percpu_ref_alloc(), and then the caller can do that in the appropriate
> context (or skip it if it's in a slowpath and can't).
> 
> This would also mean that users could just unconditionally call
> percpu_ref_alloc() (or have an init function that does that too).
> 
> Just given that the code works and is tested I wasn't in a huge hurry to
> screw with it more - sort of prefer to wait and see how it gets used.

What we can do is keeping cache of percpu allocations which is
refilled via a work item and just use it as necessary if available.
As the conversion to percpu behavior is opportunistic to begin with,
this way we can avoid having separate interface for alloc/noalloc.

Several other things.

* It would probably be a good idea to have @alloc_percpu flag during
  init.

* It would be nice to have get/put perpcu fast paths as inline
  functions.

* Is it really necessary to overload percpu_ref->pcpu_count with
  flags?  Fast path would be simpler if we just leave it NULL if
  percpu refs aren't in use.

  if (ref->pcpu_count)
	this_cpu_inc(ref->pcpu_count);
  else
	get_slowpath();

* I feel too stupid to understand the frequency counting code.

* So, what happens if the percpu counter overflows?  Does it require
  that get and put happen on the same CPU?  Also, note that
  rcu_read_lock() doesn't necessarily guarantee that the task won't be
  preempted.  You may end up on a different CPU.

Thanks.

-- 
tejun
