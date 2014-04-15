Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbaDOTaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 15:30:11 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48888 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaDOTaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 15:30:06 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH v2] PM / devfreq: Use freq_table for available_frequencies
Date: Tue, 15 Apr 2014 12:29:58 -0700
Message-Id: <1397590198-4965-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368716.232331397543409452.JavaMail.weblogic@epv6ml06>
References: <1368716.232331397543409452.JavaMail.weblogic@epv6ml06>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices use freq_table instead of OPP. For those devices, the
available_frequencies file shows up empty. Fix that by using freq_table to
generate the available_frequencies data when it's available.

OPP find frequency APIs also skips frequencies that have been temporarily
disabled (say, due to thermal, etc). Since available_frequencies is
supposed to show the entire list of available frequencies without taking
temporary limits into consideration, preference is given to freq_table when
available.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/devfreq/devfreq.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 2042ec3..527cbe2 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -912,20 +912,27 @@ static ssize_t available_frequencies_show(struct device *d,
 	struct devfreq *df = to_devfreq(d);
 	struct device *dev = df->dev.parent;
 	struct dev_pm_opp *opp;
+	unsigned int i = 0;
 	ssize_t count = 0;
 	unsigned long freq = 0;
 
-	rcu_read_lock();
-	do {
-		opp = dev_pm_opp_find_freq_ceil(dev, &freq);
-		if (IS_ERR(opp))
-			break;
-
-		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
-				   "%lu ", freq);
-		freq++;
-	} while (1);
-	rcu_read_unlock();
+	if (df->profile->freq_table) {
+		for (i = 0; i < df->profile->max_state; i++)
+			count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
+					   "%u ", df->profile->freq_table[i]);
+	} else {
+		rcu_read_lock();
+		do {
+			opp = dev_pm_opp_find_freq_ceil(dev, &freq);
+			if (IS_ERR(opp))
+				break;
+
+			count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
+					   "%lu ", freq);
+			freq++;
+		} while (1);
+		rcu_read_unlock();
+	}
 
 	/* Truncate the trailing space */
 	if (count)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

