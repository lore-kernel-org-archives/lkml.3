Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935052Ab3IDOm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:42:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762776Ab3IDOhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:37:04 -0400
X-Authority-Analysis: v=2.0 cv=DqnUCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0DKgs0syVEkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=fWtwRutPKNMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=1N1UImZtlF93Ckg_JSIA:9 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130904143701.946250603@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 04 Sep 2013 10:36:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [for-next][PATCH 10/18] ftrace: Add selftest to check if RCU unsafe functions are filtered
 properly
References: <20130904143552.456506259@goodmis.org>
Content-Disposition: inline; filename=0009-ftrace-Add-selftest-to-check-if-RCU-unsafe-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a boot time start up test that has a RCU safe ftrace_ops as well
as an unsafe one. Make sure the RCU safe ops can trace RCU unsafe
functions while the unsafe ftrace_ops can not.

Cc: Jiri Olsa <jolsa@redhat.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                  |    2 +
 kernel/trace/trace_selftest.c         |   94 +++++++++++++++++++++++++++++++++
 kernel/trace/trace_selftest_dynamic.c |    7 +++
 3 files changed, 103 insertions(+)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 502fed7..3578be6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -648,6 +648,8 @@ extern unsigned long ftrace_update_tot_cnt;
 extern int DYN_FTRACE_TEST_NAME(void);
 #define DYN_FTRACE_TEST_NAME2 trace_selftest_dynamic_test_func2
 extern int DYN_FTRACE_TEST_NAME2(void);
+#define DYN_FTRACE_TEST_RCU_UNSAFE trace_selftest_dynamic_test_rcu_unsafe
+extern int DYN_FTRACE_TEST_RCU_UNSAFE(void);
 
 extern bool ring_buffer_expanded;
 extern bool tracing_selftest_disabled;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index a7329b7..eeacb47 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -185,6 +185,97 @@ static void reset_counts(void)
 	trace_selftest_test_dyn_cnt = 0;
 }
 
+static struct ftrace_ops ftrace_rcu_safe_ops = {
+	.func		= trace_selftest_test_probe1_func,
+	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_RCU_SAFE,
+};
+
+static struct ftrace_ops ftrace_rcu_unsafe_ops = {
+	.func		= trace_selftest_test_probe2_func,
+	.flags		= FTRACE_OPS_FL_RECURSION_SAFE,
+};
+
+static int test_rcu_safe_unsafe(void)
+{
+	int save_ftrace_enabled = ftrace_enabled;
+	char *func_name;
+	int len;
+	int ret = 0;
+
+	printk(KERN_CONT "PASSED\n");
+	pr_info("Testing ftrace rcu safe unsafe: ");
+
+	ftrace_enabled = 1;
+
+	trace_selftest_test_probe1_cnt = 0;
+	trace_selftest_test_probe2_cnt = 0;
+
+	func_name = "*" __stringify(DYN_FTRACE_TEST_RCU_UNSAFE);
+	len = strlen(func_name);
+
+	ftrace_set_filter(&ftrace_rcu_safe_ops, func_name, len, 1);
+	ftrace_set_filter(&ftrace_rcu_unsafe_ops, func_name, len, 1);
+
+	/* Do single registrations first */
+	register_ftrace_function(&ftrace_rcu_safe_ops);
+
+	DYN_FTRACE_TEST_RCU_UNSAFE();
+
+	unregister_ftrace_function(&ftrace_rcu_safe_ops);
+
+	if (trace_selftest_test_probe1_cnt != 1) {
+		printk(KERN_CONT "rcu_safe expected 1 call but had %d ",
+		       trace_selftest_test_probe1_cnt);
+		goto out;
+	}
+
+	register_ftrace_function(&ftrace_rcu_unsafe_ops);
+
+	DYN_FTRACE_TEST_RCU_UNSAFE();
+
+	unregister_ftrace_function(&ftrace_rcu_unsafe_ops);
+
+	if (trace_selftest_test_probe2_cnt != 0) {
+		printk(KERN_CONT "rcu_safe expected 0 calls but had %d ",
+		       trace_selftest_test_probe2_cnt);
+		goto out;
+	}
+
+	/* Run both together, which uses the list op */
+
+	trace_selftest_test_probe1_cnt = 0;
+	trace_selftest_test_probe2_cnt = 0;
+
+	register_ftrace_function(&ftrace_rcu_safe_ops);
+	register_ftrace_function(&ftrace_rcu_unsafe_ops);
+
+	DYN_FTRACE_TEST_RCU_UNSAFE();
+	DYN_FTRACE_TEST_RCU_UNSAFE();
+	DYN_FTRACE_TEST_RCU_UNSAFE();
+
+	unregister_ftrace_function(&ftrace_rcu_unsafe_ops);
+	unregister_ftrace_function(&ftrace_rcu_safe_ops);
+
+
+	if (trace_selftest_test_probe1_cnt != 3) {
+		printk(KERN_CONT "rcu_safe expected 3 calls but had %d ",
+		       trace_selftest_test_probe1_cnt);
+		goto out;
+	}
+
+	if (trace_selftest_test_probe2_cnt != 0) {
+		printk(KERN_CONT "rcu_safe expected 0 calls but had %d ",
+		       trace_selftest_test_probe2_cnt);
+		goto out;
+	}
+
+	ret = 0;
+ out:
+	ftrace_enabled = save_ftrace_enabled;
+
+	return ret;
+}
+
 static int trace_selftest_ops(int cnt)
 {
 	int save_ftrace_enabled = ftrace_enabled;
@@ -401,6 +492,9 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	if (!ret)
 		ret = trace_selftest_ops(2);
 
+	if (!ret)
+		ret = test_rcu_safe_unsafe();
+
 	return ret;
 }
 
diff --git a/kernel/trace/trace_selftest_dynamic.c b/kernel/trace/trace_selftest_dynamic.c
index b4c475a..5eefa56 100644
--- a/kernel/trace/trace_selftest_dynamic.c
+++ b/kernel/trace/trace_selftest_dynamic.c
@@ -11,3 +11,10 @@ int DYN_FTRACE_TEST_NAME2(void)
 	/* used to call mcount */
 	return 0;
 }
+
+int trace_selftest_dynamic_test_rcu_unsafe(void)
+{
+	/* used to call mcount */
+	return 0;
+}
+FTRACE_UNSAFE_RCU(trace_selftest_dynamic_test_rcu_unsafe);
-- 
1.7.10.4


