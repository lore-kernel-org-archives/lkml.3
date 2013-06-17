Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3FQDtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:49:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:11580 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab3FQDtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:49:21 -0400
Message-ID: <51BE857A.1080505@huawei.com>
Date: Mon, 17 Jun 2013 11:41:46 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] tracing/kprobes: Avoid perf_trace_buf_*() if ->perf_events
 is empty
References: <20130616172146.GA8533@redhat.com>
In-Reply-To: <20130616172146.GA8533@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/17 1:21, Oleg Nesterov wrote:
> perf_trace_buf_prepare() + perf_trace_buf_submit() make no sense
> if this task/CPU has no active counters. Change kprobe_perf_func()
> and kretprobe_perf_func() to check call->perf_events beforehand
> and return if this list is empty.
> 
> For example, "perf record -e some_probe -p1". Only /sbin/init will
> report, all other threads which hit the same probe will do
> perf_trace_buf_prepare/perf_trace_buf_submit just to realize that
> nobody wants perf_swevent_event().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Good point, I think we also need to change other places in below patch.

After applied the patch, perf_tp_event() function call reduced a lots
when using task based perf tracing.


-----------------------------------


tracing: Avoid perf_trace_buf_*() if ->perf_events is empty


Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/trace/ftrace.h        |    5 ++++-
 kernel/trace/trace_syscalls.c |   10 ++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 19edd7f..5d340f5 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -659,6 +659,10 @@ perf_trace_##call(void *__data, proto)					\
 	int __data_size;						\
 	int rctx;							\
 									\
+	head = this_cpu_ptr(event_call->perf_events);			\
+	if (hlist_empty(head))						\
+		return;							\
+									\
 	perf_fetch_caller_regs(&__regs);				\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
@@ -679,7 +683,6 @@ perf_trace_##call(void *__data, proto)					\
 									\
 	{ assign; }							\
 									\
-	head = this_cpu_ptr(event_call->perf_events);			\
 	perf_trace_buf_submit(entry, __entry_size, rctx, __addr,	\
 		__count, &__regs, head, __task);			\
 }
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8f2ac73..28debf4 100644
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
@@ -571,7 +575,6 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);

-	head = this_cpu_ptr(sys_data->enter_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }

@@ -629,6 +632,10 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;

+	head = this_cpu_ptr(sys_data->exit_event->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	/* We can probably do that at build time */
 	size = ALIGN(sizeof(*rec) + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -649,7 +656,6 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	rec->nr = syscall_nr;
 	rec->ret = syscall_get_return_value(current, regs);

-	head = this_cpu_ptr(sys_data->exit_event->perf_events);
 	perf_trace_buf_submit(rec, size, rctx, 0, 1, regs, head, NULL);
 }

-- 
1.7.9.7



