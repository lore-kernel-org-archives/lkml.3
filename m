Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422871Ab3LTOZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:25:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64412 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422815Ab3LTOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:25:48 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-fd-52b4536b93f7
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH v12 7/7] thermal:exynos:boost: Automatic enable/disable of
 BOOST feature (at Exynos4412)
Date: Fri, 20 Dec 2013 15:24:55 +0100
Message-id: <1387549495-809-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387549495-809-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1387549495-809-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t9jQd3s4C1BBm0bVC02zljPavG06Qe7
	Rd/PK8wWa/b/ZLLoPPuE2eLNI26LNw83M1pc3jWHzeJz7xFGixnn9zFZ3G5cwWZx5vQlVosn
	D/vYLDZ+9XDg81i85yWTx51re9g81k17y+yx5Wo7i0ffllWMHsdvbGfy+LxJLoA9issmJTUn
	syy1SN8ugSujbdFbtoIlihUrer+yNTBulupi5OSQEDCRWPTlMzOELSZx4d56ti5GLg4hgemM
	Es/nToVyupgklq+8wghSxSagJ/H57lMmEFtEoJlR4tZzP5AiZoFLzBIdS6+CjRIWyJJo+v6K
	tYuRg4NFQFXi+sU4kDCvgIvEwtNH2CC2KUp0P5sAZnMKuEqsXnsHbL6QQAOjRNNG1QmMvAsY
	GVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfrM+kdjKsaLA4xCnAwKvHwFuhvDhJiTSwr
	rsw9xCjBwawkwvvZZ0uQEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalF
	MFkmDk6pBkbLrNaJHW9P+Vkvva6x/Xv1DYOIJ6l1BcekPwiFPa28Ytre+X7nsiOC3lOYTjZP
	t9rGs+Tnu3chU4UYvE4uVMp4pbBRdAHD3CULHslEHQlbz50k8tlm5fswx3mVKeyT5976mN9g
	2n6J9VnwhW3nExgCYs7cdeyNnDdnkqfDR06THxLLJV5XVGUosRRnJBpqMRcVJwIAm47xtVIC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides auto disable/enable operation for boost. It uses already
present thermal infrastructure to provide BOOST hysteresis.
The TMU data has been modified to work properly with or without BOOST.
Hence, the two first trip points with corresponding clip frequencies were
adjusted.

The first one was reduced from 85 to 70 degrees and clip frequency was
increased to 1.4 GHz from 800 MHz. This trip point is in fact responsible
for providing BOOST hysteresis. When temperature exceeds 70 deg, the maximal
non BOOST frequency for Exynos4412 is imposed.

Since the first trigger level has been "stolen" for BOOST, the second one
needs to be a compromise for the previously used two for non BOOST
configuration. The 95 deg with modified clip freq (to 400 MHz) shall provide
a good balance between cooling down the overheated device and throughput on
an acceptable level.

Two last trigger levels were not modified since, they cause platform shutdown
on emergency overheat situation.
Third trip point passage results in SW managed shut down of the system.
If the last trip point is crossed, the PMU HW generates the power off
signal.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>

---
Changes for v12:
    - More verbose patch description to explain new TMU temperature assignment
      for Exynos4412

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

