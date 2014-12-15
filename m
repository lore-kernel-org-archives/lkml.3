Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaLOO6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:58:09 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27069 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaLOO5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:57:14 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-b9-548ef6c6352b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/3] devfreq: exynos: Add driver for Exynos3250
Date: Mon, 15 Dec 2014 15:56:52 +0100
Message-id: <1418655413-25410-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418655413-25410-1-git-send-email-k.kozlowski@samsung.com>
References: <1418655413-25410-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xq7rHvvWFGGzcZ2axccZ6VovrX56z
	Wsw/co7V4vULQ4v+x6+ZLc42vWG32PT4GqvF5V1z2Cw+9x5htJhxfh+Txdojd9ktll6/yGRx
	u3EFmwOvx5p5axg9Nq3qZPPYvKTeo2/LKkaPz5vkAlijuGxSUnMyy1KL9O0SuDJOH13FXjDv
	AmPFrYO72BsYn65g7GLk5JAQMJGY1jCPBcIWk7hwbz1bFyMXh5DAUkaJhx/+skA4fUwSy499
	YAepYhMwlti8fAlYlYjAcyaJnbPegFUxC8xglLi3cBfYLGEBJ4lNy7vAOlgEVCWmHb0Oto9X
	wF3i3aoJUPvkJE4em8wKYnMKeEhced0IVi8EVLP+9FK2CYy8CxgZVjGKppYmFxQnpeca6hUn
	5haX5qXrJefnbmKEhOWXHYyLj1kdYhTgYFTi4U3Y2xsixJpYVlyZe4hRgoNZSYR31ru+ECHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2M7K2a5xYebE107Ir60csXMX37Xt1Fizz+njfXubxky7/3
	WUpzbNk1v15qXinq0an7QHnK+w65M1YRWYt3sDEvejKrmWWW7pPOo2fdOfSm/vbN/K9gYbhj
	0dOf7z59OiuS/7y4/5FB0ZqDej5tX5qYXJrDijRmvUpxiQ/7cKJy/zqRzxL3GjdaK7EUZyQa
	ajEXFScCAJ8eYTwpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new devfreq driver for Exynos3250. The driver utilizes devfreq event
class for bus utilization data is multiplatform safe. Currently it does
not support ASV (Adaptive Supply Voltage).

Driver creates two devices:
 - Dynamic Memory Controller (DMC) and memory bus,
 - peripheral (left/right) buses.

For memory it changes the DMC clock from 50 MHz to 400 MHz and MIF
voltage regulator from 800 mV to 875 mV.
As for peripheral it changes the frequencies of multiple bus clocks and
INT voltage regulator from 850 mV to 950 mV.

Impact on performance (Rinato/Gear 2 board) calculated with:
$ perf bench mem memcpy -l 256MB -i 10
$ perf bench mem memset -l 256MB -i 10
$ dd if=/dev/mmcblk0p15 of=/opt/file iflag=direct oflag=direct count=128 bs=1M

 type           | no devfreq [MB/s] | devfreq [MB/s] |   diff
=============================================================
memcpy          | 152.016           | 151.590        |  -0.3%
memcpy prefault | 166.636           | 166.598        |   0.0%
memset          | 126.832           | 112.814        | -11.0%
memset prefault | 168.349           | 168.287        |  -0.0%
MMC transfer    |  19.0             |  18.5          |  -2.6%

Impact on energy consumption, system in idle (WFI), mA:
 no devfreq [mA] | devfreq [mA] |   diff
========================================
 29.0            | 19.2         | -33.8%

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/devfreq/Kconfig              |  12 +
 drivers/devfreq/Makefile             |   1 +
 drivers/devfreq/exynos/Makefile      |   1 +
 drivers/devfreq/exynos/exynos3_bus.c | 847 +++++++++++++++++++++++++++++++++++
 4 files changed, 861 insertions(+)
 create mode 100644 drivers/devfreq/exynos/exynos3_bus.c

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index d4559f7866d6..ed4718bad8c9 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -65,6 +65,18 @@ config DEVFREQ_GOV_USERSPACE
 
 comment "DEVFREQ Drivers"
 
