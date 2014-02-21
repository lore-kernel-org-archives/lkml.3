Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaBUCyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:54:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3616 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753213AbaBUCuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:05 -0500
Message-Id: <20140221025003.592091532@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [for-next][PATCH 17/18] tracing: Add trace_clock=<clock> kernel parameter
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0017-tracing-Add-trace_clock-clock-kernel-parameter.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Being able to change the trace clock at boot can be advantageous if
you need a better source of when things happen across CPUs. The default
trace clock is the fastest, but it uses local clocks which may not be
synced across CPUs and it does not let you know when events took place
with respect to events on other CPUs.

The global trace clock can help in this case, and if you do not care
about timings, the counter "clock" is the best, as that is just a  simple
atomic counter that is incremented for every event.

Usage is to add "trace_clock=counter" on the kernel command line. You
can replace counter with "global" or any of the clocks listed in
/sys/kernel/debug/tracing/trace_clock

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Appreciated-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 61 ++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d95ec28..c90f55d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -181,6 +181,17 @@ static int __init set_trace_boot_options(char *str)
 }
 __setup("trace_options=", set_trace_boot_options);
 
+static char trace_boot_clock_buf[MAX_TRACER_SIZE] __initdata;
+static char *trace_boot_clock __initdata;
+
+static int __init set_trace_boot_clock(char *str)
+{
+	strlcpy(trace_boot_clock_buf, str, MAX_TRACER_SIZE);
+	trace_boot_clock = trace_boot_clock_buf;
+	return 0;
+}
+__setup("trace_clock=", set_trace_boot_clock);
+
 
 unsigned long long ns2usecs(cycle_t nsec)
 {
@@ -4746,25 +4757,10 @@ static int tracing_clock_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
-				   size_t cnt, loff_t *fpos)
+static int tracing_set_clock(struct trace_array *tr, const char *clockstr)
 {
-	struct seq_file *m = filp->private_data;
-	struct trace_array *tr = m->private;
-	char buf[64];
-	const char *clockstr;
 	int i;
 
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	buf[cnt] = 0;
-
-	clockstr = strstrip(buf);
-
 	for (i = 0; i < ARRAY_SIZE(trace_clocks); i++) {
 		if (strcmp(trace_clocks[i].name, clockstr) == 0)
 			break;
@@ -4792,6 +4788,32 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 
 	mutex_unlock(&trace_types_lock);
 
+	return 0;
+}
+
+static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
+				   size_t cnt, loff_t *fpos)
+{
+	struct seq_file *m = filp->private_data;
+	struct trace_array *tr = m->private;
+	char buf[64];
+	const char *clockstr;
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	clockstr = strstrip(buf);
+
+	ret = tracing_set_clock(tr, clockstr);
+	if (ret)
+		return ret;
+
 	*fpos += cnt;
 
 	return cnt;
@@ -6574,6 +6596,13 @@ __init static int tracer_alloc_buffers(void)
 
 	trace_init_cmdlines();
 
+	if (trace_boot_clock) {
+		ret = tracing_set_clock(&global_trace, trace_boot_clock);
+		if (ret < 0)
+			pr_warning("Trace clock %s not defined, going back to default\n",
+				   trace_boot_clock);
+	}
+
 	/*
 	 * register_tracer() might reference current_trace, so it
 	 * needs to be set before we register anything. This is
-- 
1.8.5.3


