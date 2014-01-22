Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbaAVL7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:59:53 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53219 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaAVL7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:59:51 -0500
Date: Wed, 22 Jan 2014 12:59:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        dyoung@redhat.com
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140122115918.GG3694@twins.programming.kicks-ass.net>
References: <20131212140835.729222186@infradead.org>
 <20131212141655.362219382@infradead.org>
 <52DEF495.2020304@oracle.com>
 <20140122104532.GJ31570@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122104532.GJ31570@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 11:45:32AM +0100, Peter Zijlstra wrote:
> Ho humm.

OK, so I had me a ponder; does the below fix things for you and David?
I've only done a boot test on real proper hardware :-)

---
 kernel/sched/clock.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index 6bd6a6731b21..6bbcd97f4532 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -77,35 +77,45 @@ __read_mostly int sched_clock_running;
 
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
 
 void set_sched_clock_stable(void)
 {
+	__sched_clock_stable_early = 1;
+
+	smp_mb(); /* matches sched_clock_init() */
+
+	if (!sched_clock_running)
+		return;
+
 	if (!sched_clock_stable())
-		static_key_slow_dec(&__sched_clock_stable);
+		static_key_slow_inc(&__sched_clock_stable);
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
@@ -140,6 +150,20 @@ void sched_clock_init(void)
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
+		set_sched_clock_stable();
+	else
+		clear_sched_clock_stable();
 }
 
 /*
