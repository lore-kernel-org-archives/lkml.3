Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3JDVj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 17:39:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:30824 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab3JDVjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 17:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1035,1371106800"; 
   d="scan'208";a="414189162"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: [PATCH 3/6] x86, ptrace: Ifdef HW_BREAKPOINTS code in ptrace
Date: Fri,  4 Oct 2013 14:39:45 -0700
Message-Id: <1380922788-23112-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add ifdefs on CONFIG_HW_BREAKPOINTS to the hardware
break point code in x86 ptrace.c. This prepares
this file for being able to disable HW_BREAKPOINTS.

The only debug register that needs to be handled
without break points is DR6, so do that in a simple
separate function without breakpoints.

Cc: fweisbec@gmail.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/ptrace.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 7461f50..dda433f 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -561,6 +561,8 @@ static int genregs_set(struct task_struct *target,
 	return ret;
 }
 
+#ifdef CONFIG_HW_BREAKPOINTS
+
 static void ptrace_triggered(struct perf_event *bp,
 			     struct perf_sample_data *data,
 			     struct pt_regs *regs)
@@ -778,6 +780,34 @@ static int ptrace_set_debugreg(struct task_struct *tsk, int n,
 	return rc;
 }
 
+#else
+
+/* Without breakpoints only handle DR6 */
+static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
+{
+	struct thread_struct *thread = &tsk->thread;
+
+	if (n == 6)
+		return thread->debugreg6;
+	return 0;
+}
+
+/* Without breakpoints only handle DR6 */
+static int ptrace_set_debugreg(struct task_struct *tsk, int n,
+			       unsigned long val)
+{
+	struct thread_struct *thread = &tsk->thread;
+	int rc = -EIO;
+
+	if (n == 6) {
+		thread->debugreg6 = val;
+		rc = 0;
+	}
+	return rc;
+}
+
+#endif
+
 /*
  * These access the current or another (stopped) task's io permission
  * bitmap for debugging or core dump.
-- 
1.8.3.1

