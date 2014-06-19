Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175AbaFSRIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:08:36 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:58971 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781AbaFSRId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:08:33 -0400
From: Doug Anderson <dianders@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, olof@lixom.net,
        linux-samsung-soc@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        javier.martinez@collabora.co.uk, Doug Anderson <dianders@chromium.org>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] clocksource: exynos_mct: Fix ftrace
Date: Thu, 19 Jun 2014 10:08:26 -0700
Message-Id: <1403197706-29966-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In (93bfb76 clocksource: exynos_mct: register sched_clock callback) we
supported using the MCT as a scheduler clock.  We properly marked
exynos4_read_sched_clock() as notrace.  However, we then went and
called another function that _wasn't_ notrace.  That means if you do:

  cd /sys/kernel/debug/tracing/
  echo function_graph > current_tracer

You'll get a crash.

Fix this (but still let other readers of the MCT be trace-enabled) by
adding an extra function.  It's important to keep other users of MCT
traceable because the MCT is actually quite slow to access and we want
exynos4_frc_read() to show up in ftrace profiles if it's the
bottleneck.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v2:
- Split out from other patches so this can go into 3.16.
- Better comment about why exynos4_frc_read() should be traceable.
- No more useless inline.

 drivers/clocksource/exynos_mct.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index f71d55f..5ce99c0 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -162,7 +162,7 @@ static void exynos4_mct_frc_start(void)
 	exynos4_mct_write(reg, EXYNOS4_MCT_G_TCON);
 }
 
-static cycle_t exynos4_frc_read(struct clocksource *cs)
+static cycle_t notrace _exynos4_frc_read(void)
 {
 	unsigned int lo, hi;
 	u32 hi2 = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_U);
@@ -176,6 +176,11 @@ static cycle_t exynos4_frc_read(struct clocksource *cs)
 	return ((cycle_t)hi << 32) | lo;
 }
 
+static cycle_t exynos4_frc_read(struct clocksource *cs)
+{
+	return _exynos4_frc_read();
+}
+
 static void exynos4_frc_resume(struct clocksource *cs)
 {
 	exynos4_mct_frc_start();
@@ -192,7 +197,7 @@ struct clocksource mct_frc = {
 
 static u64 notrace exynos4_read_sched_clock(void)
 {
-	return exynos4_frc_read(&mct_frc);
+	return _exynos4_frc_read();
 }
 
 static void __init exynos4_clocksource_init(void)
-- 
2.0.0.526.g5318336

