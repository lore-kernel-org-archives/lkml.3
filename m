Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab3KTEZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:25:25 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60166 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3KTEWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:22:51 -0500
Subject: [PATCH -tip v3 23/23] kprobes/x86: Use kprobe_blacklist for
 .kprobes.text and .entry.text
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 20 Nov 2013 04:22:46 +0000
Message-ID: <20131120042246.15296.87880.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
References: <20131120042148.15296.88360.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kprobe_blackpoint for blacklisting .entry.text and .kprobes.text
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
 arch/x86/kernel/kprobes/core.c |   14 +++++++-------
 include/linux/kprobes.h        |    1 +
 kernel/kprobes.c               |   40 +++++++++++++++++++++++++++++-----------
 3 files changed, 37 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 54ada0b..adb0e26 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -1087,16 +1087,16 @@ int longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 }
 NOKPROBE_SYMBOL(longjmp_break_handler);
 
-bool arch_within_kprobe_blacklist(unsigned long addr)
-{
-	return ((addr >= (unsigned long)__kprobes_text_start &&
-		 addr < (unsigned long)__kprobes_text_end) ||
-		(addr >= (unsigned long)__entry_text_start &&
-		 addr < (unsigned long)__entry_text_end));
-}
+static struct kprobe_blackpoint kbp_entry_text = {
+	.name = ".entry.text",
+};
 
 int __init arch_init_kprobes(void)
 {
+	kbp_entry_text.start_addr = (unsigned long)__entry_text_start;
+	kbp_entry_text.range = (unsigned long)__entry_text_end -
+				(unsigned long)__entry_text_start;
+	add_kprobe_blacklist(&kbp_entry_text);
 	return 0;
 }
 
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 641d009..19be202 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -267,6 +267,7 @@ extern int arch_init_kprobes(void);
 extern void show_registers(struct pt_regs *regs);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
 extern bool arch_within_kprobe_blacklist(unsigned long addr);
+extern void add_kprobe_blacklist(struct kprobe_blackpoint *bp);
 
 struct kprobe_insn_cache {
 	struct mutex mutex;
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 0a206ec..895cc8a 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1325,19 +1325,10 @@ out:
 	return ret;
 }
 
-bool __weak arch_within_kprobe_blacklist(unsigned long addr)
-{
-	/* The __kprobes marked functions and entry code must not be probed */
-	return (addr >= (unsigned long)__kprobes_text_start &&
-		addr < (unsigned long)__kprobes_text_end);
-}
-
 static bool within_kprobe_blacklist(unsigned long addr)
 {
 	struct kprobe_blackpoint *bp;
 
-	if (arch_within_kprobe_blacklist(addr))
-		return true;
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
@@ -2098,6 +2089,19 @@ static void shrink_kprobe_blacklist(struct kprobe_blackpoint **start,
 	mutex_unlock(&kprobe_blacklist_mutex);
 }
 
+static void __add_kprobe_blacklist(struct kprobe_blackpoint *bp)
+{
+	INIT_LIST_HEAD(&bp->list);
+	list_add_tail(&bp->list, &kprobe_blacklist);
+}
+
+void add_kprobe_blacklist(struct kprobe_blackpoint *bp)
+{
+	mutex_lock(&kprobe_blacklist_mutex);
+	__add_kprobe_blacklist(bp);
+	mutex_unlock(&kprobe_blacklist_mutex);
+}
+
 /*
  * Lookup and populate the kprobe_blacklist.
  *
@@ -2123,8 +2127,7 @@ static void populate_kprobe_blacklist(struct kprobe_blackpoint **start,
 			continue;
 
 		bp->range = size;
-		INIT_LIST_HEAD(&bp->list);
-		list_add_tail(&bp->list, &kprobe_blacklist);
+		__add_kprobe_blacklist(bp);
 	}
 	mutex_unlock(&kprobe_blacklist_mutex);
 }
@@ -2134,6 +2137,7 @@ extern struct kprobe_blackpoint *__stop_kprobe_blacklist[];
 
 static int __init init_kprobes(void)
 {
+	struct kprobe_blackpoint *bp;
 	int i, err = 0;
 
 	/* FIXME allocate the probe table, currently defined statically */
@@ -2147,6 +2151,20 @@ static int __init init_kprobes(void)
 	populate_kprobe_blacklist(__start_kprobe_blacklist,
 				  __stop_kprobe_blacklist);
 
+	if (__kprobes_text_start != __kprobes_text_end) {
+		/* The __kprobes marked functions must not be probed */
+		bp = kmalloc(sizeof(*bp), GFP_KERNEL);
+		if (!bp) {
+			pr_err("Kprobes: Failed to allocate memory\n");
+			return -ENOMEM;
+		}
+		bp->name = ".kprobes.text";
+		bp->start_addr = (unsigned long)__kprobes_text_start;
+		bp->range = (unsigned long)__kprobes_text_end -
+			    (unsigned long)__kprobes_text_start;
+		add_kprobe_blacklist(bp);
+	}
+
 	if (kretprobe_blacklist_size) {
 		/* lookup the function address from its name */
 		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {


