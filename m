Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaDOWrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:47:32 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:36615 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaDOWrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:47:31 -0400
Date: Tue, 15 Apr 2014 15:47:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, cl@linux.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, tj@kernel.org, grygorii.strashko@ti.com,
        peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
Message-ID: <20140415224725.GS4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140415221755.GA27188@linux.vnet.ibm.com>
 <20140415222951.GA742@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140415222951.GA742@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041522-7164-0000-0000-000001123537
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 06:29:51PM -0400, Dave Jones wrote:
> On Tue, Apr 15, 2014 at 03:17:55PM -0700, Paul E. McKenney wrote:
> 
>  > My current admittedly crude workaround is as follows:
>  > 
>  > 	static inline bool rcu_should_resched(void)
>  > 	{
>  > 		int t;
>  > 
>  > 	#ifdef CONFIG_DEBUG_PREEMPT
>  > 		preempt_disable();
>  > 	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
>  > 		t = __this_cpu_read(rcu_cond_resched_count) + 1;
>  > 		if (t < RCU_COND_RESCHED_LIM) {
>  > 			__this_cpu_write(rcu_cond_resched_count, t);
>  > 	#ifdef CONFIG_DEBUG_PREEMPT
>  > 			preempt_enable();
>  > 	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
>  > 			return false;
>  > 		}
>  > 	#ifdef CONFIG_DEBUG_PREEMPT
>  > 		preempt_enable();
>  > 	#endif /* #ifdef CONFIG_DEBUG_PREEMPT */
>  > 		return true;
>  > 	}
> 
> Won't using DEBUG_PREEMPT instead of just CONFIG_PREEMPT here make this
> silently do the wrong thing if preemption is enabled, but debugging isn't ?

If preemption is enabled, but debugging is not, then yes, the above code
might force an unnecessary schedule() if the above code was preempted
between the __this_cpu_read() and the __this_cpu_write().  Which does
not cause a problem, especially given that it won't happen very often.

> I'm not seeing why you need the ifdefs at all, unless the implied
> barrier() is a problem ?

I don't think that Peter Zijlstra would be too happy about an extra
unneeded preempt_disable()/preempt_enable() pair in the cond_resched()
fastpath.  Not that I necessarily expect him to be particularly happy
with the above, but perhaps someone has a better approach.

							Thanx, Paul

