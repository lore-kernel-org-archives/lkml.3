Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbaJINCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:02:33 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:60660 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbaJINBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:01:45 -0400
Subject: [PATCH ftrace/for-next v5 5/5] kselftest,
 ftrace: Add ftrace IPMODIFY flag test
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Thu, 09 Oct 2014 13:01:33 +0000
Message-ID: <20141009130133.4698.45425.stgit@kbuild-f20.novalocal>
In-Reply-To: <20141009130059.4698.21616.stgit@kbuild-f20.novalocal>
References: <20141009130059.4698.21616.stgit@kbuild-f20.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ftrace IPMODIFY flag test to selftest/ftrace. The
test checks simple ftrace handler insertion and
combinations of ftrace, kprobe, and jprobe.
This test requires kernel build tree to build a test
kernel module and root privilage to run.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

---
Changes in v5:
 - Add this test to kselftest.
---
 tools/testing/selftests/ftrace/Makefile            |   11 +
 tools/testing/selftests/ftrace/ipmodify/Makefile   |   15 ++
 tools/testing/selftests/ftrace/ipmodify/ipmodify.c |  168 ++++++++++++++++++++
 .../selftests/ftrace/ipmodify/run_ipmodify.sh      |    6 +
 4 files changed, 200 insertions(+)
 create mode 100644 tools/testing/selftests/ftrace/ipmodify/Makefile
 create mode 100644 tools/testing/selftests/ftrace/ipmodify/ipmodify.c
 create mode 100644 tools/testing/selftests/ftrace/ipmodify/run_ipmodify.sh

diff --git a/tools/testing/selftests/ftrace/Makefile b/tools/testing/selftests/ftrace/Makefile
index 76cc9f1..69f0b1a 100644
--- a/tools/testing/selftests/ftrace/Makefile
+++ b/tools/testing/selftests/ftrace/Makefile
@@ -1,7 +1,18 @@
+TARGETS += ipmodify
+
 all:
+	for TARGET in $(TARGETS); do \
+		make -C $$TARGET; \
+	done;
 
 run_tests:
 	@/bin/sh ./ftracetest || echo "ftrace selftests: [FAIL]"
