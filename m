Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaCBJWF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 04:22:05 -0500
Received: from www84.your-server.de ([213.133.104.84]:48023 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaCBJUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 04:20:52 -0500
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v21 03/12] revamp vclock_gettime.c
Date: Sun,  2 Mar 2014 10:20:11 +0100
Message-Id: <1393752020-6740-4-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393752020-6740-1-git-send-email-stefani@seibold.net>
References: <1393752020-6740-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This intermediate patch revamps the vclock_gettime.c by moving some functions
around. It is only for spliting purpose, to make whole the 32 bit vdso timer
patch easier to review.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 arch/x86/vdso/vclock_gettime.c | 85 +++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 43 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index eb5d7a5..bbc8065 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -26,41 +26,26 @@
 
 #define gtod (&VVAR(vsyscall_gtod_data))
 
-notrace static cycle_t vread_tsc(void)
+static notrace cycle_t vread_hpet(void)
 {
-	cycle_t ret;
-	u64 last;
-
-	/*
-	 * Empirically, a fence (of type that depends on the CPU)
-	 * before rdtsc is enough to ensure that rdtsc is ordered
-	 * with respect to loads.  The various CPU manuals are unclear
-	 * as to whether rdtsc can be reordered with later loads,
-	 * but no one has ever seen it happen.
-	 */
-	rdtsc_barrier();
-	ret = (cycle_t)vget_cycles();
-
-	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
-
-	if (likely(ret >= last))
-		return ret;
+	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
+}
 
-	/*
-	 * GCC likes to generate cmov here, but this branch is extremely
-	 * predictable (it's just a funciton of time and the likely is
-	 * very likely) and there's a data dependence, so force GCC
-	 * to generate a branch instead.  I don't barrier() because
-	 * we don't actually need a barrier, and if this function
-	 * ever gets inlined it will generate worse code.
-	 */
-	asm volatile ("");
-	return last;
+notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+{
+	long ret;
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
+	return ret;
 }
 
-static notrace cycle_t vread_hpet(void)
+notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
 {
-	return readl((const void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
+	long ret;
+
+	asm("syscall" : "=a" (ret) :
+	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	return ret;
 }
 
 #ifdef CONFIG_PARAVIRT_CLOCK
@@ -133,23 +118,37 @@ static notrace cycle_t vread_pvclock(int *mode)
 }
 #endif
 
-notrace static long vdso_fallback_gettime(long clock, struct timespec *ts)
+notrace static cycle_t vread_tsc(void)
 {
-	long ret;
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_clock_gettime),"D" (clock), "S" (ts) : "memory");
-	return ret;
-}
+	cycle_t ret;
+	u64 last;
 
-notrace static long vdso_fallback_gtod(struct timeval *tv, struct timezone *tz)
-{
-	long ret;
+	/*
+	 * Empirically, a fence (of type that depends on the CPU)
+	 * before rdtsc is enough to ensure that rdtsc is ordered
+	 * with respect to loads.  The various CPU manuals are unclear
+	 * as to whether rdtsc can be reordered with later loads,
+	 * but no one has ever seen it happen.
+	 */
+	rdtsc_barrier();
+	ret = (cycle_t)vget_cycles();
 
-	asm("syscall" : "=a" (ret) :
-	    "0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
-	return ret;
-}
+	last = VVAR(vsyscall_gtod_data).clock.cycle_last;
 
+	if (likely(ret >= last))
+		return ret;
+
+	/*
+	 * GCC likes to generate cmov here, but this branch is extremely
+	 * predictable (it's just a funciton of time and the likely is
+	 * very likely) and there's a data dependence, so force GCC
+	 * to generate a branch instead.  I don't barrier() because
+	 * we don't actually need a barrier, and if this function
+	 * ever gets inlined it will generate worse code.
+	 */
+	asm volatile ("");
+	return last;
+}
 
 notrace static inline u64 vgetsns(int *mode)
 {
-- 
1.9.0

