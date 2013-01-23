Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab3AWUe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:34:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3AWUee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:34:34 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jMLNOPgicDUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=SApUdAxLHXgA:10 a=20KFwNOVAAAA:8 a=CIVuRCbC61s4UZf07ZUA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130123203433.708031234@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 23 Jan 2013 15:30:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/12 -next] tracing: Fix selftest function recursion accounting
References: <20130123203002.957226869@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Fix-selftest-function-recursion-accounting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The test that checks function recursion does things differently
if the arch does not support all ftrace features. But that really
doesn't make a difference with how the test runs, and either way
the count variable should be 2 at the end.

Currently the test wrongly fails for archs that don't support all
the ftrace features.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_selftest.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 6c62d58..adb008a 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -452,7 +452,6 @@ trace_selftest_function_recursion(void)
 	char *func_name;
 	int len;
 	int ret;
-	int cnt;
 
 	/* The previous test PASSED */
 	pr_cont("PASSED\n");
@@ -510,19 +509,10 @@ trace_selftest_function_recursion(void)
 
 	unregister_ftrace_function(&test_recsafe_probe);
 
-	/*
-	 * If arch supports all ftrace features, and no other task
-	 * was on the list, we should be fine.
-	 */
-	if (!ftrace_nr_registered_ops() && !FTRACE_FORCE_LIST_FUNC)
-		cnt = 2; /* Should have recursed */
-	else
-		cnt = 1;
-
 	ret = -1;
-	if (trace_selftest_recursion_cnt != cnt) {
-		pr_cont("*callback not called expected %d times (%d)* ",
-			cnt, trace_selftest_recursion_cnt);
+	if (trace_selftest_recursion_cnt != 2) {
+		pr_cont("*callback not called expected 2 times (%d)* ",
+			trace_selftest_recursion_cnt);
 		goto out;
 	}
 
-- 
1.7.10.4


