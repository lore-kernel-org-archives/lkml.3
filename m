Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaKJMob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:44:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:10698 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbaKJMo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:44:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="634415489"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, knaack.h@gmx.de
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        irina.tirdea@intel.com, daniel.baluta@inte.com
Subject: [PATCH v4 4/7] iio: core: Introduce STEPS channel, ENABLE mask and INSTANCE event
Date: Mon, 10 Nov 2014 14:45:32 +0200
Message-Id: <1415623535-24337-5-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com>
References: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

These changes are needed to support the functionality of a pedometer.
A pedometer has two basic functionalities: step counter and step detector.

The step counter needs to be enabled and then it will count the steps
in its hardware register. Whenever the application needs to check
the step count, it will read the step counter register. To support the
step counter a new channel type STEPS is added. Since the pedometer needs
to be enabled first so that the hardware can count and store the steps,
we need a specific ENABLE channel info mask.

The step detector will generate an interrupt each time a step is detected.
To support this functionality we add a new event type INSTANCE.

For more information on the Android requirements for step counter and step
detector see:
http://source.android.com/devices/sensors/composite_sensors.html#counter
and http://source.android.com/devices/sensors/composite_sensors.html#detector.

A device that has the pedometer functionality this interface needs to
support is Freescale's MMA9553L:
http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 22 ++++++++++++++++++++++
 drivers/iio/industrialio-core.c         |  2 ++
 drivers/iio/industrialio-event.c        |  1 +
 include/linux/iio/iio.h                 |  1 +
 include/linux/iio/types.h               |  2 ++
 5 files changed, 28 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 7bf49ad..c60b0a1 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -856,6 +856,13 @@ Description:
 		number or direction is not specified, applies to all channels of
 		this type.
 
+What:		/sys/.../events/in_steps_instance_en
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Enables or disables step detection. Each time the user takes a step an
+		event of this type will be generated.
+
 What:		/sys/bus/iio/devices/iio:deviceX/trigger/current_trigger
 KernelVersion:	2.6.35
 Contact:	linux-iio@vger.kernel.org
@@ -1095,3 +1102,18 @@ Description:
 		after application of scale and offset. If no offset or scale is
 		present, output should be considered as processed with the
 		unit in milliamps.
+
+What:		/sys/.../iio:deviceX/in_steps_en
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Activates the step counter. After activation, the number of steps
+		taken by the user will be counted in hardware and exported through
+		in_steps_input.
+
+What:		/sys/.../iio:deviceX/in_steps_input
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This attribute is used to read the number of steps taken by the user
+		since the last reboot while activated.
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index e453ef9..1e060f3 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -71,6 +71,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_PRESSURE] = "pressure",
 	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
 	[IIO_ACTIVITY] = "activity",
+	[IIO_STEPS] = "steps",
 };
 
 static const char * const iio_modifier_names[] = {
@@ -118,6 +119,7 @@ static const char * const iio_chan_info_postfix[] = {
 	[IIO_CHAN_INFO_HARDWAREGAIN] = "hardwaregain",
 	[IIO_CHAN_INFO_HYSTERESIS] = "hysteresis",
 	[IIO_CHAN_INFO_INT_TIME] = "integration_time",
+	[IIO_CHAN_INFO_ENABLE] = "en",
 };
 
 /**
diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index 1290290..3f5cee0 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -197,6 +197,7 @@ static const char * const iio_ev_type_text[] = {
 	[IIO_EV_TYPE_ROC] = "roc",
 	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
 	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
+	[IIO_EV_TYPE_INSTANCE] = "instance",
 };
 
 static const char * const iio_ev_dir_text[] = {
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 3642ce7..f45a400 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -38,6 +38,7 @@ enum iio_chan_info_enum {
 	IIO_CHAN_INFO_HARDWAREGAIN,
 	IIO_CHAN_INFO_HYSTERESIS,
 	IIO_CHAN_INFO_INT_TIME,
+	IIO_CHAN_INFO_ENABLE,
 };
 
 enum iio_shared_by {
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index 52cb532..904dcbb 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -31,6 +31,7 @@ enum iio_chan_type {
 	IIO_PRESSURE,
 	IIO_HUMIDITYRELATIVE,
 	IIO_ACTIVITY,
+	IIO_STEPS,
 };
 
 enum iio_modifier {
@@ -73,6 +74,7 @@ enum iio_event_type {
 	IIO_EV_TYPE_ROC,
 	IIO_EV_TYPE_THRESH_ADAPTIVE,
 	IIO_EV_TYPE_MAG_ADAPTIVE,
+	IIO_EV_TYPE_INSTANCE,
 };
 
 enum iio_event_info {
-- 
1.9.1

