Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbaLLG1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:27:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52045 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759376AbaLLGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bandan Das" <bsd@redhat.com>,
        "Andy Lutomirski" <luto@amacapital.net>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.595073774@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 074/164] x86, apic: Handle a bad TSC more gracefully
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit b47dcbdc5161d3d5756f430191e2840d9b855492 upstream.

If the TSC is unusable or disabled, then this patch fixes:

 - Confusion while trying to clear old APIC interrupts.
 - Division by zero and incorrect programming of the TSC deadline
   timer.

This fixes boot if the CPU has a TSC deadline timer but a missing or
broken TSC.  The failure to boot can be observed with qemu using
-cpu qemu64,-tsc,+tsc-deadline

This also happens to me in nested KVM for unknown reasons.
With this patch, I can boot cleanly (although without a TSC).

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Bandan Das <bsd@redhat.com>
Link: http://lkml.kernel.org/r/e2fa274e498c33988efac0ba8b7e3120f7f92d78.1413393027.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/apic/apic.c | 4 ++--
 arch/x86/kernel/tsc.c       | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1213,7 +1213,7 @@ void __cpuinit setup_local_APIC(void)
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
-	long long max_loops = cpu_khz;
+	long long max_loops = cpu_khz ? cpu_khz : 1000000;
 
 	if (cpu_has_tsc)
 		rdtscll(tsc);
@@ -1310,7 +1310,7 @@ void __cpuinit setup_local_APIC(void)
 			break;
 		}
 		if (queued) {
-			if (cpu_has_tsc) {
+			if (cpu_has_tsc && cpu_khz) {
 				rdtscll(ntsc);
 				max_loops = (cpu_khz << 10) - (ntsc - tsc);
 			} else
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -961,14 +961,17 @@ void __init tsc_init(void)
 
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
 

