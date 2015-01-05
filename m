Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbbAEPAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:00:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51560 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbbAEPAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:00:17 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 2/4] x86, alternatives: Cleanup DPRINTK macro
Date: Mon,  5 Jan 2015 16:00:11 +0100
Message-Id: <1420470013-26413-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.2.0.33.gc18b867
In-Reply-To: <1420470013-26413-1-git-send-email-bp@alien8.de>
References: <1420470013-26413-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Make it pass __func__ implicitly. Also, dump info about each replacing
we're doing. Fixup comments and style while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/alternative.c | 41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 703130f469ec..1e86e85bcf58 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -52,10 +52,10 @@ static int __init setup_noreplace_paravirt(char *str)
 __setup("noreplace-paravirt", setup_noreplace_paravirt);
 #endif
 
-#define DPRINTK(fmt, ...)				\
-do {							\
-	if (debug_alternative)				\
-		printk(KERN_DEBUG fmt, ##__VA_ARGS__);	\
+#define DPRINTK(fmt, args...)						\
+do {									\
+	if (debug_alternative)						\
+		printk(KERN_DEBUG "%s: " fmt "\n", __func__, ##args);	\
 } while (0)
 
 /*
@@ -243,12 +243,13 @@ extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
 void *text_poke_early(void *addr, const void *opcode, size_t len);
 
-/* Replace instructions with better alternatives for this CPU type.
-   This runs before SMP is initialized to avoid SMP problems with
-   self modifying code. This implies that asymmetric systems where
-   APs have less capabilities than the boot processor are not handled.
-   Tough. Make sure you disable such features by hand. */
-
+/*
+ * Replace instructions with better alternatives for this CPU type. This runs
+ * before SMP is initialized to avoid SMP problems with self modifying code.
+ * This implies that asymmetric systems where APs have less capabilities than
+ * the boot processor are not handled. Tough. Make sure you disable such
+ * features by hand.
+ */
 void __init_or_module apply_alternatives(struct alt_instr *start,
 					 struct alt_instr *end)
 {
@@ -256,10 +257,10 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 	u8 *instr, *replacement;
 	u8 insnbuf[MAX_PATCH_LEN];
 
-	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
+	DPRINTK("alt table %p -> %p", start, end);
 	/*
 	 * The scan order should be from start to end. A later scanned
-	 * alternative code can overwrite a previous scanned alternative code.
+	 * alternative code can overwrite previously scanned alternative code.
 	 * Some kernel functions (e.g. memcpy, memset, etc) use this order to
 	 * patch code.
 	 *
@@ -275,11 +276,19 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 		if (!boot_cpu_has(a->cpuid))
 			continue;
 
+		DPRINTK("feat: %d*32+%d, old: (%p, len: %d), repl: (%p, len: %d)",
+			a->cpuid >> 5,
+			a->cpuid & 0x1f,
+			instr, a->instrlen,
+			replacement, a->replacementlen);
+
 		memcpy(insnbuf, replacement, a->replacementlen);
 
 		/* 0xe8 is a relative jump; fix the offset. */
-		if (*insnbuf == 0xe8 && a->replacementlen == 5)
-		    *(s32 *)(insnbuf + 1) += replacement - instr;
+		if (*insnbuf == 0xe8 && a->replacementlen == 5) {
+			*(s32 *)(insnbuf + 1) += replacement - instr;
+			DPRINTK("Fix CALL offset: 0x%x", *(s32 *)(insnbuf + 1));
+		}
 
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
@@ -371,8 +380,8 @@ void __init_or_module alternatives_smp_module_add(struct module *mod,
 	smp->locks_end	= locks_end;
 	smp->text	= text;
 	smp->text_end	= text_end;
-	DPRINTK("%s: locks %p -> %p, text %p -> %p, name %s\n",
-		__func__, smp->locks, smp->locks_end,
+	DPRINTK("locks %p -> %p, text %p -> %p, name %s\n",
+		smp->locks, smp->locks_end,
 		smp->text, smp->text_end, smp->name);
 
 	list_add_tail(&smp->next, &smp_alt_modules);
-- 
2.2.0.33.gc18b867

