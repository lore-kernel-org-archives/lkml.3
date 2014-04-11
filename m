Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaDKCyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:54:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42083 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaDKCyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:54:53 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH] PM / devfreq: Use freq_table for available_frequencies
Date: Thu, 10 Apr 2014 19:54:41 -0700
Message-Id: <1397184881-12223-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices use freq_table instead of OPP. For those devices, the
available_frequencies file shows up empty. Fix that by using freq_table to
generate the available_frequencies data when OPP is not present.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/devfreq/devfreq.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 2042ec3..a715d15 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -912,19 +912,26 @@ static ssize_t available_frequencies_show(struct device *d,
 	struct devfreq *df = to_devfreq(d);
 	struct device *dev = df->dev.parent;
 	struct dev_pm_opp *opp;
+	unsigned int i = 0, max_state = df->profile->max_state;
+	bool use_opp;
 	ssize_t count = 0;
 	unsigned long freq = 0;
 
 	rcu_read_lock();
+	use_opp = dev_pm_opp_get_opp_count(dev) > 0;
 	do {
-		opp = dev_pm_opp_find_freq_ceil(dev, &freq);
-		if (IS_ERR(opp))
-			break;
+		if (use_opp) {
+			opp = dev_pm_opp_find_freq_ceil(dev, &freq);
+			if (IS_ERR(opp))
+				break;
+		} else {
+			freq = df->profile->freq_table[i++];
+		}
 
 		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
 				   "%lu ", freq);
 		freq++;
-	} while (1);
+	} while (use_opp || (!use_opp && i < max_state));
 	rcu_read_unlock();
 
 	/* Truncate the trailing space */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
