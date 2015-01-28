Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953AbbA1ET4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:19:56 -0500
Received: from mail.kernel.org ([198.145.29.136]:38976 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933922AbbA1ETu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:19:50 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.eti.br>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 066/177] crypto: more robust crypto_memneq
Date: Wed, 28 Jan 2015 12:08:18 +0800
Message-Id: <1422418236-12852-131-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cesar Eduardo Barros <cesarb@cesarb.eti.br>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit fe8c8a126806fea4465c43d62a1f9d273a572bf5 upstream.

[Only use the compiler.h portion of this patch, to get the
OPTIMIZER_HIDE_VAR() macro, which we need for other -stable patches
- gregkh]

Disabling compiler optimizations can be fragile, since a new
optimization could be added to -O0 or -Os that breaks the assumptions
the code is making.

Instead of disabling compiler optimizations, use a dummy inline assembly
(based on RELOC_HIDE) to block the problematic kinds of optimization,
while still allowing other optimizations to be applied to the code.

The dummy inline assembly is added after every OR, and has the
accumulator variable as its input and output. The compiler is forced to
assume that the dummy inline assembly could both depend on the
accumulator variable and change the accumulator variable, so it is
forced to compute the value correctly before the inline assembly, and
cannot assume anything about its value after the inline assembly.

This change should be enough to make crypto_memneq work correctly (with
data-independent timing) even if it is inlined at its call sites. That
can be done later in a followup patch.

Compile-tested on x86_64.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/compiler-gcc.h   | 3 +++
 include/linux/compiler-intel.h | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 7970e31..ea9cffe 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -37,6 +37,9 @@
     __asm__ ("" : "=r"(__ptr) : "0"(ptr));		\
     (typeof(ptr)) (__ptr + (off)); })
 
+/* Make the optimizer believe the variable can be manipulated arbitrarily. */
+#define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=r" (var) : "0" (var))
+
 #ifdef __CHECKER__
 #define __must_be_array(arr) 0
 #else
diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index cba9593..1a97cac 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -15,6 +15,7 @@
  */
 #undef barrier
 #undef RELOC_HIDE
+#undef OPTIMIZER_HIDE_VAR
 
 #define barrier() __memory_barrier()
 
@@ -23,6 +24,12 @@
      __ptr = (unsigned long) (ptr);				\
     (typeof(ptr)) (__ptr + (off)); })
 
+/* This should act as an optimization barrier on var.
+ * Given that this compiler does not have inline assembly, a compiler barrier
+ * is the best we can do.
+ */
+#define OPTIMIZER_HIDE_VAR(var) barrier()
+
 /* Intel ECC compiler doesn't support __builtin_types_compatible_p() */
 #define __must_be_array(a) 0
 
-- 
1.9.1

