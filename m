Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaJ1KVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:21:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:45530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611AbaJ1KTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:19:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,802,1406617200"; 
   d="scan'208";a="621979788"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org
Cc: daniel.baluta@intel.com, knaack.h@gmx.de, linux-kernel@vger.kernel.org,
        irina.tirdea@intel.com
Subject: [PATCH v3 2/7] iio: core: Introduce IIO_ACTIVITY channel
Date: Tue, 28 Oct 2014 12:19:26 +0200
Message-Id: <1414491571-11672-3-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414491571-11672-1-git-send-email-daniel.baluta@intel.com>
References: <1414491571-11672-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This channel will be used for exposing information about
activity composite sensors. Activities supported so far:
	* running
	* jogging
	* walking
	* still

THRESHOLD event is used to signal a change in the activity
state.

We associate a confidence interval for each activity expressed
as a percentage from 0 to 100.
  * 0, means the sensor IS NOT reporting that activity.
  * 100, means the sensor IS reporting that activity.

Users of this interface have two possibile means to gather
information about the ongoing activities.

1. Event based, via event file descriptor
  * sensor may report an event when ENTERING an activity or LEAVING
    an activity based on a threshold value.
  * drivers will wake up applications waiting data on the event fd

2. Polling, by reading the sysfs associated attribute files:
  * /sys/bus/iio/devices/iio:device0/in_activity_running_input
expressed as percentage confidence value from 0 to 100.

This will offer an interface for Android significant motion
composite sensor defined here:
http://source.android.com/devices/sensors/composite_sensors.html

Activities listed above are supported by Freescale's MMA9553 sensor:
http://freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 44 +++++++++++++++++++++++++++++++++
 drivers/iio/industrialio-core.c         |  5 ++++
 include/linux/iio/types.h               |  7 +++++-
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 5a7fc66..c3a1fd3 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -783,6 +783,40 @@ Description:
 		met before an event is generated. If direction is not
 		specified then this period applies to both directions.
 
+What:		/sys/.../events/in_activity_still_thresh_rising_en
+What:		/sys/.../events/in_activity_still_thresh_falling_en
+What:		/sys/.../events/in_activity_walking_thresh_rising_en
+What:		/sys/.../events/in_activity_walking_thresh_falling_en
+What:		/sys/.../events/in_activity_jogging_thresh_rising_en
+What:		/sys/.../events/in_activity_jogging_thresh_falling_en
+What:		/sys/.../events/in_activity_running_thresh_rising_en
+What:		/sys/.../events/in_activity_running_thresh_falling_en
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Enables or disables activitity events. Depending on direction
+		an event is generated when sensor ENTERS or LEAVES a given state.
+
+What:		/sys/.../events/in_activity_still_thresh_rising_value
+What:		/sys/.../events/in_activity_still_thresh_falling_value
+What:		/sys/.../events/in_activity_walking_thresh_rising_value
+What:		/sys/.../events/in_activity_walking_thresh_falling_value
+What:		/sys/.../events/in_activity_jogging_thresh_rising_value
+What:		/sys/.../events/in_activity_jogging_thresh_falling_value
+What:		/sys/.../events/in_activity_running_thresh_rising_value
+What:		/sys/.../events/in_activity_running_thresh_falling_value
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Confidence value (in units as percentage) to be used
+		for deciding when an event should be generated. E.g for
+		running: If the confidence value reported by the sensor
+		is greater then in_activity_running_thresh_rising_value
+		then the sensor ENTERS running state. Conversely, if the
+		confidence value reported by the sensor is lower than
+		in_activity_running_thresh_falling_value then the sensor
+		is LEAVING running state.
+
 What:		/sys/.../iio:deviceX/events/in_accel_mag_en
 What:		/sys/.../iio:deviceX/events/in_accel_mag_rising_en
 What:		/sys/.../iio:deviceX/events/in_accel_mag_falling_en
@@ -949,6 +983,16 @@ Description:
 		and the relevant _type attributes to establish the data storage
 		format.
 
+What:		/sys/.../iio:deviceX/in_activity_still_input
+What:		/sys/.../iio:deviceX/in_activity_walking_input
+What:		/sys/.../iio:deviceX/in_activity_jogging_input
+What:		/sys/.../iio:deviceX/in_activity_running_input
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This attribute is used to read the confidence for an activity
+		expressed in units as percentage.
+
 What:		/sys/.../iio:deviceX/in_anglvel_z_quadrature_correction_raw
 KernelVersion:	2.6.38
 Contact:	linux-iio@vger.kernel.org
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index af3e76d..e453ef9 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -70,6 +70,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_CCT] = "cct",
 	[IIO_PRESSURE] = "pressure",
 	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
+	[IIO_ACTIVITY] = "activity",
 };
 
 static const char * const iio_modifier_names[] = {
@@ -91,6 +92,10 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_NORTH_TRUE] = "from_north_true",
 	[IIO_MOD_NORTH_MAGN_TILT_COMP] = "from_north_magnetic_tilt_comp",
 	[IIO_MOD_NORTH_TRUE_TILT_COMP] = "from_north_true_tilt_comp",
+	[IIO_MOD_RUNNING] = "running",
+	[IIO_MOD_JOGGING] = "jogging",
+	[IIO_MOD_WALKING] = "walking",
+	[IIO_MOD_STILL] = "still",
 };
 
 /* relies on pairs of these shared then separate */
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index 4a2af8a..b3a241d 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -30,6 +30,7 @@ enum iio_chan_type {
 	IIO_CCT,
 	IIO_PRESSURE,
 	IIO_HUMIDITYRELATIVE,
+	IIO_ACTIVITY,
 };
 
 enum iio_modifier {
@@ -59,7 +60,11 @@ enum iio_modifier {
 	IIO_MOD_NORTH_MAGN,
 	IIO_MOD_NORTH_TRUE,
 	IIO_MOD_NORTH_MAGN_TILT_COMP,
-	IIO_MOD_NORTH_TRUE_TILT_COMP
+	IIO_MOD_NORTH_TRUE_TILT_COMP,
+	IIO_MOD_RUNNING,
+	IIO_MOD_JOGGING,
+	IIO_MOD_WALKING,
+	IIO_MOD_STILL,
 };
 
 enum iio_event_type {
-- 
1.9.1

