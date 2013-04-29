Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab3D2Val (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:30:41 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57104 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab3D2Vaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:30:39 -0400
Date: Mon, 29 Apr 2013 14:30:02 -0700
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
Message-ID: <20130429213002.GP3780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1366940708-10180-1-git-send-email-horms@verge.net.au>
 <1366940708-10180-3-git-send-email-horms@verge.net.au>
 <20130426080313.GC8669@dyad.programming.kicks-ass.net>
 <20130426154547.GC3860@linux.vnet.ibm.com>
 <20130426171948.GA31467@dyad.programming.kicks-ass.net>
 <20130426174815.GI3860@linux.vnet.ibm.com>
 <1367000815.8964.243.camel@edumazet-glaptop>
 <alpine.LFD.2.00.1304271342260.1633@ja.ssi.bg>
 <20130427162049.GB3780@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1304292356220.1822@ja.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1304292356220.1822@ja.ssi.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042921-4834-0000-0000-00000652F224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 12:08:18AM +0300, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Sat, 27 Apr 2013, Paul E. McKenney wrote:
> 
> > On Sat, Apr 27, 2013 at 02:32:48PM +0300, Julian Anastasov wrote:
> > > 
> > > 	So, I assume, to help realtime kernels and rcu_barrier
> > > it is not a good idea to guard rcu_read_unlock with checks.
> > > I see that rcu_read_unlock will try to reschedule in the 
> > > !CONFIG_PREEMPT_RCU case (via preempt_enable), can we
> > > use ifdefs to avoid double TIF_NEED_RESCHED check?:
> > > 
> > > 	rcu_read_unlock();
> > > #if !defined(CONFIG_PREEMPT) || defined(CONFIG_PREEMPT_RCU)
> > 
> > I would instead suggest something like:
> > 
> > #ifndef CONFIG_PREEMPT_RCU
> > 
> > But yes, in the CONFIG_PREEMPT_RCU case, the cond_resched() is not
> > needed.
> 
> 	Hm, is this correct? If I follow the ifdefs
> preempt_schedule is called when CONFIG_PREEMPT is
> defined _and_ CONFIG_PREEMPT_RCU is not defined.
> Your example for CONFIG_PREEMPT_RCU is the opposite to this?

Yep, I really did intend to say "#ifndef CONFIG_PREEMPT_RCU".

A couple of things to keep in mind:

1.	Although rcu_read_unlock() does map to preempt_enable() for
	CONFIG_TINY_RCU and CONFIG_TREE_RCU, the current Kconfig refuses
	to allow either CONFIG_TINY_RCU or CONFIG_TREE_RCU to be selected
	if CONFIG_PREEMPT=y.

2.	In the CONFIG_PREEMPT_RCU case, __rcu_read_unlock() will check
	to see if the RCU core needs to be informed, so there is no
	need to invoke cond_resched() in that case.

3.	If we drop your "|| defined(CONFIG_PREEMPT_RCU)", we get an
	almost-synonym for my "#ifndef CONFIG_PREEMPT_RCU".  The "almost"
	applies to older kernels due to the possibility of having a
	CONFIG_TINY_PREEMPT_RCU kernel -- but this possibility is going
	away soon.

Make sense?

							Thanx, Paul

> > > 	cond_resched();
> > > #endif
> > > 	rcu_read_lock();
> 
> Regards
> 
> --
> Julian Anastasov <ja@ssi.bg>
> 

