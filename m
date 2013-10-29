Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab3J2OIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:08:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45907 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3J2OIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:08:35 -0400
Date: Tue, 29 Oct 2013 07:07:58 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-vw9lg588x1ic248whybjon0c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Remove useless atomic_t
Git-Commit-ID: d9494cb4299da66541a3f3ab82c552889bee0606
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:08:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9494cb4299da66541a3f3ab82c552889bee0606
Gitweb:     http://git.kernel.org/tip/d9494cb4299da66541a3f3ab82c552889bee0606
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 17 Oct 2013 15:36:19 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:49 +0100

perf: Remove useless atomic_t

There's nothing atomic about atomic_set vs atomic_read; so remove the
atomic_t usage.

Also, make running_sample_length static as it really is (and should
be) local to this translation unit.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com
Cc: Don Zickus <dzickus@redhat.com>
Cc: jmario@redhat.com
Cc: acme@infradead.org
Cc: dave.hansen@linux.intel.com
Link: http://lkml.kernel.org/n/tip-vw9lg588x1ic248whybjon0c@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5bd7fe4..028dad9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -175,8 +175,8 @@ int sysctl_perf_event_sample_rate __read_mostly	= DEFAULT_MAX_SAMPLE_RATE;
 static int max_samples_per_tick __read_mostly	= DIV_ROUND_UP(DEFAULT_MAX_SAMPLE_RATE, HZ);
 static int perf_sample_period_ns __read_mostly	= DEFAULT_SAMPLE_PERIOD_NS;
 
-static atomic_t perf_sample_allowed_ns __read_mostly =
-	ATOMIC_INIT( DEFAULT_SAMPLE_PERIOD_NS * DEFAULT_CPU_TIME_MAX_PERCENT / 100);
+static int perf_sample_allowed_ns __read_mostly =
+	DEFAULT_SAMPLE_PERIOD_NS * DEFAULT_CPU_TIME_MAX_PERCENT / 100;
 
 void update_perf_cpu_limits(void)
 {
@@ -184,7 +184,7 @@ void update_perf_cpu_limits(void)
 
 	tmp *= sysctl_perf_cpu_time_max_percent;
 	do_div(tmp, 100);
-	atomic_set(&perf_sample_allowed_ns, tmp);
+	ACCESS_ONCE(perf_sample_allowed_ns) = tmp;
 }
 
 static int perf_rotate_context(struct perf_cpu_context *cpuctx);
@@ -228,14 +228,15 @@ int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
  * we detect that events are taking too long.
  */
 #define NR_ACCUMULATED_SAMPLES 128
-DEFINE_PER_CPU(u64, running_sample_length);
+static DEFINE_PER_CPU(u64, running_sample_length);
 
 void perf_sample_event_took(u64 sample_len_ns)
 {
 	u64 avg_local_sample_len;
 	u64 local_samples_len;
+	u64 allowed_ns = ACCESS_ONCE(perf_sample_allowed_ns);
 
-	if (atomic_read(&perf_sample_allowed_ns) == 0)
+	if (allowed_ns == 0)
 		return;
 
 	/* decay the counter by 1 average sample */
@@ -251,7 +252,7 @@ void perf_sample_event_took(u64 sample_len_ns)
 	 */
 	avg_local_sample_len = local_samples_len/NR_ACCUMULATED_SAMPLES;
 
-	if (avg_local_sample_len <= atomic_read(&perf_sample_allowed_ns))
+	if (avg_local_sample_len <= allowed_ns)
 		return;
 
 	if (max_samples_per_tick <= 1)
@@ -262,10 +263,9 @@ void perf_sample_event_took(u64 sample_len_ns)
 	perf_sample_period_ns = NSEC_PER_SEC / sysctl_perf_event_sample_rate;
 
 	printk_ratelimited(KERN_WARNING
-			"perf samples too long (%lld > %d), lowering "
+			"perf samples too long (%lld > %lld), lowering "
 			"kernel.perf_event_max_sample_rate to %d\n",
-			avg_local_sample_len,
-			atomic_read(&perf_sample_allowed_ns),
+			avg_local_sample_len, allowed_ns,
 			sysctl_perf_event_sample_rate);
 
 	update_perf_cpu_limits();
