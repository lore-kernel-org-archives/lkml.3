Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231Ab3JRL5Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 07:57:25 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:57057 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3JRLyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 07:54:02 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@kernel.org,
        pjt@google.com, Morten.Rasmussen@arm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org
Cc: rjw@sisk.pl, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, l.majewski@samsung.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC][PATCH v5 12/14] sched: create a statistic structure
Date: Fri, 18 Oct 2013 13:52:25 +0200
Message-Id: <1382097147-30088-12-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a statistic structure that will be used to share information with
other frameworks like cpuidle and cpufreq. This structure only contains the
current wake up latency of a core for now but could be extended with other
usefull information.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 include/linux/sched.h |   12 +++++++++++-
 kernel/sched/fair.c   |    5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2004cdb..d676aa2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2,7 +2,7 @@
 #define _LINUX_SCHED_H
 
 #include <uapi/linux/sched.h>
-
+#include <linux/atomic.h>
 
 struct sched_param {
 	int sched_priority;
@@ -63,6 +63,16 @@ struct fs_struct;
 struct perf_event_context;
 struct blk_plug;
 
+/* This structure is used to share information and statistics with other
+ * frameworks. It only shares wake up latency fro the moment but should be
+ * extended with other usefull informations
+ */
+struct sched_pm {
+	atomic_t  wake_latency; /* time to wake up the cpu */
+};
+
+DECLARE_PER_CPU(struct sched_pm, sched_stat);
+
 /*
  * List of flags we want to share for kernel threads,
  * if only because they are not used by them anyway.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2d9f782..ad8b99a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -178,6 +178,11 @@ void sched_init_granularity(void)
 	update_sysctl();
 }
 
+/* Save per_cpu information that will be shared with other frameworks */
+DEFINE_PER_CPU(struct sched_pm, sched_stat) = {
+	.wake_latency = ATOMIC_INIT(0)
+};
+
 #ifdef CONFIG_SMP
 static unsigned long available_of(int cpu)
 {
-- 
1.7.9.5

