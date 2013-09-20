Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab3ITLxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:53:13 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:49052 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab3ITLxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:53:12 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: core: Reduce busy-wait looping
Date: Fri, 20 Sep 2013 13:51:56 +0200
Message-Id: <1379677916-3857-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep busy-wait looping to a minimum while waiting for a regulator to
ramp-up to the target voltage. This follows the guidelines set forth
in Documentation/timers/timers-howto.txt and assumes that regulators
are never enabled in atomic context.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/regulator/core.c | 38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4eefcc3..4e18884 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1566,11 +1566,39 @@ static int _regulator_do_enable(struct regulator_dev *rdev)
 	 * together.  */
 	trace_regulator_enable_delay(rdev_get_name(rdev));
 
-	if (delay >= 1000) {
-		mdelay(delay / 1000);
-		udelay(delay % 1000);
-	} else if (delay) {
-		udelay(delay);
+	/*
+	 * Delay for the requested amount of time as per the guidelines in:
+	 *
+	 *     Documentation/timers/timers-howto.txt
+	 *
+	 * The assumption here is that regulators will never be enabled in
+	 * atomic context and therefore sleeping functions can be used.
+	 */
+	if (delay) {
+		unsigned int ms = delay / 1000;
+		unsigned int us = delay % 1000;
+
+		if (ms > 0) {
+			/*
+			 * For small enough values, handle super-millisecond
+			 * delays in the usleep_range() call below.
+			 */
+			if (ms < 20)
+				us += ms * 1000;
+			else
+				msleep(ms);
+		}
+
+		/*
+		 * Give the scheduler some room to coalesce with any other
+		 * wakeup sources. For delays shorter than 10 us, don't even
+		 * bother setting up high-resolution timers and just busy-
+		 * loop.
+		 */
+		if (us >= 10)
+			usleep_range(us, us + 100);
+		else
+			udelay(us);
 	}
 
 	trace_regulator_enable_complete(rdev_get_name(rdev));
-- 
1.8.4

