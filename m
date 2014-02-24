Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaBXINK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:13:10 -0500
Received: from mx.mmd.net ([80.83.0.3]:55413 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752846AbaBXIND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:13:03 -0500
From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
To: linux-pm@vger.kernel.org, rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, tuukka.tikkanen@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] Cpuidle: Ensure menu coefficients stay within domain
Date: Mon, 24 Feb 2014 08:29:33 +0200
Message-Id: <1393223377-5744-4-git-send-email-tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
References: <1393223377-5744-1-git-send-email-tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The menu governor uses coefficients as one method of actual idle
period length estimation. The coefficients are, as detailed below,
multipliers giving expected idle period length from time until next
timer expiry. The multipliers are supposed to have domain of (0..1].

The coefficients are fractions where only the numerators are stored
and denominators are a shared constant RESOLUTION*DECAY. Since the
value of the coefficient should always be greater than 0 and less
than or equal to 1, the numerator must have a value greater than
0 and less than or equal to RESOLUTION*DECAY.

If the coefficients are updated with measured idle durations exceeding
timer length, the multiplier may reach values exceeding unity (i.e.
the stored numerator exceeds RESOLUTION*DECAY). This patch ensures that
the multipliers are updated with durations capped to timer length.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 115386a..f0995dd 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -410,6 +410,9 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	if (measured_us > target->exit_latency)
 		measured_us -= target->exit_latency;
 
+	/* Make sure our coefficients do not exceed unity */
+	if (measured_us > data->next_timer_us)
+		measured_us = data->next_timer_us;
 
 	/* Update our correction ratio */
 	new_factor = data->correction_factor[data->bucket];
-- 
1.7.9.5

