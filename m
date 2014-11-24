Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaKXSC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:02:58 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50088 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaKXSCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:02:53 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a4-547372ccc270
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v7 12/12] x86_64: kasan: add interceptors for
 memset/memmove/memcpy functions
Date: Mon, 24 Nov 2014 21:02:25 +0300
Message-id: <1416852146-9781-13-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRXUhTYRzGfc/Z+XA5PJgfb16YDLpQ2DIRehEJhYiXuimSLhaoU08quSk7
	bmh1YTMMV0yxMpvDRiLk0tTj/KT8WKaSYmFTUUs0Uxv4kcvMFDTX7n7/53ngd/FnyaBNMpzN
	0RbwOq06V05LJaMHwy7FmE5IjhE/0Khj7xuN9t8+o5C1uZFGg1N/GDS9swaQx70AkGPaSKDV
	xUUGVSyWMqiqNQw1PCihUefKOoEayhYo9LnHSqP5xkMKlXf+YNBEv41AdYNzJNpYeUSiNvEJ
	iSbtAwzabVmiEkPx8+4tgLstXxlsE/W47o2bwKK9jMaip5LBpnUXgTfGxxk8Ur0vwd9dTwm8
	tTwrwZu9kzQ2O+wA/xIj8Mi9bepyoEqakMnn5hh43elzadLstXftRH51QmHT6Ee6GDyONQGW
	hVwcLDlMMgH/IwyFn+abaROQskFcPYBjfauk7zAT0NHXS3pXNKeEB5ZO2svBnALaV3v+j0hu
	h4JTzT8Zb3GcS4Ur7g3gZQl3ChqNVuC1ybgL0Fmb4hNHwPbXl7zof5TuLht8qrsAPrS00RVA
	ZgN+dhDC6zPyhfQsTaxSUGsEvTZLmZGnEYHvSb+7QP1QvBNwLJAHyAqjhOQgSm0QijROAFlS
	Hiy7kXcUyTLVRbd4XV6qTp/LC05AsP7hxQCkD635KWprXHxV8azypiJmZn8AO5VTL7vMr86O
	bluWrqTYrNe+lCfV3/+bBJ04Mg1sOxJb6RCHJUomFrT2Gi7GocgdZXVhl3HOUWNyv6h83z/j
	CVOZ2YDQ2jt78cdUpZHCeZdn9+qJlsAmdfSIijjZMsxdjyi5rVVJJuQSIVt9JprUCep/vykJ
	DYICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently instrumentation of builtin functions calls was removed from GCC 5.0.
To check the memory accessed by such functions, userspace asan always uses
interceptors for them.

So now we should do this as well. This patch declares memset/memmove/memcpy
as weak symbols. In mm/kasan/kasan.c we have our own implementation
of those functions which checks memory before accessing it.

