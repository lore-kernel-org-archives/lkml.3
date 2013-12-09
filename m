Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018Ab3LIKxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:53:46 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36258 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933218Ab3LIKxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:53:38 -0500
Subject: [PATCH -tip v5 16/18] kprobes: Support blacklist functions in module
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Rob Landley <rob@landley.net>, systemtap@sourceware.org,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Dec 2013 10:47:55 +0000
Message-ID: <20131209104755.13397.96977.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To blacklist the functions in a module (e.g. user-defined
kprobe handler and the functions invoked from it), expand
blacklist support for modules.
With this change, users can use NOKPROBE_SYMBOL() macro in
their own modules.

Changes from previous:
 - Update shrink_blacklist according to the blacklist
   implementation changes.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rob Landley <rob@landley.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/kprobes.txt |    8 ++++++
 include/linux/module.h    |    5 ++++
 kernel/kprobes.c          |   63 ++++++++++++++++++++++++++++++++++++++-------
 kernel/module.c           |    6 ++++
 4 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 7062631..c6634b3 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -512,6 +512,14 @@ int enable_jprobe(struct jprobe *jp);
 Enables *probe which has been disabled by disable_*probe(). You must specify
 the probe which has been registered.
 
+4.9 NOKPROBE_SYMBOL()
+
+#include <linux/kprobes.h>
+NOKPROBE_SYMBOL(FUNCTION);
+
+Protects given FUNCTION from other kprobes. This is useful for handler
+functions and functions called from the handlers.
+
 5. Kprobes Features and Limitations
 
 Kprobes allows multiple probes at the same address.  Currently,
diff --git a/include/linux/module.h b/include/linux/module.h
index 15cd6b1..33a6451 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/tracepoint.h>
+#include <linux/kprobes.h>
 #include <linux/export.h>
 
 #include <linux/percpu.h>
@@ -360,6 +361,10 @@ struct module
 	unsigned int num_ftrace_callsites;
 	unsigned long *ftrace_callsites;
 #endif
+#ifdef CONFIG_KPROBES
+	unsigned int num_kprobe_blacklist;
+	unsigned long  *kprobe_blacklist;
+#endif
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* What modules depend on me? */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3214289..8319048 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -88,6 +88,7 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 
 /* Blacklist -- list of struct kprobe_blacklist_entry */
 static LIST_HEAD(kprobe_blacklist);
+static DEFINE_MUTEX(kprobe_blacklist_mutex);
 
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
@@ -1331,22 +1332,27 @@ bool __weak arch_within_kprobe_blacklist(unsigned long addr)
 	       addr < (unsigned long)__kprobes_text_end;
 }
 
-static bool within_kprobe_blacklist(unsigned long addr)
+static struct kprobe_blacklist_entry *find_blacklist_entry(unsigned long addr)
 {
 	struct kprobe_blacklist_entry *ent;
 
+	list_for_each_entry(ent, &kprobe_blacklist, list) {
+		if (addr >= ent->start_addr && addr < ent->end_addr)
+			return ent;
+	}
+
+	return NULL;
+}
+
+static bool within_kprobe_blacklist(unsigned long addr)
+{
 	if (arch_within_kprobe_blacklist(addr))
 		return true;
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
 	 */
-	list_for_each_entry(ent, &kprobe_blacklist, list) {
-		if (addr >= ent->start_addr && addr < ent->end_addr)
-			return true;
-	}
-
-	return false;
+	return !!find_blacklist_entry(addr);
 }
 
 /*
@@ -1432,6 +1438,7 @@ static int check_kprobe_address_safe(struct kprobe *p,
 #endif
 	}
 
+	mutex_lock(&kprobe_blacklist_mutex);
 	jump_label_lock();
 	preempt_disable();
 
@@ -1469,6 +1476,7 @@ static int check_kprobe_address_safe(struct kprobe *p,
 out:
 	preempt_enable();
 	jump_label_unlock();
+	mutex_unlock(&kprobe_blacklist_mutex);
 
 	return ret;
 }
@@ -2032,13 +2040,13 @@ NOKPROBE_SYMBOL(dump_kprobe);
  * since a kprobe need not necessarily be at the beginning
  * of a function.
  */
