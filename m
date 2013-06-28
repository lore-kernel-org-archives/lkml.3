Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3F1Klh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:41:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:45489 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab3F1Klf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:41:35 -0400
Date: Fri, 28 Jun 2013 12:41:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [GIT pull] timer fixes for 3.10
Message-ID: <alpine.DEB.2.02.1306281226360.4013@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
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


 * Correct an ordering issue in the tick broadcast code. I really wish
   we'd get compensation for pain and suffering for each line of code
   we write to work around disfunctional timer hardware.

Thanks,

	tglx

------------------>
Daniel Lezcano (1):
      tick: Fix tick_broadcast_pending_mask not cleared


 kernel/time/tick-broadcast.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index b4c2455..20d6fba 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -599,8 +599,6 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	} else {
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-			if (dev->next_event.tv64 == KTIME_MAX)
-				goto out;
 			/*
 			 * The cpu which was handling the broadcast
 			 * timer marked this cpu in the broadcast
@@ -615,6 +613,11 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 				goto out;
 
 			/*
+			 * Bail out if there is no next event.
+			 */
+			if (dev->next_event.tv64 == KTIME_MAX)
+				goto out;
+			/*
 			 * If the pending bit is not set, then we are
 			 * either the CPU handling the broadcast
 			 * interrupt or we got woken by something else.
