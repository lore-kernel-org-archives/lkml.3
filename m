Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab3GBU0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:26:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33065 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab3GBUY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:28 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=oHkucnw5I60A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Su328q2Qjh8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=3nbZYyFuAAAA:8 a=wniiS7EUZDIcOveDR-UA:9 a=jEp0ucaQiEUA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202425.507708254@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 02/14] tracing/kprobes: Avoid perf_trace_buf_*() if ->perf_events is empty
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-kprobes-Avoid-perf_trace_buf_-if-perf_events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

perf_trace_buf_prepare() + perf_trace_buf_submit() make no sense
if this task/CPU has no active counters. Change kprobe_perf_func()
and kretprobe_perf_func() to check call->perf_events beforehand
and return if this list is empty.

For example, "perf record -e some_probe -p1". Only /sbin/init will
report, all other threads which hit the same probe will do
perf_trace_buf_prepare/perf_trace_buf_submit just to realize that
nobody wants perf_swevent_event().

Link: http://lkml.kernel.org/r/20130620173806.GA13151@redhat.com

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f237417..c35bebe 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1156,6 +1156,10 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	int size, __size, dsize;
 	int rctx;
 
+	head = this_cpu_ptr(call->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	dsize = __get_data_size(tp, regs);
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
@@ -1171,8 +1175,6 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
-
-	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx,
 					entry->ip, 1, regs, head, NULL);
 }
@@ -1188,6 +1190,10 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	int size, __size, dsize;
 	int rctx;
 
+	head = this_cpu_ptr(call->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	dsize = __get_data_size(tp, regs);
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
@@ -1203,8 +1209,6 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
-
-	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx,
 					entry->ret_ip, 1, regs, head, NULL);
 }
-- 
1.7.10.4


