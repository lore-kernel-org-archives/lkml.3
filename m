Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab3IQMoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:44:12 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39040 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3IQMoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:44:09 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 08/11] ARM: PIE: Add macro for generating PIE resume trampoline
Date: Tue, 17 Sep 2013 05:43:34 -0700
Message-Id: <1379421817-15759-9-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper that generates a short snippet of code that updates PIE
relocations, loads the stack pointer and calls a C (or asm) function.
The code gets placed into a PIE section.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
---
 arch/arm/include/asm/suspend.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm/include/asm/suspend.h b/arch/arm/include/asm/suspend.h
index cd20029..92996f0 100644
--- a/arch/arm/include/asm/suspend.h
+++ b/arch/arm/include/asm/suspend.h
@@ -1,6 +1,8 @@
 #ifndef __ASM_ARM_SUSPEND_H
 #define __ASM_ARM_SUSPEND_H
 
+#include <asm/pie.h>
+
 struct sleep_save_sp {
 	u32 *save_ptr_stash;
 	u32 save_ptr_stash_phys;
@@ -9,4 +11,27 @@ struct sleep_save_sp {
 extern void cpu_resume(void);
 extern int cpu_suspend(unsigned long, int (*)(unsigned long));
 
+/**
+ * ARM_PIE_RESUME - generate a PIE trampoline for resume
+ * @proc:	SoC, should match argument used with PIE_OVERLAY_SECTION()
+ * @func:	C or asm function to call at resume
+ * @stack:	stack to use before calling func
+ */
+#define ARM_PIE_RESUME(proc, func, stack)				\
+static void __naked __noreturn __pie(proc) proc##_resume_trampoline2(void) \
+{									\
+	__asm__ __volatile__(						\
+	"	mov	sp, %0\n"					\
+	: : "r"((stack)) : "sp");					\
+									\
+	func();								\
+}									\
+									\
+void __naked __noreturn __pie(proc) proc##_resume_trampoline(void)	\
+{									\
+	pie_relocate_from_pie();					\
+	proc##_resume_trampoline2();					\
+}									\
+EXPORT_PIE_SYMBOL(proc##_resume_trampoline)
+
 #endif
-- 
1.8.3.2

