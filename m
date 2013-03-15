Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172Ab3COURu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:17:50 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56159 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3COURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:17:49 -0400
Date: Fri, 15 Mar 2013 13:17:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ming Lei <tom.leiming@gmail.com>,
        Shaohua Li <shli@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: +
 atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive .patch
 added to -mm tree
Message-ID: <20130315201739.GK3656@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130314162413.GA21344@redhat.com>
 <CACVXFVP+fGeWS3xwBfaQDFaH7=e_4CbgCru9DJczB2vyWuUL1g@mail.gmail.com>
 <20130315134632.GA18335@redhat.com>
 <CACVXFVOjWc4RU+A-8PeYP9RfJ1-HSiZHbbv771LXDynMs0ybMQ@mail.gmail.com>
 <20130315165131.GA32065@redhat.com>
 <CAFTL4hxNh5qMZyyrLc8_yG5-i7UoS_nan22pO8o1fb8yS7Vz3w@mail.gmail.com>
 <20130315175117.GA2462@redhat.com>
 <CAFTL4hwZQcN_sO0SN8bJqEsQdC8ArDvJhFPg62Kh8OQyUe=MUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hwZQcN_sO0SN8bJqEsQdC8ArDvJhFPg62Kh8OQyUe=MUw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031520-5806-0000-0000-0000205BF72D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 07:34:32PM +0100, Frederic Weisbecker wrote:
> 2013/3/15 Oleg Nesterov <oleg@redhat.com>:
> > On 03/15, Frederic Weisbecker wrote:
> >>
> >> > The lack of the barrier?
> >> >
> >> > I thought about this, this should be fine? atomic_add_unless() has the same
> >> > "problem", but this is documented in atomic_ops.txt:
> >> >
> >> >         atomic_add_unless requires explicit memory barriers around the operation
> >> >         unless it fails (returns 0).
> >> >
> >> > I thought that atomic_add_unless_negative() should have the same
> >> > guarantees?
> >>
> >> I feel very uncomfortable with that. The memory barrier is needed
> >> anyway to make sure we don't deal with a stale value of the atomic val
> >> (wrt. ordering against another object).
> >> The following should really be expected to work without added barrier:
> >>
> >> void put_object(foo *obj)
> >> {
> >>       if (atomic_dec_return(obj->ref) == -1)
> >>           free_rcu(obj);
> >> }
> >>
> >> bool try_get_object(foo *obj)
> >> {
> >>       if (atomic_add_unless_negative(obj, 1))
> >>            return true;
> >>       return false;
> >> }
> >>
> >> = CPU 0 =                = CPU 1
> >>                                 rcu_read_lock()
> >> put_object(obj0);
> >>                                 obj = rcu_derefr(obj0);
> >> rcu_assign_ptr(obj0, NULL);
> >
> > (I guess you meant rcu_assign_ptr() then put_object())
> 
> Right.
> 
> >
> >>                                 if (try_get_object(obj))
> >>                                      do_something...
> >>                                 else
> >>                                      object is dying
> >>                                 rcu_read_unlock()
> >
> > I must have missed something.
> >
> > do_something() looks fine, if atomic_add_unless_negative() succeeds
> > we do have a barrier?
> 
> Ok, I guess the guarantee of a barrier in case of failure is probably
> not needed. But since the only way to safely read the atomic value is
> a cmpxchg like operation, I guess a barrier must be involved in any
> case.
> 
> Using atomic_read() may return some stale value.
> 
> >
> > Anyway, I understand that it is possible to write the code which
> > won't work without the uncoditional mb().
> 
> Yeah that's my fear.
> 
> >
> > My point was: should we fix atomic_add_unless() then? If not, why
> > should atomic_add_unless_negative() differ?
> 
> They shouldn't differ I guess.

Completely agreed.  It is not like memory ordering is simple, so we should
keep the rules simple.  Atomic primitives that sometimes imply a memory
barrier seems a bit over the top.

The rule is that if an atomic primitive returns non-void, then there is
a full memory barrier before and after.  This applies to primitives
returning boolean as well, with atomic_dec_and_test() setting this
precedent from what I can see.

							Thanx, Paul

