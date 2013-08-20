Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab3HTSVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:21:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab3HTSV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:21:29 -0400
Date: Tue, 20 Aug 2013 20:15:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH RESEND 0/4] nohz: Fix racy sleeptime stats
Message-ID: <20130820181500.GA22287@redhat.com>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it.

I do not also understand the cpu_online() checks in fs/proc/stat.c.

OK, I agree, if cpu is offline it should not participate in cpu
summary. But if it goes offline, why it should switch from
->iowait_sleeptime + cpustat[CPUTIME_IDLE] as it seen by /proc/stat?

This can be another source of "idle goes backward", no?

IOW. Ignoring the other problems we have, perhaps something like
below makes sense?

Oleg.

--- x/fs/proc/stat.c
+++ x/fs/proc/stat.c
@@ -45,10 +45,9 @@ static cputime64_t get_iowait_time(int c
 
 static u64 get_idle_time(int cpu)
 {
-	u64 idle, idle_time = -1ULL;
+	u64 idle, idle_time;
 
-	if (cpu_online(cpu))
-		idle_time = get_cpu_idle_time_us(cpu, NULL);
+	idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
@@ -61,10 +60,9 @@ static u64 get_idle_time(int cpu)
 
 static u64 get_iowait_time(int cpu)
 {
-	u64 iowait, iowait_time = -1ULL;
+	u64 iowait, iowait_time;
 
-	if (cpu_online(cpu))
-		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+	iowait_time = get_cpu_iowait_time_us(cpu, NULL);
 
 	if (iowait_time == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
--- x/kernel/time/tick-sched.c
+++ x/kernel/time/tick-sched.c
@@ -477,7 +477,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *l
 		update_ts_time_stats(cpu, ts, now, last_update_time);
 		idle = ts->idle_sleeptime;
 	} else {
-		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
+		if (ts->idle_active && cpu_online(cpu) && !nr_iowait_cpu(cpu)) {
 			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 
 			idle = ktime_add(ts->idle_sleeptime, delta);
@@ -518,7 +518,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64 
 		update_ts_time_stats(cpu, ts, now, last_update_time);
 		iowait = ts->iowait_sleeptime;
 	} else {
-		if (ts->idle_active && nr_iowait_cpu(cpu) > 0) {
+		if (ts->idle_active && cpu_online(cpu) && nr_iowait_cpu(cpu)) {
 			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
 
 			iowait = ktime_add(ts->iowait_sleeptime, delta);

