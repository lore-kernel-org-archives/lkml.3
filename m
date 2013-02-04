Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3BDKa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:30:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3BDKa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:30:56 -0500
Date: Mon, 4 Feb 2013 02:30:28 -0800
From: tip-bot for Mark Rutland <mark.rutland@arm.com>
Message-ID: <tip-12572dbb53638c6e454ef831c8fee7de3df24389@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        santosh.shilimkar@ti.com, mark.rutland@arm.com, tglx@linutronix.de,
        sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, tglx@linutronix.de, mark.rutland@arm.com,
        sboyd@codeaurora.org
In-Reply-To: <1358183124-28461-2-git-send-email-mark.rutland@arm.com>
References: <1358183124-28461-2-git-send-email-mark.rutland@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents:
  Add generic timer broadcast receiver
Git-Commit-ID: 12572dbb53638c6e454ef831c8fee7de3df24389
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 02:30:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12572dbb53638c6e454ef831c8fee7de3df24389
Gitweb:     http://git.kernel.org/tip/12572dbb53638c6e454ef831c8fee7de3df24389
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Mon, 14 Jan 2013 17:05:21 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 31 Jan 2013 22:15:35 +0100

clockevents: Add generic timer broadcast receiver

Currently the broadcast mechanism used for timers is abstracted by a
function pointer on struct clock_event_device. As the fundamental
mechanism for broadcast is architecture-specific, this ties each
clock_event_device driver to a single architecture, even where the
driver is otherwise generic.

This patch adds a standard path for the receipt of timer broadcasts, so
drivers and/or architecture backends need not manage redundant lists of
timers for the purpose of routing broadcast timer ticks.

[tglx: Made the implementation depend on the config switch as well ]

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: nico@linaro.org
Cc: Will.Deacon@arm.com
Cc: Marc.Zyngier@arm.com
Cc: john.stultz@linaro.org
Link: http://lkml.kernel.org/r/1358183124-28461-2-git-send-email-mark.rutland@arm.com
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h   |  4 ++++
 kernel/time/tick-broadcast.c | 17 +++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 8a7096f..e1089aa 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -161,6 +161,10 @@ clockevents_calc_mult_shift(struct clock_event_device *ce, u32 freq, u32 minsec)
 extern void clockevents_suspend(void);
 extern void clockevents_resume(void);
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+extern int tick_receive_broadcast(void);
+#endif
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..7cc81c5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -125,6 +125,23 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 	return ret;
 }
 
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+int tick_receive_broadcast(void)
+{
+	struct tick_device *td = this_cpu_ptr(&tick_cpu_device);
+	struct clock_event_device *evt = td->evtdev;
+
+	if (!evt)
+		return -ENODEV;
+
+	if (!evt->event_handler)
+		return -EINVAL;
+
+	evt->event_handler(evt);
+	return 0;
+}
+#endif
+
 /*
  * Broadcast the event to the cpus, which are set in the mask (mangled).
  */
