Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaJFQCv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:02:51 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:51442 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaJFQBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:01:36 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-eb-5432bcde3a31
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
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, Michal Marek <mmarek@suse.cz>
Subject: [RFC PATCH v4 13/13] kasan: introduce inline instrumentation
Date: Mon, 06 Oct 2014 19:54:07 +0400
Message-id: <1412610847-27671-14-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyWRa0iTUQCGPd/d4ehjeTlImA4SKrImRafQkCI6RIU/DEW6LZ2b5absa5b9
	WjoKlzMx0DZWGlLgMNSpbYYKrdG0IgSvNVxa0znykmYmilZr/5734YX3x8uRkgAZzxVqbii0
	GnmRlBFR77c8Q/t8PalZB+YsR9DL9a8M2ug108ja2sIg9+hvFo2tzgG0HJwEqHOsnECBqSkW
	1UzdZVFdexxqvl/BIMfMPIGaKydpNPTKyiBfyx8aGfoGCdTk9pJoYeYhiUZsr1m01vaNzojG
	Dd1LAHdbJljcaNfhpp4gge22Sgbbl2tZbJwfJnD/ow0K+4frCbw0/ZnCi30jDK7utAH8odHN
	4p/2BNxvWKEzt+WK0vIVRYWlCu3+Y1dEKkNDBVnSJrtl9VtoPfiVbASRHOQPwgfPrWyYY+Gg
	r5UxAhEn4Z8BeKf7Ex0O1QQcNXnoUIvhU+CWxcGEOJpPhB2mmf+e5Lto6FhVhXg7fxI+/mgG
	RsBxFL8Lmp6eDmkxfwrqR14Q4bEEWN87QYU48p+vGzaz4a1yAF0rTqYGiBtBhA3EKHR5JcJV
	pVqWIsjVgk6jTMkrVttB+JwVJ2h6e9QFeA5Io8Q5TlmWhJaXCmVqF4AcKY0WH36SmiUR58vL
	biu0xZe1uiKF4AIEFxmvB6ITXsOF62Aztjjbq818Y07cnTTrrPU6LLk3TWhHXd/g+OhsxHT7
	uBJZqhZUjpqC9MC9nWuas8EvVQMlctOismNvfT470HamJercj5i4a1vK9PXj1ng4P+72ZZ+/
	WPode/SewCU++K7c30WldR7aLMsoSIZWr6pKleT3JkopQSWX7SG1gvwvEHbWYnoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only demonstration how easy this could be achieved.
GCC doesn't support this feature yet. Two patches required for this:
    https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00452.html
    https://gcc.gnu.org/ml/gcc-patches/2014-09/msg00605.html

In inline instrumentation mode compiler directly inserts code
checking shadow memory instead of __asan_load/__asan_store
calls.
This is usually faster than outline. In some workloads inline is
2 times faster than outline instrumentation.

The downside of inline instrumentation is bloated kernel's .text size:

size noasan/vmlinux
   text     data     bss      dec     hex    filename
11759720  1566560  946176  14272456  d9c7c8  noasan/vmlinux

size outline/vmlinux
   text    data     bss      dec      hex    filename
16553474  1602592  950272  19106338  1238a22 outline/vmlinux

size inline/vmlinux
   text    data     bss      dec      hex    filename
32064759  1598688  946176  34609623  21019d7 inline/vmlinux

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 Makefile          |  6 +++++-
 lib/Kconfig.kasan | 24 ++++++++++++++++++++++++
 mm/kasan/kasan.c  | 14 +-------------
 mm/kasan/kasan.h  | 22 ++++++++++++++++++++++
 mm/kasan/report.c | 37 +++++++++++++++++++++++++++++++++++++
 5 files changed, 89 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index 6f8be78..01cfa71 100644
--- a/Makefile
+++ b/Makefile
@@ -758,7 +758,11 @@ KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
 endif
 
 ifdef CONFIG_KASAN
-  ifeq ($(CFLAGS_KASAN),)
+ifdef CONFIG_KASAN_INLINE
+CFLAGS_KASAN += $(call cc-option, -fasan-shadow-offset=$(CONFIG_KASAN_SHADOW_OFFSET)) \
+		 $(call cc-option, --param asan-instrumentation-with-call-threshold=10000)
+endif
+  ifeq ($(strip $(CFLAGS_KASAN)),)
     $(warning Cannot use CONFIG_KASAN: \
 	      -fsanitize=kernel-address not supported by compiler)
   endif
diff --git a/lib/Kconfig.kasan b/lib/Kconfig.kasan
index 94293c8..ec5d680 100644
--- a/lib/Kconfig.kasan
+++ b/lib/Kconfig.kasan
@@ -27,4 +27,28 @@ config TEST_KASAN
 	  out of bounds accesses, use after free. It is useful for testing
 	  kernel debugging features like kernel address sanitizer.
 
