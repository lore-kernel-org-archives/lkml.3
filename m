Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbaLLGsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:48:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbaLLGsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:48:12 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.444050551@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 064/164] compiler: Define OPTIMIZER_HIDE_VAR
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

Part of upstream commit fe8c8a126806 ('crypto: more robust
crypto_memneq'), needed by commit d4c5efdb9777 ('random: add and use
memzero_explicit() for clearing data').

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
 
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -164,6 +164,10 @@ void ftrace_likely_update(struct ftrace_
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#ifndef OPTIMIZER_HIDE_VAR
+#define OPTIMIZER_HIDE_VAR(var) barrier()
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */

