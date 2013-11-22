Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3KVGiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:38:07 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44321 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab3KVGiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:38:04 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
Cc: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/4] sched/nohz_full: give correct cpu load for nohz_full cpu
Date: Fri, 22 Nov 2013 14:37:15 +0800
Message-Id: <1385102235-25664-5-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385102235-25664-1-git-send-email-alex.shi@linaro.org>
References: <1385102235-25664-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a nohz_full cpu in tickless mode, it may update cpu_load in
following chain:
__tick_nohz_full_check
    tick_nohz_restart_sched_tick
        update_cpu_load_nohz
then it will be set a incorrect cpu_load: 0.
This patch try to fix it and give it the correct cpu_load value.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/proc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 057bb9b..5058e6a 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -477,10 +477,16 @@ void update_cpu_load_nohz(void)
 	if (pending_updates) {
 		this_rq->last_load_update_tick = curr_jiffies;
 		/*
-		 * We were idle, this means load 0, the current load might be
-		 * !0 due to remote wakeups and the sort.
+		 * We may has one task and in NO_HZ_FULL, then use normal
+		 * cfs load.
+		 * Or we were idle, this means load 0, the current load might
+		 * be !0 due to remote wakeups and the sort.
 		 */
-		__update_cpu_load(this_rq, 0);
+		if (this_rq->cfs.h_nr_running) {
+			unsigned load = get_rq_runnable_load(this_rq);
+			__update_cpu_load(this_rq, load);
+		} else
+			__update_cpu_load(this_rq, 0);
 	}
 	raw_spin_unlock(&this_rq->lock);
 }
-- 
1.8.1.2

