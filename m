Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933518Ab3GPRF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:05:28 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:60433 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933482Ab3GPRFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:05:25 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [PATCH 5/7] alpha: Implement atomic64_dec_if_positive
Date: Tue, 16 Jul 2013 10:04:38 -0700
Message-Id: <1373994280-12047-6-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373994280-12047-1-git-send-email-rth@twiddle.net>
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/Kconfig              |  1 +
 arch/alpha/include/asm/atomic.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 837a1f2..082d9b4 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -15,6 +15,7 @@ config ALPHA
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_STRNCPY_FROM_USER
diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index 0dc18fc..78b03ef 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -238,6 +238,34 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 	return !c;
 }
 
+/*
+ * atomic64_dec_if_positive - decrement by 1 if old value positive
+ * @v: pointer of type atomic_t
+ *
+ * The function returns the old value of *v minus 1, even if
+ * the atomic variable, v, was not decremented.
+ */
+static inline long atomic64_dec_if_positive(atomic64_t *v)
+{
+	long old, tmp;
+	smp_mb();
+	__asm__ __volatile__(
+	"1:	ldq_l	%[old],%[mem]\n"
+	"	subq	%[old],1,%[tmp]\n"
+	"	ble	%[old],2f\n"
+	"	stq_c	%[tmp],%[mem]\n"
+	"	beq	%[tmp],3f\n"
+	"2:\n"
+	".subsection 2\n"
+	"3:	br	1b\n"
+	".previous"
+	: [old] "=&r"(old), [tmp] "=&r"(tmp)
+	: [mem] "m"(*v)
+	: "memory");
+	smp_mb();
+	return old - 1;
+}
+
 #define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
 
 #define atomic_add_negative(a, v) (atomic_add_return((a), (v)) < 0)
-- 
1.8.1.4

