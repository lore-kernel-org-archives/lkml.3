Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaFLTeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:34:11 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:59641 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaFLTeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:34:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] timer: Store cpu-number in 'struct tvec_base'
Date: Thu, 12 Jun 2014 21:34:00 +0200
Message-Id: <1402601641-28462-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1402601641-28462-1-git-send-email-fweisbec@gmail.com>
References: <1402601641-28462-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

Timers are serviced by the tick. But when a timer is enqueued on a
dynticks target, we need to kick it in order to make it reconsider the
next tick to schedule to correctly handle the timer's expiring time.

Now while this kick is correctly performed for add_timer_on(), the
mod_timer*() family has been a bit neglected.

To prepare for fixing this, we need internal_add_timer() to be able to
resolve the CPU target associated to a timer's object 'base' so that the
kick can be centralized there.

This can't be passed as an argument as not all the callers know the CPU
number of a timer's base. So lets store it in the struct tvec_base to
resolve the CPU without much overhead. It is set once for good at every
CPU's first boot.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index 3bb01a3..9e5f4f2 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -82,6 +82,7 @@ struct tvec_base {
 	unsigned long next_timer;
 	unsigned long active_timers;
 	unsigned long all_timers;
+	int cpu;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -1568,6 +1569,7 @@ static int init_timers_cpu(int cpu)
 		}
 		spin_lock_init(&base->lock);
 		tvec_base_done[cpu] = 1;
+		base->cpu = cpu;
 	} else {
 		base = per_cpu(tvec_bases, cpu);
 	}
-- 
1.8.3.1

