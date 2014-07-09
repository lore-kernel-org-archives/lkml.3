Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaGILh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:37:59 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63169 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaGILg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:56 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-07-53bd294cd7d2
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
Subject: [RFC/PATCH RESEND -next 17/21] arm: add kasan hooks fort
 memcpy/memmove/memset functions
Date: Wed, 09 Jul 2014 15:30:11 +0400
Message-id: <1404905415-9046-18-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xy7o+mnuDDW4flLPY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroyXe3cwFZzmr5h1+iJbA+Mr
	ni5GTg4JAROJ39d2sUHYYhIX7q0Hsrk4hASWMkq0HuhmhXD6mCQOzljEDlLFJqAn8W/WdrAO
	EQEFic29z8CKmAWa2STaOz6wgiSEBZIlTn6ZwAJiswioSvw9PhvM5hVwk2g6PIEdYp2CxLLl
	M8HqOYHiE6ZfY+5i5ADa5ioxYYXaBEbeBYwMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFC
	YunLDsbFx6wOMQpwMCrx8GrU7g4WYk0sK67MPcQowcGsJMJrK7o3WIg3JbGyKrUoP76oNCe1
	+BAjEwenVAPj6gj/zy/kBItCo5nEFUWlwhUkj5QyHb383OXGit8bijxWGiuIJf2T4rsZFS4U
	9iVnyltLO1N3s1PBHzItRILCVRKDWS6VsXUKBmZ8S2pjPfRXrttPTfxrXYTmE3dZxpfiX/zm
	P+Sx3fIqNjnsQ3Kkd9Y+tkM7LBa0ffe1W3gzunfTFL+gOCWW4oxEQy3mouJEAPp2CdWDAgAA
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