+config ARM_EXYNOS3_BUS_DEVFREQ
+	bool "ARM Exynos3250 Memory and peripheral bus DEVFREQ Driver"
+	depends on SOC_EXYNOS3250
+	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	select PM_OPP
+	help
+	  This adds the DEVFREQ driver for Exynos3250 memory interface
+	  and peripheral bus (vdd_mif + vdd_int).
+	  It reads PPMU counters of memory controllers and adjusts
+	  the operating frequencies and voltages with OPP support.
+	  This does not yet operate with optimal voltages.
+
 config ARM_EXYNOS4_BUS_DEVFREQ
 	bool "ARM Exynos4210/4212/4412 Memory Bus DEVFREQ Driver"
 	depends on (CPU_EXYNOS4210 || SOC_EXYNOS4212 || SOC_EXYNOS4412) && !ARCH_MULTIPLATFORM
diff --git a/drivers/devfreq/Makefile b/drivers/devfreq/Makefile
index a1ffabe90a14..780f1c4724ea 100644
--- a/drivers/devfreq/Makefile
+++ b/drivers/devfreq/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_DEVFREQ_GOV_POWERSAVE)	+= governor_powersave.o
 obj-$(CONFIG_DEVFREQ_GOV_USERSPACE)	+= governor_userspace.o
 
 # DEVFREQ Drivers
+obj-$(CONFIG_ARM_EXYNOS3_BUS_DEVFREQ)	+= exynos/
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos/
 obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos/
 
diff --git a/drivers/devfreq/exynos/Makefile b/drivers/devfreq/exynos/Makefile
index 49bc9175f923..a4aa1ed474c9 100644
--- a/drivers/devfreq/exynos/Makefile
+++ b/drivers/devfreq/exynos/Makefile
@@ -1,3 +1,4 @@
 # Exynos DEVFREQ Drivers
+obj-$(CONFIG_ARM_EXYNOS3_BUS_DEVFREQ)	+= exynos_ppmu.o exynos3_bus.o
 obj-$(CONFIG_ARM_EXYNOS4_BUS_DEVFREQ)	+= exynos_ppmu.o exynos4_bus.o
 obj-$(CONFIG_ARM_EXYNOS5_BUS_DEVFREQ)	+= exynos_ppmu.o exynos5_bus.o
