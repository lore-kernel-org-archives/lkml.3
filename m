Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3DLOLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 10:11:55 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63035 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3DLOLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 10:11:53 -0400
From: Dave Martin <dave.martin@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Tim Bird <tim.bird@am.sony.com>,
        Andi Kleen <andi.kleen@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] ARM: Remove backwards-compatibility IT macros for CONFIG_LTO
Date: Fri, 12 Apr 2013 15:11:45 +0100
Message-Id: <1365775905-13173-1-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old assemblers which don't support Thumb-2 also don't accept the IT
instructions.  Currently, dummy macros are defined when
CONFIG_ARM_ASM_UNIFIED=n, to allow assembly to annotate code with
IT instructions even if the tools being used are too old to support
them.

These macro definitions interfere with link-time-optimisation (LTO)
because LTO may optimise and wedge multiple compilation units
together into huge, combined source files passed to the assembler.
LTO may in general reorder compilation units at the top level,
which may also cause the macro definitions to move after the point
where they are needed.

Since LTO depends on tools far too new to lack Thumb-2 support,
this patch gets rid of the dummy macros when building .c files.
Any IT instructions should be understood natively by the assembler
and accepted [*] The macros are not strictly needed for .S files in
this case either, but they are harmless and so retained for now.

[*] Some GCC versions between 4.6 and 4.7 erroneously generate some
IT instructions in the compiler output even with -marm.  This
doesn't seem to have been causing a lot of problems for people, so
it looks like recent assemblers don't barf on those instructions.

Signed-off-by: Dave Martin <dave.martin@linaro.org>
---
If this works, I believe it can supersede other currently proposed
patches for working around this issue.

I've done dome trivial build-testing, but haven't tried this with
LTO yet and don't have a wide variety of older tools to play with.

Testing/comments would be gratefully appreciated.

 arch/arm/include/asm/unified.h |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
index f5989f4..2fafbe9 100644
--- a/arch/arm/include/asm/unified.h
+++ b/arch/arm/include/asm/unified.h
@@ -54,12 +54,18 @@
 
 #endif	/* CONFIG_THUMB2_KERNEL */
 
-#ifndef CONFIG_ARM_ASM_UNIFIED
-
+#if !defined(CONFIG_ARM_ASM_UNIFIED) && !defined(CONFIG_LTO)
 /*
  * If the unified assembly syntax isn't used (in ARM mode), these
- * macros expand to an empty string
+ * macros expand to an empty string.
+ *
+ * These macro definitions can leak between compilation units if LTO
+ * is enabled, causing post-LTO assembly failures.  Newer versions of
+ * gas will silently accept IT instructions even in non-unified mode.
+ * So we'll assume the tools are new enough in that case and skip the
+ * macro definitions.
  */
+
 #ifdef __ASSEMBLY__
 	.macro	it, cond
 	.endm
@@ -125,6 +131,6 @@ __asm__(
 "	.endm\n");
 #endif	/* __ASSEMBLY__ */
 
-#endif	/* CONFIG_ARM_ASM_UNIFIED */
+#endif	/* CONFIG_ARM_ASM_UNIFIED || CONFIG_LTO */
 
 #endif	/* !__ASM_UNIFIED_H */
-- 
1.7.9.5

