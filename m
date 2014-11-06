Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaKFMmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:42:39 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36637 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaKFMmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:42:19 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH RESEND 3.18-rc3 v2 2/2] trace: kdb: Fix kernel livelock with empty buffers
Date: Thu,  6 Nov 2014 12:41:56 +0000
Message-Id: <1415277716-19419-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
References: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
 <1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kdb's ftdump command will livelock by constantly printk'ing
the empty string at KERN_EMERG level if it run when the ftrace system is
not in use. This occurs because trace_empty() never returns false when
the ring buffers are left at the start of a non-consuming read [launched
by ring_buffer_read_start()].

This patch changes the loop exit condition to use the result of
trace_find_next_entry_inc(). Effectively this switches the non-consuming
kdb dumper to follow the approach of the non-consuming userspace
interface [s_next()] rather than the consuming ftrace_dump().

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_kdb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 8faa7ce..b0b1c44 100644
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
1.9.3

