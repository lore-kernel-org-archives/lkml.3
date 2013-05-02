Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3EBH2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:28:12 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39689
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab3EBH2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:28:10 -0400
Date: Thu, 2 May 2013 09:26:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>, Eric Dumazet <eric.dumazet@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH v2 1/2] sched: Add cond_resched_rcu_lock() helper
Message-ID: <20130502072623.GE7521@dyad.programming.kicks-ass.net>
References: <1367290378-29224-1-git-send-email-horms@verge.net.au>
 <1367290378-29224-2-git-send-email-horms@verge.net.au>
 <alpine.LFD.2.00.1304301011310.1700@ja.ssi.bg>
 <20130430072944.GA13959@verge.net.au>
 <alpine.LFD.2.00.1304301051260.1700@ja.ssi.bg>
 <20130501091012.GB28253@dyad.programming.kicks-ass.net>
 <alpine.LFD.2.00.1305011344320.1603@ja.ssi.bg>
 <20130501155501.GB7521@dyad.programming.kicks-ass.net>
 <alpine.LFD.2.00.1305012004360.3397@ja.ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1305012004360.3397@ja.ssi.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 09:22:08PM +0300, Julian Anastasov wrote:
> > +extern int __cond_resched_rcu(void);
> > +
> > +#define cond_resched_rcu() ({			\
> > +	__might_sleep(__FILE__, __LINE__, 0);	\
> 
> 	I see your goal. But digging into __might_sleep()
> I see that rcu_sleep_check() will scream for the non-preempt
> case because we are under rcu_read_lock.


#ifdef CONFIG_PREEMPT_RCU
#define PREEMPT_RCU_OFFSET 0
#else
#define PREEMPT_RCU_OFFSET 1
#endif

#define cond_resched_rcu() ({	\
	__might_sleep(__FILE__, __LINE__, PREEMPT_RCU_OFFSET);	\
	__cond_resched_rcu();	\
})

Should work I think..
