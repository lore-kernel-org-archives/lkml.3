Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3GYQeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:34:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41233 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab3GYQeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:34:17 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-45-51f153875167
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH v6 4/8] thermal:boost: Automatic enable/disable of BOOST feature
Date: Thu, 25 Jul 2013 18:33:27 +0200
Message-id: <1374770011-22171-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jQd324I+BBh/X61psnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaHG7cQWbRf/C
	XiaLJw/72Cw2fvVw4PdYvOclk8eda3vYPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6APYrL
	JiU1J7MstUjfLoEr4+fFxawFTZoV+3+sZm9gvK3YxcjJISFgIjFt82YmCFtM4sK99WxdjFwc
	QgLTGSUu/r4B5XQxSTyY+p0NpIpNQE/i892nYB0iAnMYJe4cdQcpYhZ4wCyx+PsXRpCEsECA
	xPPG8+xdjBwcLAKqEudv2oCEeQXcJDZumMsOsU1e4un9PrCZnALuEhMmT2GEWNbEKPHvxl3m
	CYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEh+0z6R2MqxosDjEKcDAq8fAqOH0M
	FGJNLCuuzD3EKMHBrCTCa24JFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1
	tSC1CCbLxMEp1cC4baMi7yOrCQrsm/dPZMq48CXrdWOobMJ2BrYFFnIiXE4cUSzcYc3r2qyC
	10UoP25vvdN2b2nJT+8vp+qjO08Wvl5+aUblhRKR3R2ML4S8J77hzuQq2vjEzP2vQ+GvjZrn
	TJV2tcd0Vydbb7F6+ExM9Mqdu307UmUTD9x8vdbMaZ2NhENFbpsSS3FGoqEWc1FxIgDs/do/
	VwIAAA==
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
Changes for v6:
- Disable boost only when supported and enabled
- Protect boost related thermal_zone_device struct fields with mutex
- Evaluate temperature trend during boost enable decision
- Create separate methods to handle boost enable/disable
  (thermal_boost_{enable|disable}) operations
- Boost is disabled at any trip point passage (not only the non critical one)
- Add stub definitions for cpufreq boost functions used when
  CONFIG_CPU_FREQ is NOT defined.

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

 drivers/thermal/thermal_core.c |   55 ++++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h        |   15 +++++++++++
 include/linux/thermal.h        |    2 ++
 3 files changed, 72 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 1f02e8e..8f4be55 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -34,6 +34,7 @@
 #include <linux/thermal.h>
 #include <linux/reboot.h>
 #include <linux/string.h>
+#include <linux/cpufreq.h>
 #include <net/netlink.h>
 #include <net/genetlink.h>
 
@@ -354,9 +355,59 @@ static void handle_critical_trips(struct thermal_zone_device *tz,
 	}
 }
 
+static int thermal_boost_enable(struct thermal_zone_device *tz)
+{
+	enum thermal_trend trend = get_tz_trend(tz, 0);
+	long trip_temp;
+
+	if (!tz->ops->get_trip_temp || !tz->overheated)
+		return -EPERM;
+	if (trend == THERMAL_TREND_RAISING || trend == THERMAL_TREND_RAISE_FULL)
+		return -EBUSY;
+
+	tz->ops->get_trip_temp(tz, 0, &trip_temp);
+	/*
+	 * Enable boost again only when current temperature is less
+	 * than 75% of trip_temp[0]
+	 */
+	if ((tz->temperature + (trip_temp >> 2)) < trip_temp) {
+		mutex_lock(&tz->lock);
+		tz->overheated = false;
+		if (tz->boost_polling) {
+			tz->boost_polling = false;
+			tz->polling_delay = 0;
+		}
+		mutex_unlock(&tz->lock);
+		cpufreq_boost_trigger_state(1);
+		return 0;
+	}
+	return -EBUSY;
+}
+
+static void thermal_boost_disable(struct thermal_zone_device *tz)
+{
+	cpufreq_boost_trigger_state(0);
+
+	/*
+	 * If no workqueue for monitoring is running - start one with
+	 * 1000 ms monitoring period
+	 * If workqueue already running - do not change its period and only
+	 * test if target CPU has cooled down
+	 */
+	mutex_lock(&tz->lock);
+	if (!tz->polling_delay) {
+		tz->boost_polling = true;
+		tz->polling_delay = 1000;
+	}
+	tz->overheated = true;
+	mutex_unlock(&tz->lock);
+}
+
 static void handle_thermal_trip(struct thermal_zone_device *tz, int trip)
 {
 	enum thermal_trip_type type;
+	if (cpufreq_boost_supported() && cpufreq_boost_enabled())
+		thermal_boost_disable(tz);
 
 	tz->ops->get_trip_type(tz, trip, &type);
 
@@ -455,6 +506,10 @@ static void thermal_zone_device_check(struct work_struct *work)
 	struct thermal_zone_device *tz = container_of(work, struct
 						      thermal_zone_device,
 						      poll_queue.work);
+	if (cpufreq_boost_supported())
+		if (!thermal_boost_enable(tz))
+			return;
+
 	thermal_zone_device_update(tz);
 }
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 49a73c9..3d9276d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -435,9 +435,24 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 				   unsigned int relation,
 				   unsigned int *index);
 
+#ifdef CONFIG_CPU_FREQ
 int cpufreq_boost_trigger_state(int state);
 int cpufreq_boost_supported(void);
 int cpufreq_boost_enabled(void);
+#else
+static inline int cpufreq_boost_trigger_state(int state)
+{
+	return 0;
+}
+static inline int cpufreq_boost_supported(void)
+{
+	return 0;
+}
+static inline int cpufreq_boost_enabled(void)
+{
+	return 0;
+}
+#endif
 /* the following 3 funtions are for cpufreq core use only */
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 
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

