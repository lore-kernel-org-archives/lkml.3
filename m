Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaFOFlK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 01:41:10 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:56594 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaFOFlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 01:41:08 -0400
Date: Sat, 14 Jun 2014 22:40:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
	unprotected when accessed by /proc)
Message-ID: <20140615054058.GJ4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140611171734.GA27457@redhat.com>
 <20140611172958.GF4581@linux.vnet.ibm.com>
 <20140611175934.GA28912@redhat.com>
 <20140611195613.GM4581@linux.vnet.ibm.com>
 <20140612172844.GA15795@redhat.com>
 <20140612203518.GZ4581@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406122337060.5170@nanos>
 <20140612222748.GF4581@linux.vnet.ibm.com>
 <20140612231944.GA30683@linux.vnet.ibm.com>
 <20140613150830.GB31794@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613150830.GB31794@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061505-3532-0000-0000-0000027BFE97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 05:08:30PM +0200, Oleg Nesterov wrote:
> On 06/12, Paul E. McKenney wrote:
> >
> > @@ -398,11 +399,9 @@ void rcu_read_unlock_special(struct task_struct *t)
> >  #ifdef CONFIG_RCU_BOOST
> >  		if (&t->rcu_node_entry == rnp->boost_tasks)
> >  			rnp->boost_tasks = np;
> > -		/* Snapshot/clear ->rcu_boost_mutex with rcu_node lock held. */
> > -		if (t->rcu_boost_mutex) {
> > -			rbmp = t->rcu_boost_mutex;
> > -			t->rcu_boost_mutex = NULL;
> > -		}
> > +		/* Snapshot/clear ->boost_mutex with rcu_node lock held. */
> > +		if (rt_mutex_owner(&rnp->boost_mtx) == t)
> > +			rbmp = &rnp->boost_mtx;
> 
> The comment above looks confusing after this change ;) We do not clear it,
> and it doesn't explain "with rcu_node lock held".
> 
> And, with or without this change it is not obvious why do we need "rbmp",
> after this patch this becomes even more unobvious.
> 
> This is subjective of course, but perhaps it would be more understandable
> to do
> 
> 	bool xxx;
> 
> 	...
> 
> 	// Check this under rcu_node lock to ensure that unlock below
> 	// can't race with rt_mutex_init_proxy_locked() in progress.
> 	xxx = rt_mutex_owner(&rnp->boost_mtx) == t;
> 
> 	...
> 
> 	// rnp->lock was dropped
> 	if (xxx)
> 		rt_mutex_unlock(&rnp->boost_mtx);
> 
> 
> But this is very minor, I won't insist of course. Mostly I am just trying
> to check my understanding.

No, this is good, and I will update accordingly.

							Thanx, Paul

