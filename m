Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3DLXyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:54:19 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36431 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3DLXyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:54:17 -0400
X-Originating-IP: 173.246.103.110
Date: Fri, 12 Apr 2013 16:54:02 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130412235401.GA8140@jtriplet-mobl1>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 04:19:13PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Systems with HZ=100 can have slow bootup times due to the default
> three-jiffy delays between quiescent-state forcing attempts.  This
> commit therefore auto-tunes the RCU_JIFFIES_TILL_FORCE_QS value based
> on the value of HZ.  However, this would break very large systems that
> require more time between quiescent-state forcing attempts.  This
> commit therefore also ups the default delay by one jiffy for each
> 256 CPUs that might be on the system (based off of nr_cpu_ids at
> runtime, -not- NR_CPUS at build time).
> 
> Reported-by: Paul Mackerras <paulus@au1.ibm.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Something seems very wrong if RCU regularly hits the fqs code during
boot; feels like there's some more straightforward solution we're
missing.  What causes these CPUs to fall under RCU's scrutiny during
boot yet not actually hit the RCU codepaths naturally?

Also, a comment below.

> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -342,7 +342,17 @@ struct rcu_data {
>  #define RCU_FORCE_QS		3	/* Need to force quiescent state. */
>  #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
>  
> -#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
> +#if HZ > 500
> +#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for jiffies_till_first_fqs */
> +#elif HZ > 250
> +#define RCU_JIFFIES_TILL_FORCE_QS	 2
> +#else
> +#define RCU_JIFFIES_TILL_FORCE_QS	 1
> +#endif

This seems like it really wants to use a duration calculated directly
from HZ; perhaps (HZ/100)?

- Josh Triplett
