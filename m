Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3DNTP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 15:15:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab3DNTPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 15:15:25 -0400
Date: Sun, 14 Apr 2013 21:12:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ptrace/x86: simplify the "disable" logic in
	ptrace_write_dr7()
Message-ID: <20130414191228.GA28809@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414191205.GA28791@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_write_dr7() looks unnecessarily overcomplicated. We can
factor out ptrace_modify_breakpoint() and do not do "continue"
twice, just we need to pass the proper "disabled" argument to
ptrace_modify_breakpoint().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/ptrace.c |   40 +++++++++++++++-------------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 7a98b21..0649f16 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -637,9 +637,7 @@ static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
 	struct thread_struct *thread = &(tsk->thread);
 	unsigned long old_dr7;
 	int i, orig_ret = 0, rc = 0;
-	int enabled, second_pass = 0;
-	unsigned len, type;
-	struct perf_event *bp;
+	int second_pass = 0;
 
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
@@ -649,30 +647,22 @@ restore:
 	 * appropriate changes to each.
 	 */
 	for (i = 0; i < HBP_NUM; i++) {
-		enabled = decode_dr7(data, i, &len, &type);
-		bp = thread->ptrace_bps[i];
-
-		if (!enabled) {
-			if (bp) {
-				/*
-				 * Don't unregister the breakpoints right-away,
-				 * unless all register_user_hw_breakpoint()
-				 * requests have succeeded. This prevents
-				 * any window of opportunity for debug
-				 * register grabbing by other users.
-				 */
-				if (!second_pass)
-					continue;
-
-				rc = ptrace_modify_breakpoint(bp, len, type,
-							      tsk, 1);
-				if (rc)
-					break;
-			}
-			continue;
+		unsigned len, type;
+		bool disabled = !decode_dr7(data, i, &len, &type);
+		struct perf_event *bp = thread->ptrace_bps[i];
+
+		if (disabled) {
+			/*
+			 * Don't unregister the breakpoints right-away, unless
+			 * all register_user_hw_breakpoint() requests have
+			 * succeeded. This prevents any window of opportunity
+			 * for debug register grabbing by other users.
+			 */
+			if (!bp || !second_pass)
+				continue;
 		}
 
-		rc = ptrace_modify_breakpoint(bp, len, type, tsk, 0);
+		rc = ptrace_modify_breakpoint(bp, len, type, tsk, disabled);
 		if (rc)
 			break;
 	}
-- 
1.5.5.1

