Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab3J2SHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:07:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59286 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3J2SFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 19/81] compiler/gcc4: Add quirk for 'asm goto' miscompilation bug
Date: Tue, 29 Oct 2013 11:03:40 -0700
Message-Id: <1383069882-11437-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ingo Molnar <mingo@kernel.org>

commit 3f0116c3238a96bc18ad4b4acefe4e7be32fa861 upstream.

Fengguang Wu, Oleg Nesterov and Peter Zijlstra tracked down
a kernel crash to a GCC bug: GCC miscompiles certain 'asm goto'
constructs, as outlined here:

  http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670

Implement a workaround suggested by Jakub Jelinek.

Reported-and-tested-by: Fengguang Wu <fengguang.wu@intel.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Suggested-by: Jakub Jelinek <jakub@redhat.com>
Reviewed-by: Richard Henderson <rth@twiddle.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/include/asm/jump_label.h     |  2 +-
 arch/mips/include/asm/jump_label.h    |  2 +-
 arch/powerpc/include/asm/jump_label.h |  2 +-
 arch/s390/include/asm/jump_label.h    |  2 +-
 arch/sparc/include/asm/jump_label.h   |  2 +-
 arch/x86/include/asm/cpufeature.h     |  2 +-
 arch/x86/include/asm/jump_label.h     |  2 +-
 include/linux/compiler-gcc4.h         | 15 +++++++++++++++
 8 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/jump_label.h b/arch/arm/include/asm/jump_label.h
index bfc198c..863c892 100644
--- a/arch/arm/include/asm/jump_label.h
+++ b/arch/arm/include/asm/jump_label.h
@@ -16,7 +16,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\n\t"
+	asm_volatile_goto("1:\n\t"
 		 JUMP_LABEL_NOP "\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 ".word 1b, %l[l_yes], %c0\n\t"
diff --git a/arch/mips/include/asm/jump_label.h b/arch/mips/include/asm/jump_label.h
index 4d6d77e..e194f95 100644
--- a/arch/mips/include/asm/jump_label.h
+++ b/arch/mips/include/asm/jump_label.h
@@ -22,7 +22,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\tnop\n\t"
+	asm_volatile_goto("1:\tnop\n\t"
 		"nop\n\t"
 		".pushsection __jump_table,  \"aw\"\n\t"
 		WORD_INSN " 1b, %l[l_yes], %0\n\t"
diff --git a/arch/powerpc/include/asm/jump_label.h b/arch/powerpc/include/asm/jump_label.h
index ae098c4..f016bb6 100644
--- a/arch/powerpc/include/asm/jump_label.h
+++ b/arch/powerpc/include/asm/jump_label.h
@@ -19,7 +19,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:\n\t"
+	asm_volatile_goto("1:\n\t"
 		 "nop\n\t"
 		 ".pushsection __jump_table,  \"aw\"\n\t"
 		 JUMP_ENTRY_TYPE "1b, %l[l_yes], %c0\n\t"
diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
index 6c32190..346b1c8 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -15,7 +15,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("0:	brcl 0,0\n"
+	asm_volatile_goto("0:	brcl 0,0\n"
 		".pushsection __jump_table, \"aw\"\n"
 		ASM_ALIGN "\n"
 		ASM_PTR " 0b, %l[label], %0\n"
diff --git a/arch/sparc/include/asm/jump_label.h b/arch/sparc/include/asm/jump_label.h
index 5080d16..ec2e2e2 100644
--- a/arch/sparc/include/asm/jump_label.h
+++ b/arch/sparc/include/asm/jump_label.h
@@ -9,7 +9,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-		asm goto("1:\n\t"
+		asm_volatile_goto("1:\n\t"
 			 "nop\n\t"
 			 "nop\n\t"
 			 ".pushsection __jump_table,  \"aw\"\n\t"
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 2d9075e..d3f0db1 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -346,7 +346,7 @@ extern const char * const x86_power_flags[32];
 static __always_inline __pure bool __static_cpu_has(u16 bit)
 {
 #if __GNUC__ > 4 || __GNUC_MINOR__ >= 5
-		asm goto("1: jmp %l[t_no]\n"
+		asm_volatile_goto("1: jmp %l[t_no]\n"
 			 "2:\n"
 			 ".section .altinstructions,\"a\"\n"
 			 " .long 1b - .\n"
diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index 3a16c14..0297669 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -13,7 +13,7 @@
 
 static __always_inline bool arch_static_branch(struct static_key *key)
 {
-	asm goto("1:"
+	asm_volatile_goto("1:"
 		STATIC_KEY_INITIAL_NOP
 		".pushsection __jump_table,  \"aw\" \n\t"
 		_ASM_ALIGN "\n\t"
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index c9785c2..e8f0bf9 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -67,6 +67,21 @@
 #define __visible __attribute__((externally_visible))
 #endif
 
+/*
+ * GCC 'asm goto' miscompiles certain code sequences:
+ *
+ *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
+ *
+ * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
+ * Fixed in GCC 4.8.2 and later versions.
+ *
+ * (asm goto is automatically volatile - the naming reflects this.)
+ */
+#if GCC_VERSION <= 40801
+# define asm_volatile_goto(x...)	do { asm goto(x); asm (""); } while (0)
+#else
+# define asm_volatile_goto(x...)	do { asm goto(x); } while (0)
+#endif
 
 #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
 #if __GNUC_MINOR__ >= 4
-- 
1.8.1.2

