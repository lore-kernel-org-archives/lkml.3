Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbbA2JAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:24 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755429AbbA2JAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 155/176] clocksource: exynos_mct: Fix bitmask regression for exynos4_mct_write
Date: Wed, 28 Jan 2015 15:29:45 +0100
Message-Id: <5fd6b8ef126ff49ec1d79e13c10ff52d16f528cf.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8c38d28ba8da98f7102c31d35359b4dbe9d1f329 upstream.

EXYNOS4_MCT_L_MASK is defined as 0xffffff00, so applying this bitmask
produces a number outside the range 0x00 to 0xff, which always results
in execution of the default switch statement.

Obviously this is wrong and git history shows that the bitmask inversion
was incorrectly set during a refactoring of the MCT code.

Fix this by putting the inversion at the correct position again.

Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Reported-by: GP Orcullo <kinsamanka@gmail.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/clocksource/exynos_mct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
index 70f3a597ec57..12fbec743fac 100644
--- a/drivers/clocksource/exynos_mct.c
+++ b/drivers/clocksource/exynos_mct.c
@@ -94,8 +94,8 @@ static void exynos4_mct_write(unsigned int value, unsigned long offset)
 	__raw_writel(value, reg_base + offset);
 
 	if (likely(offset >= EXYNOS4_MCT_L_BASE(0))) {
-		stat_addr = (offset & ~EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
-		switch (offset & EXYNOS4_MCT_L_MASK) {
+		stat_addr = (offset & EXYNOS4_MCT_L_MASK) + MCT_L_WSTAT_OFFSET;
+		switch (offset & ~EXYNOS4_MCT_L_MASK) {
 		case MCT_L_TCON_OFFSET:
 			mask = 1 << 3;		/* L_TCON write status */
 			break;
-- 
2.2.2

