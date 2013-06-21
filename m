Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab3FULYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 07:24:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55597 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab3FULYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 07:24:52 -0400
Date: Fri, 21 Jun 2013 04:24:35 -0700
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-ea8deb8dfa6b0e8d1b3d1051585706739b46656c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        josephl@nvidia.com, swarren@nvidia.com, tglx@linutronix.de,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        josephl@nvidia.com, tglx@linutronix.de, swarren@nvidia.com,
        daniel.lezcano@linaro.org
In-Reply-To: <1371485735-31249-1-git-send-email-daniel.lezcano@linaro.org>
References: <1371485735-31249-1-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick:
  Fix tick_broadcast_pending_mask not cleared
Git-Commit-ID: ea8deb8dfa6b0e8d1b3d1051585706739b46656c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 21 Jun 2013 04:24:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea8deb8dfa6b0e8d1b3d1051585706739b46656c
Gitweb:     http://git.kernel.org/tip/ea8deb8dfa6b0e8d1b3d1051585706739b46656c
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Mon, 17 Jun 2013 18:15:35 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Jun 2013 13:10:34 +0200

tick: Fix tick_broadcast_pending_mask not cleared

The recent modification in the cpuidle framework consolidated the
timer broadcast code across the different drivers by setting a new
flag in the idle state. It tells the cpuidle core code to enter/exit
the broadcast mode for the cpu when entering a deep idle state. The
broadcast timer enter/exit is no longer handled by the back-end
driver.

This change made the local interrupt to be enabled *before* calling
CLOCK_EVENT_NOTIFY_EXIT.

On a tegra114, a four cores system, when the flag has been introduced
in the driver, the following warning appeared:

WARNING: at kernel/time/tick-broadcast.c:578 tick_broadcast_oneshot_control
CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.10.0-rc3-next-20130529+ #15
[<c00667f8>] (tick_broadcast_oneshot_control+0x1a4/0x1d0) from [<c0065cd0>] (tick_notify+0x240/0x40c)
[<c0065cd0>] (tick_notify+0x240/0x40c) from [<c0044724>] (notifier_call_chain+0x44/0x84)
[<c0044724>] (notifier_call_chain+0x44/0x84) from [<c0044828>] (raw_notifier_call_chain+0x18/0x20)
[<c0044828>] (raw_notifier_call_chain+0x18/0x20) from [<c00650cc>] (clockevents_notify+0x28/0x170)
[<c00650cc>] (clockevents_notify+0x28/0x170) from [<c033f1f0>] (cpuidle_idle_call+0x11c/0x168)
[<c033f1f0>] (cpuidle_idle_call+0x11c/0x168) from [<c000ea94>] (arch_cpu_idle+0x8/0x38)
[<c000ea94>] (arch_cpu_idle+0x8/0x38) from [<c005ea80>] (cpu_startup_entry+0x60/0x134)
[<c005ea80>] (cpu_startup_entry+0x60/0x134) from [<804fe9a4>] (0x804fe9a4)

I don't have the hardware, so I wasn't able to reproduce the warning
but after looking a while at the code, I deduced the following:

 1. the CPU2 enters a deep idle state and sets the broadcast timer

 2. the timer expires, the tick_handle_oneshot_broadcast function is
    called, setting the tick_broadcast_pending_mask and waking up the
    idle cpu CPU2

 3. the CPU2 exits idle handles the interrupt and then invokes
    tick_broadcast_oneshot_control with CLOCK_EVENT_NOTIFY_EXIT which
    runs the following code:

    [...]
    if (dev->next_event.tv64 == KTIME_MAX)
            goto out;

    if (cpumask_test_and_clear_cpu(cpu,
                                 tick_broadcast_pending_mask))
            goto out;
    [...]

    So if there is no next event scheduled for CPU2, we fulfil the
    first condition and jump out without clearing the
    tick_broadcast_pending_mask.

 4. CPU2 goes to deep idle again and calls
    tick_broadcast_oneshot_control with CLOCK_NOTIFY_EVENT_ENTER but
    with the tick_broadcast_pending_mask set for CPU2, triggering the
    warning.

The issue only surfaced due to the modifications of the cpuidle
framework, which resulted in interrupts being enabled before the call
to the clockevents code. If the call happens before interrupts have
been enabled, the warning cannot trigger, because there is still the
event pending which caused the broadcast timer expiry.

Move the check for the next event below the check for the pending bit,
so the pending bit gets cleared whether an event is scheduled on the
cpu or not.

[ tglx: Massaged changelog ]

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Reported-and-tested-by: Joseph Lo <josephl@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linaro-kernel@lists.linaro.org
Link: http://lkml.kernel.org/r/1371485735-31249-1-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 7 +++++--
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
