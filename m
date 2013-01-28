Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab3A1RxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:53:10 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:37499 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab3A1RxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:53:08 -0500
Date: Mon, 28 Jan 2013 09:53:04 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        bcrl@kvack.org, jmoyer@redhat.com, axboe@kernel.dk,
        viro@zeniv.linux.org.uk, tytso@mit.edu,
        Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130128175304.GX26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130125005136.GE2373@mtj.dyndns.org>
 <87libhpz4h.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87libhpz4h.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 04:45:10PM +1030, Rusty Russell wrote:
> Tejun Heo <tj@kernel.org> writes:
> >> It also implements two stage shutdown, as we need it to tear down the
> >> percpu counts. Before dropping the initial refcount, you must call
> >> percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> >> switches back to a single atomic refcount with the appropriate barriers
> >> (synchronize_rcu()).
> >
> > Maybe if we have tryget() which only succeeds if the counter is alive,
> > we can replace moulde refcnt with this?  Rusty?
> 
> Yes, it's similar (hence my previous interest), though module count is a
> bit weird.

I'll try and take a stab at converting it, if I can find time.

> Like Tejun, I'd prefer to see it always alloc up-front, because it
> avoids the _noalloc variant (which is backwards: please hand gfp_t, so
> you don't hide the alloc) and heuristics.

Problem with gfp_t is alloc_percpu() doesn't take it. I don't know why,
but this all goes away with Tejun's idea for allocating from a pool
refilled by workqueue.
