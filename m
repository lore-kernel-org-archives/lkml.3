Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbaEIKFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:05:01 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55827 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790AbaEIKFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:05:00 -0400
Subject: [PATCH -tip v10.1] ftrace: Introduce FTRACE_OPS_FL_SELF_FILTER for
 ftrace-kprobe
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 09 May 2014 19:04:49 +0900
Message-ID: <20140509100449.346.34603.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140508234355.38ac66ee@gandalf.local.home>
References: <20140508234355.38ac66ee@gandalf.local.home>
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
  Samples: 1K of event 'cycles', Event count (approx.): 340068894
  +  20.77%  [k] ftrace_lookup_ip
  +   8.33%  [k] kprobe_trace_func
  +   4.83%  [k] get_kprobe_cached
  ----

With this patch, ftrace_lookup_ip() vanished from the
cycles consumer list (of course, there is no caller on
hotpath anymore :))
  ----
  Samples: 1K of event 'cycles', Event count (approx.): 186861492
  +   9.95%  [k] kprobe_trace_func
  +   6.00%  [k] kprobe_ftrace_handler
  +   5.53%  [k] get_kprobe_cached
  ----

Changes from v10:
 - Update comment of the flag according to Steven's comment.

Changes from v7:
 - Re-evaluate the performance improvement.

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
index ae9504b..5653001 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -93,6 +93,8 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * INITIALIZED - The ftrace_ops has already been initialized (first use time
  *            register_ftrace_function() is called, it will initialized the ops)
  * DELETED - The ops are being deleted, do not let them be registered again.
+ * SELF_FILTER - The ftrace_ops function has its own ip filter and does not
+ *            need to rely on the ftrace internal ip filtering.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -105,6 +107,7 @@ enum {
 	FTRACE_OPS_FL_STUB			= 1 << 7,
 	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
 	FTRACE_OPS_FL_DELETED			= 1 << 9,
+	FTRACE_OPS_FL_SELF_FILTER		= 1 << 10,
 };
 
 /*
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 0f5f23c..5c6e410 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1027,7 +1027,7 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 #ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
-	.flags = FTRACE_OPS_FL_SAVE_REGS,
+	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_SELF_FILTER,
 };
 static int kprobe_ftrace_enabled;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 4a54a25..062ca20 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4501,7 +4501,8 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
 	 */
 	preempt_disable_notrace();
 	do_for_each_ftrace_op(op, ftrace_ops_list) {
-		if (ftrace_ops_test(op, ip, regs))
+		if (op->flags & FTRACE_OPS_FL_SELF_FILTER ||
+		    ftrace_ops_test(op, ip, regs))
 			op->func(ip, parent_ip, op, regs);
 	} while_for_each_ftrace_op(op);
 	preempt_enable_notrace();


