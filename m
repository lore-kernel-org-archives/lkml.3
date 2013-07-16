Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab3GPRFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:05:30 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:63822 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099Ab3GPRFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:05:23 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [PATCH 4/7] alpha: Improve atomic_add_unless
Date: Tue, 16 Jul 2013 10:04:37 -0700
Message-Id: <1373994280-12047-5-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373994280-12047-1-git-send-email-rth@twiddle.net>
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ll/sc loops instead of C loops around cmpxchg.
Update the atomic64_add_unless block comment to match the code.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/atomic.h | 60 +++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index c2cbe4f..0dc18fc 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -186,17 +186,24 @@ static __inline__ long atomic64_sub_return(long i, atomic64_t * v)
  */
 static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
 {
-	int c, old;
-	c = atomic_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = atomic_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c;
+	int c, new, old;
+	smp_mb();
+	__asm__ __volatile__(
+	"1:	ldl_l	%[old],%[mem]\n"
+	"	cmpeq	%[old],%[u],%[c]\n"
+	"	addl	%[old],%[a],%[new]\n"
+	"	bne	%[c],2f\n"
+	"	stl_c	%[new],%[mem]\n"
+	"	beq	%[new],3f\n"
+	"2:\n"
+	".subsection 2\n"
+	"3:	br	1b\n"
+	".previous"
+	: [old] "=&r"(old), [new] "=&r"(new), [c] "=&r"(c)
+	: [mem] "m"(*v), [a] "rI"(a), [u] "rI"((long)u)
+	: "memory");
+	smp_mb();
+	return old;
 }
 
 
@@ -207,21 +214,28 @@ static __inline__ int __atomic_add_unless(atomic_t *v, int a, int u)
  * @u: ...unless v is equal to u.
  *
  * Atomically adds @a to @v, so long as it was not @u.
- * Returns the old value of @v.
+ * Returns true iff @v was not @u.
  */
 static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 {
-	long c, old;
-	c = atomic64_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = atomic64_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c != (u);
+	long c, tmp;
+	smp_mb();
+	__asm__ __volatile__(
+	"1:	ldq_l	%[tmp],%[mem]\n"
+	"	cmpeq	%[tmp],%[u],%[c]\n"
+	"	addq	%[tmp],%[a],%[tmp]\n"
+	"	bne	%[c],2f\n"
+	"	stq_c	%[tmp],%[mem]\n"
+	"	beq	%[tmp],3f\n"
+	"2:\n"
+	".subsection 2\n"
+	"3:	br	1b\n"
+	".previous"
+	: [tmp] "=&r"(tmp), [c] "=&r"(c)
+	: [mem] "m"(*v), [a] "rI"(a), [u] "rI"(u)
+	: "memory");
+	smp_mb();
+	return !c;
 }
 
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
-- 
1.8.1.4

