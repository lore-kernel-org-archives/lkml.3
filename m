Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3JQKT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:19:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab3JQKTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:19:24 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Jones <drjones@redhat.com>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: [PATCH 5/7] jump_label: relax branch hinting restrictions
Date: Thu, 17 Oct 2013 12:10:28 +0200
Message-Id: <1382004631-25895-6-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We implemented the optimized branch selection in higher levels of api.
That made static_keys very unintuitive, so this patch introduces another
element to jump_table, carrying one bit that tells the underlying code
which branch to optimize.

It is now possible to select optimized branch for every jump_entry.

Current side effect is 1/3 increase increase in space, we could:
* use bitmasks and selectors on 2+ aligned code/struct.
  - aligning jump target is easy, but because it is not done by default
    and few bytes in .text are much worse that few kilos in .data,
    I chose not to
  - data is probably aligned by default on all current architectures,
    but programmer can force misalignment of static_key
* optimize each architecture independently
  - I can't test everything and this patch shouldn't break anything, so
    others can contribute in the future
* choose something worse, like packing or splitting
* ignore

proof: example & x86_64 disassembly: (F = ffffffff)

  struct static_key flexible_feature;
  noinline void jump_label_experiment(void) {
  	if ( static_key_false(&flexible_feature))
  	     asm ("push 0xa1");
  	else asm ("push 0xa0");
  	if (!static_key_false(&flexible_feature))
  	     asm ("push 0xb0");
  	else asm ("push 0xb1");
  	if ( static_key_true(&flexible_feature))
  	     asm ("push 0xc1");
  	else asm ("push 0xc0");
  	if (!static_key_true(&flexible_feature))
  	     asm ("push 0xd0");
  	else asm ("push 0xd1");
  }

  Disassembly of section .text: (push marked by "->")

  F81002000 <jump_label_experiment>:
  F81002000:       e8 7b 29 75 00          callq  F81754980 <__fentry__>
  F81002005:       55                      push   %rbp
  F81002006:       48 89 e5                mov    %rsp,%rbp
  F81002009:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
  F8100200e: ->    ff 34 25 a0 00 00 00    pushq  0xa0
  F81002015:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
  F8100201a: ->    ff 34 25 b0 00 00 00    pushq  0xb0
  F81002021:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
  F81002026: ->    ff 34 25 c1 00 00 00    pushq  0xc1
  F8100202d:       0f 1f 00                nopl   (%rax)
  F81002030:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
  F81002035: ->    ff 34 25 d1 00 00 00    pushq  0xd1
  F8100203c:       5d                      pop    %rbp
  F8100203d:       0f 1f 00                nopl   (%rax)
  F81002040:       c3                      retq
  F81002041:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
  F81002048: ->    ff 34 25 d0 00 00 00    pushq  0xd0
  F8100204f:       5d                      pop    %rbp
  F81002050:       c3                      retq
  F81002051:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
  F81002058: ->    ff 34 25 c0 00 00 00    pushq  0xc0
  F8100205f:       90                      nop
  F81002060:       eb cb                   jmp    F8100202d <[...]+0x2d>
  F81002062:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
  F81002068: ->    ff 34 25 b1 00 00 00    pushq  0xb1
  F8100206f:       90                      nop
  F81002070:       eb af                   jmp    F81002021 <[...]+0x21>
  F81002072:       66 0f 1f 44 00 00       nopw   0x0(%rax,%rax,1)
  F81002078: ->    ff 34 25 a1 00 00 00    pushq  0xa1
  F8100207f:       90                      nop
  F81002080:       eb 93                   jmp    F81002015 <[...]+0x15>
  F81002082:       66 66 66 66 66 2e 0f    [...]
  F81002089:       1f 84 00 00 00 00 00

  Contents of section .data: (relevant part of embedded __jump_table)
    F81d26a40 09200081 ffffffff 78200081 ffffffff
    F81d26a50 20600f82 ffffffff 00000000 00000000
    F81d26a60 15200081 ffffffff 68200081 ffffffff
    F81d26a70 20600f82 ffffffff 00000000 00000000
    F81d26a80 21200081 ffffffff 58200081 ffffffff
    F81d26a90 20600f82 ffffffff 01000000 00000000
    F81d26aa0 30200081 ffffffff 48200081 ffffffff
    F81d26ab0 20600f82 ffffffff 01000000 00000000

  (I've also compiled for s390x, blocks were placed correctly,
   jump table looked ok too;
   I hope the least significant bit is correct everywhere)

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 Documentation/static-keys.txt         |  6 ----
 arch/arm/include/asm/jump_label.h     | 19 ++++++++----
 arch/arm/kernel/jump_label.c          |  2 +-
 arch/mips/include/asm/jump_label.h    | 19 ++++++++----
 arch/mips/kernel/jump_label.c         |  2 +-
 arch/powerpc/include/asm/jump_label.h | 19 ++++++++----
 arch/powerpc/kernel/jump_label.c      |  2 +-
 arch/s390/include/asm/jump_label.h    | 19 ++++++++----
 arch/s390/kernel/jump_label.c         |  2 +-
 arch/sparc/include/asm/jump_label.h   | 19 ++++++++----
 arch/sparc/kernel/jump_label.c        |  2 +-
 arch/x86/include/asm/jump_label.h     | 19 ++++++++----
 arch/x86/kernel/jump_label.c          | 32 ++++----------------
 include/linux/jump_label.h            | 55 ++++++++++++-----------------------
 kernel/jump_label.c                   | 29 ++++--------------
 15 files changed, 119 insertions(+), 127 deletions(-)

