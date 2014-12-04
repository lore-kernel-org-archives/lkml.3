Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaLDNAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:00:51 -0500
Received: from mga03.intel.com ([134.134.136.65]:38653 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbaLDNAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:00:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="493541736"
From: Teodora Baluta <teodora.baluta@intel.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Teodora Baluta <teodora.baluta@intel.com>
Subject: [RFC PATCH 1/3] iio: core: add support for fingerprint devices
Date: Thu,  4 Dec 2014 15:00:15 +0200
Message-Id: <1417698017-13835-2-git-send-email-teodora.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
References: <1417698017-13835-1-git-send-email-teodora.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the IIO_FINGERPRINT channel which exposes fingerprint sensor
information needed by consumer, attributes for a fingerprint device and
a modifier for the IIO_FINGERPRINT channel. We detail these below.

In order to have a uniform interface, we add the following attributes:
height, width, bit depth, color scheme, orientation, resolution, sensitivity
threshold. These provide information about the image a scanner type device
like a fingerprint sensor produces. Depending on the device, some of these
could be adjusted. For example, setting a lower resolution or a higher
sensitivity threshold.

The sensitivity threshold controls the sensitivy of the finger detection
process. The SW6888[0] sensor and the MBF200[1] sensor have this option.

Add a modifier that enables us to communicate a status code after each scan.
The status codes for a fingerprint device are added in the types.h file.
Devices that are able to send out these status codes are UPEK Eikon 2 and
Validity VFS101 (see [2]). Thus, we have two channels: a modified one
representing the status code and the actual scanned fingerprint data channel.

This patch adds ABI documentation for the attributes a fingerprint
device would have. These attributes describe the image such a sensor
produces. Also, add ABI documentation for the fingerprint channel and
fingerprint status modified channel.

[0] http://ww1.microchip.com/downloads/cn/DeviceDoc/sw6888.pdf
[1]
http://pdf.datasheetcatalog.com/datasheet/FujitsuMicroelectronics/mXsxyvq.pdf
[2]
http://cgit.freedesktop.org/libfprint/libfprint/tree/libfprint/drivers

Signed-off-by: Teodora Baluta <teodora.baluta@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 51 +++++++++++++++++++++++++++++++++
 drivers/iio/industrialio-core.c         |  9 ++++++
 include/linux/iio/iio.h                 |  7 +++++
 include/linux/iio/types.h               | 10 +++++++
 4 files changed, 77 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 4a9e29a..74d0eed 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -1125,3 +1125,54 @@ Contact:	linux-iio@vger.kernel.org
 Description:
 		This attribute is used to read the number of steps taken by the user
 		since the last reboot while activated.
+
+What:		/sys/bus/iio/devices/iio:deviceX/scan_elements/in_fingerprint_en
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Activates the fingerprint channel. By activating the channel,
+		the scanned fingerprint can be read from the character device
+		/dev/iio:deviceX.
+
+What:		/sys/bus/iio/devices/iio:deviceX/scan_elements/in_fingerprint_status_en
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Activates the fingerprint status modified channel. After
+		activation, a status code representing the scan feedback from
+		the device can be read from the character device
+		/dev/iio:deviceX.
+
+What:		/sys/bus/iio/devices/iio:deviceX/in_fingerprint_scan_height
+What:		/sys/bus/iio/devices/iio:deviceX/in_fingerprint_scan_width
+What:		/sys/bus/iio/devices/iio:deviceX/in_fingerprint_scan_bit_depth
+What:		/sys/bus/iio/devices/iio:deviceX/in_fingerprint_scan_colorscheme
+What:		/sys/bus/iio/devices/iio:deviceX/in_fingerprint_scan_orientation
+What:		/sys/bus/iio/devices/iio:deviceX/in_fingerprint_scan_resolution
+What:		/sys/bus/iio/devices/iio:deviceX/in_fingerprint_sensitivity_threshold
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Attributes that describe the output of a fingerprint device.
+		These values are device dependent and should be provided to the
+		upper layer for processing the image.
+
+		The height * width * bit_depth represents the total amount of
+		data the fingerprint channel stores and makes available in the
+		corresponding character device. Here height and width are
+		represented in pixels.
+
+		The colorscheme represents whether the image is black-on-white
+		or white-on-black. We associate the black-on-white with 0 and
+		white-on-black with 1. Similarly, we use 0 for a horizontal
+		orientation and 1 for a vertical orientation.
+
+		The scan_resolution (in ppmm) is a useful metric for processing
+		the fingerprint. The sensor usually has a set resolution, but as
+		with any other scanners this attribute could also be used as a
+		quality setting.
+
+		Lastly, a sensitivity threshold is a way of adjusting
+		sensitivity in the finger detection/scanning.
+		The userspace application should be able to set this value if
+		the device has this capability.
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 45bb3a4..f54d22b 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -72,6 +72,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
 	[IIO_ACTIVITY] = "activity",
 	[IIO_STEPS] = "steps",
+	[IIO_FINGERPRINT] = "fingerprint",
 };
 
 static const char * const iio_modifier_names[] = {
@@ -97,6 +98,7 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_JOGGING] = "jogging",
 	[IIO_MOD_WALKING] = "walking",
 	[IIO_MOD_STILL] = "still",
