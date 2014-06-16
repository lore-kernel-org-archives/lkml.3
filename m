Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576AbaFPWaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:30:35 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61155 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001AbaFPWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:30:25 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH v3 3/3] iio: hid-sensor-magn-3d: Add support for rotation from north usage attributes
Date: Mon, 16 Jun 2014 17:30:03 -0500
Message-Id: <1402957803-5154-4-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402957803-5154-1-git-send-email-reyad.attiyat@gmail.com>
References: <1402957803-5154-1-git-send-email-reyad.attiyat@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the ability for this driver to scan for a range of hid usage attributes.
This allows for dynamic creation of iio channels such as rotation from north
and/or magnetic flux axises (X, Y, Z).

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 drivers/iio/magnetometer/hid-sensor-magn-3d.c | 394 +++++++++++++++++---------
 1 file changed, 266 insertions(+), 128 deletions(-)

diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
index 41cf29e..73e1272 100644
--- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
+++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
@@ -35,6 +35,10 @@ enum magn_3d_channel {
 	CHANNEL_SCAN_INDEX_X,
 	CHANNEL_SCAN_INDEX_Y,
 	CHANNEL_SCAN_INDEX_Z,
+	CHANNEL_SCAN_INDEX_NORTH_MAGN,
+	CHANNEL_SCAN_INDEX_NORTH_TRUE,
+	CHANNEL_SCAN_INDEX_NORTH_MAGN_TILT_COMP,
+	CHANNEL_SCAN_INDEX_NORTH_TRUE_TILT_COMP,
 	MAGN_3D_CHANNEL_MAX,
 };
 
@@ -42,63 +46,47 @@ struct magn_3d_state {
 	struct hid_sensor_hub_callbacks callbacks;
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info magn[MAGN_3D_CHANNEL_MAX];
-	u32 magn_val[MAGN_3D_CHANNEL_MAX];
+	u32 *magn_val_addr[MAGN_3D_CHANNEL_MAX];
+	u32 *iio_val;
 	int scale_pre_decml;
 	int scale_post_decml;
 	int scale_precision;
 	int value_offset;
 };
 
-static const u32 magn_3d_addresses[MAGN_3D_CHANNEL_MAX] = {
-	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS,
-	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS,
-	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS
-};
 
