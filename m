Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3KER2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:28:02 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60152 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab3KER15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:27:57 -0500
X-AuditID: cbfee61b-b7fd56d000001fc6-19-52792a9cf9a2
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
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v10 7/7] thermal:exynos:boost: Automatic enable/disable of
 BOOST feature (at Exynos4412)
Date: Tue, 05 Nov 2013 18:26:51 +0100
Message-id: <1383672411-26324-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQd05WpVBBvN2C1o0XA2x2DhjPavF
	06Yf7BZ9P68wW6zZ/5PJovPsE2aLN4+4Ld483MxocXnXHDaLz71HGC1uN65gszhz+hKrxZOH
	fWwWG796OPB5LN7zksnjzrU9bB7rpr1l9thytZ3Fo2/LKkaP4ze2M3l83iQXwB7FZZOSmpNZ
	llqkb5fAlfHm2jq2gj3yFYumH2BsYJwq2cXIySEhYCLx4PdnJghbTOLCvfVsXYxcHEIC0xkl
	+o9dYoFwupgknmw6wgxSxSagJ/H57lMmkISIwBJGiddNC1hBHGaBvcwSk/6sBXI4OIQFsiR2
	bZcAaWARUJXo7HoPtoJXwE2ie/VVFoh18hJP7/exgdicAu4SO2bthVrdxCjx5vYEpgmMvAsY
	GVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfrM+kdjKsaLA4xCnAwKvHwJshXBgmxJpYV
	V+YeYpTgYFYS4T32vyJIiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutAIYH0xJLU7NTUgtQi
	mCwTB6dUA6N7xnzJInMX0c9qbC7N92UKSq97OXI2a2w6UVD26EjJcbmpERG//L8r9MvGpwkk
	SO4zX8y3KXXy9eC5f4T5F/xWbp5TrTXD/thylpf2vo2Pz16+uo/tWNb/uM+T58bcvWdyJ/1E
	1su8VBf5eWsKfolGuD6NuDLn4P8VhmuEJyuol72+uftQd60SS3FGoqEWc1FxIgAAHWd+UwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides auto disable/enable operation for boost. It uses already
present thermal infrastructure to provide boost hysteresis.
A special set of TMU data has been defined for Exynos4412, which is only
considered when BOOST is enabled.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
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

 drivers/thermal/samsung/exynos_tmu_data.c |   47 +++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/thermal/samsung/exynos_tmu_data.c b/drivers/thermal/samsung/exynos_tmu_data.c
index 073c292..9346926 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.c
+++ b/drivers/thermal/samsung/exynos_tmu_data.c
@@ -167,13 +167,60 @@ static const struct exynos_tmu_registers exynos4412_tmu_registers = {
 	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
 			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
 			TMU_SUPPORT_EMUL_TIME)
+
+#define EXYNOS4412_TMU_DATA_BOOST \
+	.threshold_falling = 10, \
+	.trigger_levels[0] = 70, \
+	.trigger_levels[1] = 85, \
+	.trigger_levels[2] = 103, \
+	.trigger_levels[3] = 110, \
+	.trigger_enable[0] = true, \
+	.trigger_enable[1] = true, \
+	.trigger_enable[2] = true, \
+	.trigger_enable[3] = true, \
+	.trigger_type[0] = THROTTLE_ACTIVE, \
+	.trigger_type[1] = THROTTLE_ACTIVE, \
+	.trigger_type[2] = THROTTLE_ACTIVE, \
+	.trigger_type[3] = SW_TRIP, \
+	.max_trigger_level = 4, \
+	.gain = 8, \
+	.reference_voltage = 16, \
+	.noise_cancel_mode = 4, \
+	.cal_type = TYPE_ONE_POINT_TRIMMING, \
+	.efuse_value = 55, \
+	.min_efuse_value = 40, \
+	.max_efuse_value = 100, \
+	.first_point_trim = 25, \
+	.second_point_trim = 85, \
+	.default_temp_offset = 50, \
+	.freq_tab[0] = { \
+		.freq_clip_max = 1400 * 1000, \
+		.temp_level = 70, \
+	}, \
+	.freq_tab[1] = { \
+		.freq_clip_max = 800 * 1000, \
+		.temp_level = 85, \
+	}, \
+	.freq_tab[2] = { \
+		.freq_clip_max = 200 * 1000, \
+		.temp_level = 103, \
+	}, \
+	.freq_tab_count = 3, \
+	.registers = &exynos4412_tmu_registers, \
+	.features = (TMU_SUPPORT_EMULATION | TMU_SUPPORT_TRIM_RELOAD | \
+			TMU_SUPPORT_FALLING_TRIP | TMU_SUPPORT_READY_STATUS | \
+			TMU_SUPPORT_EMUL_TIME)
 #endif
 
 #if defined(CONFIG_SOC_EXYNOS4412)
 struct exynos_tmu_init_data const exynos4412_default_tmu_data = {
 	.tmu_data = {
 		{
+#ifdef CONFIG_CPU_FREQ_BOOST_SW
+			EXYNOS4412_TMU_DATA_BOOST,
+#else
 			EXYNOS4412_TMU_DATA,
+#endif
 			.type = SOC_ARCH_EXYNOS4412,
 			.test_mux = EXYNOS4412_MUX_ADDR_VALUE,
 		},
-- 
1.7.10.4

