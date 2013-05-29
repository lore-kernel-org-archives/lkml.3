Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637Ab3E2QkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:40:05 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35733 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759554Ab3E2Qjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:39:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Bohac <jbohac@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH] nohz: Prevent broadcast source from stealing full dynticks timekeeping duty
Date: Wed, 29 May 2013 18:39:40 +0200
Message-Id: <1369845580-15273-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369845580-15273-1-git-send-email-fweisbec@gmail.com>
References: <1369845580-15273-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timekeeping duty is currently assigned to the CPU that
handles the tick broadcast clock device by the time it is set in
one shot mode.

The reason for this is not entirely clear as outlined by Jiri
Bohac: https://patchwork.kernel.org/patch/2302951/

One could speculate though that it makes sure only one CPU
is woken up to fixup the timekeeping max deferment. But the
timekeeper can change anytime after the broadcast CPU becomes
idle. So probably we can remove this as in Jiri's patch, but
not late in the -rc's.

The issue we need to deal with now is that the timekeeping duty
must stay handled by the boot CPU in full dynticks mode for now.
Otherwise it prevents secondary CPUs from offlining and this breaks
suspend/shutdown/reboot/...

Long term plan is to make the timekeeper dynamic in full dynticks
as well but for now lets prevent that to happen to avoid breakages.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
---
 kernel/time/tick-broadcast.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 24938d5..ed3a253 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -692,9 +692,14 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 
-		/* Take the do_timer update */
-		if (!tick_nohz_full_cpu(cpu))
-			tick_do_timer_cpu = cpu;
+		/*
+		 * Take the timekeeping duty unless we run in full
+		 * dynticks mode that require the boot CPU to stay
+		 * the timekeeper for now.
+		 */
+#ifndef CONFIG_NO_HZ_FULL
+		tick_do_timer_cpu = cpu;
+#endif
 
 		/*
 		 * We must be careful here. There might be other CPUs
-- 
1.7.5.4

