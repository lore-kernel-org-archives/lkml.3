Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3EMPVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:21:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755035Ab3EMPVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:21:33 -0400
Date: Mon, 13 May 2013 17:17:33 +0200
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
Subject: [PATCH 10/13] ptrace/x86: cleanup ptrace_set_debugreg()
Message-ID: <20130513151733.GA6290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513151631.GA6215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ptrace_set_debugreg() is trivial but looks horrible. Kill the
unnecessary goto's and return's to cleanup the code.

This matches ptrace_get_debugreg() which also needs the trivial
whitespace cleanups.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5c387b3..7461f50 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -703,7 +703,7 @@ restore:
  */
 static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 {
-	struct thread_struct *thread = &(tsk->thread);
+	struct thread_struct *thread = &tsk->thread;
 	unsigned long val = 0;
 
 	if (n < HBP_NUM) {
@@ -713,7 +713,7 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 			val = bp->hw.info.address;
 	} else if (n == 6) {
 		val = thread->debugreg6;
-	 } else if (n == 7) {
+	} else if (n == 7) {
 		val = thread->ptrace_dr7;
 	}
 	return val;
@@ -761,30 +761,20 @@ static int ptrace_set_breakpoint_addr(struct task_struct *tsk, int nr,
 static int ptrace_set_debugreg(struct task_struct *tsk, int n,
 			       unsigned long val)
 {
-	struct thread_struct *thread = &(tsk->thread);
-	int rc = 0;
-
+	struct thread_struct *thread = &tsk->thread;
 	/* There are no DR4 or DR5 registers */
-	if (n == 4 || n == 5)
-		return -EIO;
+	int rc = -EIO;
 
-	if (n == 6) {
-		thread->debugreg6 = val;
-		goto ret_path;
-	}
 	if (n < HBP_NUM) {
 		rc = ptrace_set_breakpoint_addr(tsk, n, val);
-		if (rc)
-			return rc;
-	}
-	/* All that's left is DR7 */
-	if (n == 7) {
+	} else if (n == 6) {
+		thread->debugreg6 = val;
+		rc = 0;
+	} else if (n == 7) {
 		rc = ptrace_write_dr7(tsk, val);
 		if (!rc)
 			thread->ptrace_dr7 = val;
 	}
-
-ret_path:
 	return rc;
 }
 
-- 
1.5.5.1

