Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaHRNKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:10:42 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:34600 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaHRNKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:10:41 -0400
From: Guodong Xu <guodong.xu@linaro.org>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, broonie@kernel.org, grant.likely@linaro.org,
        khilman@linaro.org, haojian.zhuang@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, axel.lin@ingics.com,
        zhangnian@huawei.com
Cc: Guodong Xu <guodong.xu@linaro.org>
Subject: [PATCH v6 2/6] regulator: core: factor out delay function from _regulator_do_enable
Date: Mon, 18 Aug 2014 21:09:12 +0800
Message-Id: <1408367356-2628-3-git-send-email-guodong.xu@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408367356-2628-1-git-send-email-guodong.xu@linaro.org>
References: <1408367356-2628-1-git-send-email-guodong.xu@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common delay function can be helpful when implementing new features. Factor
it out to maximize code reusability.

Signed-off-by: Guodong Xu <guodong.xu@linaro.org>
---
 drivers/regulator/core.c | 74 ++++++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 34 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index c4a13db..4976451 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1759,6 +1759,45 @@ static int regulator_ena_gpio_ctrl(struct regulator_dev *rdev, bool enable)
 	return 0;
 }
 
+/**
+ * _regulator_enable_delay - a delay helper function
+ * @delay: time to delay in microseconds
+ *
+ * Delay for the requested amount of time as per the guidelines in:
+ *
+ *     Documentation/timers/timers-howto.txt
+ *
+ * The assumption here is that regulators will never be enabled in
+ * atomic context and therefore sleeping functions can be used.
+ */
+static void _regulator_enable_delay(unsigned int delay)
+{
+	unsigned int ms = delay / 1000;
+	unsigned int us = delay % 1000;
+
+	if (ms > 0) {
+		/*
+		 * For small enough values, handle super-millisecond
+		 * delays in the usleep_range() call below.
+		 */
+		if (ms < 20)
+			us += ms * 1000;
+		else
+			msleep(ms);
+	}
+
+	/*
+	 * Give the scheduler some room to coalesce with any other
+	 * wakeup sources. For delays shorter than 10 us, don't even
+	 * bother setting up high-resolution timers and just busy-
+	 * loop.
+	 */
+	if (us >= 10)
+		usleep_range(us, us + 100);
+	else
+		udelay(us);
+}
+
 static int _regulator_do_enable(struct regulator_dev *rdev)
 {
 	int ret, delay;
@@ -1792,40 +1831,7 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	 * together.  */
 	trace_regulator_enable_delay(rdev_get_name(rdev));
 
-	/*
-	 * Delay for the requested amount of time as per the guidelines in:
-	 *
-	 *     Documentation/timers/timers-howto.txt
-	 *
-	 * The assumption here is that regulators will never be enabled in
-	 * atomic context and therefore sleeping functions can be used.
-	 */
-	if (delay) {
-		unsigned int ms = delay / 1000;
-		unsigned int us = delay % 1000;
-
-		if (ms > 0) {
-			/*
-			 * For small enough values, handle super-millisecond
-			 * delays in the usleep_range() call below.
-			 */
-			if (ms < 20)
-				us += ms * 1000;
-			else
-				msleep(ms);
-		}
-
-		/*
-		 * Give the scheduler some room to coalesce with any other
-		 * wakeup sources. For delays shorter than 10 us, don't even
-		 * bother setting up high-resolution timers and just busy-
-		 * loop.
-		 */
-		if (us >= 10)
-			usleep_range(us, us + 100);
-		else
-			udelay(us);
-	}
+	_regulator_enable_delay(delay);
 
 	trace_regulator_enable_complete(rdev_get_name(rdev));
 
-- 
1.9.1

