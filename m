Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3JRL4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:56:51 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44399 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3JRLyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:54:05 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 14/14] cpuidle: set the current wake up latency
Date: Fri, 18 Oct 2013 13:52:27 +0200
Message-Id: <1382097147-30088-14-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the current wake up latency of a core. This latency is not always
the latency of a defined c-state but can also be an intermediate value
when a core is ready to shutdown (timer migration, cache flush ...) but
wait for the last core of the cluster to finalize the cluster power down.
This latter use case is not manage by the current version of the patch because
it implies that the cpuidle drivers set the wake up latency instead of the
cpuidle core.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Conflicts:

	drivers/cpuidle/cpuidle.c
---
 drivers/cpuidle/cpuidle.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index d75040d..7b6553b 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -19,6 +19,7 @@
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <trace/events/power.h>
 
 #include "cpuidle.h"
@@ -42,6 +43,12 @@ void disable_cpuidle(void)
 	off = 1;
 }
 
+static void cpuidle_set_current_state(int cpu, int latency)
+{
+	struct sched_pm *stat = &per_cpu(sched_stat, cpu);
+
+	atomic_set(&(stat->wake_latency), latency);
+}
 /**
  * cpuidle_play_dead - cpu off-lining
  *
@@ -79,12 +86,16 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 	ktime_t time_start, time_end;
 	s64 diff;
 
+	cpuidle_set_current_state(dev->cpu, target_state->exit_latency);
+
 	time_start = ktime_get();
 
 	entered_state = target_state->enter(dev, drv, index);
 
 	time_end = ktime_get();
 
+	cpuidle_set_current_state(dev->cpu, 0);
+
 	local_irq_enable();
 
 	diff = ktime_to_us(ktime_sub(time_end, time_start));
-- 
1.7.9.5

