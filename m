Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256AbaLIJNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:13:39 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52951 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaLIJNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:13:34 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v13 07/12] input: cyapa: add gen3 trackpad device read baseline function support
Date: Tue,  9 Dec 2014 17:11:39 +0800
Message-Id: <1418116304-11392-8-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read baseline function supported for gen3 trackpad device,
it can be used through sysfs baseline interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa_gen3.c | 71 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index 1110668..3b2ad88 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -754,6 +754,75 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
 	return 0;
 }
 
+static ssize_t cyapa_gen3_show_baseline(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int max_baseline, min_baseline;
+	int tries = 3;
+	int ret;
+
+	ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+	if (ret < 0) {
+		dev_err(dev, "Error reading dev status. err = %d\n", ret);
+		goto out;
+	}
+	if ((ret & CYAPA_DEV_NORMAL) != CYAPA_DEV_NORMAL) {
+		dev_warn(dev, "Trackpad device is busy. device state = 0x%x\n",
+			 ret);
+		ret = -EAGAIN;
+		goto out;
+	}
+
+	ret = cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
+			       OP_REPORT_BASELINE_MASK);
+	if (ret < 0) {
+		dev_err(dev, "Failed to send report baseline command. %d\n",
+			ret);
+		goto out;
+	}
+
+	do {
+		usleep_range(10000, 20000);
+
+		ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+		if (ret < 0) {
+			dev_err(dev, "Error reading dev status. err = %d\n",
+				ret);
+			goto out;
+		}
+		if ((ret & CYAPA_DEV_NORMAL) == CYAPA_DEV_NORMAL)
+			break;
+	} while (--tries);
+
+	if (tries == 0) {
+		dev_err(dev, "Device timed out going to Normal state.\n");
+		ret = -ETIMEDOUT;
+		goto out;
+	}
+
+	ret = cyapa_read_byte(cyapa, CYAPA_CMD_MAX_BASELINE);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read max baseline. err = %d\n", ret);
+		goto out;
+	}
+	max_baseline = ret;
+
+	ret = cyapa_read_byte(cyapa, CYAPA_CMD_MIN_BASELINE);
+	if (ret < 0) {
+		dev_err(dev, "Failed to read min baseline. err = %d\n", ret);
+		goto out;
+	}
+	min_baseline = ret;
+
+	dev_dbg(dev, "Baseline report successful. Max: %d Min: %d\n",
+		max_baseline, min_baseline);
+	ret = scnprintf(buf, PAGE_SIZE, "%d %d\n", max_baseline, min_baseline);
+
+out:
+	return ret;
+}
+
 /*
  * cyapa_get_wait_time_for_pwr_cmd
  *
@@ -1067,6 +1136,8 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
 	.update_fw = cyapa_gen3_do_fw_update,
 	.bl_deactivate = cyapa_gen3_bl_deactivate,
 
+	.show_baseline = cyapa_gen3_show_baseline,
+
 	.state_parse = cyapa_gen3_state_parse,
 	.operational_check = cyapa_gen3_do_operational_check,
 
-- 
1.9.1

