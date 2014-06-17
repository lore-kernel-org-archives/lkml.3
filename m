Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaFQLFQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 07:05:16 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52257 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbaFQLFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 07:05:05 -0400
Subject: [PATCH -tip v2 3/3] kprobes: Set IPMODIFY flag only if the probe
 can change regs->ip
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 17 Jun 2014 11:04:56 +0000
Message-ID: <20140617110456.15167.89566.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
References: <20140617110436.15167.7179.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set FTRACE_OPS_FL_IPMODIFY flag only for the probes which can change
regs->ip, which has kprobe->break_handler.
Currently only jprobe modifies regs->ip to hook a function entry
and jumps to a user handler which has same prototype of the original
function.

In other cases, kprobes restores original regs->ip when returning
to ftrace.

Note about the implementation: This uses a dummy ftrace_ops to
reserve IPMODIFY flag on the given ftrace address, for the case
that we have a enabled kprobe on a function entry and a jprobe
is added on the same point. In that case, we already have a
ftrace_ops without IPMODIFY flag on the entry, and we have to
add another ftrace_ops with IPMODIFY on the same address.
If we put a same handler on both ftrace_ops, the handler can
be called twice on that entry until the first one is removed.
This means that the kprobe and the jprobe are called twice too,
and that will not what kprobes expected.
Thus I added a dummy ftrace_ops just for reserving IPMODIFY flag.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 Documentation/kprobes.txt        |   12 ++--
 arch/x86/kernel/kprobes/ftrace.c |    9 ++-
 kernel/kprobes.c                 |  117 +++++++++++++++++++++++++++++++++-----
 3 files changed, 112 insertions(+), 26 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 4bbeca8..177f051 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -264,15 +264,13 @@ stop-machine method that ksplice uses for supporting a CONFIG_PREEMPT=y
 kernel.
 
 NOTE for geeks:
-The jump optimization changes the kprobe's pre_handler behavior.
-Without optimization, the pre_handler can change the kernel's execution
+The jump optimization (and ftrace-based kprobes) changes the kprobe's
+pre_handler behavior.
+Without optimizations, the pre_handler can change the kernel's execution
 path by changing regs->ip and returning 1.  However, when the probe
 is optimized, that modification is ignored.  Thus, if you want to
-tweak the kernel's execution path, you need to suppress optimization,
-using one of the following techniques:
-- Specify an empty function for the kprobe's post_handler or break_handler.
- or
-- Execute 'sysctl -w debug.kprobes_optimization=n'
+tweak the kernel's execution path, you need to suppress optimization or
+notify your handler will modify regs->ip by setting p->break_handler.
 
 1.5 Blacklist
 
diff --git a/arch/x86/kernel/kprobes/ftrace.c b/arch/x86/kernel/kprobes/ftrace.c
index 717b02a..5f8f0b3 100644
--- a/arch/x86/kernel/kprobes/ftrace.c
+++ b/arch/x86/kernel/kprobes/ftrace.c
@@ -27,7 +27,7 @@
 
 static nokprobe_inline
 int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
