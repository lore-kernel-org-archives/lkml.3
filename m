Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3IKCtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:49:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46976 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3IKCtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:49:15 -0400
Date: Tue, 10 Sep 2013 19:48:44 -0700
Message-Id: <201309110248.r8B2miI2032449@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL RESEND] x86/jumpmplabel changes for v3.12-rc1
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 10 Sep 2013 19:48:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One more x86 tree for this merge window.  This tree improves the
handling of jump labels, so that most of the time we don't have to do
a massive initial patching run.  Furthermore, we will error out of the
jump label is not what is expected, e.g. if it has been corrupted or
tampered with.

This tree does conflict with your top of tree; the resolution should be
reasonably straightforward but let me know if you want a merged tree.

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-jumplabel-for-linus

for you to fetch changes up to fb40d7a8994a3cc7a1e1c1f3258ea8662a366916:

  x86/jump-label: Show where and what was wrong on errors (2013-08-06 21:54:33 -0400)

----------------------------------------------------------------
Steven Rostedt (4):
      x86/jump-label: Use best default nops for inital jump label calls
      x86/jump-label: Do not bother updating nops if they are correct
      x86/jump-label: Add safety checks to jump label conversions
      x86/jump-label: Show where and what was wrong on errors

 arch/x86/include/asm/jump_label.h |  9 +++--
 arch/x86/kernel/jump_label.c      | 70 ++++++++++++++++++++++++++++++++++++---
 2 files changed, 73 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 3a16c14..64507f3 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -3,18 +3,23 @@
 
 #ifdef __KERNEL__
 
+#include <linux/stringify.h>
 #include <linux/types.h>
 #include <asm/nops.h>
 #include <asm/asm.h>
 
 #define JUMP_LABEL_NOP_SIZE 5
 
-#define STATIC_KEY_INITIAL_NOP ".byte 0xe9 \n\t .long 0\n\t"
+#ifdef CONFIG_X86_64
+# define STATIC_KEY_INIT_NOP P6_NOP5_ATOMIC
+#else
+# define STATIC_KEY_INIT_NOP GENERIC_NOP5_ATOMIC
+#endif
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
 	asm goto("1:"
-		STATIC_KEY_INITIAL_NOP
+		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
 		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 2889b3d..912a528 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -24,18 +24,57 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
+static void bug_at(unsigned char *ip, int line)
+{
+	/*
+	 * The location is not an op that we were expecting.
+	 * Something went wrong. Crash the box, as something could be
+	 * corrupting the kernel.
+	 */
+	pr_warning("Unexpected op at %pS [%p] (%02x %02x %02x %02x %02x) %s:%d\n",
+	       ip, ip, ip[0], ip[1], ip[2], ip[3], ip[4], __FILE__, line);
+	BUG();
+}
+
 static void __jump_label_transform(struct jump_entry *entry,
 				   enum jump_label_type type,
-				   void *(*poker)(void *, const void *, size_t))
+				   void *(*poker)(void *, const void *, size_t),
+				   int init)
 {
 	union jump_code_union code;
+	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
 
 	if (type == JUMP_LABEL_ENABLE) {
+		/*
+		 * We are enabling this jump label. If it is not a nop
+		 * then something must have gone wrong.
+		 */
+		if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
+			bug_at((void *)entry->code, __LINE__);
+
 		code.jump = 0xe9;
 		code.offset = entry->target -
 				(entry->code + JUMP_LABEL_NOP_SIZE);
-	} else
+	} else {
+		/*
+		 * We are disabling this jump label. If it is not what
+		 * we think it is, then something must have gone wrong.
+		 * If this is the first initialization call, then we
+		 * are converting the default nop to the ideal nop.
+		 */
+		if (init) {
+			const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
+			if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
+				bug_at((void *)entry->code, __LINE__);
+		} else {
+			code.jump = 0xe9;
+			code.offset = entry->target -
+				(entry->code + JUMP_LABEL_NOP_SIZE);
+			if (unlikely(memcmp((void *)entry->code, &code, 5) != 0))
+				bug_at((void *)entry->code, __LINE__);
+		}
 		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
+	}
 
 	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
 }
@@ -45,15 +84,38 @@ void arch_jump_label_transform(struct jump_entry *entry,
 {
 	get_online_cpus();
 	mutex_lock(&text_mutex);
-	__jump_label_transform(entry, type, text_poke_smp);
+	__jump_label_transform(entry, type, text_poke_smp, 0);
 	mutex_unlock(&text_mutex);
 	put_online_cpus();
 }
 
+static enum {
+	JL_STATE_START,
+	JL_STATE_NO_UPDATE,
+	JL_STATE_UPDATE,
+} jlstate __initdata_or_module = JL_STATE_START;
+
 __init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 				      enum jump_label_type type)
 {
-	__jump_label_transform(entry, type, text_poke_early);
+	/*
+	 * This function is called at boot up and when modules are
+	 * first loaded. Check if the default nop, the one that is
+	 * inserted at compile time, is the ideal nop. If it is, then
+	 * we do not need to update the nop, and we can leave it as is.
+	 * If it is not, then we need to update the nop to the ideal nop.
+	 */
+	if (jlstate == JL_STATE_START) {
+		const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
+		const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
+
+		if (memcmp(ideal_nop, default_nop, 5) != 0)
+			jlstate = JL_STATE_UPDATE;
+		else
+			jlstate = JL_STATE_NO_UPDATE;
+	}
+	if (jlstate == JL_STATE_UPDATE)
+		__jump_label_transform(entry, type, text_poke_early, 1);
 }
 
 #endif
