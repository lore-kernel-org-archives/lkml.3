Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815AbaJORMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:12:17 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32839 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaJORMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:12:16 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Bandan Das <bsd@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        stable@vger.kernel.org
Subject: [PATCH] x86, apic: Handle a bad TSC more gracefully
Date: Wed, 15 Oct 2014 10:12:07 -0700
Message-Id: <e2fa274e498c33988efac0ba8b7e3120f7f92d78.1413393027.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the TSC is unusable or disabled, then this patch fixes:

 - Confusion while trying to clear old APIC interrupts.
 - Division by zero and incorrect programming of the TSC deadline
   timer.

This fixes boot if the CPU has a TSC deadline timer but a missing or
broken TSC.  The failure to boot can be observed with qemu using
-cpu qemu64,-tsc,+tsc-deadline

This also happens to me in nested KVM for unknown reasons.
With this patch, I can boot cleanly (although without a TSC).

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/kernel/apic/apic.c | 4 ++--
 arch/x86/kernel/tsc.c       | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 67760275544b..24b5894396a0 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1297,7 +1297,7 @@ void setup_local_APIC(void)
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
-	long long max_loops = cpu_khz;
+	long long max_loops = cpu_khz ? cpu_khz : 1000000;
 
 	if (cpu_has_tsc)
 		rdtscll(tsc);
@@ -1383,7 +1383,7 @@ void setup_local_APIC(void)
 			break;
 		}
 		if (queued) {
-			if (cpu_has_tsc) {
+			if (cpu_has_tsc && cpu_khz) {
 				rdtscll(ntsc);
 				max_loops = (cpu_khz << 10) - (ntsc - tsc);
 			} else
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index b6025f9e36c6..b7e50bba3bbb 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1166,14 +1166,17 @@ void __init tsc_init(void)
 
 	x86_init.timers.tsc_pre_init();
 
-	if (!cpu_has_tsc)
+	if (!cpu_has_tsc) {
+		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 		return;
+	}
 
 	tsc_khz = x86_platform.calibrate_tsc();
 	cpu_khz = tsc_khz;
 
 	if (!tsc_khz) {
 		mark_tsc_unstable("could not calculate TSC khz");
+		setup_clear_cpu_cap(X86_FEATURE_TSC_DEADLINE_TIMER);
 		return;
 	}
 
-- 
1.9.3

