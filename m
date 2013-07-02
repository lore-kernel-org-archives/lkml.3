Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab3GBUYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:24:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab3GBUYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:31 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=6Acex7qkhjIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=8jHTo664lQoA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=tgebEE9ePry_H1rURlcA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202426.628771872@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [for-next][PATCH 09/14] tracing/kprobes: Dont pass addr=ip to perf_trace_buf_submit()
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-kprobes-Don-t-pass-addr-ip-to-perf_trace_buf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

kprobe_perf_func() and kretprobe_perf_func() pass addr=ip to
perf_trace_buf_submit() for no reason.

This sets perf_sample_data->addr for PERF_SAMPLE_ADDR, we already
have perf_sample_data->ip initialized if PERF_SAMPLE_IP.

Link: http://lkml.kernel.org/r/20130620173811.GA13161@redhat.com

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 405b5b0..7ed6976 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1098,8 +1098,7 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
-	perf_trace_buf_submit(entry, size, rctx,
-					entry->ip, 1, regs, head, NULL);
+	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 
 /* Kretprobe profile handler */
@@ -1132,8 +1131,7 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
-	perf_trace_buf_submit(entry, size, rctx,
-					entry->ret_ip, 1, regs, head, NULL);
+	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
-- 
1.7.10.4


