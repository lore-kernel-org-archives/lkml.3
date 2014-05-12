Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbaELPNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:13:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:27486 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758804AbaELPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:08 -0400
Message-Id: <20140512151204.455283030@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 12/13] ftrace: Remove FTRACE_UPDATE_MODIFY_CALL_REGS flag
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0012-ftrace-Remove-FTRACE_UPDATE_MODIFY_CALL_REGS-flag.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As the decision to what needs to be done (converting a call to the
ftrace_caller to ftrace_caller_regs or to convert from ftrace_caller_regs
to ftrace_caller) can easily be determined from the rec->flags of
FTRACE_FL_REGS and FTRACE_FL_REGS_EN, there's no need to have the
ftrace_check_record() return either a UPDATE_MODIFY_CALL_REGS or a
UPDATE_MODIFY_CALL. Just he latter is enough. This added flag causes
more complexity than is required. Remove it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |  3 ---
 include/linux/ftrace.h   |  2 --
 kernel/trace/ftrace.c    | 13 ++++---------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 5ef43ce..89de3ea 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -366,7 +366,6 @@ static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 		/* converting nop to call */
 		return add_brk_on_nop(rec);
 
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
 	case FTRACE_UPDATE_MAKE_NOP:
 		/* converting a call to a nop */
@@ -469,7 +468,6 @@ static int add_update(struct dyn_ftrace *rec, int enable)
 	case FTRACE_UPDATE_IGNORE:
 		return 0;
 
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
 	case FTRACE_UPDATE_MAKE_CALL:
 		/* converting nop to call */
@@ -516,7 +514,6 @@ static int finish_update(struct dyn_ftrace *rec, int enable)
 	case FTRACE_UPDATE_IGNORE:
 		return 0;
 
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
 	case FTRACE_UPDATE_MAKE_CALL:
 		/* converting nop to call */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 2f8cbff..3e6dfb3 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -362,14 +362,12 @@ enum {
  *  IGNORE           - The function is already what we want it to be
  *  MAKE_CALL        - Start tracing the function
  *  MODIFY_CALL      - Stop saving regs for the function
- *  MODIFY_CALL_REGS - Start saving regs for the function
  *  MAKE_NOP         - Stop tracing the function
  */
 enum {
 	FTRACE_UPDATE_IGNORE,
 	FTRACE_UPDATE_MAKE_CALL,
 	FTRACE_UPDATE_MODIFY_CALL,
-	FTRACE_UPDATE_MODIFY_CALL_REGS,
 	FTRACE_UPDATE_MAKE_NOP,
 };
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 52c2b53..cc07b7f 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1701,19 +1701,15 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 		/*
 		 * If this record is being updated from a nop, then
 		 *   return UPDATE_MAKE_CALL.
-		 * Otherwise, if the EN flag is set, then return
-		 *   UPDATE_MODIFY_CALL_REGS to tell the caller to convert
-		 *   from the non-save regs, to a save regs function.
 		 * Otherwise,
 		 *   return UPDATE_MODIFY_CALL to tell the caller to convert
-		 *   from the save regs, to a non-save regs function.
+		 *   from the save regs, to a non-save regs function or
+		 *   vice versa.
 		 */
 		if (flag & FTRACE_FL_ENABLED)
 			return FTRACE_UPDATE_MAKE_CALL;
-		else if (rec->flags & FTRACE_FL_REGS_EN)
-			return FTRACE_UPDATE_MODIFY_CALL_REGS;
-		else
-			return FTRACE_UPDATE_MODIFY_CALL;
+
+		return FTRACE_UPDATE_MODIFY_CALL;
 	}
 
 	if (update) {
@@ -1815,7 +1811,6 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 	case FTRACE_UPDATE_MAKE_NOP:
 		return ftrace_make_nop(NULL, rec, ftrace_addr);
 
-	case FTRACE_UPDATE_MODIFY_CALL_REGS:
 	case FTRACE_UPDATE_MODIFY_CALL:
 		return ftrace_modify_call(rec, ftrace_old_addr, ftrace_addr);
 	}
-- 
1.8.5.3


