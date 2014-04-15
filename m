Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaDOWcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:32:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaDOWck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:32:40 -0400
Date: Tue, 15 Apr 2014 18:29:51 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: cl@linux.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        tj@kernel.org, grygorii.strashko@ti.com, peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
Message-ID: <20140415222951.GA742@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, cl@linux.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
	grygorii.strashko@ti.com, peterz@infradead.org
References: <20140415221755.GA27188@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415221755.GA27188@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 03:17:55PM -0700, Paul E. McKenney wrote:
 
 > My current admittedly crude workaround is as follows:
 > 
 > 	static inline bool rcu_should_resched(void)
 > 	{
 > 		int t;
 > 
 > 	#ifdef CONFIG_DEBUG_PREEMPT
 > 		preempt_disable();
 > 	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
 > 		t = __this_cpu_read(rcu_cond_resched_count) + 1;
 > 		if (t < RCU_COND_RESCHED_LIM) {
 > 			__this_cpu_write(rcu_cond_resched_count, t);
 > 	#ifdef CONFIG_DEBUG_PREEMPT
 > 			preempt_enable();
 > 	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
 > 			return false;
 > 		}
 > 	#ifdef CONFIG_DEBUG_PREEMPT
 > 		preempt_enable();
 > 	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
 > 		return true;
 > 	}

Won't using DEBUG_PREEMPT instead of just CONFIG_PREEMPT here make this
silently do the wrong thing if preemption is enabled, but debugging isn't ?

I'm not seeing why you need the ifdefs at all, unless the implied
barrier() is a problem ?

	Dave

