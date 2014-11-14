Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935429AbaKNXY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 18:24:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:18275 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935395AbaKNXYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 18:24:53 -0500
Message-Id: <20141114232452.385669375@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 14 Nov 2014 18:24:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 3/9] tracing: kdb: Fix kernel panic during ftdump
References: <20141114232401.493543108@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-tracing-kdb-Fix-kernel-panic-during-ftdump.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

Currently kdb's ftdump command unconditionally crashes due to a null
pointer de-reference whenever the command is run. This in turn causes
the kernel to panic.

The abridged stacktrace (gathered with ARCH=arm) is:

--- cut here ---
[<c09535ac>] (panic) from [<c02132dc>] (die+0x264/0x440)
[<c02132dc>] (die) from [<c0952eb8>]
(__do_kernel_fault.part.11+0x74/0x84)
[<c0952eb8>] (__do_kernel_fault.part.11) from [<c021f954>]
(do_page_fault+0x1d0/0x3c4)
[<c021f954>] (do_page_fault) from [<c020846c>] (do_DataAbort+0x48/0xac)

[<c020846c>] (do_DataAbort) from [<c0213c58>] (__dabt_svc+0x38/0x60)
Exception stack(0xc0deba88 to 0xc0debad0)
ba80:                   e8c29180 00000001 e9854304 e9854300 c0f567d8
c0df2580
baa0: 00000000 00000000 00000000 c0f117b8 c0e3a3c0 c0debb0c 00000000
c0debad0
bac0: 0000672e c02f4d60 60000193 ffffffff
[<c0213c58>] (__dabt_svc) from [<c02f4d60>] (kdb_ftdump+0x1e4/0x3d8)
[<c02f4d60>] (kdb_ftdump) from [<c02ce328>] (kdb_parse+0x2b8/0x698)
[<c02ce328>] (kdb_parse) from [<c02ceef0>] (kdb_main_loop+0x52c/0x784)
[<c02ceef0>] (kdb_main_loop) from [<c02d1b0c>] (kdb_stub+0x238/0x490)
--- cut here ---

The NULL deref occurs due to the initialized use of struct trace_iter's
buffer_iter member.

This is a regression, albeit a fairly elderly one. It was introduced
by commit 6d158a813efc ("tracing: Remove NR_CPUS array from
trace_iterator").

This patch solves this by providing a collection of ring_buffer_iter(s)
and using this to initialize buffer_iter. Note that static allocation
is used solely because the trace_iter itself is also static allocated.
Static allocation also means that we have to NULL-ify the pointer during
cleanup to avoid use-after-free problems.

Link: http://lkml.kernel.org/r/1415277716-19419-2-git-send-email-daniel.thompson@linaro.org

Cc: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kdb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index bd90e1b06088..8faa7ce58814 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -20,10 +20,12 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 {
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
+	static struct ring_buffer_iter *buffer_iter[CONFIG_NR_CPUS];
 	unsigned int old_userobj;
 	int cnt = 0, cpu;
 
 	trace_init_global_iter(&iter);
+	iter.buffer_iter = buffer_iter;
 
 	for_each_tracing_cpu(cpu) {
 		atomic_inc(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
@@ -86,9 +88,12 @@ out:
 		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
 	}
 
-	for_each_tracing_cpu(cpu)
-		if (iter.buffer_iter[cpu])
+	for_each_tracing_cpu(cpu) {
+		if (iter.buffer_iter[cpu]) {
 			ring_buffer_read_finish(iter.buffer_iter[cpu]);
+			iter.buffer_iter[cpu] = NULL;
+		}
+	}
 }
 
 /*
-- 
2.1.1


