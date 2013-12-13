Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3LMQjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:39:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:39227 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3LMQjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:39:25 -0500
X-AuditID: cbfee61b-b7fbf6d0000051a3-4d-52ab383c8ed4
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v11 7/7] thermal:exynos:boost: Automatic enable/disable of
 BOOST feature (at Exynos4412)
Date: Fri, 13 Dec 2013 17:38:37 +0100
Message-id: <1386952717-30947-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQV0bi9VBBue2m1lsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAlfGsU9fmAr2SlQ82/2BvYFxkXAXIyeHhICJxK33b5kgbDGJC/fWs3UxcnEICUxn
	lHj99z8zSEJIoItJ4t9fRxCbTUBP4vPdp0wgRSICS4CKmhawgjjMAhuZJXbOfMsGUiUskCWx
	sesaWDeLgKrE7jOnGUFsXgE3icn989kh1ilKdD+bAFbPKeAuMW3TKkaI1U2MEs+v3GecwMi7
	gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwwD6T3sG4qsHiEKMAB6MSD69n76ogIdbE
	suLK3EOMEhzMSiK8Iaqrg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1I
	LYLJMnFwSjUwKuxO3u80fcr907YTXk7YGaTiVil4WPJs/cNNAsvjXzu9PtK1myc9qOBIl7fx
	Y2Mtu2a98PayGC3jZ+JdD+J7qy1Mn1hVXctY92Wy2dpw14MXJi8KemHv67PwiUjNw2puhoyt
	TZ7rzi1d0aRSl+L6hGXmkz2VK0suhEi5fPNatmb5hPXv5RPZlFiKMxINtZiLihMBokCuw1QC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides auto disable/enable operation for boost. It uses already
present thermal infrastructure to provide boost hysteresis.
The TMU data has been modified to work properly with or without boost.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
Changes for v11:
    - Use only one thermal data set
    - Adjust Exynos4412 thermal data to work with or without BOOST

Changes for v10:
    - Remove boost related code from thermal_core.c
    - Use already present thermal infrastructure to provide thermal hysteresis
    - Introduce special set of TMU data for BOOST

Changes for v9:
    - None

Changes for v8:
    - Move cpufreq_boost_* stub functions definition (needed when cpufreq
      is not compiled in) to cpufreq.h at cpufreq core support commit

Changes for v7:
    - None

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

 drivers/thermal/samsung/exynos_tmu_data.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 073c292..476b768 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -131,8 +131,8 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 
 #define EXYNOS4412_TMU_DATA \
 	.threshold_falling = 10, \
-	.trigger_levels[0] = 85, \
-	.trigger_levels[1] = 103, \
+	.trigger_levels[0] = 70, \
+	.trigger_levels[1] = 95, \
 	.trigger_levels[2] = 110, \
 	.trigger_levels[3] = 120, \
 	.trigger_enable[0] = true, \
@@ -155,12 +155,12 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.second_point_trim = 85, \
 	.default_temp_offset = 50, \
 	.freq_tab[0] = { \
-		.freq_clip_max = 800 * 1000, \
-		.temp_level = 85, \
+		.freq_clip_max = 1400 * 1000, \
+		.temp_level = 70, \
 	}, \
 	.freq_tab[1] = { \
-		.freq_clip_max = 200 * 1000, \
-		.temp_level = 103, \
+		.freq_clip_max = 400 * 1000, \
+		.temp_level = 95, \
 	}, \
 	.freq_tab_count = 2, \
 	.registers = &exynos4412_tmu_registers, \
-- 
1.7.10.4

