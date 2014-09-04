Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaIDVF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 17:05:58 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:40003 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaIDVF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 17:05:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: chris.j.arges@canonical.com, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
Date: Thu,  4 Sep 2014 23:05:44 +0200
Message-Id: <1409864744-26417-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cbcf2dd3b3d4 (x86: kvm: Make kvm_get_time_and_clockread() nanoseconds
based, 2014-07-16) used the wrong formula for boot_ns, thus breaking kvmclock on
hosts that have a reliable TSC.

To find the right formula, let's first backport the switch to nanoseconds
to 3.16-era timekeeping logic.  The full patch (which works) is at
https://lkml.org/lkml/2014/9/4/462.  The key line here is

        boot_ns = timespec_to_ns(&tk->total_sleep_time)
                + timespec_to_ns(&tk->wall_to_monotonic)
                + tk->xtime_sec * (u64)NSEC_PER_SEC;

Because the above patch works, the conclusion is that the above formula
is not the same as commit cbcf2dd3b3d4's

        boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));

As to what is the right one, commit 02cba1598a2a (timekeeping: Simplify getboottime(),
2014-07-16) provides a hint:

   offs_real             = -wall-to_monotonic
   offs_boot             =  total_sleep_time

   offs_real - offs_boot = -wall_to_monotonic - total_sleep_time

that is

   offs_boot - offs_real =  wall_to_monotonic + total_sleep_time

which is what this patch uses, adding xtime_sec separately.  The "boot_ns"
moniker is not too clear, so rename boot_ns to nsec_base and the existing
nsec_base to snsec_base.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Reported-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Thomas/John, the problem with the above explanation is that
	tk_update_ktime_data has "base_mono = xtime_sec + wtm", and from
	there "base_mono + offs_boot = xtime_sec + wtm + total_sleep_time".
	Except that doesn't work, so something must be wrong in
	tk_update_ktime_data's comment.

 arch/x86/kvm/x86.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f1e22d3b286..c55203bea337 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1020,8 +1020,8 @@ struct pvclock_gtod_data {
 		u32	shift;
 	} clock;
 
-	u64		boot_ns;
 	u64		nsec_base;
+	u64		snsec_base;
 };
 
 static struct pvclock_gtod_data pvclock_gtod_data;
@@ -1031,7 +1031,7 @@ static void update_pvclock_gtod(struct timekeeper *tk)
 	struct pvclock_gtod_data *vdata = &pvclock_gtod_data;
 	u64 boot_ns;
 
-	boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));
+	boot_ns = ktime_to_ns(ktime_sub(tk->tkr.offs_boot, tk->offs_real));
 
 	write_seqcount_begin(&vdata->seq);
 
@@ -1042,8 +1042,9 @@ static void update_pvclock_gtod(struct timekeeper *tk)
 	vdata->clock.mult		= tk->tkr.mult;
 	vdata->clock.shift		= tk->tkr.shift;
 
-	vdata->boot_ns			= boot_ns;
-	vdata->nsec_base		= tk->tkr.xtime_nsec;
+	vdata->nsec_base		= tk->xtime_sec * (u64)NSEC_PER_SEC
+					+ boot_ns;
+	vdata->snsec_base		= tk->tkr.xtime_nsec;
 
 	write_seqcount_end(&vdata->seq);
 }
@@ -1413,10 +1414,10 @@ static int do_monotonic_boot(s64 *t, cycle_t *cycle_now)
 	do {
 		seq = read_seqcount_begin(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
-		ns = gtod->nsec_base;
+		ns = gtod->snsec_base;
 		ns += vgettsc(cycle_now);
 		ns >>= gtod->clock.shift;
-		ns += gtod->boot_ns;
+		ns += gtod->nsec_base;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	*t = ns;
 
-- 
1.8.3.1

