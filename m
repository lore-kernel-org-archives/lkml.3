Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaIJEkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 00:40:24 -0400
Received: from bay004-omc1s26.hotmail.com ([65.54.190.37]:62586 "EHLO
	BAY004-OMC1S26.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbaIJEkU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 00:40:20 -0400
X-TMN: [g9D63i7Ahy5lNoclaXX0CwnxSRn2ckIR]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY176-DS15C95D97E9CC3570636D4CBDCF0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 12/13] input: cyapa: add gen5 trackpad device baseline and calibrate functions support
Date: Wed, 10 Sep 2014 12:35:12 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac/MsJx48BuXE6/sSDiSO5c/QYTDWQ==
Content-Language: zh-cn
X-OriginalArrivalTime: 10 Sep 2014 04:35:14.0289 (UTC) FILETIME=[9D544610:01CFCCB0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add report baseline and force calibrate functions supported for gen5
trackpad device, which these functions are supplied through
cyapa core baseline and calibrate interfaces.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudl@cypress.com>
---
 drivers/input/mouse/cyapa_gen5.c | 670 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 670 insertions(+)

diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c
index 0c84b1b..452cb5d 100644
--- a/drivers/input/mouse/cyapa_gen5.c
+++ b/drivers/input/mouse/cyapa_gen5.c
@@ -1540,6 +1540,673 @@ static int cyapa_gen5_set_power_mode(struct cyapa *cyapa,
 	return ret;
 }
 
+static int cyapa_gen5_resume_scanning(struct cyapa *cyapa)
+{
+	u8 cmd[7] = { 0x04, 0x00, 0x05, 0x00, 0x2f, 0x00, 0x04 };
+	u8 resp_data[6];
+	int resp_len;
+	int ret;
+
+	/* Try to dump all bufferred data before doing command. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	resp_len = 6;
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, 7,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+	if (ret || !VALID_CMD_RESP_HEADER(resp_data, 0x04))
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
+	int ret;
+
+	/* Try to dump all bufferred data before doing command. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	resp_len = 6;
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, 7,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+	if (ret || !VALID_CMD_RESP_HEADER(resp_data, 0x03))
+		return -EINVAL;
+
+	/* Try to dump all bufferred data when suspending scanning. */
+	cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
+
+	return 0;
+}
+
+static int cyapa_gen5_calibrate_pwcs(struct cyapa *cyapa,
+		u8 calibrate_sensing_mode_type)
+{
+	int ret;
+	u8 cmd[8];
+	u8 resp_data[6];
+	int resp_len;
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
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, sizeof(cmd),
+			resp_data, &resp_len,
+			5000, cyapa_gen5_sort_tsg_pip_app_resp_data);
+	if (ret || !VALID_CMD_RESP_HEADER(resp_data, GEN5_CMD_CALIBRATE) ||
+			!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]))
+		return ret < 0 ? ret : -EAGAIN;
+
+	return 0;
+}
+
+static ssize_t cyapa_gen5_do_calibrate(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct cyapa *cyapa = dev_get_drvdata(dev);
+	int ret, calibrate_ret;
+
+	/* 1. Suspend Scanning*/
+	ret = cyapa_gen5_suspend_scanning(cyapa);
+	if (ret)
+		return ret;
+
+	/* 2. Do mutual capacitance fine calibrate. */
+	calibrate_ret = cyapa_gen5_calibrate_pwcs(cyapa,
+				CYAPA_SENSING_MODE_MUTUAL_CAP_FINE);
+	if (calibrate_ret)
+		goto resume_scanning;
+
+	/* 3. Do self capacitance calibrate. */
+	calibrate_ret = cyapa_gen5_calibrate_pwcs(cyapa,
+				CYAPA_SENSING_MODE_SELF_CAP);
+	if (calibrate_ret)
+		goto resume_scanning;
+
+resume_scanning:
+	/* 4. Resume Scanning*/
+	ret = cyapa_gen5_resume_scanning(cyapa);
+	if (ret || calibrate_ret)
+		return ret ? ret : calibrate_ret;
+
+	return count;
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
+	int ret;
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
+	int tmp_max, tmp_min, tmp_ave, tmp_sum, tmp_count, tmp_max_elements;
+	int electrodes_rx;
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
+	electrodes_rx = 0;
+	tmp_max_elements = 0;
+	if (*data_size == 0) {
+		/*
+		 * Read global idac values firstly.
+		 * Currently, no idac data exceed 4 bytes.
+		 */
+		read_global_idac = true;
+		offset = 0;
+		*data_size = 4;
+
+		if (idac_data_type == GEN5_RETRIEVE_MUTUAL_PWC_DATA) {
+			if (cyapa->electrodes_rx == 0) {
+				if (cyapa->electrodes_y > cyapa->electrodes_x) {
+					electrodes_rx = cyapa->electrodes_y;
+					tmp_max_elements = cyapa->electrodes_x;
+				} else {
+					electrodes_rx =	cyapa->electrodes_x;
+					tmp_max_elements = cyapa->electrodes_y;
+				}
+			} else {
+				electrodes_rx = cyapa->electrodes_rx;
+				tmp_max_elements = 0;  /* Disable Rx detect. */
+			}
+			max_element_cnt = ((electrodes_rx + 7) / 8) * 8;
+			tmp_max = INT_MIN;
+			tmp_min = INT_MAX;
+			tmp_ave = tmp_sum = tmp_count = 0;
+		} else
+			max_element_cnt = 2;
+	} else {
+		read_global_idac = false;
+		if (*data_size > 4)
+			*data_size = 4;
+		/* Calculate the start offset in bytes of local PWC data. */
+		if (idac_data_type == GEN5_RETRIEVE_MUTUAL_PWC_DATA) {
+			offset = ((cyapa->electrodes_rx + 7) / 8) * 8
+						* (*data_size);
+			if (cyapa->electrodes_rx == cyapa->electrodes_x)
+				tmp_count = cyapa->electrodes_y;
+			else
+				tmp_count = cyapa->electrodes_x;
+			max_element_cnt = ((cyapa->electrodes_rx + 7) / 8) *
+						8 * tmp_count;
+		} else if (idac_data_type == GEN5_RETRIEVE_SELF_CAP_PWC_DATA) {
+			offset = 2;
+			max_element_cnt = cyapa->electrodes_x +
+						cyapa->electrodes_y;
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
+		ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+				cmd, 12,
+				resp_data, &resp_len,
+				500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+		if (ret || resp_len < 10 ||
+				!VALID_CMD_RESP_HEADER(resp_data, cmd_code) ||
+				!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]) ||
+				resp_data[6] != idac_data_type)
+			return (ret < 0) ? ret : -EAGAIN;
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
+				tmp_count < tmp_max_elements &&
+				read_global_idac) {
+				tmp_min = min(value, tmp_min);
+				tmp_max = max(value, tmp_max);
+				tmp_sum += value;
+				tmp_count++;
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
+		/* Algorithm to detect electrodes_rx value. */
+		tmp_ave = tmp_sum / tmp_count;
+		tmp_count = tmp_ave * 15 / 100;
+		if (abs(tmp_ave - *idac_ave) > tmp_count ||
+			(abs(tmp_ave - *idac_min) > (tmp_count * 2) &&
+				*idac_min < tmp_min) ||
+			(abs(*idac_max - tmp_ave) > (tmp_count * 2) &&
+				*idac_max > tmp_max)) {
+			/* Overcount the mutual global idac values. */
+			cyapa->electrodes_rx = tmp_max_elements;
+			*idac_min = tmp_min;
+			*idac_max = tmp_max;
+			*idac_ave = tmp_ave;
+		} else
+			cyapa->electrodes_rx = electrodes_rx;
+	}
+
+	return 0;
+}
+
+static int cyapa_gen5_read_mutual_idac_data(struct cyapa *cyapa,
+	int *gidac_mutual_max, int *gidac_mutual_min, int *gidac_mutual_ave,
+	int *lidac_mutual_max, int *lidac_mutual_min, int *lidac_mutual_ave)
+{
+	int ret;
+	int data_size;
+
+	*gidac_mutual_max = *gidac_mutual_min = *gidac_mutual_ave = 0;
+	*lidac_mutual_max = *lidac_mutual_min = *lidac_mutual_ave = 0;
+
+	data_size = 0;
+	ret = cyapa_gen5_read_idac_data(cyapa,
+		GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+		GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+		&data_size,
+		gidac_mutual_max, gidac_mutual_min, gidac_mutual_ave);
+	if (ret)
+		return ret;
+
+	ret = cyapa_gen5_read_idac_data(cyapa,
+		GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+		GEN5_RETRIEVE_MUTUAL_PWC_DATA,
+		&data_size,
+		lidac_mutual_max, lidac_mutual_min, lidac_mutual_ave);
+	return ret;
+}
+
+static int cyapa_gen5_read_self_idac_data(struct cyapa *cyapa,
+		int *gidac_self_rx, int *gidac_self_tx,
+		int *lidac_self_max, int *lidac_self_min, int *lidac_self_ave)
+{
+	int ret;
+	int data_size;
+
+	*gidac_self_rx = *gidac_self_tx = 0;
+	*lidac_self_max = *lidac_self_min = *lidac_self_ave = 0;
+
+	data_size = 0;
+	ret = cyapa_gen5_read_idac_data(cyapa,
+		GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+		GEN5_RETRIEVE_SELF_CAP_PWC_DATA,
+		&data_size,
+		lidac_self_max, lidac_self_min, lidac_self_ave);
+	if (ret)
+		return ret;
+	*gidac_self_rx = *lidac_self_max;
+	*gidac_self_tx = *lidac_self_min;
+
+	ret = cyapa_gen5_read_idac_data(cyapa,
+		GEN5_CMD_RETRIEVE_DATA_STRUCTURE,
+		GEN5_RETRIEVE_SELF_CAP_PWC_DATA,
+		&data_size,
+		lidac_self_max, lidac_self_min, lidac_self_ave);
+	return ret;
+}
+
+static ssize_t cyapa_gen5_execute_panel_scan(struct cyapa *cyapa)
+{
+	int ret;
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
+	ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, 7,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+	if (ret || resp_len != 6 ||
+			!VALID_CMD_RESP_HEADER(resp_data,
+				GEN5_CMD_EXECUTE_PANEL_SCAN) ||
+			!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5])) {
+		cyapa_gen5_resume_scanning(cyapa);
+		return (ret < 0) ? ret : -EAGAIN;
+	}
+
+	return 0;
+}
+
+static int cyapa_gen5_read_panel_scan_raw_data(struct cyapa *cyapa,
+		u8 cmd_code, u8 raw_data_type, int raw_data_max_num,
+		int *raw_data_max, int *raw_data_min, int *raw_data_ave,
+		u8 *buffer)
+{
+	int ret;
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
+		ret = cyapa_i2c_pip_cmd_irq_sync(cyapa,
+			cmd, 12,
+			resp_data, &resp_len,
+			500, cyapa_gen5_sort_tsg_pip_app_resp_data);
+		if (ret || resp_len < 10 ||
+				!VALID_CMD_RESP_HEADER(resp_data, cmd_code) ||
+				!GEN5_CMD_COMPLETE_SUCCESS(resp_data[5]) ||
+				resp_data[6] != raw_data_type)
+			return (ret < 0) ? ret : -EAGAIN;
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
+	int ret, err;
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
+
+	if (cyapa->state != CYAPA_STATE_GEN5_APP)
+		return -EBUSY;
+
+	/* 1. Suspend Scanning*/
+	ret = cyapa_gen5_suspend_scanning(cyapa);
+	if (ret)
+		return ret;
+
+	/* 2.  Read global and local mutual IDAC data. */
+	gidac_self_rx = gidac_self_tx = 0;
+	err = cyapa_gen5_read_mutual_idac_data(cyapa,
+				&gidac_mutual_max, &gidac_mutual_min,
+				&gidac_mutual_ave, &lidac_mutual_max,
+				&lidac_mutual_min, &lidac_mutual_ave);
+	if (err)
+		goto resume_scanning;
+
+	/* 3.  Read global and local self IDAC data. */
+	err = cyapa_gen5_read_self_idac_data(cyapa,
+				&gidac_self_rx, &gidac_self_tx,
+				&lidac_self_max, &lidac_self_min,
+				&lidac_self_ave);
+	if (err)
+		goto resume_scanning;
+
+	/* 4. Execuate panel scan. It must be executed before read data. */
+	err = cyapa_gen5_execute_panel_scan(cyapa);
+	if (err)
+		goto resume_scanning;
+
+	/* 5. Retrive panel scan, mutual cap raw data. */
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_MUTUAL_RAW_DATA,
+				cyapa->electrodes_x * cyapa->electrodes_y,
+				&raw_cap_mutual_max, &raw_cap_mutual_min,
+				&raw_cap_mutual_ave,
+				NULL);
+	if (err)
+		goto resume_scanning;
+
+	/* 6. Retrive panel scan, self cap raw data. */
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_SELF_RAW_DATA,
+				cyapa->electrodes_x + cyapa->electrodes_y,
+				&raw_cap_self_max, &raw_cap_self_min,
+				&raw_cap_self_ave,
+				NULL);
+	if (err)
+		goto resume_scanning;
+
+	/* 7. Retrive panel scan, mutual cap diffcount raw data. */
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_MUTUAL_DIFFCOUNT,
+				cyapa->electrodes_x * cyapa->electrodes_y,
+				&mutual_diffdata_max, &mutual_diffdata_min,
+				&mutual_diffdata_ave,
+				NULL);
+	if (err)
+		goto resume_scanning;
+
+	/* 8. Retrive panel scan, self cap diffcount raw data. */
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_SELF_DIFFCOUNT,
+				cyapa->electrodes_x + cyapa->electrodes_y,
+				&self_diffdata_max, &self_diffdata_min,
+				&self_diffdata_ave,
+				NULL);
+	if (err)
+		goto resume_scanning;
+
+	/* 9. Retrive panel scan, mutual cap baseline raw data. */
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_MUTUAL_BASELINE,
+				cyapa->electrodes_x * cyapa->electrodes_y,
+				&mutual_baseline_max, &mutual_baseline_min,
+				&mutual_baseline_ave,
+				NULL);
+	if (err)
+		goto resume_scanning;
+
+	/* 10. Retrive panel scan, self cap baseline raw data. */
+	err = cyapa_gen5_read_panel_scan_raw_data(cyapa,
+				GEN5_CMD_RETRIEVE_PANEL_SCAN,
+				GEN5_PANEL_SCAN_SELF_BASELINE,
+				cyapa->electrodes_x + cyapa->electrodes_y,
+				&self_baseline_max, &self_baseline_min,
+				&self_baseline_ave,
+				NULL);
+	if (err)
+		goto resume_scanning;
+
+resume_scanning:
+	/* 11. Resume Scanning*/
+	ret = cyapa_gen5_resume_scanning(cyapa);
+	if (ret || err)
+		return ret ? ret : err;
+
+	/* 12. Output data strings */
+	ret = scnprintf(buf, PAGE_SIZE, "%d %d %d %d %d %d %d %d %d %d %d ",
+		gidac_mutual_min, gidac_mutual_max, gidac_mutual_ave,
+		lidac_mutual_min, lidac_mutual_max, lidac_mutual_ave,
+		gidac_self_rx, gidac_self_tx,
+		lidac_self_min, lidac_self_max, lidac_self_ave);
+	err = scnprintf(buf + ret, PAGE_SIZE - ret,
+		"%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n",
+		raw_cap_mutual_min, raw_cap_mutual_max, raw_cap_mutual_ave,
+		raw_cap_self_min, raw_cap_self_max, raw_cap_self_ave,
+		mutual_diffdata_min, mutual_diffdata_max, mutual_diffdata_ave,
+		self_diffdata_min, self_diffdata_max, self_diffdata_ave,
+		mutual_baseline_min, mutual_baseline_max, mutual_baseline_ave,
+		self_baseline_min, self_baseline_max, self_baseline_ave);
+	return ret + err;
+}
+
 static bool cyapa_gen5_sort_system_info_data(struct cyapa *cyapa,
 		u8 *buf, int len)
 {
@@ -1941,6 +2608,9 @@ const struct cyapa_dev_ops cyapa_gen5_ops = {
 	.bl_initiate = cyapa_gen5_bl_initiate,
 	.update_fw = cyapa_gen5_do_fw_update,
 
+	.show_baseline = cyapa_gen5_show_baseline,
+	.calibrate_store = cyapa_gen5_do_calibrate,
+
 	.initialize = cyapa_gen5_initialize,
 	.uninitialize = cyapa_gen5_uninitialize,
 
-- 
1.9.1


