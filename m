Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbaJDAo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:44:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbaJCVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 3.16 033/357] pwm: Fix period and polarity in pwm_get() for non-perfect matches
Date: Fri,  3 Oct 2014 14:26:59 -0700
Message-Id: <20141003212934.464999120@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit d717ea73e36dd5659640fae82605ad85c4117f4d upstream.

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

Fixes: 3796ce1d4d4b ("pwm: add period and polarity to struct pwm_lookup")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pwm/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -606,6 +606,8 @@ struct pwm_device *pwm_get(struct device
 	unsigned int best = 0;
 	struct pwm_lookup *p;
 	unsigned int match;
+	unsigned int period;
+	enum pwm_polarity polarity;
 
 	/* look up via DT first */
 	if (IS_ENABLED(CONFIG_OF) && dev && dev->of_node)
@@ -653,6 +655,8 @@ struct pwm_device *pwm_get(struct device
 		if (match > best) {
 			chip = pwmchip_find_by_name(p->provider);
 			index = p->index;
+			period = p->period;
+			polarity = p->polarity;
 
 			if (match != 3)
 				best = match;
@@ -668,8 +672,8 @@ struct pwm_device *pwm_get(struct device
 	if (IS_ERR(pwm))
 		return pwm;
 
-	pwm_set_period(pwm, p->period);
-	pwm_set_polarity(pwm, p->polarity);
+	pwm_set_period(pwm, period);
+	pwm_set_polarity(pwm, polarity);
 
 
 	return pwm;


