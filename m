Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaGILMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:12:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25379 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaGILK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:26 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ac-53bd231c5f0e
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 17/21] arm: add kasan hooks fort
 memcpy/memmove/memset functions
Date: Wed, 09 Jul 2014 15:01:14 +0400
Message-id: <1404903678-8257-18-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHJMWRmVeSWpSXmKPExsVy+t/xy7oyynuDDY790LLY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+Pl3h1MBaf5K2advsjWwPiKp4uRk0NCwERi
	1dc2FghbTOLCvfVsXYxcHEICSxklWta+ZIdw+pgkPm17yAxSxSagJ/Fv1nY2EFtEQEFic+8z
	VhCbWUBHYuO1ViYQW1ggRuLYzv2MIDaLgKrE4kdTwGxeATeJhRcms0JsU5BYtnwmmM0JFO/p
	WQDWKyTgKrH68zbGCYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEhMGXHYyLj1kd
	YhTgYFTi4dWo3R0sxJpYVlyZe4hRgoNZSYTXVnRvsBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG
	SU59kgF/7v9cPffD8wtG4hK5JltetG5fn+u1vYTrv/56ZrkDfNU2jDZiTs8ZnoTabTwSt8ku
	9mtT+9pewbkH9tref7h+YcrS6tfvpN31YqWKosq396b4MT6RXaKx1+7qH+XUyBsuMYLf/kYm
	fLway7gn1bDF9sBlAWaJ1f+MDVu6ZFglkrYrsRRnJBpqMRcVJwIAKJD3yeEBAAA=
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
 arch/arm/include/asm/string.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/include/asm/string.h b/arch/arm/include/asm/string.h
index cf4f3aa..3cbe47f 100644
--- a/arch/arm/include/asm/string.h
+++ b/arch/arm/include/asm/string.h
@@ -38,4 +38,34 @@ extern void __memzero(void *ptr, __kernel_size_t n);
 		(__p);							\
 	})
 
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
+ * In case if any of mem*() fucntions are written in C we use our instrumented
+ * functions for perfomance reasons. It's should be faster to check whole
+ * accessed memory range at once, then do a lot of checks at each memory access.
+ *
+ * In rare circumstances you may need to use the original functions,
+ * in such case #undef KASAN_HOOKS before includes.
+ */
+#undef memset
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
 #endif
-- 
1.8.5.5

