Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaFLCFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 22:05:24 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:50849 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaFLCFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 22:05:22 -0400
Message-ID: <1402538717.5160.4.camel@marge.simpson.net>
Subject: Re: [PATCH 1/2] sched: Rework migrate_tasks()
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: tkhai@yandex.ru
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tkhai Kirill <ktkhai@parallels.com>
Date: Thu, 12 Jun 2014 04:05:17 +0200
In-Reply-To: <1402515194.10391.9.camel@localhost.localdomain>
References: <20140611093417.27807.2288.stgit@tkhai>
	 <1402480330.32126.14.camel@tkhai>
	 <20140611112411.GA21191@linux.vnet.ibm.com>
	 <3732251402489254@web2m.yandex.ru>
	 <20140611131536.GB21191@linux.vnet.ibm.com>
	 <4032471402494232@web2m.yandex.ru>
	 <1402515194.10391.9.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 23:33 +0400, Kirill Tkhai wrote: 
> В Ср, 11/06/2014 в 17:43 +0400, Kirill Tkhai пишет:
> > 
> > 11.06.2014, 17:15, "Srikar Dronamraju" <srikar@linux.vnet.ibm.com>:
> > >>>  * Kirill Tkhai <ktkhai@parallels.com> [2014-06-11 13:52:10]:
> > >>>>   Currently migrate_tasks() skips throttled tasks,
> > >>>>   because they are not pickable by pick_next_task().
> > >>>  Before migrate_tasks() is called, we do call set_rq_offline(), in
> > >>>  migration_call().
> > >>>
> > >>>  Shouldnt this take care of unthrottling the tasks and making sure that
> > >>>  they can be picked by pick_next_task().
> > >>  If we do this separate for every class, we'll have to do this 3 times.
> > >>  Furthermore, deadline class does not have a list of throttled tasks.
> > >>  So we'll have to the same as I did: to lock tasklist_lock and to iterate
> > >>  throw all of the tasks in the system just to found deadline tasks.
> > >
> > > I think you misread my comment.
> > >
> > > Currently migrate_task() gets called from migration_call() and in the
> > > migration_call() before migrate_tasks(), set_rq_offline() should put
> > > tasks back using unthrottle_cfs_rq().
> > >
> > > So my question is: Why are these tasks not getting unthrottled
> > > through we are calling set_rq_offline? To me set_rq_offline is
> > > calling the actual sched class routines to do the needful.
> > >
> > > I can understand about deadline tasks, because we don't have a deadline
> > > But thats the only tasks that we need to fix.
> > 
> > Hm, I tested that on fair class tasks. They used to disappear from
> > /proc/sched_debug and used to hang. I'll check all once again.
> > 
> > I'm agree with you, if set_rq_offline() already presents, we should use it.
> > 
> > /me went to clarify why it does not work in my test.
> 
> Ok, it looks like the problem is that unthrottled cfs_rq may become throttled
> again ;)

Dejavu.  You could try either of the below.

On Thu, Apr 03, 2014 at 10:02:18AM +0200, Mike Galbraith wrote:
> Prevent large wakeup latencies from being accounted to the wrong task.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
> ---
>  kernel/sched/core.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -118,7 +118,12 @@ void update_rq_clock(struct rq *rq)
>  {
>  	s64 delta;
>  
> -	if (rq->skip_clock_update > 0)
> +	/*
> +	 * Set during wakeup to indicate we are on the way to schedule().
> +	 * Decrement to ensure that a very large latency is not accounted
> +	 * to the wrong task.
> +	 */
> +	if (rq->skip_clock_update-- > 0)
>  		return;
>  
>  	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;

OK; so as previously mentioned (Oct '13); I've entirely had it with
skip_clock_update bugs, so I got angry and did the below.

Its not something I can merge, not least because it uses trace_printk(),
but it should be usable to 1) demonstate the above actually helps and 2)
make damn sure we got it right this time :-)

I've not really stared at the output much yet; but when you select
function_graph tracer; we get lovely things like:

  8)               |                                          wake_up_process() {
  8)               |                                            try_to_wake_up() {
  8)   0.076 us    |                                              _raw_spin_lock_irqsave();
  8)   0.092 us    |                                              task_waking_fair();
  8)   0.106 us    |                                              select_task_rq_fair();
  8)   0.161 us    |                                              _raw_spin_lock();
  8)               |                                              ttwu_do_activate.constprop.103() {
  8)               |                                                activate_task() {
  8)               |                                                  enqueue_task() {
  8)               |                                                    update_rq_clock() {
  8)               |                                                      /* clock update: 420411 */
  8)   0.084 us    |                                                      sched_avg_update();
  8)   1.277 us    |                                                    }
  8)               |                                                    enqueue_task_fair() {
  8)               |                                                      enqueue_entity() {
  8)   0.083 us    |                                                        update_curr();
  8)   0.071 us    |                                                        __compute_runnable_contrib();
  8)   0.074 us    |                                                        __update_entity_load_avg_contrib();
  8)   0.121 us    |                                                        update_cfs_rq_blocked_load();
  8)   0.236 us    |                                                        account_entity_enqueue();
  8)   0.076 us    |                                                        update_cfs_shares();
  8)   0.075 us    |                                                        place_entity();
  8)   0.123 us    |                                                        __enqueue_entity();
  8)   5.260 us    |                                                      }
  8)   0.069 us    |                                                      __compute_runnable_contrib();
  8)   0.073 us    |                                                      hrtick_update();
  8)   7.146 us    |                                                    }
  8)   9.583 us    |                                                  }
  8) + 10.169 us   |                                                }
  8)               |                                                wq_worker_waking_up() {
  8)   0.071 us    |                                                  kthread_data();
  8)   0.682 us    |                                                }
  8)               |                                                ttwu_do_wakeup() {
  8)               |                                                  check_preempt_curr() {
  8)   0.077 us    |                                                    resched_task();
  8)               |                                                    /* skip_clock_update on cpu: 8 */
  8)   1.188 us    |                                                  }
  8)   1.914 us    |                                                }
  8) + 14.533 us   |                                              }
  8)   0.071 us    |                                              _raw_spin_unlock();
  8)   0.082 us    |                                              _raw_spin_unlock_irqrestore();
  8) + 18.874 us   |                                            }
  8) + 19.509 us   |                                          }

