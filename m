Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbaGORPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:15:09 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:55981 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbaGORCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:12 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Kukjin Kim <kgene.kim@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 24/94] clocksource: exynos_mct: Register the timer for stable udelay
Date: Tue, 15 Jul 2014 20:00:39 +0300
Message-Id: <1405443709-15288-24-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Daniel Kachhap <amit.daniel@samsung.com>

This patch registers the exynos mct clocksource as the current timer
as it has constant clock rate. This will generate correct udelay for
the exynos platform and avoid using unnecessary calibrated
jiffies. This change has been tested on exynos5420 based board and
udelay is very close to expected.

Without this patch udelay() on exynos5400 / exynos5800 is wildly
inaccurate due to big.LITTLE not adjusting loops_per_jiffy correctly.
Also without this patch udelay() on exynos5250 can be innacruate
during transitions between frequencies < 800 MHz (you'll go 200 MHz ->
800 MHz -> 300 MHz and will run at 800 MHz for a time with the wrong
loops_per_jiffy).

[dianders: reworked and created version 3]

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clocksource/exynos_mct.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 5ce99c0..ab51bf20a 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -200,10 +200,21 @@ static u64 notrace exynos4_read_sched_clock(void)
 	return _exynos4_frc_read();
 }
 
+static struct delay_timer exynos4_delay_timer;
+
+static cycles_t exynos4_read_current_timer(void)
+{
+	return _exynos4_frc_read();
+}
+
 static void __init exynos4_clocksource_init(void)
 {
 	exynos4_mct_frc_start();
 
+	exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
+	exynos4_delay_timer.freq = clk_rate;
+	register_current_timer_delay(&exynos4_delay_timer);
+
 	if (clocksource_register_hz(&mct_frc, clk_rate))
 		panic("%s: can't register clocksource\n", mct_frc.name);
 
-- 
1.7.10.4

