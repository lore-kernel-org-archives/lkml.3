Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbbA2PMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:12:46 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19495 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbbA2PMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:42 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-27-54ca4d55ccba
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        x86@kernel.org, linux-mm@kvack.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        linux-efi@vger.kernel.org (open list:EXTENSIBLE FIRMWA...)
Subject: [PATCH v10 11/17] x86_64: kasan: add interceptors for
 memset/memmove/memcpy functions
Date: Thu, 29 Jan 2015 18:11:55 +0300
Message-id: <1422544321-24232-12-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xy7qhvqdCDJqaJC22/XrEZvF770xW
	iznr17BZHLn2nd3i+rc3jBafXj5gtHj+8CG7xYSHbewW0zaKW6zsbmaz2P7sLZPFys4HrBZt
	D28xWlzeNYfN4t6a/6wW/dtfsFtcOrCAyWLxkdvMFu+eTWa22LxpKrPFjw2PWR1EPebv/Mjo
	sXPWXXaPBZtKPRbvecnksWlVJ5vHpk+T2D263l5h8nh37hy7x4kZv1k8nlyZzuTx8ektFo/3
	+66yefRtWcXo8XmTnMeJli+sAfxRXDYpqTmZZalF+nYJXBnXNtxhLXjsWtHW1c7ewDjBqouR
	k0NCwETi1+1NzBC2mMSFe+vZuhi5OIQEljJKrDrSwQjh9DFJbO09xQ5SxSagJ/Fv1nY2EFtE
	QEFic+8zVhCbWeAnq8SuhYpdjBwcwgIJEpP6lUHCLAKqEjOW7GcEsXkF3CUe3T/BDFIiISAn
	ceFjPEiYEyj8795jJohVTYwSG8/OY5vAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4m
	RkgEfdnBuPiY1SFGAQ5GJR7emZtOhgixJpYVV+YeYpTgYFYS4V1qeSpEiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA+Pik1N4pxbGvuHawtdfJ96b+vSm1Qm9VfsTbuQtWtOx6/Al/bOnpRp93ScI
	3bsh9eeNpBBTwU6hD63X/h3LZC2sNyyYOW3PjH1zll+PEt4ltCS6nPvBfunUotzErRPavkqV
	S9zZd69If8meIzztN+ZL6n9LY+VzYIvb3///bNI14eBelT0O9+OUWIozEg21mIuKEwF/qvZ9
	fgIAAA==
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
 arch/x86/boot/compressed/eboot.c       |  3 +--
 arch/x86/boot/compressed/misc.h        |  1 +
 arch/x86/include/asm/string_64.h       | 18 +++++++++++++++++-
 arch/x86/kernel/x8664_ksyms_64.c       | 10 ++++++++--
 arch/x86/lib/memcpy_64.S               |  6 ++++--
 arch/x86/lib/memmove_64.S              |  4 ++++
 arch/x86/lib/memset_64.S               | 10 ++++++----
 drivers/firmware/efi/libstub/efistub.h |  4 ++++
 mm/kasan/kasan.c                       | 31 ++++++++++++++++++++++++++++++-
 9 files changed, 75 insertions(+), 12 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 92b9a5f..ef17683 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -13,8 +13,7 @@
 #include <asm/setup.h>
 #include <asm/desc.h>
 
-#undef memcpy			/* Use memcpy from misc.c */
-
+#include "../string.h"
 #include "eboot.h"
 
 static efi_system_table_t *sys_table;
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
index 56313a3..89b53c9 100644
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
@@ -199,8 +201,8 @@ ENDPROC(__memcpy)
 	 * only outcome...
 	 */
 	.section .altinstructions, "a"
-	altinstruction_entry memcpy,.Lmemcpy_c,X86_FEATURE_REP_GOOD,\
+	altinstruction_entry __memcpy,.Lmemcpy_c,X86_FEATURE_REP_GOOD,\
 			     .Lmemcpy_e-.Lmemcpy_c,.Lmemcpy_e-.Lmemcpy_c
-	altinstruction_entry memcpy,.Lmemcpy_c_e,X86_FEATURE_ERMS, \
+	altinstruction_entry __memcpy,.Lmemcpy_c_e,X86_FEATURE_ERMS, \
 			     .Lmemcpy_e_e-.Lmemcpy_c_e,.Lmemcpy_e_e-.Lmemcpy_c_e
 	.previous
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
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 2be1098..47437b1 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -5,6 +5,10 @@
 /* error code which can't be mistaken for valid address */
 #define EFI_ERROR	(~0UL)
 
+#undef memcpy
+#undef memset
+#undef memmove
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index 45d58f2..8c0bdd6 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -44,7 +44,7 @@ static void kasan_poison_shadow(const void *address, size_t size, u8 value)
 	shadow_start = kasan_mem_to_shadow(addr);
 	shadow_end = kasan_mem_to_shadow(addr + size);
 
-	memset((void *)shadow_start, value, shadow_end - shadow_start);
+	__memset((void *)shadow_start, value, shadow_end - shadow_start);
 }
 
 void kasan_unpoison_shadow(const void *address, size_t size)
@@ -248,6 +248,35 @@ static __always_inline void check_memory_region(unsigned long addr,
 	kasan_report(addr, size, write);
 }
 
+void __asan_loadN(unsigned long addr, size_t size);
+void __asan_storeN(unsigned long addr, size_t size);
+
+#undef memset
+void *memset(void *addr, int c, size_t len)
+{
+	__asan_storeN((unsigned long)addr, len);
+
+	return __memset(addr, c, len);
+}
+
+#undef memmove
+void *memmove(void *dest, const void *src, size_t len)
+{
+	__asan_loadN((unsigned long)src, len);
+	__asan_storeN((unsigned long)dest, len);
+
+	return __memmove(dest, src, len);
+}
+
+#undef memcpy
+void *memcpy(void *dest, const void *src, size_t len)
+{
+	__asan_loadN((unsigned long)src, len);
+	__asan_storeN((unsigned long)dest, len);
+
+	return __memcpy(dest, src, len);
+}
+
 void kasan_alloc_pages(struct page *page, unsigned int order)
 {
 	if (likely(!PageHighMem(page)))
-- 
2.2.2

