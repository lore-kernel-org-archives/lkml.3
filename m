Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3KTEWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:22:36 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59874 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab3KTEWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:22:04 -0500
Subject: [PATCH -tip v3 04/23] kprobes: Support blacklist functions in module
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Rob Landley <rob@landley.net>, systemtap@sourceware.org,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Nov 2013 04:21:59 +0000
Message-ID: <20131120042159.15296.80748.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
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
 - Fix the type of kprobe_blacklist_seq_stop()

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rob Landley <rob@landley.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/kprobes.txt |    8 ++++++++
 include/linux/module.h    |    5 +++++
 kernel/kprobes.c          |   44 +++++++++++++++++++++++++++++++++++++++++---
 kernel/module.c           |    6 ++++++
 4 files changed, 60 insertions(+), 3 deletions(-)

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
index 05f2447..acb682b 100644
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
+	struct kprobe_blackpoint **kprobe_blacklist;
+	unsigned int num_kprobe_blacklist;
+#endif
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* What modules depend on me? */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index d34744e..eb9b938 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -88,6 +88,7 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 
 /* Blacklist -- list of struct kprobe_blackpoint */
 static LIST_HEAD(kprobe_blacklist);
+static DEFINE_MUTEX(kprobe_blacklist_mutex);
 
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
@@ -1420,6 +1421,7 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
 #endif
 	}
 
+	mutex_lock(&kprobe_blacklist_mutex);
 	jump_label_lock();
 	preempt_disable();
 
@@ -1457,6 +1459,7 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
 out:
 	preempt_enable();
 	jump_label_unlock();
+	mutex_unlock(&kprobe_blacklist_mutex);
 
 	return ret;
 }
@@ -2011,6 +2014,11 @@ void __kprobes dump_kprobe(struct kprobe *kp)
 	       kp->symbol_name, kp->addr, kp->offset);
 }
 
+static void populate_kprobe_blacklist(struct kprobe_blackpoint **start,
+				      struct kprobe_blackpoint **end);
+static void shrink_kprobe_blacklist(struct kprobe_blackpoint **start,
+				    struct kprobe_blackpoint **end);
+
 /* Module notifier call back, checking kprobes on the module */
 static int __kprobes kprobes_module_callback(struct notifier_block *nb,
 					     unsigned long val, void *data)
@@ -2021,6 +2029,16 @@ static int __kprobes kprobes_module_callback(struct notifier_block *nb,
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
 
@@ -2054,6 +2072,18 @@ static struct notifier_block kprobe_module_nb = {
 	.priority = 0
 };
 
+/* Shrink the blacklist */
+static void shrink_kprobe_blacklist(struct kprobe_blackpoint **start,
+				    struct kprobe_blackpoint **end)
+{
+	struct kprobe_blackpoint **iter;
+
+	mutex_lock(&kprobe_blacklist_mutex);
+	for (iter = start; (unsigned long)iter < (unsigned long)end; iter++)
+		list_del(&(*iter)->list);
+	mutex_unlock(&kprobe_blacklist_mutex);
+}
+
 /*
  * Lookup and populate the kprobe_blacklist.
  *
@@ -2062,14 +2092,15 @@ static struct notifier_block kprobe_module_nb = {
  * since a kprobe need not necessarily be at the beginning
  * of a function.
  */
-static void __init populate_kprobe_blacklist(struct kprobe_blackpoint **start,
-					     struct kprobe_blackpoint **end)
+static void populate_kprobe_blacklist(struct kprobe_blackpoint **start,
+				      struct kprobe_blackpoint **end)
 {
 	struct kprobe_blackpoint **iter, *bp;
 	unsigned long offset = 0, size = 0;
 	char *modname, namebuf[128];
 	const char *symbol_name;
 
+	mutex_lock(&kprobe_blacklist_mutex);
 	for (iter = start; (unsigned long)iter < (unsigned long)end; iter++) {
 		bp = *iter;
 		symbol_name = kallsyms_lookup(bp->start_addr,
@@ -2081,6 +2112,7 @@ static void __init populate_kprobe_blacklist(struct kprobe_blackpoint **start,
 		INIT_LIST_HEAD(&bp->list);
 		list_add_tail(&bp->list, &kprobe_blacklist);
 	}
+	mutex_unlock(&kprobe_blacklist_mutex);
 }
 
 extern struct kprobe_blackpoint *__start_kprobe_blacklist[];
@@ -2231,6 +2263,7 @@ static const struct file_operations debugfs_kprobes_operations = {
 /* kprobes/blacklist -- shows which functions can not be probed */
 static void *kprobe_blacklist_seq_start(struct seq_file *m, loff_t *pos)
 {
+	mutex_lock(&kprobe_blacklist_mutex);
 	return seq_list_start(&kprobe_blacklist, *pos);
 }
 
@@ -2239,6 +2272,11 @@ static void *kprobe_blacklist_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	return seq_list_next(v, &kprobe_blacklist, pos);
 }
 
+static void kprobe_blacklist_seq_stop(struct seq_file *m, void *v)
+{
+	mutex_unlock(&kprobe_blacklist_mutex);
+}
+
 static int kprobe_blacklist_seq_show(struct seq_file *m, void *v)
 {
 	struct kprobe_blackpoint *bp =
@@ -2252,7 +2290,7 @@ static int kprobe_blacklist_seq_show(struct seq_file *m, void *v)
 static const struct seq_operations kprobe_blacklist_seq_ops = {
 	.start = kprobe_blacklist_seq_start,
 	.next  = kprobe_blacklist_seq_next,
-	.stop  = kprobe_seq_stop,	/* Reuse void function */
+	.stop  = kprobe_blacklist_seq_stop,
 	.show  = kprobe_blacklist_seq_show,
 };
 
diff --git a/kernel/module.c b/kernel/module.c
index dc58274..4cc844c 100644
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
@@ -2796,6 +2797,11 @@ static void find_module_sections(struct module *mod, struct load_info *info)
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


