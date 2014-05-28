Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334AbaE1VGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:06:51 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37358 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbaE1VGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:06:37 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org, jic23@kernel.org,
        srinivas.pandruvada@linux.intel.com, linux-input@vger.kernel.org,
        jkosina@suse.cz
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH 3/3] IO: hid-sensor-magn-3d: Add in support for True/Magnetic North HID usages
Date: Wed, 28 May 2014 16:06:15 -0500
Message-Id: <1401311175-12784-4-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com>
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated magn_3d_channel enum for all possible north channels

Added functions to setup iio_chan_spec array depending on
a hid usage report

Renamed magn_val to iio_val to differentiate the index being used

Updated magn_3d_state struct to hold pointer array (magn_val_addr[]) to
iio_val and a count of the iio channels found

Updated magn_3d_parse_report to scan for all compass usages
and create channels for each

Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
---
 drivers/iio/magnetometer/hid-sensor-magn-3d.c | 278 +++++++++++++++++---------
 1 file changed, 183 insertions(+), 95 deletions(-)

diff --git a/drivers/iio/magnetometer/hid-sensor-magn-3d.c b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
index 6d162b7..7ffac17 100644
--- a/drivers/iio/magnetometer/hid-sensor-magn-3d.c
+++ b/drivers/iio/magnetometer/hid-sensor-magn-3d.c
@@ -34,63 +34,54 @@ enum magn_3d_channel {
 	CHANNEL_SCAN_INDEX_X,
 	CHANNEL_SCAN_INDEX_Y,
 	CHANNEL_SCAN_INDEX_Z,
+	CHANNEL_SCAN_INDEX_NORTH,
+	CHANNEL_SCAN_INDEX_NORTH_TRUE,
+	CHANNEL_SCAN_INDEX_NORTH_TILT_COMP,
+	CHANNEL_SCAN_INDEX_NORTH_TRUE_TILT_COMP,
 	MAGN_3D_CHANNEL_MAX,
 };
 
+#define IIO_CHANNEL_MAX MAGN_3D_CHANNEL_MAX
+
 struct magn_3d_state {
 	struct hid_sensor_hub_callbacks callbacks;
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info magn[MAGN_3D_CHANNEL_MAX];
-	u32 magn_val[MAGN_3D_CHANNEL_MAX];
-};
+	u32 *magn_val_addr[MAGN_3D_CHANNEL_MAX];
 
-static const u32 magn_3d_addresses[MAGN_3D_CHANNEL_MAX] = {
-	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS,
-	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS,
-	HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS
+	u32 iio_val[IIO_CHANNEL_MAX];
+	int num_iio_channels;
 };
 
