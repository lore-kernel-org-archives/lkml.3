Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab3J3Sou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:44:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51713 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab3J3Sos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:44:48 -0400
Date: Wed, 30 Oct 2013 19:44:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: will.deacon@arm.com, fweisbec@gmail.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] perf: Fix arch_perf_out_copy_user default implementation
Message-ID: <20131030184442.GQ2490@laptop.programming.kicks-ass.net>
References: <20131030143750.GT19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030143750.GT19466@laptop.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf: Fix arch_perf_out_copy_user default implementation

I noticed that the arch_perf_output_copy_user default of
__copy_from_user_inatomic has different return semantics that all other
memcpy functions we use -- notably also copy_from_user_nmi() for x86.

So provide a compatible default function.

Also change all the memcpy functions to use unsigned long.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/events/internal.h | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index ca6599723be5..325e85776406 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -82,14 +82,14 @@ static inline unsigned long perf_data_size(struct ring_buffer *rb)
 }
 
 #define DEFINE_OUTPUT_COPY(func_name, memcpy_func)			\
-static inline unsigned int						\
+static inline unsigned long						\
 func_name(struct perf_output_handle *handle,				\
-	  const void *buf, unsigned int len)				\
+	  const void *buf, unsigned long len)				\
 {									\
 	unsigned long size, written;					\
 									\
 	do {								\
-		size = min_t(unsigned long, handle->size, len);		\
+		size = min(handle->size, len);				\
 									\
 		written = memcpy_func(handle->addr, buf, size);		\
 									\
@@ -110,7 +110,8 @@ func_name(struct perf_output_handle *handle,				\
 	return len;							\
 }
 
-static inline int memcpy_common(void *dst, const void *src, size_t n)
+static inline unsigned long
+memcpy_common(void *dst, const void *src, unsigned long n)
 {
 	memcpy(dst, src, n);
 	return n;
@@ -118,12 +119,28 @@ static inline int memcpy_common(void *dst, const void *src, size_t n)
 
 DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
 
-#define MEMCPY_SKIP(dst, src, n) (n)
+static inline unsigned long
+memcpy_skip(void *dst, const void *src, unsigned long n)
+{
+	return n;
+}
 
-DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
+DEFINE_OUTPUT_COPY(__output_skip, memcpy_skip)
 
 #ifndef arch_perf_out_copy_user
-#define arch_perf_out_copy_user __copy_from_user_inatomic
+#define arch_perf_out_copy_user arch_perf_out_copy_user
+
+static inline unsigned long
+arch_perf_out_copy_user(void *dst, const void *src, unsigned long n)
+{
+	unsigned long ret;
+
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(dst, src, n);
+	pagefault_enable();
+
+	return n - ret;
+}
 #endif
 
 DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
