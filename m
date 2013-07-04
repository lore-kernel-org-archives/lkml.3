Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972Ab3GDIvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:51:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34883 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933708Ab3GDIvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:51:21 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-9c-51d537835683
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v5 5/7] thermal:boost: Automatic enable/disable of BOOST feature
Date: Thu, 04 Jul 2013 10:50:28 +0200
Message-id: <1372927830-2949-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jAd1m86uBBjunK1r8ebuc1eJp0w92
	i3mfZS3W7P/JZNF59gmzRe+Cq2wWbx5xW7x5uJnR4vKuOWwWn3uPMFrcblzBZtG/sJfJ4snD
	PjaLjV89HPg8Fu95yeRx59oeNo91094ye/RtWcXo8WhxC6PH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgyrj2+SFrwUGJireNrewNjL+Euxg5OCQETCS6r4p3MXICmWISF+6tZ+ti5OIQEljE
	KNE1dR4zhNPFJLF73XdGkCo2AT2Jz3efMoHYIgJzGCXuHHUHsZkFVjJLnGh0BLGFBQIken6u
	ZgWxWQRUJVrfbWIHsXkFXCV2zd3AArFNXuLp/T42EJtTwE3i8oUeJohljYwSGzo+sExg5F3A
	yLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzhUn0ntYFzZYHGIUYCDUYmHV8LqSqAQa2JZ
	cWXuIUYJDmYlEV4njquBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQW
	wWSZODilGhjz80rWmoUXL57SqzBrwsW1BU2hkTenKMqurpvv4rdJ6pL/R56dLhIqG26tuT1R
	qUDI8lrB/MM7qy0eb/p07Tif86mQljPnZMRqJthf+fTqazIL38wJKSmx5xoWTT72qXlawdld
	6RGbr6nwZBbfY/c5tOvh7RaJqOmLrS6/ZStr2XKS9yy7wGUVJZbijERDLeai4kQAJA4gNFEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides auto disable/enable operation for boost. When any
defined trip point is passed, the boost is disabled.
In that moment thermal monitor workqueue is woken up and it monitors
if the device temperature drops below 75% of the smallest trip point.
When device cools down, the boost is enabled again.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
Changes for v5:
- Move boost disable code from cpu_cooling.c to thermal_core.c
  (to handle_non_critical_trips)
- Extent struct thermal_zone_device by adding overheated bool flag
- Implement auto enable of boost after device cools down
- Introduce boost_polling flag, which indicates if thermal uses it's predefined
  pool delay or has woken up thermal workqueue only to wait until device
  cools down.

Changes for v4:
- New patch

 drivers/thermal/thermal_core.c |   31 +++++++++++++++++++++++++++++++
 include/linux/thermal.h        |    2 ++
 2 files changed, 33 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index d755440..12adbad 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -33,6 +33,7 @@
 #include <linux/idr.h>
 #include <linux/thermal.h>
 #include <linux/reboot.h>
+#include <linux/cpufreq.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
@@ -326,6 +327,15 @@ static void monitor_thermal_zone(struct thermal_zone_device *tz)
 static void handle_non_critical_trips(struct thermal_zone_device *tz,
 			int trip, enum thermal_trip_type trip_type)
 {
+	if (cpufreq_boost_supported()) {
+		tz->overheated = true;
+		cpufreq_boost_trigger_state(0);
+		if (!tz->polling_delay) {
+			tz->boost_polling = true;
+			tz->polling_delay = 1000;
+		}
+	}
+
 	if (tz->governor)
 		tz->governor->throttle(tz, trip);
 }
@@ -453,6 +463,27 @@ static void thermal_zone_device_check(struct work_struct *work)
 	struct thermal_zone_device *tz = container_of(work, struct
 						      thermal_zone_device,
 						      poll_queue.work);
+	long trip_temp;
+
+	if (cpufreq_boost_supported() && tz->overheated) {
+		tz->ops->get_trip_temp(tz, 0, &trip_temp);
+		/*
+		 * Enable boost again only when current temperature is less
+		 * than 75% of trip_temp[0]
+		 */
+		if ((tz->temperature + (trip_temp >> 2)) < trip_temp) {
+			tz->overheated = false;
+			if (tz->boost_polling) {
+				tz->boost_polling = false;
+				tz->polling_delay = 0;
+				monitor_thermal_zone(tz);
+			}
+
+			cpufreq_boost_trigger_state(1);
+			return;
+		}
+	}
+
 	thermal_zone_device_update(tz);
 }
 
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index a386a1c..f1aa3c2 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -172,6 +172,8 @@ struct thermal_zone_device {
 	int emul_temperature;
 	int passive;
 	unsigned int forced_passive;
+	bool overheated;
+	bool boost_polling;
 	const struct thermal_zone_device_ops *ops;
 	const struct thermal_zone_params *tzp;
 	struct thermal_governor *governor;
-- 
1.7.10.4

