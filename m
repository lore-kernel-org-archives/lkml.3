Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaHMPTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 11:19:24 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:57627 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaHMPTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 11:19:22 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        linux-pwm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>, stable@vger.kernel.org
Subject: [PATCH] pwm: Fix period and polarity in pwm_get() for non-perfect matches
Date: Wed, 13 Aug 2014 17:18:53 +0200
Message-Id: <1407943133-18170-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pwm_get() finds a look-up entry with a perfect match (both dev_id and
con_id match), the loop is aborted, and "p" still points to the correct
struct pwm_lookup.

If only an entry with a matching dev_id or con_id is found, the loop
terminates after traversing the whole list, and "p" now points to
arbitrary memory, not part of the pwm_lookup list.
Then pwm_set_period() and pwm_set_polarity() will set random values for
period resp. polarity.

To fix this, save period and polarity when finding a new best match,
just like is done for chip (for the provider) and index.

This fixes the LCD backlight on r8a7740/armadillo-legacy, which was fed
period 0 and polarity -1068821144 instead of 33333 resp. 1.

Fixes: 3796ce1d4d4b330a75005c5eda105603ce9d4071 ("pwm: add period and polarity to struct pwm_lookup")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
---
 drivers/pwm/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 4b66bf09ee55..d2c35920ff08 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -606,6 +606,8 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 	unsigned int best = 0;
 	struct pwm_lookup *p;
 	unsigned int match;
+	unsigned int period;
+	enum pwm_polarity polarity;
 
 	/* look up via DT first */
 	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
@@ -653,6 +655,8 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 		if (match > best) {
 			chip = pwmchip_find_by_name(p->provider);
 			index = p->index;
+			period = p->period;
+			polarity = p->polarity;
 
 			if (match != 3)
 				best = match;
@@ -668,8 +672,8 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 	if (IS_ERR(pwm))
 		return pwm;
 
-	pwm_set_period(pwm, p->period);
-	pwm_set_polarity(pwm, p->polarity);
+	pwm_set_period(pwm, period);
+	pwm_set_polarity(pwm, polarity);
 
 
 	return pwm;
-- 
1.9.1

