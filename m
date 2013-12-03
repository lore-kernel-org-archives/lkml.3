Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3LCM2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:28:01 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37702 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3LCM17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:27:59 -0500
From: Alex Shi <alex.shi@linaro.org>
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        fweisbec@gmail.com, linux@arm.linux.org.uk, tony.luck@intel.com,
        fenghua.yu@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
        arjan@linux.intel.com, pjt@google.com, fengguang.wu@intel.com
Cc: james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, Alex Shi <alex.shi@intel.com>
Subject: [PATCH 3/3] nohz_full: update cpu load fix in nohz_full
Date: Tue,  3 Dec 2013 20:27:01 +0800
Message-Id: <1386073621-30234-3-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386073621-30234-1-git-send-email-alex.shi@linaro.org>
References: <1386073621-30234-1-git-send-email-alex.shi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are not always 0 when update nohz cpu load, after nohz_full enabled.
But current code still treat the cpu as idle. that is incorrect.
Fix it to use correct cpu_load.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/proc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
index 16f5a30..f1441f0 100644
--- a/kernel/sched/proc.c
+++ b/kernel/sched/proc.c
@@ -568,8 +568,14 @@ void update_cpu_load_nohz(void)
 		/*
 		 * We were idle, this means load 0, the current load might be
 		 * !0 due to remote wakeups and the sort.
+		 * or we may has only one task and in NO_HZ_FULL, then still use
+		 * normal cpu load.
 		 */
-		__update_cpu_load(this_rq, 0, pending_updates);
+		if (this_rq->cfs.h_nr_running) {
+			unsigned load = get_rq_runnable_load(this_rq);
+			__update_cpu_load(this_rq, load, pending_updates);
+		} else
+			__update_cpu_load(this_rq, 0, pending_updates);
 	}
 	raw_spin_unlock(&this_rq->lock);
 }
-- 
1.8.1.2

