Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966204AbaFTRsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 13:48:06 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:36919 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402AbaFTRsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 13:48:00 -0400
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
Subject: [PATCH v3 1/3] clocksource: exynos_mct: Register the timer for stable udelay
Date: Fri, 20 Jun 2014 10:47:50 -0700
Message-Id: <1403286472-6817-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403286472-6817-1-git-send-email-dianders@chromium.org>
References: <1403286472-6817-1-git-send-email-dianders@chromium.org>
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
---
Changes in v3:
- Back to exynos_frc_read for now until 32/64 is resolved.
- Now returns cycles_t which matches arch/arm/include/asm/timex.h.
- Rebased.
- Moved registration to its own function.

Changes in v2:
- Added #defines for ARM and ARM64 as pointed by Doug Anderson.

 drivers/clocksource/exynos_mct.c | 11 +++++++++++
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
2.0.0.526.g5318336

