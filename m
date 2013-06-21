Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422725Ab3FUNjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 09:39:43 -0400
Received: from multi.imgtec.com ([194.200.65.239]:45365 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161367Ab3FUNjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 09:39:41 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, Ralf Baechle <ralf@linux-mips.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        "David Daney" <david.daney@cavium.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        <linux-mips@linux-mips.org>
Subject: [PATCH v3] kernel/signal.c: fix BUG_ON with SIG128 (MIPS)
Date: Fri, 21 Jun 2013 14:39:22 +0100
Message-ID: <1371821962-9151-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_21_14_39_38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS has 128 signals, the highest of which has the number 128 (they
start from 1). The following command causes get_signal_to_deliver() to
pass this signal number straight through to do_group_exit() as the exit
code:

  strace sleep 10 & sleep 1 && kill -128 `pidof sleep`

However do_group_exit() checks for the core dump bit (0x80) in the exit
code which matches in this particular case and the kernel panics:

  BUG_ON(exit_code & 0x80); /* core dumps don't get here */

Fundamentally the exit / wait status code cannot represent SIG128. In
fact it cannot represent SIG127 either as 0x7f represents a stopped
child.

Therefore add sig_to_exitcode() and exitcode_to_sig() functions which
map signal numbers > 126 to exit code 126 and puts the remainder (i.e.
sig - 126) in higher bits. This allows WIFSIGNALED() to return true for
both SIG127 and SIG128, and allows WTERMSIG to be later updated to read
the correct signal number for SIG127 and SIG128.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: David Daney <david.daney@cavium.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: linux-mips@linux-mips.org
---
v3:

A slightly different approach this time, closer to the original patch I
sent. This is because reducing _NSIG to 127 (like v2) still leaves
incorrect exit status codes for SIG127. The only ABI this changes is the
wait/waitpid status code, and it's in such a way that old binaries, as
long as they use the macros defined in the wait manpage, should see a
process terminated by signal 126 for SIG127 and SIG128 rather than
!WIFSIGNALED(). Software rebuilt with updated libc wait status macros
would see the correct terminating signal number.

 kernel/signal.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 113411b..212598c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -941,6 +941,32 @@ static inline int wants_signal(int sig, struct task_struct *p)
 	return task_curr(p) || !signal_pending(p);
 }
 
+/*
+ * MIPS has 128 signals which doesn't play nicely with the wait status code.
+ * There are 7 bits to store the terminating signal number, with 0 and 127
+ * having special meanings (normal termination and stopped).
+ *
+ * Since signals 127 and 128 cannot be directly represented, cap the signal
+ * number to 126 (so WIFSIGNALED works) and store remainder in some higher bits.
+ */
+
+static inline int exitcode_to_sig(int exit_code)
+{
+#if _NSIG > 126
+	exit_code = (exit_code & 0x7f) + ((exit_code >> 16) & 0xff);
+#endif
+	return exit_code;
+}
+
+static inline int sig_to_exitcode(int sig)
+{
+#if _NSIG > 126
+	if (sig > 126)
+		sig = 126 | (sig - 126) << 16;
+#endif
+	return sig;
+}
+
 static void complete_signal(int sig, struct task_struct *p, int group)
 {
 	struct signal_struct *signal = p->signal;
@@ -997,7 +1023,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 			 * thread has the fatal signal pending.
 			 */
 			signal->flags = SIGNAL_GROUP_EXIT;
-			signal->group_exit_code = sig;
+			signal->group_exit_code = sig_to_exitcode(sig);
 			signal->group_stop_count = 0;
 			t = p;
 			do {
@@ -1770,7 +1796,7 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
  		info.si_status = SIGCONT;
  		break;
  	case CLD_STOPPED:
- 		info.si_status = tsk->signal->group_exit_code & 0x7f;
+		info.si_status = exitcode_to_sig(tsk->signal->group_exit_code);
  		break;
  	case CLD_TRAPPED:
  		info.si_status = tsk->exit_code & 0x7f;
@@ -2367,7 +2393,7 @@ relock:
 		/*
 		 * Death signals, no core dump.
 		 */
-		do_group_exit(info->si_signo);
+		do_group_exit(sig_to_exitcode(info->si_signo));
 		/* NOTREACHED */
 	}
 	spin_unlock_irq(&sighand->siglock);
-- 
1.8.1.2


