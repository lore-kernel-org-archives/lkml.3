Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab3HEWFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:05:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:21922 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130Ab3HEWDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="342111476"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        jeremy@goop.org
Subject: [PATCH 12/16] x86, asmlinkage, paravirt: Add __visible/asmlinkage to xen paravirt ops
Date: Mon,  5 Aug 2013 15:02:46 -0700
Message-Id: <1375740170-7446-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: jeremy@goop.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/paravirt_types.h |  3 ++-
 arch/x86/kernel/paravirt.c            |  4 ++--
 arch/x86/xen/xen-ops.h                | 16 ++++++++--------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 0db1fca..0617ff2 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -387,7 +387,8 @@ extern struct pv_lock_ops pv_lock_ops;
 
 /* Simple instruction patching code. */
 #define DEF_NATIVE(ops, name, code) 					\
-	extern const char start_##ops##_##name[], end_##ops##_##name[];	\
+	extern const char start_##ops##_##name[] __visible,		\
+			  end_##ops##_##name[] __visible;		\
 	asm("start_" #ops "_" #name ": " code "; end_" #ops "_" #name ":")
 
 unsigned paravirt_patch_nop(void);
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index cd6de64..884aa40 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -324,7 +324,7 @@ struct pv_time_ops pv_time_ops = {
 	.steal_clock = native_steal_clock,
 };
 
-struct pv_irq_ops pv_irq_ops = {
+__visible struct pv_irq_ops pv_irq_ops = {
 	.save_fl = __PV_IS_CALLEE_SAVE(native_save_fl),
 	.restore_fl = __PV_IS_CALLEE_SAVE(native_restore_fl),
 	.irq_disable = __PV_IS_CALLEE_SAVE(native_irq_disable),
@@ -336,7 +336,7 @@ struct pv_irq_ops pv_irq_ops = {
 #endif
 };
 
-struct pv_cpu_ops pv_cpu_ops = {
+__visible struct pv_cpu_ops pv_cpu_ops = {
 	.cpuid = native_cpuid,
 	.get_debugreg = native_get_debugreg,
 	.set_debugreg = native_set_debugreg,
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 86782c5..d380213 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -105,9 +105,9 @@ static inline void __init xen_init_apic(void)
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
-	ret name(__VA_ARGS__);			\
-	extern char name##_end[];		\
-	extern char name##_reloc[]		\
+	asmlinkage ret name(__VA_ARGS__);	\
+	extern char name##_end[] __visible;	\
+	extern char name##_reloc[] __visible
 
 DECL_ASM(void, xen_irq_enable_direct, void);
 DECL_ASM(void, xen_irq_disable_direct, void);
@@ -115,11 +115,11 @@ DECL_ASM(unsigned long, xen_save_fl_direct, void);
 DECL_ASM(void, xen_restore_fl_direct, unsigned long);
 
 /* These are not functions, and cannot be called normally */
-void xen_iret(void);
-void xen_sysexit(void);
-void xen_sysret32(void);
-void xen_sysret64(void);
-void xen_adjust_exception_frame(void);
+asmlinkage void xen_iret(void);
+asmlinkage void xen_sysexit(void);
+asmlinkage void xen_sysret32(void);
+asmlinkage void xen_sysret64(void);
+asmlinkage void xen_adjust_exception_frame(void);
 
 extern int xen_panic_handler_init(void);
 
-- 
1.8.3.1

