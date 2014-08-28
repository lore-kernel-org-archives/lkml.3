Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297AbaH1JDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:03:25 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:39012 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936523AbaH1JDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:03:16 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] pwm: Fix uninitialized warnings in pwm_get()
Date: Thu, 28 Aug 2014 11:03:14 +0200
Message-Id: <1409216594-31389-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With some versions of gcc (e.g. 4.1.2):

drivers/pwm/core.c: In function ‘pwm_get’:
drivers/pwm/core.c:610: warning: ‘polarity’ may be used uninitialized in this function
drivers/pwm/core.c:609: warning: ‘period’ may be used uninitialized in this function

While these are false positives, we can get rid of them by refactoring
the code to store a pointer to the best match, as suggested before by
Thierry Reding. This does require moving the mutex_unlock() down.

Fixes: d717ea73e36dd565 ("pwm: Fix period and polarity in pwm_get() for non-perfect matches")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/pwm/core.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 8c748b17f416..966497d10c6e 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -602,12 +602,9 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 	struct pwm_device *pwm = ERR_PTR(-EPROBE_DEFER);
 	const char *dev_id = dev ? dev_name(dev) : NULL;
 	struct pwm_chip *chip = NULL;
-	unsigned int index = 0;
 	unsigned int best = 0;
-	struct pwm_lookup *p;
+	struct pwm_lookup *p, *chosen = NULL;
 	unsigned int match;
-	unsigned int period;
-	enum pwm_polarity polarity;
 
 	/* look up via DT first */
 	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
@@ -653,10 +650,7 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 		}
 
 		if (match > best) {
-			chip = pwmchip_find_by_name(p->provider);
-			index = p->index;
-			period = p->period;
-			polarity = p->polarity;
+			chosen = p;
 
 			if (match != 3)
 				best = match;
@@ -665,17 +659,22 @@ struct pwm_device *pwm_get(struct device *dev, const char *con_id)
 		}
 	}
 
-	mutex_unlock(&pwm_lookup_lock);
+	if (!chosen)
+		goto out;
 
-	if (chip)
-		pwm = pwm_request_from_chip(chip, index, con_id ?: dev_id);
-	if (IS_ERR(pwm))
-		return pwm;
+	chip = pwmchip_find_by_name(chosen->provider);
+	if (!chip)
+		goto out;
 
-	pwm_set_period(pwm, period);
-	pwm_set_polarity(pwm, polarity);
+	pwm = pwm_request_from_chip(chip, chosen->index, con_id ?: dev_id);
+	if (IS_ERR(pwm))
+		goto out;
 
+	pwm_set_period(pwm, chosen->period);
+	pwm_set_polarity(pwm, chosen->polarity);
 
+out:
+	mutex_unlock(&pwm_lookup_lock);
 	return pwm;
 }
 EXPORT_SYMBOL_GPL(pwm_get);
-- 
1.9.1

