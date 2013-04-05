Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161595Ab3DEN2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 09:28:06 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6167 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161486Ab3DEN1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 09:27:12 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        <davem@davemloft.net>, <anil.s.keshavamurthy@intel.com>,
        <ananth@in.ibm.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        <radovan.lekanovic@sonymobile.com>, <bjorn.davidsson@sonymobile.com>,
        <oskar.andero@sonymobile.com>,
        Toby Collett <toby.collett@sonymobile.com>
Subject: [PATCH v3 1/4] kprobes: delay blacklist symbol lookup until we actually need it
Date: Fri, 5 Apr 2013 15:26:37 +0200
Message-ID: <1365168400-17954-2-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1365168400-17954-1-git-send-email-oskar.andero@sonymobile.com>
References: <1365168400-17954-1-git-send-email-oskar.andero@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toby Collett <toby.collett@sonymobile.com>

The symbol lookup can take a long time and kprobes is
initialised very early in boot, so delay symbol lookup
until the blacklist is first used.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David S. Miller <davem@davemloft.net>
Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Signed-off-by: Toby Collett <toby.collett@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 kernel/kprobes.c | 100 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 38 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e35be53..c8c2281 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -68,6 +68,7 @@
 #endif
 
 static int kprobes_initialized;
+static bool kprobe_blacklist_initialized;
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
@@ -102,6 +103,62 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
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
+
+	smp_wmb();
+	kprobe_blacklist_initialized = true;
+
+out:
+	mutex_unlock(&kprobe_mutex);
+}
+
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
  * kprobe->ainsn.insn points to the copy of the instruction to be
@@ -1331,6 +1388,9 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
 	if (addr >= (unsigned long)__kprobes_text_start &&
 	    addr < (unsigned long)__kprobes_text_end)
 		return -EINVAL;
+
+	if (unlikely(!kprobe_blacklist_initialized))
+		init_kprobe_blacklist();
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
@@ -1816,6 +1876,8 @@ int __kprobes register_kretprobe(struct kretprobe *rp)
 	void *addr;
 
 	if (kretprobe_blacklist_size) {
+		if (unlikely(!kprobe_blacklist_initialized))
+			init_kprobe_blacklist();
 		addr = kprobe_addr(&rp->kp);
 		if (IS_ERR(addr))
 			return PTR_ERR(addr);
@@ -2065,11 +2127,6 @@ static struct notifier_block kprobe_module_nb = {
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
@@ -2079,39 +2136,6 @@ static int __init init_kprobes(void)
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
1.8.1.5

