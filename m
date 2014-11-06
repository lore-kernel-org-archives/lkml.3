Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaKFWtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:49:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59122 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaKFWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cesar Eduardo Barros <cesarb@cesarb.eti.br>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 077/162] compiler: define OPTIMIZER_HIDE_VAR() macro
Date: Thu,  6 Nov 2014 14:35:41 -0800
Message-Id: <1415313426-9622-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cesar Eduardo Barros <cesarb@cesarb.eti.br>

[ 3.13-stable only: OPTIMIZER_HIDE_VAR() macro
  extracted from fe8c8a1 "crypto: more robust crypto_memneq" ]

[...] dummy inline assembly
(based on RELOC_HIDE) to block the problematic kinds of optimization,
while still allowing other optimizations to be applied to the code.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
[ kamal: 3.13-stable prereq for
  d4c5efd "random: add and use memzero_explicit() for clearing data" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/compiler-gcc.h   | 3 +++
 include/linux/compiler-intel.h | 7 +++++++
 include/linux/compiler.h       | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 24545cd..02ae99e 100644
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
index dc1bd3d..5529c52 100644
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
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 92669cd..a2329c5 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -170,6 +170,10 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#ifndef OPTIMIZER_HIDE_VAR
+#define OPTIMIZER_HIDE_VAR(var) barrier()
+#endif
+
 /* Not-quite-unique ID. */
 #ifndef __UNIQUE_ID
 # define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __LINE__)
-- 
1.9.1

