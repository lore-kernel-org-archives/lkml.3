Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaBXHPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 02:15:16 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57405 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaBXHPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 02:15:12 -0500
From: Saravana Kannan <skannan@codeaurora.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH] PM / devfreq: Fix out of bounds access of transition table array
Date: Sun, 23 Feb 2014 23:15:00 -0800
Message-Id: <1393226100-18428-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous_freq value for a device could be an invalid frequency that
results in a error value being returned from devfreq_get_freq_level().
Check for an error value before using that to index into the transition
table.

Not doing this check will result in memory corruption when previous_freq is
not a valid frequency.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/devfreq/devfreq.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index a0b2f7e..f91ea29 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -101,14 +101,20 @@ static int devfreq_update_status(struct devfreq *devfreq, unsigned long freq)
 	cur_time = jiffies;
 	devfreq->time_in_state[lev] +=
 			 cur_time - devfreq->last_stat_updated;
-	if (freq != devfreq->previous_freq) {
-		prev_lev = devfreq_get_freq_level(devfreq,
-						devfreq->previous_freq);
+	devfreq->last_stat_updated = cur_time;
+
+	if (freq == devfreq->previous_freq)
+		return 0;
+
+	prev_lev = devfreq_get_freq_level(devfreq, devfreq->previous_freq);
+	if (prev_lev < 0)
+		return 0;
+
+	if (lev != prev_lev) {
 		devfreq->trans_table[(prev_lev *
 				devfreq->profile->max_state) + lev]++;
 		devfreq->total_trans++;
 	}
-	devfreq->last_stat_updated = cur_time;
 
 	return 0;
 }
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