diff --git a/drivers/devfreq/exynos/exynos3_bus.c b/drivers/devfreq/exynos/exynos3_bus.c
new file mode 100644
index 000000000000..e01c3d90d2b8
--- /dev/null
+++ b/drivers/devfreq/exynos/exynos3_bus.c
@@ -0,0 +1,847 @@
+/*
+ * drivers/devfreq/exynos/exynos3_bus.c
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * based on drivers/devfreqw/exynos/exynos4_bus.c
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *
+ * EXYNOS3250 - Memory/Bus clock frequency scaling support in DEVFREQ framework
+ * This version supports EXYNOS3250 only.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/clk.h>
+#include <linux/devfreq.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/pm_opp.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/suspend.h>
+
+
+/*#include "exynos_ppmu.h"*/
+
+/*
+ * Assume that the bus is saturated if the utilization is 30%.
+ *
+ * Saturation ratio is less than that in exynos4_bus.c (40%) to boost
+ * ondemand governor early.
+ * Memory tests (memcpy, memory alloc, dmatest) shown that ratio of 40%
+ * triggers frequency increase sporadically.
+ */
+#define EXYNOS3_BUS_SATURATION_RATIO	30
+#define EXYNOS3_BUS_INT_REGULATOR_NAME	"vdd-int"
+#define EXYNOS3_BUS_MIF_REGULATOR_NAME	"vdd-mif"
+
+#define EXYNOS3_BUS_PPMU_NUM		2
+
+#define EXYNOS3_BUS_INTERVAL_SAFEVOLT	25000	/* 25mV */
+
+enum exynos3_busfreq_type {
+	TYPE_BUSFREQ_UNKNOWN = 0,
+	TYPE_BUSFREQ_EXYNOS3250_MIF,
+	TYPE_BUSFREQ_EXYNOS3250_INT,
+};
+
+enum exynos3_busfreq_level {
+	LV_0,
+	LV_1,
+	LV_2,
+	LV_3,
+	LV_4,
+	LV_5,
+
+	LV_END,
+};
+
+enum exynos3_bus_mif_clk {
+	DMC,
+	EXYNOS3_BUS_MIF_CLK_END,
+};
+
+enum exynos3_bus_int_clk {
+	ACLK_400,
+	ACLK_266,
+	ACLK_200,
+	ACLK_160,
+	ACLK_GDL,
+	ACLK_GDR,
+	MFC,
+	EXYNOS3_BUS_INT_CLK_END,
+};
+
+static const char * const exynos3_bus_mif_clk_name[] = {
+	[DMC]		= "dmc",
+};
+
+static const char * const exynos3_bus_int_clk_name[] = {
+	[ACLK_400]	= "aclk_400",
+	[ACLK_266]	= "aclk_266",
+	[ACLK_200]	= "aclk_200",
+	[ACLK_160]	= "aclk_160",
+	[ACLK_GDL]	= "aclk_gdl",
+	[ACLK_GDR]	= "aclk_gdr",
+	[MFC]		= "mfc",
+};
+
+/**
+ * struct busfreq_opp_info - opp information for bus
+ * @rate:	Frequency in hertz
+ * @volt:	Voltage in microvolts corresponding to this OPP
+ */
+struct busfreq_opp_info {
+	unsigned long rate;
+	unsigned long volt;
+};
+
+struct busfreq_opp_table {
+	unsigned int idx;
+	unsigned long clk;
+	unsigned long volt;
+};
+
+struct busfreq_data {
+	struct devfreq_dev_profile *profile;
+	enum exynos3_busfreq_type type;
+	struct device *dev;
+	struct devfreq *devfreq;
+	bool disabled;
+
+	struct busfreq_opp_info curr_opp_info;
+
+	struct regulator *regulator_vdd;
+	struct devfreq_event_dev *edevs[EXYNOS3_BUS_PPMU_NUM];
+	struct clk **clk_bus;
+	unsigned int clk_bus_num;
+
+	const struct busfreq_opp_table *opp_table;
+	int opp_table_end;
+
+	struct notifier_block pm_notifier;
+	struct mutex lock;
+};
+
+static const struct busfreq_opp_table exynos3_bus_mif_clk_table[] = {
+	/*   DMC clock, MIF voltage */
+	{LV_0,	400000,	875000},
+	{LV_1,	200000,	800000},
+	{LV_2,	133000,	800000},
+	{LV_3,	100000,	800000},
+	{LV_4,	 50000,	800000},
+};
+
+/*
+ * The frequency for INT is an abstract clock, without real representation
+ * because INT actually changes multiple clocks. Values for this frequency
+ * match MIF/DMC clock (except one additional level: 80000).
+ */
+static const struct busfreq_opp_table exynos3_bus_int_clk_table[] = {
+	/* abstract clock, INT voltage */
+	{LV_0,	400000,	950000},
+	{LV_1,	200000,	950000},
+	{LV_2,	133000, 925000},
+	{LV_3,	100000, 850000},
+	{LV_4,	80000,  850000},
+	{LV_5,	50000,  850000},
+};
+
+static const unsigned int exynos3_bus_mif_clk_freq[][EXYNOS3_BUS_MIF_CLK_END] = {
+		/* DMC */
+	[LV_0] = { 400000000, },
+	[LV_1] = { 200000000, },
+	[LV_2] = { 133333334, },
+	[LV_3] = { 100000000, },
+	[LV_4] = {  50000000, },
+};
+
+static const unsigned int exynos3_bus_int_clk_freq[][EXYNOS3_BUS_INT_CLK_END] = {
+		/*  ACLK_400,  ACLK_266,  ACLK_200,  ACLK_160,  ACLK_GDL,  ACLK_GDR, MFC */
+	[LV_0] = { 400000000, 300000000, 200000000, 200000000, 200000000, 200000000, 200000000, },
+	[LV_1] = { 200000000, 200000000, 200000000, 133333334, 200000000, 200000000, 200000000, },
+	[LV_2] = {  50000000, 133333334, 100000000, 100000000, 133333334, 133333334, 200000000, },
+	[LV_3] = {  50000000,  50000000,  80000000,  80000000, 100000000, 100000000, 133333334, },
+	[LV_4] = {  50000000,  50000000,  50000000,  50000000, 100000000, 100000000, 100000000, },
+	[LV_5] = {  50000000,  50000000,  50000000,  50000000, 100000000, 100000000,  80000000, },
+};
+
+static int round_set_clk(struct device *dev, int id, struct clk *clk,
+		unsigned long rate)
+{
+	int ret;
+	long real_rate;
+
+	real_rate = clk_round_rate(clk, rate);
+	if (real_rate <= 0) {
+		dev_err(dev, "Cannot round clock rate %d to %lu: %ld\n",
+				id, rate, real_rate);
+		return -EINVAL;
+	}
+
+	ret = clk_set_rate(clk, real_rate);
+	if (ret) {
+		dev_err(dev, "Cannot set clock rate %d to %lu: %d",
+				id, real_rate, ret);
+		return ret;
+	}
+
+	dev_dbg(dev, "Clock %d to %lu/%lu\n", id, rate, real_rate);
+
+	return 0;
+}
+
+static int exynos3_bus_set_clk(struct busfreq_data *data,
+				  struct busfreq_opp_info *new_opp_info)
+{
+	int index, i, clk_num;
+	const unsigned int *clk_freq;
+
+	for (index = 0; index < data->opp_table_end; index++)
+		if (new_opp_info->rate == data->opp_table[index].clk)
+			break;
+
+	if (index == data->opp_table_end)
+		return -EINVAL;
+
+	switch (data->type) {
+	case TYPE_BUSFREQ_EXYNOS3250_MIF:
+		clk_num = EXYNOS3_BUS_MIF_CLK_END;
+		clk_freq = exynos3_bus_mif_clk_freq[index];
+		break;
+	case TYPE_BUSFREQ_EXYNOS3250_INT:
+		clk_num = EXYNOS3_BUS_INT_CLK_END;
+		clk_freq = exynos3_bus_int_clk_freq[index];
+		break;
+	default:
+		dev_err(data->dev, "Unknown device type %d\n", data->type);
+		return -EINVAL;
+	};
+
+	for (i = 0; i < clk_num; i++) {
+		int ret;
+
+		ret = round_set_clk(data->dev, i, data->clk_bus[i],
+				clk_freq[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int exynos3_bus_set_volt(struct busfreq_data *data,
+				struct busfreq_opp_info *new_opp_info,
+				struct busfreq_opp_info *old_opp_info)
+{
+	int ret;
+
+	ret = regulator_set_voltage(data->regulator_vdd, new_opp_info->volt,
+			new_opp_info->volt + EXYNOS3_BUS_INTERVAL_SAFEVOLT);
+	if (ret < 0) {
+		dev_err(data->dev, "Failed to set voltage %d\n", data->type);
+		regulator_set_voltage(data->regulator_vdd, old_opp_info->volt,
+			old_opp_info->volt + EXYNOS3_BUS_INTERVAL_SAFEVOLT);
+	}
+
+	return 0;
+}
+
+/*
+ * Define internal function of structure devfreq_dev_profile
+ */
+static int exynos3_bus_target(struct device *dev, unsigned long *_freq,
+			      u32 flags)
+{
+	struct busfreq_data *data = dev_get_drvdata(dev);
+	struct busfreq_opp_info	new_opp_info;
+	unsigned long old_freq, new_freq;
+	struct dev_pm_opp *opp;
+	int ret = 0;
+
+	if (data->disabled)
+		goto out;
+
+	/* Get new opp-info instance according to new busfreq clock */
+	rcu_read_lock();
+	opp = devfreq_recommended_opp(dev, _freq, flags);
+	if (IS_ERR_OR_NULL(opp)) {
+		dev_err(dev, "Failed to get recommed opp instance\n");
+		rcu_read_unlock();
+		return PTR_ERR(opp);
+	}
+	new_opp_info.rate = dev_pm_opp_get_freq(opp);
+	new_opp_info.volt = dev_pm_opp_get_voltage(opp);
+	rcu_read_unlock();
+
+	old_freq = data->curr_opp_info.rate;
+	new_freq = new_opp_info.rate;
+	if (old_freq == new_freq)
+		return 0;
+
+	dev_dbg(dev, "%lu MHz, %ld mV --> %lu MHz, %ld mV\n",
+		old_freq / 1000, data->curr_opp_info.volt / 1000,
+		new_freq / 1000, new_opp_info.volt / 1000);
+
+	/* Change voltage/clock according to new busfreq level */
+	mutex_lock(&data->lock);
+
+	if (old_freq < new_freq) {
+		ret = exynos3_bus_set_volt(data, &new_opp_info,
+					   &data->curr_opp_info);
+		if (ret < 0) {
+			dev_err(dev, "Failed to set voltage %d\n", data->type);
+			goto out;
+		}
+	}
+
+	ret = exynos3_bus_set_clk(data, &new_opp_info);
+	if (ret < 0) {
+		dev_err(dev, "Failed to set bus clock %d\n", data->type);
+		goto out;
+	}
+
+	if (old_freq > new_freq) {
+		ret = exynos3_bus_set_volt(data, &new_opp_info,
+					   &data->curr_opp_info);
+		if (ret < 0) {
+			dev_err(dev, "Failed to set voltage %d\n", data->type);
+			goto out;
+		}
+	}
+
+	data->curr_opp_info = new_opp_info;
+out:
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
+static int exynos3_bus_edev_set_event(struct busfreq_data *data)
+{
+	int i, ret;
+
+	for (i = 0; i < EXYNOS3_BUS_PPMU_NUM; i++) {
+		ret = devfreq_event_set_event(data->edevs[i],
+				DEVFREQ_EVENT_TYPE_RAW_DATA);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int exynos3_bus_edev_enable(struct busfreq_data *data)
+{
+	int i, ret;
+
+	for (i = 0; i < EXYNOS3_BUS_PPMU_NUM; i++) {
+		ret = devfreq_event_enable_edev(data->edevs[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int exynos3_bus_edev_disable(struct busfreq_data *data)
+{
+	int i, ret;
+
+	for (i = 0; i < EXYNOS3_BUS_PPMU_NUM; i++) {
+		ret = devfreq_event_disable_edev(data->edevs[i]);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int exynos3_bus_get_dev_status(struct device *dev,
+				      struct devfreq_dev_status *stat)
+{
+	struct busfreq_data *data = dev_get_drvdata(dev);
+	u64 cnt[EXYNOS3_BUS_PPMU_NUM], total[EXYNOS3_BUS_PPMU_NUM], max_cnt = 0;
+	int busier, ret, i;
+
+	/* Read PPMU total cycle count and Read/Write count */
+	for (i = 0; i < EXYNOS3_BUS_PPMU_NUM; i++) {
+		cnt[i] = devfreq_event_get_event(data->edevs[i],
+				DEVFREQ_EVENT_TYPE_RAW_DATA, &total[i]);
+		/*
+		 * FIXME: devfreq_event_get_event should return 0/err, not
+		 * counter value.
+		 */
+		if (cnt[i] == (u64)-EINVAL)
+			return -EINVAL;
+	}
+
+	/* Re-enable after reading data */
+	ret = exynos3_bus_edev_set_event(data);
+	if (ret < 0)
+		return ret;
+
+	/* Find the busiest PPMU */
+	for (i = 0; i < EXYNOS3_BUS_PPMU_NUM; i++) {
+		if (cnt[i] >= max_cnt) {
+			max_cnt = cnt[i];
+			busier = i;
+		}
+	}
+
+	if (total[busier] == 0) {
+		WARN_ONCE(true, "Empty data returned by PPMU\n");
+		return -EIO;
+	}
+
+	stat->current_frequency = data->curr_opp_info.rate;
+
+	/* Number of cycles spent on memory access */
+	stat->busy_time = cnt[busier];
+	stat->busy_time *= 100 / EXYNOS3_BUS_SATURATION_RATIO;
+	stat->total_time = total[busier];
+
+	return 0;
+}
+
+static void exynos3_bus_cleanup_clocks(struct busfreq_data *data)
+{
+	int i;
+
+	for (i = 0; i < data->clk_bus_num; i++) {
+		if (data->clk_bus[i])
+			clk_disable_unprepare(data->clk_bus[i]);
+	}
+}
+
+static void exynos3_bus_exit(struct device *dev)
+{
+	struct busfreq_data *data = dev_get_drvdata(dev);
+
+	regulator_disable(data->regulator_vdd);
+	/*
+	 * FIXME: Reverse the devfreq_event_get_edev_by_phandle
+	 *   -> of_node_put.
+	 */
+	exynos3_bus_cleanup_clocks(data);
+}
+
+/* Define devfreq_dev_profile for MIF block */
+static struct devfreq_dev_profile exynos3_busfreq_mif_profile = {
+	.initial_freq	= 400000,
+	.polling_ms	= 100,
+	.target		= exynos3_bus_target,
+	.get_dev_status	= exynos3_bus_get_dev_status,
+	.exit		= exynos3_bus_exit,
+};
+
+/* Define devfreq_dev_profile for INT block */
+static struct devfreq_dev_profile exynos3_busfreq_int_profile = {
+	.initial_freq	= 400000,
+	.polling_ms	= 100,
+	.target		= exynos3_bus_target,
+	.get_dev_status	= exynos3_bus_get_dev_status,
+	.exit		= exynos3_bus_exit,
+};
+
+static int exynos3_bus_pm_notifier_event(struct notifier_block *this,
+					     unsigned long event, void *ptr)
+{
+	struct busfreq_data *data = container_of(this, struct busfreq_data,
+						 pm_notifier);
+	struct dev_pm_opp *opp;
+	struct busfreq_opp_info	new_opp_info;
+	unsigned long maxfreq = ULONG_MAX;
+	int err = 0;
+
+	switch (event) {
+	case PM_SUSPEND_PREPARE:
+		mutex_lock(&data->lock);
+
+		data->disabled = true;
+
+		rcu_read_lock();
+		opp = dev_pm_opp_find_freq_floor(data->dev, &maxfreq);
+		if (IS_ERR(opp)) {
+			rcu_read_unlock();
+			dev_err(data->dev, "%s: unable to find a min freq\n",
+				__func__);
+			mutex_unlock(&data->lock);
+			return PTR_ERR(opp);
+		}
+		new_opp_info.rate = dev_pm_opp_get_freq(opp);
+		new_opp_info.volt = dev_pm_opp_get_voltage(opp);
+		rcu_read_unlock();
+
+		err = exynos3_bus_set_volt(data, &new_opp_info,
+					   &data->curr_opp_info);
+		if (err) {
+			mutex_unlock(&data->lock);
+			return err;
+		}
+
+		err = exynos3_bus_set_clk(data, &new_opp_info);
+		if (err) {
+			mutex_unlock(&data->lock);
+			return err;
+		}
+
+		data->curr_opp_info = new_opp_info;
+
+		mutex_unlock(&data->lock);
+		if (err)
+			return err;
+		return NOTIFY_OK;
+	case PM_POST_RESTORE:
+	case PM_POST_SUSPEND:
+		/* Reactivate */
+		mutex_lock(&data->lock);
+		data->disabled = false;
+		mutex_unlock(&data->lock);
+		return NOTIFY_OK;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static int exynos3_bus_init_table(struct busfreq_data *data)
+{
+	int i, ret;
+
+	/* Add OPP entry including the voltage/clock of busfreq level */
+	for (i = 0; i < data->opp_table_end; i++) {
+		ret = dev_pm_opp_add(data->dev,
+			      data->opp_table[i].clk,
+			      data->opp_table[i].volt);
+		if (ret < 0) {
+			dev_err(data->dev, "Failed to add opp entry(%ld,%ld)\n",
+				data->opp_table[i].clk,
+				data->opp_table[i].volt);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int exynos3_bus_parse_dt(struct busfreq_data *data)
+{
+	struct device *dev = data->dev;
+	char regulator_name[DEVFREQ_NAME_LEN];
+	const char * const *bus_clk_name;
+	int i, ret = 0;
+
+	switch (data->type) {
+	case TYPE_BUSFREQ_EXYNOS3250_MIF:
+		data->profile		= &exynos3_busfreq_mif_profile;
+		data->opp_table		= exynos3_bus_mif_clk_table;
+		data->opp_table_end	= ARRAY_SIZE(exynos3_bus_mif_clk_table);
+
+		bus_clk_name		= exynos3_bus_mif_clk_name;
+		data->clk_bus_num	= ARRAY_SIZE(exynos3_bus_mif_clk_name);
+		strcpy(regulator_name,	EXYNOS3_BUS_MIF_REGULATOR_NAME);
+		break;
+	case TYPE_BUSFREQ_EXYNOS3250_INT:
+		data->profile		= &exynos3_busfreq_int_profile;
+		data->opp_table		= exynos3_bus_int_clk_table;
+		data->opp_table_end	= ARRAY_SIZE(exynos3_bus_int_clk_table);
+
+		bus_clk_name		= exynos3_bus_int_clk_name;
+		data->clk_bus_num	= ARRAY_SIZE(exynos3_bus_int_clk_name);
+		strcpy(regulator_name,	EXYNOS3_BUS_INT_REGULATOR_NAME);
+
+		break;
+	default:
+		dev_err(dev, "Unknown device id %d\n", data->type);
+		return -EINVAL;
+	};
+
+	data->clk_bus = devm_kzalloc(dev,
+				sizeof(struct clk *) * data->clk_bus_num,
+				GFP_KERNEL);
+	if (!data->clk_bus)
+		return -ENOMEM;
+
+	for (i = 0; i < data->clk_bus_num; i++) {
+		data->clk_bus[i] = devm_clk_get(dev, bus_clk_name[i]);
+		if (IS_ERR_OR_NULL(data->clk_bus[i])) {
+			dev_err(dev, "Cannot get %s clock: %ld\n",
+					bus_clk_name[i],
+					PTR_ERR(data->clk_bus[i]));
+			goto err_clocks;
+		}
+
+		ret = clk_prepare_enable(data->clk_bus[i]);
+		if (ret < 0) {
+			dev_err(dev, "Cannot enable %s clock: %d\n",
+						bus_clk_name[i], ret);
+			data->clk_bus[i] = NULL;
+			goto err_clocks;
+		}
+	}
+
+	for (i = 0; i < EXYNOS3_BUS_PPMU_NUM; i++) {
+		data->edevs[i] = devfreq_event_get_edev_by_phandle(dev, i);
+		if (IS_ERR(data->edevs[i])) {
+			ret = PTR_ERR(data->edevs[i]);
+			/*
+			 * FIXME: Reverse the devfreq_event_get_edev_by_phandle
+			 *   -> of_node_put.
+			 */
+			goto err_clocks;
+		}
+	}
+
+	/* Get regulators to control voltage of int/mif block */
+	data->regulator_vdd = devm_regulator_get(dev, regulator_name);
+	if (IS_ERR(data->regulator_vdd)) {
+		dev_err(dev, "Failed to get the regulator \"%s\": %ld\n",
+			regulator_name, PTR_ERR(data->regulator_vdd));
+		ret = -EINVAL;
+		goto err_clocks;
+	}
+
+	ret = regulator_enable(data->regulator_vdd);
+	if (ret < 0) {
+		dev_err(dev, "Failed to enable regulator: %d\n", ret);
+		goto err_clocks;
+	}
+
+	return 0;
+
+err_clocks:
+	/*
+	 * FIXME: Reverse the devfreq_event_get_edev_by_phandle
+	 *   -> of_node_put.
+	 */
+	exynos3_bus_cleanup_clocks(data);
+
+	return ret;
+}
+
+static struct of_device_id exynos3_busfreq_id_match[] = {
+	{
+		.compatible = "samsung,exynos3250-busfreq-mif",
+		.data = (void *)TYPE_BUSFREQ_EXYNOS3250_MIF,
+	}, {
+		.compatible = "samsung,exynos3250-busfreq-int",
+		.data = (void *)TYPE_BUSFREQ_EXYNOS3250_INT,
+	},
+	{},
+};
+
+static int exynos3_busfreq_get_driver_data(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos3_busfreq_id_match, dev->of_node);
+	if (!match)
+		return -ENODEV;
+
+	return (int)match->data;
+}
+
+static int exynos3_busfreq_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct busfreq_data *data;
+	struct dev_pm_opp *opp;
+	int ret = 0;
+
+	if (!dev->of_node)
+		return -EINVAL;
+
+	data = devm_kzalloc(dev, sizeof(struct busfreq_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->type = exynos3_busfreq_get_driver_data(pdev);
+	data->dev = dev;
+	mutex_init(&data->lock);
+	platform_set_drvdata(pdev, data);
+
+	switch (data->type) {
+	case TYPE_BUSFREQ_EXYNOS3250_MIF:
+	case TYPE_BUSFREQ_EXYNOS3250_INT:
+		/* Parse dt data to get register/clock/regulator */
+		ret = exynos3_bus_parse_dt(data);
+		if (ret < 0) {
+			dev_err(dev, "Failed to parse dt for resource %d\n",
+				data->type);
+			return ret;
+		}
+
+		/* Initialize Memory Bus Voltage/Frequency table */
+		ret = exynos3_bus_init_table(data);
+		if (ret < 0) {
+			dev_err(dev, "Failed to initialze volt/freq table %d\n",
+				data->type);
+			return ret;
+		}
+		break;
+	default:
+		dev_err(dev, "Unknown device id %d\n", data->type);
+		return -EINVAL;
+	}
+
+	/* Find the proper opp instance according to initial bus frequency */
+	rcu_read_lock();
+	opp = dev_pm_opp_find_freq_floor(dev, &data->profile->initial_freq);
+	if (IS_ERR_OR_NULL(opp)) {
+		rcu_read_unlock();
+		dev_err(dev, "Failed to find initial frequency %lu kHz, %d\n",
+			      data->profile->initial_freq, data->type);
+		ret = PTR_ERR(opp);
+		goto err_opp;
+	}
+	data->curr_opp_info.rate = dev_pm_opp_get_freq(opp);
+	data->curr_opp_info.volt = dev_pm_opp_get_voltage(opp);
+	rcu_read_unlock();
+
+	ret = exynos3_bus_edev_enable(data);
+	if (ret < 0) {
+		dev_err(dev, "Failed to enable devfreq event device: %d\n", ret);
+		goto err_opp;
+	}
+
+	ret = exynos3_bus_edev_set_event(data);
+	if (ret < 0) {
+		dev_err(dev, "Failed to set devfreq events: %d\n", ret);
+		goto err_event_set;
+	}
+
+	/* Reigster Exynos3250's devfreq instance with 'simple_ondemand' gov */
+	data->devfreq = devfreq_add_device(dev, data->profile,
+					   "simple_ondemand", NULL);
+	if (IS_ERR_OR_NULL(data->devfreq)) {
+		dev_err(dev, "Failed to add devfreq device\n");
+		ret = PTR_ERR(data->devfreq);
+		goto err_event_set;
+	}
+
+	/* Register opp_notifier for Exynos3 busfreq */
+	ret = devfreq_register_opp_notifier(dev, data->devfreq);
+	if (ret < 0) {
+		dev_err(dev, "Failed to register opp notifier\n");
+		goto err_notifier_opp;
+	}
+
+	/* Register pm_notifier for Exynos3 busfreq */
+	data->pm_notifier.notifier_call = exynos3_bus_pm_notifier_event;
+	ret = register_pm_notifier(&data->pm_notifier);
+	if (ret < 0) {
+		dev_err(dev, "Failed to register pm notifier\n");
+		goto err_notifier_pm;
+	}
+
+	return 0;
+
+err_notifier_pm:
+	devfreq_unregister_opp_notifier(dev, data->devfreq);
+err_notifier_opp:
+	devfreq_remove_device(data->devfreq);
+err_event_set:
+	exynos3_bus_edev_disable(data);
+err_opp:
+	regulator_disable(data->regulator_vdd);
+	/*
+	 * FIXME: Reverse the devfreq_event_get_edev_by_phandle
+	 *   -> of_node_put.
+	 */
+	exynos3_bus_cleanup_clocks(data);
+
+	return ret;
+}
+
+static int exynos3_busfreq_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct busfreq_data *data = platform_get_drvdata(pdev);
+
+	/*
+	 * devfreq_dev_profile.exit() will disable regulator, unprepare
+	 * clocks and unmap memory.
+	 */
+
+	/* Unregister all of notifier chain */
+	unregister_pm_notifier(&data->pm_notifier);
+	devfreq_unregister_opp_notifier(dev, data->devfreq);
+
+	exynos3_bus_edev_disable(data);
+	devfreq_remove_device(data->devfreq);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int exynos3_busfreq_resume(struct device *dev)
+{
+	struct busfreq_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	/* Reset PPMU to check utilization again */
+	ret = exynos3_bus_edev_set_event(data);
+	if (ret < 0) {
+		dev_err(dev, "Failed to set devfreq events: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int exynos3_busfreq_suspend(struct device *dev)
+{
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops exynos3_busfreq_pm = {
+	SET_SYSTEM_SLEEP_PM_OPS(exynos3_busfreq_suspend, exynos3_busfreq_resume)
+};
+
+static const struct platform_device_id exynos3_busfreq_id[] = {
+	{ "exynos3250-busf-mif", TYPE_BUSFREQ_EXYNOS3250_MIF },
+	{ "exynos3250-busf-int", TYPE_BUSFREQ_EXYNOS3250_INT },
+	{},
+};
+
+static struct platform_driver exynos3_busfreq_driver = {
+	.probe		= exynos3_busfreq_probe,
+	.remove		= exynos3_busfreq_remove,
+	.id_table	= exynos3_busfreq_id,
+	.driver		= {
+		.name		= "exynos3250-busfreq",
+		.owner		= THIS_MODULE,
+		.pm		= &exynos3_busfreq_pm,
+		.of_match_table	= exynos3_busfreq_id_match,
+	},
+};
+
+static int __init exynos3_busfreq_init(void)
+{
+	BUILD_BUG_ON(ARRAY_SIZE(exynos3_bus_mif_clk_name) !=
+					EXYNOS3_BUS_MIF_CLK_END);
+	BUILD_BUG_ON(ARRAY_SIZE(exynos3_bus_int_clk_name) !=
+					EXYNOS3_BUS_INT_CLK_END);
+
+	return platform_driver_register(&exynos3_busfreq_driver);
+}
+late_initcall(exynos3_busfreq_init);
+
+static void __exit exynos3_busfreq_exit(void)
+{
+	platform_driver_unregister(&exynos3_busfreq_driver);
+}
+module_exit(exynos3_busfreq_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("EXYNOS3250 INT/MIF busfreq driver with devfreq framework");
+MODULE_AUTHOR("Chanwoo Choi <cw00.choi@samsung.com>");
+MODULE_AUTHOR("Krzysztof Kozlowski <k.kozlowski@samsung.com>");
-- 
1.9.1

