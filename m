Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938AbaH2UWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 16:22:18 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:43255 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaH2UWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 16:22:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH resend] nosave: Consolidate __nosave_{begin,end} in <asm/sections.h>
Date: Fri, 29 Aug 2014 22:22:11 +0200
Message-Id: <1409343731-5292-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The different architectures used their own (and different) declarations:

    extern __visible const void __nosave_begin, __nosave_end;
    extern const void __nosave_begin, __nosave_end;
    extern long __nosave_begin, __nosave_end;

Consolidate them using the first variant in <asm/sections.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This has been sent before, as part of the series "[PATCH 00/17] <asm/sections.h>
related cleanups", almost one year ago (https://lkml.org/lkml/2013/11/12/510).

 arch/mips/include/asm/suspend.h   | 7 -------
 arch/mips/power/cpu.c             | 2 +-
 arch/powerpc/kernel/suspend.c     | 4 +---
 arch/s390/kernel/suspend.c        | 6 +-----
 arch/sh/include/asm/sections.h    | 1 -
 arch/sparc/power/hibernate.c      | 4 +---
 arch/unicore32/include/mach/pm.h  | 3 ---
 arch/unicore32/kernel/hibernate.c | 1 +
 arch/x86/power/hibernate_32.c     | 4 +---
 arch/x86/power/hibernate_64.c     | 4 +---
 include/asm-generic/sections.h    | 4 ++++
 11 files changed, 11 insertions(+), 29 deletions(-)
 delete mode 100644 arch/mips/include/asm/suspend.h

diff --git a/arch/mips/include/asm/suspend.h b/arch/mips/include/asm/suspend.h
deleted file mode 100644
index 3adac3b53d19..000000000000
--- a/arch/mips/include/asm/suspend.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __ASM_SUSPEND_H
-#define __ASM_SUSPEND_H
-
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
-#endif /* __ASM_SUSPEND_H */
diff --git a/arch/mips/power/cpu.c b/arch/mips/power/cpu.c
index 521e5963df05..2129e67723ff 100644
--- a/arch/mips/power/cpu.c
+++ b/arch/mips/power/cpu.c
@@ -7,7 +7,7 @@
  * Author: Hu Hongbing <huhb@lemote.com>
  *	   Wu Zhangjin <wuzhangjin@gmail.com>
  */
-#include <asm/suspend.h>
+#include <asm/sections.h>
 #include <asm/fpu.h>
 #include <asm/dsp.h>
 
diff --git a/arch/powerpc/kernel/suspend.c b/arch/powerpc/kernel/suspend.c
index 0167d53da30c..a531154cc0f3 100644
--- a/arch/powerpc/kernel/suspend.c
+++ b/arch/powerpc/kernel/suspend.c
@@ -9,9 +9,7 @@
 
 #include <linux/mm.h>
 #include <asm/page.h>
-
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
+#include <asm/sections.h>
 
 /*
  *	pfn_is_nosave - check if given pfn is in the 'nosave' section
diff --git a/arch/s390/kernel/suspend.c b/arch/s390/kernel/suspend.c
index a7a7537ce1e7..1c4c5accd220 100644
--- a/arch/s390/kernel/suspend.c
+++ b/arch/s390/kernel/suspend.c
@@ -13,14 +13,10 @@
 #include <asm/ipl.h>
 #include <asm/cio.h>
 #include <asm/pci.h>
+#include <asm/sections.h>
 #include "entry.h"
 
 /*
- * References to section boundaries
- */
-extern const void __nosave_begin, __nosave_end;
-
-/*
  * The restore of the saved pages in an hibernation image will set
  * the change and referenced bits in the storage key for each page.
  * Overindication of the referenced bits after an hibernation cycle
diff --git a/arch/sh/include/asm/sections.h b/arch/sh/include/asm/sections.h
index 1b6199740e98..7a99e6af6372 100644
--- a/arch/sh/include/asm/sections.h
+++ b/arch/sh/include/asm/sections.h
@@ -3,7 +3,6 @@
 
 #include <asm-generic/sections.h>
 
-extern long __nosave_begin, __nosave_end;
 extern long __machvec_start, __machvec_end;
 extern char __uncached_start, __uncached_end;
 extern char __start_eh_frame[], __stop_eh_frame[];
diff --git a/arch/sparc/power/hibernate.c b/arch/sparc/power/hibernate.c
index 42b0b8ce699a..17bd2e167e07 100644
--- a/arch/sparc/power/hibernate.c
+++ b/arch/sparc/power/hibernate.c
@@ -9,11 +9,9 @@
 #include <asm/hibernate.h>
 #include <asm/visasm.h>
 #include <asm/page.h>
+#include <asm/sections.h>
 #include <asm/tlb.h>
 
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
 struct saved_context saved_context;
 
 /*
diff --git a/arch/unicore32/include/mach/pm.h b/arch/unicore32/include/mach/pm.h
index 4dcd34ae194c..77b522694e74 100644
--- a/arch/unicore32/include/mach/pm.h
+++ b/arch/unicore32/include/mach/pm.h
@@ -36,8 +36,5 @@ extern int puv3_pm_enter(suspend_state_t state);
 /* Defined in hibernate_asm.S */
 extern int restore_image(pgd_t *resume_pg_dir, struct pbe *restore_pblist);
 
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
 extern struct pbe *restore_pblist;
 #endif
diff --git a/arch/unicore32/kernel/hibernate.c b/arch/unicore32/kernel/hibernate.c
index d75ef8b6cb56..9969ec374abb 100644
--- a/arch/unicore32/kernel/hibernate.c
+++ b/arch/unicore32/kernel/hibernate.c
@@ -18,6 +18,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
+#include <asm/sections.h>
 #include <asm/suspend.h>
 
 #include "mach/pm.h"
diff --git a/arch/x86/power/hibernate_32.c b/arch/x86/power/hibernate_32.c
index 7d28c885d238..291226b952a9 100644
--- a/arch/x86/power/hibernate_32.c
+++ b/arch/x86/power/hibernate_32.c
@@ -13,13 +13,11 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmzone.h>
+#include <asm/sections.h>
 
 /* Defined in hibernate_asm_32.S */
 extern int restore_image(void);
 
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
 /* Pointer to the temporary resume page tables */
 pgd_t *resume_pg_dir;
 
diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index 35e2bb6c0f37..009947d419a6 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -17,11 +17,9 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/sections.h>
 #include <asm/suspend.h>
 
-/* References to section boundaries */
-extern __visible const void __nosave_begin, __nosave_end;
-
 /* Defined in hibernate_asm_64.S */
 extern asmlinkage __visible int restore_image(void);
 
diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index f1a24b5c3b90..b58fd667f87b 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -3,6 +3,8 @@
 
 /* References to section boundaries */
 
+#include <linux/compiler.h>
+
 /*
  * Usage guidelines:
  * _text, _data: architecture specific, don't use them in arch-independent code
@@ -37,6 +39,8 @@ extern char __start_rodata[], __end_rodata[];
 /* Start and end of .ctors section - used for constructor calls. */
 extern char __ctors_start[], __ctors_end[];
 
+extern __visible const void __nosave_begin, __nosave_end;
+
 /* function descriptor handling (if any).  Override
  * in asm/sections.h */
 #ifndef dereference_function_descriptor
-- 
1.9.1

