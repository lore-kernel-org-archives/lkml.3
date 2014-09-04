Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaIDM6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 08:58:21 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62737 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaIDM6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 08:58:19 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: chris.j.arges@canonical.com, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
Date: Thu,  4 Sep 2014 14:58:07 +0200
Message-Id: <1409835487-14371-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cbcf2dd3b3d4 (x86: kvm: Make kvm_get_time_and_clockread() nanoseconds
based, 2014-07-16) forgot to add tk->xtime_sec, thus breaking kvmclock on
hosts that have a reliable TSC.  Add it back; and since the field boot_ns
is not anymore related to the host boot-based clock, rename boot_ns->nsec_base
and the existing nsec_base->snsec_base.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Reported-by: Chris J Arges <chris.j.arges@canonical.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f1e22d3b286..92493e10937c 100644
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
2.1.0

