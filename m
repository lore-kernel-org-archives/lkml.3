Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3CSFPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:15:12 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:65288 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3CSFPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:15:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAFTL4hwyaDYx6d3V=oFxu-iQDFOAA22GPJbH5wG8v6_G_AeNnw@mail.gmail.com>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<9f0fd16f792b9f9b399a4c91c98de37c56067d47.1363617402.git.viresh.kumar@linaro.org>
	<CAFTL4hxJUnnBvHNty1FgxbBGOrrPPNotJGaE03B8s_t1Lx5vRw@mail.gmail.com>
	<CAKohpokB3yeXuLVe_0fWuMRVMKWJktDU7UrMepfd+3N0GmNtMw@mail.gmail.com>
	<CAFTL4hwyaDYx6d3V=oFxu-iQDFOAA22GPJbH5wG8v6_G_AeNnw@mail.gmail.com>
Date: Tue, 19 Mar 2013 10:45:07 +0530
Message-ID: <CAKohpom9gJEucMAdOOF0R5rf2T915MasVkZm18XRqRHuzKbJYg@mail.gmail.com>
Subject: Re: [PATCH V3 1/7] sched: Create sched_select_cpu() to give preferred
 CPU for power saving
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 March 2013 21:27, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/3/18 Viresh Kumar <viresh.kumar@linaro.org>:
>>> It would be nice to have some more precise naming. sched_select_busy_cpu() ?
>>
>> You are correct that name can be improved but busy may give it a different
>> meaning. Maybe sched_select_non_idle_cpu()?
>
> That works too yeah.

Here is the fixup that i applied (it fixes another stupid mistake in sched.h).
I have pushed this series here again:

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/sched-wq-migration-v3

commit e769ff0d78fd2fb504ae056a44b70bba7c259126
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Sep 14 15:13:05 2012 +0530

    fixup! sched: Create sched_select_cpu() to give preferred CPU for
power saving

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/sched.h | 19 ++++++++++---------
 kernel/sched/core.c   |  2 +-
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 216fa0d..db6655a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -231,11 +231,18 @@ extern void init_idle_bootup_task(struct
task_struct *idle);
 extern int runqueue_is_locked(int cpu);

 #ifdef CONFIG_SMP
-extern int sched_select_cpu(unsigned int sd_flags);
+extern int sched_select_non_idle_cpu(unsigned int sd_flags);
+#else
+static inline int sched_select_non_idle_cpu(unsigned int sd_flags)
+{
+       return smp_processor_id();
+}
+#endif

-#ifdef CONFIG_NO_HZ
+#if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern void nohz_balance_enter_idle(int cpu);
 extern void set_cpu_sd_state_idle(void);
+
 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
  * from an idle cpu.  This is good for power-savings.
@@ -244,17 +251,11 @@ extern void set_cpu_sd_state_idle(void);
  * selecting an idle cpu will add more delays to the timers than intended
  * (as that cpu's timer base may not be uptodate wrt jiffies etc).
  */
-#define get_nohz_timer_target() sched_select_cpu(0)
+#define get_nohz_timer_target() sched_select_non_idle_cpu(0)
 #else
 static inline void nohz_balance_enter_idle(int cpu) { }
 static inline void set_cpu_sd_state_idle(void) { }
-
-static inline int sched_select_cpu(unsigned int sd_flags)
-{
-       return raw_smp_processor_id();
-}
 #endif
-#endif /* CONFIG_SMP */

 /*
  * Only dump TASK_* tasks. (0 for all tasks)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ccd76d7..0265a5e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -627,7 +627,7 @@ void sched_avg_update(struct rq *rq)
  * returned back. If it is idle, then we must look for another CPU which have
  * all the flags passed as argument as set.
  */
-int sched_select_cpu(unsigned int sd_flags)
+int sched_select_non_idle_cpu(unsigned int sd_flags)
 {
        struct sched_domain *sd;
        int cpu = smp_processor_id();
