Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759841AbbA0Ual (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:30:41 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:58199 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759811AbbA0Uaj (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 27 Jan 2015 15:30:39 -0500
Message-ID: <1422390627.4604.5.camel@stgolabs.net>
Subject: Re: [PATCH 2/6] locking/rwsem: Document barrier need when waking
 tasks
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Michel Lespinasse <walken@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 27 Jan 2015 12:30:27 -0800
In-Reply-To: <20150127170732.GI21418@twins.programming.kicks-ass.net>
References: <1422257769-14083-1-git-send-email-dave@stgolabs.net>
	 <1422257769-14083-3-git-send-email-dave@stgolabs.net>
	 <20150127170732.GI21418@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 18:07 +0100, Peter Zijlstra wrote:
> On Sun, Jan 25, 2015 at 11:36:05PM -0800, Davidlohr Bueso wrote:
> > The need for the smp_mb in __rwsem_do_wake should be
> > properly documented. Applies to both xadd and spinlock
> > variants.
> > 
> > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> > ---
> >  kernel/locking/rwsem-spinlock.c | 5 +++++
> >  kernel/locking/rwsem-xadd.c     | 5 +++++
> >  2 files changed, 10 insertions(+)
> > 
> > diff --git a/kernel/locking/rwsem-spinlock.c b/kernel/locking/rwsem-spinlock.c
> > index 2555ae1..54f7a17 100644
> > --- a/kernel/locking/rwsem-spinlock.c
> > +++ b/kernel/locking/rwsem-spinlock.c
> > @@ -85,6 +85,11 @@ __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
> >  
> >  		list_del(&waiter->list);
> >  		tsk = waiter->task;
> > +		/*
> > +		 * Ensure that all cores see the read before
> > +		 * setting it to the waiter task to nil, as that
> > +		 * grants the read lock to the next task.
> > +		 */
> >  		smp_mb();
> >  		waiter->task = NULL;
> >  		wake_up_process(tsk);
> 
> Could you enhance that comment by pointing at the pairing code? Is that
> the wait loop in rwsem_down_read_failed()?

Yep.

> Also, the comment confuses, how can all cores observe a read into a
> local variable?

Yep, I'll rephrase that ;)

