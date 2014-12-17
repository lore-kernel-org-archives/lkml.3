Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaLQKBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:01:04 -0500
Received: from bay004-omc1s8.hotmail.com ([65.54.190.19]:58266 "EHLO
	BAY004-OMC1S8.hotmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaLQKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:01:00 -0500
X-TMN: [/dI5AWXxJKBi6gkx+PqICGsuA6NNkYfo]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY407-EAS378B1FE15A5CD638BCAD6DCBD6D0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <jmmahler@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v16 11/12] input: cyapa: add gen5 trackpad device force
Date: Wed, 17 Dec 2014 17:57:58 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AdAZ32xF25eRWf+OSe+EWwDlNbaZ/w==
Content-Language: zh-cn
X-OriginalArrivalTime: 17 Dec 2014 09:58:00.0555 (UTC) FILETIME=[F10173B0:01D019DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add force re-calibrate function supported for gen5 trackpad device,
it can be used through sysfs calibrate interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa_gen5.c | 65 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index 2b800e3..4bb6f34 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -1713,6 +1713,70 @@ static int cyapa_gen5_suspend_scanning(struct cyapa
*cyapa)
 	return 0;
 }
 
+static int cyapa_gen5_calibrate_pwcs(struct cyapa *cyapa,
+		u8 calibrate_sensing_mode_type)
+{
+	struct gen5_app_cmd_head *app_cmd_head;
+	u8 cmd[8];
+	u8 resp_data[6];
+	int resp_len;
+	int error;
+
+	/* Try to dump all buffered data before doing command. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	memset(cmd, 0, sizeof(cmd));
+	app_cmd_head = (struct gen5_app_cmd_head *)cmd;
+	put_unaligned_le16(GEN5_OUTPUT_REPORT_ADDR, &app_cmd_head->addr);
+	put_unaligned_le16(sizeof(cmd) - 2, &app_cmd_head->length);
+	app_cmd_head->report_id = GEN5_APP_CMD_REPORT_ID;
+	app_cmd_head->cmd_code = GEN5_CMD_CALIBRATE;
+	app_cmd_head->parameter_data[0] = calibrate_sensing_mode_type;
+	resp_len = sizeof(resp_data);
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, sizeof(cmd),
+			resp_data, &resp_len,
+			5000, cyapa_gen5_sort_tsg_pip_app_resp_data, true);
+	if (error || !VALID_CMD_RESP_HEADER(resp_data, GEN5_CMD_CALIBRATE) ||
+			!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+		return error < 0 ? error : -EAGAIN;
+
+	return 0;
+}
+
+static ssize_t cyapa_gen5_do_calibrate(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int error, calibrate_error;
+
+	/* 1. Suspend Scanning*/
+	error = cyapa_gen5_suspend_scanning(cyapa);
+	if (error)
+		return error;
+
+	/* 2. Do mutual capacitance fine calibrate. */
+	calibrate_error = cyapa_gen5_calibrate_pwcs(cyapa,
+				CYAPA_SENSING_MODE_MUTUAL_CAP_FINE);
+	if (calibrate_error)
+		goto resume_scanning;
+
+	/* 3. Do self capacitance calibrate. */
+	calibrate_error = cyapa_gen5_calibrate_pwcs(cyapa,
+				CYAPA_SENSING_MODE_SELF_CAP);
+	if (calibrate_error)
+		goto resume_scanning;
+
+resume_scanning:
+	/* 4. Resume Scanning*/
+	error = cyapa_gen5_resume_scanning(cyapa);
+	if (error || calibrate_error)
+		return error ? error : calibrate_error;
+
+	return count;
+}
+
 static s32 twos_complement_to_s32(s32 value, int num_bits)
 {
 	if (value >> (num_bits - 1))
@@ -2689,6 +2753,7 @@ const struct cyapa_dev_ops cyapa_gen5_ops = {
 	.update_fw = cyapa_gen5_do_fw_update,
 
 	.show_baseline = cyapa_gen5_show_baseline,
+	.calibrate_store = cyapa_gen5_do_calibrate,
 
 	.initialize = cyapa_gen5_initialize,
 
-- 
1.9.1

