Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab3E1Hux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:50:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47467 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3E1Huw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:50:52 -0400
Date: Tue, 28 May 2013 00:50:14 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-2938d2757fc99c26aa678ce4eba910c4a77c3a55@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bp@alien8.de, lenb@kernel.org, fweisbec@gmail.com, mroos@linux.ee,
        tglx@linutronix.de, rjw@sisk.pl
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bp@alien8.de, lenb@kernel.org, fweisbec@gmail.com, mroos@linux.ee,
        tglx@linutronix.de, rjw@sisk.pl
In-Reply-To: <alpine.LFD.2.02.1305271841130.4220@ionos>
References: <alpine.LFD.2.02.1305271841130.4220@ionos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick:
  Cure broadcast false positive pending bit warning
Git-Commit-ID: 2938d2757fc99c26aa678ce4eba910c4a77c3a55
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

Commit-ID:  2938d2757fc99c26aa678ce4eba910c4a77c3a55
Gitweb:     http://git.kernel.org/tip/2938d2757fc99c26aa678ce4eba910c4a77c3a55
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 28 May 2013 09:33:01 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 28 May 2013 09:33:01 +0200

tick: Cure broadcast false positive pending bit warning

commit 26517f3e (tick: Avoid programming the local cpu timer if
broadcast pending) added a warning if the cpu enters broadcast mode
again while the pending bit is still set. Meelis reported that the
warning triggers. There are two corner cases which have been not
considered:

1) cpuidle calls clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER)
   twice. That can result in the following scenario

   CPU0                    CPU1
                           cpuidle_idle_call()
                             clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER)
                               set cpu in tick_broadcast_oneshot_mask

   broadcast interrupt
     event expired for cpu1
     set pending bit

                             acpi_idle_enter_simple()
                               clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER)
                                 WARN_ON(pending bit)

  Move the WARN_ON into the section where we enter broadcast mode so
  it wont provide false positives on the second call.

2) safe_halt() enables interrupts, so a broadcast interrupt can be
   delivered befor the broadcast mode is disabled. That sets the
   pending bit for the CPU which receives the broadcast
   interrupt. Though the interrupt is delivered right away from the
   broadcast handler and leaves the pending bit stale.

   Clear the pending bit for the current cpu in the broadcast handler.

Reported-and-tested-by: Meelis Roos <mroos@linux.ee>
Cc: Len Brown <lenb@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1305271841130.4220@ionos
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

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
