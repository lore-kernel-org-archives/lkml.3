Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaEWKcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:32:17 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37620 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaEWKcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:32:15 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 31/71] clocksource: sh_tmu: Hardcode TMU clock event and source ratings to 200
Date: Fri, 23 May 2014 12:31:11 +0200
Message-Id: <1400841111-6683-31-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
References: <537F214C.8000700@linaro.org>
 <1400841111-6683-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

All boards use clock event and clock source ratings of 200 for the TMU,
hardcode it in the driver.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/clocksource/sh_tmu.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 63ed92d..fec9bed 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -300,12 +300,12 @@ static void sh_tmu_clocksource_resume(struct clocksource *cs)
 }
 
 static int sh_tmu_register_clocksource(struct sh_tmu_channel *ch,
-				       const char *name, unsigned long rating)
+				       const char *name)
 {
 	struct clocksource *cs = &ch->cs;
 
 	cs->name = name;
-	cs->rating = rating;
+	cs->rating = 200;
 	cs->read = sh_tmu_clocksource_read;
 	cs->enable = sh_tmu_clocksource_enable;
 	cs->disable = sh_tmu_clocksource_disable;
@@ -402,7 +402,7 @@ static void sh_tmu_clock_event_resume(struct clock_event_device *ced)
 }
 
 static void sh_tmu_register_clockevent(struct sh_tmu_channel *ch,
-				       const char *name, unsigned long rating)
+				       const char *name)
 {
 	struct clock_event_device *ced = &ch->ced;
 	int ret;
@@ -410,7 +410,7 @@ static void sh_tmu_register_clockevent(struct sh_tmu_channel *ch,
 	ced->name = name;
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
-	ced->rating = rating;
+	ced->rating = 200;
 	ced->cpumask = cpumask_of(0);
 	ced->set_next_event = sh_tmu_clock_event_next;
 	ced->set_mode = sh_tmu_clock_event_mode;
@@ -433,13 +433,12 @@ static void sh_tmu_register_clockevent(struct sh_tmu_channel *ch,
 }
 
 static int sh_tmu_register(struct sh_tmu_channel *ch, const char *name,
-		    unsigned long clockevent_rating,
-		    unsigned long clocksource_rating)
+			   bool clockevent, bool clocksource)
 {
-	if (clockevent_rating)
-		sh_tmu_register_clockevent(ch, name, clockevent_rating);
-	else if (clocksource_rating)
-		sh_tmu_register_clocksource(ch, name, clocksource_rating);
+	if (clockevent)
+		sh_tmu_register_clockevent(ch, name);
+	else if (clocksource)
+		sh_tmu_register_clocksource(ch, name);
 
 	return 0;
 }
@@ -471,8 +470,8 @@ static int sh_tmu_channel_setup(struct sh_tmu_channel *ch,
 	ch->enable_count = 0;
 
 	return sh_tmu_register(ch, dev_name(&tmu->pdev->dev),
-			       cfg->clockevent_rating,
-			       cfg->clocksource_rating);
+			       cfg->clockevent_rating != 0,
+			       cfg->clocksource_rating != 0);
 }
 
 static int sh_tmu_setup(struct sh_tmu_device *tmu, struct platform_device *pdev)
-- 
1.7.9.5