-/* Channel definitions */
-static const struct iio_chan_spec magn_3d_channels[] = {
-	{
-		.type = IIO_MAGN,
-		.modified = 1,
-		.channel2 = IIO_MOD_X,
-		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
-		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
-		BIT(IIO_CHAN_INFO_SCALE) |
-		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
-		BIT(IIO_CHAN_INFO_HYSTERESIS),
-		.scan_index = CHANNEL_SCAN_INDEX_X,
-	}, {
-		.type = IIO_MAGN,
-		.modified = 1,
-		.channel2 = IIO_MOD_Y,
-		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
-		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
-		BIT(IIO_CHAN_INFO_SCALE) |
-		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
-		BIT(IIO_CHAN_INFO_HYSTERESIS),
-		.scan_index = CHANNEL_SCAN_INDEX_Y,
-	}, {
-		.type = IIO_MAGN,
-		.modified = 1,
-		.channel2 = IIO_MOD_Z,
-		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),
-		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
-		BIT(IIO_CHAN_INFO_SCALE) |
-		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
-		BIT(IIO_CHAN_INFO_HYSTERESIS),
-		.scan_index = CHANNEL_SCAN_INDEX_Z,
+/* Find index into magn_3d_state magn[] and magn_val_addr[] from HID Usage  */
+static int magn_3d_usage_id_to_chan_index(unsigned usage_id){
+	int offset;
+
+	switch (usage_id) {
+	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS:
+		offset = CHANNEL_SCAN_INDEX_X;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS:
+		offset = CHANNEL_SCAN_INDEX_Y;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS:
+		offset = CHANNEL_SCAN_INDEX_Z;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH:
+		offset = CHANNEL_SCAN_INDEX_NORTH_MAGN_TILT_COMP;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH:
+		offset = CHANNEL_SCAN_INDEX_NORTH_TRUE_TILT_COMP;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_MAGN_NORTH:
+		offset = CHANNEL_SCAN_INDEX_NORTH_MAGN;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_TRUE_NORTH:
+		offset = CHANNEL_SCAN_INDEX_NORTH_TRUE;
+		break;
+	default:
+		offset = -EINVAL;
+		break;
 	}
-};
 
-/* Adjust channel real bits based on report descriptor */
-static void magn_3d_adjust_channel_bit_mask(struct iio_chan_spec *channels,
-						int channel, int size)
-{
-	channels[channel].scan_type.sign = 's';
-	/* Real storage bits will change based on the report desc. */
-	channels[channel].scan_type.realbits = size * 8;
-	/* Maximum size of a sample to capture is u32 */
-	channels[channel].scan_type.storagebits = sizeof(u32) * 8;
+	return offset;
 }
 
 /* Channel read_raw handler */
@@ -109,11 +97,14 @@ static int magn_3d_read_raw(struct iio_dev *indio_dev,
 {
 	struct magn_3d_state *magn_state = iio_priv(indio_dev);
 	int report_id = -1;
-	u32 address;
+	unsigned usage_id;
+	int chan_index = -1;
 	int ret;
 	int ret_type;
 	s32 poll_value;
 
+	dev_dbg(&indio_dev->dev, "magn_3d_read_raw\n");
+
 	*val = 0;
 	*val2 = 0;
 	switch (mask) {
@@ -126,13 +117,17 @@ static int magn_3d_read_raw(struct iio_dev *indio_dev,
 		hid_sensor_power_state(&magn_state->common_attributes, true);
 		msleep_interruptible(poll_value * 2);
 
+		usage_id = chan->address;
+		chan_index = magn_3d_usage_id_to_chan_index(usage_id);
+		if (chan_index < 0)
+			return -EINVAL;
+
 		report_id =
-			magn_state->magn[chan->scan_index].report_id;
-		address = magn_3d_addresses[chan->scan_index];
+			magn_state->magn[chan_index].report_id;
 		if (report_id >= 0)
 			*val = sensor_hub_input_attr_get_raw_value(
 				magn_state->common_attributes.hsdev,
-				HID_USAGE_SENSOR_COMPASS_3D, address,
+				HID_USAGE_SENSOR_COMPASS_3D, usage_id,
 				report_id);
 		else {
 			*val = 0;
@@ -221,12 +216,13 @@ static int magn_3d_proc_event(struct hid_sensor_hub_device *hsdev,
 	dev_dbg(&indio_dev->dev, "magn_3d_proc_event\n");
 	if (atomic_read(&magn_state->common_attributes.data_ready))
 		hid_sensor_push_data(indio_dev,
-				magn_state->magn_val,
-				sizeof(magn_state->magn_val));
+				&(magn_state->iio_val),
+				sizeof(magn_state->iio_val));
 
 	return 0;
 }
 
+
 /* Capture samples in local storage */
 static int magn_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 				unsigned usage_id,
@@ -236,51 +232,138 @@ static int magn_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 	struct iio_dev *indio_dev = platform_get_drvdata(priv);
 	struct magn_3d_state *magn_state = iio_priv(indio_dev);
 	int offset;
-	int ret = -EINVAL;
+	u32 *magn_val;
+	int ret = 0;
 
-	switch (usage_id) {
+	offset = magn_3d_usage_id_to_chan_index(usage_id);
+	if (offset < 0)
+		return -EINVAL;
+
+	magn_val = magn_state->magn_val_addr[offset];
+	if (!magn_val)
+		return -EINVAL;
+
+	*(magn_val) =  *(u32 *)raw_data;
+
+	return ret;
+}
+
+/* Setup the iio_chan_spec for HID Usage ID */
+static int magn_3d_setup_iio_chan(unsigned attr_usage_id,
+				s32 size,
+				struct iio_chan_spec *channel)
+{
+
+	channel->modified = 1;
+	channel->address = attr_usage_id;
+
+	switch (attr_usage_id){
+	case HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH:
+		channel->type = IIO_ROT;
+		channel->channel2 = IIO_MOD_NORTH_MAGN_TILT_COMP;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH:
+		channel->type = IIO_ROT;
+		channel->channel2 = IIO_MOD_NORTH_TRUE_TILT_COMP;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_MAGN_NORTH:
+		channel->type = IIO_ROT;
+		channel->channel2 = IIO_MOD_NORTH_MAGN;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_TRUE_NORTH:
+		channel->type = IIO_ROT;
+		channel->channel2 = IIO_MOD_NORTH_TRUE;
+		break;
 	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS:
+		channel->type = IIO_MAGN;
+		channel->channel2 = IIO_MOD_X;
+		break;
 	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS:
+		channel->type = IIO_MAGN;
+		channel->channel2 = IIO_MOD_Y;
+		break;
 	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS:
-		offset = usage_id - HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS;
-		magn_state->magn_val[CHANNEL_SCAN_INDEX_X + offset] =
-						*(u32 *)raw_data;
-		ret = 0;
-	break;
-	default:
+		channel->type = IIO_MAGN;
+		channel->channel2 = IIO_MOD_Z;
 		break;
+	default:
+		return -EINVAL;
 	}
 
-	return ret;
+	channel->info_mask_separate = BIT(IIO_CHAN_INFO_RAW);
+	channel->info_mask_shared_by_type =
+		BIT(IIO_CHAN_INFO_OFFSET) |
+		BIT(IIO_CHAN_INFO_SCALE) |
+		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
+		BIT(IIO_CHAN_INFO_HYSTERESIS);
+
+	channel->scan_type.sign = 's';
+	/* Real storage bits will change based on the report desc. */
+	channel->scan_type.realbits = size  * 8;
+	/* Maximum size of a sample to capture is u32 */
+	channel->scan_type.storagebits = sizeof(u32) * 8;
+
+
+	return 0;
 }
 
-/* Parse report which is specific to an usage id*/
-static int magn_3d_parse_report(struct platform_device *pdev,
-				struct hid_sensor_hub_device *hsdev,
-				struct iio_chan_spec *channels,
+/* Scan a HID report for a range of attribute usages.
+ * Returns the count of attribute usages found.
+ */
+static int magn_3d_scan_range_usage_ids(struct hid_sensor_hub_device *hsdev,
 				unsigned usage_id,
+				unsigned start_id,
+				unsigned end_id,
 				struct magn_3d_state *st)
 {
+	int count = 0;
 	int ret;
-	int i;
+	int id;
 
-	for (i = 0; i <= CHANNEL_SCAN_INDEX_Z; ++i) {
+	for (id = start_id; id <= end_id; id++) {
+		int i;
+
+		i = magn_3d_usage_id_to_chan_index(id);
+		if(i < 0)
+			continue;
+
+		/* Check if usage attribute exists in the sensor hub device */
 		ret = sensor_hub_input_get_attribute_info(hsdev,
 				HID_INPUT_REPORT,
 				usage_id,
-				HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS + i,
-				&st->magn[CHANNEL_SCAN_INDEX_X + i]);
-		if (ret < 0)
-			break;
-		magn_3d_adjust_channel_bit_mask(channels,
-				CHANNEL_SCAN_INDEX_X + i,
-				st->magn[CHANNEL_SCAN_INDEX_X + i].size);
+				id,
+				&(st->magn[i]));
+		if (ret == 0)
+			count++;
+	}
+
+	return count;
+}
+
+/* Parse the HID report and return number of reports found */
+static int magn_3d_parse_report(struct platform_device *pdev,
+				struct hid_sensor_hub_device *hsdev,
+				unsigned usage_id,
+				int* attribute_count,
+				struct magn_3d_state *st)
+{
+	int usage_count = 0;
+
+	usage_count += magn_3d_scan_range_usage_ids(hsdev, usage_id,
+					HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH,
+					HID_USAGE_SENSOR_ORIENT_TRUE_NORTH,
+					st);
+
+	usage_count += magn_3d_scan_range_usage_ids(hsdev, usage_id,
+					HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS,
+					HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS,
+					st);
+
+	if (attribute_count != NULL && usage_count > 0) {
+		*attribute_count = usage_count;
+	} else {
+		return -EINVAL;
 	}
-	dev_dbg(&pdev->dev, "magn_3d %x:%x, %x:%x, %x:%x\n",
-			st->magn[0].index,
-			st->magn[0].report_id,
-			st->magn[1].index, st->magn[1].report_id,
-			st->magn[2].index, st->magn[2].report_id);
 
 	st->scale_precision = hid_sensor_format_scale(
 				HID_USAGE_SENSOR_COMPASS_3D,
@@ -299,54 +382,60 @@ static int magn_3d_parse_report(struct platform_device *pdev,
 			st->common_attributes.sensitivity.report_id);
 	}
 
-	return ret;
+	dev_dbg(&pdev->dev, "magn_3d_parse_reports found %d attribute usages\n", usage_count);
+
+	return 0;
 }
 
-/* Function to initialize the processing for usage id */
-static int hid_magn_3d_probe(struct platform_device *pdev)
+/* Setup iio channels */
+static int magn_3d_setup_iio_channels(struct platform_device *pdev,
+				struct iio_dev *indio_dev,
+				unsigned usage_id,
+				int attr_count,
+				struct magn_3d_state *st)
 {
-	int ret = 0;
+	int ret;
 	static char *name = "magn_3d";
-	struct iio_dev *indio_dev;
-	struct magn_3d_state *magn_state;
-	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
 	struct iio_chan_spec *channels;
+	int chan_count = 0;
+	int i;
 
-	indio_dev = devm_iio_device_alloc(&pdev->dev,
-					  sizeof(struct magn_3d_state));
-	if (indio_dev == NULL)
+	/* Allocate IIO channels struct */
+	channels = devm_kcalloc(&pdev->dev,
+			attr_count,
+			sizeof(struct iio_chan_spec),
+			GFP_KERNEL);
+	if (!channels) {
+		dev_err(&pdev->dev, "failed to allocate memory for iio channels\n");
 		return -ENOMEM;
-
-	platform_set_drvdata(pdev, indio_dev);
-
-	magn_state = iio_priv(indio_dev);
-	magn_state->common_attributes.hsdev = hsdev;
-	magn_state->common_attributes.pdev = pdev;
-
-	ret = hid_sensor_parse_common_attributes(hsdev,
-				HID_USAGE_SENSOR_COMPASS_3D,
-				&magn_state->common_attributes);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to setup common attributes\n");
-		return ret;
 	}
 
-	channels = kmemdup(magn_3d_channels, sizeof(magn_3d_channels),
-			   GFP_KERNEL);
-	if (!channels) {
-		dev_err(&pdev->dev, "failed to duplicate channels\n");
+	/* Allocate IIO values array */
+	st->iio_val = devm_kcalloc(&pdev->dev,
+				attr_count,
+				sizeof(u32),
+				GFP_KERNEL);
+	if (!(st->iio_val)) {
+		dev_err(&pdev->dev, "failed to allocate memory for iio value\n");
 		return -ENOMEM;
 	}
 
-	ret = magn_3d_parse_report(pdev, hsdev, channels,
-				HID_USAGE_SENSOR_COMPASS_3D, magn_state);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to setup attributes\n");
-		goto error_free_dev_mem;
+	/* Setup each IIO channel that is present */
+	for (i = 0; i < MAGN_3D_CHANNEL_MAX && chan_count < attr_count; i++){
+		u32 attr = st->magn[i].attrib_id;
+		s32 size = st->magn[i].size;
+
+		if (attr != 0 && size > 0) {
+			ret = magn_3d_setup_iio_chan(attr, size, &(channels[chan_count]));
+			if (ret == 0) {
+				chan_count++;
+				st->magn_val_addr[i] = &(st->iio_val[chan_count]);
+			}
+		}
 	}
 
 	indio_dev->channels = channels;
-	indio_dev->num_channels = ARRAY_SIZE(magn_3d_channels);
+	indio_dev->num_channels = chan_count;
 	indio_dev->dev.parent = &pdev->dev;
 	indio_dev->info = &magn_3d_info;
 	indio_dev->name = name;
@@ -358,9 +447,9 @@ static int hid_magn_3d_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to initialize trigger buffer\n");
 		goto error_free_dev_mem;
 	}
-	atomic_set(&magn_state->common_attributes.data_ready, 0);
+	atomic_set(&st->common_attributes.data_ready, 0);
 	ret = hid_sensor_setup_trigger(indio_dev, name,
-					&magn_state->common_attributes);
+					&st->common_attributes);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "trigger setup failed\n");
 		goto error_unreg_buffer_funcs;
@@ -372,6 +461,65 @@ static int hid_magn_3d_probe(struct platform_device *pdev)
 		goto error_remove_trigger;
 	}
 
+	return 0;
+
+error_remove_trigger:
+	hid_sensor_remove_trigger(&st->common_attributes);
+error_unreg_buffer_funcs:
+	iio_triggered_buffer_cleanup(indio_dev);
+error_free_dev_mem:
+	devm_kfree(&pdev->dev, (void*) indio_dev->channels);
+	devm_kfree(&pdev->dev, (void*) st->iio_val);
+
+	return -EINVAL;
+}
+
+/* Function to initialize the processing for usage id */
+static int hid_magn_3d_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct iio_dev *indio_dev;
+	struct magn_3d_state *magn_state;
+	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	int report_attr_count = 0;
+
+	indio_dev = devm_iio_device_alloc(&pdev->dev,
+					  sizeof(struct magn_3d_state));
+	if (indio_dev == NULL)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, indio_dev);
+
+	magn_state = iio_priv(indio_dev);
+	magn_state->common_attributes.hsdev = hsdev;
+	magn_state->common_attributes.pdev = pdev;
+
+	ret = hid_sensor_parse_common_attributes(hsdev,
+				HID_USAGE_SENSOR_COMPASS_3D,
+				&magn_state->common_attributes);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to setup common attributes\n");
+		return ret;
+	}
+
+	ret = magn_3d_parse_report(pdev, hsdev,
+				HID_USAGE_SENSOR_COMPASS_3D,
+				&report_attr_count,
+				magn_state);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to setup attributes\n");
+		return ret;
+	}
+
+	ret = magn_3d_setup_iio_channels(pdev, indio_dev,
+				HID_USAGE_SENSOR_COMPASS_3D,
+				report_attr_count,
+				magn_state);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to setup iio channel\n");
+		return ret;
+	}
+
 	magn_state->callbacks.send_event = magn_3d_proc_event;
 	magn_state->callbacks.capture_sample = magn_3d_capture_sample;
 	magn_state->callbacks.pdev = pdev;
@@ -379,20 +527,9 @@ static int hid_magn_3d_probe(struct platform_device *pdev)
 					&magn_state->callbacks);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "callback reg failed\n");
-		goto error_iio_unreg;
 	}
 
 	return ret;
-
-error_iio_unreg:
-	iio_device_unregister(indio_dev);
-error_remove_trigger:
-	hid_sensor_remove_trigger(&magn_state->common_attributes);
-error_unreg_buffer_funcs:
-	iio_triggered_buffer_cleanup(indio_dev);
-error_free_dev_mem:
-	kfree(indio_dev->channels);
-	return ret;
 }
 
 /* Function to deinitialize the processing for usage id */
@@ -406,7 +543,8 @@ static int hid_magn_3d_remove(struct platform_device *pdev)
 	iio_device_unregister(indio_dev);
 	hid_sensor_remove_trigger(&magn_state->common_attributes);
 	iio_triggered_buffer_cleanup(indio_dev);
-	kfree(indio_dev->channels);
+	devm_kfree(&pdev->dev, (void*) magn_state->iio_val);
+	devm_kfree(&pdev->dev, (void*) indio_dev->channels);
 
 	return 0;
 }
-- 
1.9.3

