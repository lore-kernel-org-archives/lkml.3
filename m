Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaKCIhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:37:35 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:57782 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaKCIha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 03:37:30 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
X-Google-Original-From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 18/18] input: cyapa: add gen5 trackpad device read raw data function support
Date: Mon,  3 Nov 2014 16:33:10 +0800
Message-Id: <1415003590-30485-19-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415003590-30485-1-git-send-email-dudl@cypress.com>
References: <1415003590-30485-1-git-send-email-dudl@cypress.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read raw data function supported for gen5 trackpad device,
it can be used through debugfs raw_data interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa_gen5.c | 109 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index 35334dc..bbc2e20 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -2350,6 +2350,114 @@ resume_scanning:
 	return ret + err;
 }
 
+static int cyapa_gen5_read_raw_data(struct cyapa *cyapa)
+{
+	int ret, err;
+	int raw_cap_mutual_max, raw_cap_mutual_min, raw_cap_mutual_ave;
+	int raw_cap_self_max, raw_cap_self_min, raw_cap_self_ave;
+	int offset;
+	int data_size, max, min, ave;
+	ktime_t time_mono;
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
+	ret = cyapa_gen5_suspend_scanning(cyapa);
+	if (ret)
+		return ret;
+
+	/* 2. Get the correct electrodes_rx number. */
+	if (cyapa->electrodes_rx == 0) {
+		/*
+		 * Through the read global idac interface to get the Rx number.
+		 * this value is useful to the raw data map.
+		 */
+		data_size = 0;
+		err = cyapa_gen5_read_idac_data(cyapa,
+				GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+				GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+				&data_size, &max, &min, &ave);
+		if (err || cyapa->electrodes_rx == 0)
+			goto resume_scanning;
+	}
+
+	/* 3. Execuate panel scan. It must be executed before read data. */
+	err = cyapa_gen5_execute_panel_scan(cyapa);
+	if (err)
+		goto resume_scanning;
+
+	/* 4. Retrieve panel scan, mutual cap raw data. */
+	offset = GEN5_RAW_DATA_HEAD_SIZE;
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_MUTUAL_DIFFCOUNT,
+				cyapa->electrodes_x * cyapa->electrodes_y,
+				&raw_cap_mutual_max, &raw_cap_mutual_min,
+				&raw_cap_mutual_ave,
+				cyapa->tp_raw_data + offset);
+	if (err)
+		goto resume_scanning;
+
+	offset += sizeof(s32) * cyapa->electrodes_x * cyapa->electrodes_y;
+
+	/* 5. Retrieve panel scan, self cap raw data. */
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_SELF_DIFFCOUNT,
+				cyapa->electrodes_x + cyapa->electrodes_y,
+				&raw_cap_self_max, &raw_cap_self_min,
+				&raw_cap_self_ave,
+				cyapa->tp_raw_data + offset);
+	if (err)
+		goto resume_scanning;
+
+	offset += sizeof(s32) * (cyapa->electrodes_x + cyapa->electrodes_y);
+
+resume_scanning:
+	/* 6. Resume Scanning*/
+	ret = cyapa_gen5_resume_scanning(cyapa);
+	if (ret || err)
+		return ret ? ret : err;
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
@@ -2762,6 +2870,7 @@ const struct cyapa_dev_ops cyapa_gen5_ops = {
 	.calibrate_store = cyapa_gen5_do_calibrate,
 
 	.read_fw = cyapa_gen5_read_fw,
+	.read_raw_data = cyapa_gen5_read_raw_data,
 
 	.initialize = cyapa_gen5_initialize,
 
-- 
1.9.1

