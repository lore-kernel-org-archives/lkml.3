Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaGILg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:36:29 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45104 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755137AbaGILg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:27 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-68-53bd293822e2
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 03/21] x86: add kasan hooks fort
 memcpy/memmove/memset functions
Date: Wed, 09 Jul 2014 15:29:57 +0400
Message-id: <1404905415-9046-4-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xy7oWmnuDDa4+M7DY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroy5W/8zFeyTr7i9diV7A+Mc
	qS5GTg4JAROJQ+/3s0PYYhIX7q1n62Lk4hASWMooMbXpOzuE08cksfDpTUaQKjYBPYl/s7az
	gdgiAgoSm3ufsYIUMQs0s0m0d3xgBUkICyRL7DrcxwRiswioSkxevwjM5hVwlVh88wLUOgWJ
	ZctngtVzCrhJTJh+jbmLkQNom6vEhBVqExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P
	3cQIiaWvOxiXHrM6xCjAwajEw/ti955gIdbEsuLK3EOMEhzMSiK8tqJ7g4V4UxIrq1KL8uOL
	SnNSiw8xMnFwSjUwWj79cyfyeOAyDadnWluefnQs+ppecUjy4u/Njz6G9Gf9lBTVVoj3PCHg
	WcxtUOmhJVih+uDNja3LnvonR9q9vZucfnH1j92dsp/3Hu/s1uoWmdxq/bfu5DMzk+yyfd/X
	HElhuKAz+e5z+WvbIo2drm5zFPV4NDFkvlGZmZ1Bh+LVz+L2R9ctVGIpzkg01GIuKk4EAJp5
	nJqDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since functions memset, memmove, memcpy are written in assembly,
compiler can't instrument memory accesses inside them.

This patch replaces these functions with our own instrumented
functions (kasan_mem*) for CONFIG_KASAN = y

In rare circumstances you may need to use the original functions,
in such case put #undef KASAN_HOOKS before includes.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/x86/include/asm/string_32.h | 28 ++++++++++++++++++++++++++++
 arch/x86/include/asm/string_64.h | 24 ++++++++++++++++++++++++
 arch/x86/lib/Makefile            |  2 ++
 3 files changed, 54 insertions(+)

diff --git a/arch/x86/include/asm/string_32.h b/arch/x86/include/asm/string_32.h
index 3d3e835..a86615a 100644
--- a/arch/x86/include/asm/string_32.h
+++ b/arch/x86/include/asm/string_32.h
@@ -321,6 +321,32 @@ void *__constant_c_and_count_memset(void *s, unsigned long pattern,
 	 : __memset_generic((s), (c), (count)))
 
 #define __HAVE_ARCH_MEMSET
+
+#if defined(CONFIG_KASAN) && defined(KASAN_HOOKS)
+
+/*
+ * Since some of the following functions (memset, memmove, memcpy)
+ * are written in assembly, compiler can't instrument memory accesses
+ * inside them.
+ *
+ * To solve this issue we replace these functions with our own instrumented
+ * functions (kasan_mem*)
+ *
+ * In rare circumstances you may need to use the original functions,
+ * in such case put #undef KASAN_HOOKS before includes.
+ */
+
+#undef memcpy
+void *kasan_memset(void *ptr, int val, size_t len);
+void *kasan_memcpy(void *dst, const void *src, size_t len);
+void *kasan_memmove(void *dst, const void *src, size_t len);
+
+#define memcpy(dst, src, len) kasan_memcpy((dst), (src), (len))
+#define memset(ptr, val, len) kasan_memset((ptr), (val), (len))
+#define memmove(dst, src, len) kasan_memmove((dst), (src), (len))
+
+#else /* CONFIG_KASAN && KASAN_HOOKS */
+
 #if (__GNUC__ >= 4)
 #define memset(s, c, count) __builtin_memset(s, c, count)
 #else
@@ -331,6 +357,8 @@ void *__constant_c_and_count_memset(void *s, unsigned long pattern,
 	 : __memset((s), (c), (count)))
 #endif
 
+#endif /* CONFIG_KASAN && KASAN_HOOKS */
+
 /*
  * find the first occurrence of byte 'c', or 1 past the area if none
  */
diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 19e2c46..2af2dbe 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -63,6 +63,30 @@ char *strcpy(char *dest, const char *src);
 char *strcat(char *dest, const char *src);
 int strcmp(const char *cs, const char *ct);
 
+#if defined(CONFIG_KASAN) && defined(KASAN_HOOKS)
+
+/*
+ * Since some of the following functions (memset, memmove, memcpy)
+ * are written in assembly, compiler can't instrument memory accesses
+ * inside them.
+ *
+ * To solve this issue we replace these functions with our own instrumented
+ * functions (kasan_mem*)
+ *
+ * In rare circumstances you may need to use the original functions,
+ * in such case put #undef KASAN_HOOKS before includes.
+ */
+
+void *kasan_memset(void *ptr, int val, size_t len);
+void *kasan_memcpy(void *dst, const void *src, size_t len);
+void *kasan_memmove(void *dst, const void *src, size_t len);
+
+#define memcpy(dst, src, len) kasan_memcpy((dst), (src), (len))
+#define memset(ptr, val, len) kasan_memset((ptr), (val), (len))
+#define memmove(dst, src, len) kasan_memmove((dst), (src), (len))
+
+#endif /* CONFIG_KASAN && KASAN_HOOKS */
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_X86_STRING_64_H */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 4d4f96a..d82bc35 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -2,6 +2,8 @@
 # Makefile for x86 specific library files.
 #
 
+KASAN_SANITIZE_memcpy_32.o := n
+
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
-- 
1.8.5.5