-/* Channel definitions */
-static const struct iio_chan_spec magn_3d_channels[] = {
-	{
-		.type = IIO_MAGN,
-		.modified = 1,
-		.channel2 = IIO_MOD_X,
-		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
-		BIT(IIO_CHAN_INFO_SCALE) |
-		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
-		BIT(IIO_CHAN_INFO_HYSTERESIS),
-		.scan_index = CHANNEL_SCAN_INDEX_X,
-	}, {
-		.type = IIO_MAGN,
-		.modified = 1,
-		.channel2 = IIO_MOD_Y,
-		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
-		BIT(IIO_CHAN_INFO_SCALE) |
-		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
-		BIT(IIO_CHAN_INFO_HYSTERESIS),
-		.scan_index = CHANNEL_SCAN_INDEX_Y,
-	}, {
-		.type = IIO_MAGN,
-		.modified = 1,
-		.channel2 = IIO_MOD_Z,
-		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |
-		BIT(IIO_CHAN_INFO_SCALE) |
-		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
-		BIT(IIO_CHAN_INFO_HYSTERESIS),
-		.scan_index = CHANNEL_SCAN_INDEX_Z,
+/* Find index into magn_3d_state magn[] and magn_val_addr[] from HID Usage  */
+static int magn_3d_usage_id_to_chan_index(unsigned usage_id){
+	int offset = -1;
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
+		offset = CHANNEL_SCAN_INDEX_NORTH_TILT_COMP;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH:
+		offset = CHANNEL_SCAN_INDEX_NORTH_TRUE_TILT_COMP;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_MAGN_NORTH:
+		offset = CHANNEL_SCAN_INDEX_NORTH;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_TRUE_NORTH:
+		offset = CHANNEL_SCAN_INDEX_NORTH_TRUE;
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
@@ -101,21 +92,31 @@ static int magn_3d_read_raw(struct iio_dev *indio_dev,
 {
 	struct magn_3d_state *magn_state = iio_priv(indio_dev);
 	int report_id = -1;
-	u32 address;
+	unsigned usage_id;
+	int chan_index = -1;
 	int ret;
 	int ret_type;
 
+	dev_dbg(&indio_dev->dev, "magn_3d_read_raw\n");
+
 	*val = 0;
 	*val2 = 0;
 	switch (mask) {
 	case 0:
+		/* We store the HID usage ID of the iio channel
+		 * in its address field
+		 */
+		usage_id = chan->address;
+		chan_index = magn_3d_usage_id_to_chan_index(usage_id);
+		if(chan_index < 0)
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
@@ -202,12 +203,13 @@ static int magn_3d_proc_event(struct hid_sensor_hub_device *hsdev,
 				magn_state->common_attributes.data_ready);
 	if (magn_state->common_attributes.data_ready)
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
@@ -217,62 +219,147 @@ static int magn_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 	struct iio_dev *indio_dev = platform_get_drvdata(priv);
 	struct magn_3d_state *magn_state = iio_priv(indio_dev);
 	int offset;
+	u32 *magn_val;
 	int ret = -EINVAL;
 
-	switch (usage_id) {
+	offset = magn_3d_usage_id_to_chan_index(usage_id);
+	if(offset < 0)
+		return ret;
+
+	magn_val = magn_state->magn_val_addr[offset];
+	if(!magn_val)
+		return ret;
+
+	*(magn_val) =  *(u32 *)raw_data;
+
+	return 0;
+}
+
+/* Setup the iio_chan_spec for HID Usage ID */
+static int magn_3d_setup_iio_chan(unsigned usage_id,
+				struct iio_chan_spec* channel,
+				u32 size,
+				struct magn_3d_state *st)
+{
+	int ret = -1;
+
+	if(channel == NULL)
+		return ret;
+
+	channel->type = IIO_MAGN;
+	channel->address = usage_id;
+	channel->modified = 1;
+
+	switch (usage_id){
+	case HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH:
+		channel->channel2 = IIO_MOD_MAGN_NORTH_TILT_COMP;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_COMP_TRUE_NORTH:
+		channel->channel2 = IIO_MOD_MAGN_NORTH_TRUE_TILT_COMP;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_MAGN_NORTH:
+		channel->channel2 = IIO_MOD_MAGN_NORTH;
+		break;
+	case HID_USAGE_SENSOR_ORIENT_TRUE_NORTH:
+		channel->channel2 = IIO_MOD_MAGN_NORTH_TRUE;
+		break;
 	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS:
+		channel->channel2 = IIO_MOD_X;
+		break;
 	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Y_AXIS:
+		channel->channel2 = IIO_MOD_Y;
+		break;
 	case HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS:
-		offset = usage_id - HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS;
-		magn_state->magn_val[CHANNEL_SCAN_INDEX_X + offset] =
-						*(u32 *)raw_data;
-		ret = 0;
-	break;
-	default:
+		channel->channel2 = IIO_MOD_Z;
 		break;
+	default:
+		return ret;
 	}
 
-	return ret;
+	channel->info_mask_shared_by_type =
+		BIT(IIO_CHAN_INFO_OFFSET) |
+		BIT(IIO_CHAN_INFO_SCALE) |
+		BIT(IIO_CHAN_INFO_SAMP_FREQ) |
+		BIT(IIO_CHAN_INFO_HYSTERESIS);
+
+	channel->scan_type.sign = 's';
+	/* Real storage bits will change based on the report desc. */
+	channel->scan_type.realbits = size * 8;
+	/* Maximum size of a sample to capture is u32 */
+	channel->scan_type.storagebits = sizeof(u32) * 8;
+
+	return 0;
+}
+
+static void sensor_hub_fill_attr_info(
+		struct hid_sensor_hub_attribute_info *info,
+		s32 index, s32 report_id, struct hid_field *field)
+{
+	info->index = index;
+	info->report_id = report_id;
+	info->units = field->unit;
+	info->unit_expo = field->unit_exponent;
+	info->size = (field->report_size * field->report_count)/8;
+	info->logical_minimum = field->logical_minimum;
+	info->logical_maximum = field->logical_maximum;
 }
 
-/* Parse report which is specific to an usage id*/
+/* Read the HID reports and setup IIO Channels */
 static int magn_3d_parse_report(struct platform_device *pdev,
 				struct hid_sensor_hub_device *hsdev,
-				struct iio_chan_spec *channels,
+				struct iio_chan_spec *iio_chans,
 				unsigned usage_id,
 				struct magn_3d_state *st)
 {
-	int ret;
+	int ret = -1;
 	int i;
-
-	for (i = 0; i <= CHANNEL_SCAN_INDEX_Z; ++i) {
-		ret = sensor_hub_input_get_attribute_info(hsdev,
-				HID_INPUT_REPORT,
-				usage_id,
-				HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_X_AXIS + i,
-				&st->magn[CHANNEL_SCAN_INDEX_X + i]);
-		if (ret < 0)
-			break;
-		magn_3d_adjust_channel_bit_mask(channels,
-				CHANNEL_SCAN_INDEX_X + i,
-				st->magn[CHANNEL_SCAN_INDEX_X + i].size);
-	}
-	dev_dbg(&pdev->dev, "magn_3d %x:%x, %x:%x, %x:%x\n",
-			st->magn[0].index,
-			st->magn[0].report_id,
-			st->magn[1].index, st->magn[1].report_id,
-			st->magn[2].index, st->magn[2].report_id);
-
-	/* Set Sensitivity field ids, when there is no individual modifier */
-	if (st->common_attributes.sensitivity.index < 0) {
-		sensor_hub_input_get_attribute_info(hsdev,
-			HID_FEATURE_REPORT, usage_id,
-			HID_USAGE_SENSOR_DATA_MOD_CHANGE_SENSITIVITY_ABS |
-			HID_USAGE_SENSOR_DATA_ORIENTATION,
-			&st->common_attributes.sensitivity);
-		dev_dbg(&pdev->dev, "Sensitivity index:report %d:%d\n",
-			st->common_attributes.sensitivity.index,
-			st->common_attributes.sensitivity.report_id);
+	int j;
+
+	struct hid_report *report;
+	struct hid_field *field;
+	struct hid_report_enum *report_enum;
+	struct hid_device *hdev = hsdev->hdev;
+	struct hid_usage *usage = NULL;
+
+	dev_dbg(&pdev->dev, "magn_north_parse_reports Usage ID: %x\n", usage_id);
+	report_enum = &hdev->report_enum[HID_INPUT_REPORT];
+	list_for_each_entry(report, &report_enum->report_list, list) {
+		for (i = 0; i < report->maxfield; ++i) {
+			field = report->field[i];
+
+			for (j = 0; j < field->maxusage; j++) {
+				usage = &(field->usage[j]);
+
+				/* Check if collection_index is valid */
+				if(usage->collection_index >=
+					   hsdev->start_collection_index &&
+				   usage->collection_index <
+					   hsdev->end_collection_index &&
+				   usage->hid >=
+					   HID_USAGE_SENSOR_ORIENT_COMP_MAGN_NORTH &&
+				   usage->hid <=
+					   HID_USAGE_SENSOR_ORIENT_MAGN_FLUX_Z_AXIS)
+				{
+					struct hid_sensor_hub_attribute_info *usage_attr;
+					int magn_index = magn_3d_usage_id_to_chan_index(usage->hid);
+					int iio_index = st->num_iio_channels++;
+
+					if(magn_index >= 0 && magn_index < MAGN_3D_CHANNEL_MAX &&
+						iio_index >= 0 && iio_index < IIO_CHANNEL_MAX){
+						usage_attr = &(st->magn[magn_index]);
+
+						sensor_hub_fill_attr_info(usage_attr, i,
+									report->id,
+									field);
+						ret = magn_3d_setup_iio_chan(usage->hid,
+								&(iio_chans[iio_index]),
+								usage_attr->size,
+								st);
+						st->magn_val_addr[magn_index] = &(st->iio_val[iio_index]);
+					}
+				}
+			}
+		}
 	}
 
 	return ret;
@@ -307,10 +394,11 @@ static int hid_magn_3d_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	channels = kmemdup(magn_3d_channels, sizeof(magn_3d_channels),
-			   GFP_KERNEL);
+	channels = kcalloc(MAGN_3D_CHANNEL_MAX,
+			sizeof(struct iio_chan_spec),
+			GFP_KERNEL);
 	if (!channels) {
-		dev_err(&pdev->dev, "failed to duplicate channels\n");
+		dev_err(&pdev->dev, "failed to allocate memory for iio channel\n");
 		return -ENOMEM;
 	}
 
@@ -322,7 +410,7 @@ static int hid_magn_3d_probe(struct platform_device *pdev)
 	}
 
 	indio_dev->channels = channels;
-	indio_dev->num_channels = ARRAY_SIZE(magn_3d_channels);
+	indio_dev->num_channels = magn_state->num_iio_channels;
 	indio_dev->dev.parent = &pdev->dev;
 	indio_dev->info = &magn_3d_info;
 	indio_dev->name = name;
-- 
1.9.3

