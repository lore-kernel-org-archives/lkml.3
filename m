Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423200Ab3FUF6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 01:58:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965602Ab3FUF6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 01:58:05 -0400
Date: Thu, 20 Jun 2013 22:57:50 -0700
From: tip-bot for Seiji Aguchi <tipbot@zytor.com>
Message-ID: <tip-629f4f9d59a27d8e58aa612e886e6a9a63ea7aeb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, seiji.aguchi@hds.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, seiji.aguchi@hds.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <51C323A8.7050905@hds.com>
References: <51C323A8.7050905@hds.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/trace] x86: Rename variables for debugging
Git-Commit-ID: 629f4f9d59a27d8e58aa612e886e6a9a63ea7aeb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 22:57:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  629f4f9d59a27d8e58aa612e886e6a9a63ea7aeb
Gitweb:     http://git.kernel.org/tip/629f4f9d59a27d8e58aa612e886e6a9a63ea7aeb
Author:     Seiji Aguchi <seiji.aguchi@hds.com>
AuthorDate: Thu, 20 Jun 2013 11:45:44 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Jun 2013 22:25:13 -0700

x86: Rename variables for debugging

Rename variables for debugging to describe meaning of them precisely.

Also, introduce a generic way to switch IDT by checking a current state,
debug on/off.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
Link: http://lkml.kernel.org/r/51C323A8.7050905@hds.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/desc.h  | 47 +++++++++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/common.c | 16 +++++++--------
 arch/x86/kernel/head_64.S    |  2 +-
 arch/x86/kernel/traps.c      |  2 +-
 4 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 8bf1c06..af290b8 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -36,8 +36,8 @@ static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *in
 
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
-extern struct desc_ptr nmi_idt_descr;
-extern gate_desc nmi_idt_table[];
+extern struct desc_ptr debug_idt_descr;
+extern gate_desc debug_idt_table[];
 
 struct gdt_page {
 	struct desc_struct gdt[GDT_ENTRIES];
@@ -316,7 +316,7 @@ static inline void set_nmi_gate(int gate, void *addr)
 	gate_desc s;
 
 	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
-	write_idt_entry(nmi_idt_table, gate, &s);
+	write_idt_entry(debug_idt_table, gate, &s);
 }
 #endif
 
@@ -405,4 +405,45 @@ static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
 }
 
+#ifdef CONFIG_X86_64
+DECLARE_PER_CPU(u32, debug_idt_ctr);
+static inline bool is_debug_idt_enabled(void)
+{
+	if (this_cpu_read(debug_idt_ctr))
+		return true;
+
+	return false;
+}
+
+static inline void load_debug_idt(void)
+{
+	load_idt((const struct desc_ptr *)&debug_idt_descr);
+}
+#else
+static inline bool is_debug_idt_enabled(void)
+{
+	return false;
+}
+
+static inline void load_debug_idt(void)
+{
+}
+#endif
+
+/*
+ * the load_current_idt() is called with interrupt disabled by local_irq_save()
+ * to avoid races. That way the IDT will always be set back to the expected
+ * descriptor.
+ */
+static inline void load_current_idt(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	if (is_debug_idt_enabled())
+		load_debug_idt();
+	else
+		load_idt((const struct desc_ptr *)&idt_descr);
+	local_irq_restore(flags);
+}
 #endif /* _ASM_X86_DESC_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22018f7..8f6a0f9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1071,8 +1071,8 @@ __setup("clearcpuid=", setup_disablecpuid);
 
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
-struct desc_ptr nmi_idt_descr = { NR_VECTORS * 16 - 1,
-				    (unsigned long) nmi_idt_table };
+struct desc_ptr debug_idt_descr = { NR_VECTORS * 16 - 1,
+				    (unsigned long) debug_idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
@@ -1148,20 +1148,20 @@ int is_debug_stack(unsigned long addr)
 		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
 
-static DEFINE_PER_CPU(u32, debug_stack_use_ctr);
+DEFINE_PER_CPU(u32, debug_idt_ctr);
 
 void debug_stack_set_zero(void)
 {
-	this_cpu_inc(debug_stack_use_ctr);
-	load_idt((const struct desc_ptr *)&nmi_idt_descr);
+	this_cpu_inc(debug_idt_ctr);
+	load_current_idt();
 }
 
 void debug_stack_reset(void)
 {
-	if (WARN_ON(!this_cpu_read(debug_stack_use_ctr)))
+	if (WARN_ON(!this_cpu_read(debug_idt_ctr)))
 		return;
-	if (this_cpu_dec_return(debug_stack_use_ctr) == 0)
-		load_idt((const struct desc_ptr *)&idt_descr);
+	if (this_cpu_dec_return(debug_idt_ctr) == 0)
+		load_current_idt();
 }
 
 #else	/* CONFIG_X86_64 */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 321d65e..84fb779 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -518,7 +518,7 @@ ENTRY(idt_table)
 	.skip IDT_ENTRIES * 16
 
 	.align L1_CACHE_BYTES
-ENTRY(nmi_idt_table)
+ENTRY(debug_idt_table)
 	.skip IDT_ENTRIES * 16
 
 	__PAGE_ALIGNED_BSS
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 772e2a8..d27182d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -785,7 +785,7 @@ void __init trap_init(void)
 	x86_init.irqs.trap_init();
 
 #ifdef CONFIG_X86_64
-	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
+	memcpy(&debug_idt_table, &idt_table, IDT_ENTRIES * 16);
 	set_nmi_gate(X86_TRAP_DB, &debug);
 	set_nmi_gate(X86_TRAP_BP, &int3);
 #endif
