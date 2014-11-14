Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422931AbaKNXZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:25:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:59789 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935436AbaKNXZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:25:01 -0500
Message-Id: <20141114232452.539100956@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 18:24:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [for-next][PATCH 4/9] tracing: kdb: Fix kernel livelock with empty buffers
References: <20141114232401.493543108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-tracing-kdb-Fix-kernel-livelock-with-empty-buffers.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

Currently kdb's ftdump command will livelock by constantly printk'ing
the empty string at KERN_EMERG level if it run when the ftrace system is
not in use. This occurs because trace_empty() never returns false when
the ring buffers are left at the start of a non-consuming read [launched
by ring_buffer_read_start()].

This patch changes the loop exit condition to use the result of
trace_find_next_entry_inc(). Effectively this switches the non-consuming
kdb dumper to follow the approach of the non-consuming userspace
interface [s_next()] rather than the consuming ftrace_dump().

Link: http://lkml.kernel.org/r/1415277716-19419-3-git-send-email-daniel.thompson@linaro.org

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kdb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 8faa7ce58814..b0b1c44e923a 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -59,19 +59,19 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
 		tracing_iter_reset(&iter, cpu_file);
 	}
-	if (!trace_empty(&iter))
-		trace_find_next_entry_inc(&iter);
-	while (!trace_empty(&iter)) {
+
+	while (trace_find_next_entry_inc(&iter)) {
 		if (!cnt)
 			kdb_printf("---------------------------------\n");
 		cnt++;
 
-		if (trace_find_next_entry_inc(&iter) != NULL && !skip_lines)
+		if (!skip_lines) {
 			print_trace_line(&iter);
-		if (!skip_lines)
 			trace_printk_seq(&iter.seq);
-		else
+		} else {
 			skip_lines--;
+		}
+
 		if (KDB_FLAG(CMD_INTERRUPT))
 			goto out;
 	}
-- 
2.1.1


