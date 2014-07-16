Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbaGPDBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:01:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35210 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaGPDBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:01:35 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH v3] PM / devfreq: Add possible_frequencies device attribute
Date: Tue, 15 Jul 2014 20:01:28 -0700
Message-Id: <1405479688-13735-1-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <30733097.432311399543337408.JavaMail.weblogic@epv6ml09>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices use freq_table instead of OPP. For those devices, the
available_frequencies sysfs file shows up empty. So, add a
possible_frequencies attribute/syfs file that list all the possible
frequencies.

For devices that use OPP, the output of this file will match
available_frequencies. It may change in the future to show all OPP
frequencies -- even the disabled ones.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/devfreq/devfreq.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 9f90369..65eed38 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -994,6 +994,31 @@ static ssize_t available_frequencies_show(struct device *d,
 }
 static DEVICE_ATTR_RO(available_frequencies);
 
+static ssize_t possible_frequencies_show(struct device *d,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct devfreq *df = to_devfreq(d);
+	unsigned int i = 0;
+	ssize_t count = 0;
+
+	if (!df->profile->freq_table)
+		return available_frequencies_show(d, attr, buf);
+
+	for (i = 0; i < df->profile->max_state; i++)
+		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
+				   "%u ", df->profile->freq_table[i]);
+
+	/* Truncate the trailing space */
+	if (count)
+		count--;
+
+	count += sprintf(&buf[count], "\n");
+
+	return count;
+}
+static DEVICE_ATTR_RO(possible_frequencies);
+
 static ssize_t trans_stat_show(struct device *dev,
 			       struct device_attribute *attr, char *buf)
 {
@@ -1041,6 +1066,7 @@ static struct attribute *devfreq_attrs[] = {
 	&dev_attr_available_governors.attr,
 	&dev_attr_cur_freq.attr,
 	&dev_attr_available_frequencies.attr,
+	&dev_attr_possible_frequencies.attr,
 	&dev_attr_target_freq.attr,
 	&dev_attr_polling_interval.attr,
 	&dev_attr_min_freq.attr,
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
