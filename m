Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965431AbaLLG1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:27:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52043 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759377AbaLLGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steven Rostedt" <rostedt@goodmis.org>,
        "Rabin Vincent" <rabin@rab.in>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.39091769@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 103/164] tracing/syscalls: Ignore numbers outside
 NR_syscalls' range
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin@rab.in>

commit 086ba77a6db00ed858ff07451bedee197df868c9 upstream.

ARM has some private syscalls (for example, set_tls(2)) which lie
outside the range of NR_syscalls.  If any of these are called while
syscall tracing is being performed, out-of-bounds array access will
occur in the ftrace and perf sys_{enter,exit} handlers.

 # trace-cmd record -e raw_syscalls:* true && trace-cmd report
 ...
 true-653   [000]   384.675777: sys_enter:            NR 192 (0, 1000, 3, 4000022, ffffffff, 0)
 true-653   [000]   384.675812: sys_exit:             NR 192 = 1995915264
 true-653   [000]   384.675971: sys_enter:            NR 983045 (76f74480, 76f74000, 76f74b28, 76f74480, 76f76f74, 1)
 true-653   [000]   384.675988: sys_exit:             NR 983045 = 0
 ...

 # trace-cmd record -e syscalls:* true
 [   17.289329] Unable to handle kernel paging request at virtual address aaaaaace
 [   17.289590] pgd = 9e71c000
 [   17.289696] [aaaaaace] *pgd=00000000
 [   17.289985] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
 [   17.290169] Modules linked in:
 [   17.290391] CPU: 0 PID: 704 Comm: true Not tainted 3.18.0-rc2+ #21
 [   17.290585] task: 9f4dab00 ti: 9e710000 task.ti: 9e710000
 [   17.290747] PC is at ftrace_syscall_enter+0x48/0x1f8
 [   17.290866] LR is at syscall_trace_enter+0x124/0x184

Fix this by ignoring out-of-NR_syscalls-bounds syscall numbers.

Commit cd0980fc8add "tracing: Check invalid syscall nr while tracing syscalls"
added the check for less than zero, but it should have also checked
for greater than NR_syscalls.

Link: http://lkml.kernel.org/p/1414620418-29472-1-git-send-email-rabin@rab.in

Fixes: cd0980fc8add "tracing: Check invalid syscall nr while tracing syscalls"
Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace_syscalls.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -309,7 +309,7 @@ void ftrace_syscall_enter(void *ignore,
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_enter_syscalls))
 		return;
@@ -349,7 +349,7 @@ void ftrace_syscall_exit(void *ignore, s
 	int syscall_nr;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_exit_syscalls))
 		return;
@@ -519,7 +519,7 @@ static void perf_syscall_enter(void *ign
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
@@ -595,7 +595,7 @@ static void perf_syscall_exit(void *igno
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;

