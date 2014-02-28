Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaB1DjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:39:09 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42096 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaB1DjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:39:07 -0500
From: Saravana Kannan <skannan@codeaurora.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH] PM / devfreq: Rewrite devfreq_update_status() to fix multiple bugs
Date: Thu, 27 Feb 2014 19:38:57 -0800
Message-Id: <1393558737-24037-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current devfreq_update_status() has the following bugs:
- If previous frequency doesn't have a valid level, it does an out of bounds
  access into the trans_table and causes memory corruption.
- When the new frequency doesn't have a valid level, the time spent in the
  new frequency is counted towards the next valid frequency switch instead of
  being ignored.
- The time spent on the previous frequency is added to the new frequency's
  stats instead of the previous frequency's stats.

This patch fixes all of this.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/devfreq/devfreq.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index a0b2f7e..2042ec3 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -91,26 +91,35 @@ static int devfreq_get_freq_level(struct devfreq *devfreq, unsigned long freq)
  */
 static int devfreq_update_status(struct devfreq *devfreq, unsigned long freq)
 {
-	int lev, prev_lev;
+	int lev, prev_lev, ret = 0;
 	unsigned long cur_time;
 
-	lev = devfreq_get_freq_level(devfreq, freq);
-	if (lev < 0)
-		return lev;
-
 	cur_time = jiffies;
-	devfreq->time_in_state[lev] +=
+
+	prev_lev = devfreq_get_freq_level(devfreq, devfreq->previous_freq);
+	if (prev_lev < 0) {
+		ret = prev_lev;
+		goto out;
+	}
+
+	devfreq->time_in_state[prev_lev] +=
 			 cur_time - devfreq->last_stat_updated;
-	if (freq != devfreq->previous_freq) {
-		prev_lev = devfreq_get_freq_level(devfreq,
-						devfreq->previous_freq);
+
+	lev = devfreq_get_freq_level(devfreq, freq);
+	if (lev < 0) {
+		ret = lev;
+		goto out;
+	}
+
+	if (lev != prev_lev) {
 		devfreq->trans_table[(prev_lev *
 				devfreq->profile->max_state) + lev]++;
 		devfreq->total_trans++;
 	}
-	devfreq->last_stat_updated = cur_time;
 
-	return 0;
+out:
+	devfreq->last_stat_updated = cur_time;
+	return ret;
 }
 
 /**
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

