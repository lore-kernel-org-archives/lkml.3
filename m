Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaAZFBZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 00:01:25 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:29821 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752515AbaAZFAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 00:00:42 -0500
Message-Id: <20140126050030.429010716@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 25 Jan 2014 23:59:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/3] tracing: Check if tracing is enabled in trace_puts()
References: <20140126045941.796589415@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Check-if-tracing-is-enabled-in-trace_puts.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If trace_puts() is used very early in boot up, it can crash the machine
if it is called before the ring buffer is allocated. If a trace_printk()
is used with no arguments, then it will be converted into a trace_puts()
and suffer the same fate.

Cc: stable@vger.kernel.org # 3.10+
Fixes: 09ae72348ecc "tracing: Add trace_puts() for even faster trace_printk() tracing"
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7857ea9..815c878 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -455,6 +455,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	unsigned long irq_flags;
 	int alloc;
 
+	if (unlikely(tracing_selftest_running || tracing_disabled))
+		return 0;
+
 	alloc = sizeof(*entry) + size + 2; /* possible \n added */
 
 	local_save_flags(irq_flags);
@@ -495,6 +498,9 @@ int __trace_bputs(unsigned long ip, const char *str)
 	unsigned long irq_flags;
 	int size = sizeof(struct bputs_entry);
 
+	if (unlikely(tracing_selftest_running || tracing_disabled))
+		return 0;
+
 	local_save_flags(irq_flags);
 	buffer = global_trace.trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_BPUTS, size,
-- 
1.8.4.3


