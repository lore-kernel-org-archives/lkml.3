Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaGORYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:24:52 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:48104 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898AbaGORCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:09 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 23/94] clocksource: exynos_mct: Fix ftrace
Date: Tue, 15 Jul 2014 20:00:38 +0300
Message-Id: <1405443709-15288-23-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Anderson <dianders@chromium.org>

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
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clocksource/exynos_mct.c |    9 +++++++--
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
1.7.10.4

