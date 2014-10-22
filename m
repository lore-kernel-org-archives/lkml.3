Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaJVTer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:34:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbaJVTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:34:44 -0400
Date: Wed, 22 Oct 2014 12:34:20 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-b47dcbdc5161d3d5756f430191e2840d9b855492@git.kernel.org>
Cc: luto@amacapital.net, linux-kernel@vger.kernel.org, bsd@redhat.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com
Reply-To: mingo@kernel.org, bsd@redhat.com, linux-kernel@vger.kernel.org,
        hpa@zytor.com, tglx@linutronix.de, luto@amacapital.net
In-Reply-To: <e2fa274e498c33988efac0ba8b7e3120f7f92d78.1413393027.git.luto@amacapital.net>
References: <e2fa274e498c33988efac0ba8b7e3120f7f92d78.1413393027.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, apic: Handle a bad TSC more gracefully
Git-Commit-ID: b47dcbdc5161d3d5756f430191e2840d9b855492
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b47dcbdc5161d3d5756f430191e2840d9b855492
Gitweb:     http://git.kernel.org/tip/b47dcbdc5161d3d5756f430191e2840d9b855492
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 15 Oct 2014 10:12:07 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 22 Oct 2014 21:31:46 +0200

x86, apic: Handle a bad TSC more gracefully

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/e2fa274e498c33988efac0ba8b7e3120f7f92d78.1413393027.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c | 4 ++--
 arch/x86/kernel/tsc.c       | 5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 6776027..24b5894 100644
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
index b6025f9..b7e50bb 100644
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
 
