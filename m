Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaLCJdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:33:32 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44688 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaLCJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:33:27 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 12/19] input: cyapa: add gen5 trackpad device read baseline function support
Date: Wed,  3 Dec 2014 17:30:18 +0800
Message-Id: <1417599025-21681-13-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
References: <1417599025-21681-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add read baseline function supported for gen5 trackpad device,
it can be used through sysfs baseline interface.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.h      |   2 +
 drivers/input/mouse/cyapa_gen5.c | 621 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 623 insertions(+)

diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index eafeb79..39e7941 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -285,6 +285,8 @@ struct cyapa {
 	u8 y_origin;  /* Y Axis Origin: 0 = top; 1 = bottom. */
 	int electrodes_x;  /* Number of electrodes on the X Axis*/
 	int electrodes_y;  /* Number of electrodes on the Y Axis*/
+	int electrodes_rx;  /* Number of Rx electrodes */
+	int algined_electrodes_rx;  /* 4 aligned */
 	int max_z;
 
 	/*
diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index eee7d0c..ad123ae 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -1532,6 +1532,625 @@ static int cyapa_gen5_set_power_mode(struct cyapa *cyapa,
 	return 0;
 }
 
+static int cyapa_gen5_resume_scanning(struct cyapa *cyapa)
+{
+	u8 cmd[7] = { 0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x04 };
+	u8 resp_data[6];
+	int resp_len;
+	int error;
+
+	/* Try to dump all bufferred data before doing command. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	resp_len = 6;
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, 7,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data, true);
+	if (error || !VALID_CMD_RESP_HEADER(resp_data, 0x04))
+		return -EINVAL;
+
+	/* Try to dump all bufferred data when resuming scanning. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	return 0;
+}
+
+static int cyapa_gen5_suspend_scanning(struct cyapa *cyapa)
+{
+	u8 cmd[7] = { 0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x03 };
+	u8 resp_data[6];
+	int resp_len;
+	int error;
+
+	/* Try to dump all bufferred data before doing command. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	resp_len = 6;
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, 7,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data, true);
+	if (error || !VALID_CMD_RESP_HEADER(resp_data, 0x03))
+		return -EINVAL;
+
+	/* Try to dump all bufferred data when suspending scanning. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	return 0;
+}
+
+static s32 two_complement_to_s32(s32 value, int num_bits)
+{
+	if (value >> (num_bits - 1))
+		value |=  -1 << num_bits;
+	return value;
+}
+
+static s32 cyapa_parse_structure_data(u8 data_format, u8 *buf, int buf_len)
+{
+	int data_size;
+	bool big_endian;
+	bool unsigned_type;
+	s32 value;
+
+	data_size = (data_format & 0x07);
+	big_endian = ((data_format & 0x10) == 0x00);
+	unsigned_type = ((data_format & 0x20) == 0x00);
+
+	if (buf_len < data_size)
+		return 0;
+
+	switch (data_size) {
+	case 1:
+		value  = buf[0];
+		break;
+	case 2:
+		if (big_endian)
+			value = get_unaligned_be16(buf);
+		else
+			value = get_unaligned_le16(buf);
+		break;
+	case 4:
+		if (big_endian)
+			value = get_unaligned_be32(buf);
+		else
+			value = get_unaligned_le32(buf);
+		break;
+	default:
+		/* Should not happen, just as default case here. */
+		value = 0;
+		break;
+	}
+
+	if (!unsigned_type)
+		value = two_complement_to_s32(value, data_size * 8);
+
+	return value;
+}
+
+
+/*
+ * Read all the global mutual or self idac data or mutual or self local PWC
+ * data based on the @idac_data_type.
+ * If the input value of @data_size is 0, then means read global mutual or
+ * self idac data. For read global mutual idac data, @idac_max, @idac_min and
+ * @idac_ave are in order used to return the max value of global mutual idac
+ * data, the min value of global mutual idac and the average value of the
+ * global mutual idac data. For read global self idac data, @idac_max is used
+ * to return the global self cap idac data in Rx direction, @idac_min is used
+ * to return the global self cap idac data in Tx direction. @idac_ave is not
+ * used.
+ * If the input value of @data_size is not 0, than means read the mutual or
+ * self local PWC data. The @idac_max, @idac_min and @idac_ave are used to
+ * return the max, min and average value of the mutual or self local PWC data.
+ * Note, in order to raed mutual local PWC data, must read invoke this function
+ * to read the mutual global idac data firstly to set the correct Rx number
+ * value, otherwise, the read mutual idac and PWC data may not correct.
+ */
+static int cyapa_gen5_read_idac_data(struct cyapa *cyapa,
+		u8 cmd_code, u8 idac_data_type, int *data_size,
+		int *idac_max, int *idac_min, int *idac_ave)
+{
+	int i;
+	u8 cmd[12];
+	u8 resp_data[256];
+	int resp_len;
+	int read_len;
+	int value;
+	u16 offset;
+	int read_elements;
+	bool read_global_idac;
+	int sum, count, max_element_cnt;
+	int tmp_max, tmp_min, tmp_ave, tmp_sum, tmp_count;
+	int electrodes_rx, electrodes_tx;
+	int error;
+
+	if (cmd_code != GEN5_CMD_RETRIEVE_DATA_STRUCTURE ||
+		(idac_data_type != GEN5_RETRIEVE_MUTUAL_PWC_DATA &&
+		idac_data_type != GEN5_RETRIEVE_SELF_CAP_PWC_DATA) ||
+		!data_size || !idac_max || !idac_min || !idac_ave)
+		return -EINVAL;
+
+	*idac_max = INT_MIN;
+	*idac_min = INT_MAX;
+	sum = count = tmp_count = 0;
+	electrodes_rx = electrodes_tx = 0;
+	if (*data_size == 0) {
+		/*
+		 * Read global idac values firstly.
+		 * Currently, no idac data exceed 4 bytes.
+		 */
+		read_global_idac = true;
+		offset = 0;
+		*data_size = 4;
+		tmp_max = INT_MIN;
+		tmp_min = INT_MAX;
+		tmp_ave = tmp_sum = tmp_count = 0;
+
+		if (idac_data_type == GEN5_RETRIEVE_MUTUAL_PWC_DATA) {
+			if (cyapa->algined_electrodes_rx == 0) {
+				if (cyapa->electrodes_rx != 0) {
+					electrodes_rx = cyapa->electrodes_rx;
+					electrodes_tx = (cyapa->electrodes_x ==
+						electrodes_rx) ?
+							cyapa->electrodes_y :
+							cyapa->electrodes_x;
+				} else {
+					electrodes_tx = min(cyapa->electrodes_x,
+							cyapa->electrodes_y);
+					electrodes_rx = max(cyapa->electrodes_x,
+							cyapa->electrodes_y);
+				}
+				cyapa->algined_electrodes_rx =
+					(electrodes_rx + 3) & ~3u;
+			}
+			max_element_cnt =
+				(cyapa->algined_electrodes_rx + 7) & ~7u;
+		} else {
+			max_element_cnt = 2;
+		}
+	} else {
+		read_global_idac = false;
+		if (*data_size > 4)
+			*data_size = 4;
+		/* Calculate the start offset in bytes of local PWC data. */
+		if (idac_data_type == GEN5_RETRIEVE_MUTUAL_PWC_DATA) {
+			offset = cyapa->algined_electrodes_rx * (*data_size);
+			electrodes_tx =
+				(cyapa->electrodes_rx == cyapa->electrodes_x) ?
+				cyapa->electrodes_y : cyapa->electrodes_x;
+			max_element_cnt = ((cyapa->algined_electrodes_rx + 7) &
+						~7u) * electrodes_tx;
+		} else if (idac_data_type == GEN5_RETRIEVE_SELF_CAP_PWC_DATA) {
+			offset = 2;
+			max_element_cnt = cyapa->electrodes_x +
+						cyapa->electrodes_y;
+			max_element_cnt = (max_element_cnt + 3) & ~3u;
+		}
+	}
+
+	do {
+		read_elements = (256 - 10) / (*data_size);
+		read_elements = min(read_elements, max_element_cnt - count);
+		read_len = read_elements * (*data_size);
+
+		cmd[0] = 0x04;
+		cmd[1] = 0x00;
+		cmd[2] = 0x0a;
+		cmd[3] = 0x00;
+		cmd[4] = GEN5_APP_CMD_REPORT_ID;
+		cmd[5] = 0x00;
+		cmd[6] = cmd_code;
+		put_unaligned_le16(offset, &cmd[7]); /* Read Offset[15:0] */
+		put_unaligned_le16(read_len, &cmd[9]); /* Read Length[15:0] */
+		cmd[11] = idac_data_type;
+		resp_len = 10 + read_len;
+		error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+				cmd, 12,
+				resp_data, &resp_len,
+				500, cyapa_gen5_sort_tsg_pip_app_resp_data,
+				true);
+		if (error || resp_len < 10 ||
+				!VALID_CMD_RESP_HEADER(resp_data, cmd_code) ||
+				!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]) ||
+				resp_data[6] != idac_data_type)
+			return (error < 0) ? error : -EAGAIN;
+		read_len = get_unaligned_le16(&resp_data[7]);
+		if (read_len == 0)
+			break;
+
+		*data_size = (resp_data[9] & GEN5_PWC_DATA_ELEMENT_SIZE_MASK);
+		if (read_len < *data_size)
+			return -EINVAL;
+
+		if (read_global_idac &&
+			idac_data_type == GEN5_RETRIEVE_SELF_CAP_PWC_DATA) {
+			/* Rx's self global idac data. */
+			*idac_max = cyapa_parse_structure_data(
+					resp_data[9], &resp_data[10],
+					*data_size);
+			/* Tx's self global idac data. */
+			*idac_min = cyapa_parse_structure_data(
+					resp_data[9],
+					&resp_data[10 + *data_size],
+					*data_size);
+			break;
+		}
+
+		/* Read mutual global idac or local mutual/self PWC data. */
+		offset += read_len;
+		for (i = 10; i < (read_len + 10); i += *data_size) {
+			value = cyapa_parse_structure_data(resp_data[9],
+					&resp_data[i], *data_size);
+			*idac_min = min(value, *idac_min);
+			*idac_max = max(value, *idac_max);
+
+			if (idac_data_type == GEN5_RETRIEVE_MUTUAL_PWC_DATA &&
+				tmp_count < cyapa->algined_electrodes_rx &&
+				read_global_idac) {
+				/*
+				 * The value gap betwen global and local mutual
+				 * idac data must bigger than 50%.
+				 * Normally, global value bigger than 50,
+				 * local values less than 10.
+				 */
+				if (!tmp_ave || value > tmp_ave / 2) {
+					tmp_min = min(value, tmp_min);
+					tmp_max = max(value, tmp_max);
+					tmp_sum += value;
+					tmp_count++;
+
+					tmp_ave = tmp_sum / tmp_count;
+				}
+			}
+
+			sum += value;
+			count++;
+
+			if (count >= max_element_cnt)
+				goto out;
+		}
+	} while (true);
+
+out:
+	*idac_ave = count ? (sum / count) : 0;
+
+	if (read_global_idac &&
+		idac_data_type == GEN5_RETRIEVE_MUTUAL_PWC_DATA) {
+		if (tmp_count == 0)
+			return 0;
+
+		if (tmp_count == cyapa->algined_electrodes_rx) {
+			cyapa->electrodes_rx = cyapa->electrodes_rx ?
+				cyapa->electrodes_rx : electrodes_rx;
+		} else if (tmp_count == electrodes_rx) {
+			cyapa->electrodes_rx = cyapa->electrodes_rx ?
+				cyapa->electrodes_rx : electrodes_rx;
+			cyapa->algined_electrodes_rx = electrodes_rx;
+		} else {
+			cyapa->electrodes_rx = cyapa->electrodes_rx ?
+				cyapa->electrodes_rx : electrodes_tx;
+			cyapa->algined_electrodes_rx = tmp_count;
+		}
+
+		*idac_min = tmp_min;
+		*idac_max = tmp_max;
+		*idac_ave = tmp_ave;
+	}
+
+	return 0;
+}
+
+static int cyapa_gen5_read_mutual_idac_data(struct cyapa *cyapa,
+	int *gidac_mutual_max, int *gidac_mutual_min, int *gidac_mutual_ave,
+	int *lidac_mutual_max, int *lidac_mutual_min, int *lidac_mutual_ave)
+{
+	int error;
+	int data_size;
+
+	*gidac_mutual_max = *gidac_mutual_min = *gidac_mutual_ave = 0;
+	*lidac_mutual_max = *lidac_mutual_min = *lidac_mutual_ave = 0;
+
+	data_size = 0;
+	error = cyapa_gen5_read_idac_data(cyapa,
+		GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+		GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+		&data_size,
+		gidac_mutual_max, gidac_mutual_min, gidac_mutual_ave);
+	if (error)
+		return error;
+
+	error = cyapa_gen5_read_idac_data(cyapa,
+		GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+		GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+		&data_size,
+		lidac_mutual_max, lidac_mutual_min, lidac_mutual_ave);
+	return error;
+}
+
+static int cyapa_gen5_read_self_idac_data(struct cyapa *cyapa,
+		int *gidac_self_rx, int *gidac_self_tx,
+		int *lidac_self_max, int *lidac_self_min, int *lidac_self_ave)
+{
+	int error;
+	int data_size;
+
+	*gidac_self_rx = *gidac_self_tx = 0;
+	*lidac_self_max = *lidac_self_min = *lidac_self_ave = 0;
+
+	data_size = 0;
+	error = cyapa_gen5_read_idac_data(cyapa,
+		GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+		GEN5_RETRIEVE_SELF_CAP_PWC_DATA,
+		&data_size,
+		lidac_self_max, lidac_self_min, lidac_self_ave);
+	if (error)
+		return error;
+	*gidac_self_rx = *lidac_self_max;
+	*gidac_self_tx = *lidac_self_min;
+
+	error = cyapa_gen5_read_idac_data(cyapa,
+		GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+		GEN5_RETRIEVE_SELF_CAP_PWC_DATA,
+		&data_size,
+		lidac_self_max, lidac_self_min, lidac_self_ave);
+	return error;
+}
+
+static ssize_t cyapa_gen5_execute_panel_scan(struct cyapa *cyapa)
+{
+	int error;
+	u8 cmd[7];
+	u8 resp_data[6];
+	int resp_len;
+
+	cmd[0] = 0x04;
+	cmd[1] = 0x00;
+	cmd[2] = 0x05;
+	cmd[3] = 0x00;
+	cmd[4] = GEN5_APP_CMD_REPORT_ID;
+	cmd[5] = 0x00;
+	cmd[6] = GEN5_CMD_EXECUTE_PANEL_SCAN;  /* Command code */
+	resp_len = 6;
+	error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, 7,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data, true);
+	if (error || resp_len != 6 ||
+			!VALID_CMD_RESP_HEADER(resp_data,
+				GEN5_CMD_EXECUTE_PANEL_SCAN) ||
+			!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+		return error ? error : -EAGAIN;
+
+	return 0;
+}
+
+static int cyapa_gen5_read_panel_scan_raw_data(struct cyapa *cyapa,
+		u8 cmd_code, u8 raw_data_type, int raw_data_max_num,
+		int *raw_data_max, int *raw_data_min, int *raw_data_ave,
+		u8 *buffer)
+{
+	int i;
+	u8 cmd[12];
+	u8 resp_data[256];  /* Max bytes can transfer one time. */
+	int resp_len;
+	int read_elements;
+	int read_len;
+	u16 offset;
+	s32 value;
+	int sum, count;
+	int data_size;
+	s32 *intp;
+	int error;
+
+	if (cmd_code != GEN5_CMD_RETRIEVE_PANEL_SCAN ||
+		(raw_data_type > GEN5_PANEL_SCAN_SELF_DIFFCOUNT) ||
+		!raw_data_max || !raw_data_min || !raw_data_ave)
+		return -EINVAL;
+
+	intp = (s32 *)buffer;
+	*raw_data_max = INT_MIN;
+	*raw_data_min = INT_MAX;
+	sum = count = 0;
+	offset = 0;
+	read_elements = (256 - 10) / 4;  /* Currently, max element size is 4. */
+	read_len = read_elements * 4;
+	do {
+		cmd[0] = 0x04;
+		cmd[1] = 0x00;
+		cmd[2] = 0x0a;
+		cmd[3] = 0x00;
+		cmd[4] = GEN5_APP_CMD_REPORT_ID;
+		cmd[5] = 0x00;
+		cmd[6] = cmd_code;  /* Command code */
+		put_unaligned_le16(offset, &cmd[7]);
+		put_unaligned_le16(read_elements, &cmd[9]);
+		cmd[11] = raw_data_type;
+		resp_len = 10 + read_len;
+
+		error = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, 12,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data, true);
+		if (error || resp_len < 10 ||
+				!VALID_CMD_RESP_HEADER(resp_data, cmd_code) ||
+				!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]) ||
+				resp_data[6] != raw_data_type)
+			return error ? error : -EAGAIN;
+
+		read_elements = get_unaligned_le16(&resp_data[7]);
+		if (read_elements == 0)
+			break;
+
+		data_size = (resp_data[9] & GEN5_PWC_DATA_ELEMENT_SIZE_MASK);
+		offset += read_elements;
+		if (read_elements) {
+			for (i = 10;
+			     i < (read_elements * data_size + 10);
+			     i += data_size) {
+				value = cyapa_parse_structure_data(resp_data[9],
+						&resp_data[i], data_size);
+				*raw_data_min = min(value, *raw_data_min);
+				*raw_data_max = max(value, *raw_data_max);
+
+				if (intp)
+					put_unaligned_le32(value, &intp[count]);
+
+				sum += value;
+				count++;
+
+			}
+		}
+
+		if (count >= raw_data_max_num)
+			break;
+
+		read_elements = (sizeof(resp_data) - 10) / data_size;
+		read_len = read_elements * data_size;
+	} while (true);
+
+	*raw_data_ave = count ? (sum / count) : 0;
+
+	return 0;
+}
+
+static ssize_t cyapa_gen5_show_baseline(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int gidac_mutual_max, gidac_mutual_min, gidac_mutual_ave;
+	int lidac_mutual_max, lidac_mutual_min, lidac_mutual_ave;
+	int gidac_self_rx, gidac_self_tx;
+	int lidac_self_max, lidac_self_min, lidac_self_ave;
+	int raw_cap_mutual_max, raw_cap_mutual_min, raw_cap_mutual_ave;
+	int raw_cap_self_max, raw_cap_self_min, raw_cap_self_ave;
+	int mutual_diffdata_max, mutual_diffdata_min, mutual_diffdata_ave;
+	int self_diffdata_max, self_diffdata_min, self_diffdata_ave;
+	int mutual_baseline_max, mutual_baseline_min, mutual_baseline_ave;
+	int self_baseline_max, self_baseline_min, self_baseline_ave;
+	int error, resume_error;
+	int size;
+
+	if (cyapa->state != CYAPA_STATE_GEN5_APP)
+		return -EBUSY;
+
+	/* 1. Suspend Scanning*/
+	error = cyapa_gen5_suspend_scanning(cyapa);
+	if (error)
+		return error;
+
+	/* 2.  Read global and local mutual IDAC data. */
+	gidac_self_rx = gidac_self_tx = 0;
+	error = cyapa_gen5_read_mutual_idac_data(cyapa,
+				&gidac_mutual_max, &gidac_mutual_min,
+				&gidac_mutual_ave, &lidac_mutual_max,
+				&lidac_mutual_min, &lidac_mutual_ave);
+	if (error)
+		goto resume_scanning;
+
+	/* 3.  Read global and local self IDAC data. */
+	error = cyapa_gen5_read_self_idac_data(cyapa,
+				&gidac_self_rx, &gidac_self_tx,
+				&lidac_self_max, &lidac_self_min,
+				&lidac_self_ave);
+	if (error)
+		goto resume_scanning;
+
+	/* 4. Execuate panel scan. It must be executed before read data. */
+	error = cyapa_gen5_execute_panel_scan(cyapa);
+	if (error)
+		goto resume_scanning;
+
+	/* 5. Retrieve panel scan, mutual cap raw data. */
+	error = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_MUTUAL_RAW_DATA,
+				cyapa->electrodes_x * cyapa->electrodes_y,
+				&raw_cap_mutual_max, &raw_cap_mutual_min,
+				&raw_cap_mutual_ave,
+				NULL);
+	if (error)
+		goto resume_scanning;
+
+	/* 6. Retrieve panel scan, self cap raw data. */
+	error = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_SELF_RAW_DATA,
+				cyapa->electrodes_x + cyapa->electrodes_y,
+				&raw_cap_self_max, &raw_cap_self_min,
+				&raw_cap_self_ave,
+				NULL);
+	if (error)
+		goto resume_scanning;
+
+	/* 7. Retrieve panel scan, mutual cap diffcount raw data. */
+	error = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_MUTUAL_DIFFCOUNT,
+				cyapa->electrodes_x * cyapa->electrodes_y,
+				&mutual_diffdata_max, &mutual_diffdata_min,
+				&mutual_diffdata_ave,
+				NULL);
+	if (error)
+		goto resume_scanning;
+
+	/* 8. Retrieve panel scan, self cap diffcount raw data. */
+	error = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_SELF_DIFFCOUNT,
+				cyapa->electrodes_x + cyapa->electrodes_y,
+				&self_diffdata_max, &self_diffdata_min,
+				&self_diffdata_ave,
+				NULL);
+	if (error)
+		goto resume_scanning;
+
+	/* 9. Retrieve panel scan, mutual cap baseline raw data. */
+	error = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_MUTUAL_BASELINE,
+				cyapa->electrodes_x * cyapa->electrodes_y,
+				&mutual_baseline_max, &mutual_baseline_min,
+				&mutual_baseline_ave,
+				NULL);
+	if (error)
+		goto resume_scanning;
+
+	/* 10. Retrieve panel scan, self cap baseline raw data. */
+	error = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_SELF_BASELINE,
+				cyapa->electrodes_x + cyapa->electrodes_y,
+				&self_baseline_max, &self_baseline_min,
+				&self_baseline_ave,
+				NULL);
+	if (error)
+		goto resume_scanning;
+
+resume_scanning:
+	/* 11. Resume Scanning*/
+	resume_error = cyapa_gen5_resume_scanning(cyapa);
+	if (resume_error || error)
+		return resume_error ? resume_error : error;
+
+	/* 12. Output data strings */
+	size = scnprintf(buf, PAGE_SIZE, "%d %d %d %d %d %d %d %d %d %d %d ",
+		gidac_mutual_min, gidac_mutual_max, gidac_mutual_ave,
+		lidac_mutual_min, lidac_mutual_max, lidac_mutual_ave,
+		gidac_self_rx, gidac_self_tx,
+		lidac_self_min, lidac_self_max, lidac_self_ave);
+	size += scnprintf(buf + size, PAGE_SIZE - size,
+		"%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
+		raw_cap_mutual_min, raw_cap_mutual_max, raw_cap_mutual_ave,
+		raw_cap_self_min, raw_cap_self_max, raw_cap_self_ave,
+		mutual_diffdata_min, mutual_diffdata_max, mutual_diffdata_ave,
+		self_diffdata_min, self_diffdata_max, self_diffdata_ave,
+		mutual_baseline_min, mutual_baseline_max, mutual_baseline_ave,
+		self_baseline_min, self_baseline_max, self_baseline_ave);
+	return size;
+}
+
 static bool cyapa_gen5_sort_system_info_data(struct cyapa *cyapa,
 		u8 *buf, int len)
 {
@@ -1937,6 +2556,8 @@ const struct cyapa_dev_ops cyapa_gen5_ops = {
 	.bl_initiate = cyapa_gen5_bl_initiate,
 	.update_fw = cyapa_gen5_do_fw_update,
 
+	.show_baseline = cyapa_gen5_show_baseline,
+
 	.initialize = cyapa_gen5_initialize,
 
 	.state_parse = cyapa_gen5_state_parse,
-- 
1.9.1

