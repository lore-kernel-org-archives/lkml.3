Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaJ1Qn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:43:29 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37415 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ1Qn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:43:27 -0400
Date: Tue, 28 Oct 2014 09:43:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: max77693-haptic - fix potential overflow
Message-ID: <20141028164322.GA13234@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expression haptic->pwm_dev->period * haptic->magnitude is of type 'unsigned
int' and may overflow. We need to convert one of the operands to u64 before
multiplying, instead of casting result (potentially overflown) to u64.

Reported by Coverity: CID 1248753

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/max77693-haptic.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/input/misc/max77693-haptic.c b/drivers/input/misc/max77693-haptic.c
index 7b1fde9..ef6a9d6 100644
--- a/drivers/input/misc/max77693-haptic.c
+++ b/drivers/input/misc/max77693-haptic.c
@@ -194,7 +194,7 @@ static int max77693_haptic_play_effect(struct input_dev *dev, void *data,
 				       struct ff_effect *effect)
 {
 	struct max77693_haptic *haptic = input_get_drvdata(dev);
-	uint64_t period_mag_multi;
+	u64 period_mag_multi;
 
 	haptic->magnitude = effect->u.rumble.strong_magnitude;
 	if (!haptic->magnitude)
@@ -205,8 +205,7 @@ static int max77693_haptic_play_effect(struct input_dev *dev, void *data,
 	 * The formula to convert magnitude to pwm_duty as follows:
 	 * - pwm_duty = (magnitude * pwm_period) / MAX_MAGNITUDE(0xFFFF)
 	 */
-	period_mag_multi = (int64_t)(haptic->pwm_dev->period *
-						haptic->magnitude);
+	period_mag_multi = (u64)haptic->pwm_dev->period * haptic->magnitude;
 	haptic->pwm_duty = (unsigned int)(period_mag_multi >>
 						MAX_MAGNITUDE_SHIFT);
 
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
