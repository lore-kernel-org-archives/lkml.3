Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3LBOoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:44:07 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:41759 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3LBOoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:44:01 -0500
Date: Mon, 2 Dec 2013 15:43:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20131202144356.GA26150@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-urgent-for-linus

   # HEAD: 96739d6e548e16d76de39d059e1e39e70c187fff sched/doc: Fix generation of device-drivers

Various smaller fixlets, all over the place.

 Thanks,

	Ingo

------------------>
Alex Shi (1):
      sched: Remove unused variable in 'struct sched_domain'

Joe Perches (1):
      MAINTAINERS: Update file patterns in the lockdep and scheduler entries

Nicolas Dichtel (1):
      sched/doc: Fix generation of device-drivers

Peter Zijlstra (1):
      sched: Avoid NULL dereference on sd_busy

Shigeru Yoshida (1):
      sched: Fix a trivial typo in comments

Srikar Dronamraju (1):
      sched: Check sched_domain before computing group power

Thomas Gleixner (1):
      sched: Expose preempt_schedule_irq()


 Documentation/DocBook/device-drivers.tmpl |  2 +-
 MAINTAINERS                               |  3 +--
 include/linux/sched.h                     |  2 --
 kernel/sched/core.c                       |  8 ++++----
 kernel/sched/fair.c                       | 27 ++++++++++++++++++++++++---
 5 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 6c9d9d3..f517008 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -58,7 +58,7 @@
      </sect1>
      <sect1><title>Wait queues and Wake events</title>
 !Iinclude/linux/wait.h
-!Ekernel/wait.c
+!Ekernel/sched/wait.c
      </sect1>
      <sect1><title>High-resolution timers</title>
 !Iinclude/linux/ktime.h
diff --git a/MAINTAINERS b/MAINTAINERS
index f3ef1d1..3f85561 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5236,7 +5236,7 @@ S:	Maintained
 F:	Documentation/lockdep*.txt
 F:	Documentation/lockstat.txt
 F:	include/linux/lockdep.h
-F:	kernel/lockdep*
+F:	kernel/locking/
 
 LOGICAL DISK MANAGER SUPPORT (LDM, Windows 2000/XP/Vista Dynamic Disks)
 M:	"Richard Russon (FlatCap)" <ldm@flatcap.org>
@@ -7361,7 +7361,6 @@ S:	Maintained
 F:	kernel/sched/
 F:	include/linux/sched.h
 F:	include/uapi/linux/sched.h
-F:	kernel/wait.c
 F:	include/linux/wait.h
 
 SCORE ARCHITECTURE
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f7efc86..b122395 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -823,8 +823,6 @@ struct sched_domain {
 	unsigned int balance_interval;	/* initialise to 1. units in ms. */
 	unsigned int nr_balance_failed; /* initialise to 0 */
 
-	u64 last_update;
-
 	/* idle_balance() stats */
 	u64 max_newidle_lb_cost;
 	unsigned long next_decay_max_lb_cost;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c180860..e85cda2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2660,6 +2660,7 @@ asmlinkage void __sched notrace preempt_schedule(void)
 	} while (need_resched());
 }
 EXPORT_SYMBOL(preempt_schedule);
+#endif /* CONFIG_PREEMPT */
 
 /*
  * this is the entry point to schedule() from kernel preemption
@@ -2693,8 +2694,6 @@ asmlinkage void __sched preempt_schedule_irq(void)
 	exception_exit(prev_state);
 }
 
-#endif /* CONFIG_PREEMPT */
-
 int default_wake_function(wait_queue_t *curr, unsigned mode, int wake_flags,
 			  void *key)
 {
@@ -4762,7 +4761,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 		cpumask_clear_cpu(rq->cpu, old_rd->span);
 
 		/*
-		 * If we dont want to free the old_rt yet then
+		 * If we dont want to free the old_rd yet then
 		 * set old_rd to NULL to skip the freeing later
 		 * in this function:
 		 */
@@ -4910,8 +4909,9 @@ static void update_top_cache_domain(int cpu)
 	if (sd) {
 		id = cpumask_first(sched_domain_span(sd));
 		size = cpumask_weight(sched_domain_span(sd));
-		rcu_assign_pointer(per_cpu(sd_busy, cpu), sd->parent);
+		sd = sd->parent; /* sd_busy */
 	}
+	rcu_assign_pointer(per_cpu(sd_busy, cpu), sd);
 
 	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
 	per_cpu(sd_llc_size, cpu) = size;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e8b652e..fd773ad 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5379,10 +5379,31 @@ void update_group_power(struct sched_domain *sd, int cpu)
 		 */
 
 		for_each_cpu(cpu, sched_group_cpus(sdg)) {
-			struct sched_group *sg = cpu_rq(cpu)->sd->groups;
+			struct sched_group_power *sgp;
+			struct rq *rq = cpu_rq(cpu);
 
-			power_orig += sg->sgp->power_orig;
-			power += sg->sgp->power;
+			/*
+			 * build_sched_domains() -> init_sched_groups_power()
+			 * gets here before we've attached the domains to the
+			 * runqueues.
+			 *
+			 * Use power_of(), which is set irrespective of domains
+			 * in update_cpu_power().
+			 *
+			 * This avoids power/power_orig from being 0 and
+			 * causing divide-by-zero issues on boot.
+			 *
+			 * Runtime updates will correct power_orig.
+			 */
+			if (unlikely(!rq->sd)) {
+				power_orig += power_of(cpu);
+				power += power_of(cpu);
+				continue;
+			}
+
+			sgp = rq->sd->groups->sgp;
+			power_orig += sgp->power_orig;
+			power += sgp->power;
 		}
 	} else  {
 		/*
