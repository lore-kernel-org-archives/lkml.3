Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3CGAGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:06:46 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36435 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab3CGAEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:04:09 -0500
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="27738008"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 02/10] ARM: smp: Remove duplicate dummy timer implementation
Date: Wed,  6 Mar 2013 16:03:58 -0800
Message-Id: <1362614646-24113-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop ARM's version of the dummy timer now that we have a generic
implementation in drivers/clocksource.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/smp.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 1bdfd87..e4f3669 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -468,24 +468,6 @@ void tick_broadcast(const struct cpumask *mask)
 }
 #endif
 
-static void broadcast_timer_set_mode(enum clock_event_mode mode,
-	struct clock_event_device *evt)
-{
-}
-
-static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
-{
-	evt->name	= "dummy_timer";
-	evt->features	= CLOCK_EVT_FEAT_ONESHOT |
-			  CLOCK_EVT_FEAT_PERIODIC |
-			  CLOCK_EVT_FEAT_DUMMY;
-	evt->rating	= 400;
-	evt->mult	= 1;
-	evt->set_mode	= broadcast_timer_set_mode;
-
-	clockevents_register_device(evt);
-}
-
 static struct local_timer_ops *lt_ops;
 
 #ifdef CONFIG_LOCAL_TIMERS
@@ -509,8 +491,8 @@ static void __cpuinit percpu_timer_setup(void)
 
 	evt->cpumask = cpumask_of(cpu);
 
-	if (!lt_ops || lt_ops->setup(evt))
-		broadcast_timer_setup(evt);
+	if (lt_ops)
+		lt_ops->setup(evt);
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

