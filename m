Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab3GEPix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:38:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52573 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab3GEPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:38:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arch@vger.kernel.org
Subject: [PATCH, re-send] Always trap on BUG()
Date: Fri, 5 Jul 2013 17:38:35 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307051738.35930.arnd@arndb.de>
X-Provags-ID: V02:K0:tuGYCYYTwrJ6pelxGd4KQccl8MGUUeeS2OIZ2cynNT+
 yDQBG8YOROL5jnN6Yoy9fMeApzlWY+7pOoucactN1TSe1X8lRh
 u9PWs9g7qYBEnN/9FANzzGfvii9qQlkO+62U0AaEEcdE2wU2Gm
 1GisdfQ4IrQvpnjXaJKel6aYeQhmn2/rFbQzDQcY8mQZcSG/Eo
 XkzjhBp1XZPycK/x3iPyWOEuhh8+pRR61c+kl63QHhGQyZDD6k
 4k6eZKMUPmlnkUU4TwQClKY6JtvlalhIikX1KkGp76ju8hH58N
 PreasKhmOA8ctxv8LMfhlZMTjngAhFMwWX/P2mlNFcp4Fw0Zgi
 hYAUXuCtBtbA/M+RVVgc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've run some size analyis using the ARM 'multi_v7_defconfig'
and gcc-4.8, using various definitions for BUG() and BUG_ON(), to
see how big the size improvement actually gets

1. Baseline: normal bug plus CONFIG_BUG_VERBOSE
   text    data     bss     dec     hex filename
3743196  224396  206812 4174404  3fb244 vmlinux-bugverbose

2. disabling CONFIG_BUG_VERBOSE, saving 0.6%
3716920  224380  206812 4148112  3f4b90 vmlinux-nobugverbose

3. #define BUG() panic(__func__), #define BUG_ON(c) if(c) BUG(), saving 1.0%
3701076  224384  206812 4132272  3f0db0 vmlinux-bug-panicfunc

3. #define BUG() panic(__func__), #define BUG_ON(c) if(c) BUG(), saving 1.5%
3678884  224400  206812 4110096  3eb710 vmlinux-bug-panic

4. #define BUG() unreachable(), saving 2.1%
3652636  224384  206812 4083832  3e5078 vmlinux-bug-unreachable

5. as 4, plus #define BUG_ON(c) if(c) unreachable(), saving 2.2%
3651108  224380  206812 4082300  3e4a7c vmlinux-bugon-unreachable

6. #define BUG() do{}while(0), saving 2.1%
3654264  224380  206812 4085456  3e56d0 vmlinux-nobug

7. as 6, plus #define BUG_ON if(0 && (c)) unreachable, saving 2.2%
3648392  223996  206748 4079136  3e3e20 vmlinux-no-bugon

8. my patch below, saving 1.8%
3666532  224380  206812 4097724  3e86bc obj-tmp/vmlinux

The gain of doing unreachable and letting the code run off whereever
is minimal compared to the current state of doing nothing, but it
avoids the warnings.

Same test using x86_defconfig:

1. CONFIG_BUG=y, CONFIG_BUGVERBOSE=n
10797859        1395648 1175552 13369059         cbfee3 vmlinux-x86-bug

2. CONFIG_BUG=n, saves 1.0%
10658553        1395584 1175552 13229689         c9de79 vmlinux-x86-nobug

3. with my patch, saves 0.8%
10684186        1395584 1175552 13255322         ca429a vmlinux-x86-archbug

Getting 1-2% savings in kernel size seems absolutely worth keeping the
option, but 0.2-0.4% left for getting reproducible behavior also seems
worthwhile. The result in the patch below.

This basically loses any of the BUG() reporting, but leaves the
logic to trap and kill the task in place when CONFIG_BUG is disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
Cc: Chen Gang <gang.chen@asianux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>

diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
index 7af5c6c..4a5b85d 100644
--- a/arch/arm/include/asm/bug.h
+++ b/arch/arm/include/asm/bug.h
@@ -3,8 +3,6 @@
 
 #include <linux/linkage.h>
 
-#ifdef CONFIG_BUG
-
 /*
  * Use a suitable undefined instruction to use for ARM/Thumb2 bug handling.
  * We need to be careful not to conflict with those used by other modules and
@@ -54,7 +52,6 @@ do {								\
 #endif  /* CONFIG_DEBUG_BUGVERBOSE */
 
 #define HAVE_ARCH_BUG
-#endif  /* CONFIG_BUG */
 
 #include <asm-generic/bug.h>
 
diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index 2f03ff0..ba38ebb 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_BUG_H
 #define _ASM_X86_BUG_H
 
-#ifdef CONFIG_BUG
 #define HAVE_ARCH_BUG
 
 #ifdef CONFIG_DEBUG_BUGVERBOSE
@@ -33,8 +32,6 @@ do {								\
 } while (0)
 #endif
 
-#endif /* !CONFIG_BUG */
-
 #include <asm-generic/bug.h>
 
 #endif /* _ASM_X86_BUG_H */
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 7d10f96..bbd2872 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -112,12 +112,13 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
+#define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while(0)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON
 #define WARN_ON(condition) ({						\
 	int __ret_warn_on = !!(condition);				\
+	(void)__ret_warn_on;						\
 	unlikely(__ret_warn_on);					\
 })
 #endif
@@ -125,6 +126,8 @@ extern void warn_slowpath_null(const char *file, const int line);
 #ifndef WARN
 #define WARN(condition, format...) ({					\
 	int __ret_warn_on = !!(condition);				\
+	if (0 && (__ret_warn_on))					\
+		printk(format);						\
 	unlikely(__ret_warn_on);					\
 })
 #endif
