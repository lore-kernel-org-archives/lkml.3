Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3EMPV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754921Ab3EMPVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:21:21 -0400
Date: Mon, 13 May 2013 17:17:25 +0200
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
Subject: [PATCH 08/13] ptrace/x86: introduce ptrace_register_breakpoint()
Message-ID: <20130513151725.GA6280@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513151631.GA6215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation.

Extract the "register breakpoint" code from ptrace_get_debugreg()
into the new/generic helper, ptrace_register_breakpoint(). It will
have more users.

The patch also adds another simple helper, ptrace_fill_bp_fields(),
to factor out the arch_bp_generic_fields() logic in register/modify.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c |   86 ++++++++++++++++++++++++++-------------------
 1 files changed, 50 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 98b0a2c..0526368 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -601,22 +601,48 @@ static unsigned long ptrace_get_dr7(struct perf_event *bp[])
 	return dr7;
 }
 
-static int
-ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
-			 struct task_struct *tsk, int disabled)
+static int ptrace_fill_bp_fields(struct perf_event_attr *attr,
+					int len, int type, bool disabled)
+{
+	int err, bp_len, bp_type;
+
+	err = arch_bp_generic_fields(len, type, &bp_len, &bp_type);
+	if (!err) {
+		attr->bp_len = bp_len;
+		attr->bp_type = bp_type;
+		attr->disabled = disabled;
+	}
+
+	return err;
+}
+
+static struct perf_event *
+ptrace_register_breakpoint(struct task_struct *tsk, int len, int type,
+				unsigned long addr, bool disabled)
 {
-	int err;
-	int gen_len, gen_type;
 	struct perf_event_attr attr;
+	int err;
+
+	ptrace_breakpoint_init(&attr);
+	attr.bp_addr = addr;
 
-	err = arch_bp_generic_fields(len, type, &gen_len, &gen_type);
+	err = ptrace_fill_bp_fields(&attr, len, type, disabled);
 	if (err)
-		return err;
+		return ERR_PTR(err);
+
+	return register_user_hw_breakpoint(&attr, ptrace_triggered,
+						 NULL, tsk);
+}
 
-	attr = bp->attr;
-	attr.bp_len = gen_len;
-	attr.bp_type = gen_type;
-	attr.disabled = disabled;
+static int ptrace_modify_breakpoint(struct perf_event *bp, int len, int type,
+					int disabled)
+{
+	struct perf_event_attr attr = bp->attr;
+	int err;
+
+	err = ptrace_fill_bp_fields(&attr, len, type, disabled);
+	if (err)
+		return err;
 
 	return modify_user_hw_breakpoint(bp, &attr);
 }
@@ -653,7 +679,7 @@ restore:
 			break;
 		}
 
-		rc = ptrace_modify_breakpoint(bp, len, type, tsk, disabled);
+		rc = ptrace_modify_breakpoint(bp, len, type, disabled);
 		if (rc)
 			break;
 	}
@@ -693,26 +719,14 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 				      unsigned long addr)
 {
-	struct perf_event *bp;
 	struct thread_struct *t = &tsk->thread;
-	struct perf_event_attr attr;
+	struct perf_event *bp = t->ptrace_bps[nr];
 	int err = 0;
 
-	if (!t->ptrace_bps[nr]) {
-		ptrace_breakpoint_init(&attr);
-		/*
-		 * Put stub len and type to register (reserve) an inactive but
-		 * correct bp
-		 */
-		attr.bp_addr = addr;
-		attr.bp_len = HW_BREAKPOINT_LEN_1;
-		attr.bp_type = HW_BREAKPOINT_W;
-		attr.disabled = 1;
-
-		bp = register_user_hw_breakpoint(&attr, ptrace_triggered,
-						 NULL, tsk);
-
+	if (!bp) {
 		/*
+		 * Put stub len and type to create an inactive but correct bp.
+		 *
 		 * CHECKME: the previous code returned -EIO if the addr wasn't
 		 * a valid task virtual addr. The new one will return -EINVAL in
 		 *  this case.
@@ -721,20 +735,20 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 		 * writing for the user. And anyway this is the previous
 		 * behaviour.
 		 */
-		if (IS_ERR(bp)) {
+		bp = ptrace_register_breakpoint(tsk,
+				X86_BREAKPOINT_LEN_1, X86_BREAKPOINT_WRITE,
+				addr, true);
+		if (IS_ERR(bp))
 			err = PTR_ERR(bp);
-			goto out;
-		}
-
-		t->ptrace_bps[nr] = bp;
+		else
+			t->ptrace_bps[nr] = bp;
 	} else {
-		bp = t->ptrace_bps[nr];
+		struct perf_event_attr attr = bp->attr;
 
-		attr = bp->attr;
 		attr.bp_addr = addr;
 		err = modify_user_hw_breakpoint(bp, &attr);
 	}
-out:
+
 	return err;
 }
 
-- 
1.5.5.1

