Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaLOOwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:52:55 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40509 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLOOvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:51:00 -0500
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        acme@kernel.org, mpe@ellerman.id.au
Cc: ananth@in.ibm.com
Subject: [PATCHv2 1/8] kprobes: Fix kallsyms lookup across powerpc ABIv1 and ABIv2
Date: Mon, 15 Dec 2014 20:20:31 +0530
Message-Id: <4b28743424effcf0dc4c3b4656d95cab494b248d.1418654436.git.naveen.n.rao@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
In-Reply-To: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
References: <cover.1418654435.git.naveen.n.rao@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121514-0025-0000-0000-000000BD8B1B
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

perf probe bases all kernel probes on _text and writes,
for example, "p:probe/do_fork _text+768432" to
/sys/kernel/debug/tracing/kprobe_events. In-kernel, _text is being
considered to be a function descriptor and is resulting in the above
error.

Fix this by changing how we lookup symbol addresses on ppc64. We first
check for the dot variant of a symbol and look at the non-dot variant
only if that fails. In this manner, we avoid having to look at the
function descriptor.

While at it, also separate out how this works on ABIv2 where
we don't have dot symbols, but need to use the local entry point.

Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
---
Mike,
I have restricted all changes to just the kprobe_lookup_name() macro. It has
now been split into different implementations for ABIv1 and ABIv2, hopefully
addressing the concerns you raised previously.

- Naveen

 arch/powerpc/include/asm/kprobes.h | 63 ++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/kprobes.h b/arch/powerpc/include/asm/kprobes.h
index af15d4d..039b583 100644
--- a/arch/powerpc/include/asm/kprobes.h
+++ b/arch/powerpc/include/asm/kprobes.h
@@ -41,34 +41,59 @@ typedef ppc_opcode_t kprobe_opcode_t;
 #define MAX_INSN_SIZE 1
 
 #ifdef CONFIG_PPC64
+#if defined(_CALL_ELF) && _CALL_ELF == 2
+/* PPC64 ABIv2 needs local entry point */
+#define kprobe_lookup_name(name, addr)					\
+{									\
+	addr = (kprobe_opcode_t *)kallsyms_lookup_name(name);		\
+	if (addr)							\
+		addr = (kprobe_opcode_t *)ppc_function_entry(addr);	\
+}
+#else
 /*
- * 64bit powerpc uses function descriptors.
- * Handle cases where:
- * 		- User passes a <.symbol> or <module:.symbol>
- * 		- User passes a <symbol> or <module:symbol>
- * 		- User passes a non-existent symbol, kallsyms_lookup_name
- * 		  returns 0. Don't deref the NULL pointer in that case
+ * 64bit powerpc ABIv1 uses function descriptors:
+ * - Check for the dot variant of the symbol first.
+ * - If that fails, try looking up the symbol provided.
+ *
+ * This ensures we always get to the actual symbol and not the descriptor.
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
+			strncat(dot_name, modsym,			\
+				sizeof(dot_name) - (modsym - name) - 2);\
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
+		/* Let's try the original non-dot symbol lookup	*/	\
+		addr = (kprobe_opcode_t *)kallsyms_lookup_name(name);	\
 	}								\
 }
-#endif
+#endif /* defined(_CALL_ELF) && _CALL_ELF == 2 */
+#endif /* CONFIG_PPC64 */
 
 #define flush_insn_slot(p)	do { } while (0)
 #define kretprobe_blacklist_size 0
-- 
2.1.3

