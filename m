Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760074Ab3HNQUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:20:19 -0400
Received: from mx.mmd.net ([80.83.0.3]:57315 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760023Ab3HNQRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:17:42 -0400
From: tuukka.tikkanen@linaro.org
To: rjw@sisk.pl, daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Cc: private-pmwg@linaro.org, linux-kernel@vger.kernel.org,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Subject: [PATCH 6/8] Cpuidle: Fix variable domains in get_typical_interval()
Date: Wed, 14 Aug 2013 19:02:39 +0300
Message-Id: <c4145504e535ac343251cc7690807eee2005af28.1376493949.git.tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
References: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
In-Reply-To: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
References: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>

The menu governor uses a static function get_typical_interval() to
try to detect a repeating pattern of wakeups. The previous interval
durations are stored as an array of unsigned ints, but the arithmetic
in the function is performed exclusively as 64 bit values, even when
the value stored in a variable is known not to exceed unsigned int,
which may be smaller and more efficient on some platforms.

This patch changes the types of varibles used to store some
intermediates, the maximum and and the cutoff threshold to unsigned
ints. Average and standard deviation are still treated as 64 bit values,
even when the values are known to be within the domain of unsigned int,
to avoid casts to ensure correct integer promotion for arithmetic
operations.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 0b37ee4..96fd10d 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -200,18 +200,19 @@ static u64 div_round64(u64 dividend, u32 divisor)
 static void get_typical_interval(struct menu_device *data)
 {
 	int i, divisor;
-	uint64_t max, avg, stddev;
-	int64_t thresh = LLONG_MAX; /* Discard outliers above this value. */
+	unsigned int max, thresh;
+	uint64_t avg, stddev;
+
+	thresh = ULONG_MAX; /* Discard outliers above this value */
 
 again:
 
-	/* first calculate average and standard deviation of the past */
+	/* First calculate the average of past intervals */
 	max = 0;
 	avg = 0;
 	divisor = 0;
-	stddev = 0;
 	for (i = 0; i < INTERVALS; i++) {
-		int64_t value = data->intervals[i];
+		unsigned int value = data->intervals[i];
 		if (value <= thresh) {
 			avg += value;
 			divisor++;
@@ -221,8 +222,10 @@ again:
 	}
 	do_div(avg, divisor);
 
+	/* Then try to determine standard deviation */
+	stddev = 0;
 	for (i = 0; i < INTERVALS; i++) {
-		int64_t value = data->intervals[i];
+		unsigned int value = data->intervals[i];
 		if (value <= thresh) {
 			int64_t diff = value - avg;
 			stddev += diff * diff;
-- 
1.7.9.5