-static int __init populate_kprobe_blacklist(unsigned long *start,
-					     unsigned long *end)
+static int populate_kprobe_blacklist(unsigned long *start, unsigned long *end)
 {
 	unsigned long *iter;
 	struct kprobe_blacklist_entry *ent;
 	unsigned long offset = 0, size = 0;
 
+	mutex_lock(&kprobe_blacklist_mutex);
 	for (iter = start; iter < end; iter++) {
 		if (!kallsyms_lookup_size_offset(*iter, &size, &offset)) {
 			pr_err("Failed to find blacklist %p\n", (void *)*iter);
@@ -2053,9 +2061,28 @@ static int __init populate_kprobe_blacklist(unsigned long *start,
 		INIT_LIST_HEAD(&ent->list);
 		list_add_tail(&ent->list, &kprobe_blacklist);
 	}
+	mutex_unlock(&kprobe_blacklist_mutex);
+
 	return 0;
 }
 
+/* Shrink the blacklist */
+static void shrink_kprobe_blacklist(unsigned long *start, unsigned long *end)
+{
+	struct kprobe_blacklist_entry *ent;
+	unsigned long *iter;
+
+	mutex_lock(&kprobe_blacklist_mutex);
+	for (iter = start; iter < end; iter++) {
+		ent = find_blacklist_entry(*iter);
+		if (!ent)
+			continue;
+		list_del(&ent->list);
+		kfree(ent);
+	}
+	mutex_unlock(&kprobe_blacklist_mutex);
+}
+
 /* Module notifier call back, checking kprobes on the module */
 static int kprobes_module_callback(struct notifier_block *nb,
 				   unsigned long val, void *data)
@@ -2066,6 +2093,16 @@ static int kprobes_module_callback(struct notifier_block *nb,
 	unsigned int i;
 	int checkcore = (val == MODULE_STATE_GOING);
 
+	/* Add/remove module blacklist */
+	if (val == MODULE_STATE_COMING)
+		populate_kprobe_blacklist(mod->kprobe_blacklist,
+					  mod->kprobe_blacklist +
+					  mod->num_kprobe_blacklist);
+	else if (val == MODULE_STATE_GOING)
+		shrink_kprobe_blacklist(mod->kprobe_blacklist,
+					mod->kprobe_blacklist +
+					mod->num_kprobe_blacklist);
+
 	if (val != MODULE_STATE_GOING && val != MODULE_STATE_LIVE)
 		return NOTIFY_DONE;
 
@@ -2252,6 +2289,7 @@ static const struct file_operations debugfs_kprobes_operations = {
 /* kprobes/blacklist -- shows which functions can not be probed */
 static void *kprobe_blacklist_seq_start(struct seq_file *m, loff_t *pos)
 {
+	mutex_lock(&kprobe_blacklist_mutex);
 	return seq_list_start(&kprobe_blacklist, *pos);
 }
 
@@ -2260,6 +2298,11 @@ static void *kprobe_blacklist_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	return seq_list_next(v, &kprobe_blacklist, pos);
 }
 
+static void kprobe_blacklist_seq_stop(struct seq_file *m, void *v)
+{
+	mutex_unlock(&kprobe_blacklist_mutex);
+}
+
 static int kprobe_blacklist_seq_show(struct seq_file *m, void *v)
 {
 	struct kprobe_blacklist_entry *ent =
@@ -2273,7 +2316,7 @@ static int kprobe_blacklist_seq_show(struct seq_file *m, void *v)
 static const struct seq_operations kprobe_blacklist_seq_ops = {
 	.start = kprobe_blacklist_seq_start,
 	.next  = kprobe_blacklist_seq_next,
-	.stop  = kprobe_seq_stop,	/* Reuse void function */
+	.stop  = kprobe_blacklist_seq_stop,
 	.show  = kprobe_blacklist_seq_show,
 };
 
diff --git a/kernel/module.c b/kernel/module.c
index f5a3b1e..76be47d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -58,6 +58,7 @@
 #include <linux/percpu.h>
 #include <linux/kmemleak.h>
 #include <linux/jump_label.h>
+#include <linux/kprobes.h>
 #include <linux/pfn.h>
 #include <linux/bsearch.h>
 #include <linux/fips.h>
@@ -2768,6 +2769,11 @@ static int find_module_sections(struct module *mod, struct load_info *info)
 					     sizeof(*mod->ftrace_callsites),
 					     &mod->num_ftrace_callsites);
 #endif
+#ifdef CONFIG_KPROBES
+	mod->kprobe_blacklist = section_objs(info, "_kprobe_blacklist",
+					     sizeof(*mod->kprobe_blacklist),
+					     &mod->num_kprobe_blacklist);
+#endif
 
 	mod->extable = section_objs(info, "__ex_table",
 				    sizeof(*mod->extable), &mod->num_exentries);


