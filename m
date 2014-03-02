Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaCBLh6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 06:37:58 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:51695 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaCBLh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 06:37:57 -0500
From: Felix Rueegg <felix.rueegg@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Rueegg <felix.rueegg@gmail.com>
Subject: [PATCH] input: ff-memless: don't schedule already playing effect to play again
Date: Sun,  2 Mar 2014 12:35:43 +0100
Message-Id: <1393760143-5986-1-git-send-email-felix.rueegg@gmail.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an effect with zero replay length, zero replay delay
and zero envelope attack length is uploaded, it is played and then scheduled to play
again one timer tick later. This triggers a warning (URB submitted while
active) in combination with the xpad driver.

Skipping the rescheduling of this effect fixes the issue.

Signed-off-by: Felix Rueegg <felix.rueegg@gmail.com>
---
 drivers/input/ff-memless.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/input/ff-memless.c b/drivers/input/ff-memless.c
index 74c0d8c..2e06948 100644
--- a/drivers/input/ff-memless.c
+++ b/drivers/input/ff-memless.c
@@ -139,10 +139,13 @@ static void ml_schedule_timer(struct ml_device *ml)
 		if (!test_bit(FF_EFFECT_STARTED, &state->flags))
 			continue;
 
-		if (test_bit(FF_EFFECT_PLAYING, &state->flags))
+		if (test_bit(FF_EFFECT_PLAYING, &state->flags)) {
 			next_at = calculate_next_time(state);
-		else
+			if (next_at == now)
+				continue;
+		} else {
 			next_at = state->play_at;
+		}
 
 		if (time_before_eq(now, next_at) &&
 		    (++events == 1 || time_before(next_at, earliest)))
-- 
1.9.0

