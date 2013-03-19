Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab3CSNW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:22:28 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:46972 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3CSNW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:22:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo===J9EeZXcDa2cmUifuwinSVnQsOs1u-cg==tfbs_-0Q@mail.gmail.com>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<9f0fd16f792b9f9b399a4c91c98de37c56067d47.1363617402.git.viresh.kumar@linaro.org>
	<1363696232.22553.37.camel@laptop>
	<CAKohpo===J9EeZXcDa2cmUifuwinSVnQsOs1u-cg==tfbs_-0Q@mail.gmail.com>
Date: Tue, 19 Mar 2013 18:52:26 +0530
Message-ID: <CAKohpomKKSBE-S1jTwh3Nr5ESOoN68kiK5BxRVHXqHX=-rDMSQ@mail.gmail.com>
Subject: Re: [PATCH V3 1/7] sched: Create sched_select_cpu() to give preferred
 CPU for power saving
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, rostedt@goodmis.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2013 18:22, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 19 March 2013 18:00, Peter Zijlstra <peterz@infradead.org> wrote:
>> Why not leave out the sd_flags argument and introduce it once you start
>> using it; at which point we can argue on the interface.
>
> Yes, that can be done. Will fix it up.

Fixup:

commit 77927939224520cbb0ac47270d3458bedffe42c4
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Tue Mar 19 18:50:37 2013 +0530

    fixup! sched: Create sched_select_non_idle_cpu() to give preferred
CPU for power saving
---
 include/linux/sched.h | 6 +++---
 kernel/sched/core.c   | 6 +-----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index db6655a..37eb1dd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -231,9 +231,9 @@ extern void init_idle_bootup_task(struct task_struct *idle);
 extern int runqueue_is_locked(int cpu);

 #ifdef CONFIG_SMP
-extern int sched_select_non_idle_cpu(unsigned int sd_flags);
+extern int sched_select_non_idle_cpu(void);
 #else
-static inline int sched_select_non_idle_cpu(unsigned int sd_flags)
+static inline int sched_select_non_idle_cpu(void)
 {
        return smp_processor_id();
 }
@@ -251,7 +251,7 @@ extern void set_cpu_sd_state_idle(void);
  * selecting an idle cpu will add more delays to the timers than intended
  * (as that cpu's timer base may not be uptodate wrt jiffies etc).
  */
-#define get_nohz_timer_target() sched_select_non_idle_cpu(0)
+#define get_nohz_timer_target() sched_select_non_idle_cpu()
 #else
 static inline void nohz_balance_enter_idle(int cpu) { }
 static inline void set_cpu_sd_state_idle(void) { }
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0265a5e..f597d2b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -627,7 +627,7 @@ void sched_avg_update(struct rq *rq)
  * returned back. If it is idle, then we must look for another CPU which have
  * all the flags passed as argument as set.
  */
-int sched_select_non_idle_cpu(unsigned int sd_flags)
+int sched_select_non_idle_cpu(void)
 {
        struct sched_domain *sd;
        int cpu = smp_processor_id();
@@ -639,10 +639,6 @@ int sched_select_non_idle_cpu(unsigned int sd_flags)

        rcu_read_lock();
        for_each_domain(cpu, sd) {
-                /* If sd doesnt' have sd_flags set skip sd. */
-               if ((sd->flags & sd_flags) != sd_flags)
-                       continue;
-
                for_each_cpu(i, sched_domain_span(sd)) {
                        if (i == cpu)
                                continue;
