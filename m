Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3LCNXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:23:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33145 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab3LCNXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:23:42 -0500
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH v5 5/8] x86: do not trace __probe_kernel_read
Date: Tue,  3 Dec 2013 14:21:24 +0100
Message-Id: <1386076887-2655-6-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
References: <1386076887-2655-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe_kernel_read is used when modifying function calls in ftrace_replace_code,
see arch/x86/kernel/ftrace.c. On x86, the code is replaced using int3 guard.
All functions are patched in parallel to reduce an expensive synchronization
of all CPUs. The result is that all affected functions are called via
ftrace_int3_handler during the process.

ftrace_int3_handler is relatively slow because it has to check whether
it is responsible for the handled IP. Therefore we should not modify
functions that used during patching. It would slowdown the patching.

I tried to switch between 7 tracers: blk, branch, function_graph, wakeup_rt,
irqsoff, function, and nop. Every tracer has also been enabled and disabled.
With 500 cycles, I got these times before this commit:

    real    18m2.477s     18m8.654s     18m9.196s
    user    0m0.008s      0m0.008s      0m0.012s
    sys     0m17.316s     0m17.104s     0m17.300s

and after this commit:

    real    16m14.390s    16m15.200s    16m19.632s
    user    0m0.028s      0m0.024s	0m0.028s
    sys     0m23.788s     0m23.812s	0m23.804s

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 mm/maccess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/maccess.c b/mm/maccess.c
index d53adf9ba84b..bed9ee854ea0 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -18,7 +18,7 @@
 long __weak probe_kernel_read(void *dst, const void *src, size_t size)
     __attribute__((alias("__probe_kernel_read")));
 
-long __probe_kernel_read(void *dst, const void *src, size_t size)
+long notrace __probe_kernel_read(void *dst, const void *src, size_t size)
 {
 	long ret;
 	mm_segment_t old_fs = get_fs();
-- 
1.8.4

