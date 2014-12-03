Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaLCJfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:35:33 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35551 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaLCJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:35:30 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 18/19] input: cyapa: add gen5 trackpad device read raw data function support
Date: Wed,  3 Dec 2014 17:30:24 +0800
Message-Id: <1417599025-21681-19-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read raw data function supported for gen5 trackpad device,
it can be used through debugfs raw_data interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa_gen5.c | 138 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index f75461c..af098d4 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -2363,6 +2363,143 @@ resume_scanning:
 	return size;
 }
 
+static int cyapa_gen5_read_electrodies_rx_tx(struct cyapa *cyapa)
+{
+	u8 cmd[7] = { 0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x71 };
+	u8 resp_data[7];
+	int resp_len;
+	int error;
+
+	resp_len = sizeof(resp_data);
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, 7,
+			resp_data, &resp_len,
+			150, cyapa_gen5_sort_tsg_pip_app_resp_data, true);
+	if (error || !VALID_CMD_RESP_HEADER(resp_data, 0x71) ||
+		!resp_data[5] || !resp_data[6])
+		return -EINVAL;
+
+	cyapa->electrodes_rx = resp_data[6];
+
+	return 0;
+}
+
+static int cyapa_gen5_read_raw_data(struct cyapa *cyapa)
+{
+	int raw_cap_mutual_max, raw_cap_mutual_min, raw_cap_mutual_ave;
+	int raw_cap_self_max, raw_cap_self_min, raw_cap_self_ave;
+	int offset;
+	int data_size, max, min, ave;
+	ktime_t time_mono;
+	int error, resume_error;
+
+	offset = 0;
+	if (!cyapa->tp_raw_data) {
+		if (cyapa->state != CYAPA_STATE_GEN5_APP ||
+			!cyapa->electrodes_x || !cyapa->electrodes_y)
+			return  -EINVAL;
+
+		cyapa->tp_raw_data_size = sizeof(s32) * (cyapa->electrodes_x *
+			cyapa->electrodes_y + cyapa->electrodes_x +
+			cyapa->electrodes_y) + GEN5_RAW_DATA_HEAD_SIZE;
+		/*
+		 * This buffer will be hold after used until the driver is
+		 * unloaded, the purpose of it is to improve the performace
+		 * to avoid frequently allocate and release the buffer.
+		 */
+		cyapa->tp_raw_data = devm_kzalloc(&cyapa->client->dev,
+					cyapa->tp_raw_data_size, GFP_KERNEL);
+		if (!cyapa->tp_raw_data)
+			return -ENOMEM;
+	}
+
+	/*
+	 * 1. Suspend Scanning.
+	 *
+	 * After suspend scanning, the raw data will not be updated,
+	 * so the time of the raw data is before scanning suspended.
+	 */
+	time_mono = ktime_get();
+	error = cyapa_gen5_suspend_scanning(cyapa);
+	if (error)
+		return error;
+
+	/* 2. Get the correct electrodes_rx number. */
+	if (cyapa->electrodes_rx == 0) {
+		error = cyapa_gen5_read_electrodies_rx_tx(cyapa);
+		if (error || cyapa->electrodes_rx == 0) {
+			cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+			/*
+			 * Since, old firmware doesn't support the command to
+			 * read the electrodies' Rx and Tx values, so using
+			 * the read global idac interface to get the Rx number,
+			 * this value is useful to analyze and
+			 * display the raw data map in userspace.
+			 */
+			data_size = 0;
+			error = cyapa_gen5_read_idac_data(cyapa,
+					GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+					GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+					&data_size, &max, &min, &ave);
+			if (error || cyapa->electrodes_rx == 0)
+				goto resume_scanning;
+		}
+	}
+
+	/* 3. Execuate panel scan. It must be executed before read data. */
+	error = cyapa_gen5_execute_panel_scan(cyapa);
+	if (error)
+		goto resume_scanning;
+
+	/* 4. Retrieve panel scan, mutual cap raw data. */
+	offset = GEN5_RAW_DATA_HEAD_SIZE;
+	error = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_MUTUAL_DIFFCOUNT,
+				cyapa->electrodes_x * cyapa->electrodes_y,
+				&raw_cap_mutual_max, &raw_cap_mutual_min,
+				&raw_cap_mutual_ave,
+				cyapa->tp_raw_data + offset);
+	if (error)
+		goto resume_scanning;
+
+	offset += sizeof(s32) * cyapa->electrodes_x * cyapa->electrodes_y;
+
+	/* 5. Retrieve panel scan, self cap raw data. */
+	error = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_SELF_DIFFCOUNT,
+				cyapa->electrodes_x + cyapa->electrodes_y,
+				&raw_cap_self_max, &raw_cap_self_min,
+				&raw_cap_self_ave,
+				cyapa->tp_raw_data + offset);
+	if (error)
+		goto resume_scanning;
+
+	offset += sizeof(s32) * (cyapa->electrodes_x + cyapa->electrodes_y);
+
+resume_scanning:
+	/* 6. Resume Scanning*/
+	resume_error = cyapa_gen5_resume_scanning(cyapa);
+	if (resume_error || error)
+		return resume_error ? resume_error : error;
+
+	*((struct timeval *)&cyapa->tp_raw_data[0]) =
+						ktime_to_timeval(time_mono);
+	cyapa->tp_raw_data[16] = (u8)cyapa->electrodes_x;
+	cyapa->tp_raw_data[17] = (u8)cyapa->electrodes_y;
+	cyapa->tp_raw_data[18] = (u8)cyapa->x_origin;
+	cyapa->tp_raw_data[19] = (u8)cyapa->y_origin;
+	cyapa->tp_raw_data[20] = (u8)sizeof(s32);
+	cyapa->tp_raw_data[21] = (u8)sizeof(s32);
+	cyapa->tp_raw_data[22] = (u8)cyapa->electrodes_rx;
+	cyapa->tp_raw_data[23] = 0;  /* Reserved. */
+
+	cyapa->tp_raw_data_size = offset;
+	return 0;
+}
+
 static bool cyapa_gen5_sort_system_info_data(struct cyapa *cyapa,
 		u8 *buf, int len)
 {
@@ -2777,6 +2914,7 @@ const struct cyapa_dev_ops cyapa_gen5_ops = {
 	.calibrate_store = cyapa_gen5_do_calibrate,
 
 	.read_fw = cyapa_gen5_read_fw,
+	.read_raw_data = cyapa_gen5_read_raw_data,
 
 	.initialize = cyapa_gen5_initialize,
 
-- 
1.9.1

