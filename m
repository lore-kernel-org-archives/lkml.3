Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaJTQ07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:26:59 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46274 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaJTQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:25:54 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: rjw@rjwysocki.net
Cc: peterz@infradead.org, nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 4/5] cpuidle: menu: Fix the get_typical_interval
Date: Mon, 20 Oct 2014 18:25:42 +0200
Message-Id: <1413822343-1972-4-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>
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
deviation for these unexisting values. Just return without setting the
'data->predicted_us' to zero.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/governors/menu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 3907301..6ae8390 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -226,6 +226,15 @@ again:
 	else
 		do_div(avg, divisor);
 
+	/*
+	 * We are at the very beginning and no data have been filled
+	 * yet. Let's skip the standard deviation computation
+	 * otherwise the data->predicted_us will be zero and that will
+	 * lead to a zero latency req in the select function
+	 */
+	if (!avg)
+		return;
+
 	/* Then try to determine standard deviation */
 	stddev = 0;
 	for (i = 0; i < INTERVALS; i++) {
-- 
1.9.1

