Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540Ab3DQT7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:59:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58368 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965067Ab3DQT7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:59:51 -0400
Date: Wed, 17 Apr 2013 12:59:41 -0700
From: tip-bot for Stephen Boyd <tipbot@zytor.com>
Message-ID: <tip-c038c1c44179c80da6201f91ef354e48d5689617@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sboyd@codeaurora.org
In-Reply-To: <1366219566-29783-1-git-send-email-sboyd@codeaurora.org>
References: <1366219566-29783-1-git-send-email-sboyd@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents:
  Switch into oneshot mode even if broadcast registered late
Git-Commit-ID: c038c1c44179c80da6201f91ef354e48d5689617
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 12:59:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c038c1c44179c80da6201f91ef354e48d5689617
Gitweb:     http://git.kernel.org/tip/c038c1c44179c80da6201f91ef354e48d5689617
Author:     Stephen Boyd <sboyd@codeaurora.org>
AuthorDate: Wed, 17 Apr 2013 10:26:06 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 17 Apr 2013 21:30:56 +0200

clockevents: Switch into oneshot mode even if broadcast registered late

tick_oneshot_notify() is used to notify a particular CPU to try
to switch into oneshot mode after a oneshot capable tick device
is registered and tick_clock_notify() is used to notify all CPUs
to try to switch into oneshot mode after a high res clocksource
is registered. There is one caveat; if the tick devices suffer
from FEAT_C3_STOP we don't try to switch into oneshot mode unless
we have a oneshot capable broadcast device already registered.

If the broadcast device is registered after the tick devices that
have FEAT_C3_STOP we'll never try to switch into oneshot mode
again, causing us to be stuck in periodic mode forever. Avoid
this scenario by calling tick_clock_notify() after we register
the broadcast device so that we try to switch into oneshot mode
on all CPUs one more time.

[ tglx: Adopted to timers/core and added a comment ]

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Link: http://lkml.kernel.org/r/1366219566-29783-1-git-send-email-sboyd@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index d76d816..f8d2109 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -75,6 +75,16 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_broadcast_mask))
 		tick_broadcast_start_periodic(dev);
+	/*
+	 * Inform all cpus about this. We might be in a situation
+	 * where we did not switch to oneshot mode because the per cpu
+	 * devices are affected by CLOCK_EVT_FEAT_C3STOP and the lack
+	 * of a oneshot capable broadcast device. Without that
+	 * notification the systems stays stuck in periodic mode
+	 * forever.
+	 */
+	if (dev->features & CLOCK_EVT_FEAT_ONESHOT)
+		tick_clock_notify();
 	return 1;
 }
 
