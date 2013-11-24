Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3KXVTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 16:19:25 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:58833 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3KXVTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 16:19:23 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Nov 2013 16:19:22 EST
From: Cesar Eduardo Barros <cesarb@cesarb.eti.br>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        James Yonan <james@openvpn.net>, Daniel Borkmann <dborkman@redhat.com>,
        Florian Weimer <fw@deneb.enyo.de>, linux-kernel@vger.kernel.org,
        Cesar Eduardo Barros <cesarb@cesarb.eti.br>
Subject: [PATCH] crypto: more robust crypto_memneq
Date: Sun, 24 Nov 2013 19:12:15 -0200
Message-Id: <1385327535-27991-1-git-send-email-cesarb@cesarb.eti.br>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 crypto/Makefile |  5 ----
 crypto/memneq.c | 82 +++++++++++++++++++++++++++++++++++++++------------------
 2 files changed, 57 insertions(+), 30 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 989c510..b29402a 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -2,11 +2,6 @@
 # Cryptographic API
 #
 
-# memneq MUST be built with -Os or -O0 to prevent early-return optimizations
-# that will defeat memneq's actual purpose to prevent timing attacks.
-CFLAGS_REMOVE_memneq.o := -O1 -O2 -O3
-CFLAGS_memneq.o := -Os
-
 obj-$(CONFIG_CRYPTO) += crypto.o
 crypto-y := api.o cipher.o compress.o memneq.o
 
diff --git a/crypto/memneq.c b/crypto/memneq.c
index cd01622..fce066c 100644
--- a/crypto/memneq.c
+++ b/crypto/memneq.c
@@ -63,6 +63,9 @@
 
 #ifndef __HAVE_ARCH_CRYPTO_MEMNEQ
 
+/* Make the optimizer believe the variable can be manipulated arbitrarily. */
+#define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=r" (var) : "0" (var))
+
 /* Generic path for arbitrary size */
 static inline unsigned long
 __crypto_memneq_generic(const void *a, const void *b, size_t size)
@@ -72,6 +75,7 @@ __crypto_memneq_generic(const void *a, const void *b, size_t size)
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 	while (size >= sizeof(unsigned long)) {
 		neq |= *(unsigned long *)a ^ *(unsigned long *)b;
+		OPTIMIZER_HIDE_VAR(neq);
 		a += sizeof(unsigned long);
 		b += sizeof(unsigned long);
 		size -= sizeof(unsigned long);
@@ -79,6 +83,7 @@ __crypto_memneq_generic(const void *a, const void *b, size_t size)
 #endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
 	while (size > 0) {
 		neq |= *(unsigned char *)a ^ *(unsigned char *)b;
+		OPTIMIZER_HIDE_VAR(neq);
 		a += 1;
 		b += 1;
 		size -= 1;
@@ -89,33 +94,60 @@ __crypto_memneq_generic(const void *a, const void *b, size_t size)
 /* Loop-free fast-path for frequently used 16-byte size */
 static inline unsigned long __crypto_memneq_16(const void *a, const void *b)
 {
+	unsigned long neq = 0;
+
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
-	if (sizeof(unsigned long) == 8)
-		return ((*(unsigned long *)(a)   ^ *(unsigned long *)(b))
-		      | (*(unsigned long *)(a+8) ^ *(unsigned long *)(b+8)));
-	else if (sizeof(unsigned int) == 4)
-		return ((*(unsigned int *)(a)    ^ *(unsigned int *)(b))
-                      | (*(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4))
-		      | (*(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8))
-	              | (*(unsigned int *)(a+12) ^ *(unsigned int *)(b+12)));
-	else
+	if (sizeof(unsigned long) == 8) {
+		neq |= *(unsigned long *)(a)   ^ *(unsigned long *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned long *)(a+8) ^ *(unsigned long *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+	} else if (sizeof(unsigned int) == 4) {
+		neq |= *(unsigned int *)(a)    ^ *(unsigned int *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned int *)(a+4)  ^ *(unsigned int *)(b+4);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned int *)(a+8)  ^ *(unsigned int *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+	        neq |= *(unsigned int *)(a+12) ^ *(unsigned int *)(b+12);
+		OPTIMIZER_HIDE_VAR(neq);
+	} else {
 #endif /* CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS */
-		return ((*(unsigned char *)(a)    ^ *(unsigned char *)(b))
-		      | (*(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1))
-		      | (*(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2))
-		      | (*(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3))
-		      | (*(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4))
-		      | (*(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5))
-		      | (*(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6))
-		      | (*(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7))
-		      | (*(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8))
-		      | (*(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9))
-		      | (*(unsigned char *)(a+10) ^ *(unsigned char *)(b+10))
-		      | (*(unsigned char *)(a+11) ^ *(unsigned char *)(b+11))
-		      | (*(unsigned char *)(a+12) ^ *(unsigned char *)(b+12))
-		      | (*(unsigned char *)(a+13) ^ *(unsigned char *)(b+13))
-		      | (*(unsigned char *)(a+14) ^ *(unsigned char *)(b+14))
-		      | (*(unsigned char *)(a+15) ^ *(unsigned char *)(b+15)));
+		neq |= *(unsigned char *)(a)    ^ *(unsigned char *)(b);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+1)  ^ *(unsigned char *)(b+1);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+2)  ^ *(unsigned char *)(b+2);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+3)  ^ *(unsigned char *)(b+3);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+4)  ^ *(unsigned char *)(b+4);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+5)  ^ *(unsigned char *)(b+5);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+6)  ^ *(unsigned char *)(b+6);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+7)  ^ *(unsigned char *)(b+7);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+8)  ^ *(unsigned char *)(b+8);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+9)  ^ *(unsigned char *)(b+9);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+10) ^ *(unsigned char *)(b+10);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+11) ^ *(unsigned char *)(b+11);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+12) ^ *(unsigned char *)(b+12);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+13) ^ *(unsigned char *)(b+13);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+14) ^ *(unsigned char *)(b+14);
+		OPTIMIZER_HIDE_VAR(neq);
+		neq |= *(unsigned char *)(a+15) ^ *(unsigned char *)(b+15);
+		OPTIMIZER_HIDE_VAR(neq);
+	}
+
+	return neq;
 }
 
 /* Compare two areas of memory without leaking timing information,
-- 
1.8.3.1

