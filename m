Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3EMPWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:22:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab3EMPVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:21:38 -0400
Date: Mon, 13 May 2013 17:17:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/13] ptrace/x86: dont delay "disable" till second pass in
	ptrace_write_dr7()
Message-ID: <20130513151721.GA6273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513151631.GA6215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_write_dr7() skips ptrace_modify_breakpoint(disabled => true)
unless second_pass, this buys nothing but complicates the code and
means that we always do the main loop twice even if "disabled" was
never true.

The comment says:

	Don't unregister the breakpoints right-away,
	unless all register_user_hw_breakpoint()
	requests have succeeded.

Firstly, we do not do register_user_hw_breakpoint(), it was removed
by 24f1e32c "hw-breakpoints: Rewrite the hw-breakpoints layer on top
of perf events".

We are going to restore register_user_hw_breakpoint() (see the next
patch) but this doesn't matter, after 44234adc "hw-breakpoints: Modify
breakpoints without unregistering them" perf_event_disable() can not
hurt, hw_breakpoint_del() does not free the slot.

Remove the "second_pass" check from the main loop and simplify the
code. Since we have to check "bp != NULL" anyway, the patch also
removes the same check in ptrace_modify_breakpoint() and moves the
comment into ptrace_write_dr7().

With this patch the second pass is only needed to restore the saved
old_dr7. This should never fail, so the patch adds WARN_ON() to catch
the potential problems as Frederic suggested.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c |   53 +++++++++++++++++----------------------------
 1 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0649f16..98b0a2c 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -609,14 +609,6 @@ ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
 	int gen_len, gen_type;
 	struct perf_event_attr attr;
 
-	/*
-	 * We should have at least an inactive breakpoint at this
-	 * slot. It means the user is writing dr7 without having
-	 * written the address register first
-	 */
-	if (!bp)
-		return -EINVAL;
-
 	err = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
 	if (err)
 		return err;
@@ -634,52 +626,47 @@ ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
  */
 static int ptrace_write_dr7(struct task_struct *tsk, unsigned long data)
 {
-	struct thread_struct *thread = &(tsk->thread);
+	struct thread_struct *thread = &tsk->thread;
 	unsigned long old_dr7;
-	int i, orig_ret = 0, rc = 0;
-	int second_pass = 0;
+	bool second_pass = false;
+	int i, rc, ret = 0;
 
 	data &= ~DR_CONTROL_RESERVED;
 	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
+
 restore:
-	/*
-	 * Loop through all the hardware breakpoints, making the
-	 * appropriate changes to each.
-	 */
+	rc = 0;
 	for (i = 0; i < HBP_NUM; i++) {
 		unsigned len, type;
 		bool disabled = !decode_dr7(data, i, &len, &type);
 		struct perf_event *bp = thread->ptrace_bps[i];
 
-		if (disabled) {
+		if (!bp) {
+			if (disabled)
+				continue;
 			/*
-			 * Don't unregister the breakpoints right-away, unless
-			 * all register_user_hw_breakpoint() requests have
-			 * succeeded. This prevents any window of opportunity
-			 * for debug register grabbing by other users.
+			 * We should have at least an inactive breakpoint at
+			 * this slot. It means the user is writing dr7 without
+			 * having written the address register first.
 			 */
-			if (!bp || !second_pass)
-				continue;
+			rc = -EINVAL;
+			break;
 		}
 
 		rc = ptrace_modify_breakpoint(bp, len, type, tsk, disabled);
 		if (rc)
 			break;
 	}
-	/*
-	 * Make a second pass to free the remaining unused breakpoints
-	 * or to restore the original breakpoints if an error occurred.
-	 */
-	if (!second_pass) {
-		second_pass = 1;
-		if (rc < 0) {
-			orig_ret = rc;
-			data = old_dr7;
-		}
+
+	/* Restore if the first pass failed, second_pass shouldn't fail. */
+	if (rc && !WARN_ON(second_pass)) {
+		ret = rc;
+		data = old_dr7;
+		second_pass = true;
 		goto restore;
 	}
 
-	return orig_ret < 0 ? orig_ret : rc;
+	return ret;
 }
 
 /*
-- 
1.5.5.1

