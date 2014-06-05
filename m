Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaFERyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:54:37 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:57043 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaFERyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:54:36 -0400
Message-ID: <1401990873.13877.34.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [RFC PATCH 1/1] remove redundant compare, cmpxchg already does
 it
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andev <debiandev@gmail.com>, Pranith Kumar <pranith@gatech.edu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 05 Jun 2014 10:54:33 -0700
In-Reply-To: <20140605072248.GE3213@twins.programming.kicks-ass.net>
References: <538F83DF.8090303@gatech.edu>
	 <CAJUuVQ4VioKuVuCTXr3BcfRpYs+9+5bx9m2WLO7Swsnni0tUAw@mail.gmail.com>
	 <20140605072248.GE3213@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 09:22 +0200, Peter Zijlstra wrote:
> On Wed, Jun 04, 2014 at 04:56:50PM -0400, Andev wrote:
> > On Wed, Jun 4, 2014 at 4:38 PM, Pranith Kumar <pranith@gatech.edu> wrote:
> > > remove a redundant comparision
> > >
> > > Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> > > ---
> > >  kernel/locking/rwsem-xadd.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> > > index 1f99664b..6f8bd3c 100644
> > > --- a/kernel/locking/rwsem-xadd.c
> > > +++ b/kernel/locking/rwsem-xadd.c
> > > @@ -249,8 +249,7 @@ static inline bool rwsem_try_write_lock(long count, struct rw_semaphore *sem)
> > >  {
> > >      if (!(count & RWSEM_ACTIVE_MASK)) {
> > >          /* try acquiring the write lock */
> > > -        if (sem->count == RWSEM_WAITING_BIAS &&
> > > -            cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> > > +        if (cmpxchg(&sem->count, RWSEM_WAITING_BIAS,
> > >                  RWSEM_ACTIVE_WRITE_BIAS) == RWSEM_WAITING_BIAS) {
> > 
> > This was mainly done to avoid the cost of a cmpxchg in case where they
> > are not equal. Not sure if it really makes a difference though.
> 
> It does, a cache hot cmpxchg instruction is 24 cycles (as is pretty much
> any other LOCKed ins, as measured on my WSM-EP), not to mention that
> cmpxchg is a RMW so it needs to grab the cacheline in exclusive mode.
> 
> A read, which allows the cacheline to remain in shared, and non LOCKed
> ops are way faster.

Yep, and we also do it in mutexes. The numbers and benefits on larger
systems speaks for themselves. It would, perhaps, be worth adding a
comment as it does seem redundant if you're not thinking about the
cacheline when reading the code.


