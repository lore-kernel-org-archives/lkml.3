Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab3A1RtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:49:05 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60565 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab3A1RtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:49:02 -0500
Date: Mon, 28 Jan 2013 09:48:58 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Oleg Nesterov <oleg@redhat.com>,
        srivatsa.bhat@linux.vnet.ibm.com, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130128174858.GW26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130125005136.GE2373@mtj.dyndns.org>
 <20130125011345.GT26407@google.com>
 <20130125020340.GG2373@mtj.dyndns.org>
 <20130125020943.GH2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125020943.GH2373@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 06:09:43PM -0800, Tejun Heo wrote:
> Hello, again.
> 
> On Thu, Jan 24, 2013 at 06:03:40PM -0800, Tejun Heo wrote:
> > Yeah, if we're aiming to replace refcnts in file and kobj, dynamic
> > alloc may be justified.  Hopefully, the accounting necessary to decide
> > whethre to use percpu isn't too burdensome.
> 
> Ooh, I forgot one thing.  We might not gain much by replacing file
> refcnt w/ this.  You can't really get cheaper than fget_light().

I've seen fget() show up when profiling the aio code - it's not high
enough to be a big concern when not doing stupid stuff, but high enough
that making it percpu would be worth it if it was easy. Which it's not,
for plenty of reasons.

> Also, while kobj destruction can still be considered an infrequent
> operation, file destruction is not and people will get mighty unhappy
> if you do synchronize_sched/rcu() from fput() synchronously.
> 
> So, I'm now back to "do we need dynamic allocation".  What else do we
> have to convert?

I dunno. There's a lot of random refcounts scattered around, though.

The way I see it, if it's always percpu when joe random dev needs a
refcount, he's going to weigh whether the overhead of a percpu refcount
is worth it.

With dynamic allocation, it's 16 bytes if you don't need it to be
percpu, vs. 4 for an atomic_t - so you never need to think about it, you
can just always use this for your refcounts and never have to think
about if it's going to be a fast path thing or not.

But I really liked your idea for making dynamic allocation use a pool
that's refilled from a workqueue, then I can keep dynamic allocation
without contorting the api.
