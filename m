Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445Ab3LIKyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:54:12 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36278 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab3LIKxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:53:43 -0500
Subject: [PATCH -tip v5 18/18] kprobes/x86: Use kprobe_blacklist for
 .kprobes.text and .entry.text
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Dec 2013 10:48:00 +0000
Message-ID: <20131209104800.13397.36613.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kprobe_blackpoint for blacklisting .entry.text and .kprobees.text
instead of arch_within_kprobe_blacklist. This also makes them visible
via (debugfs)/kprobes/blacklist.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/x86/kernel/kprobes/core.c |   11 +------
 include/linux/kprobes.h        |    1 +
 kernel/kprobes.c               |   64 ++++++++++++++++++++++++++++------------
 3 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index a641327..04670bb 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1069,17 +1069,10 @@ int longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(longjmp_break_handler);
 
-bool arch_within_kprobe_blacklist(unsigned long addr)
-{
-	return  (addr >= (unsigned long)__kprobes_text_start &&
-		 addr < (unsigned long)__kprobes_text_end) ||
-		(addr >= (unsigned long)__entry_text_start &&
-		 addr < (unsigned long)__entry_text_end);
-}
-
 int __init arch_init_kprobes(void)
 {
-	return 0;
+	return kprobe_blacklist_add_range((unsigned long)__entry_text_start,
+					  (unsigned long) __entry_text_end);
 }
 
 int arch_trampoline_kprobe(struct kprobe *p)
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index e059507..e81bced 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -266,6 +266,7 @@ extern int arch_init_kprobes(void);
 extern void show_registers(struct pt_regs *regs);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
 extern bool arch_within_kprobe_blacklist(unsigned long addr);
+extern int kprobe_blacklist_add_range(unsigned long start, unsigned long end);
 
 struct kprobe_insn_cache {
 	struct mutex mutex;
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 8319048..abdede5 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1325,13 +1325,6 @@ out:
 	return ret;
 }
 
-bool __weak arch_within_kprobe_blacklist(unsigned long addr)
-{
-	/* The __kprobes marked functions and entry code must not be probed */
-	return addr >= (unsigned long)__kprobes_text_start &&
-	       addr < (unsigned long)__kprobes_text_end;
-}
-
 static struct kprobe_blacklist_entry *find_blacklist_entry(unsigned long addr)
 {
 	struct kprobe_blacklist_entry *ent;
@@ -1346,8 +1339,6 @@ static struct kprobe_blacklist_entry *find_blacklist_entry(unsigned long addr)
 
 static bool within_kprobe_blacklist(unsigned long addr)
 {
-	if (arch_within_kprobe_blacklist(addr))
-		return true;
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
@@ -2032,6 +2023,40 @@ void dump_kprobe(struct kprobe *kp)
 }
 NOKPROBE_SYMBOL(dump_kprobe);
 
+static int __kprobe_blacklist_add(unsigned long start, unsigned long end)
+{
+	struct kprobe_blacklist_entry *ent;
+
+	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
+	if (!ent)
+		return -ENOMEM;
+
+	ent->start_addr = start;
+	ent->end_addr = end;
+	INIT_LIST_HEAD(&ent->list);
+	list_add_tail(&ent->list, &kprobe_blacklist);
+	return 0;
+}
+
+int kprobe_blacklist_add_range(unsigned long start, unsigned long end)
+{
+	unsigned long offset = 0, size = 0;
+	int err = 0;
+
+	mutex_lock(&kprobe_blacklist_mutex);
+	while (!err && start < end) {
+		if (!kallsyms_lookup_size_offset(start, &size, &offset) ||
+		    size == 0) {
+			err = -ENOENT;
+			break;
+		}
+		err = __kprobe_blacklist_add(start, start + size);
+		start += size;
+	}
+	mutex_unlock(&kprobe_blacklist_mutex);
+	return err;
+}
+
 /*
  * Lookup and populate the kprobe_blacklist.
  *
@@ -2043,8 +2068,8 @@ NOKPROBE_SYMBOL(dump_kprobe);
 static int populate_kprobe_blacklist(unsigned long *start, unsigned long *end)
 {
 	unsigned long *iter;
-	struct kprobe_blacklist_entry *ent;
 	unsigned long offset = 0, size = 0;
+	int ret;
 
 	mutex_lock(&kprobe_blacklist_mutex);
 	for (iter = start; iter < end; iter++) {
@@ -2052,14 +2077,7 @@ static int populate_kprobe_blacklist(unsigned long *start, unsigned long *end)
 			pr_err("Failed to find blacklist %p\n", (void *)*iter);
 			continue;
 		}
-
-		ent = kmalloc(sizeof(*ent), GFP_KERNEL);
-		if (!ent)
-			return -ENOMEM;
-		ent->start_addr = *iter;
-		ent->end_addr = *iter + size;
-		INIT_LIST_HEAD(&ent->list);
-		list_add_tail(&ent->list, &kprobe_blacklist);
+		ret = __kprobe_blacklist_add(*iter, *iter + size);
 	}
 	mutex_unlock(&kprobe_blacklist_mutex);
 
@@ -2154,7 +2172,15 @@ static int __init init_kprobes(void)
 
 	err = populate_kprobe_blacklist(__start_kprobe_blacklist,
 					__stop_kprobe_blacklist);
-	if (err) {
+
+	if (err >= 0 && __kprobes_text_start != __kprobes_text_end) {
+		/* The __kprobes marked functions must not be probed */
+		err = kprobe_blacklist_add_range(
+					(unsigned long)__kprobes_text_start,
+					(unsigned long)__kprobes_text_end);
+	}
+
+	if (err < 0) {
 		pr_err("kprobes: failed to populate blacklist: %d\n", err);
 		pr_err("Please take care of using kprobes.\n");
 	}


