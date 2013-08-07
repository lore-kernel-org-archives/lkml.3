Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab3HGRl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:41:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25209 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab3HGRlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:41:22 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=CtuoerzdPKUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=_OqaKrVT8_IA:10 a=20KFwNOVAAAA:8 a=3FE5NN9oZHMokVY65lcA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130807174121.001163270@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 07 Aug 2013 13:36:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@akamai.com>
Subject: [RFC][PATCH 2/2] x86/jump labels: Use etiher 5 byte or 2 byte jumps
References: <20130807173606.872055511@goodmis.org>
Content-Disposition: inline; filename=0002-x86-jump-labels-Use-etiher-5-byte-or-2-byte-jumps.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Have the jump labels add a "jmp" in the assembly instead
of a default nop. This will cause the assembler to put in
either a 2 byte or 5 byte jmp depending on where the target
lable is.

Then at compile time, the update_jump_label code will replace
the jmps with either 2 or 5 byte nops.

On boot up, the code can be examined to see if the jump label
uses either a 2 or 5 byte nop and replace it.

By allowing the jump labels to be 2 bytes, it speeds up the
nops, not only 2 byte nops are faster than 5 byte nops, but also
because it saves on cache foot print.

   text    data     bss     dec     hex filename
13403667 3666856 2998272 20068795 13239bb ../nobackup/mxtest/vmlinux-old
13398536 3666856 2998272 20063664 13225b0 ../nobackup/mxtest/vmlinux-new

Converting the current v3.2 trace points saved 5,131 bytes.
As more places use jump labels, this will have a bigger savings.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/Kconfig                  |    1 +
 arch/x86/include/asm/jump_label.h |    7 ++-
 arch/x86/kernel/jump_label.c      |   88 +++++++++++++++++++++++++++----------
 3 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..5dbbee2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -81,6 +81,7 @@ config X86
 	select HAVE_USER_RETURN_NOTIFIER
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_ARCH_JUMP_LABEL
+	select HAVE_BUILD_TIME_JUMP_LABEL
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 64507f3..615adb4 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -10,6 +10,11 @@
 
 #define JUMP_LABEL_NOP_SIZE 5
 
+/*
+ * The STATIC_KEY_INIT_NOP must match the nops used in
+ * scripts/update_jump_label.c. Otherwise the boot time checks
+ * will fail and trigger a BUG() on boot up.
+ */
 #ifdef CONFIG_X86_64
 # define STATIC_KEY_INIT_NOP P6_NOP5_ATOMIC
 #else
@@ -19,7 +24,7 @@
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:"
-		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
+		"jmp %l[l_yes]\n"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 912a528..1a943aa 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -16,12 +16,20 @@
 
 #ifdef HAVE_JUMP_LABEL
 
+/* These are the nops added at compile time */
+static const unsigned char nop_short[] = { P6_NOP2 };
+static const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
+
 union jump_code_union {
 	char code[JUMP_LABEL_NOP_SIZE];
 	struct {
 		char jump;
 		int offset;
-	} __attribute__((packed));
+	} __packed;
+	struct {
+		char jump_short;
+		char offset_short;
+	} __packed;
 };
 
 static void bug_at(unsigned char *ip, int line)
@@ -42,19 +50,29 @@ static void __jump_label_transform(struct jump_entry *entry,
 				   int init)
 {
 	union jump_code_union code;
+	unsigned char nop;
+	unsigned char op;
+	unsigned size;
+	void *ip = (void *)entry->code;
 	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
 
-	if (type == JUMP_LABEL_ENABLE) {
-		/*
-		 * We are enabling this jump label. If it is not a nop
-		 * then something must have gone wrong.
-		 */
-		if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
-			bug_at((void *)entry->code, __LINE__);
+	/* Use probe_kernel_read()? */
+	op = *(unsigned char *)ip;
+	nop = ideal_nops[NOP_ATOMIC5][0];
 
-		code.jump = 0xe9;
-		code.offset = entry->target -
-				(entry->code + JUMP_LABEL_NOP_SIZE);
+	if (type == JUMP_LABEL_ENABLE) {
+		if (memcmp(ip, nop_short, 2) == 0) {
+			size = 2;
+			code.jump_short = 0xeb;
+			code.offset = entry->target - (entry->code + 2);
+			/* Check for overflow ? */
+		} else if ((!init && memcmp(ip, ideal_nop, 5) == 0) ||
+			   (init && memcmp(ip, default_nop, 5) == 0)) {
+			size = JUMP_LABEL_NOP_SIZE;
+			code.jump = 0xe9;
+			code.offset = entry->target - (entry->code + size);
+		} else
+			bug_at(ip, __LINE__);
 	} else {
 		/*
 		 * We are disabling this jump label. If it is not what
@@ -63,20 +81,48 @@ static void __jump_label_transform(struct jump_entry *entry,
 		 * are converting the default nop to the ideal nop.
 		 */
 		if (init) {
-			const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
-			if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
-				bug_at((void *)entry->code, __LINE__);
-		} else {
+			/* Ignore short nops, we do not change them */
+			if (memcmp(ip, nop_short, 2) == 0)
+				return;
+
+			/* We are initializing from the default nop */
+			if (unlikely(memcmp(ip, default_nop, 5) != 0))
+				bug_at(ip, __LINE__);
+
+			/* Set to the ideal nop */
+			size = JUMP_LABEL_NOP_SIZE;
+			memcpy(&code, ideal_nops[NOP_ATOMIC5], size);
+
+		} else if (op == 0xe9) {
+			/* Replace a 5 byte jmp */
+
+			/* Make sure this is what we expected it to be */
 			code.jump = 0xe9;
 			code.offset = entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
-			if (unlikely(memcmp((void *)entry->code, &code, 5) != 0))
-				bug_at((void *)entry->code, __LINE__);
-		}
-		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+
+			if (unlikely(memcmp(ip, &code, 5) != 0))
+				bug_at(ip, __LINE__);
+
+			size = JUMP_LABEL_NOP_SIZE;
+			memcpy(&code, ideal_nops[NOP_ATOMIC5], size);
+		} else if (op == 0xeb) {
+			/* Replace a 2 byte jmp */
+
+			/* Had better be a 2 byte jmp */
+			code.jump_short = 0xeb;
+			code.offset = entry->target - (entry->code + 2);
+			if (unlikely(memcmp(ip, &code, 2) != 0))
+				bug_at(ip, __LINE__);
+
+			size = 2;
+			memcpy(&code, nop_short, size);
+		} else
+			/* The code was not what we expected!  */
+			bug_at(ip, __LINE__);
 	}
 
-	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
+	(*poker)(ip, &code, size);
 }
 
 void arch_jump_label_transform(struct jump_entry *entry,
@@ -106,7 +152,6 @@ __init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 	 * If it is not, then we need to update the nop to the ideal nop.
 	 */
 	if (jlstate == JL_STATE_START) {
-		const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
 		const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
 
 		if (memcmp(ideal_nop, default_nop, 5) != 0)
@@ -117,5 +162,4 @@ __init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 	if (jlstate == JL_STATE_UPDATE)
 		__jump_label_transform(entry, type, text_poke_early, 1);
 }
-
 #endif
-- 
1.7.10.4


