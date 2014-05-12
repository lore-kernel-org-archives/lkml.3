Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbaELPOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:14:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:21047 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758642AbaELPMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:06 -0400
Message-Id: <20140512151204.161971503@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 10/13] ftrace: Make get_ftrace_addr() and get_ftrace_addr_old() global
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0010-ftrace-Make-get_ftrace_addr-and-get_ftrace_addr_old-.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Move and rename get_ftrace_addr() and get_ftrace_addr_old() to
ftrace_get_addr_new() and ftrace_get_addr_curr() respectively.

This moves these two helper functions in the generic code out from
the arch specific code, and renames them to have a better generic
name. This will allow other archs to use them as well as makes it
a bit easier to work on getting separate trampolines for different
functions.

ftrace_get_addr_new() returns the trampoline address that the mcount
call address will be converted to.

ftrace_get_addr_curr() returns the trampoline address of what the
mcount call address currently jumps to.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 36 +++++-------------------------------
 include/linux/ftrace.h   |  2 ++
 kernel/trace/ftrace.c    | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 4b3c195..5ef43ce 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -349,38 +349,12 @@ static int add_brk_on_nop(struct dyn_ftrace *rec)
 	return add_break(rec->ip, old);
 }
 
-/*
- * If the record has the FTRACE_FL_REGS set, that means that it
- * wants to convert to a callback that saves all regs. If FTRACE_FL_REGS
- * is not not set, then it wants to convert to the normal callback.
- */
-static unsigned long get_ftrace_addr(struct dyn_ftrace *rec)
-{
-	if (rec->flags & FTRACE_FL_REGS)
-		return (unsigned long)FTRACE_REGS_ADDR;
-	else
-		return (unsigned long)FTRACE_ADDR;
-}
-
-/*
- * The FTRACE_FL_REGS_EN is set when the record already points to
- * a function that saves all the regs. Basically the '_EN' version
- * represents the current state of the function.
- */
-static unsigned long get_ftrace_old_addr(struct dyn_ftrace *rec)
-{
-	if (rec->flags & FTRACE_FL_REGS_EN)
-		return (unsigned long)FTRACE_REGS_ADDR;
-	else
-		return (unsigned long)FTRACE_ADDR;
-}
-
 static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 {
 	unsigned long ftrace_addr;
 	int ret;
 
-	ftrace_addr = get_ftrace_old_addr(rec);
+	ftrace_addr = ftrace_get_addr_curr(rec);
 
 	ret = ftrace_test_record(rec, enable);
 
@@ -438,14 +412,14 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 		 * If not, don't touch the breakpoint, we make just create
 		 * a disaster.
 		 */
-		ftrace_addr = get_ftrace_addr(rec);
+		ftrace_addr = ftrace_get_addr_new(rec);
 		nop = ftrace_call_replace(ip, ftrace_addr);
 
 		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) == 0)
 			goto update;
 
 		/* Check both ftrace_addr and ftrace_old_addr */
-		ftrace_addr = get_ftrace_old_addr(rec);
+		ftrace_addr = ftrace_get_addr_curr(rec);
 		nop = ftrace_call_replace(ip, ftrace_addr);
 
 		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0)
@@ -489,7 +463,7 @@ static int add_update(struct dyn_ftrace *rec, int enable)
 
 	ret = ftrace_test_record(rec, enable);
 
-	ftrace_addr  = get_ftrace_addr(rec);
+	ftrace_addr  = ftrace_get_addr_new(rec);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
@@ -536,7 +510,7 @@ static int finish_update(struct dyn_ftrace *rec, int enable)
 
 	ret = ftrace_update_record(rec, enable);
 
-	ftrace_addr = get_ftrace_addr(rec);
+	ftrace_addr = ftrace_get_addr_new(rec);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f0ff2c2..2f8cbff 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -400,6 +400,8 @@ int ftrace_update_record(struct dyn_ftrace *rec, int enable);
 int ftrace_test_record(struct dyn_ftrace *rec, int enable);
 void ftrace_run_stop_machine(int command);
 unsigned long ftrace_location(unsigned long ip);
+unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec);
+unsigned long ftrace_get_addr_curr(struct dyn_ftrace *rec);
 
 extern ftrace_func_t ftrace_trace_function;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 98fa931..e825fde 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1755,6 +1755,42 @@ int ftrace_test_record(struct dyn_ftrace *rec, int enable)
 	return ftrace_check_record(rec, enable, 0);
 }
 
+/**
+ * ftrace_get_addr_new - Get the call address to set to
+ * @rec:  The ftrace record descriptor
+ *
+ * If the record has the FTRACE_FL_REGS set, that means that it
+ * wants to convert to a callback that saves all regs. If FTRACE_FL_REGS
+ * is not not set, then it wants to convert to the normal callback.
+ *
+ * Returns the address of the trampoline to set to
+ */
+unsigned long ftrace_get_addr_new(struct dyn_ftrace *rec)
+{
+	if (rec->flags & FTRACE_FL_REGS)
+		return (unsigned long)FTRACE_REGS_ADDR;
+	else
+		return (unsigned long)FTRACE_ADDR;
+}
+
+/**
+ * ftrace_get_addr_curr - Get the call address that is already there
+ * @rec:  The ftrace record descriptor
+ *
+ * The FTRACE_FL_REGS_EN is set when the record already points to
+ * a function that saves all the regs. Basically the '_EN' version
+ * represents the current state of the function.
+ *
+ * Returns the address of the trampoline that is currently being called
+ */
+unsigned long ftrace_get_addr_curr(struct dyn_ftrace *rec)
+{
+	if (rec->flags & FTRACE_FL_REGS_EN)
+		return (unsigned long)FTRACE_REGS_ADDR;
+	else
+		return (unsigned long)FTRACE_ADDR;
+}
+
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
-- 
1.8.5.3


