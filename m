Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965048AbaCSNLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:11:02 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:50159 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964956AbaCSNK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:10:58 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Fugang Duan <B38611@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Simon Budig <simon.budig@kernelconcepts.de>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCHv4 5/5] Input: edt-ft5x06: Add support for M09 firmware version
Date: Wed, 19 Mar 2014 14:09:23 +0100
Message-Id: <1395234563-11034-6-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
References: <1395234563-11034-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new firmware version for the EDT-FT5x06 chip.
Add support for detecting the firmware version and handle the
differences appropriately.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/input/touchscreen/edt-ft5x06.c |  360 ++++++++++++++++++++++++--------
 1 file changed, 277 insertions(+), 83 deletions(-)

diff --git a/drivers/input/touchscreen/edt-ft5x06.c b/drivers/input/touchscreen/edt-ft5x06.c
index af736e4..acdda82 100644
--- a/drivers/input/touchscreen/edt-ft5x06.c
+++ b/drivers/input/touchscreen/edt-ft5x06.c
@@ -46,6 +46,14 @@
 #define WORK_REGISTER_NUM_X		0x33
 #define WORK_REGISTER_NUM_Y		0x34
 
+#define M09_REGISTER_THRESHOLD		0x80
+#define M09_REGISTER_GAIN		0x92
+#define M09_REGISTER_OFFSET		0x93
+#define M09_REGISTER_NUM_X		0x94
+#define M09_REGISTER_NUM_Y		0x95
+
+#define NO_REGISTER			0xff
+
 #define WORK_REGISTER_OPMODE		0x3c
 #define FACTORY_REGISTER_OPMODE		0x01
 
@@ -60,6 +68,20 @@
 #define EDT_RAW_DATA_RETRIES		100
 #define EDT_RAW_DATA_DELAY		1 /* msec */
 
