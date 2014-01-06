Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaAFPlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:41:17 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20664 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751446AbaAFPlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:41:15 -0500
Date: Mon, 6 Jan 2014 10:41:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH] tracing/probes: Fix build break on
 !CONFIG_KPROBE_EVENT
Message-ID: <20140106104113.237f5f54@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: e0d18fe063464cb3f1a6d1939e4fcf47d92d8386


Namhyung Kim (1):
      tracing/probes: Fix build break on !CONFIG_KPROBE_EVENT

----
 kernel/trace/trace_probe.h  | 8 ++++++++
 kernel/trace/trace_uprobe.c | 8 --------
 2 files changed, 8 insertions(+), 8 deletions(-)
---------------------------
commit e0d18fe063464cb3f1a6d1939e4fcf47d92d8386
Author: Namhyung Kim <namhyung.kim@lge.com>
Date:   Fri Jan 3 14:12:46 2014 +0900

    tracing/probes: Fix build break on !CONFIG_KPROBE_EVENT
    
    When kprobe-based dynamic event tracer is not enabled, it caused
    following build error:
    
       kernel/built-in.o: In function `traceprobe_update_arg':
       (.text+0x10c8dd): undefined reference to `fetch_symbol_u8'
       kernel/built-in.o: In function `traceprobe_update_arg':
       (.text+0x10c8e9): undefined reference to `fetch_symbol_u16'
       kernel/built-in.o: In function `traceprobe_update_arg':
       (.text+0x10c8f5): undefined reference to `fetch_symbol_u32'
       kernel/built-in.o: In function `traceprobe_update_arg':
       (.text+0x10c901): undefined reference to `fetch_symbol_u64'
       kernel/built-in.o: In function `traceprobe_update_arg':
       (.text+0x10c909): undefined reference to `fetch_symbol_string'
       kernel/built-in.o: In function `traceprobe_update_arg':
       (.text+0x10c913): undefined reference to `fetch_symbol_string_size'
       ...
    
    It was due to the fetch methods are referred from CHECK_FETCH_FUNCS
    macro and since it was only defined in trace_kprobe.c.  Move NULL
    definition of such fetch functions to the header file.
    
    Note, it also requires CONFIG_BRANCH_PROFILING enabled to trigger
    this failure as well. This is because the "fetch_symbol_*" variables
    are referenced in a "else if" statement that will only call
    update_symbol_cache(), which is a static inline stub function
    when CONFIG_KPROBE_EVENT is not enabled. gcc is smart enough
    to optimize this "else if" out and that also removes the code that
    references the undefined variables.
    
    But when BRANCH_PROFILING is enabled, it fools gcc into keeping
    the if statement around and thus references the undefined symbols
    and fails to build.
    
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Signed-off-by: Namhyung Kim <namhyung@kernel.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index e29d743..b73574a 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -243,6 +243,14 @@ unsigned long update_symbol_cache(struct symbol_cache *sc);
 void free_symbol_cache(struct symbol_cache *sc);
 struct symbol_cache *alloc_symbol_cache(const char *sym, long offset);
 #else
+/* uprobes do not support symbol fetch methods */
+#define fetch_symbol_u8			NULL
+#define fetch_symbol_u16		NULL
+#define fetch_symbol_u32		NULL
+#define fetch_symbol_u64		NULL
+#define fetch_symbol_string		NULL
+#define fetch_symbol_string_size	NULL
+
 struct symbol_cache {
 };
 static inline unsigned long __used update_symbol_cache(struct symbol_cache *sc)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 1fdea6d..79e52d9 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -172,14 +172,6 @@ static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 		*(u32 *)dest = len;
 }
 
-/* uprobes do not support symbol fetch methods */
-#define fetch_symbol_u8			NULL
-#define fetch_symbol_u16		NULL
-#define fetch_symbol_u32		NULL
-#define fetch_symbol_u64		NULL
-#define fetch_symbol_string		NULL
-#define fetch_symbol_string_size	NULL
-
 static unsigned long translate_user_vaddr(void *file_offset)
 {
 	unsigned long base_addr;
