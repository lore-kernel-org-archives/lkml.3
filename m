Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbaJaKul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:50:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:40017 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbaJaKui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:50:38 -0400
Date: Fri, 31 Oct 2014 11:50:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] timer updates for 3.18
Message-ID: <alpine.DEB.2.11.1410311144420.5308@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

As you requested in the rc2 release mail the timer department serves
you a few real bug fixes:

 - Fix the probe logic of the architected arm/arm64 timer
 - Plug a stack info leak in posix-timers
 - Prevent a shift out of bounds issue in the clockevents core

Thanks,

	tglx

------------------>
Marc Zyngier (1):
      ARM/ARM64: arch-timer: fix arch_timer_probed logic

Mathias Krause (1):
      posix-timers: Fix stack info leak in timer_create()

Thomas Gleixner (1):
      clockevents: Prevent shift out of bounds


 drivers/clocksource/arm_arch_timer.c | 6 +++---
 kernel/time/clockevents.c            | 2 +-
 kernel/time/posix-timers.c           | 1 +
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 2133f9d59d06..43005d4d3348 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -660,11 +660,11 @@ static bool __init
 arch_timer_probed(int type, const struct of_device_id *matches)
 {
 	struct device_node *dn;
-	bool probed = false;
+	bool probed = true;
 
 	dn = of_find_matching_node(NULL, matches);
-	if (dn && of_device_is_available(dn) && (arch_timers_present & type))
-		probed = true;
+	if (dn && of_device_is_available(dn) && !(arch_timers_present & type))
+		probed = false;
 	of_node_put(dn);
 
 	return probed;
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 9c94c19f1305..55449909f114 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -72,7 +72,7 @@ static u64 cev_delta2ns(unsigned long latch, struct clock_event_device *evt,
 	 * Also omit the add if it would overflow the u64 boundary.
 	 */
 	if ((~0ULL - clc > rnd) &&
-	    (!ismax || evt->mult <= (1U << evt->shift)))
+	    (!ismax || evt->mult <= (1ULL << evt->shift)))
 		clc += rnd;
 
 	do_div(clc, evt->mult);
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 42b463ad90f2..31ea01f42e1f 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -636,6 +636,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 			goto out;
 		}
 	} else {
+		memset(&event.sigev_value, 0, sizeof(event.sigev_value));
 		event.sigev_notify = SIGEV_SIGNAL;
 		event.sigev_signo = SIGALRM;
 		event.sigev_value.sival_int = new_timer->it_id;
