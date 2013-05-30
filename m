Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab3E3Xfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 19:35:52 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51069 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3E3Xfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 19:35:44 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Bohac <jbohac@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tick: Remove useless timekeeping duty attribution to broadcast source
Date: Fri, 31 May 2013 01:35:37 +0200
Message-Id: <1369956937-29579-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <alpine.LFD.2.02.1305301638470.2905@ionos>
References: <alpine.LFD.2.02.1305301638470.2905@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

Since 7300711e ("clockevents: broadcast fixup possible waiters"),
the timekeeping duty is assigned to the CPU that handles the tick
broadcast clock device by the time it is set in one shot mode.

This is an issue in full dynticks mode where the timekeeping duty
must stay handled by the boot CPU for now. Otherwise it prevents
secondary CPUs from offlining and this breaks
suspend/shutdown/reboot/...

As it appears there is no reason for this timekeeping duty to be
moved to the broadcast CPU, besides nothing prevent it from being
later re-assigned to another target, let's simply remove it.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/time/tick-broadcast.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 24938d5..ee316b9 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -692,10 +692,6 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 
-		/* Take the do_timer update */
-		if (!tick_nohz_full_cpu(cpu))
-			tick_do_timer_cpu = cpu;
-
 		/*
 		 * We must be careful here. There might be other CPUs
 		 * waiting for periodic broadcast. We need to set the
-- 
1.7.5.4

