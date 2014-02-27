Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaB0BCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 20:02:32 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56253 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbaB0BC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 20:02:28 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Stefani Seibold <stefani@seibold.net>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/2] x86: Mark __vdso entries as asmlinkage
Date: Wed, 26 Feb 2014 17:02:13 -0800
Message-Id: <ecbd286ccd2ac038740a07cc04f5d98e96af669f.1393462777.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <cover.1393462777.git.luto@amacapital.net>
References: <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
 <cover.1393462777.git.luto@amacapital.net>
In-Reply-To: <cover.1393462777.git.luto@amacapital.net>
References: <cover.1393462777.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes no difference for 64-bit, bit it's critical for 32-bit code:
these functions are called from outside the kernel, so they need to comply
with the ABI.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/vdso/vclock_gettime.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 828888e..260a422 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -25,9 +25,9 @@
 
 #define gtod (&VVAR(vsyscall_gtod_data))
 
-extern int __vdso_clock_gettime(clockid_t clock, struct timespec *ts);
-extern int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz);
-extern time_t __vdso_time(time_t *t);
+extern asmlinkage int __vdso_clock_gettime(clockid_t clock, struct timespec *ts);
+extern asmlinkage int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz);
+extern asmlinkage time_t __vdso_time(time_t *t);
 
 #ifdef CONFIG_HPET_TIMER
 static inline u32 read_hpet_counter(const volatile void *addr)
@@ -304,7 +304,7 @@ notrace static void do_monotonic_coarse(struct timespec *ts)
 	} while (unlikely(gtod_read_retry(gtod, seq)));
 }
 
-notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
+notrace asmlinkage int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	switch (clock) {
 	case CLOCK_REALTIME:
@@ -332,7 +332,7 @@ fallback:
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
-notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
+notrace asmlinkage int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	if (likely(tv != NULL)) {
 		if (unlikely(do_realtime((struct timespec *)tv) == VCLOCK_NONE))
@@ -353,7 +353,7 @@ int gettimeofday(struct timeval *, struct timezone *)
  * This will break when the xtime seconds get inaccurate, but that is
  * unlikely
  */
-notrace time_t __vdso_time(time_t *t)
+notrace asmlinkage time_t __vdso_time(time_t *t)
 {
 	/* This is atomic on x86 so we don't need any locks. */
 	time_t result = ACCESS_ONCE(gtod->wall_time_sec);
-- 
1.8.5.3

