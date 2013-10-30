Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3J3OiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:38:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45767 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab3J3OiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:38:00 -0400
Date: Wed, 30 Oct 2013 15:37:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: will.deacon@arm.com, fweisbec@gmail.com
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] perf: arch_perf_out_copy_user default
Message-ID: <20131030143750.GT19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

I just spotted:

#ifndef arch_perf_out_copy_user
#define arch_perf_out_copy_user __copy_from_user_inatomic
#endif

vs:

arch/x86/include/asm/perf_event.h:#define arch_perf_out_copy_user copy_from_user_nmi


Now the problem is that copy_from_user_nmi() and
__copy_from_user_inatomic() have different return semantics.

Furthermore, the macro you use them in DEFINE_OUTPUT_COPY() assumes the
return value is the amount of memory copied; as also illustrated by
memcpy_common().

Trouble is, __copy_from_user_inatomic() returns the number of bytes
_NOT_ copied.

With this, my question to Will is, how did your ARM unwind support
patches ever work? AFAICT they end up using the
__copy_from_user_inatomic() thing.


---
 kernel/events/internal.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index ca6599723be5..d7a0f753e695 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -110,7 +110,8 @@ func_name(struct perf_output_handle *handle,				\
 	return len;							\
 }
 
-static inline int memcpy_common(void *dst, const void *src, size_t n)
+static inline unsigned long
+memcpy_common(void *dst, const void *src, unsigned long n)
 {
 	memcpy(dst, src, n);
 	return n;
@@ -123,7 +124,19 @@ DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
 DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
 
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
+	ret = __copy_from_user_inatomic(to, from, n);
+	pagefault_enable();
+
+	return n - ret;
+}
 #endif
 
 DEFINE_OUTPUT_COPY(__output_copy_user, arch_perf_out_copy_user)