+	[IIO_MOD_STATUS] = "status",
 };
 
 /* relies on pairs of these shared then separate */
@@ -121,6 +123,13 @@ static const char * const iio_chan_info_postfix[] = {
 	[IIO_CHAN_INFO_INT_TIME] = "integration_time",
 	[IIO_CHAN_INFO_ENABLE] = "en",
 	[IIO_CHAN_INFO_CALIBHEIGHT] = "calibheight",
+	[IIO_CHAN_INFO_SCAN_HEIGHT] = "scan_height",
+	[IIO_CHAN_INFO_SCAN_WIDTH] = "scan_width",
+	[IIO_CHAN_INFO_SCAN_BIT_DEPTH] = "scan_bit_depth",
+	[IIO_CHAN_INFO_SCAN_COLOR_SCHEME] = "scan_color_scheme",
+	[IIO_CHAN_INFO_SCAN_ORIENTATION] = "scan_orientation",
+	[IIO_CHAN_INFO_SCAN_RESOLUTION] = "scan_resolution",
+	[IIO_CHAN_INFO_SENSITIVITY_THRESHOLD] = "sensitivity_threshold",
 };
 
 /**
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 878d861..e280cfe 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -40,6 +40,13 @@ enum iio_chan_info_enum {
 	IIO_CHAN_INFO_INT_TIME,
 	IIO_CHAN_INFO_ENABLE,
 	IIO_CHAN_INFO_CALIBHEIGHT,
+	IIO_CHAN_INFO_SCAN_HEIGHT,
+	IIO_CHAN_INFO_SCAN_WIDTH,
+	IIO_CHAN_INFO_SCAN_BIT_DEPTH,
+	IIO_CHAN_INFO_SCAN_COLOR_SCHEME,
+	IIO_CHAN_INFO_SCAN_ORIENTATION,
+	IIO_CHAN_INFO_SCAN_RESOLUTION,
+	IIO_CHAN_INFO_SENSITIVITY_THRESHOLD,
 };
 
 enum iio_shared_by {
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index 904dcbb..d0c7cc9 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -32,6 +32,7 @@ enum iio_chan_type {
 	IIO_HUMIDITYRELATIVE,
 	IIO_ACTIVITY,
 	IIO_STEPS,
+	IIO_FINGERPRINT,
 };
 
 enum iio_modifier {
@@ -66,6 +67,7 @@ enum iio_modifier {
 	IIO_MOD_JOGGING,
 	IIO_MOD_WALKING,
 	IIO_MOD_STILL,
+	IIO_MOD_STATUS,
 };
 
 enum iio_event_type {
@@ -91,6 +93,14 @@ enum iio_event_direction {
 	IIO_EV_DIR_NONE,
 };
 
+#define STATUS_UNKNOWN				255
+
+#define STATUS_FINGERPRINT_GOOD			0
+#define STATUS_FINGERPRINT_FAIL			1
+#define STATUS_FINGERPRINT_TOO_SLOW		2
+#define STATUS_FINGERPRINT_TOO_FAST		3
+#define STATUS_FINGERPRINT_CENTER_FINGER	4
+
 #define IIO_VAL_INT 1
 #define IIO_VAL_INT_PLUS_MICRO 2
 #define IIO_VAL_INT_PLUS_NANO 3
-- 
1.9.1

