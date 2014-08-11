Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbaHKWv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:51:26 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:52200 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbaHKWvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:51:23 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Christopher Li <sparse@chrisli.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Cesar Eduardo Barros <cesarb@cesarb.eti.br>,
        Daniel Borkmann <dborkman@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org (open list),
        linux-sparse@vger.kernel.org (open list:SPARSE CHECKER)
Subject: [PATCH] compiler.h: Move __memory_barrier() use to compiler-intel.h
Date: Mon, 11 Aug 2014 18:51:42 -0400
Message-Id: <1407797503-24727-4-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
References: <1407797503-24727-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 73679e5082012 ("compiler-intel.h: Remove duplicate definition") removed a
duplicate definition of barrier() from compiler-intel.h. This is the wrong
duplicate definition removed since __memory_barrier() is an intel compiler
specific intrinsic and should live in compiler-intel.h.

This commit reverts the previous commit and removes the definition from
compiler.h

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/compiler-intel.h | 3 +++
 include/linux/compiler.h       | 5 -----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index ba147a1..5529c52 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -13,9 +13,12 @@
 /* Intel ECC compiler doesn't support gcc specific asm stmts.
  * It uses intrinsics to do the equivalent things.
  */
+#undef barrier
 #undef RELOC_HIDE
 #undef OPTIMIZER_HIDE_VAR
 
+#define barrier() __memory_barrier()
+
 #define RELOC_HIDE(ptr, off)					\
   ({ unsigned long __ptr;					\
      __ptr = (unsigned long) (ptr);				\
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d5ad7b1..bc24cad 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -160,11 +160,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define unlikely(x)	__builtin_expect(!!(x), 0)
 #endif
 
-/* Optimization barrier */
-#ifndef barrier
-# define barrier() __memory_barrier()
-#endif
-
 /* Unreachable code */
 #ifndef unreachable
 # define unreachable() do { } while (1)
-- 
1.9.1

