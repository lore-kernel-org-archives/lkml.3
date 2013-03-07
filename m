Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab3CGMpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:45:25 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11333 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754827Ab3CGMpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:45:24 -0500
From: <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <davem@davemloft.net>,
        <anil.s.keshavamurthy@intel.com>, <ananth@in.ibm.com>,
        <radovan.lekanovic@sonymobile.com>,
        Toby Collett <toby.collett@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [PATCH] delay blacklist symbol lookup until we actually need it
Date: Thu, 7 Mar 2013 13:45:18 +0100
Message-ID: <1362660318-30603-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toby Collett <toby.collett@sonymobile.com>

The symbol lookup can take a long time and kprobes is
initialised very early in boot, so delay symbol lookup
until the blacklist is first used.

Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Signed-off-by: Toby Collett <toby.collett@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 kernel/kprobes.c |   91 +++++++++++++++++++++++++++++++----------------------
 1 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e35be53..71a6bee 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -68,6 +68,7 @@
 #endif
 
 static int kprobes_initialized;
+static int kprobe_blacklist_initialized;
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
@@ -102,6 +103,53 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{NULL}    /* Terminator */
 };
 
+/* it can take some time ( > 100ms ) to initialise the
+ * blacklist so we delay this until we actually need it
+ */
+static void init_kprobe_blacklist(void)
+{
+	int i;
+	unsigned long offset = 0, size = 0;
+	char *modname, namebuf[128];
+	const char *symbol_name;
+	void *addr;
+	struct kprobe_blackpoint *kb;
+
+	/*
+	 * Lookup and populate the kprobe_blacklist.
+	 *
+	 * Unlike the kretprobe blacklist, we'll need to determine
+	 * the range of addresses that belong to the said functions,
+	 * since a kprobe need not necessarily be at the beginning
+	 * of a function.
+	 */
+	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
+		kprobe_lookup_name(kb->name, addr);
+		if (!addr)
+			continue;
+
+		kb->start_addr = (unsigned long)addr;
+		symbol_name = kallsyms_lookup(kb->start_addr,
+				&size, &offset, &modname, namebuf);
+		if (!symbol_name)
+			kb->range = 0;
+		else
+			kb->range = size;
+	}
+
+	if (kretprobe_blacklist_size) {
+		/* lookup the function address from its name */
+		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
+			kprobe_lookup_name(kretprobe_blacklist[i].name,
+					   kretprobe_blacklist[i].addr);
+			if (!kretprobe_blacklist[i].addr)
+				printk("kretprobe: lookup failed: %s\n",
+				       kretprobe_blacklist[i].name);
+		}
+	}
+	kprobe_blacklist_initialized = 1;
+}
+
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -1331,6 +1379,9 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
 	if (addr >= (unsigned long)__kprobes_text_start &&
 	    addr < (unsigned long)__kprobes_text_end)
 		return -EINVAL;
+
+	if (!kprobe_blacklist_initialized)
+		init_kprobe_blacklist();
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
@@ -1816,6 +1867,8 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 	void *addr;
 
 	if (kretprobe_blacklist_size) {
+		if (!kprobe_blacklist_initialized)
+			init_kprobe_blacklist();
 		addr = kprobe_addr(&rp->kp);
 		if (IS_ERR(addr))
 			return PTR_ERR(addr);
@@ -2065,11 +2118,6 @@ static struct notifier_block kprobe_module_nb = {
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
-	unsigned long offset = 0, size = 0;
-	char *modname, namebuf[128];
-	const char *symbol_name;
-	void *addr;
-	struct kprobe_blackpoint *kb;
 
 	/* FIXME allocate the probe table, currently defined statically */
 	/* initialize all list heads */
@@ -2079,39 +2127,6 @@ static int __init init_kprobes(void)
 		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
 	}
 
-	/*
-	 * Lookup and populate the kprobe_blacklist.
-	 *
-	 * Unlike the kretprobe blacklist, we'll need to determine
-	 * the range of addresses that belong to the said functions,
-	 * since a kprobe need not necessarily be at the beginning
-	 * of a function.
-	 */
-	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
-		kprobe_lookup_name(kb->name, addr);
-		if (!addr)
-			continue;
-
-		kb->start_addr = (unsigned long)addr;
-		symbol_name = kallsyms_lookup(kb->start_addr,
-				&size, &offset, &modname, namebuf);
-		if (!symbol_name)
-			kb->range = 0;
-		else
-			kb->range = size;
-	}
-
-	if (kretprobe_blacklist_size) {
-		/* lookup the function address from its name */
-		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
-			kprobe_lookup_name(kretprobe_blacklist[i].name,
-					   kretprobe_blacklist[i].addr);
-			if (!kretprobe_blacklist[i].addr)
-				printk("kretprobe: lookup failed: %s\n",
-				       kretprobe_blacklist[i].name);
-		}
-	}
-
 #if defined(CONFIG_OPTPROBES)
 #if defined(__ARCH_WANT_KPROBES_INSN_SLOT)
 	/* Init kprobe_optinsn_slots */
-- 
1.7.8.6

