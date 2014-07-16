Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbaGPVK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:10:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:59831 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbaGPVE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:58 -0400
Message-Id: <20140716205055.929964640@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org
Subject: [patch V2 44/64] x86: kvm: Make kvm_get_time_and_clockread()
 nanoseconds based
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-kvm-use-ktime-based.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the relevant base data right away to nanoseconds instead of
doing the conversion on every readout. Reduces text size by 160 bytes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/x86.c |   44 ++++++++++++++------------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

Index: tip/arch/x86/kvm/x86.c
===================================================================
--- tip.orig/arch/x86/kvm/x86.c
+++ tip/arch/x86/kvm/x86.c
@@ -984,9 +984,8 @@ struct pvclock_gtod_data {
 		u32	shift;
 	} clock;
 
-	/* open coded 'struct timespec' */
-	u64		monotonic_time_snsec;
-	time_t		monotonic_time_sec;
+	u64		boot_ns;
+	u64		nsec_base;
 };
 
 static struct pvclock_gtod_data pvclock_gtod_data;
@@ -994,6 +993,9 @@ static struct pvclock_gtod_data pvclock_
 static void update_pvclock_gtod(struct timekeeper *tk)
 {
 	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
+	u64 boot_ns;
+
+	boot_ns = ktime_to_ns(ktime_add(tk->base_mono, tk->offs_boot));
 
 	write_seqcount_begin(&vdata->seq);
 
@@ -1004,17 +1006,8 @@ static void update_pvclock_gtod(struct t
 	vdata->clock.mult		= tk->mult;
 	vdata->clock.shift		= tk->shift;
 
-	vdata->monotonic_time_sec	= tk->xtime_sec
-					+ tk->wall_to_monotonic.tv_sec;
-	vdata->monotonic_time_snsec	= tk->xtime_nsec
-					+ (tk->wall_to_monotonic.tv_nsec
-						<< tk->shift);
-	while (vdata->monotonic_time_snsec >=
-					(((u64)NSEC_PER_SEC) << tk->shift)) {
-		vdata->monotonic_time_snsec -=
-					((u64)NSEC_PER_SEC) << tk->shift;
-		vdata->monotonic_time_sec++;
-	}
+	vdata->boot_ns			= boot_ns;
+	vdata->nsec_base		= tk->xtime_nsec;
 
 	write_seqcount_end(&vdata->seq);
 }
@@ -1371,23 +1364,22 @@ static inline u64 vgettsc(cycle_t *cycle
 	return v * gtod->clock.mult;
 }
 
-static int do_monotonic(struct timespec *ts, cycle_t *cycle_now)
+static int do_monotonic_boot(s64 *t, cycle_t *cycle_now)
 {
+	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
 	unsigned long seq;
-	u64 ns;
 	int mode;
-	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
+	u64 ns;
 
-	ts->tv_nsec = 0;
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
-		ts->tv_sec = gtod->monotonic_time_sec;
-		ns = gtod->monotonic_time_snsec;
+		ns = gtod->nsec_base;
 		ns += vgettsc(cycle_now);
 		ns >>= gtod->clock.shift;
+		ns += gtod->boot_ns;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
-	timespec_add_ns(ts, ns);
+	*t = ns;
 
 	return mode;
 }
@@ -1395,19 +1387,11 @@ static int do_monotonic(struct timespec
 /* returns true if host is using tsc clocksource */
 static bool kvm_get_time_and_clockread(s64 *kernel_ns, cycle_t *cycle_now)
 {
-	struct timespec ts;
-
 	/* checked again under seqlock below */
 	if (pvclock_gtod_data.clock.vclock_mode != VCLOCK_TSC)
 		return false;
 
-	if (do_monotonic(&ts, cycle_now) != VCLOCK_TSC)
-		return false;
-
-	monotonic_to_bootbased(&ts);
-	*kernel_ns = timespec_to_ns(&ts);
-
-	return true;
+	return do_monotonic_boot(kernel_ns, cycle_now) == VCLOCK_TSC;
 }
 #endif
 


