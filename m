Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaDOILv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:11:51 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51860 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaDOILs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:11:48 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        nasa4836@gmail.com
Subject: [PATCH] kprobes: be more permissive when user specifies both symbol name and address
Date: Tue, 15 Apr 2014 16:10:46 +0800
Message-Id: <1397549446-849-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if user specifies both symbol name and address, we just
bail out.

This might be too rude. This patch makes it give more tolerance.
If both are specified, check address first, if the symbol found
does not match the one user specify, print a waring. If not found,
return -ENOENT, because some symbols might have muplitple instances,
we don't bother to check symbol name.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 Documentation/kprobes.txt |  4 +++-
 kernel/kprobes.c          | 30 ++++++++++++++++++++++++++----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 0cfb00f..217f976 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -344,7 +344,9 @@ to install a probepoint is known. This field is used to calculate the
 probepoint.
 
 3. Specify either the kprobe "symbol_name" OR the "addr". If both are
-specified, kprobe registration will fail with -EINVAL.
+specified, only check "addr", because some symbols might have muplitple
+instances. If neither is specified, kprobe registration will fail
+with -EINVAL.
 
 4. With CISC architectures (such as i386 and x86_64), the kprobes code
 does not validate if the kprobe.addr is at an instruction boundary.
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ceeadfc..ac910f4 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1354,17 +1354,39 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
 static kprobe_opcode_t __kprobes *kprobe_addr(struct kprobe *p)
 {
 	kprobe_opcode_t *addr = p->addr;
+	char namebuf[KSYM_NAME_LEN];
+	const char *sym_name = NULL;
+	unsigned long offset;
 
-	if ((p->symbol_name && p->addr) ||
-	    (!p->symbol_name && !p->addr))
+	if (!p->symbol_name && !p->addr)
 		goto invalid;
 
-	if (p->symbol_name) {
+	/* Some symbols might have muplitple instances,
+	 * so if both specified, only check address. */
+	if (unlikely(p->addr && p->symbol_name)) {
+		sym_name = kallsyms_lookup((unsigned long)(p->addr),
+				NULL, &offset, NULL, namebuf);
+		if (!sym_name)
+			return ERR_PTR(-ENOENT);
+
+		if (strncmp(sym_name, p->symbol_name, KSYM_NAME_LEN)
+				|| offset != p->offset) {
+			pr_err("Incorrect symbol or offset, should be "
+				"symbol=%s, offset=%ld.\n", sym_name, offset);
+			goto invalid;
+		}
+	} else if (p->symbol_name) {
+		/* only symbol case */
 		kprobe_lookup_name(p->symbol_name, addr);
 		if (!addr)
 			return ERR_PTR(-ENOENT);
+	} else {
+		/* only address case */
+		sym_name = kallsyms_lookup((unsigned long)(p->addr),
+				NULL, &offset, NULL, namebuf);
+		if (!sym_name)
+			return ERR_PTR(-ENOENT);
 	}
-
 	addr = (kprobe_opcode_t *)(((char *)addr) + p->offset);
 	if (addr)
 		return addr;
-- 
1.9.0.GIT

