Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbaDYT5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbaDYT5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:57:44 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 2/2] nohz: don't fetch per_cpu variable before we need it
Date: Fri, 25 Apr 2014 20:57:30 +0200
Message-Id: <1398452250-6047-2-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1398452250-6047-1-git-send-email-dvlasenk@redhat.com>
References: <1398452250-6047-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In get_cpu_{idle,iowait}_time_us, we were fetching
per_cpu(tick_cpu_sched, cpu) upfront. But them we do
        if (!tick_nohz_active)
                return -1;
which may make that fetch pointless.
Moving it further down, closer to the usage point.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/time/tick-sched.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index d78c942..4ffccd0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -476,7 +476,7 @@ void tick_nohz_iowait_to_idle(int cpu)
  */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts;
 	ktime_t now, idle;
 	unsigned int seq;
 
@@ -487,6 +487,8 @@ u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
+	ts = &per_cpu(tick_cpu_sched, cpu);
+
 	do {
 		ktime_t start, delta, iowait_exit;
 
@@ -531,7 +533,7 @@ EXPORT_SYMBOL_GPL(get_cpu_idle_time_us);
  */
 u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	struct tick_sched *ts;
 	ktime_t now, iowait;
 	unsigned int seq;
 
@@ -542,6 +544,8 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
+	ts = &per_cpu(tick_cpu_sched, cpu);
+
 	do {
 		ktime_t delta, end;
 
-- 
1.8.1.4

