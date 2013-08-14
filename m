Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab3HNQT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:19:58 -0400
Received: from mx.mmd.net ([80.83.0.3]:57312 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759993Ab3HNQRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:17:43 -0400
From: tuukka.tikkanen@linaro.org
To: rjw@sisk.pl, daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Cc: private-pmwg@linaro.org, linux-kernel@vger.kernel.org,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Subject: [PATCH 8/8] Cpuidle: Change struct menu_device field types
Date: Wed, 14 Aug 2013 19:02:41 +0300
Message-Id: <2bd993782a293bcf8738dcd7bc1c943b5615828c.1376493949.git.tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
References: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
In-Reply-To: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
References: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>

Field predicted_us value can never exceed expected_us value, but it has
a potentially larger type. As there is no need for additional 32 bits of
zeroes on 32 bit plaforms, change the type of predicted_us to match the
type of expected_us.

Field correction_factor is used to store a value that cannot exceed the
product of RESOLUTION and DECAY (default 1024*8 = 8192). The constants
cannot in practice be incremented to such values, that they'd overflow
unsigned int even on 32 bit systems, so the type is changed to avoid
unnecessary 64 bit arithmetic on 32 bit systems.

One multiplication of (now) 32 bit values needs an added cast to avoid
truncation of the result and has been added.

In order to avoid another multiplication from 32 bit domain to 64 bit
domain, the new correction_factor calculation has been changed from
new = old * (DECAY-1) / DECAY
to
new = old - old / DECAY,
which with infinite precision would yeild exactly the same result, but
now changes the direction of rounding. The impact is not significant as
the maximum accumulated difference cannot exceed the value of DECAY,
which is relatively small compared to product of RESOLUTION and DECAY
(8 / 8192).

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |   28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index f277c13..cbd9b6c 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -123,10 +123,10 @@ struct menu_device {
 	int             needs_update;
 
 	unsigned int	expected_us;
-	u64		predicted_us;
+	unsigned int	predicted_us;
 	unsigned int	exit_us;
 	unsigned int	bucket;
-	u64		correction_factor[BUCKETS];
+	unsigned int	correction_factor[BUCKETS];
 	unsigned int	intervals[INTERVALS];
 	int		interval_ptr;
 };
@@ -321,8 +321,13 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	if (data->correction_factor[data->bucket] == 0)
 		data->correction_factor[data->bucket] = RESOLUTION * DECAY;
 
-	/* Make sure to round up for half microseconds */
-	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
+	/*
+	 * Force the result of multiplication to be 64 bits even if both
+	 * operands are 32 bits.
+	 * Make sure to round up for half microseconds.
+	 */
+	data->predicted_us = div_round64((uint64_t)data->expected_us *
+					 data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
 	get_typical_interval(data);
@@ -388,7 +393,7 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 	unsigned int last_idle_us = cpuidle_get_last_residency(dev);
 	struct cpuidle_state *target = &drv->states[last_idx];
 	unsigned int measured_us;
-	u64 new_factor;
+	unsigned int new_factor;
 
 	/*
 	 * Ugh, this idle state doesn't support residency measurements, so we
@@ -409,10 +414,9 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		measured_us -= data->exit_us;
 
 
-	/* update our correction ratio */
-
-	new_factor = data->correction_factor[data->bucket]
-			* (DECAY - 1) / DECAY;
+	/* Update our correction ratio */
+	new_factor = data->correction_factor[data->bucket];
+	new_factor -= new_factor / DECAY;
 
 	if (data->expected_us > 0 && measured_us < MAX_INTERESTING)
 		new_factor += RESOLUTION * measured_us / data->expected_us;
@@ -425,9 +429,11 @@ static void menu_update(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 
 	/*
 	 * We don't want 0 as factor; we always want at least
-	 * a tiny bit of estimated time.
+	 * a tiny bit of estimated time. Fortunately, due to rounding,
+	 * new_factor will stay nonzero regardless of measured_us values
+	 * and the compiler can eliminate this test as long as DECAY > 1.
 	 */
-	if (new_factor == 0)
+	if (DECAY == 1 && unlikely(new_factor == 0))
 		new_factor = 1;
 
 	data->correction_factor[data->bucket] = new_factor;
-- 
1.7.9.5

