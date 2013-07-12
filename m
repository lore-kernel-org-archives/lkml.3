Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab3GLKk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 06:40:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab3GLKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 06:40:24 -0400
Date: Fri, 12 Jul 2013 03:39:36 -0700
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-a272dcca1802a7e265a56e60b0d0a6715b0a8ac2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com,
        Mark.Rutland@arm.com, swarren@nvidia.com, sboyd@codeaurora.org,
        john.stultz@linaro.org, josephl@nvidia.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Mark.Rutland@arm.com,
        marc.zyngier@arm.com, swarren@nvidia.com, sboyd@codeaurora.org,
        john.stultz@linaro.org, josephl@nvidia.com, tglx@linutronix.de
In-Reply-To: <20130711140059.GA27430@codeaurora.org>
References: <20130711140059.GA27430@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick: broadcast:
  Check broadcast mode on CPU hotplug
Git-Commit-ID: a272dcca1802a7e265a56e60b0d0a6715b0a8ac2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 03:39:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a272dcca1802a7e265a56e60b0d0a6715b0a8ac2
Gitweb:     http://git.kernel.org/tip/a272dcca1802a7e265a56e60b0d0a6715b0a8ac2
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Thu, 11 Jul 2013 07:00:59 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 12 Jul 2013 12:35:40 +0200

tick: broadcast: Check broadcast mode on CPU hotplug

On ARM systems the dummy clockevent is registered with the cpu
hotplug notifier chain before any other per-cpu clockevent. This
has the side-effect of causing the dummy clockevent to be
registered first in every hotplug sequence. Because the dummy is
first, we'll try to turn the broadcast source on but the code in
tick_device_uses_broadcast() assumes the broadcast source is in
periodic mode and calls tick_broadcast_start_periodic()
unconditionally.

On boot this isn't a problem because we typically haven't
switched into oneshot mode yet (if at all). During hotplug, if
the broadcast source isn't in periodic mode we'll replace the
broadcast oneshot handler with the broadcast periodic handler and
start emulating oneshot mode when we shouldn't. Due to the way
the broadcast oneshot handler programs the next_event it's
possible for it to contain KTIME_MAX and cause us to hang the
system when the periodic handler tries to program the next tick.
Fix this by using the appropriate function to start the broadcast
source.

Reported-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: ARM kernel mailing list <linux-arm-kernel@lists.infradead.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Joseph Lo <josephl@nvidia.com>
Link: http://lkml.kernel.org/r/20130711140059.GA27430@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 6d3f916..218bcb5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -157,7 +157,10 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 		dev->event_handler = tick_handle_periodic;
 		tick_device_setup_broadcast_func(dev);
 		cpumask_set_cpu(cpu, tick_broadcast_mask);
-		tick_broadcast_start_periodic(bc);
+		if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
+			tick_broadcast_start_periodic(bc);
+		else
+			tick_broadcast_setup_oneshot(bc);
 		ret = 1;
 	} else {
 		/*
