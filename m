Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbaBJN3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:29:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbaBJN3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:29:37 -0500
Date: Mon, 10 Feb 2014 05:29:06 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-75dv35xf6dhhmeb7nq6fua31@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, dave.hansen@linux.intel.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dave.hansen@linux.intel.com,
        dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Push the duration-logging printk()
  to IRQ context
Git-Commit-ID: 6a02ad66b2c44155d529f430d4fa5c6c66321077
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:29:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a02ad66b2c44155d529f430d4fa5c6c66321077
Gitweb:     http://git.kernel.org/tip/6a02ad66b2c44155d529f430d4fa5c6c66321077
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 3 Feb 2014 18:11:08 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 13:17:21 +0100

perf/x86: Push the duration-logging printk() to IRQ context

Calling printk() from NMI context is bad (TM), so move it to IRQ
context.

This also avoids the problem where the printk() time is measured by
the generic NMI duration goo and triggers a second warning.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-75dv35xf6dhhmeb7nq6fua31@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/irq_work.h |  2 ++
 kernel/events/core.c     | 28 +++++++++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6601702..add13c8 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -30,6 +30,8 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 	work->func = func;
 }
 
+#define DEFINE_IRQ_WORK(name, _f) struct irq_work name = { .func = (_f), }
+
 void irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..2067cbb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -231,11 +231,29 @@ int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
 #define NR_ACCUMULATED_SAMPLES 128
 static DEFINE_PER_CPU(u64, running_sample_length);
 
-void perf_sample_event_took(u64 sample_len_ns)
+static void perf_duration_warn(struct irq_work *w)
 {
+	u64 allowed_ns = ACCESS_ONCE(perf_sample_allowed_ns);
 	u64 avg_local_sample_len;
 	u64 local_samples_len;
+
+	local_samples_len = __get_cpu_var(running_sample_length);
+	avg_local_sample_len = local_samples_len/NR_ACCUMULATED_SAMPLES;
+
+	printk_ratelimited(KERN_WARNING
+			"perf interrupt took too long (%lld > %lld), lowering "
+			"kernel.perf_event_max_sample_rate to %d\n",
+			avg_local_sample_len, allowed_ns,
+			sysctl_perf_event_sample_rate);
+}
+
+static DEFINE_IRQ_WORK(perf_duration_work, perf_duration_warn);
+
+void perf_sample_event_took(u64 sample_len_ns)
+{
 	u64 allowed_ns = ACCESS_ONCE(perf_sample_allowed_ns);
+	u64 avg_local_sample_len;
+	u64 local_samples_len;
 
 	if (allowed_ns == 0)
 		return;
@@ -263,13 +281,9 @@ void perf_sample_event_took(u64 sample_len_ns)
 	sysctl_perf_event_sample_rate = max_samples_per_tick * HZ;
 	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
 
-	printk_ratelimited(KERN_WARNING
-			"perf samples too long (%lld > %lld), lowering "
-			"kernel.perf_event_max_sample_rate to %d\n",
-			avg_local_sample_len, allowed_ns,
-			sysctl_perf_event_sample_rate);
-
 	update_perf_cpu_limits();
+
+	irq_work_queue(&perf_duration_work);
 }
 
 static atomic64_t perf_event_id;
