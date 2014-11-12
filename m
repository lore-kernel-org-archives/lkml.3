Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934988AbaKLBrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:47:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934921AbaKLBra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:47:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>, Bandan Das <bsd@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.14 183/203] x86, apic: Handle a bad TSC more gracefully
Date: Wed, 12 Nov 2014 10:17:33 +0900
Message-Id: <20141112011551.080233872@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/apic.c |    4 ++--
 arch/x86/kernel/tsc.c       |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1290,7 +1290,7 @@ void setup_local_APIC(void)
 	unsigned int value, queued;
 	int i, j, acked = 0;
 	unsigned long long tsc = 0, ntsc;
-	long long max_loops = cpu_khz;
+	long long max_loops = cpu_khz ? cpu_khz : 1000000;
 
 	if (cpu_has_tsc)
 		rdtscll(tsc);
@@ -1387,7 +1387,7 @@ void setup_local_APIC(void)
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
@@ -1173,14 +1173,17 @@ void __init tsc_init(void)
 
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
 


