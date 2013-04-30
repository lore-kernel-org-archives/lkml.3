Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab3D3H3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:29:49 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:47500 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3D3H3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:29:47 -0400
Date: Tue, 30 Apr 2013 16:29:44 +0900
From: Simon Horman <horms@verge.net.au>
To: Julian Anastasov <ja@ssi.bg>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH v2 1/2] sched: Add cond_resched_rcu_lock() helper
Message-ID: <20130430072944.GA13959@verge.net.au>
References: <1367290378-29224-1-git-send-email-horms@verge.net.au>
 <1367290378-29224-2-git-send-email-horms@verge.net.au>
 <alpine.LFD.2.00.1304301011310.1700@ja.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1304301011310.1700@ja.ssi.bg>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 10:12:38AM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Tue, 30 Apr 2013, Simon Horman wrote:
> 
> > This is intended for use in loops which read data protected by RCU and may
> > have a large number of iterations.  Such an example is dumping the list of
> > connections known to IPVS: ip_vs_conn_array() and ip_vs_conn_seq_next().
> > 
> > The call to cond_resched() is guarded by #ifndef CONFIG_PREEMPT_RCU as in
> > the case of CONFIG_PREEMPT_RCU _rcu_read_unlock() will check to see if the
> > RCU core needs to be informed, so there is no need to invoke cond_resched()
> > in that case. Thanks to Paul E. McKenney for explaining this.
> > 
> > cond_resched_rcu_lock() suggested by Eric Dumazet.
> > ifndef guard suggested by Paul E. McKenney and Julian Anastasov.
> > 
> > Cc: Eric Dumazet <eric.dumazet@gmail.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Julian Anastasov <ja@ssi.bg>
> > Acked-by: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Simon Horman <horms@verge.net.au>
> > 
> > ---
> > 
> > v2
> > * Add guard the call to cond_resched()
> > ---
> >  include/linux/sched.h | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index e692a02..66da71c 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -2787,3 +2787,14 @@ static inline unsigned long rlimit_max(unsigned int limit)
> >  }
> >  
> >  #endif
> > +
> > +static void inline cond_resched_rcu_lock(void)
> > +{
> > +	if (need_resched()) {
> 
> 	Ops, it should be without above need_resched.

Thanks, to clarify, just this:

static void inline cond_resched_rcu_lock(void)
{
	rcu_read_unlock();
#ifndef CONFIG_PREEMPT_RCU
	cond_resched();
#endif
	rcu_read_lock();
}
