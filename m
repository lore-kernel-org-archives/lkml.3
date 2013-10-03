Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3JCOCc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:02:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47130 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab3JCOCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:02:17 -0400
Date: Thu, 3 Oct 2013 16:01:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20131003140150.GL28601@twins.programming.kicks-ass.net>
References: <20131002145655.361606532@infradead.org>
 <20131002150518.600557855@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002150518.600557855@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 04:56:56PM +0200, Peter Zijlstra wrote:
> +	if (atomic_dec_and_test(&cpuhp_waitcount))
> +		wake_up(&cpuhp_writer);
> +
> +	goto again:
>  }

> +
> +#define per_cpu_sum(var)						\
> +({ 									\
> + 	typeof(var) __sum = 0;						\
> + 	int cpu;							\
> + 	for_each_possible_cpu(cpu)					\
> + 		__sum += per_cpu(var, cpu);				\
> + 	__sum;								\
> +)}
>  

I just noticed I forgot a refresh..


+++ b/kernel/cpu.c
@@ -120,7 +120,7 @@ void __get_online_cpus(void)
        if (atomic_dec_and_test(&cpuhp_waitcount))
                wake_up(&cpuhp_writer);
 
-       goto again:
+       goto again;
 }
 EXPORT_SYMBOL_GPL(__get_online_cpus);
 
@@ -146,7 +146,7 @@ EXPORT_SYMBOL_GPL(__put_online_cpus);
        for_each_possible_cpu(cpu)                                      \
                __sum += per_cpu(var, cpu);                             \
        __sum;                                                          \
-)}
+})
 
 /*
  * See srcu_readers_active_idx_check() for a rather more detailed explanation.
