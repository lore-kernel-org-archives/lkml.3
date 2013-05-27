Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3E0Qol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:44:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:48106 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab3E0Qok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:44:40 -0400
Date: Mon, 27 May 2013 18:44:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Meelis Roos <mroos@linux.ee>
cc: Borislav Petkov <bp@alien8.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 3.10-rc3: WARNING: at kernel/time/tick-broadcast.c:578
In-Reply-To: <alpine.SOC.1.00.1305271849130.2372@math.ut.ee>
Message-ID: <alpine.LFD.2.02.1305271841130.4220@ionos>
References: <alpine.SOC.1.00.1305271406050.2372@math.ut.ee> <20130527123520.GA4806@pd.tnic> <alpine.LFD.2.02.1305271456280.4220@ionos> <alpine.SOC.1.00.1305271849130.2372@math.ut.ee>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013, Meelis Roos wrote:
> > So we need to move the WARN_ON into the section where we actually set
> > the broadcast stuff up.
> 
> Are you sure? This is a UP machine.

Ooops.
 
> Tested the patch - no effect, warning is still there :(

Found another possibility how we end up with the stale flag.

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 24938d5..0c73942 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -511,6 +511,12 @@ again:
 		}
 	}
 
+	/*
+	 * Remove the current cpu from the pending mask. The event is
+	 * delivered immediately in tick_do_broadcast() !
+	 */
+	cpumask_clear_cpu(smp_processor_id(), tick_broadcast_pending_mask);
+
 	/* Take care of enforced broadcast requests */
 	cpumask_or(tmpmask, tmpmask, tick_broadcast_force_mask);
 	cpumask_clear(tick_broadcast_force_mask);
@@ -575,8 +581,8 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
-		WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 		if (!cpumask_test_and_set_cpu(cpu, tick_broadcast_oneshot_mask)) {
+			WARN_ON_ONCE(cpumask_test_cpu(cpu, tick_broadcast_pending_mask));
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
 			/*
 			 * We only reprogram the broadcast timer if we
