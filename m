Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaLIRe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:34:57 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36545 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbaLIRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:34:53 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [RFC PATCH 1/8] kprobes: Fix kallsyms lookup across powerpc ABIv1 and ABIv2
Date: Tue,  9 Dec 2014 23:03:59 +0530
Message-Id: <7a96a9c262a818112955da93f8ff1ada1bfe5c59.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418146300.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120917-0025-0000-0000-000000B14C28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all non-dot symbols are being treated as function descriptors
in ABIv1. This is incorrect and is resulting in perf probe not working:

  # perf probe do_fork
  Added new event:
  Failed to write event: Invalid argument
    Error: Failed to add events.
  # dmesg | tail -1
  [192268.073063] Could not insert probe at _text+768432: -22

_text is being resolved incorrectly and is resulting in the above error.
Fix this by changing how we lookup symbol addresses on ppc64. We first
check for the dot variant of a symbol and look at the non-dot variant
only if that fails. In this manner, we avoid having to look at the
function descriptor.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/code-patching.h | 26 +++++++++-----
 arch/powerpc/include/asm/kprobes.h       | 58 ++++++++++++++++++++++----------
 2 files changed, 58 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/include/asm/code-patching.h b/arch/powerpc/include/asm/code-patching.h
index 840a550..19c5bab 100644
--- a/arch/powerpc/include/asm/code-patching.h
+++ b/arch/powerpc/include/asm/code-patching.h
@@ -47,18 +47,12 @@ void __patch_exception(int exc, unsigned long addr);
 #define ADDIS_R2_R12	0x3c4c0000UL
 #define ADDI_R2_R2	0x38420000UL
 
-static inline unsigned long ppc_function_entry(void *func)
+static inline unsigned long ppc_local_function_entry(void *func)
 {
-#if defined(CONFIG_PPC64)
-#if defined(_CALL_ELF) && _CALL_ELF == 2
+#if defined(CONFIG_PPC64) && defined(_CALL_ELF) && _CALL_ELF == 2
 	u32 *insn = func;
 
 	/*
-	 * A PPC64 ABIv2 function may have a local and a global entry
-	 * point. We need to use the local entry point when patching
-	 * functions, so identify and step over the global entry point
-	 * sequence.
-	 *
 	 * The global entry point sequence is always of the form:
 	 *
 	 * addis r2,r12,XXXX
@@ -76,6 +70,22 @@ static inline unsigned long ppc_function_entry(void *func)
 	else
 		return (unsigned long)func;
 #else
+	return (unsigned long)func;
+#endif
+}
+
+static inline unsigned long ppc_function_entry(void *func)
+{
+#if defined(CONFIG_PPC64)
+#if defined(_CALL_ELF) && _CALL_ELF == 2
+	/*
+	 * A PPC64 ABIv2 function may have a local and a global entry
+	 * point. We need to use the local entry point when patching
+	 * functions, so identify and step over the global entry point
+	 * sequence.
+	 */
+	return ppc_local_function_entry(func);
+#else
 	/*
 	 * On PPC64 ABIv1 the function pointer actually points to the
 	 * function's descriptor. The first entry in the descriptor is the
diff --git a/arch/powerpc/include/asm/kprobes.h b/arch/powerpc/include/asm/kprobes.h
index af15d4d..060bdea 100644
--- a/arch/powerpc/include/asm/kprobes.h
+++ b/arch/powerpc/include/asm/kprobes.h
@@ -42,30 +42,52 @@ typedef ppc_opcode_t kprobe_opcode_t;
 
 #ifdef CONFIG_PPC64
 /*
- * 64bit powerpc uses function descriptors.
- * Handle cases where:
- * 		- User passes a <.symbol> or <module:.symbol>
- * 		- User passes a <symbol> or <module:symbol>
- * 		- User passes a non-existent symbol, kallsyms_lookup_name
- * 		  returns 0. Don't deref the NULL pointer in that case
+ * ppc64[le] uses function descriptors with ABIv1 and global/local
+ * entry points for ABIv2:
+ * - Check for the dot variant of the symbol first. If that exists, then
+ *   we know this is ABIv1 and we have the symbol and not the descriptor.
+ * - If that fails, try looking up the symbol provided. If that works,
+ *   then we either have ABIv1 symbol (not the descriptor) or ABIv2
+ *   global entry point.
+ *
+ * Also handle <module:symbol> format.
  */
 #define kprobe_lookup_name(name, addr)					\
 {									\
-	addr = (kprobe_opcode_t *)kallsyms_lookup_name(name);		\
-	if (addr) {							\
-		char *colon;						\
-		if ((colon = strchr(name, ':')) != NULL) {		\
-			colon++;					\
-			if (*colon != '\0' && *colon != '.')		\
-				addr = (kprobe_opcode_t *)ppc_function_entry(addr); \
-		} else if (name[0] != '.')				\
-			addr = (kprobe_opcode_t *)ppc_function_entry(addr); \
-	} else {							\
-		char dot_name[KSYM_NAME_LEN];				\
+	char dot_name[MODULE_NAME_LEN + 1 + KSYM_NAME_LEN];		\
+	char *modsym;							\
+	bool dot_appended = false;					\
+	if ((modsym = strchr(name, ':')) != NULL) {			\
+		modsym++;						\
+		if (*modsym != '\0' && *modsym != '.') {		\
+			/* Convert to <module:.symbol> */		\
+			strncpy(dot_name, name, modsym - name);		\
+			dot_name[modsym - name] = '.';			\
+			dot_name[modsym - name + 1] = '\0';		\
+			strncat(dot_name, modsym, sizeof(dot_name) - (modsym - name) - 2);	\
+			dot_appended = true;				\
+		} else {						\
+			dot_name[0] = '\0';				\
+			strncat(dot_name, name, sizeof(dot_name) - 1);	\
+		}							\
+	} else if (name[0] != '.') {					\
 		dot_name[0] = '.';					\
 		dot_name[1] = '\0';					\
 		strncat(dot_name, name, KSYM_NAME_LEN - 2);		\
-		addr = (kprobe_opcode_t *)kallsyms_lookup_name(dot_name); \
+		dot_appended = true;					\
+	} else {							\
+		dot_name[0] = '\0';					\
+		strncat(dot_name, name, KSYM_NAME_LEN - 1);		\
+	}								\
+	addr = (kprobe_opcode_t *)kallsyms_lookup_name(dot_name);	\
+	if (!addr && dot_appended) {					\
+		/* Let's try the original symbol lookup	*/		\
+		addr = (kprobe_opcode_t *)kallsyms_lookup_name(name);	\
+		if (addr) {						\
+			/* We know this isn't a function descriptor */  \
+			/* But, this could be the global entry point */ \
+			addr = (kprobe_opcode_t *)ppc_local_function_entry(addr);		\
+		}							\
 	}								\
 }
 #endif
-- 
2.1.3

