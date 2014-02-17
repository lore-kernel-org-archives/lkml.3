Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaBQAz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 19:55:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51707 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaBQAxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 19:53:13 -0500
Date: Sun, 16 Feb 2014 16:52:52 -0800
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-0b20a1f58d3502a8dfec98a8926f26c43429bee7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stefani@seibold.net, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1392587568-7325-4-git-send-email-stefani@seibold.net>
References: <1392587568-7325-4-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Revamp vclock_gettime.c
Git-Commit-ID: 0b20a1f58d3502a8dfec98a8926f26c43429bee7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 16 Feb 2014 16:52:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b20a1f58d3502a8dfec98a8926f26c43429bee7
Gitweb:     http://git.kernel.org/tip/0b20a1f58d3502a8dfec98a8926f26c43429bee7
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Sun, 16 Feb 2014 22:52:41 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 16 Feb 2014 15:06:39 -0800

x86, vdso: Revamp vclock_gettime.c

This intermediate patch revamps the vclock_gettime.c by moving some
functions around.  This is only code movement, to make the whole
32-bit vdso timer patchset easier to review.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/1392587568-7325-4-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
