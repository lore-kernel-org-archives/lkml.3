Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbaKFXUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:20:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58533 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaKFWiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:38:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Lutomirski <luto@amacapital.net>, Bandan Das <bsd@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 122/162] x86, apic: Handle a bad TSC more gracefully
Date: Thu,  6 Nov 2014 14:36:26 -0800
Message-Id: <1415313426-9622-123-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/apic/apic.c | 4 ++--
 arch/x86/kernel/tsc.c       | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d278736..f9e7786 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1283,7 +1283,7 @@ void setup_local_APIC(void)
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
-	long long max_loops = cpu_khz;
+	long long max_loops = cpu_khz ? cpu_khz : 1000000;
 
 	if (cpu_has_tsc)
 		rdtscll(tsc);
@@ -1380,7 +1380,7 @@ void setup_local_APIC(void)
 			break;
 		}
 		if (queued) {
-			if (cpu_has_tsc) {
+			if (cpu_has_tsc && cpu_khz) {
 				rdtscll(ntsc);
 				max_loops = (cpu_khz << 10) - (ntsc - tsc);
 			} else
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 66af9af..dffebdd 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -974,14 +974,17 @@ void __init tsc_init(void)
 
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
1.9.1

