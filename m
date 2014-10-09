Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbaJIMeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:34:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:14708 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989AbaJIMdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:33:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,684,1406617200"; 
   d="scan'208";a="615765082"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: irina.tirdea@intel.com, daniel.baluta@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 7/7] iio: event_monitor: Add support for new channel types
Date: Thu,  9 Oct 2014 15:39:45 +0300
Message-Id: <1412858385-11954-8-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412858385-11954-1-git-send-email-daniel.baluta@intel.com>
References: <1412858385-11954-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have the following testing scenario:

$ insmod iio_dummy_evgen.ko
$ insmod iio_dummy.ko

./iio_event_monitor /dev/iio:device0
Event: time: 1412786467971335337, type: activity(running), channel: 0, evtype: transition, direction:
rising
Event: time: 1412786530792974091, type: activity(walking), channel: 0, evtype: transition, direction:
falling
Event: time: 1412764319184761765, type: steps, channel: 0, evtype: instance

$ echo 1 > /sys/bus/iio/devices/iio_evgen/poke_ev0
$ echo 2 > /sys/bus/iio/devices/iio_evgen/poke_ev0
$ echo 3 > /sys/bus/iio/devices/iio_evgen/poke_ev0

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 .../staging/iio/Documentation/iio_event_monitor.c  | 25 +++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/Documentation/iio_event_monitor.c b/drivers/staging/iio/Documentation/iio_event_monitor.c
index 569d6f8..47de74b2 100644
--- a/drivers/staging/iio/Documentation/iio_event_monitor.c
+++ b/drivers/staging/iio/Documentation/iio_event_monitor.c
@@ -49,6 +49,8 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_CCT] = "cct",
 	[IIO_PRESSURE] = "pressure",
 	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
+	[IIO_ACTIVITY] = "activity",
+	[IIO_STEPS] = "steps",
 };
 
 static const char * const iio_ev_type_text[] = {
@@ -57,6 +59,8 @@ static const char * const iio_ev_type_text[] = {
 	[IIO_EV_TYPE_ROC] = "roc",
 	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
 	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
+	[IIO_EV_TYPE_TRANSITION] = "transition",
+	[IIO_EV_TYPE_INSTANCE] = "instance",
 };
 
 static const char * const iio_ev_dir_text[] = {
@@ -79,6 +83,10 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_LIGHT_RED] = "red",
 	[IIO_MOD_LIGHT_GREEN] = "green",
 	[IIO_MOD_LIGHT_BLUE] = "blue",
+	[IIO_MOD_RUNNING] = "running",
+	[IIO_MOD_JOGGING] = "jogging",
+	[IIO_MOD_WALKING] = "walking",
+	[IIO_MOD_STILL] = "still",
 };
 
 static bool event_is_known(struct iio_event_data *event)
@@ -108,6 +116,8 @@ static bool event_is_known(struct iio_event_data *event)
 	case IIO_CCT:
 	case IIO_PRESSURE:
 	case IIO_HUMIDITYRELATIVE:
+	case IIO_ACTIVITY:
+	case IIO_STEPS:
 		break;
 	default:
 		return false;
@@ -126,6 +136,10 @@ static bool event_is_known(struct iio_event_data *event)
 	case IIO_MOD_LIGHT_RED:
 	case IIO_MOD_LIGHT_GREEN:
 	case IIO_MOD_LIGHT_BLUE:
+	case IIO_MOD_RUNNING:
+	case IIO_MOD_JOGGING:
+	case IIO_MOD_WALKING:
+	case IIO_MOD_STILL:
 		break;
 	default:
 		return false;
@@ -137,6 +151,8 @@ static bool event_is_known(struct iio_event_data *event)
 	case IIO_EV_TYPE_ROC:
 	case IIO_EV_TYPE_THRESH_ADAPTIVE:
 	case IIO_EV_TYPE_MAG_ADAPTIVE:
+	case IIO_EV_TYPE_TRANSITION:
+	case IIO_EV_TYPE_INSTANCE:
 		break;
 	default:
 		return false;
@@ -146,6 +162,7 @@ static bool event_is_known(struct iio_event_data *event)
 	case IIO_EV_DIR_EITHER:
 	case IIO_EV_DIR_RISING:
 	case IIO_EV_DIR_FALLING:
+	case IIO_EV_DIR_NONE:
 		break;
 	default:
 		return false;
@@ -186,9 +203,11 @@ static void print_event(struct iio_event_data *event)
 	else if (chan >= 0)
 		printf("channel: %d, ", chan);
 
-	printf("evtype: %s, direction: %s\n",
-		iio_ev_type_text[ev_type],
-		iio_ev_dir_text[dir]);
+	printf("evtype: %s", iio_ev_type_text[ev_type]);
+
+	if (dir != IIO_EV_DIR_NONE)
+		printf(", direction: %s", iio_ev_dir_text[dir]);
+	printf("\n");
 }
 
 int main(int argc, char **argv)
-- 
1.9.1

