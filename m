Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3CRPYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:24:21 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:49210 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3CRPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:24:19 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 2/7] timer: hrtimer: Don't check idle_cpu() before calling get_nohz_timer_target()
Date: Mon, 18 Mar 2013 20:53:24 +0530
Message-Id: <b5639020972e5321269d403c65e9b62ba8236bab.1363617402.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for current cpu's idleness is already done in implementation of
sched_select_cpu() which is called by get_nohz_timer_target(). So, no need to
call idle_cpu() twice, once from sched_select_cpu() and once from timer and
hrtimer before calling get_nohz_timer_target().

This patch removes calls to idle_cpu() from timer and hrtimer.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 2 +-
 kernel/timer.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cc47812..c56668d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -161,7 +161,7 @@ struct hrtimer_clock_base *lock_hrtimer_base(const struct hrtimer *timer,
 static int hrtimer_get_target(int this_cpu, int pinned)
 {
 #ifdef CONFIG_NO_HZ
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(this_cpu))
+	if (!pinned && get_sysctl_timer_migration())
 		return get_nohz_timer_target();
 #endif
 	return this_cpu;
diff --git a/kernel/timer.c b/kernel/timer.c
index dbf7a78..83a0d3c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -739,7 +739,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 	cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu))
+	if (!pinned && get_sysctl_timer_migration())
 		cpu = get_nohz_timer_target();
 #endif
 	new_base = per_cpu(tvec_bases, cpu);
-- 
1.7.12.rc2.18.g61b472e

