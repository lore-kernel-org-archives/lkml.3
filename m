Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3KFOzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:55:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32083 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932449Ab3KFOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:52:59 -0500
Message-Id: <20131106145257.266311470@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 09:50:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kevin Hao <haokexin@gmail.com>
Subject: [for-next][PATCH 2/8] ftrace/x86: skip over the breakpoint for ftrace caller
References: <20131106145041.904349372@goodmis.org>
Content-Disposition: inline; filename=0008-ftrace-x86-skip-over-the-breakpoint-for-ftrace-calle.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hao <haokexin@gmail.com>

In commit 8a4d0a687a59 "ftrace: Use breakpoint method to update ftrace
caller", we choose to use breakpoint method to update the ftrace
caller. But we also need to skip over the breakpoint in function
ftrace_int3_handler() for them. Otherwise weird things would happen.

Cc: stable@vger.kernel.org # 3.5+
Signed-off-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 42a392a..d4bdd25 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -248,6 +248,15 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	return ret;
 }
 
+static int is_ftrace_caller(unsigned long ip)
+{
+	if (ip == (unsigned long)(&ftrace_call) ||
+		ip == (unsigned long)(&ftrace_regs_call))
+		return 1;
+
+	return 0;
+}
+
 /*
  * A breakpoint was added to the code address we are about to
  * modify, and this is the handle that will just skip over it.
@@ -257,10 +266,13 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
  */
 int ftrace_int3_handler(struct pt_regs *regs)
 {
+	unsigned long ip;
+
 	if (WARN_ON_ONCE(!regs))
 		return 0;
 
-	if (!ftrace_location(regs->ip - 1))
+	ip = regs->ip - 1;
+	if (!ftrace_location(ip) && !is_ftrace_caller(ip))
 		return 0;
 
 	regs->ip += MCOUNT_INSN_SIZE - 1;
-- 
1.8.4.rc3


