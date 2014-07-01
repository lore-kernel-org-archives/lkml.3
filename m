Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758546AbaGAQlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:41:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758289AbaGAQls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:41:48 -0400
Date: Tue, 1 Jul 2014 18:40:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] rcu: uninline rcu_lock_acquire() and
	rcu_lock_release()
Message-ID: <20140701164002.GA26950@redhat.com>
References: <20140630161837.GA15873@redhat.com> <20140630161849.GA15887@redhat.com> <20140701114138.GQ6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701114138.GQ6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Peter Zijlstra wrote:
>
> On Mon, Jun 30, 2014 at 06:18:49PM +0200, Oleg Nesterov wrote:
> > +static inline void __rcu_lock_acquire(struct lockdep_map *map, unsigned long ip)
> >  {
> > +	lock_acquire(map, 0, 0, 2, 0, NULL, ip);
> >  }
>
> > +extern void rcu_lock_acquire(void);
> > +extern void rcu_lock_release(void);
> > +extern void rcu_lock_acquire_bh(void);
> > +extern void rcu_lock_release_bh(void);
> > +extern void rcu_lock_acquire_sched(void);
> > +extern void rcu_lock_release_sched(void);
>
> > diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> > index a2783cb..5c06289 100644
> > --- a/include/linux/srcu.h
> > +++ b/include/linux/srcu.h
> > @@ -219,7 +219,7 @@ static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
> >  {
> >  	int retval = __srcu_read_lock(sp);
> >
> > -	rcu_lock_acquire(&(sp)->dep_map);
> > +	__rcu_lock_acquire(&(sp)->dep_map, _THIS_IP_);
> >  	return retval;
> >  }
>
> Would an srcu_lock_acquire() not make sense here?
>
> In any case, not wrong per se, just a consistency thing that stood out.

Yes, I looked at this too...

But probably it would be better to just add __rcu_lock_acquire() into
__srcu_read_lock(), and kill that inline in srcu.h ?

Oleg.

