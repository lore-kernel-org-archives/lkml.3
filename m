Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3FQRHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:07:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab3FQRHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:07:15 -0400
Date: Mon, 17 Jun 2013 19:02:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] tracing/syscall: Avoid perf_trace_buf_*() if
	sys_data->perf_events is empty
Message-ID: <20130617170207.GA19806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617170142.GA19780@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_trace_buf_prepare() + perf_trace_buf_submit(head, task => NULL)
make no sense if hlist_empty(head). Change perf_syscall_enter/exit()
to check sys_data->{enter,exit}_event->perf_events beforehand.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_syscalls.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8f2ac73..4d1bd5d 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -553,6 +553,10 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	if (!sys_data)
 		return;
 
+	head = this_cpu_ptr(sys_data->enter_event->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	/* get the size after alignment with the u32 buffer size field */
 	size = sizeof(unsigned long) * sys_data->nb_args + sizeof(*rec);
 	size = ALIGN(size + sizeof(u32), sizeof(u64));
@@ -570,8 +574,6 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	rec->nr = syscall_nr;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
-
-	head = this_cpu_ptr(sys_data->enter_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
 
@@ -629,6 +631,10 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
+	head = this_cpu_ptr(sys_data->exit_event->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	/* We can probably do that at build time */
 	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -648,8 +654,6 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);
-
-	head = this_cpu_ptr(sys_data->exit_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }
 
-- 
1.5.5.1

