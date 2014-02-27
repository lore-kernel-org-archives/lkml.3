Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaB0Hez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 02:34:55 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51457 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaB0HeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 02:34:22 -0500
Subject: [PATCH -tip v7 26/26] ftrace: Introduce FTRACE_OPS_FL_SELF_FILTER
 for ftrace-kprobe
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 27 Feb 2014 16:34:18 +0900
Message-ID: <20140227073418.20992.2720.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140227073315.20992.6174.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the kprobes itself owns a hash table to get a kprobe
data structure corresponding to the given ip address, there
is no need to test ftrace hash in ftrace side.
To achive better performance on ftrace-based kprobe,
FTRACE_OPS_FL_SELF_FILTER flag to ftrace_ops which means
that ftrace skips testing its own hash table.

Without this patch, ftrace_lookup_ip() is biggest cycles
consumer when 20,000 kprobes are enabled.
  ----
  Samples: 917  of event 'cycles', Event count (approx.): 427239250
  +  22.21%  [k] ftrace_lookup_ip
  +  10.22%  [k] kprobe_trace_func
  +   3.77%  [k] get_kprobe_cached
  ----

With this patch, ftrace_lookup_ip() vanished from the
cycles consumer list (of course, there is no caller on
hotpath anymore :))
  ----
  Samples: 1K of event 'cycles', Event count (approx.): 337873938
  +   7.88%  [k] kprobe_trace_func
  +   7.32%  [k] kprobe_ftrace_handler
  +   5.78%  [k] get_kprobe_cached
  ----

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/ftrace.h |    3 +++
 kernel/kprobes.c       |    2 +-
 kernel/trace/ftrace.c  |    3 ++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f4233b1..1842334 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -92,6 +92,8 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * STUB   - The ftrace_ops is just a place holder.
  * INITIALIZED - The ftrace_ops has already been initialized (first use time
  *            register_ftrace_function() is called, it will initialized the ops)
+ * SELF_FILTER - The ftrace_ops function filters ip by itself. Do not need to
+ *            check hash table on each hit.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -103,6 +105,7 @@ enum {
 	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 6,
 	FTRACE_OPS_FL_STUB			= 1 << 7,
 	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
+	FTRACE_OPS_FL_SELF_FILTER		= 1 << 9,
 };
 
 struct ftrace_ops {
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 65b18f6..2f82117 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1019,7 +1019,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 #ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
-	.flags = FTRACE_OPS_FL_SAVE_REGS,
+	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_SELF_FILTER,
 };
 static int kprobe_ftrace_enabled;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cd7f76d..2734f20 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4502,7 +4502,8 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	 */
 	preempt_disable_notrace();
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
-		if (ftrace_ops_test(op, ip, regs))
+		if (op->flags & FTRACE_OPS_FL_SELF_FILTER ||
+		    ftrace_ops_test(op, ip, regs))
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
 	preempt_enable_notrace();


