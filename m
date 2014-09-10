Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaIJOo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:44:57 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38653 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaIJOoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:44:55 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3.17-rc4] trace: kdb: Fix kernel panic during ftdump
Date: Wed, 10 Sep 2014 15:44:07 +0100
Message-Id: <1410360247-13791-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
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

This patch solves this by providing a collection of ring_buffer_iter(s)
and using this to initialized buffer_iter. Note that static allocation
is used solely because the trace_iter itself is also static allocated.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_kdb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index bd90e1b..989288a 100644
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
--
1.9.3

