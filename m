Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab3HNQRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:17:45 -0400
Received: from mx.mmd.net ([80.83.0.3]:57313 "EHLO mx.mmd.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759998Ab3HNQRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:17:42 -0400
From: tuukka.tikkanen@linaro.org
To: rjw@sisk.pl, daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Cc: private-pmwg@linaro.org, linux-kernel@vger.kernel.org,
        Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
Subject: [PATCH 3/8] Cpuidle: Check called function parameter in get_typical_interval()
Date: Wed, 14 Aug 2013 19:02:36 +0300
Message-Id: <7b413e8d6d840209125042fc4a534e779d92bc31.1376493949.git.tuukka.tikkanen@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
References: <cover.1376487596.git.tuukka.tikkanen@linaro.org>
In-Reply-To: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
References: <cover.1376493949.git.tuukka.tikkanen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>

get_typical_interval() uses int_sqrt() in calculation of standard
deviation. The formal parameter of int_sqrt() is unsigned long, which
may on some platforms be smaller than the 64 bit unsigned integer used
as the actual parameter. The overflow can occur frequently when actual
idle period lengths are in hundreds of milliseconds.

This patch adds a check for such overflow and rejects the candidate
average when an overflow would occur.

Signed-off-by: Tuukka Tikkanen <tuukka.tikkanen@linaro.org>
---
 drivers/cpuidle/governors/menu.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index b13d57c..c24b10b 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -226,18 +226,26 @@ again:
 		}
 	}
 	do_div(stddev, divisor);
-	stddev = int_sqrt(stddev);
 	/*
 	 * The typical interval is obtained when standard deviation is small
 	 * or standard deviation is small compared to the average interval.
 	 *
+	 * int_sqrt() formal parameter type is unsigned long. When the
+	 * greatest difference to an outlier exceeds ~65 ms * sqrt(divisor)
+	 * the resulting squared standard deviation exceeds the input domain
+	 * of int_sqrt on platforms where unsigned long is 32 bits in size.
+	 * In such case reject the candidate average.
+	 *
 	 * Use this result only if there is no timer to wake us up sooner.
 	 */
-	if (((avg > stddev * 6) && (divisor * 4 >= INTERVALS * 3))
+	if (likely(stddev <= ULONG_MAX)) {
+		stddev = int_sqrt(stddev);
+		if (((avg > stddev * 6) && (divisor * 4 >= INTERVALS * 3))
 							|| stddev <= 20) {
-		if (data->expected_us > avg)
-			data->predicted_us = avg;
-		return;
+			if (data->expected_us > avg)
+				data->predicted_us = avg;
+			return;
+		}
 	}
 
 	/*
-- 
1.7.9.5