+enum edt_ver {
+	M06,
+	M09,
+};
+
+struct edt_reg_addr {
+	int reg_threshold;
+	int reg_report_rate;
+	int reg_gain;
+	int reg_offset;
+	int reg_num_x;
+	int reg_num_y;
+};
+
 struct edt_ft5x06_ts_data {
 	struct i2c_client *client;
 	struct input_dev *input;
@@ -84,6 +106,9 @@ struct edt_ft5x06_ts_data {
 	int report_rate;
 
 	char name[EDT_NAME_LEN];
+
+	struct edt_reg_addr reg_addr;
+	enum edt_ver version;
 };
 
 static int edt_ft5x06_ts_readwrite(struct i2c_client *client,
@@ -141,33 +166,58 @@ static irqreturn_t edt_ft5x06_ts_isr(int irq, void *dev_id)
 {
 	struct edt_ft5x06_ts_data *tsdata = dev_id;
 	struct device *dev = &tsdata->client->dev;
-	u8 cmd = 0xf9;
-	u8 rdbuf[26];
+	u8 cmd;
+	u8 rdbuf[29];
 	int i, type, x, y, id;
+	int offset, tplen, datalen;
 	int error;
 
+	switch (tsdata->version) {
+	case M06:
+		cmd = 0xf9; /* tell the controller to send touch data */
+		offset = 5; /* where the actual touch data starts */
+		tplen = 4;  /* data comes in so called frames */
+		datalen = 26; /* how much bytes to listen for */
+		break;
+
+	case M09:
+		cmd = 0x02;
+		offset = 1;
+		tplen = 6;
+		datalen = 29;
+		break;
+
+	default:
+		goto out;
+	}
+
 	memset(rdbuf, 0, sizeof(rdbuf));
 
 	error = edt_ft5x06_ts_readwrite(tsdata->client,
 					sizeof(cmd), &cmd,
-					sizeof(rdbuf), rdbuf);
+					datalen, rdbuf);
 	if (error) {
 		dev_err_ratelimited(dev, "Unable to fetch data, error: %d\n",
 				    error);
 		goto out;
 	}
 
-	if (rdbuf[0] != 0xaa || rdbuf[1] != 0xaa || rdbuf[2] != 26) {
-		dev_err_ratelimited(dev, "Unexpected header: %02x%02x%02x!\n",
-				    rdbuf[0], rdbuf[1], rdbuf[2]);
-		goto out;
-	}
+	/* M09 does not send header or CRC */
+	if (tsdata->version == M06) {
+		if (rdbuf[0] != 0xaa || rdbuf[1] != 0xaa ||
+			rdbuf[2] != datalen) {
+			dev_err_ratelimited(dev,
+					"Unexpected header: %02x%02x%02x!\n",
+					rdbuf[0], rdbuf[1], rdbuf[2]);
+			goto out;
+		}
 
-	if (!edt_ft5x06_ts_check_crc(tsdata, rdbuf, 26))
-		goto out;
+		if (!edt_ft5x06_ts_check_crc(tsdata, rdbuf, datalen))
+			goto out;
+	}
 
 	for (i = 0; i < MAX_SUPPORT_POINTS; i++) {
-		u8 *buf = &rdbuf[i * 4 + 5];
+		u8 *buf = &rdbuf[i * tplen + offset];
 		bool down;
 
 		type = buf[0] >> 6;
@@ -175,8 +225,8 @@ static irqreturn_t edt_ft5x06_ts_isr(int irq, void *dev_id)
 		if (type == TOUCH_EVENT_RESERVED)
 			continue;
 
-		/* ignore TOUCH_DOWN events, might have bogus coordinates */
-		if (type == TOUCH_EVENT_DOWN)
+		/* M06 sometimes sends bogus coordinates in TOUCH_DOWN */
+		if (tsdata->version == M06 && type == TOUCH_EVENT_DOWN)
 			continue;
 
 		x = ((buf[0] << 8) | buf[1]) & 0x0fff;
@@ -206,12 +256,25 @@ static int edt_ft5x06_register_write(struct edt_ft5x06_ts_data *tsdata,
 {
 	u8 wrbuf[4];
 
-	wrbuf[0] = tsdata->factory_mode ? 0xf3 : 0xfc;
-	wrbuf[1] = tsdata->factory_mode ? addr & 0x7f : addr & 0x3f;
-	wrbuf[2] = value;
-	wrbuf[3] = wrbuf[0] ^ wrbuf[1] ^ wrbuf[2];
-
-	return edt_ft5x06_ts_readwrite(tsdata->client, 4, wrbuf, 0, NULL);
+	switch (tsdata->version) {
+	case M06:
+		wrbuf[0] = tsdata->factory_mode ? 0xf3 : 0xfc;
+		wrbuf[1] = tsdata->factory_mode ? addr & 0x7f : addr & 0x3f;
+		wrbuf[1] = tsdata->factory_mode ? addr & 0x7f : addr & 0x3f;
+		wrbuf[2] = value;
+		wrbuf[3] = wrbuf[0] ^ wrbuf[1] ^ wrbuf[2];
+		return edt_ft5x06_ts_readwrite(tsdata->client, 4,
+					wrbuf, 0, NULL);
+	case M09:
+		wrbuf[0] = addr;
+		wrbuf[1] = value;
+
+		return edt_ft5x06_ts_readwrite(tsdata->client, 3,
+					wrbuf, 0, NULL);
+
+	default:
+		return -EINVAL;
+	}
 }
 
 static int edt_ft5x06_register_read(struct edt_ft5x06_ts_data *tsdata,
@@ -220,19 +283,35 @@ static int edt_ft5x06_register_read(struct edt_ft5x06_ts_data *tsdata,
 	u8 wrbuf[2], rdbuf[2];
 	int error;
 
-	wrbuf[0] = tsdata->factory_mode ? 0xf3 : 0xfc;
-	wrbuf[1] = tsdata->factory_mode ? addr & 0x7f : addr & 0x3f;
-	wrbuf[1] |= tsdata->factory_mode ? 0x80 : 0x40;
+	switch (tsdata->version) {
+	case M06:
+		wrbuf[0] = tsdata->factory_mode ? 0xf3 : 0xfc;
+		wrbuf[1] = tsdata->factory_mode ? addr & 0x7f : addr & 0x3f;
+		wrbuf[1] |= tsdata->factory_mode ? 0x80 : 0x40;
 
-	error = edt_ft5x06_ts_readwrite(tsdata->client, 2, wrbuf, 2, rdbuf);
-	if (error)
+		error = edt_ft5x06_ts_readwrite(tsdata->client,
+						2, wrbuf, 2, rdbuf);
 		return error;
 
-	if ((wrbuf[0] ^ wrbuf[1] ^ rdbuf[0]) != rdbuf[1]) {
-		dev_err(&tsdata->client->dev,
-			"crc error: 0x%02x expected, got 0x%02x\n",
-			wrbuf[0] ^ wrbuf[1] ^ rdbuf[0], rdbuf[1]);
-		return -EIO;
+		if ((wrbuf[0] ^ wrbuf[1] ^ rdbuf[0]) != rdbuf[1]) {
+			dev_err(&tsdata->client->dev,
+				"crc error: 0x%02x expected, got 0x%02x\n",
+				wrbuf[0] ^ wrbuf[1] ^ rdbuf[0],
+				rdbuf[1]);
+			return -EIO;
+		}
+		break;
+
+	case M09:
+		wrbuf[0] = addr;
+		error = edt_ft5x06_ts_readwrite(tsdata->client, 1,
+						wrbuf, 1, rdbuf);
+		if (error)
+			return error;
+		break;
+
+	default:
+		return -EINVAL;
 	}
 
 	return rdbuf[0];
@@ -243,19 +322,21 @@ struct edt_ft5x06_attribute {
 	size_t field_offset;
 	u8 limit_low;
 	u8 limit_high;
-	u8 addr;
+	u8 addr_m06;
+	u8 addr_m09;
 };
 
-#define EDT_ATTR(_field, _mode, _addr, _limit_low, _limit_high)		\
+#define EDT_ATTR(_field, _mode, _addr_m06, _addr_m09,			\
+		_limit_low, _limit_high)				\
 	struct edt_ft5x06_attribute edt_ft5x06_attr_##_field = {	\
 		.dattr = __ATTR(_field, _mode,				\
 				edt_ft5x06_setting_show,		\
 				edt_ft5x06_setting_store),		\
-		.field_offset =						\
-			offsetof(struct edt_ft5x06_ts_data, _field),	\
+		.field_offset = offsetof(struct edt_ft5x06_ts_data, _field), \
+		.addr_m06 = _addr_m06,					\
+		.addr_m09 = _addr_m09,					\
 		.limit_low = _limit_low,				\
 		.limit_high = _limit_high,				\
-		.addr = _addr,						\
 	}
 
 static ssize_t edt_ft5x06_setting_show(struct device *dev,
@@ -270,6 +351,7 @@ static ssize_t edt_ft5x06_setting_show(struct device *dev,
 	int val;
 	size_t count = 0;
 	int error = 0;
+	u8 addr;
 
 	mutex_lock(&tsdata->mutex);
 
@@ -278,15 +360,33 @@ static ssize_t edt_ft5x06_setting_show(struct device *dev,
 		goto out;
 	}
 
-	val = edt_ft5x06_register_read(tsdata, attr->addr);
-	if (val < 0) {
-		error = val;
-		dev_err(&tsdata->client->dev,
-			"Failed to fetch attribute %s, error %d\n",
-			dattr->attr.name, error);
+	switch (tsdata->version) {
+	case M06:
+		addr = attr->addr_m06;
+		break;
+
+	case M09:
+		addr = attr->addr_m09;
+		break;
+
+	default:
+		error = -ENODEV;
 		goto out;
 	}
 
+	if (addr != NO_REGISTER) {
+		val = edt_ft5x06_register_read(tsdata, addr);
+		if (val < 0) {
+			error = val;
+			dev_err(&tsdata->client->dev,
+				"Failed to fetch attribute %s, error %d\n",
+				dattr->attr.name, error);
+			goto out;
+		}
+	} else {
+		val = *field;
+	}
+
 	if (val != *field) {
 		dev_warn(&tsdata->client->dev,
 			 "%s: read (%d) and stored value (%d) differ\n",
@@ -311,6 +411,7 @@ static ssize_t edt_ft5x06_setting_store(struct device *dev,
 	u8 *field = (u8 *)tsdata + attr->field_offset;
 	unsigned int val;
 	int error;
+	u8 addr;
 
 	mutex_lock(&tsdata->mutex);
 
@@ -328,14 +429,29 @@ static ssize_t edt_ft5x06_setting_store(struct device *dev,
 		goto out;
 	}
 
-	error = edt_ft5x06_register_write(tsdata, attr->addr, val);
-	if (error) {
-		dev_err(&tsdata->client->dev,
-			"Failed to update attribute %s, error: %d\n",
-			dattr->attr.name, error);
+	switch (tsdata->version) {
+	case M06:
+		addr = attr->addr_m06;
+		break;
+
+	case M09:
+		addr = attr->addr_m09;
+		break;
+
+	default:
+		error = -ENODEV;
 		goto out;
 	}
 
+	if (addr != NO_REGISTER) {
+		error = edt_ft5x06_register_write(tsdata, addr, val);
+		if (error) {
+			dev_err(&tsdata->client->dev,
+				"Failed to update attribute %s, error: %d\n",
+				dattr->attr.name, error);
+			goto out;
+		}
+	}
 	*field = val;
 
 out:
@@ -343,12 +459,14 @@ out:
 	return error ?: count;
 }
 
-static EDT_ATTR(gain, S_IWUSR | S_IRUGO, WORK_REGISTER_GAIN, 0, 31);
-static EDT_ATTR(offset, S_IWUSR | S_IRUGO, WORK_REGISTER_OFFSET, 0, 31);
-static EDT_ATTR(threshold, S_IWUSR | S_IRUGO,
-		WORK_REGISTER_THRESHOLD, 20, 80);
-static EDT_ATTR(report_rate, S_IWUSR | S_IRUGO,
-		WORK_REGISTER_REPORT_RATE, 3, 14);
+static EDT_ATTR(gain, S_IWUSR | S_IRUGO, WORK_REGISTER_GAIN,
+		M09_REGISTER_GAIN, 0, 31);
+static EDT_ATTR(offset, S_IWUSR | S_IRUGO, WORK_REGISTER_OFFSET,
+		M09_REGISTER_OFFSET, 0, 31);
+static EDT_ATTR(threshold, S_IWUSR | S_IRUGO, WORK_REGISTER_THRESHOLD,
+		M09_REGISTER_THRESHOLD, 20, 80);
+static EDT_ATTR(report_rate, S_IWUSR | S_IRUGO, WORK_REGISTER_REPORT_RATE,
+		NO_REGISTER, 3, 14);
 
 static struct attribute *edt_ft5x06_attrs[] = {
 	&edt_ft5x06_attr_gain.dattr.attr,
@@ -383,6 +501,9 @@ static int edt_ft5x06_factory_mode(struct edt_ft5x06_ts_data *tsdata)
 	}
 
 	/* mode register is 0x3c when in the work mode */
+	if (tsdata->version == M09)
+		goto m09_out;
+
 	error = edt_ft5x06_register_write(tsdata, WORK_REGISTER_OPMODE, 0x03);
 	if (error) {
 		dev_err(&client->dev,
@@ -415,12 +536,18 @@ err_out:
 	enable_irq(client->irq);
 
 	return error;
+
+m09_out:
+	dev_err(&client->dev, "No factory mode support for M09\n");
+	return -EINVAL;
+
 }
 
 static int edt_ft5x06_work_mode(struct edt_ft5x06_ts_data *tsdata)
 {
 	struct i2c_client *client = tsdata->client;
 	int retries = EDT_SWITCH_MODE_RETRIES;
+	struct edt_reg_addr *reg_addr = &tsdata->reg_addr;
 	int ret;
 	int error;
 
@@ -453,13 +580,14 @@ static int edt_ft5x06_work_mode(struct edt_ft5x06_ts_data *tsdata)
 	tsdata->raw_buffer = NULL;
 
 	/* restore parameters */
-	edt_ft5x06_register_write(tsdata, WORK_REGISTER_THRESHOLD,
+	edt_ft5x06_register_write(tsdata, reg_addr->reg_threshold,
 				  tsdata->threshold);
-	edt_ft5x06_register_write(tsdata, WORK_REGISTER_GAIN,
+	edt_ft5x06_register_write(tsdata, reg_addr->reg_gain,
 				  tsdata->gain);
-	edt_ft5x06_register_write(tsdata, WORK_REGISTER_OFFSET,
+	edt_ft5x06_register_write(tsdata, reg_addr->reg_offset,
 				  tsdata->offset);
-	edt_ft5x06_register_write(tsdata, WORK_REGISTER_REPORT_RATE,
+	if (reg_addr->reg_report_rate)
+		edt_ft5x06_register_write(tsdata, reg_addr->reg_report_rate,
 				  tsdata->report_rate);
 
 	enable_irq(client->irq);
@@ -665,30 +793,60 @@ static int edt_ft5x06_ts_reset(struct i2c_client *client,
 }
 
 static int edt_ft5x06_ts_identify(struct i2c_client *client,
-					    char *model_name,
-					    char *fw_version)
+					struct edt_ft5x06_ts_data *tsdata,
+					char *fw_version)
 {
 	u8 rdbuf[EDT_NAME_LEN];
 	char *p;
 	int error;
+	char *model_name = tsdata->name;
 
+	/* see what we find if we assume it is a M06 *
+	 * if we get less than EDT_NAME_LEN, we don't want
+	 * to have garbage in there
+	 */
+	memset(rdbuf, 0, sizeof(rdbuf));
 	error = edt_ft5x06_ts_readwrite(client, 1, "\xbb",
 					EDT_NAME_LEN - 1, rdbuf);
 	if (error)
 		return error;
 
-	/* remove last '$' end marker */
-	rdbuf[EDT_NAME_LEN - 1] = '\0';
-	if (rdbuf[EDT_NAME_LEN - 2] == '$')
-		rdbuf[EDT_NAME_LEN - 2] = '\0';
+	/* if we find something consistent, stay with that assumption
+	 * at least M09 won't send 3 bytes here
+	 */
+	if (!(strnicmp(rdbuf + 1, "EP0", 3))) {
+		tsdata->version = M06;
+
+		/* remove last '$' end marker */
+		rdbuf[EDT_NAME_LEN - 1] = '\0';
+		if (rdbuf[EDT_NAME_LEN - 2] == '$')
+			rdbuf[EDT_NAME_LEN - 2] = '\0';
+
+		/* look for Model/Version separator */
+		p = strchr(rdbuf, '*');
+		if (p)
+			*p++ = '\0';
+		strlcpy(model_name, rdbuf + 1, EDT_NAME_LEN);
+		strlcpy(fw_version, p ? p : "", EDT_NAME_LEN);
+	} else {
+		/* since there are only two versions around (M06, M09) */
+		tsdata->version = M09;
+
+		error = edt_ft5x06_ts_readwrite(client, 1, "\xA6",
+						2, rdbuf);
+		if (error)
+			return error;
 
-	/* look for Model/Version separator */
-	p = strchr(rdbuf, '*');
-	if (p)
-		*p++ = '\0';
+		strlcpy(fw_version, rdbuf, 2);
 
-	strlcpy(model_name, rdbuf + 1, EDT_NAME_LEN);
-	strlcpy(fw_version, p ? p : "", EDT_NAME_LEN);
+		error = edt_ft5x06_ts_readwrite(client, 1, "\xA8",
+						1, rdbuf);
+		if (error)
+			return error;
+
+		snprintf(model_name, EDT_NAME_LEN, "EP0%i%i0M09",
+			rdbuf[0] >> 4, rdbuf[0] & 0x0F);
+	}
 
 	return 0;
 }
@@ -707,37 +865,71 @@ static int edt_ft5x06_ts_identify(struct i2c_client *client,
 static void edt_ft5x06_ts_get_dt_defaults(struct device_node *np,
 					struct edt_ft5x06_ts_data *tsdata)
 {
-	EDT_GET_PROP(threshold, WORK_REGISTER_THRESHOLD);
-	EDT_GET_PROP(gain, WORK_REGISTER_GAIN);
-	EDT_GET_PROP(offset, WORK_REGISTER_OFFSET);
-	EDT_GET_PROP(report_rate, WORK_REGISTER_REPORT_RATE);
+	struct edt_reg_addr *reg_addr = &tsdata->reg_addr;
+
+	EDT_GET_PROP(threshold, reg_addr->reg_threshold);
+	EDT_GET_PROP(gain, reg_addr->reg_gain);
+	EDT_GET_PROP(offset, reg_addr->reg_offset);
+	if (reg_addr->reg_report_rate != NO_REGISTER)
+		EDT_GET_PROP(report_rate, reg_addr->reg_report_rate);
 }
 
 static void
 edt_ft5x06_ts_get_defaults(struct edt_ft5x06_ts_data *tsdata,
 			   const struct edt_ft5x06_platform_data *pdata)
 {
+	struct edt_reg_addr *reg_addr = &tsdata->reg_addr;
+
 	if (!pdata->use_parameters)
 		return;
 
 	/* pick up defaults from the platform data */
-	EDT_ATTR_CHECKSET(threshold, WORK_REGISTER_THRESHOLD);
-	EDT_ATTR_CHECKSET(gain, WORK_REGISTER_GAIN);
-	EDT_ATTR_CHECKSET(offset, WORK_REGISTER_OFFSET);
-	EDT_ATTR_CHECKSET(report_rate, WORK_REGISTER_REPORT_RATE);
+	EDT_ATTR_CHECKSET(threshold, reg_addr->reg_threshold);
+	EDT_ATTR_CHECKSET(gain, reg_addr->reg_gain);
+	EDT_ATTR_CHECKSET(offset, reg_addr->reg_offset);
+	if (reg_addr->reg_report_rate != NO_REGISTER)
+		EDT_ATTR_CHECKSET(report_rate, reg_addr->reg_report_rate);
 }
 
 static void
 edt_ft5x06_ts_get_parameters(struct edt_ft5x06_ts_data *tsdata)
 {
+	struct edt_reg_addr *reg_addr = &tsdata->reg_addr;
+
 	tsdata->threshold = edt_ft5x06_register_read(tsdata,
-						     WORK_REGISTER_THRESHOLD);
-	tsdata->gain = edt_ft5x06_register_read(tsdata, WORK_REGISTER_GAIN);
-	tsdata->offset = edt_ft5x06_register_read(tsdata, WORK_REGISTER_OFFSET);
-	tsdata->report_rate = edt_ft5x06_register_read(tsdata,
-						WORK_REGISTER_REPORT_RATE);
-	tsdata->num_x = edt_ft5x06_register_read(tsdata, WORK_REGISTER_NUM_X);
-	tsdata->num_y = edt_ft5x06_register_read(tsdata, WORK_REGISTER_NUM_Y);
+						     reg_addr->reg_threshold);
+	tsdata->gain = edt_ft5x06_register_read(tsdata, reg_addr->reg_gain);
+	tsdata->offset = edt_ft5x06_register_read(tsdata, reg_addr->reg_offset);
+	if (reg_addr->reg_report_rate != NO_REGISTER)
+		tsdata->report_rate = edt_ft5x06_register_read(tsdata,
+						reg_addr->reg_report_rate);
+	tsdata->num_x = edt_ft5x06_register_read(tsdata, reg_addr->reg_num_x);
+	tsdata->num_y = edt_ft5x06_register_read(tsdata, reg_addr->reg_num_y);
+}
+
+static void
+edt_ft5x06_ts_set_regs(struct edt_ft5x06_ts_data *tsdata)
+{
+	struct edt_reg_addr *reg_addr = &tsdata->reg_addr;
+
+	switch (tsdata->version) {
+	case M06:
+		reg_addr->reg_threshold = WORK_REGISTER_THRESHOLD;
+		reg_addr->reg_report_rate = WORK_REGISTER_REPORT_RATE;
+		reg_addr->reg_gain = WORK_REGISTER_GAIN;
+		reg_addr->reg_offset = WORK_REGISTER_OFFSET;
+		reg_addr->reg_num_x = WORK_REGISTER_NUM_X;
+		reg_addr->reg_num_y = WORK_REGISTER_NUM_Y;
+		break;
+
+	case M09:
+		reg_addr->reg_threshold = M09_REGISTER_THRESHOLD;
+		reg_addr->reg_gain = M09_REGISTER_GAIN;
+		reg_addr->reg_offset = M09_REGISTER_OFFSET;
+		reg_addr->reg_num_x = M09_REGISTER_NUM_X;
+		reg_addr->reg_num_y = M09_REGISTER_NUM_Y;
+		break;
+	}
 }
 
 #ifdef CONFIG_OF
@@ -824,12 +1016,14 @@ static int edt_ft5x06_ts_probe(struct i2c_client *client,
 	tsdata->input = input;
 	tsdata->factory_mode = false;
 
-	error = edt_ft5x06_ts_identify(client, tsdata->name, fw_version);
+	error = edt_ft5x06_ts_identify(client, tsdata, fw_version);
 	if (error) {
 		dev_err(&client->dev, "touchscreen probe failed\n");
 		return error;
 	}
 
+	edt_ft5x06_ts_set_regs(tsdata);
+
 	if (!pdata)
 		edt_ft5x06_ts_get_dt_defaults(client->dev.of_node, tsdata);
 	else
-- 
1.7.10.4

