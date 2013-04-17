Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965930Ab3DQR0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:26:10 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40824 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965493Ab3DQR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:26:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,495,1363158000"; 
   d="scan'208";a="39129275"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] clockevents: Switch into oneshot mode even if broadcast registered late
Date: Wed, 17 Apr 2013 10:26:06 -0700
Message-Id: <1366219566-29783-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1.392.g85e7e81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Found this one when we were registering our broadcast timer after irqs were
enabled. We've moved the registration before the irqs are enabled now so
technically we don't need this patch anymore, but it seemed like a good idea
to fix it in the core anyway to save someone else the trouble of tracking it
down later.

 kernel/time/tick-broadcast.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 7f32fe0..69b1b1a 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -77,6 +77,8 @@ int tick_check_broadcast_device(struct clock_event_device *dev)
 	tick_broadcast_device.evtdev = dev;
 	if (!cpumask_empty(tick_get_broadcast_mask()))
 		tick_broadcast_start_periodic(dev);
+	if (dev->features & CLOCK_EVT_FEAT_ONESHOT)
+		tick_clock_notify();
 	return 1;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

