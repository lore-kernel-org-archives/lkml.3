Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaDOJQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:16:13 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43287 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaDOJQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:16:09 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        nasa4836@gmail.com
Subject: Re: [PATCH] kprobes: be more permissive when user specifies both symbol name and address
Date: Tue, 15 Apr 2014 17:16:00 +0800
Message-Id: <1397553360-27970-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I've followed your suggestion. Thanks :-)

Currently, if user specifies both symbol name and address, we just
bail out.

This might be too rude. This patch makes it give more tolerance.
If both are specified, check address first, if the symbol found
does not match the one user specify, print a waring. If not found,
return -ENOENT, because some symbols might have muplitple instances,
we don't bother to check symbol name.

Suggested-by: Masami Hiramatsu masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 Documentation/kprobes.txt |  4 +++-
 kernel/kprobes.c          | 33 +++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 5 deletions(-)

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
index ceeadfc..6ebd456 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1354,17 +1354,42 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
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
+	/*
+	 * Some symbols might have muplitple instances,
+	 * so if both specified, only check address.
+	 */
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
+		/* Only symbol case */
 		kprobe_lookup_name(p->symbol_name, addr);
 		if (!addr)
 			return ERR_PTR(-ENOENT);
+	} else {
+		/*
+		 * Only address case.
+		 * Since we later will do sanity check of the
+		 * address range in check_kprobe_address_safe(),
+		 * do nothing here.
+		 */
 	}
-
 	addr = (kprobe_opcode_t *)(((char *)addr) + p->offset);
 	if (addr)
 		return addr;
-- 
1.9.0.GIT

