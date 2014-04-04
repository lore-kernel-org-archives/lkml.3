Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaDDDTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 23:19:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65456 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215AbaDDDTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 23:19:04 -0400
From: Lei Wen <leiwen@marvell.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Petr Mladek <pmladek@suse.cz>, <linux-kernel@vger.kernel.org>,
        <leiwen@marvell.com>
Subject: [PATCH 1/3] time: create __get_monotonic_boottime for WARNless calls
Date: Fri, 4 Apr 2014 11:18:40 +0800
Message-ID: <1396581522-3309-2-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396581522-3309-1-git-send-email-leiwen@marvell.com>
References: <1396581522-3309-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-04_01:2014-04-03,2014-04-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404030304
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since sched_clock always get stopped during suspend period, it
would make it hard to use the kernel log to compare with other
procssor generated log which running over the same machine.
[Absolutely not running linux]

So we need a way to recover the printk timestamp that including
suspend time in the old way, get_monotonic_boottime is a good
candidate, but it cannot be called after suspend process has happen.
Thus, it prevent printk to be used in every corner.

Export one warn less __get_monotonic_boottime to solve this issue.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 include/linux/time.h      |  1 +
 kernel/time/timekeeping.c | 33 ++++++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b..a2f5079 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -171,6 +171,7 @@ extern void getnstime_raw_and_real(struct timespec *ts_raw,
 		struct timespec *ts_real);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
+extern int __get_monotonic_boottime(struct timespec *ts);
 extern void get_monotonic_boottime(struct timespec *ts);
 
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5b40279..c196111 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1465,23 +1465,22 @@ void getboottime(struct timespec *ts)
 EXPORT_SYMBOL_GPL(getboottime);
 
 /**
- * get_monotonic_boottime - Returns monotonic time since boot
+ * __get_monotonic_boottime - Returns monotonic time since boot
  * @ts:		pointer to the timespec to be set
  *
- * Returns the monotonic time since boot in a timespec.
+ * Update the monotonic time since boot in a timespec.
+ * Returns 0 on success, or -ve when suspended (timespec will be undefined).
  *
  * This is similar to CLOCK_MONTONIC/ktime_get_ts, but also
  * includes the time spent in suspend.
  */
-void get_monotonic_boottime(struct timespec *ts)
+int __get_monotonic_boottime(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
 	struct timespec tomono, sleep;
 	s64 nsec;
 	unsigned int seq;
 
-	WARN_ON(timekeeping_suspended);
-
 	do {
 		seq = read_seqcount_begin(&timekeeper_seq);
 		ts->tv_sec = tk->xtime_sec;
@@ -1494,6 +1493,30 @@ void get_monotonic_boottime(struct timespec *ts)
 	ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsec + tomono.tv_nsec + sleep.tv_nsec);
+
+	/*
+	 * Do not bail out early, in case there were callers still using
+	 * the value, even in the face of the WARN_ON.
+	 */
+	if (unlikely(timekeeping_suspended))
+		return -EAGAIN;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__get_monotonic_boottime);
+
+/**
+ * get_monotonic_boottime - Returns monotonic time since boot
+ * @ts:		pointer to the timespec to be set
+ *
+ * Returns the monotonic time since boot in a timespec.
+ * (WARN if suspended)
+ *
+ * This is similar to CLOCK_MONTONIC/ktime_get_ts, but also
+ * includes the time spent in suspend.
+ */
+void get_monotonic_boottime(struct timespec *ts)
+{
+	WARN_ON(__get_monotonic_boottime(ts));
 }
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 
-- 
1.8.3.2

