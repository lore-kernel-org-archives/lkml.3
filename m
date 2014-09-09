Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbaIIQQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:16:55 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39706 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaIIQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:16:53 -0400
Date: Tue, 9 Sep 2014 09:16:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andreea-Cristina Bernat <bernat.ada@gmail.com>, paulus@samba.org,
        mingo@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: events: core: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140909161648.GE4704@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140822132605.GA20130@ada>
 <20140909094235.GD19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909094235.GD19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090916-3532-0000-0000-0000047D1726
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 11:42:35AM +0200, Peter Zijlstra wrote:
> On Fri, Aug 22, 2014 at 04:26:05PM +0300, Andreea-Cristina Bernat wrote:
> > The use of "rcu_assign_pointer()" is NULLing out the pointer.
> > According to RCU_INIT_POINTER()'s block comment:
> > "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
> > it is better to use it instead of rcu_assign_pointer() because it has a
> > smaller overhead.
> > 
> > The following Coccinelle semantic patch was used:
> > @@
> > @@
> > 
> > - rcu_assign_pointer
> > + RCU_INIT_POINTER
> >   (..., NULL)
> > 
> > Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> > ---
> >  kernel/events/core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 0d735be..4b84dd5 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -5744,7 +5744,7 @@ static void swevent_hlist_release(struct swevent_htable *swhash)
> >  	if (!hlist)
> >  		return;
> >  
> > -	rcu_assign_pointer(swhash->swevent_hlist, NULL);
> > +	RCU_INIT_POINTER(swhash->swevent_hlist, NULL);
> >  	kfree_rcu(hlist, rcu_head);
> >  }
> 
> Paul, why not do something like the below and do away with all this
> nonsense?

We used to do that, but the compilers became uncooperative, despite
Stephen Hemminger's best efforts.

							Thanx, Paul

> ---
>  include/linux/rcupdate.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index d231aa17b1d7..38c3e629ae70 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -623,7 +623,13 @@ static inline void rcu_preempt_sleep_check(void)
>   * please be careful when making changes to rcu_assign_pointer() and the
>   * other macros that it invokes.
>   */
> -#define rcu_assign_pointer(p, v) smp_store_release(&p, RCU_INITIALIZER(v))
> +#define rcu_assign_pointer(p, v)					\
> +do {									\
> +	if (__builtin_constant_p(v) && v == NULL)			\
> +		p = RCU_INITIALIZER(v);					\
> +	else								\
> +		smp_store_release(&p, RCU_INITIALIZER(v));		\
> +} while (0)
>  
>  /**
>   * rcu_access_pointer() - fetch RCU pointer with no dereferencing


