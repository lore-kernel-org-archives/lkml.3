Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbaGOR0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:26:16 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:38701 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbaGORCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:08 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Medhurst <tixy@linaro.org>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 16/94] ARM: kprobes: Prevent known test failures stopping other tests running
Date: Tue, 15 Jul 2014 20:00:31 +0300
Message-Id: <1405443709-15288-16-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Medhurst <tixy@linaro.org>

Due to a long-standing issue with Thumb symbol lookup [1] the jprobes
tests fail when built into a kernel compiled as Thumb mode. (They work
fine for ARM mode kernels or for Thumb when built as a loadable module.)

Rather than have this problem terminate testing prematurely lets instead
emit an error message and carry on with the main kprobes tests, delaying
the final failure report until the end.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2011-August/063026.html

Signed-off-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 arch/arm/kernel/kprobes-test.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 3796399..08d7312 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -225,6 +225,7 @@ static int pre_handler_called;
 static int post_handler_called;
 static int jprobe_func_called;
 static int kretprobe_handler_called;
+static int tests_failed;
 
 #define FUNC_ARG1 0x12345678
 #define FUNC_ARG2 0xabcdef
@@ -461,6 +462,13 @@ static int run_api_tests(long (*func)(long, long))
 
 	pr_info("    jprobe\n");
 	ret = test_jprobe(func);
+#if defined(CONFIG_THUMB2_KERNEL) && !defined(MODULE)
+	if (ret == -EINVAL) {
+		pr_err("FAIL: Known longtime bug with jprobe on Thumb kernels\n");
+		tests_failed = ret;
+		ret = 0;
+	}
+#endif
 	if (ret < 0)
 		return ret;
 
@@ -1672,6 +1680,8 @@ static int __init run_all_tests(void)
 
 out:
 	if (ret == 0)
+		ret = tests_failed;
+	if (ret == 0)
 		pr_info("Finished kprobe tests OK\n");
 	else
 		pr_err("kprobe tests failed\n");
-- 
1.7.10.4