diff --git a/Documentation/static-keys.txt b/Documentation/static-keys.txt
index 9f5263d..57c040e 100644
--- a/Documentation/static-keys.txt
+++ b/Documentation/static-keys.txt
@@ -103,12 +103,6 @@ Or:
         else
                 do unlikely code
 
-A key that is initialized via 'STATIC_KEY_INIT_FALSE', must be used in a
-'static_key_false()' construct. Likewise, a key initialized via
-'STATIC_KEY_INIT_TRUE' must be used in a 'static_key_true()' construct. A
-single key can be used in many branches, but all the branches must match the
-way that the key has been initialized.
-
 The branch(es) can then be switched via:
 
 	static_key_slow_inc(&key);
diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_label.h
index 863c892..f4ec3af 100644
--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -14,18 +14,21 @@
 #define JUMP_LABEL_NOP	"nop"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+struct static_key;
+
+static __always_inline bool arch_static_branch(struct static_key *key,
+		const bool default_branch)
 {
 	asm_volatile_goto("1:\n\t"
 		 JUMP_LABEL_NOP "\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
-		 ".word 1b, %l[l_yes], %c0\n\t"
+		 ".word 1b, %l[l_yes], %c0, %c1\n\t"
 		 ".popsection\n\t"
-		 : :  "i" (key) :  : l_yes);
+		 : :  "i" (key), "i" (default_branch) :  : l_yes);
 
-	return false;
+	return default_branch;
 l_yes:
-	return true;
+	return !default_branch;
 }
 
 #endif /* __KERNEL__ */
@@ -36,6 +39,12 @@ struct jump_entry {
 	jump_label_t code;
 	jump_label_t target;
 	jump_label_t key;
+	union {
+		jump_label_t flags;
+		struct {
+			unsigned default_branch:1; /* lsb */
+		};
+	};
 };
 
 #endif
diff --git a/arch/arm/kernel/jump_label.c b/arch/arm/kernel/jump_label.c
index 4ce4f78..b02c531 100644
--- a/arch/arm/kernel/jump_label.c
+++ b/arch/arm/kernel/jump_label.c
@@ -13,7 +13,7 @@ static void __arch_jump_label_transform(struct jump_entry *entry,
 	void *addr = (void *)entry->code;
 	unsigned int insn;
 
-	if (type == JUMP_LABEL_ENABLE)
+	if (type != jump_label_default_branch(entry))
 		insn = arm_gen_branch(entry->code, entry->target);
 	else
 		insn = arm_gen_nop();
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
index e194f95..2c065ec 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -20,17 +20,20 @@
 #define WORD_INSN ".word"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+struct static_key;
+
+static __always_inline bool arch_static_branch(struct static_key *key,
+		const bool default_branch)
 {
 	asm_volatile_goto("1:\tnop\n\t"
 		"nop\n\t"
 		".pushsection __jump_table,  \"aw\"\n\t"
-		WORD_INSN " 1b, %l[l_yes], %0\n\t"
+		WORD_INSN " 1b, %l[l_yes], %0, %1\n\t"
 		".popsection\n\t"
-		: :  "i" (key) : : l_yes);
-	return false;
+		: :  "i" (key), "i" (default_branch) : : l_yes);
+	return default_branch;
 l_yes:
-	return true;
+	return !default_branch;
 }
 
 #endif /* __KERNEL__ */
