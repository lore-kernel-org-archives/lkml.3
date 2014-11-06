Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaKFMmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:42:21 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47976 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaKFMmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:42:17 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH RESEND 3.18-rc3 v2 1/2] trace: kdb: Fix kernel panic during ftdump
Date: Thu,  6 Nov 2014 12:41:55 +0000
Message-Id: <1415277716-19419-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
References: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
 <1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_kdb.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index bd90e1b..8faa7ce 100644
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
1.9.3