Default memset/memmove/memcpy now now always have aliases with '__' prefix.
For files that built without kasan instrumentation (e.g. mm/slub.c)
original mem* replaced (via #define) with prefixed variants,
cause we don't want to check memory accesses there.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/x86/boot/compressed/eboot.c |  2 ++
 arch/x86/boot/compressed/misc.h  |  1 +
 arch/x86/include/asm/string_64.h | 18 +++++++++++++++++-
 arch/x86/kernel/x8664_ksyms_64.c | 10 ++++++++--
 arch/x86/lib/memcpy_64.S         |  2 ++
 arch/x86/lib/memmove_64.S        |  4 ++++
 arch/x86/lib/memset_64.S         | 10 ++++++----
 mm/kasan/kasan.c                 | 28 +++++++++++++++++++++++++++-
 8 files changed, 67 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 1acf605..8f46fa7 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -14,6 +14,8 @@
 #include <asm/desc.h>
 
 #undef memcpy			/* Use memcpy from misc.c */
+#undef memset
+#undef memmove
 
 #include "eboot.h"
 
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 24e3e56..04477d6 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -7,6 +7,7 @@
  * we just keep it from happening
  */
 #undef CONFIG_PARAVIRT
+#undef CONFIG_KASAN
 #ifdef CONFIG_X86_32
 #define _ASM_X86_DESC_H 1
 #endif
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 19e2c46..e466119 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -27,11 +27,12 @@ static __always_inline void *__inline_memcpy(void *to, const void *from, size_t
    function. */
 
 #define __HAVE_ARCH_MEMCPY 1
+extern void *__memcpy(void *to, const void *from, size_t len);
+
 #ifndef CONFIG_KMEMCHECK
 #if (__GNUC__ == 4 && __GNUC_MINOR__ >= 3) || __GNUC__ > 4
 extern void *memcpy(void *to, const void *from, size_t len);
 #else
-extern void *__memcpy(void *to, const void *from, size_t len);
 #define memcpy(dst, src, len)					\
 ({								\
 	size_t __len = (len);					\
@@ -53,9 +54,11 @@ extern void *__memcpy(void *to, const void *from, size_t len);
 
 #define __HAVE_ARCH_MEMSET
 void *memset(void *s, int c, size_t n);
+void *__memset(void *s, int c, size_t n);
 
 #define __HAVE_ARCH_MEMMOVE
 void *memmove(void *dest, const void *src, size_t count);
+void *__memmove(void *dest, const void *src, size_t count);
 
 int memcmp(const void *cs, const void *ct, size_t count);
 size_t strlen(const char *s);
@@ -63,6 +66,19 @@ char *strcpy(char *dest, const char *src);
 char *strcat(char *dest, const char *src);
 int strcmp(const char *cs, const char *ct);
 
+#if defined(CONFIG_KASAN) && !defined(__SANITIZE_ADDRESS__)
+
+/*
+ * For files that not instrumented (e.g. mm/slub.c) we
+ * should use not instrumented version of mem* functions.
+ */
+
+#undef memcpy
+#define memcpy(dst, src, len) __memcpy(dst, src, len)
+#define memmove(dst, src, len) __memmove(dst, src, len)
+#define memset(s, c, n) __memset(s, c, n)
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_STRING_64_H */
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 0406819..37d8fa4 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -50,13 +50,19 @@ EXPORT_SYMBOL(csum_partial);
 #undef memset
 #undef memmove
 
+extern void *__memset(void *, int, __kernel_size_t);
+extern void *__memcpy(void *, const void *, __kernel_size_t);
+extern void *__memmove(void *, const void *, __kernel_size_t);
 extern void *memset(void *, int, __kernel_size_t);
 extern void *memcpy(void *, const void *, __kernel_size_t);
-extern void *__memcpy(void *, const void *, __kernel_size_t);
+extern void *memmove(void *, const void *, __kernel_size_t);
+
+EXPORT_SYMBOL(__memset);
+EXPORT_SYMBOL(__memcpy);
+EXPORT_SYMBOL(__memmove);
 
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcpy);
-EXPORT_SYMBOL(__memcpy);
 EXPORT_SYMBOL(memmove);
 
 #ifndef CONFIG_DEBUG_VIRTUAL
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index 56313a3..d79db86 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -53,6 +53,8 @@
 .Lmemcpy_e_e:
 	.previous
 
+.weak memcpy
+
 ENTRY(__memcpy)
 ENTRY(memcpy)
 	CFI_STARTPROC
diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
index 65268a6..9c4b530 100644
--- a/arch/x86/lib/memmove_64.S
+++ b/arch/x86/lib/memmove_64.S
@@ -24,7 +24,10 @@
  * Output:
  * rax: dest
  */
+.weak memmove
+
 ENTRY(memmove)
+ENTRY(__memmove)
 	CFI_STARTPROC
 
 	/* Handle more 32 bytes in loop */
@@ -220,4 +223,5 @@ ENTRY(memmove)
 		.Lmemmove_end_forward-.Lmemmove_begin_forward,	\
 		.Lmemmove_end_forward_efs-.Lmemmove_begin_forward_efs
 	.previous
+ENDPROC(__memmove)
 ENDPROC(memmove)
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 2dcb380..6f44935 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -56,6 +56,8 @@
 .Lmemset_e_e:
 	.previous
 
+.weak memset
+
 ENTRY(memset)
 ENTRY(__memset)
 	CFI_STARTPROC
@@ -147,8 +149,8 @@ ENDPROC(__memset)
          * feature to implement the right patch order.
 	 */
 	.section .altinstructions,"a"
-	altinstruction_entry memset,.Lmemset_c,X86_FEATURE_REP_GOOD,\
-			     .Lfinal-memset,.Lmemset_e-.Lmemset_c
-	altinstruction_entry memset,.Lmemset_c_e,X86_FEATURE_ERMS, \
-			     .Lfinal-memset,.Lmemset_e_e-.Lmemset_c_e
+	altinstruction_entry __memset,.Lmemset_c,X86_FEATURE_REP_GOOD,\
+			     .Lfinal-__memset,.Lmemset_e-.Lmemset_c
+	altinstruction_entry __memset,.Lmemset_c_e,X86_FEATURE_ERMS, \
+			     .Lfinal-__memset,.Lmemset_e_e-.Lmemset_c_e
 	.previous
diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index 9f5326e..190e471 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -44,7 +44,7 @@ static void kasan_poison_shadow(const void *address, size_t size, u8 value)
 	shadow_start = kasan_mem_to_shadow(addr);
 	shadow_end = kasan_mem_to_shadow(addr + size);
 
-	memset((void *)shadow_start, value, shadow_end - shadow_start);
+	__memset((void *)shadow_start, value, shadow_end - shadow_start);
 }
 
 void kasan_unpoison_shadow(const void *address, size_t size)
@@ -248,6 +248,32 @@ static __always_inline void check_memory_region(unsigned long addr,
 	kasan_report(addr, size, write);
 }
 
+#undef memset
+void *memset(void *addr, int c, size_t len)
+{
+	check_memory_region((unsigned long)addr, len, true);
+
+	return __memset(addr, c, len);
+}
+
+#undef memmove
+void *memmove(void *dest, const void *src, size_t count)
+{
+	check_memory_region((unsigned long)src, count, false);
+	check_memory_region((unsigned long)dest, count, true);
+
+	return __memmove(dest, src, count);
+}
+
+#undef memcpy
+void *memcpy(void *to, const void *from, size_t len)
+{
+	check_memory_region((unsigned long)from, len, false);
+	check_memory_region((unsigned long)to, len, true);
+
+	return __memcpy(to, from, len);
+}
+
 void kasan_alloc_pages(struct page *page, unsigned int order)
 {
 	if (likely(!PageHighMem(page)))
-- 
2.1.3