...

  8)               |                                          wake_up_process() {
  8)               |                                            try_to_wake_up() {
  8)   0.101 us    |                                              _raw_spin_lock_irqsave();
  8)   0.089 us    |                                              task_waking_fair();
  8)   0.071 us    |                                              select_task_rq_fair();
  8)   0.070 us    |                                              _raw_spin_lock();
  8)               |                                              ttwu_do_activate.constprop.103() {
  8)               |                                                activate_task() {
  8)               |                                                  enqueue_task() {
  8)               |                                                    update_rq_clock() {
  8)               |                                                      /* Invalid clock skip on cpu: 8 */
  8)               |                                                      /* clock update: 420413 */
  8)   0.942 us    |                                                    }
  8)               |                                                    enqueue_task_fair() {
  8)               |                                                      enqueue_entity() {
  8)   0.081 us    |                                                        update_curr();
  8)   0.074 us    |                                                        __compute_runnable_contrib();
  8)   0.069 us    |                                                        __update_entity_load_avg_contrib();
  8)   0.091 us    |                                                        update_cfs_rq_blocked_load();
  8)   0.108 us    |                                                        account_entity_enqueue();
  8)   0.081 us    |                                                        update_cfs_shares();
  8)   0.069 us    |                                                        place_entity();
  8)   0.107 us    |                                                        __enqueue_entity();
  8)   5.120 us    |                                                      }
  8)   0.068 us    |                                                      hrtick_update();
  8)   6.410 us    |                                                    }
  8)   8.484 us    |                                                  }
  8)   9.045 us    |                                                }
  8)               |                                                wq_worker_waking_up() {
  8)   0.074 us    |                                                  kthread_data();
  8)   0.669 us    |                                                }
  8)               |                                                ttwu_do_wakeup() {
  8)               |                                                  check_preempt_curr() {
  8)   0.091 us    |                                                    resched_task();
  8)               |                                                    /* skip_clock_update on cpu: 8 */
  8)   1.080 us    |                                                  }
  8)   1.709 us    |                                                }
  8) + 13.007 us   |                                              }
  8)   0.071 us    |                                              _raw_spin_unlock();
  8)   0.090 us    |                                              _raw_spin_unlock_irqrestore();
  8) + 17.105 us   |                                            }
  8) + 17.702 us   |                                          }

...

  8)               |  schedule_preempt_disabled() {
  8)               |    schedule() {
  8)               |    __schedule() {
  8)   0.105 us    |      rcu_note_context_switch();
  8)   0.078 us    |      _raw_spin_lock();
  8)               |      update_rq_clock() {
  8)               |        /* Invalid clock skip on cpu: 8 */
  8)               |        /* clock update: 420415 */
  8)   0.073 us    |        sched_avg_update();
  8)   1.630 us    |      }
  8)   0.080 us    |      pick_next_task_stop();
  8)   0.112 us    |      pick_next_task_dl();
  8)   0.088 us    |      pick_next_task_rt();
  8)               |      pick_next_task_fair() {
  8)               |        put_prev_task_idle() {
  8)   0.118 us    |          idle_exit_fair();
  8)   0.709 us    |        }
  8)               |        pick_next_entity() {
  8)   0.071 us    |          clear_buddies();
  8)   0.721 us    |        }
  8)               |        set_next_entity() {
  8)   0.139 us    |          __dequeue_entity();
  8)   0.732 us    |        }
  8)   3.804 us    |      }
 ------------------------------------------
  8)    <idle>-0    =>   <...>-220   
 ------------------------------------------

  8)               |      finish_task_switch() {
  8)   0.076 us    |        _raw_spin_unlock();
  8)   0.716 us    |      }
  8) ! 1876.643 us |    }
  8) ! 1877.297 us |  } /* schedule */

Also; did I say how much I hate that function_graph doesn't default to
latency-format ?

