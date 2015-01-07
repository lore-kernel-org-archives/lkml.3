Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbbAGL3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:29:06 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63043 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbbAGL3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:29:04 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: olof@lixom.net, magnus.damm@gmail.com, tjakobi@math.uni-bielefeld.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] clocksource: kona: fix __iomem annotation
Date: Wed,  7 Jan 2015 12:28:57 +0100
Message-Id: <1420630138-31443-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420630138-31443-1-git-send-email-daniel.lezcano@linaro.org>
References: <54AD17F1.4010002@linaro.org>
 <1420630138-31443-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

It makes no sense to hide the __iomem annotation from the function
that uses it, especially since it causes a sparse warning:

drivers/clocksource/bcm_kona_timer.c:118:38: warning: incorrect type in argument 1 (different address spaces)
drivers/clocksource/bcm_kona_timer.c:118:38:    expected void *timer_base
drivers/clocksource/bcm_kona_timer.c:118:38:    got void [noderef] <asn:2>*static [toplevel] tmr_regs

Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/bcm_kona_timer.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/clocksource/bcm_kona_timer.c b/drivers/clocksource/bcm_kona_timer.c
index 0595dc6..f1e33d0 100644
--- a/drivers/clocksource/bcm_kona_timer.c
+++ b/drivers/clocksource/bcm_kona_timer.c
@@ -68,9 +68,8 @@ static void kona_timer_disable_and_clear(void __iomem *base)
 }
 
 static void
-kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
+kona_timer_get_counter(void __iomem *timer_base, uint32_t *msw, uint32_t *lsw)
 {
-	void __iomem *base = IOMEM(timer_base);
 	int loop_limit = 4;
 
 	/*
@@ -86,9 +85,9 @@ kona_timer_get_counter(void *timer_base, uint32_t *msw, uint32_t *lsw)
 	 */
 
 	while (--loop_limit) {
-		*msw = readl(base + KONA_GPTIMER_STCHI_OFFSET);
-		*lsw = readl(base + KONA_GPTIMER_STCLO_OFFSET);
-		if (*msw == readl(base + KONA_GPTIMER_STCHI_OFFSET))
+		*msw = readl(timer_base + KONA_GPTIMER_STCHI_OFFSET);
+		*lsw = readl(timer_base + KONA_GPTIMER_STCLO_OFFSET);
+		if (*msw == readl(timer_base + KONA_GPTIMER_STCHI_OFFSET))
 			break;
 	}
 	if (!loop_limit) {
-- 
1.9.1

