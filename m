Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3JKRTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:19:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48525 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab3JKRTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:19:30 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC][PATCH 2/7] sched: power: Power driver late callback interface
Date: Fri, 11 Oct 2013 18:19:12 +0100
Message-Id: <1381511957-29776-3-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 11 Oct 2013 17:19:26.0489 (UTC) FILETIME=[09664090:01CEC6A6]
X-MC-Unique: 113101118192806501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r9BHJuDG031558

Adds a late callback to the power driver interface which is called
with irq enabled and no locks held. The power driver may postpone
work that can't be done in schedule context (irq disabled and rq
locks held) and let the late callback handle it.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 include/linux/sched/power.h |    3 +++
 kernel/sched/core.c         |    1 +
 kernel/sched/fair.c         |    2 ++
 kernel/sched/power.c        |    6 ++++++
 kernel/sched/sched.h        |    8 ++++++++
 5 files changed, 20 insertions(+)

diff --git a/include/linux/sched/power.h b/include/linux/sched/power.h
index cb2cf37..aba5f47 100644
--- a/include/linux/sched/power.h
+++ b/include/linux/sched/power.h
@@ -25,6 +25,9 @@ struct power_driver {
 	int (*go_faster)	(int cpu, int hint);
 	/* Decrease cpu capacity hint */
 	int (*go_slower)	(int cpu, int hint);
+
+	/* Scheduler call-back without rq lock held and with irq enabled */
+	void (*late_callback)	(int cpu);
 };
 
 int power_driver_register(struct power_driver *driver);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 05c39f0..12b4753 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1913,6 +1913,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 		put_task_struct(prev);
 	}
 
+	power_late_callback(raw_smp_processor_id());
 	tick_nohz_task_switch(current);
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 68f1609..edba1bb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5742,6 +5742,8 @@ static void run_rebalance_domains(struct softirq_action *h)
 	 * stopped.
 	 */
 	nohz_idle_balance(this_cpu, idle);
+
+	power_late_callback(this_cpu);
 }
 
 static inline int on_null_domain(int cpu)
diff --git a/kernel/sched/power.c b/kernel/sched/power.c
index b82965a..f70b563 100644
--- a/kernel/sched/power.c
+++ b/kernel/sched/power.c
@@ -56,3 +56,9 @@ int go_slower(int cpu, int hint)
 	return power_driver->go_slower(cpu, hint);
 }
 
+void power_late_callback(int cpu)
+{
+	if (!power_driver)
+		return;
+	power_driver->late_callback(cpu);
+}
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ef0a7b2..907a967 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1364,3 +1364,11 @@ static inline u64 irq_time_read(int cpu)
 }
 #endif /* CONFIG_64BIT */
 #endif /* CONFIG_IRQ_TIME_ACCOUNTING */
+
+#ifdef CONFIG_SCHED_POWER
+extern void power_late_callback(int cpu);
+#else
+static inline void power_late_callback(int cpu)
+{
+}
+#endif /* CONFIG_SCHED_POWER */
-- 
1.7.9.5


