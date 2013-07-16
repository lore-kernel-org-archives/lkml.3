Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab3GPRGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:06:34 -0400
Received: from mail-qe0-f50.google.com ([209.85.128.50]:40774 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446Ab3GPRFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:05:21 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [PATCH 3/7] alpha: Modernize lib/mpi/longlong.h
Date: Tue, 16 Jul 2013 10:04:36 -0700
Message-Id: <1373994280-12047-4-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373994280-12047-1-git-send-email-rth@twiddle.net>
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the compile warning for __udiv_qrnnd not having a prototype.
Use the __builtin_alpha_umulh introduced in gcc 4.0.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 lib/mpi/longlong.h | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index d411355..aac5114 100644
--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -151,15 +151,12 @@ do { \
 #endif /* __a29k__ */
 
 #if defined(__alpha) && W_TYPE_SIZE == 64
-#define umul_ppmm(ph, pl, m0, m1) \
-do { \
-		UDItype __m0 = (m0), __m1 = (m1); \
-		__asm__ ("umulh %r1,%2,%0" \
-		: "=r" ((UDItype) ph) \
-		: "%rJ" (__m0), \
-			"rI" (__m1)); \
-		(pl) = __m0 * __m1; \
-	} while (0)
+#define umul_ppmm(ph, pl, m0, m1)			\
+do {							\
+	UDItype __m0 = (m0), __m1 = (m1);		\
+	(ph) = __builtin_alpha_umulh(__m0, __m1);	\
+	(pl) = __m0 * __m1;                             \
+} while (0)
 #define UMUL_TIME 46
 #ifndef LONGLONG_STANDALONE
 #define udiv_qrnnd(q, r, n1, n0, d) \
@@ -167,7 +164,7 @@ do { UDItype __r; \
 	(q) = __udiv_qrnnd(&__r, (n1), (n0), (d)); \
 	(r) = __r; \
 } while (0)
-extern UDItype __udiv_qrnnd();
+extern UDItype __udiv_qrnnd(UDItype *, UDItype, UDItype, UDItype);
 #define UDIV_TIME 220
 #endif /* LONGLONG_STANDALONE */
 #endif /* __alpha */
-- 
1.8.1.4

