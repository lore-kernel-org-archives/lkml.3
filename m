Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaFDRbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:31:04 -0400
Received: from mail-vc0-f201.google.com ([209.85.220.201]:50379 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaFDRbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:31:01 -0400
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, olof@lixom.net,
        linux-samsung-soc@vger.kernel.org,
        Mandeep Singh Baines <msb@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Doug Anderson <dianders@chromium.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/3] clocksource: exynos_mct: cache mct upper count
Date: Wed,  4 Jun 2014 10:30:33 -0700
Message-Id: <1401903034-20074-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1401903034-20074-1-git-send-email-dianders@chromium.org>
References: <1401903034-20074-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mandeep Singh Baines <msb@chromium.org>

Saves one register read.  Note that the upper count only changes every
~178 seconds with a 24MHz source clock, so it's likely it hasn't
changed from call to call.

Before: 1323852 us for 1000000 gettimeofday in userspace
After:  1173084 us for 1000000 gettimeofday in userspace

Note that even with this change the CPU is in exynos_frc_read() more
than 2% of the time in real world profiles of ChromeOS.  That
indicates that it's important to optimize.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/clocksource/exynos_mct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index ba3a683..7cbe4aa 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -167,8 +167,8 @@ static void exynos4_mct_frc_start(u32 hi, u32 lo)
 
 static inline cycle_t notrace _exynos4_frc_read(void)
 {
-	unsigned int lo, hi;
-	u32 hi2 = __raw_readl(reg_base + EXYNOS4_MCT_G_CNT_U);
+	u32 lo, hi;
+	static u32 hi2;
 
 	do {
 		hi = hi2;
-- 
2.0.0.526.g5318336

