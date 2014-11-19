Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaKSIl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:41:29 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:41517 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbaKSIl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:41:26 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 13/19] input: cyapa: add gen5 trackpad device force re-calibrate function support
Date: Wed, 19 Nov 2014 16:37:45 +0800
Message-Id: <1416386271-28167-14-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
References: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
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
index b401b2a..51bdf06 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -1580,6 +1580,70 @@ static int cyapa_gen5_suspend_scanning(struct cyapa *cyapa)
 	return 0;
 }
 
+static int cyapa_gen5_calibrate_pwcs(struct cyapa *cyapa,
+		u8 calibrate_sensing_mode_type)
+{
+	u8 cmd[8];
+	u8 resp_data[6];
+	int resp_len;
+	int error;
+
+	/* Try to dump all bufferred data before doing command. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	cmd[0] = 0x04;
+	cmd[1] = 0x00;
+	cmd[2] = 0x06;
+	cmd[3] = 0x00;
+	cmd[4] = GEN5_APP_CMD_REPORT_ID;
+	cmd[5] = 0x00;
+	cmd[6] = GEN5_CMD_CALIBRATE;
+	cmd[7] = calibrate_sensing_mode_type;
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
 static s32 two_complement_to_s32(s32 value, int num_bits)
 {
 	if (value >> (num_bits - 1))
@@ -2556,6 +2620,7 @@ const struct cyapa_dev_ops cyapa_gen5_ops = {
 	.update_fw = cyapa_gen5_do_fw_update,
 
 	.show_baseline = cyapa_gen5_show_baseline,
+	.calibrate_store = cyapa_gen5_do_calibrate,
 
 	.initialize = cyapa_gen5_initialize,
 
-- 
1.9.1

