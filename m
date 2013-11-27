Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab3K0CyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:54:06 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:41550 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3K0Cxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:53:49 -0500
From: David Long <dave.long@linaro.org>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: Rabin Vincent <rabin@rab.in>, "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 06/15] ARM: Disable jprobes test when built into thumb-mode kernel
Date: Tue, 26 Nov 2013 21:53:25 -0500
Message-Id: <1385520814-10663-7-git-send-email-dave.long@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
References: <1385520814-10663-1-git-send-email-dave.long@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jon Medhurst (Tixy)" <tixy@linaro.org>

For now the jprobes tests fail on ARM for when built into a kernel compiled
in thumb mode. They work fine for ARM kernels, and when built as a loadable
module.

Signed-off-by: David A. Long <dave.long@linaro.org>
---
 arch/arm/kernel/kprobes-test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 0cd63d0..65230b2 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -221,6 +221,7 @@ static int pre_handler_called;
 static int post_handler_called;
 static int jprobe_func_called;
 static int kretprobe_handler_called;
+static int tests_failed;
 
 #define FUNC_ARG1 0x12345678
 #define FUNC_ARG2 0xabcdef
@@ -457,6 +458,13 @@ static int run_api_tests(long (*func)(long, long))
 
 	pr_info("    jprobe\n");
 	ret = test_jprobe(func);
+#if defined(CONFIG_THUMB2_KERNEL) && !defined(MODULE)
+	if (ret == -EINVAL) {
+		pr_err("FAIL: Known longtime bug with jprobe on Thumb kernels");
+		tests_failed = ret;
+		ret = 0;
+	}
+#endif
 	if (ret < 0)
 		return ret;
 
@@ -1667,6 +1675,8 @@ static int __init run_all_tests(void)
 
 out:
 	if (ret == 0)
+		ret = tests_failed;
+	if (ret == 0)
 		pr_info("Finished kprobe tests OK\n");
 	else
 		pr_err("kprobe tests failed\n");
-- 
1.8.1.2