+	for TARGET in $(TARGETS); do \
+		make -C $$TARGET run_tests; \
+	done;
 
 clean:
 	rm -rf logs/*
+	for TARGET in $(TARGETS); do \
+		make -C $$TARGET clean; \
+	done;
diff --git a/tools/testing/selftests/ftrace/ipmodify/Makefile b/tools/testing/selftests/ftrace/ipmodify/Makefile
new file mode 100644
index 0000000..416e9a8
--- /dev/null
+++ b/tools/testing/selftests/ftrace/ipmodify/Makefile
@@ -0,0 +1,15 @@
+BUILDDIR = /lib/modules/$(shell uname -r)/build
+HERE = $(abspath ./)
+
+obj-m := ipmodify.o
+
+ipmodify.ko: ipmodify.c
+	$(MAKE) -C $(BUILDDIR) M=$(HERE) $@
+
+all: ipmodify.ko
+
+run_tests:
+	@/bin/sh ./run_ipmodify.sh || echo "ftrace ipmodify test: [FAIL]"
+
+clean:
+	$(RM) -Rf .*.o.cmd .*.ko.cmd .tmp_versions *.o *.ko *.mod.c modules.order Module.symvers
diff --git a/tools/testing/selftests/ftrace/ipmodify/ipmodify.c b/tools/testing/selftests/ftrace/ipmodify/ipmodify.c
new file mode 100644
index 0000000..88677f4
--- /dev/null
+++ b/tools/testing/selftests/ftrace/ipmodify/ipmodify.c
@@ -0,0 +1,168 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ftrace.h>
+#include <linux/kprobes.h>
+
+/* Testing the IPMODIFY flag by using kprobe, jprobe, and ftrace handler */
+
+static __used int ipmodify_target_function(int a1, int a2, int a3)
+{
+	return a1 + a2 + a3;
+}
+
+/* Kprobe pre handler (IPMODIFY bit is NOT set) */
+static int kprobe_test_handler(struct kprobe *kp, struct pt_regs *regs)
+{
+	return 0;
+}
+
+static struct kprobe test_kp, __test_kp = {
+	.pre_handler = kprobe_test_handler,
+	.addr = (void *)ipmodify_target_function,
+};
+
+/* Jprobe entry handler (IPMODIFY should be set) */
+static void jprobe_test_handler(int a1, int a2, int a3)
+{
+	jprobe_return();
+}
+
+static struct jprobe test_jp, __test_jp = {
+	.entry = jprobe_test_handler,
+	.kp = {
+		.addr = (void *)ipmodify_target_function,
+	},
+};
+
+/* Ftrace handler (with IPMODIFY flag) */
+static void ftrace_ipmodify_handler(unsigned long a0, unsigned long a1,
+				struct ftrace_ops *op, struct pt_regs *regs)
+{
+	return;
+}
+
+static struct ftrace_ops test_ops __read_mostly, __test_ops = {
+	.func = ftrace_ipmodify_handler,
+	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
+};
+
+static void cleanup_probes(void)
+{
+	unregister_kprobe(&test_kp);
+	unregister_jprobe(&test_jp);
+	if (test_ops.flags & FTRACE_OPS_FL_ENABLED)
+		unregister_ftrace_function(&test_ops);
+	test_kp = __test_kp;
+	test_jp = __test_jp;
+}
+
+
+
+/* We'll test various probes on a target function. */
+static int __init ipmodify_init(void)
+{
+	int ret;
+
+	test_kp = __test_kp;
+	test_jp = __test_jp;
+	test_ops = __test_ops;
+
+	/* Setup ftrace filter */
+	ret = ftrace_set_filter_ip(&test_ops,
+				 (unsigned long)ipmodify_target_function, 0, 0);
+	if (ret < 0) {
+		ret = pr_err("IPMODIFY test: ftrace_set_filter_ip\t[FAILED]\n");
+		goto err;
+	}
+
+	ret = -EINVAL;
+
+/* For the test case which should pass */
+#define EXP_OK(cond)		\
+	if ((cond) < 0) {		\
+		pr_cont("[FAIL]\n\t" #cond " is failed\n");	\
+		goto err;	\
+	}
+/* For the test case which should fail */
+#define EXP_NG(cond)		\
+	if ((cond) >= 0) {	\
+		pr_cont("[XPASS]\n\t" #cond " is unexpectedly passed\n");\
+		goto err;	\
+	}
+
+	/* Case 1 */
+	pr_info("IPMODIFY test: ipmodify only\t");
+	EXP_OK(register_ftrace_function(&test_ops))
+	ipmodify_target_function(1, 2, 3);
+	pr_cont("[PASS]\n");
+	cleanup_probes();
+
+	/* Case 2 */
+	pr_info("IPMODIFY test: kprobe->ipmodify\t");
+	EXP_OK(register_kprobe(&test_kp))
+	EXP_OK(register_ftrace_function(&test_ops))
+	ipmodify_target_function(2, 3, 4);
+	pr_cont("[PASS]\n");
+	cleanup_probes();
+
+	/* Case 3 */
+	pr_info("IPMODIFY test: jprobe->ipmodify(NG)\t");
+	EXP_OK(register_jprobe(&test_jp))
+	EXP_NG(register_ftrace_function(&test_ops))
+	ipmodify_target_function(3, 4, 5);
+	pr_cont("[PASS]\n");
+	cleanup_probes();
+
+	/* Case 4 */
+	pr_info("IPMODIFY test: ipmodify->kprobe\t");
+	EXP_OK(register_ftrace_function(&test_ops))
+	EXP_OK(register_kprobe(&test_kp))
+	ipmodify_target_function(4, 5, 6);
+	pr_cont("[PASS]\n");
+	cleanup_probes();
+
+	/* Case 5 */
+	pr_info("IPMODIFY test: ipmodify->jprobe(NG)\t");
+	EXP_OK(register_ftrace_function(&test_ops))
+	EXP_NG(register_jprobe(&test_jp))
+	ipmodify_target_function(5, 6, 7);
+	pr_cont("[PASS]\n");
+	cleanup_probes();
+
+	/* Case 6 */
+	pr_info("IPMODIFY test: kprobe->jprobe->ipmodify(NG)\t");
+	EXP_OK(register_kprobe(&test_kp))
+	EXP_OK(register_jprobe(&test_jp))
+	EXP_NG(register_ftrace_function(&test_ops))
+	ipmodify_target_function(6, 7, 8);
+	pr_cont("[PASS]\n");
+	cleanup_probes();
+
+	/* Case 7 */
+	pr_info("IPMODIFY test: kprobe->ipmodify->jprobe(NG)\t");
+	EXP_OK(register_kprobe(&test_kp))
+	EXP_OK(register_ftrace_function(&test_ops))
+	EXP_NG(register_jprobe(&test_jp))
+	ipmodify_target_function(7, 8, 9);
+	pr_cont("[PASS]\n");
+	cleanup_probes();
+
+	/* Case 8 */
+	pr_info("IPMODIFY test: setting notrace filter with ipmodify(NG)\t");
+	EXP_NG(ftrace_set_notrace(&test_ops, "do_fork", 0, 0))
+	pr_cont("[PASS]\n");
+
+	return 0;
+err:
+	cleanup_probes();
+	return ret;
+}
+
+void ipmodify_exit(void)
+{
+	return;
+}
+
+module_init(ipmodify_init)
+module_exit(ipmodify_exit)
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/ftrace/ipmodify/run_ipmodify.sh b/tools/testing/selftests/ftrace/ipmodify/run_ipmodify.sh
new file mode 100644
index 0000000..4878d9d
--- /dev/null
+++ b/tools/testing/selftests/ftrace/ipmodify/run_ipmodify.sh
@@ -0,0 +1,6 @@
+#!/bin/sh
+set -e
+insmod ipmodify.ko
+rmmod ipmodify.ko
+dmesg | tail -n 8
+