---
 kernel/sched/core.c      |  130 +++++++++++++++++++++++++++++------------------
 kernel/sched/deadline.c  |    6 +-
 kernel/sched/debug.c     |    7 +-
 kernel/sched/fair.c      |   50 ++++++++++--------
 kernel/sched/idle_task.c |    4 -
 kernel/sched/proc.c      |    4 -
 kernel/sched/rt.c        |    4 -
 kernel/sched/sched.h     |  105 ++++++++++++++++++++++---------------
 lib/Kconfig.debug        |    7 ++
 9 files changed, 195 insertions(+), 122 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -135,11 +135,31 @@ void update_rq_clock(struct rq *rq)
 {
 	s64 delta;
 
+#ifdef CONFIG_SCHED_DEBUG_CLOCK
+	if (rq->skip_clock_update > 0 && rq->clock_stamp != rq->clock_seq) {
+		rq->skip_clock_update = 0;
+		trace_printk("Invalid clock skip on cpu: %d\n", rq->cpu);
+		goto do_update;
+	}
+#endif
+
 	if (rq->skip_clock_update > 0)
 		return;
 
-	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
-	rq->clock += delta;
+#ifdef CONFIG_SCHED_DEBUG_CLOCK
+	if (!(rq->clock_stamp & 1))
+		trace_printk("clock update outside of rq->lock\n");
+
+	if (rq->clock_stamp == rq->clock_seq)
+		trace_printk("superfluous clock update\n");
+
+do_update:
+	trace_printk("clock update: %u\n", rq->clock_seq);
+	rq->clock_stamp = rq->clock_seq;
+#endif
+
+	delta = sched_clock_cpu(cpu_of(rq)) - rq->__clock;
+	rq->__clock += delta;
 	update_rq_clock_task(rq, delta);
 }
 
@@ -325,10 +345,10 @@ static inline struct rq *__task_rq_lock(
 
 	for (;;) {
 		rq = task_rq(p);
-		raw_spin_lock(&rq->lock);
+		rq_lock(rq);
 		if (likely(rq == task_rq(p)))
 			return rq;
-		raw_spin_unlock(&rq->lock);
+		rq_unlock(rq);
 	}
 }
 
@@ -344,10 +364,10 @@ static struct rq *task_rq_lock(struct ta
 	for (;;) {
 		raw_spin_lock_irqsave(&p->pi_lock, *flags);
 		rq = task_rq(p);
-		raw_spin_lock(&rq->lock);
+		rq_lock(rq);
 		if (likely(rq == task_rq(p)))
 			return rq;
-		raw_spin_unlock(&rq->lock);
+		rq_unlock(rq);
 		raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
 	}
 }
@@ -355,7 +375,7 @@ static struct rq *task_rq_lock(struct ta
 static void __task_rq_unlock(struct rq *rq)
 	__releases(rq->lock)
 {
-	raw_spin_unlock(&rq->lock);
+	rq_unlock(rq);
 }
 
 static inline void
@@ -363,7 +383,7 @@ task_rq_unlock(struct rq *rq, struct tas
 	__releases(rq->lock)
 	__releases(p->pi_lock)
 {
-	raw_spin_unlock(&rq->lock);
+	rq_unlock(rq);
 	raw_spin_unlock_irqrestore(&p->pi_lock, *flags);
 }
 
@@ -377,7 +397,7 @@ static struct rq *this_rq_lock(void)
 
 	local_irq_disable();
 	rq = this_rq();
-	raw_spin_lock(&rq->lock);
+	rq_lock(rq);
 
 	return rq;
 }
@@ -403,10 +423,10 @@ static enum hrtimer_restart hrtick(struc
 
 	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
 
-	raw_spin_lock(&rq->lock);
+	rq_lock(rq);
 	update_rq_clock(rq);
 	rq->curr->sched_class->task_tick(rq, rq->curr, 1);
-	raw_spin_unlock(&rq->lock);
+	rq_unlock(rq);
 
 	return HRTIMER_NORESTART;
 }
@@ -428,10 +448,10 @@ static void __hrtick_start(void *arg)
 {
 	struct rq *rq = arg;
 
-	raw_spin_lock(&rq->lock);
+	rq_lock(rq);
 	__hrtick_restart(rq);
 	rq->hrtick_csd_pending = 0;
-	raw_spin_unlock(&rq->lock);
+	rq_unlock(rq);
 }
 
 /*
@@ -565,7 +585,7 @@ void resched_task(struct task_struct *p)
 {
 	int cpu;
 
-	lockdep_assert_held(&task_rq(p)->lock);
+	lockdep_assert_held(&task_rq(p)->__lock);
 
 	if (test_tsk_need_resched(p))
 		return;
@@ -587,10 +607,10 @@ void resched_cpu(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	if (!raw_spin_trylock_irqsave(&rq->lock, flags))
+	if (!raw_spin_trylock_irqsave(&rq->__lock, flags))
 		return;
 	resched_task(cpu_curr(cpu));
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->__lock, flags);
 }
 
 #ifdef CONFIG_SMP
@@ -893,7 +913,7 @@ static void update_rq_clock_task(struct
 	}
 #endif
 
-	rq->clock_task += delta;
+	rq->__clock_task += delta;
 
 #if defined(CONFIG_IRQ_TIME_ACCOUNTING) || defined(CONFIG_PARAVIRT_TIME_ACCOUNTING)
 	if ((irq_delta + steal) && sched_feat(NONTASK_POWER))
@@ -1023,8 +1043,10 @@ void check_preempt_curr(struct rq *rq, s
 	 * A queue event has occurred, and we're going to schedule.  In
 	 * this case, we can save a useless back to back clock update.
 	 */
-	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr))
+	if (rq->curr->on_rq && test_tsk_need_resched(rq->curr)) {
+		trace_printk("skip_clock_update on cpu: %d\n", rq->cpu);
 		rq->skip_clock_update = 1;
+	}
 }
 
 #ifdef CONFIG_SMP
