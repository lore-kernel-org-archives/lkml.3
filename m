Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaJBIH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:07:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaJBIHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:07:55 -0400
Date: Thu, 2 Oct 2014 09:37:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] wait: Provide infrastructure to deal with nested
 blocking
Message-ID: <20141002073739.GF2843@worktop.programming.kicks-ass.net>
References: <20140924081845.572814794@infradead.org>
 <20140924082242.051202318@infradead.org>
 <20140929210221.GA12112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929210221.GA12112@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:02:21PM +0200, Oleg Nesterov wrote:
> On 09/24, Peter Zijlstra wrote:
> >
> > There are a few places that call blocking primitives from wait loops,
> > provide infrastructure to support this without the typical
> > task_struct::state collision.
> >
> > We record the wakeup in wait_queue_t::flags which leaves
> > task_struct::state free to be used by others.
> 
> Sorry for delay. FWIW,
> 
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> 
> > +/*
> > + * DEFINE_WAIT_FUNC(wait, woken_wait_func);
>                              ^^^^^^^^^^^^^^^^
> woken_wake_function ;)
> 
> > +int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
> > +{
> > +	/*
> > +	 * Although this function is called under waitqueue lock, LOCK
> > +	 * doesn't imply write barrier and the users expects write
> > +	 * barrier semantics on wakeup functions.  The following
> > +	 * smp_wmb() is equivalent to smp_wmb() in try_to_wake_up()
> > +	 * and is paired with set_mb() in wait_woken().
> > +	 */
> > +	smp_wmb(); /* C */
> > +	wait->flags |= WQ_FLAG_WOKEN;
> 
> Perhaps it is just me, but I was a bit confused by the comment above wmb().
> Afaics, it is not that "users expects write barrier semantics", just we
> need to ensure that
> 
> 	CONDITION = true;
> 	wait->flags |= WQ_FLAG_WOKEN;
> 
> can't be reordered (and this differs from smp_wmb() in try_to_wake_up()).
> Otherwise we can obviously race with
> 
> 	// wait_woken() -> set_mb()
> 	wait->flags &= ~WQ_FLAG_WOKEN;
> 	mb();
> 
> 	if (CONDITION)
> 		break;
> 

Yes, that comment could be clearer. It is however, to me, the 'same' as
a regular wakeup in that we need to separate whatever state changes
before the wakeup (CONDITION=true typically) from whatever writes are
required to affect the wakeup (->state=TASK_RUNNING typically, +optional
enqueuing on runqueues and all that).


