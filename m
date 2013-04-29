Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab3D2TC5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:02:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759276Ab3D2TCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:02:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [ 40/42] tracing: Fix selftest function recursion accounting
Date: Mon, 29 Apr 2013 12:02:22 -0700
Message-Id: <20130429184756.916335151@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184752.435249613@linuxfoundation.org>
References: <20130429184752.435249613@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <srostedt@redhat.com>

commit 05cbbf643b8eea1be21082c53cdb856d1dc6d765 upstream.

The test that checks function recursion does things differently
if the arch does not support all ftrace features. But that really
doesn't make a difference with how the test runs, and either way
the count variable should be 2 at the end.

Currently the test wrongly fails for archs that don't support all
the ftrace features.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_selftest.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

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
 