@@ -1535,7 +1557,7 @@ static void sched_ttwu_pending(void)
 	struct llist_node *llist = llist_del_all(&rq->wake_list);
 	struct task_struct *p;
 
-	raw_spin_lock(&rq->lock);
+	rq_lock(rq);
 
 	while (llist) {
 		p = llist_entry(llist, struct task_struct, wake_entry);
@@ -1543,7 +1565,7 @@ static void sched_ttwu_pending(void)
 		ttwu_do_activate(rq, p, 0);
 	}
 
-	raw_spin_unlock(&rq->lock);
+	rq_unlock(rq);
 }
 
 void scheduler_ipi(void)
@@ -1611,9 +1633,9 @@ static void ttwu_queue(struct task_struc
 	}
 #endif
 
-	raw_spin_lock(&rq->lock);
+	rq_lock(rq);
 	ttwu_do_activate(rq, p, 0);
-	raw_spin_unlock(&rq->lock);
+	rq_unlock(rq);
 }
 
 /**
@@ -1704,12 +1726,12 @@ static void try_to_wake_up_local(struct
 	    WARN_ON_ONCE(p == current))
 		return;
 
-	lockdep_assert_held(&rq->lock);
+	lockdep_assert_held(&rq->__lock);
 
 	if (!raw_spin_trylock(&p->pi_lock)) {
-		raw_spin_unlock(&rq->lock);
+		raw_spin_unlock(&rq->__lock);
 		raw_spin_lock(&p->pi_lock);
-		raw_spin_lock(&rq->lock);
+		raw_spin_lock(&rq->__lock);
 	}
 
 	if (!(p->state & TASK_NORMAL))
@@ -2226,10 +2248,12 @@ static inline void post_schedule(struct
 	if (rq->post_schedule) {
 		unsigned long flags;
 
-		raw_spin_lock_irqsave(&rq->lock, flags);
+		local_irq_save(flags);
+		rq_lock(rq);
 		if (rq->curr->sched_class->post_schedule)
 			rq->curr->sched_class->post_schedule(rq);
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		rq_unlock(rq);
+		local_irq_restore(flags);
 
 		rq->post_schedule = 0;
 	}
@@ -2479,11 +2503,11 @@ void scheduler_tick(void)
 
 	sched_clock_tick();
 
-	raw_spin_lock(&rq->lock);
+	rq_lock(rq);
 	update_rq_clock(rq);
 	curr->sched_class->task_tick(rq, curr, 0);
 	update_cpu_load_active(rq);
-	raw_spin_unlock(&rq->lock);
+	rq_unlock(rq);
 
 	perf_event_task_tick();
 
@@ -2732,7 +2756,8 @@ static void __sched __schedule(void)
 	 * done by the caller to avoid the race with signal_wake_up().
 	 */
 	smp_mb__before_spinlock();
-	raw_spin_lock_irq(&rq->lock);
+	local_irq_disable();
+	rq_lock(rq);
 
 	switch_count = &prev->nivcsw;
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
@@ -2780,8 +2805,10 @@ static void __sched __schedule(void)
 		 */
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
-	} else
-		raw_spin_unlock_irq(&rq->lock);
+	} else {
+		rq_unlock(rq);
+		local_irq_enable();
+	}
 
 	post_schedule(rq);
 
@@ -4106,9 +4133,8 @@ SYSCALL_DEFINE0(sched_yield)
 	 * Since we are going to call schedule() anyway, there's
 	 * no need to preempt or enable interrupts:
 	 */
-	__release(rq->lock);
-	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
-	do_raw_spin_unlock(&rq->lock);
+	preempt_disable();
+	rq_unlock(rq);
 	sched_preempt_enable_no_resched();
 
 	schedule();
