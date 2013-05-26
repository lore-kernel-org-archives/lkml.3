Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3EZVh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:37:56 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:50986 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:37:54 -0400
From: kosaki.motohiro@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Olivier Langlois <olivier@trillion01.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 8/8] posix-cpu-timers: fix cputimer initialization mistake for {u,s}time
Date: Sun, 26 May 2013 17:35:49 -0400
Message-Id: <1369604149-13016-11-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1369604149-13016-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

When using CPUCLOCK_VIRT or CPUCLOCK_PROF, we need to round an expire up
because jiffies based accounting may point to one jiffy behind at maximum.
So, current code lead to wake up posix timer too early.

This patch adds one jiffy at timer initialization. itimer already has a
similar trick and it match a userland assumption.

Luckily, CPUCLOCK_VIRT and CPUCLOCK_PROF posix timer are undocumented,
standard undefined, and no libc support. So maybe nobody uses them.
However, it still would be nice to fix if possible.

Cc: Olivier Langlois <olivier@trillion01.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/posix-cpu-timers.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 34bb3f1..42874c2 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -339,6 +339,18 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 	return do_cpu_clock_timer_sample(which_clock, p, true, false, cpu);
 }
 
+static union cpu_time_count cpu_clock_resolution(clockid_t cpuid)
+{
+	union cpu_time_count ret;
+
+	if (CPUCLOCK_WHICH(cpuid) == CPUCLOCK_SCHED)
+		ret.sched = 1;
+	else
+		ret.cpu = cputime_one_jiffy;
+
+	return ret;
+}
+
 static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 {
 	const pid_t pid = CPUCLOCK_PID(which_clock);
@@ -806,7 +818,15 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 			cpu_clock_sample(timer->it_clock, p, &now);
 		else
 			cpu_clock_sample_group(timer->it_clock, p, &now);
+
 		cpu_time_add(timer->it_clock, &new_expires, now);
+
+		/*
+		 * When inaccurate timer, we need to adjust an expire time
+		 * because "now" may point to slightly past time.
+		 */
+		cpu_time_add(timer->it_clock, &new_expires,
+			     cpu_clock_resolution(timer->it_clock));
 	}
 
 	/*
-- 
1.7.1

