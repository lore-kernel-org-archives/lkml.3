Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622AbbA1EsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:48:16 -0500
Received: from mail.kernel.org ([198.145.29.136]:40115 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934326AbbA1EWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:22:52 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Bandan Das <bsd@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 099/177] x86, apic: Handle a bad TSC more gracefully
Date: Wed, 28 Jan 2015 12:09:17 +0800
Message-Id: <1422418236-12852-190-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/kernel/apic/apic.c | 4 ++--
 arch/x86/kernel/tsc.c       | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index edc2448..cb5b54e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1229,7 +1229,7 @@ void __cpuinit setup_local_APIC(void)
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
-	long long max_loops = cpu_khz;
+	long long max_loops = cpu_khz ? cpu_khz : 1000000;
 
 	if (cpu_has_tsc)
 		rdtscll(tsc);
@@ -1325,7 +1325,7 @@ void __cpuinit setup_local_APIC(void)
 			       acked);
 			break;
 		}
-		if (cpu_has_tsc) {
+		if (cpu_has_tsc && cpu_khz) {
 			rdtscll(ntsc);
 			max_loops = (cpu_khz << 10) - (ntsc - tsc);
 		} else
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index fc0a147..8652aa4 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -959,14 +959,17 @@ void __init tsc_init(void)
 
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

