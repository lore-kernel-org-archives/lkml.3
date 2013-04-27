Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab3D0QVC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 12:21:02 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60530 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab3D0QU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 12:20:57 -0400
Date: Sat, 27 Apr 2013 09:20:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Julian Anastasov <ja@ssi.bg>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Simon Horman <horms@verge.net.au>, Ingo Molnar <mingo@redhat.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, dhaval.giani@gmail.com
Subject: Re: [PATCH 2/2] ipvs: Use cond_resched_rcu_lock() helper when
 dumping connections
Message-ID: <20130427162049.GB3780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1366940708-10180-1-git-send-email-horms@verge.net.au>
 <1366940708-10180-3-git-send-email-horms@verge.net.au>
 <20130426080313.GC8669@dyad.programming.kicks-ass.net>
 <20130426154547.GC3860@linux.vnet.ibm.com>
 <20130426171948.GA31467@dyad.programming.kicks-ass.net>
 <20130426174815.GI3860@linux.vnet.ibm.com>
 <1367000815.8964.243.camel@edumazet-glaptop>
 <alpine.LFD.2.00.1304271342260.1633@ja.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1304271342260.1633@ja.ssi.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042716-7182-0000-0000-0000066E70FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 02:32:48PM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Fri, 26 Apr 2013, Eric Dumazet wrote:
> 
> > On Fri, 2013-04-26 at 10:48 -0700, Paul E. McKenney wrote:
> > 
> > > Don't get me wrong, I am not opposing cond_resched_rcu_lock() because it
> > > will be difficult to validate.  For one thing, until there are a lot of
> > > them, manual inspection is quite possible.  So feel free to apply my
> > > Acked-by to the patch.
> > 
> > One question : If some thread(s) is(are) calling rcu_barrier() and
> > waiting we exit from rcu_read_lock() section, is need_resched() enough
> > for allowing to break the section ?
> > 
> > If not, maybe we should not test need_resched() at all.
> > 
> > rcu_read_unlock();
> > cond_resched();
> > rcu_read_lock();
> 
> 	So, I assume, to help realtime kernels and rcu_barrier
> it is not a good idea to guard rcu_read_unlock with checks.
> I see that rcu_read_unlock will try to reschedule in the 
> !CONFIG_PREEMPT_RCU case (via preempt_enable), can we
> use ifdefs to avoid double TIF_NEED_RESCHED check?:
> 
> 	rcu_read_unlock();
> #if !defined(CONFIG_PREEMPT) || defined(CONFIG_PREEMPT_RCU)

I would instead suggest something like:

#ifndef CONFIG_PREEMPT_RCU

But yes, in the CONFIG_PREEMPT_RCU case, the cond_resched() is not
needed.

							Thanx, Paul

> 	cond_resched();
> #endif
> 	rcu_read_lock();
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 

