Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaAWQrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:47:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55097 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbaAWQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:47:33 -0500
Date: Thu, 23 Jan 2014 08:46:46 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-d375b4e0fa3771343b370be0d876a1963c02e0a0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, arjan@linux.intel.com, peterz@infradead.org,
        bitbucket@online.de, john.stultz@linaro.org, luto@amacapital.net,
        eliezer.tamir@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        peterz@infradead.org, bitbucket@online.de, luto@amacapital.net,
        john.stultz@linaro.org, eliezer.tamir@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <20140122115918.GG3694@twins.programming.kicks-ass.net>
References: <20140122115918.GG3694@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/clock: Fixup early initialization
Git-Commit-ID: d375b4e0fa3771343b370be0d876a1963c02e0a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 23 Jan 2014 08:46:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d375b4e0fa3771343b370be0d876a1963c02e0a0
Gitweb:     http://git.kernel.org/tip/d375b4e0fa3771343b370be0d876a1963c02e0a0
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 22 Jan 2014 12:59:18 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 23 Jan 2014 14:48:36 +0100

sched/clock: Fixup early initialization

The code would assume sched_clock_stable() and switch to !stable
later, this switch brings a discontinuity in time.

The discontinuity on switching from stable to unstable was always
present, but previously we would set stable/unstable before
initializing TSC and usually stick to the one we start out with.

So the static_key bits brought an extra switch where there previously
wasn't one.

Things are further complicated by the fact that we cannot use
static_key as early as we usually call set_sched_clock_stable().

Fix things by tracking the stable state in a regular variable and only
set the static_key to the right state on sched_clock_init(), which is
ran right after late_time_init->tsc_init().

Before this we would not be using the TSC anyway.

Reported-and-Tested-by: Sasha Levin <sasha.levin@oracle.com>
Reported-by: dyoung@redhat.com
Fixes: 35af99e646c7 ("sched/clock, x86: Use a static_key for sched_clock_stable")
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: hpa@zytor.com
Cc: paulmck@linux.vnet.ibm.com
Cc: John Stultz <john.stultz@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: rui.zhang@intel.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140122115918.GG3694@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/clock.c | 53 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 6bd6a67..43c2bcc 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -77,35 +77,50 @@ __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 static struct static_key __sched_clock_stable = STATIC_KEY_INIT;
+static int __sched_clock_stable_early;
 
 int sched_clock_stable(void)
 {
-	if (static_key_false(&__sched_clock_stable))
-		return false;
-	return true;
+	return static_key_false(&__sched_clock_stable);
 }
 
-void set_sched_clock_stable(void)
+static void __set_sched_clock_stable(void)
 {
 	if (!sched_clock_stable())
-		static_key_slow_dec(&__sched_clock_stable);
+		static_key_slow_inc(&__sched_clock_stable);
+}
+
+void set_sched_clock_stable(void)
+{
+	__sched_clock_stable_early = 1;
+
+	smp_mb(); /* matches sched_clock_init() */
+
+	if (!sched_clock_running)
+		return;
+
+	__set_sched_clock_stable();
 }
 
 static void __clear_sched_clock_stable(struct work_struct *work)
 {
 	/* XXX worry about clock continuity */
 	if (sched_clock_stable())
-		static_key_slow_inc(&__sched_clock_stable);
+		static_key_slow_dec(&__sched_clock_stable);
 }
 
 static DECLARE_WORK(sched_clock_work, __clear_sched_clock_stable);
 
 void clear_sched_clock_stable(void)
 {
-	if (keventd_up())
-		schedule_work(&sched_clock_work);
-	else
-		__clear_sched_clock_stable(&sched_clock_work);
+	__sched_clock_stable_early = 0;
+
+	smp_mb(); /* matches sched_clock_init() */
+
+	if (!sched_clock_running)
+		return;
+
+	schedule_work(&sched_clock_work);
 }
 
 struct sched_clock_data {
@@ -140,6 +155,20 @@ void sched_clock_init(void)
 	}
 
 	sched_clock_running = 1;
+
+	/*
+	 * Ensure that it is impossible to not do a static_key update.
+	 *
+	 * Either {set,clear}_sched_clock_stable() must see sched_clock_running
+	 * and do the update, or we must see their __sched_clock_stable_early
+	 * and do the update, or both.
+	 */
+	smp_mb(); /* matches {set,clear}_sched_clock_stable() */
+
+	if (__sched_clock_stable_early)
+		__set_sched_clock_stable();
+	else
+		__clear_sched_clock_stable(NULL);
 }
 
 /*
@@ -340,7 +369,7 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeup_event);
  */
 u64 cpu_clock(int cpu)
 {
-	if (static_key_false(&__sched_clock_stable))
+	if (!sched_clock_stable())
 		return sched_clock_cpu(cpu);
 
 	return sched_clock();
@@ -355,7 +384,7 @@ u64 cpu_clock(int cpu)
  */
 u64 local_clock(void)
 {
-	if (static_key_false(&__sched_clock_stable))
+	if (!sched_clock_stable())
 		return sched_clock_cpu(raw_smp_processor_id());
 
 	return sched_clock();
