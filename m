Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab3LRKCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:02:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3LRKCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:02:09 -0500
Date: Wed, 18 Dec 2013 11:01:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, juri.lelli@gmail.com,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com
Subject: Re: [PATCH] sched, deadline: Properly initialize def_dl_bandwidth
 lock
Message-ID: <20131218100134.GM13532@twins.programming.kicks-ass.net>
References: <20131217122720.950475833@infradead.org>
 <20131217151753.58834399@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131217151753.58834399@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 03:17:53PM -0500, Steven Rostedt wrote:
> 
> Spinlocks even in structures require to be properly initialized.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Index: linux-rt.git/kernel/sched/deadline.c
> ===================================================================
> --- linux-rt.git.orig/kernel/sched/deadline.c
> +++ linux-rt.git/kernel/sched/deadline.c
> @@ -18,7 +18,9 @@
>  
>  #include <linux/slab.h>
>  
> -struct dl_bandwidth def_dl_bandwidth;
> +struct dl_bandwidth def_dl_bandwidth = {
> +	.dl_runtime_lock = __RAW_SPIN_LOCK_UNLOCKED(def_dl_bandwidth.dl_runtime_lock),
> +};
>  
>  static inline struct task_struct *dl_task_of(struct sched_dl_entity *dl_se)
>  {

The thing is, init_dl_bandwidth() in sched_init() is supposed to already
do that. The stacktrace you provided out of band:

[    0.000000]  [<ffffffff814e2aca>] spin_bug+0x2b/0x2d
[    0.000000]  [<ffffffff8107535c>] do_raw_spin_lock+0x27/0x104
[    0.000000]  [<ffffffff814ec32e>] _raw_spin_lock+0x20/0x24
[    0.000000]  [<ffffffff8106fc41>] init_dl_bw+0x2d/0x79^M
[    0.000000]  [<ffffffff810607b9>] init_rootdomain+0x20/0x4f^M
[    0.000000]  [<ffffffff81b0db07>] sched_init+0x69/0x432
[    0.000000]  [<ffffffff81af3b6c>] start_kernel+0x201/0x41c
[    0.000000]  [<ffffffff81af3773>] ? repair_env_string+0x56/0x56
[    0.000000]  [<ffffffff81af3487>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff81af357b>] x86_64_start_kernel+0xf2/0xf9

Has clue though. So it appears we use the lock before we reach that
init_dl_bandwidth.

The below hunk should fix things up -- merged into patch 9/13.

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6768,15 +6768,15 @@ void __init sched_init(void)
 #endif /* CONFIG_CPUMASK_OFFSTACK */
 	}
 
-#ifdef CONFIG_SMP
-	init_defrootdomain();
-#endif
-
 	init_rt_bandwidth(&def_rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
 	init_dl_bandwidth(&def_dl_bandwidth,
 			global_dl_period(), global_dl_runtime());
 
+#ifdef CONFIG_SMP
+	init_defrootdomain();
+#endif
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	init_rt_bandwidth(&root_task_group.rt_bandwidth,
 			global_rt_period(), global_rt_runtime());
