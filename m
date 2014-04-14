Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaDNKlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:41:08 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:45646 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaDNKlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:41:06 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        nasa4836@gmail.com
Subject: [PATCH] kprobes: be more permissive when user specifies both symbol name and address
Date: Mon, 14 Apr 2014 18:40:50 +0800
Message-Id: <1397472050-19947-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if user specifies both symbol name and address, we just
bail out.

This might be too rude. This patch makes it give more tolerance.
If both are specified, let symbol name take precedence; upon failure,
try address. And print a warning message if user specify an address
to inform him that using symbol is more preferred.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 Documentation/kprobes.txt |  4 +++-
 kernel/kprobes.c          | 33 +++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 0cfb00f..ecf901b 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -344,7 +344,9 @@ to install a probepoint is known. This field is used to calculate the
 probepoint.
 
 3. Specify either the kprobe "symbol_name" OR the "addr". If both are
-specified, kprobe registration will fail with -EINVAL.
+specified, searching for "symbol_name" takes precedence; upon failure,
+then try "addr". If neither is specified, kprobe registration will fail
+with -EINVAL.
 
 4. With CISC architectures (such as i386 and x86_64), the kprobes code
 does not validate if the kprobe.addr is at an instruction boundary.
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ceeadfc..2444a7a 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1354,17 +1354,42 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
 static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
 {
 	kprobe_opcode_t *addr = p->addr;
+	char namebuf[KSYM_NAME_LEN];
+	const char *sym_name = NULL;
 
-	if ((p->symbol_name && p->addr) ||
-	    (!p->symbol_name && !p->addr))
+	if (!p->symbol_name && !p->addr)
 		goto invalid;
 
 	if (p->symbol_name) {
 		kprobe_lookup_name(p->symbol_name, addr);
-		if (!addr)
-			return ERR_PTR(-ENOENT);
+		if (addr) {
+			if (p->addr && p->addr != addr)
+				printk(KERN_WARNING "Warning: kprobe adrress for %s "
+					"mismatch, should be %p, not %p.\n",
+					p->symbol_name, addr, p->addr);
+			goto found;
+		}
+	}
+	if (p->addr) {
+		printk(KERN_WARNING "Warning: kprobes symbol name is now supported."
+			"Please use it instead.\n");
+		sym_name = kallsyms_lookup((unsigned long)(p->addr),
+				NULL, NULL, NULL, namebuf);
+		if (sym_name) {
+			if (p->symbol_name && strncmp(sym_name, p->symbol_name,
+						KSYM_NAME_LEN))
+				printk(KERN_WARNING "Warning: found %s at addres "
+				"%p, but not %s.\n",
+				p->symbol_name, addr, sym_name);
+
+			addr = p->addr;
+			goto found;
+		}
+
 	}
+	return ERR_PTR(-ENOENT);
 
+found:
 	addr = (kprobe_opcode_t *)(((char *)addr) + p->offset);
 	if (addr)
 		return addr;
-- 
1.9.0.GIT