@@ -4510,7 +4536,8 @@ void init_idle(struct task_struct *idle,
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
+	local_irq_save(flags);
+	rq_lock(rq);
 
 	__sched_fork(0, idle);
 	idle->state = TASK_RUNNING;
@@ -4536,7 +4563,8 @@ void init_idle(struct task_struct *idle,
 #if defined(CONFIG_SMP)
 	idle->on_cpu = 1;
 #endif
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rq_unlock(rq);
+	local_irq_restore(flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
 	init_idle_preempt_count(idle, cpu);
@@ -4835,11 +4863,11 @@ static void migrate_tasks(unsigned int d
 
 		/* Find suitable destination for @next, with force if needed. */
 		dest_cpu = select_fallback_rq(dead_cpu, next);
-		raw_spin_unlock(&rq->lock);
+		rq_unlock(rq);
 
 		__migrate_task(next, dead_cpu, dest_cpu);
 
-		raw_spin_lock(&rq->lock);
+		rq_lock(rq);
 	}
 
 	rq->stop = stop;
@@ -5100,27 +5128,31 @@ migration_call(struct notifier_block *nf
 
 	case CPU_ONLINE:
 		/* Update our root-domain */
-		raw_spin_lock_irqsave(&rq->lock, flags);
+		local_irq_save(flags);
+		rq_lock(rq);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 
 			set_rq_online(rq);
 		}
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		rq_unlock(rq);
+		local_irq_restore(flags);
 		break;
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
 		sched_ttwu_pending();
 		/* Update our root-domain */
-		raw_spin_lock_irqsave(&rq->lock, flags);
+		local_irq_save(flags);
+		rq_lock(rq);
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 			set_rq_offline(rq);
 		}
 		migrate_tasks(cpu);
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
+		rq_unlock(rq);
+		local_irq_restore(flags);
 		break;
 
 	case CPU_DEAD:
@@ -5427,7 +5459,8 @@ static void rq_attach_root(struct rq *rq
 	struct root_domain *old_rd = NULL;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
+	local_irq_save(flags);
+	rq_lock(rq);
 
 	if (rq->rd) {
 		old_rd = rq->rd;
@@ -5453,7 +5486,8 @@ static void rq_attach_root(struct rq *rq
 	if (cpumask_test_cpu(rq->cpu, cpu_active_mask))
 		set_rq_online(rq);
 
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rq_unlock(rq);
+	local_irq_restore(flags);
 
 	if (old_rd)
 		call_rcu_sched(&old_rd->rcu, free_rootdomain);
@@ -6931,7 +6965,7 @@ void __init sched_init(void)
 		struct rq *rq;
 
 		rq = cpu_rq(i);
-		raw_spin_lock_init(&rq->lock);
+		raw_spin_lock_init(&rq->__lock);
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
 		rq->calc_load_update = jiffies + LOAD_FREQ;
@@ -7842,13 +7876,13 @@ static int tg_set_cfs_bandwidth(struct t
 		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
 		struct rq *rq = cfs_rq->rq;
 
-		raw_spin_lock_irq(&rq->lock);
+		raw_spin_lock_irq(&rq->__lock);
 		cfs_rq->runtime_enabled = runtime_enabled;
 		cfs_rq->runtime_remaining = 0;
 
 		if (cfs_rq->throttled)
 			unthrottle_cfs_rq(cfs_rq);
-		raw_spin_unlock_irq(&rq->lock);
+		raw_spin_unlock_irq(&rq->__lock);
 	}
 	if (runtime_was_enabled && !runtime_enabled)
 		cfs_bandwidth_usage_dec();
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -511,11 +511,11 @@ static enum hrtimer_restart dl_task_time
 	struct rq *rq;
 again:
 	rq = task_rq(p);
-	raw_spin_lock(&rq->lock);
+	rq_lock(rq);
 
 	if (rq != task_rq(p)) {
 		/* Task was moved, retrying. */
-		raw_spin_unlock(&rq->lock);
+		rq_unlock(rq);
 		goto again;
 	}
 
@@ -548,7 +548,7 @@ static enum hrtimer_restart dl_task_time
 #endif
 	}
 unlock:
-	raw_spin_unlock(&rq->lock);
+	rq_unlock(rq);
 
 	return HRTIMER_NORESTART;
 }
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -187,7 +187,7 @@ void print_cfs_rq(struct seq_file *m, in
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
 			SPLIT_NS(cfs_rq->exec_clock));
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->__lock, flags);
 	if (cfs_rq->rb_leftmost)
 		MIN_vruntime = (__pick_first_entity(cfs_rq))->vruntime;
 	last = __pick_last_entity(cfs_rq);
@@ -195,7 +195,7 @@ void print_cfs_rq(struct seq_file *m, in
 		max_vruntime = last->vruntime;
 	min_vruntime = cfs_rq->min_vruntime;
 	rq0_min_vruntime = cpu_rq(0)->cfs.min_vruntime;
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->__lock, flags);
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "MIN_vruntime",
 			SPLIT_NS(MIN_vruntime));
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "min_vruntime",
@@ -301,7 +301,8 @@ do {									\
 	P(nr_uninterruptible);
 	PN(next_balance);
 	SEQ_printf(m, "  .%-30s: %ld\n", "curr->pid", (long)(task_pid_nr(rq->curr)));
-	PN(clock);
+	PN(__clock);
+	PN(__clock_task);
 	P(cpu_load[0]);
 	P(cpu_load[1]);
 	P(cpu_load[2]);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3421,7 +3421,7 @@ static u64 distribute_cfs_runtime(struct
 				throttled_list) {
 		struct rq *rq = rq_of(cfs_rq);
 
-		raw_spin_lock(&rq->lock);
+		raw_spin_lock(&rq->__lock);
 		if (!cfs_rq_throttled(cfs_rq))
 			goto next;
 
@@ -3438,7 +3438,7 @@ static u64 distribute_cfs_runtime(struct
 			unthrottle_cfs_rq(cfs_rq);
 
 next:
-		raw_spin_unlock(&rq->lock);
+		raw_spin_unlock(&rq->__lock);
 
 		if (!remaining)
 			break;
@@ -4901,7 +4901,8 @@ static void yield_task_fair(struct rq *r
 		 * so we don't do microscopic update in schedule()
 		 * and double the fastpath cost.
 		 */
-		 rq->skip_clock_update = 1;
+		trace_printk("skip_clock_update on cpu: %d\n", rq->cpu);
+		rq->skip_clock_update = 1;
 	}
 
 	set_skip_buddy(se);
@@ -5446,7 +5447,8 @@ static void update_blocked_averages(int
 	struct cfs_rq *cfs_rq;
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
+	local_irq_save(flags);
+	rq_lock(rq);
 	update_rq_clock(rq);
 	/*
 	 * Iterates the task_group tree in a bottom up fashion, see
@@ -5461,7 +5463,8 @@ static void update_blocked_averages(int
 		__update_blocked_averages_cpu(cfs_rq->tg, rq->cpu);
 	}
 
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rq_unlock(rq);
+	local_irq_restore(flags);
 }
 
 /*
@@ -6641,7 +6644,7 @@ static int load_balance(int this_cpu, st
 			sd->nr_balance_failed++;
 
 		if (need_active_balance(&env)) {
-			raw_spin_lock_irqsave(&busiest->lock, flags);
+			raw_spin_lock_irqsave(&busiest->__lock, flags);
 
 			/* don't kick the active_load_balance_cpu_stop,
 			 * if the curr task on busiest cpu can't be
@@ -6649,7 +6652,7 @@ static int load_balance(int this_cpu, st
 			 */
 			if (!cpumask_test_cpu(this_cpu,
 					tsk_cpus_allowed(busiest->curr))) {
-				raw_spin_unlock_irqrestore(&busiest->lock,
+				raw_spin_unlock_irqrestore(&busiest->__lock,
 							    flags);
 				env.flags |= LBF_ALL_PINNED;
 				goto out_one_pinned;
@@ -6665,7 +6668,7 @@ static int load_balance(int this_cpu, st
 				busiest->push_cpu = this_cpu;
 				active_balance = 1;
 			}
-			raw_spin_unlock_irqrestore(&busiest->lock, flags);
+			raw_spin_unlock_irqrestore(&busiest->__lock, flags);
 
 			if (active_balance) {
 				stop_one_cpu_nowait(cpu_of(busiest),
@@ -6775,7 +6778,7 @@ static int idle_balance(struct rq *this_
 	/*
 	 * Drop the rq->lock, but keep IRQ/preempt disabled.
 	 */
-	raw_spin_unlock(&this_rq->lock);
+	raw_spin_unlock(&this_rq->__lock);
 
 	update_blocked_averages(this_cpu);
 	rcu_read_lock();
@@ -6816,7 +6819,7 @@ static int idle_balance(struct rq *this_
 	}
 	rcu_read_unlock();
 
-	raw_spin_lock(&this_rq->lock);
+	raw_spin_lock(&this_rq->__lock);
 
 	if (curr_cost > this_rq->max_idle_balance_cost)
 		this_rq->max_idle_balance_cost = curr_cost;
@@ -6860,7 +6863,7 @@ static int active_load_balance_cpu_stop(
 	struct rq *target_rq = cpu_rq(target_cpu);
 	struct sched_domain *sd;
 
-	raw_spin_lock_irq(&busiest_rq->lock);
+	raw_spin_lock_irq(&busiest_rq->__lock);
 
 	/* make sure the requested cpu hasn't gone down in the meantime */
 	if (unlikely(busiest_cpu != smp_processor_id() ||
@@ -6910,7 +6913,7 @@ static int active_load_balance_cpu_stop(
 	double_unlock_balance(busiest_rq, target_rq);
 out_unlock:
 	busiest_rq->active_balance = 0;
-	raw_spin_unlock_irq(&busiest_rq->lock);
+	raw_spin_unlock_irq(&busiest_rq->__lock);
 	return 0;
 }
 
@@ -7192,10 +7195,12 @@ static void nohz_idle_balance(struct rq
 
 		rq = cpu_rq(balance_cpu);
 
-		raw_spin_lock_irq(&rq->lock);
+		local_irq_disable();
+		rq_lock(rq);
 		update_rq_clock(rq);
 		update_idle_cpu_load(rq);
-		raw_spin_unlock_irq(&rq->lock);
+		rq_unlock(rq);
+		local_irq_enable();
 
 		rebalance_domains(rq, CPU_IDLE);
 
@@ -7359,7 +7364,8 @@ static void task_fork_fair(struct task_s
 	struct rq *rq = this_rq();
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
+	local_irq_save(flags);
+	rq_lock(rq);
 
 	update_rq_clock(rq);
 
@@ -7393,7 +7399,8 @@ static void task_fork_fair(struct task_s
 
 	se->vruntime -= cfs_rq->min_vruntime;
 
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	rq_unlock(rq);
+	local_irq_restore(flags);
 }
 
 /*
@@ -7634,9 +7641,9 @@ void unregister_fair_sched_group(struct
 	if (!tg->cfs_rq[cpu]->on_list)
 		return;
 
-	raw_spin_lock_irqsave(&rq->lock, flags);
+	raw_spin_lock_irqsave(&rq->__lock, flags);
 	list_del_leaf_cfs_rq(tg->cfs_rq[cpu]);
-	raw_spin_unlock_irqrestore(&rq->lock, flags);
+	raw_spin_unlock_irqrestore(&rq->__lock, flags);
 }
 
 void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
@@ -7696,13 +7703,16 @@ int sched_group_set_shares(struct task_g
 
 		se = tg->se[i];
 		/* Propagate contribution to hierarchy */
-		raw_spin_lock_irqsave(&rq->lock, flags);
+		local_irq_save(flags);
+		rq_lock(rq);
 
 		/* Possible calls to update_curr() need rq clock */
 		update_rq_clock(rq);
 		for_each_sched_entity(se)
 			update_cfs_shares(group_cfs_rq(se));
-		raw_spin_unlock_irqrestore(&rq->lock, flags);
+
+		rq_unlock(rq);
+		local_irq_restore(flags);
 	}
 
 done:
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -39,10 +39,10 @@ pick_next_task_idle(struct rq *rq, struc
 static void
 dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
 {
-	raw_spin_unlock_irq(&rq->lock);
+	raw_spin_unlock_irq(&rq->__lock);
 	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
 	dump_stack();
-	raw_spin_lock_irq(&rq->lock);
+	raw_spin_lock_irq(&rq->__lock);
 }
 
 static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -561,7 +561,7 @@ void update_cpu_load_nohz(void)
 	if (curr_jiffies == this_rq->last_load_update_tick)
 		return;
 
-	raw_spin_lock(&this_rq->lock);
+	raw_spin_lock(&this_rq->__lock);
 	pending_updates = curr_jiffies - this_rq->last_load_update_tick;
 	if (pending_updates) {
 		this_rq->last_load_update_tick = curr_jiffies;
@@ -571,7 +571,7 @@ void update_cpu_load_nohz(void)
 		 */
 		__update_cpu_load(this_rq, 0, pending_updates);
 	}
-	raw_spin_unlock(&this_rq->lock);
+	raw_spin_unlock(&this_rq->__lock);
 }
 #endif /* CONFIG_NO_HZ */
 
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -813,7 +813,7 @@ static int do_sched_rt_period_timer(stru
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
 		struct rq *rq = rq_of_rt_rq(rt_rq);
 
-		raw_spin_lock(&rq->lock);
+		rq_lock(rq);
 		if (rt_rq->rt_time) {
 			u64 runtime;
 
@@ -846,7 +846,7 @@ static int do_sched_rt_period_timer(stru
 
 		if (enqueue)
 			sched_rt_rq_enqueue(rt_rq);
-		raw_spin_unlock(&rq->lock);
+		rq_unlock(rq);
 	}
 
 	if (!throttled && (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF))
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -507,7 +507,7 @@ extern struct root_domain def_root_domai
  */
 struct rq {
 	/* runqueue lock: */
-	raw_spinlock_t lock;
+	raw_spinlock_t __lock;
 
 	/*
 	 * nr_running and cpu_load should be in the same cacheline because
@@ -528,7 +528,6 @@ struct rq {
 #ifdef CONFIG_NO_HZ_FULL
 	unsigned long last_sched_tick;
 #endif
-	int skip_clock_update;
 
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
@@ -558,8 +557,11 @@ struct rq {
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
 
-	u64 clock;
-	u64 clock_task;
+	unsigned int clock_seq;
+	unsigned int clock_stamp;
+	int skip_clock_update;
+	u64 __clock;
+	u64 __clock_task;
 
 	atomic_t nr_iowait;
 
@@ -635,6 +637,24 @@ struct rq {
 #endif
 };
 
+static inline void rq_lock(struct rq *rq)
+{
+	raw_spin_lock(&rq->__lock);
+#ifdef CONFIG_SCHED_DEBUG_CLOCK
+	rq->clock_seq++;
+	barrier();
+#endif
+}
+
+static inline void rq_unlock(struct rq *rq)
+{
+#ifdef CONFIG_SCHED_DEBUG_CLOCK
+	barrier();
+	rq->clock_seq++;
+#endif
+	raw_spin_unlock(&rq->__lock);
+}
+
 static inline int cpu_of(struct rq *rq)
 {
 #ifdef CONFIG_SMP
@@ -654,12 +674,26 @@ DECLARE_PER_CPU(struct rq, runqueues);
 
 static inline u64 rq_clock(struct rq *rq)
 {
-	return rq->clock;
+#ifdef CONFIG_SCHED_DEBUG_CLOCK
+	if (rq->clock_stamp != rq->clock_seq) {
+		trace_printk("reading invalid rq->clock: %u != %u\n",
+				rq->clock_stamp, rq->clock_seq);
+	}
+#endif
+
+	return rq->__clock;
 }
 
 static inline u64 rq_clock_task(struct rq *rq)
 {
-	return rq->clock_task;
+#ifdef CONFIG_SCHED_DEBUG_CLOCK
+	if (rq->clock_stamp != rq->clock_seq) {
+		trace_printk("reading invalid rq->clock_task: %u != %u\n",
+				rq->clock_stamp, rq->clock_seq);
+	}
+#endif
+
+	return rq->__clock_task;
 }
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -980,16 +1014,17 @@ static inline void finish_lock_switch(st
 #endif
 #ifdef CONFIG_DEBUG_SPINLOCK
 	/* this is a valid case when another task releases the spinlock */
-	rq->lock.owner = current;
+	rq->__lock.owner = current;
 #endif
 	/*
 	 * If we are tracking spinlock dependencies then we have to
 	 * fix up the runqueue lock - which gets 'carried over' from
 	 * prev into current:
 	 */
-	spin_acquire(&rq->lock.dep_map, 0, 0, _THIS_IP_);
+	spin_acquire(&rq->__lock.dep_map, 0, 0, _THIS_IP_);
 
-	raw_spin_unlock_irq(&rq->lock);
+	rq_unlock(rq);
+	local_irq_enable();
 }
 
 #else /* __ARCH_WANT_UNLOCKED_CTXSW */
@@ -1003,7 +1038,7 @@ static inline void prepare_lock_switch(s
 	 */
 	next->on_cpu = 1;
 #endif
-	raw_spin_unlock(&rq->lock);
+	rq_unlock(rq);
 }
 
 static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
@@ -1305,12 +1340,12 @@ static inline void double_rq_lock(struct
  * reduces latency compared to the unfair variant below.  However, it
  * also adds more overhead and therefore may reduce throughput.
  */
-static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
+static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(this_rq->lock)
 	__acquires(busiest->lock)
 	__acquires(this_rq->lock)
 {
-	raw_spin_unlock(&this_rq->lock);
+	raw_spin_unlock(&this_rq->__lock);
 	double_rq_lock(this_rq, busiest);
 
 	return 1;
@@ -1324,22 +1359,22 @@ static inline int _double_lock_balance(s
  * grant the double lock to lower cpus over higher ids under contention,
  * regardless of entry order into the function.
  */
-static inline int _double_lock_balance(struct rq *this_rq, struct rq *busiest)
+static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(this_rq->lock)
 	__acquires(busiest->lock)
 	__acquires(this_rq->lock)
 {
 	int ret = 0;
 
-	if (unlikely(!raw_spin_trylock(&busiest->lock))) {
+	if (unlikely(!raw_spin_trylock(&busiest->__lock))) {
 		if (busiest < this_rq) {
-			raw_spin_unlock(&this_rq->lock);
-			raw_spin_lock(&busiest->lock);
-			raw_spin_lock_nested(&this_rq->lock,
+			raw_spin_unlock(&this_rq->__lock);
+			raw_spin_lock(&busiest->__lock);
+			raw_spin_lock_nested(&this_rq->__lock,
 					      SINGLE_DEPTH_NESTING);
 			ret = 1;
 		} else
-			raw_spin_lock_nested(&busiest->lock,
+			raw_spin_lock_nested(&busiest->__lock,
 					      SINGLE_DEPTH_NESTING);
 	}
 	return ret;
@@ -1347,25 +1382,11 @@ static inline int _double_lock_balance(s
 
 #endif /* CONFIG_PREEMPT */
 
-/*
- * double_lock_balance - lock the busiest runqueue, this_rq is locked already.
- */
-static inline int double_lock_balance(struct rq *this_rq, struct rq *busiest)
-{
-	if (unlikely(!irqs_disabled())) {
-		/* printk() doesn't work good under rq->lock */
-		raw_spin_unlock(&this_rq->lock);
-		BUG_ON(1);
-	}
-
-	return _double_lock_balance(this_rq, busiest);
-}
-
 static inline void double_unlock_balance(struct rq *this_rq, struct rq *busiest)
 	__releases(busiest->lock)
 {
-	raw_spin_unlock(&busiest->lock);
-	lock_set_subclass(&this_rq->lock.dep_map, 0, _RET_IP_);
+	raw_spin_unlock(&busiest->__lock);
+	lock_set_subclass(&this_rq->__lock.dep_map, 0, _RET_IP_);
 }
 
 static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
@@ -1407,15 +1428,15 @@ static inline void double_rq_lock(struct
 {
 	BUG_ON(!irqs_disabled());
 	if (rq1 == rq2) {
-		raw_spin_lock(&rq1->lock);
+		raw_spin_lock(&rq1->__lock);
 		__acquire(rq2->lock);	/* Fake it out ;) */
 	} else {
 		if (rq1 < rq2) {
-			raw_spin_lock(&rq1->lock);
-			raw_spin_lock_nested(&rq2->lock, SINGLE_DEPTH_NESTING);
+			raw_spin_lock(&rq1->__lock);
+			raw_spin_lock_nested(&rq2->__lock, SINGLE_DEPTH_NESTING);
 		} else {
-			raw_spin_lock(&rq2->lock);
-			raw_spin_lock_nested(&rq1->lock, SINGLE_DEPTH_NESTING);
+			raw_spin_lock(&rq2->__lock);
+			raw_spin_lock_nested(&rq1->__lock, SINGLE_DEPTH_NESTING);
 		}
 	}
 }
@@ -1430,9 +1451,9 @@ static inline void double_rq_unlock(stru
 	__releases(rq1->lock)
 	__releases(rq2->lock)
 {
-	raw_spin_unlock(&rq1->lock);
+	raw_spin_unlock(&rq1->__lock);
 	if (rq1 != rq2)
-		raw_spin_unlock(&rq2->lock);
+		raw_spin_unlock(&rq2->__lock);
 	else
 		__release(rq2->lock);
 }
@@ -1451,7 +1472,7 @@ static inline void double_rq_lock(struct
 {
 	BUG_ON(!irqs_disabled());
 	BUG_ON(rq1 != rq2);
-	raw_spin_lock(&rq1->lock);
+	raw_spin_lock(&rq1->__lock);
 	__acquire(rq2->lock);	/* Fake it out ;) */
 }
 
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -788,6 +788,13 @@ config SCHED_DEBUG
 	  that can help debug the scheduler. The runtime overhead of this
 	  option is minimal.
 
+config SCHED_DEBUG_CLOCK
+	bool "Debug rq clock"
+	depends on SCHED_DEBUG
+	default n
+	help
+	  If you say Y here the ftrace output contains debug muck for rq->clock
+
 config SCHEDSTATS
 	bool "Collect scheduler statistics"
 	depends on DEBUG_KERNEL && PROC_FS


