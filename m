Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaCYRmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:42:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962AbaCYRV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Max Filippov <jcmvbkbc@gmail.com>, Chris Zankel <chris@zankel.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 46/81] xtensa: move spill_registers to traps.h
Date: Tue, 25 Mar 2014 10:15:59 -0700
Message-Id: <1395767794-5012-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 2d6f82fee45a52359012948306587eba704cf35b upstream.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Chris Zankel <chris@zankel.net>
[ kamal: 3.8-stable prereq for
  "e2fd137 xtensa: introduce spill_registers_kernel macro" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/xtensa/include/asm/traps.h | 24 ++++++++++++++++++++++++
 arch/xtensa/kernel/traps.c      | 21 +--------------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/xtensa/include/asm/traps.h b/arch/xtensa/include/asm/traps.h
index 54f7044..b5464ef 100644
--- a/arch/xtensa/include/asm/traps.h
+++ b/arch/xtensa/include/asm/traps.h
@@ -20,4 +20,28 @@
 extern void * __init trap_set_handler(int cause, void *handler);
 extern void do_unhandled(struct pt_regs *regs, unsigned long exccause);
 
+static inline void spill_registers(void)
+{
+	unsigned int a0, ps;
+
+	__asm__ __volatile__ (
+		"movi	a14, " __stringify(PS_EXCM_BIT | LOCKLEVEL) "\n\t"
+		"mov	a12, a0\n\t"
+		"rsr	a13, sar\n\t"
+		"xsr	a14, ps\n\t"
+		"movi	a0, _spill_registers\n\t"
+		"rsync\n\t"
+		"callx0 a0\n\t"
+		"mov	a0, a12\n\t"
+		"wsr	a13, sar\n\t"
+		"wsr	a14, ps\n\t"
+		: : "a" (&a0), "a" (&ps)
+#if defined(CONFIG_FRAME_POINTER)
+		: "a2", "a3", "a4",       "a11", "a12", "a13", "a14", "a15",
+#else
+		: "a2", "a3", "a4", "a7", "a11", "a12", "a13", "a14", "a15",
+#endif
+		  "memory");
+}
+
 #endif /* _XTENSA_TRAPS_H */
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 01e0111..f34b526 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -37,6 +37,7 @@
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
+#include <asm/traps.h>
 
 #ifdef CONFIG_KGDB
 extern int gdb_enter;
@@ -392,26 +393,6 @@ static __always_inline unsigned long *stack_pointer(struct task_struct *task)
 	return sp;
 }
 
-static inline void spill_registers(void)
-{
-	unsigned int a0, ps;
-
-	__asm__ __volatile__ (
-		"movi	a14, " __stringify(PS_EXCM_BIT | 1) "\n\t"
-		"mov	a12, a0\n\t"
-		"rsr	a13, sar\n\t"
-		"xsr	a14, ps\n\t"
-		"movi	a0, _spill_registers\n\t"
-		"rsync\n\t"
-		"callx0 a0\n\t"
-		"mov	a0, a12\n\t"
-		"wsr	a13, sar\n\t"
-		"wsr	a14, ps\n\t"
-		:: "a" (&a0), "a" (&ps)
-		: "a2", "a3", "a4", "a7", "a11", "a12", "a13", "a14", "a15",
-		  "memory");
-}
-
 void show_trace(struct task_struct *task, unsigned long *sp)
 {
 	unsigned long a0, a1, pc;
-- 
1.8.3.2

