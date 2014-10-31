Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161617AbaJaBG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:06:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:63524 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161410AbaJaBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:06:56 -0400
Date: Thu, 30 Oct 2014 21:06:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rabin Vincent <rabin@rab.in>,
        stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] tracing/syscalls: Ignore numbers outside NR_syscalls'
 range
Message-ID: <20141030210653.3fa8be01@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

ARM has system calls outside the NR_syscalls range, and the generic
tracing system does not support that and without checks, it can cause
an oops to be reported.

Rabin Vincent added checks in the return code on syscall events to make
sure that the system call number is within the range that tracing
knows about, and if not, simply ignores the system call.

The system call tracing infrastructure needs to be rewritten to handle these
cases better, but for now, to keep from oopsing, this patch will do.

Please pull the latest trace-fixes-v3.18-rc1-2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.18-rc1-2

Tag SHA1: da1591784ffa371c3fe86b55c76430914750dba2
Head SHA1: 086ba77a6db00ed858ff07451bedee197df868c9


Rabin Vincent (1):
      tracing/syscalls: Ignore numbers outside NR_syscalls' range

----
 kernel/trace/trace_syscalls.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
---------------------------
commit 086ba77a6db00ed858ff07451bedee197df868c9
Author: Rabin Vincent <rabin@rab.in>
Date:   Wed Oct 29 23:06:58 2014 +0100

    tracing/syscalls: Ignore numbers outside NR_syscalls' range
    
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
    Cc: stable@vger.kernel.org # 2.6.33+
    Signed-off-by: Rabin Vincent <rabin@rab.in>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 4dc8b79c5f75..29228c4d5696 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -313,7 +313,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 
 	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE) */
@@ -360,7 +360,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	int syscall_nr;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 
 	/* Here we're inside tp handler's rcu_read_lock_sched (__DO_TRACE()) */
@@ -567,7 +567,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
@@ -641,7 +641,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
-	if (syscall_nr < 0)
+	if (syscall_nr < 0 || syscall_nr >= NR_syscalls)
 		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
