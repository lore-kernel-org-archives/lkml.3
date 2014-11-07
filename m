Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaKGObu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:31:50 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38343 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbaKGObq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:31:46 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, lenb@kernel.org
Subject: [PATCH V3 5/6] cpuidle: menu: Fix the get_typical_interval
Date: Fri,  7 Nov 2014 15:31:26 +0100
Message-Id: <1415370687-18688-6-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first time the 'get_typical_function' is called, it computes an average
of zero as no data is filled yet. That leads the 'data->predicted_us' variable
to be set to zero too.

The caller, 'menu_select' will then do:

	interactivity_req = data->predicted_us /
			performance_multiplier(nr_iowaiters, cpu_load);

That sets the interactivity_req to zero (0/performance...).

and then

	if (latency_req > interactivity_req)
		latency_req = interactivity_req;

... setting 'latency_req' to zero too.

No idle state will fulfill this constraint and we will go the C1 state as
default and leading to an update. So the next calls will compute an average
different from zero.

Even if that works with the current code but with a broken semantic, it will
just break with the next patches where we are stricter with the latencies
check: the first check will fail (latency_req is zero), then no update will
occur leading to always falling to choose an idle state.

As there are no previous values and it is pointless to compute a standard
deviation for these unexisting values.

Change the function to return the computed value and use it only if it is
different from zero and greater than the next timer expiration.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/governors/menu.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 2e4a315..163e63b 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -198,7 +198,7 @@ static u64 div_round64(u64 dividend, u32 divisor)
  * of points is below a threshold. If it is... then use the
  * average of these 8 points as the estimated value.
  */
-static void get_typical_interval(struct menu_device *data)
+static unsigned int get_typical_interval(struct menu_device *data)
 {
 	int i, divisor;
 	unsigned int max, thresh;
@@ -255,11 +255,8 @@ again:
 	if (likely(stddev <= ULONG_MAX)) {
 		stddev = int_sqrt(stddev);
 		if (((avg > stddev * 6) && (divisor * 4 >= INTERVALS * 3))
-							|| stddev <= 20) {
-			if (data->next_timer_us > avg)
-				data->predicted_us = avg;
-			return;
-		}
+							|| stddev <= 20)
+			return avg;
 	}
 
 	/*
@@ -272,7 +269,7 @@ again:
 	 * with sporadic activity with a bunch of short pauses.
 	 */
 	if ((divisor * 4) <= INTERVALS * 3)
-		return;
+		return 0;
 
 	thresh = max - 1;
 	goto again;
@@ -289,6 +286,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	struct menu_device *data = this_cpu_ptr(&menu_devices);
 	int i;
 	unsigned int interactivity_req;
+	unsigned int interactivity_overrride_us;
 	unsigned long nr_iowaiters, cpu_load;
 
 	if (data->needs_update) {
@@ -313,7 +311,10 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 					 data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
-	get_typical_interval(data);
+	interactivity_overrride_us = get_typical_interval(data);
+	if (interactivity_overrride_us &&
+	    data->next_timer_us > interactivity_overrride_us)
+		data->predicted_us = interactivity_overrride_us;
 
 	/*
 	 * Performance multiplier defines a minimum predicted idle
-- 
1.9.1

