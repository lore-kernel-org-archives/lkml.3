Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532AbaJUPsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:48:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbaJUPsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:48:36 -0400
Date: Tue, 21 Oct 2014 17:48:30 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
cc: linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>
Subject: [PATCH] kprobes: add kprobe_is_function_probed()
Message-ID: <alpine.LNX.2.00.1410211744550.24255@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function that allows external users (such as live patching 
mechanisms) to check whether a given function (identified by symbol name) 
has a kprobe installed in it.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 include/linux/kprobes.h |  5 +++++
 kernel/kprobes.c        | 28 ++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index f7296e5..f760555 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -384,6 +384,7 @@ int disable_kprobe(struct kprobe *kp);
 int enable_kprobe(struct kprobe *kp);
 
 void dump_kprobe(struct kprobe *kp);
+bool kprobe_is_function_probed(const char *name);
 
 #else /* !CONFIG_KPROBES: */
 
@@ -459,6 +460,10 @@ static inline int enable_kprobe(struct kprobe *kp)
 {
 	return -ENOSYS;
 }
+static inline bool kprobe_is_function_probed(const char *name)
+{
+	return false;
+}
 #endif /* CONFIG_KPROBES */
 static inline int disable_kretprobe(struct kretprobe *rp)
 {
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3995f54..27e8ddb 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2036,6 +2036,34 @@ void dump_kprobe(struct kprobe *kp)
 NOKPROBE_SYMBOL(dump_kprobe);
 
 /*
+ * Check whether a given symbol is a probed function
+ */
+bool kprobe_is_function_probed(const char *name)
+{
+	struct hlist_head *head;
+	struct kprobe *p, *kp;
+	const char *sym = NULL;
+	unsigned long offset = 0;
+	unsigned int i;
+	char *modname, namebuf[KSYM_NAME_LEN];
+
+	preempt_disable();
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, head, hlist) {
+			sym = kallsyms_lookup((unsigned long)p->addr,
+					NULL, &offset, &modname,
+					namebuf);
+			if (!strcmp(sym, name))
+				return true;
+		}
+	}
+	preempt_enable();
+	return false;
+}
+EXPORT_SYMBOL_GPL(kprobe_is_function_probed);
+
+/*
  * Lookup and populate the kprobe_blacklist.
  *
  * Unlike the kretprobe blacklist, we'll need to determine
-- 
1.9.2
