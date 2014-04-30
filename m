Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbaD3KSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:18:48 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11080 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaD3KSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:18:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 30 Apr 2014 03:09:23 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Sai Gurrappadi <sgurrappadi@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] tick: Don't clear idle and iowait sums on CPU down
Date: Wed, 30 Apr 2014 13:18:34 +0300
Message-ID: <1398853114-27544-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sai Gurrappadi <sgurrappadi@nvidia.com>

NOHZ related per-cpu data is cleared on CPU down. This was introduced by
4b0c0f294 "tick: Cleanup NOHZ per cpu data on cpu down" which breaks
/proc/stats because the idle and iowait sums are now non-monotonic
across a CPU down/up cycle.

Fix this by not clearing the idle_sleeptime and iowait_sleeptime fields
on CPU down.

Signed-off-by: Sai Gurrappadi <sgurrappadi@nvidia.com>
Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 kernel/time/tick-sched.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index c12c006..2cd27ec 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1164,6 +1164,17 @@ void tick_setup_sched_timer(void)
 #endif /* HIGH_RES_TIMERS */
 
 #if defined CONFIG_NO_HZ_COMMON || defined CONFIG_HIGH_RES_TIMERS
+
+static inline void clear_tick_sched(struct tick_sched *ts)
+{
+	ktime_t idle_sleeptime = ts->idle_sleeptime;
+	ktime_t iowait_sleeptime = ts->iowait_sleeptime;
+
+	memset(ts, 0, sizeof(*ts));
+	ts->idle_sleeptime = idle_sleeptime;
+	ts->iowait_sleeptime = iowait_sleeptime;
+}
+
 void tick_cancel_sched_timer(int cpu)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
@@ -1173,7 +1184,7 @@ void tick_cancel_sched_timer(int cpu)
 		hrtimer_cancel(&ts->sched_timer);
 # endif
 
-	memset(ts, 0, sizeof(*ts));
+	clear_tick_sched(ts);
 }
 #endif
 
-- 
1.7.7.rc0.72.g4b5ea.dirty

