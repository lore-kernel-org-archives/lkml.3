Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3C0Jto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:49:44 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45193 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab3C0Jtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:35 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 06/14] tracing: export syscall metadata
Date: Wed, 27 Mar 2013 17:48:48 +0800
Message-ID: <1364377737-10540-8-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Currently syscall metadata is important for kernel
syscall tracing, even mandatory, external modules may need this
metadata when perform syscall tracing(like ktap tool), so export it.

Instead of export variable syscalls_metadata, export function
syscall_nr_to_meta is more safe.

This patch also rename syscall_nr_to_meta to trace_syscall_nr_to_metadata.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/trace/syscall.h       |    1 +
 kernel/trace/trace_syscalls.c |   15 ++++++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 84bc419..428634e 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -31,4 +31,5 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };
 
+struct syscall_metadata *trace_syscall_nr_to_meta(int nr);
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 72675b1..d739471 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -98,13 +98,14 @@ find_syscall_meta(unsigned long syscall)
 	return NULL;
 }
 
-static struct syscall_metadata *syscall_nr_to_meta(int nr)
+struct syscall_metadata *trace_syscall_nr_to_meta(int nr)
 {
 	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
 		return NULL;
 
 	return syscalls_metadata[nr];
 }
+EXPORT_SYMBOL_GPL(trace_syscall_nr_to_meta);
 
 static enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags,
@@ -118,7 +119,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	entry = trace_syscall_nr_to_meta(syscall);
 
 	if (!entry)
 		goto end;
@@ -172,7 +173,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	entry = trace_syscall_nr_to_meta(syscall);
 
 	if (!entry) {
 		trace_seq_printf(s, "\n");
@@ -315,7 +316,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	if (!test_bit(syscall_nr, tr->enabled_enter_syscalls))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -349,7 +350,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!test_bit(syscall_nr, tr->enabled_exit_syscalls))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -545,7 +546,7 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
@@ -621,7 +622,7 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	sys_data = trace_syscall_nr_to_meta(syscall_nr);
 	if (!sys_data)
 		return;
 
-- 
1.7.9.7


