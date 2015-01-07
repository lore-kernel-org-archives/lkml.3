Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbbAGLeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:34:50 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57606 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbAGLet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:34:49 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: olof@lixom.net, magnus.damm@gmail.com, tjakobi@math.uni-bielefeld.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write
Date: Wed,  7 Jan 2015 12:28:56 +0100
Message-Id: <1420630138-31443-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <54AD17F1.4010002@linaro.org>
References: <54AD17F1.4010002@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

EXYNOS4_MCT_L_MASK is defined as 0xffffff00, so applying this bitmask
produces a number outside the range 0x00 to 0xff, which always results
in execution of the default switch statement.

Obviously this is wrong and git history shows that the bitmask inversion
was incorrectly set during a refactoring of the MCT code.

Fix this by putting the inversion at the correct position again.

Cc: stable@vger.kernel.org
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Reported-by: GP Orcullo <kinsamanka@gmail.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/exynos_mct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 9403061..83564c9 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -97,8 +97,8 @@ static void exynos4_mct_write(unsigned int value, unsigned long offset)
 	writel_relaxed(value, reg_base + offset);
 
 	if (likely(offset >= EXYNOS4_MCT_L_BASE(0))) {
-		stat_addr = (offset & ~EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
-		switch (offset & EXYNOS4_MCT_L_MASK) {
+		stat_addr = (offset & EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
+		switch (offset & ~EXYNOS4_MCT_L_MASK) {
 		case MCT_L_TCON_OFFSET:
 			mask = 1 << 3;		/* L_TCON write status */
 			break;
-- 
1.9.1

