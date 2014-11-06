Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaKFWmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:42:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58878 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaKFWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:32 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rabin Vincent <rabin@rab.in>, Steven Rostedt <rostedt@goodmis.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 159/162] tracing/syscalls: Ignore numbers outside NR_syscalls' range
Date: Thu,  6 Nov 2014 14:37:03 -0800
Message-Id: <1415313426-9622-160-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/trace/trace_syscalls.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index ea90eb5..7708669 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -313,7 +313,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 
 	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE) */
@@ -361,7 +361,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	int syscall_nr;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 
 	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE()) */
@@ -569,7 +569,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
@@ -643,7 +643,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
-- 
1.9.1