+choice
+	prompt "Instrumentation type"
+	depends on KASAN
+	default KASAN_INLINE if X86_64
+
+config KASAN_OUTLINE
+	bool "Outline instrumentation"
+	help
+	  Before every memory access compiler insert function call
+	  __asan_load*/__asan_store*. These functions performs check
+	  of shadow memory. This is slower than inline instrumentation,
+	  however it doesn't bloat size of kernel's .text section so
+	  much as inline does.
+
+config KASAN_INLINE
+	bool "Inline instrumentation"
+	help
+	  Compiler directly inserts code checking shadow memory before
+	  memory accesses. This is faster than outline (in some workloads
+	  it gives about x2 boost over outline instrumentation), but
+	  make kernel's .text size much bigger.
+
+endchoice
+
 endif
diff --git a/mm/kasan/kasan.c b/mm/kasan/kasan.c
index d4552a2..6e34fdb 100644
--- a/mm/kasan/kasan.c
+++ b/mm/kasan/kasan.c
@@ -32,11 +32,6 @@
 #include "kasan.h"
 #include "../slab.h"
 
-static inline bool kasan_enabled(void)
-{
-	return !current->kasan_depth;
-}
-
 /*
  * Poisons the shadow memory for 'size' bytes starting from 'addr'.
  * Memory addresses should be aligned to KASAN_SHADOW_SCALE_SIZE.
@@ -250,14 +245,7 @@ static __always_inline void check_memory_region(unsigned long addr,
 	if (likely(!memory_is_poisoned(addr, size)))
 		return;
 
-	if (likely(!kasan_enabled()))
-		return;
-
-	info.access_addr = addr;
-	info.access_size = size;
-	info.is_write = write;
-	info.ip = _RET_IP_;
-	kasan_report_error(&info);
+	kasan_report(addr, size, write);
 }
 
 void kasan_alloc_pages(struct page *page, unsigned int order)
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index b70a3d1..049349b 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -29,4 +29,26 @@ static inline unsigned long kasan_shadow_to_mem(unsigned long shadow_addr)
 	return (shadow_addr - KASAN_SHADOW_OFFSET) << KASAN_SHADOW_SCALE_SHIFT;
 }
 
+static inline bool kasan_enabled(void)
+{
+	return !current->kasan_depth;
+}
+
+static __always_inline void kasan_report(unsigned long addr,
+					size_t size,
+					bool is_write)
+{
+	struct access_info info;
+
+	if (likely(!kasan_enabled()))
+		return;
+
+	info.access_addr = addr;
+	info.access_size = size;
+	info.is_write = is_write;
+	info.ip = _RET_IP_;
+	kasan_report_error(&info);
+}
+
+
 #endif
diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 03ce28e..39ec639 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -199,3 +199,40 @@ void kasan_report_user_access(struct access_info *info)
 		"=================================\n");
 	spin_unlock_irqrestore(&report_lock, flags);
 }
+
+#define DEFINE_ASAN_REPORT_LOAD(size)                     \
+void __asan_report_recover_load##size(unsigned long addr) \
+{                                                         \
+	kasan_report(addr, size, false);                  \
+}                                                         \
+EXPORT_SYMBOL(__asan_report_recover_load##size)
+
+#define DEFINE_ASAN_REPORT_STORE(size)                     \
+void __asan_report_recover_store##size(unsigned long addr) \
+{                                                          \
+	kasan_report(addr, size, true);                    \
+}                                                          \
+EXPORT_SYMBOL(__asan_report_recover_store##size)
+
+DEFINE_ASAN_REPORT_LOAD(1);
+DEFINE_ASAN_REPORT_LOAD(2);
+DEFINE_ASAN_REPORT_LOAD(4);
+DEFINE_ASAN_REPORT_LOAD(8);
+DEFINE_ASAN_REPORT_LOAD(16);
+DEFINE_ASAN_REPORT_STORE(1);
+DEFINE_ASAN_REPORT_STORE(2);
+DEFINE_ASAN_REPORT_STORE(4);
+DEFINE_ASAN_REPORT_STORE(8);
+DEFINE_ASAN_REPORT_STORE(16);
+
+void __asan_report_recover_load_n(unsigned long addr, size_t size)
+{
+	kasan_report(addr, size, false);
+}
+EXPORT_SYMBOL(__asan_report_recover_load_n);
+
+void __asan_report_recover_store_n(unsigned long addr, size_t size)
+{
+	kasan_report(addr, size, true);
+}
+EXPORT_SYMBOL(__asan_report_recover_store_n);
-- 
2.1.2

