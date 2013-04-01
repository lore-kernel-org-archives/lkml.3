Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab3DAG4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:56:01 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44621 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901Ab3DAGzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:55:48 -0400
X-AuditID: 9c930197-b7c9dae000006959-0b-51592f71d1c0
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] kprobe: initialize kprobe_blacklist when it is used firstly
Date: Mon,  1 Apr 2013 15:55:56 +0900
Message-Id: <1364799356-15768-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, initializing kprobe_blacklist is done during boot process.
It takes 230 ms on our android platform and this is significant amount
for our use case. We can disable CONFIG_KPROBES for production kernel,
but it is hassle. This kprobe functionality is not commonly used,
so we don't need to pay this cost at all times. With this rationale,
change code to initialize kprobe_blacklist when it is used firstly.

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
I fotgot to add lkml.
Sorry for noise.

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e35be53..5e90092 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -101,6 +101,7 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"mcount",},	/* mcount can be called from everywhere */
 	{NULL}    /* Terminator */
 };
+static bool kprobe_blacklist_initialized;
 
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
@@ -1324,6 +1325,49 @@ out:
 	return ret;
 }
 
+static void __kprobes init_kprobe_blacklist(void)
+{
+	unsigned long offset = 0, size = 0;
+	char *modname, namebuf[128];
+	const char *symbol_name;
+	void *addr;
+	struct kprobe_blackpoint *kb;
+
+	mutex_lock(&kprobe_mutex);
+	if (kprobe_blacklist_initialized)
+		goto out;
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
+	/* This guarantee that who see initilized will
+	 * get a updated data of kprobe_blacklist */
+	smp_wmb();
+	kprobe_blacklist_initialized = true;
+
+out:
+	mutex_unlock(&kprobe_mutex);
+}
+
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
 	struct kprobe_blackpoint *kb;
@@ -1331,6 +1375,7 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
 	if (addr >= (unsigned long)__kprobes_text_start &&
 	    addr < (unsigned long)__kprobes_text_end)
 		return -EINVAL;
+
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
@@ -1476,6 +1521,9 @@ int __kprobes register_kprobe(struct kprobe *p)
 	struct module *probed_mod;
 	kprobe_opcode_t *addr;
 
+	if (unlikely(!kprobe_blacklist_initialized))
+		init_kprobe_blacklist();
+
 	/* Adjust probe address from symbol */
 	addr = kprobe_addr(p);
 	if (IS_ERR(addr))
@@ -2065,11 +2113,6 @@ static struct notifier_block kprobe_module_nb = {
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
@@ -2079,28 +2122,6 @@ static int __init init_kprobes(void)
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
 	if (kretprobe_blacklist_size) {
 		/* lookup the function address from its name */
 		for (i = 0; kretprobe_blacklist[i].name != NULL; i++) {
-- 
1.7.9.5