@@ -45,6 +48,12 @@ struct jump_entry {
 	jump_label_t code;
 	jump_label_t target;
 	jump_label_t key;
+	union {
+		jump_label_t flags;
+		struct {
+			unsigned default_branch:1; /* lsb */
+		};
+	};
 };
 
 #endif /* _ASM_MIPS_JUMP_LABEL_H */
diff --git a/arch/mips/kernel/jump_label.c b/arch/mips/kernel/jump_label.c
index 6001610..e5b17ee 100644
--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -33,7 +33,7 @@ void arch_jump_label_transform(struct jump_entry *e,
 	/* Target must have 4 byte alignment. */
 	BUG_ON((e->target & 3) != 0);
 
-	if (type == JUMP_LABEL_ENABLE) {
+	if (type != jump_label_default_branch(entry)) {
 		insn.j_format.opcode = j_op;
 		insn.j_format.target = (e->target & J_RANGE_MASK) >> 2;
 	} else {
diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/asm/jump_label.h
index f016bb6..463c03d 100644
--- a/arch/powerpc/include/asm/jump_label.h
+++ b/arch/powerpc/include/asm/jump_label.h
@@ -17,17 +17,20 @@
 #define JUMP_ENTRY_TYPE		stringify_in_c(FTR_ENTRY_LONG)
 #define JUMP_LABEL_NOP_SIZE	4
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+struct static_key;
+
+static __always_inline bool arch_static_branch(struct static_key *key,
+		const bool default_branch)
 {
 	asm_volatile_goto("1:\n\t"
 		 "nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
-		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
+		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0, %c1\n\t"
 		 ".popsection \n\t"
-		 : :  "i" (key) : : l_yes);
-	return false;
+		 : :  "i" (key), "i" (default_branch) : : l_yes);
+	return default_branch;
 l_yes:
-	return true;
+	return !default_branch;
 }
 
 #ifdef CONFIG_PPC64
@@ -40,6 +43,12 @@ struct jump_entry {
 	jump_label_t code;
 	jump_label_t target;
 	jump_label_t key;
+	union {
+		jump_label_t flags;
+		struct {
+			unsigned default_branch:1; /* lsb */
+		};
+	};
 };
 
 #endif /* _ASM_POWERPC_JUMP_LABEL_H */
diff --git a/arch/powerpc/kernel/jump_label.c b/arch/powerpc/kernel/jump_label.c
index a1ed8a8..ebf148b 100644
--- a/arch/powerpc/kernel/jump_label.c
+++ b/arch/powerpc/kernel/jump_label.c
@@ -17,7 +17,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 {
 	u32 *addr = (u32 *)(unsigned long)entry->code;
 
-	if (type == JUMP_LABEL_ENABLE)
+	if (type != jump_label_default_branch(entry))
 		patch_branch(addr, entry->target, 0);
 	else
 		patch_instruction(addr, PPC_INST_NOP);
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
index 346b1c8..5259b49 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -13,17 +13,20 @@
 #define ASM_ALIGN ".balign 4"
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+struct static_key;
+
+static __always_inline bool arch_static_branch(struct static_key *key,
+		const bool default_branch)
 {
 	asm_volatile_goto("0:	brcl 0,0\n"
 		".pushsection __jump_table, \"aw\"\n"
 		ASM_ALIGN "\n"
-		ASM_PTR " 0b, %l[label], %0\n"
+		ASM_PTR " 0b, %l[label], %0, %1\n"
 		".popsection\n"
-		: : "X" (key) : : label);
-	return false;
+		: : "X" (key), "X" (default_branch) : : label);
+	return default_branch;
 label:
-	return true;
+	return !default_branch;
 }
 
 typedef unsigned long jump_label_t;
@@ -32,6 +35,12 @@ struct jump_entry {
 	jump_label_t code;
 	jump_label_t target;
 	jump_label_t key;
+	union {
+		jump_label_t flags;
+		struct {
+			unsigned default_branch:1; /* lsb */
+		};
+	};
 };
 
 #endif
diff --git a/arch/s390/kernel/jump_label.c b/arch/s390/kernel/jump_label.c
index b987ab2..95958c5 100644
--- a/arch/s390/kernel/jump_label.c
+++ b/arch/s390/kernel/jump_label.c
@@ -28,7 +28,7 @@ static void __jump_label_transform(struct jump_entry *entry,
 	struct insn insn;
 	int rc;
 
-	if (type == JUMP_LABEL_ENABLE) {
+	if (type != jump_label_default_branch(entry)) {
 		/* brcl 15,offset */
 		insn.opcode = 0xc0f4;
 		insn.offset = (entry->target - entry->code) >> 1;
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index ec2e2e2..67b763d 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -7,19 +7,22 @@
 
 #define JUMP_LABEL_NOP_SIZE 4
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+struct static_key;
+
+static __always_inline bool arch_static_branch(struct static_key *key,
+		const bool default_branch)
 {
 		asm_volatile_goto("1:\n\t"
 			 "nop\n\t"
 			 "nop\n\t"
 			 ".pushsection __jump_table,  \"aw\"\n\t"
 			 ".align 4\n\t"
-			 ".word 1b, %l[l_yes], %c0\n\t"
+			 ".word 1b, %l[l_yes], %c0, %c1\n\t"
 			 ".popsection \n\t"
-			 : :  "i" (key) : : l_yes);
-	return false;
+			 : :  "i" (key), "i" (default_branch) : : l_yes);
+	return default_branch;
 l_yes:
-	return true;
+	return !default_branch;
 }
 
 #endif /* __KERNEL__ */
@@ -30,6 +33,12 @@ struct jump_entry {
 	jump_label_t code;
 	jump_label_t target;
 	jump_label_t key;
+	union {
+		jump_label_t flags;
+		struct {
+			unsigned default_branch:1; /* lsb */
+		};
+	};
 };
 
 #endif
diff --git a/arch/sparc/kernel/jump_label.c b/arch/sparc/kernel/jump_label.c
index 48565c1..c963a9c 100644
--- a/arch/sparc/kernel/jump_label.c
+++ b/arch/sparc/kernel/jump_label.c
@@ -16,7 +16,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	u32 val;
 	u32 *insn = (u32 *) (unsigned long) entry->code;
 
-	if (type == JUMP_LABEL_ENABLE) {
+	if (type != jump_label_default_branch(entry)) {
 		s32 off = (s32)entry->target - (s32)entry->code;
 
 #ifdef CONFIG_SPARC64
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 6a2cefb..18e192e 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -16,18 +16,21 @@
 # define STATIC_KEY_INIT_NOP GENERIC_NOP5_ATOMIC
 #endif
 
-static __always_inline bool arch_static_branch(struct static_key *key)
+struct static_key;
+
+static __always_inline bool arch_static_branch(struct static_key *key,
+		const bool default_branch)
 {
 	asm_volatile_goto("1:"
 		".byte " __stringify(STATIC_KEY_INIT_NOP) "\n\t"
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
-		_ASM_PTR "1b, %l[l_yes], %c0 \n\t"
+		_ASM_PTR "1b, %l[l_yes], %c0, %c1 \n\t"
 		".popsection \n\t"
-		: :  "i" (key) : : l_yes);
-	return false;
+		: :  "i" (key), "i" (default_branch) : : l_yes);
+	return default_branch;
 l_yes:
-	return true;
+	return !default_branch;
 }
 
 #endif /* __KERNEL__ */
@@ -42,6 +45,12 @@ struct jump_entry {
 	jump_label_t code;
 	jump_label_t target;
 	jump_label_t key;
+	union {
+		jump_label_t flags;
+		struct {
+			unsigned default_branch:1; /* lsb */
+		};
+	};
 };
 
 #endif
diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index ee11b7d..8b66855 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -43,13 +43,15 @@ static void __jump_label_transform(struct jump_entry *entry,
 {
 	union jump_code_union code;
 	const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
+	const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
 
-	if (type == JUMP_LABEL_ENABLE) {
+	if (type != jump_label_default_branch(entry)) {
 		/*
 		 * We are enabling this jump label. If it is not a nop
 		 * then something must have gone wrong.
 		 */
-		if (unlikely(memcmp((void *)entry->code, ideal_nop, 5) != 0))
+		if (unlikely(memcmp((void *)entry->code,
+		                    init ? default_nop : ideal_nop, 5) != 0))
 			bug_at((void *)entry->code, __LINE__);
 
 		code.jump = 0xe9;
@@ -63,7 +65,6 @@ static void __jump_label_transform(struct jump_entry *entry,
 		 * are converting the default nop to the ideal nop.
 		 */
 		if (init) {
-			const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
 			if (unlikely(memcmp((void *)entry->code, default_nop, 5) != 0))
 				bug_at((void *)entry->code, __LINE__);
 		} else {
@@ -101,33 +102,10 @@ void arch_jump_label_transform(struct jump_entry *entry,
 	put_online_cpus();
 }
 
-static enum {
-	JL_STATE_START,
-	JL_STATE_NO_UPDATE,
-	JL_STATE_UPDATE,
-} jlstate __initdata_or_module = JL_STATE_START;
-
 __init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 				      enum jump_label_type type)
 {
-	/*
-	 * This function is called at boot up and when modules are
-	 * first loaded. Check if the default nop, the one that is
-	 * inserted at compile time, is the ideal nop. If it is, then
-	 * we do not need to update the nop, and we can leave it as is.
-	 * If it is not, then we need to update the nop to the ideal nop.
-	 */
-	if (jlstate == JL_STATE_START) {
-		const unsigned char default_nop[] = { STATIC_KEY_INIT_NOP };
-		const unsigned char *ideal_nop = ideal_nops[NOP_ATOMIC5];
-
-		if (memcmp(ideal_nop, default_nop, 5) != 0)
-			jlstate = JL_STATE_UPDATE;
-		else
-			jlstate = JL_STATE_NO_UPDATE;
-	}
-	if (jlstate == JL_STATE_UPDATE)
-		__jump_label_transform(entry, type, text_poke_early, 1);
+	__jump_label_transform(entry, type, text_poke_early, 1);
 }
 
 #endif
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 848bd15..a06791c 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -10,7 +10,8 @@
  * Jump labels provide an interface to generate dynamic branches using
  * self-modifying code. Assuming toolchain and architecture support the result
  * of a "if (static_key_false(&key))" statement is a unconditional branch (which
- * defaults to false - and the true block is placed out of line).
+ * defaults to false - and the true block is placed out of line,
+ * static_key_true(&key) has default to true)
  *
  * However at runtime we can change the branch target using
  * static_key_slow_{inc,dec}(). These function as a 'reference' count on the key
@@ -32,17 +33,9 @@
  * Lacking toolchain and or architecture support, it falls back to a simple
  * conditional branch.
  *
- * struct static_key my_key = STATIC_KEY_INIT_TRUE;
- *
- *   if (static_key_true(&my_key)) {
- *   }
- *
- * will result in the true case being in-line and starts the key with a single
- * reference. Mixing static_key_true() and static_key_false() on the same key is not
- * allowed.
- *
- * Not initializing the key (static data is initialized to 0s anyway) is the
- * same as using STATIC_KEY_INIT_FALSE.
+ * Initial count can be set by STATIC_KEY_INIT(x), defaults to 0, but it takes
+ * effect after jump_label_init() has finished, so static_key_enabled() must be
+ * used instead of static_key_{true,false} before.
  *
 */
 
@@ -53,7 +46,6 @@
 
 struct static_key {
 	atomic_t enabled;
-/* Set lsb bit to 1 if branch is default true, 0 ot */
 	struct jump_entry *entries;
 #ifdef CONFIG_MODULES
 	struct static_key_mod *next;
@@ -75,30 +67,20 @@ struct module;
 #include <linux/atomic.h>
 #ifdef HAVE_JUMP_LABEL
 
-#define JUMP_LABEL_TRUE_BRANCH 1UL
-
 static
 inline struct jump_entry *jump_label_get_entries(struct static_key *key)
 {
-	return (struct jump_entry *)((unsigned long)key->entries
-						& ~JUMP_LABEL_TRUE_BRANCH);
-}
-
-static inline bool jump_label_get_branch_default(struct static_key *key)
-{
-	if ((unsigned long)key->entries & JUMP_LABEL_TRUE_BRANCH)
-		return true;
-	return false;
+	return (struct jump_entry *)((unsigned long)key->entries);
 }
 
 static __always_inline bool static_key_false(struct static_key *key)
 {
-	return arch_static_branch(key);
+	return arch_static_branch(key, false);
 }
 
 static __always_inline bool static_key_true(struct static_key *key)
 {
-	return !static_key_false(key);
+	return arch_static_branch(key, true);
 }
 
 extern struct jump_entry __start___jump_table[];
@@ -116,10 +98,13 @@ extern void static_key_slow_inc(struct static_key *key);
 extern void static_key_slow_dec(struct static_key *key);
 extern void jump_label_apply_nops(struct module *mod);
 
-#define STATIC_KEY_INIT_TRUE ((struct static_key) \
-	{ .enabled = ATOMIC_INIT(1), .entries = (void *)1 })
-#define STATIC_KEY_INIT_FALSE ((struct static_key) \
-	{ .enabled = ATOMIC_INIT(0), .entries = (void *)0 })
+/* this function does not exactly belong here, but it is the path of least
+ * resistance; refactoring will move it into arch specific code */
+static inline enum jump_label_type
+jump_label_default_branch(struct jump_entry *entry) {
+	return entry->default_branch ? JUMP_LABEL_ENABLE
+	                             : JUMP_LABEL_DISABLE;
+}
 
 #else  /* !HAVE_JUMP_LABEL */
 
@@ -168,14 +153,12 @@ static inline int jump_label_apply_nops(struct module *mod)
 	return 0;
 }
 
-#define STATIC_KEY_INIT_TRUE ((struct static_key) \
-		{ .enabled = ATOMIC_INIT(1) })
-#define STATIC_KEY_INIT_FALSE ((struct static_key) \
-		{ .enabled = ATOMIC_INIT(0) })
-
 #endif	/* HAVE_JUMP_LABEL */
 
-#define STATIC_KEY_INIT STATIC_KEY_INIT_FALSE
+#define STATIC_KEY_INIT(x) ((struct static_key) { .enabled = ATOMIC_INIT(x) })
+#define STATIC_KEY_INIT_TRUE  STATIC_KEY_INIT(1)
+#define STATIC_KEY_INIT_FALSE STATIC_KEY_INIT(0)
+
 #define jump_label_enabled static_key_enabled
 
 static inline bool static_key_enabled(struct static_key *key)
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 30aa3b0..3670c0e 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -63,10 +63,7 @@ void static_key_slow_inc(struct static_key *key)
 
 	jump_label_lock();
 	if (atomic_read(&key->enabled) == 0) {
-		if (!jump_label_get_branch_default(key))
-			jump_label_update(key, JUMP_LABEL_ENABLE);
-		else
-			jump_label_update(key, JUMP_LABEL_DISABLE);
+		jump_label_update(key, JUMP_LABEL_ENABLE);
 	}
 	atomic_inc(&key->enabled);
 	jump_label_unlock();
@@ -98,10 +95,7 @@ static void __static_key_slow_dec(struct static_key *key,
 			WARN(1, "jump label: negative deferred count!\n");
 		}
 	} else {
-		if (!jump_label_get_branch_default(key))
-			jump_label_update(key, JUMP_LABEL_DISABLE);
-		else
-			jump_label_update(key, JUMP_LABEL_ENABLE);
+		jump_label_update(key, JUMP_LABEL_DISABLE);
 	}
 	jump_label_unlock();
 }
@@ -189,13 +183,8 @@ static void __jump_label_update(struct static_key *key,
 
 static enum jump_label_type jump_label_type(struct static_key *key)
 {
-	bool true_branch = jump_label_get_branch_default(key);
-	bool state = static_key_enabled(key);
-
-	if ((!true_branch && state) || (true_branch && !state))
-		return JUMP_LABEL_ENABLE;
-
-	return JUMP_LABEL_DISABLE;
+	return static_key_enabled(key) ? JUMP_LABEL_ENABLE
+	                               : JUMP_LABEL_DISABLE;
 }
 
 static void static_key_rate_limit_flush(struct static_key *key)
@@ -225,10 +214,7 @@ void __init jump_label_init(void)
 			continue;
 
 		key = iterk;
-		/*
-		 * Set key->entries to iter, but preserve JUMP_LABEL_TRUE_BRANCH.
-		 */
-		*((unsigned long *)&key->entries) += (unsigned long)iter;
+		*((unsigned long *)&key->entries) = (unsigned long)iter;
 #ifdef CONFIG_MODULES
 		key->next = NULL;
 #endif
@@ -319,10 +305,7 @@ static int jump_label_add_module(struct module *mod)
 
 		key = iterk;
 		if (__module_address(iter->key) == mod) {
-			/*
-			 * Set key->entries to iter, but preserve JUMP_LABEL_TRUE_BRANCH.
-			 */
-			*((unsigned long *)&key->entries) += (unsigned long)iter;
+			*((unsigned long *)&key->entries) = (unsigned long)iter;
 			key->next = NULL;
 			continue;
 		}
-- 
1.8.3.1

