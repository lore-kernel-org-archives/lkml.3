Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbbAKTK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 14:10:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:3387 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbbAKTKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 14:10:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,739,1413270000"; 
   d="scan'208";a="660161235"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v2 03/10] iio: core: Introduce IIO_VELOCITY and IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z
Date: Sun, 11 Jan 2015 21:10:09 +0200
Message-Id: <1421003416-27557-4-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com>
References: <1421003416-27557-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices export the current speed value of the user.

One of this devices is Freescale's MMA9553L
(http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
that computes the speed of the user based on the number of steps and
stride length.

Introduce a new channel type VELOCITY and a modifier for the magniture or
norm of the velocity vector, IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 10 ++++++++++
 drivers/iio/industrialio-core.c         |  2 ++
 include/linux/iio/types.h               |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index c627a9a..80b5efb1 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -295,6 +295,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_true_tilt_comp_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_humidityrelative_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_velocity_sqrt(x^2+y^2+z^2)_scale
 KernelVersion:	2.6.35
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -1164,3 +1165,12 @@ Contact:	linux-iio@vger.kernel.org
 Description:
 		This attribute is used to read the number of steps taken by the user
 		since the last reboot while activated.
+
+What:		/sys/.../iio:deviceX/in_velocity_sqrt(x^2+y^2+z^2)_input
+What:		/sys/.../iio:deviceX/in_velocity_sqrt(x^2+y^2+z^2)_raw
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This attribute is used to read the current speed value of the
+		user (which is the norm or magnitude of the velocity vector).
+		Units after application of scale are m/s.
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 655755b..18a8ab9 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -74,6 +74,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_STEPS] = "steps",
 	[IIO_ENERGY] = "energy",
 	[IIO_DISTANCE] = "distance",
+	[IIO_VELOCITY] = "velocity",
 };
 
 static const char * const iio_modifier_names[] = {
@@ -99,6 +100,7 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_JOGGING] = "jogging",
 	[IIO_MOD_WALKING] = "walking",
 	[IIO_MOD_STILL] = "still",
+	[IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z] = "sqrt(x^2+y^2+z^2)",
 };
 
 /* relies on pairs of these shared then separate */
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index a7de445..c3601c2 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -34,6 +34,7 @@ enum iio_chan_type {
 	IIO_STEPS,
 	IIO_ENERGY,
 	IIO_DISTANCE,
+	IIO_VELOCITY,
 };
 
 enum iio_modifier {
@@ -68,6 +69,7 @@ enum iio_modifier {
 	IIO_MOD_JOGGING,
 	IIO_MOD_WALKING,
 	IIO_MOD_STILL,
+	IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z,
 };
 
 enum iio_event_type {
-- 
1.9.1

