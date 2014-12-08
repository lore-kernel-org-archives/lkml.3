Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaLHVjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 16:39:45 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50104 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaLHVjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 16:39:43 -0500
From: Olof Johansson <olof@lixom.net>
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] clocksource: kona: fix __iomem annotation
Date: Mon,  8 Dec 2014 13:42:02 -0800
Message-Id: <1418074922-671-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It makes no sense to hide the __iomem annotation from the function
that uses it, especially since it causes a sparse warning:

drivers/clocksource/bcm_kona_timer.c:118:38: warning: incorrect type in argument 1 (different address spaces)
drivers/clocksource/bcm_kona_timer.c:118:38:    expected void *timer_base
drivers/clocksource/bcm_kona_timer.c:118:38:    got void [noderef] <asn:2>*static [toplevel] tmr_regs

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/clocksource/bcm_kona_timer.c |    9 ++++-----
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
1.7.10.4

