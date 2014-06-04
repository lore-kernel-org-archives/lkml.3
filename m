Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaFDRbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:31:01 -0400
Received: from mail-yh0-f73.google.com ([209.85.213.73]:58005 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaFDRa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:30:58 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, olof@lixom.net,
        linux-samsung-soc@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] clocksource: exynos_mct: Optimize register reads with ldmia
Date: Wed,  4 Jun 2014 10:30:34 -0700
Message-Id: <1401903034-20074-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1401903034-20074-1-git-send-email-dianders@chromium.org>
References: <1401903034-20074-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we saw in (clocksource: exynos_mct: cache mct upper count), the
time spent reading the MCT shows up fairly high in real-world
profiles.  That means that it's worth some optimization.

We get a roughly 10% speedup in userspace gettimeofday() by using an
ldmia to read the two halfs of the MCT.  That seems like a worthwhile
thing to do.

Before: 1173084 us for 1000000 gettimeofday in userspace
After:  1045674 us for 1000000 gettimeofday in userspace

NOTE: we could actually do better than this if we really wanted to.
Technically we could register the clocksource as a 32-bit timer and
only use the "lower" half.  Doing so brings us down to 1014429 us for
1000000 gettimeofday in userspace (and doesn't even require assembly
code).  That would be an alternative to this change.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/clocksource/exynos_mct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 7cbe4aa..6e3017b 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -172,8 +172,9 @@ static inline cycle_t notrace _exynos4_frc_read(void)
 
 	do {
 		hi = hi2;
-		lo = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_L);
-		hi2 = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_U);
+		asm volatile("ldmia  %2, {%0, %1}"
+			     : "=r" (lo), "=r" (hi2)
+			     : "r" (reg_base + EXYNOS4_MCT_G_CNT_L));
 	} while (hi != hi2);
 
 	return ((cycle_t)hi << 32) | lo;
-- 
2.0.0.526.g5318336

