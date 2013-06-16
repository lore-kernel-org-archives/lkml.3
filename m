Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3FPR0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 13:26:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324Ab3FPR0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 13:26:03 -0400
Date: Sun, 16 Jun 2013 19:21:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tracing/kprobes: Avoid perf_trace_buf_*() if
	->perf_events is empty
Message-ID: <20130616172146.GA8533@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130616172128.GA8515@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_trace_buf_prepare() + perf_trace_buf_submit() make no sense
if this task/CPU has no active counters. Change kprobe_perf_func()
and kretprobe_perf_func() to check call->perf_events beforehand
and return if this list is empty.

For example, "perf record -e some_probe -p1". Only /sbin/init will
report, all other threads which hit the same probe will do
perf_trace_buf_prepare/perf_trace_buf_submit just to realize that
nobody wants perf_swevent_event().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_kprobe.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9f46e98..c0af476 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1157,6 +1157,10 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	int size, __size, dsize;
 	int rctx;
 
+	head = this_cpu_ptr(call->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	dsize = __get_data_size(tp, regs);
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
@@ -1172,8 +1176,6 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
-
-	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx,
 					entry->ip, 1, regs, head, NULL);
 }
@@ -1189,6 +1191,10 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	int size, __size, dsize;
 	int rctx;
 
+	head = this_cpu_ptr(call->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	dsize = __get_data_size(tp, regs);
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
@@ -1204,8 +1210,6 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
-
-	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx,
 					entry->ret_ip, 1, regs, head, NULL);
 }
-- 
1.5.5.1