-		      struct kprobe_ctlblk *kcb)
+		      struct kprobe_ctlblk *kcb, unsigned long orig_ip)
 {
 	/*
 	 * Emulate singlestep (and also recover regs->ip)
@@ -39,6 +39,8 @@ int __skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 		p->post_handler(p, regs, 0);
 	}
 	__this_cpu_write(current_kprobe, NULL);
+	if (orig_ip)
+		regs->ip = orig_ip;
 	return 1;
 }
 
@@ -46,7 +48,7 @@ int skip_singlestep(struct kprobe *p, struct pt_regs *regs,
 		    struct kprobe_ctlblk *kcb)
 {
 	if (kprobe_ftrace(p))
-		return __skip_singlestep(p, regs, kcb);
+		return __skip_singlestep(p, regs, kcb, 0);
 	else
 		return 0;
 }
@@ -71,13 +73,14 @@ void kprobe_ftrace_handler(unsigned long ip, unsigned long parent_ip,
 	if (kprobe_running()) {
 		kprobes_inc_nmissed_count(p);
 	} else {
+		unsigned long orig_ip = regs->ip;
 		/* Kprobe handler expects regs->ip = ip + 1 as breakpoint hit */
 		regs->ip = ip + sizeof(kprobe_opcode_t);
 
 		__this_cpu_write(current_kprobe, p);
 		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
 		if (!p->pre_handler || !p->pre_handler(p, regs))
-			__skip_singlestep(p, regs, kcb);
+			__skip_singlestep(p, regs, kcb, orig_ip);
 		/*
 		 * If pre_handler returns !0, it sets regs->ip and
 		 * resets current kprobe.
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e52d86f..8ba1798 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -915,10 +915,85 @@ static struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 #ifdef CONFIG_KPROBES_ON_FTRACE
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
-	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
+	.flags = FTRACE_OPS_FL_SAVE_REGS,
 };
 static int kprobe_ftrace_enabled;
 
+static void kprobe_ftrace_stub(unsigned long a0, unsigned long a1,
+			struct ftrace_ops *op, struct pt_regs *regs)
+{
+	/* Do nothing. This is just a dummy handler */
+}
+
+/* This is only for checking conflict with other ftrace users */
+static struct ftrace_ops kprobe_ipmod_ftrace_ops __read_mostly = {
+	.func = kprobe_ftrace_stub,
+	.flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_IPMODIFY,
+};
+static int kprobe_ipmod_ftrace_enabled;
+
+static int __ftrace_add_filter_ip(struct ftrace_ops *ops, unsigned long ip,
+				  int *ref)
+{
+	int ret;
+
+	/* Try to set given ip to filter */
+	ret = ftrace_set_filter_ip(ops, ip, 0, 0);
+	if (ret >= 0) {
+		(*ref)++;
+		if (*ref == 1) {
+			ret = register_ftrace_function(ops);
+			if (ret < 0) {
+				/* Rollback refcounter and filter */
+				(*ref)--;
+				ftrace_set_filter_ip(ops, ip, 1, 0);
+			}
+		}
+	}
+
+	return ret;
+}
+
+static int __ftrace_remove_filter_ip(struct ftrace_ops *ops, unsigned long ip,
+				     int *ref)
+{
+	int ret = 0;
+
+	(*ref)--;
+	if (*ref == 0)
+		ret = unregister_ftrace_function(ops);
+	if (ret >= 0)
+		/* Try to remove given ip to filter */
+		ret = ftrace_set_filter_ip(ops, ip, 1, 0);
+	if (ret < 0)	/* Rollback refcounter if an error occurs */
+		(*ref)++;
+
+	return ret;
+}
+
+static int try_reserve_ftrace_ipmodify(struct kprobe *p)
+{
+	if (!p->break_handler)
+		return 0;
+
+	return __ftrace_add_filter_ip(&kprobe_ipmod_ftrace_ops,
+				      (unsigned long)p->addr,
+				      &kprobe_ipmod_ftrace_enabled);
+}
+
+static void release_ftrace_ipmodify(struct kprobe *p)
+{
+	int ret;
+
+	if (p->break_handler) {
+		ret = __ftrace_remove_filter_ip(&kprobe_ipmod_ftrace_ops,
+						(unsigned long)p->addr,
+						&kprobe_ipmod_ftrace_enabled);
+		WARN(ret < 0, "Failed to release ftrace at %p (%d)\n",
+		     p->addr, ret);
+	}
+}
+
 /* Must ensure p->addr is really on ftrace */
 static int prepare_kprobe(struct kprobe *p)
 {
@@ -933,14 +1008,10 @@ static void arm_kprobe_ftrace(struct kprobe *p)
 {
 	int ret;
 
-	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
-				   (unsigned long)p->addr, 0, 0);
+	ret = __ftrace_add_filter_ip(&kprobe_ftrace_ops,
+				     (unsigned long)p->addr,
+				     &kprobe_ftrace_enabled);
 	WARN(ret < 0, "Failed to arm kprobe-ftrace at %p (%d)\n", p->addr, ret);
-	kprobe_ftrace_enabled++;
-	if (kprobe_ftrace_enabled == 1) {
-		ret = register_ftrace_function(&kprobe_ftrace_ops);
-		WARN(ret < 0, "Failed to init kprobe-ftrace (%d)\n", ret);
-	}
 }
 
 /* Caller must lock kprobe_mutex */
@@ -948,17 +1019,16 @@ static void disarm_kprobe_ftrace(struct kprobe *p)
 {
 	int ret;
 
-	kprobe_ftrace_enabled--;
-	if (kprobe_ftrace_enabled == 0) {
-		ret = unregister_ftrace_function(&kprobe_ftrace_ops);
-		WARN(ret < 0, "Failed to init kprobe-ftrace (%d)\n", ret);
-	}
-	ret = ftrace_set_filter_ip(&kprobe_ftrace_ops,
-			   (unsigned long)p->addr, 1, 0);
-	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n", p->addr, ret);
+	ret = __ftrace_remove_filter_ip(&kprobe_ftrace_ops,
+					(unsigned long)p->addr,
+					&kprobe_ftrace_enabled);
+	WARN(ret < 0, "Failed to disarm kprobe-ftrace at %p (%d)\n",
+	     p->addr, ret);
 }
 #else	/* !CONFIG_KPROBES_ON_FTRACE */
 #define prepare_kprobe(p)	arch_prepare_kprobe(p)
+#define try_reserve_ftrace_ipmodify(p)	(0)
+#define release_ftrace_ipmodify(p)	do {} while (0)
 #define arm_kprobe_ftrace(p)	do {} while (0)
 #define disarm_kprobe_ftrace(p)	do {} while (0)
 #endif
@@ -1502,6 +1572,14 @@ int register_kprobe(struct kprobe *p)
 	mutex_lock(&kprobe_mutex);
 
 	old_p = get_kprobe(p->addr);
+
+	/* Try to reserve ftrace ipmodify if needed */
+	if (kprobe_ftrace(p) && (!old_p || !old_p->break_handler)) {
+		ret = try_reserve_ftrace_ipmodify(p);
+		if (ret < 0)
+			goto out_noreserve;
+	}
+
 	if (old_p) {
 		/* Since this may unoptimize old_p, locking text_mutex. */
 		ret = register_aggr_kprobe(old_p, p);
@@ -1525,6 +1603,9 @@ int register_kprobe(struct kprobe *p)
 	try_to_optimize_kprobe(p);
 
 out:
+	if (ret < 0 && kprobe_ftrace(p))
+		release_ftrace_ipmodify(p);
+out_noreserve:
 	mutex_unlock(&kprobe_mutex);
 
 	if (probed_mod)
@@ -1639,6 +1720,10 @@ static void __unregister_kprobe_bottom(struct kprobe *p)
 {
 	struct kprobe *ap;
 
+	/* Release reserved ftrace ipmodify if needed */
+	if (kprobe_ftrace(p))
+		release_ftrace_ipmodify(p);
+
 	if (list_empty(&p->list))
 		/* This is an independent kprobe */
 		arch_remove_kprobe(p);


