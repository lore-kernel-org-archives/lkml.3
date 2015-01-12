Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbbALJXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:23:31 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28036 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbbALJXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:23:24 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-e7-54b3928b5b6e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Jaehoon Chung <jh80.chung@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kukjin Kim <kgene@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 1/3] mmc: Add dynamic frequency scaling
Date: Mon, 12 Jan 2015 10:23:03 +0100
Message-id: <1421054585-9032-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
References: <1421054585-9032-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xy7rdkzaHGOxeb2axccZ6VosJl7cz
	Wsw/co7V4savNlaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hszjyv5/RYsb5fUwWa4/cZbc4
	vjbcgddj06pONo871/aweWxeUu9x49VCJo++LasYPT5vkgtgi+KySUnNySxLLdK3S+DKOHdk
	PntBb3HFvNb0BsYJsV2MnBwSAiYS7859YoSwxSQu3FvPBmILCSxllDj+3bWLkQvI7mOSOPl9
	FhNIgk3AWGLz8iVsIAkRgS1MEqvWrGUFcZgFjjJK3Jh1F6xKWMBUYtfvw2A2i4CqxJ/5z8Bs
	XgE3ieMbP7JCrJOTOHlsMpjNKeAucXDiD1aI1W4SV3d1Mk1g5F3AyLCKUTS1NLmgOCk910iv
	ODG3uDQvXS85P3cTIyQsv+5gXHrM6hCjAAejEg+vpdTmECHWxLLiytxDjBIczEoivK5lQCHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2MUuvXbfz0Mvr3cpXX03/ZtTMfD2OKfu1Yx7DyhNYb7dDI
	mSsenny5ue7+Vq2Wb27pKyc1cYUfO8bScirbKvaHbym/zcYZIffbPqo6mp786r0i/UN6BDPn
	rsnuT7Lfyxa5Xay1M9zC3PziZcHft/varfUdGKvnubv73zWXCrw05/dtl7suls+8lViKMxIN
	tZiLihMB+o6WMSkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register mmc driver as devfreq device and allow dynamic frequency
scaling.

This helps in reducing of energy consumption while limiting impact on
MMC performance (in comparison to setting maximum frequency).

The feature is enabled with CONFIG_MMC_DEVFREQ (CONFIG_PM_DEVFREQ is
required). The business of device (for devfreq simple ondemand governor)
us calculated as ratio of current throughput to maximum throughput
(reached in device life-cycle) for given frequency level:
 - total_time = polling time,
 - busy_time  = (bytes / max_throughput) * (max_freq / cur_freq),

where 'bytes' is number of bytes transferred in requests since last
poll.

Measurements on:
1. Trats2 board (Exynos4412, dw_mmc)
2. Rinato board (Exynos3250, dw_mmc)

                     | dd mmc->/dev/null | dd mmc->mmc | energy (idle)
======================================================================
Trats: fixed 100 MHz |        62.15 MB/s |  17.44 MB/s |     119.50 mA
Trats: mmc devfreq   |        58.45 MB/s |  17.47 MB/s |     116.40 mA
======================================================================
Rinat: fixed 100 MHz |        78.70 MB/s  |   6.2 MB/s |      27.16 mA
Rinat: mmc devfreq   |        62.60 MB/s  |   6.0 MB/s |      26.89 mA

1. 'fixed' means fixed slot clock 100 MHz (bus clock 200 MHz)
2. 'mmc devfreq' means scaled slot clock from 25 to 100 MHz (bus clock
    50 MHz and 100 MHz)

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mmc/mmc.txt |   2 +
 drivers/mmc/card/block.c                      | 247 ++++++++++++++++++++++++++
 drivers/mmc/core/Kconfig                      |  16 ++
 drivers/mmc/core/core.h                       |   1 -
 drivers/mmc/core/host.c                       |   2 +
 include/linux/mmc/card.h                      |   8 +
 include/linux/mmc/host.h                      |   3 +
 7 files changed, 278 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc.txt b/Documentation/devicetree/bindings/mmc/mmc.txt
index bac131169c07..940c2e96d27f 100644
--- a/Documentation/devicetree/bindings/mmc/mmc.txt
+++ b/Documentation/devicetree/bindings/mmc/mmc.txt
@@ -42,6 +42,8 @@ Optional properties:
 - mmc-hs400-1_2v: eMMC HS400 mode(1.2V I/O) is supported
 - dsr: Value the card's (optional) Driver Stage Register (DSR) should be
   programmed with. Valid range: [0 .. 0xffff].
+- frequency-scaling: when present, dynamic frequency scaling for this
+  host is supported and will be enabled (if kernel supports it)
 
 *NOTE* on CD and WP polarity. To use common for all SD/MMC host controllers line
 polarity properties, we have to fix the meaning of the "normal" and "inverted"
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 4409d79ed650..c0d977f06ce2 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -35,6 +35,7 @@
 #include <linux/capability.h>
 #include <linux/compat.h>
 #include <linux/pm_runtime.h>
+#include <linux/devfreq.h>
 
 #include <linux/mmc/ioctl.h>
 #include <linux/mmc/card.h>
@@ -319,6 +320,243 @@ static void mmc_blk_release(struct gendisk *disk, fmode_t mode)
 	mutex_unlock(&block_mutex);
 }
 
+#ifdef CONFIG_MMC_DEVFREQ
+
+/*
+ * TODO:
+ * - work with clkgate
+ * - sometimes devfreq_work is not executed on intensive IO...
+ *   [   33.883417] mmcblk mmc1:0001: clk 100000000, busy 4840 ms, time 4840 ms, ceil 17997 kB/s
+ *   [   41.513621] mmcblk mmc1:0001: clk 100000000, busy 7630 ms, time 7630 ms, ceil 18226 kB/s
+ *   [   43.363617] mmcblk mmc1:0001: clk 100000000, busy 1806 ms, time 1849 ms, ceil 18226 kB/s
+ *   looks issue of defferable work. The polling times here are way too long.
+ *
+ * - devm_devfreq_register_opp_notifier
+ *
+ * - Setting MMC frequency when card is very busy may take very long time
+ *   because mmc_claim_host() must find idle gap of MMC.
+ *   Probably this should be done in workqueue.
+ */
+
+#ifdef CONFIG_MMC_CLKGATE
+#error "Currently MMC devfreq conflicts with clkgate. Choose one."
+#endif
+
+#define MMC_DEVFREQ_GOVERNOR		"simple_ondemand"
+/*
+ * Device utilization level is measured as ratio of current throughput
+ * to maximum throughput (reached in device lifecycle) for given frequency
+ * level:
+ * total_time	= polling time,
+ * busy_time	= (bytes / max_throughput) * (max_freq / cur_freq)
+ *
+ * This is still inaccurate. Especially that some of loads may achieve
+ * bigger throughput than others for the same expected business of device.
+ * For example reading from MMC to memory has higher throughput than
+ * copying data on the same MMC.
+ *
+ * To boost frequency early and reduce this inaccurate utilization metrics
+ * assume 30% of throughput as saturated.
+ */
+#define MMC_DEVFREQ_SATURATION		30
+
+/*
+ * TODO: take these from DT as OPP
+ */
+static const unsigned int mmc_devfreq_frequencies[] = {
+	 25000000,
+	 50000000,
+	100000000,
+	200000000,
+	400000000,
+};
+
+static unsigned int get_clk_ratio_throughput(struct mmc_card *card,
+					     unsigned int freq)
+{
+	unsigned int max_opp = card->df_num_freq - 1;
+
+	if (!card->df_num_freq)
+		return 0;
+
+	return (mmc_devfreq_frequencies[max_opp] / freq);
+}
+
+static int mmc_devfreq_target(struct device *dev, unsigned long *freq, u32 flags)
+{
+	struct dev_pm_opp *opp;
+	unsigned long new_freq;
+	struct mmc_card *card = mmc_dev_to_card(dev);
+	unsigned int cur_freq = mmc_host_clk_rate(card->host);
+
+	if (!cur_freq)
+		return 0;
+
+	rcu_read_lock();
+	opp = devfreq_recommended_opp(dev, freq, flags);
+	if (IS_ERR(opp)) {
+		rcu_read_unlock();
+		return PTR_ERR(opp);
+	}
+	new_freq = dev_pm_opp_get_freq(opp);
+	rcu_read_unlock();
+
+	if (cur_freq == new_freq)
+		return 0;
+
+	dev_dbg(dev, "%u Hz -> %lu Hz\n", cur_freq, new_freq);
+
+	mmc_claim_host(card->host);
+	mmc_set_clock(card->host, new_freq);
+	mmc_release_host(card->host);
+
+	return 0;
+}
+
+static int mmc_devfreq_get_dev_status(struct device *dev,
+		struct devfreq_dev_status *stat)
+{
+	struct mmc_card *card = mmc_dev_to_card(dev);
+	ktime_t old_time, cur_time;
+	/*
+	 * TODO: All calculations done on 64-bit numbers but is it really
+	 * necessary? The "bytes" are "int" and they won't overflow
+	 * (2 GB between polling time). Polling time (in ms) also shouldn't
+	 * overflow.
+	 */
+	s64 diff_time;
+	u64 bps, bytes;
+	unsigned int cur_freq = mmc_host_clk_rate(card->host);
+
+	if (!cur_freq)
+		return -ENODEV;
+
+	/*
+	 * After getting current measurements, reset byte counter and time
+	 * of polling early to reduce possible misses of processed requests.
+	 */
+	bytes = (u64)atomic_xchg(&card->df_bytes, 0);
+
+	old_time = card->df_poll_time;
+	cur_time = card->df_poll_time = ktime_get();
+	diff_time = ktime_to_ms(ktime_sub(cur_time, old_time));
+	if (diff_time < 0 || diff_time > UINT_MAX)
+		/* Can't happen, but for safe promotion to unsigned in do_div */
+		return -EINVAL;
+
+	/*
+	 * Calculate bytes per second and update card throughput. Diff time
+	 * is in ms so multiply by 1000.
+	 */
+	bytes *= 1000;
+	bps = bytes;
+	do_div(bps, diff_time);
+	card->df_ceil_bps = max(card->df_ceil_bps, bps);
+
+	/* Calculate busy time: bytes/max_throughput */
+	do_div(bytes, card->df_ceil_bps);
+
+	/*
+	 * Boost by current frequency level. This boost may result in
+	 * exceeding total_time.
+	 */
+	bytes *= get_clk_ratio_throughput(card, cur_freq);
+
+	stat->busy_time = bytes;
+	stat->total_time = diff_time;
+	stat->current_frequency = cur_freq;
+
+	/* Only debug */
+	{
+		u64 ceil = card->df_ceil_bps;
+		do_div(ceil, 1024);
+		dev_dbg(&card->dev, "clk: %u, busy: %llu ms, time: %llu ms, ceil: %llu kB/s\n",
+			cur_freq, bytes, diff_time, ceil);
+	}
+	return 0;
+}
+
+static struct devfreq_dev_profile mmc_devfreq_profile = {
+	.initial_freq	= 50000000, /* overwritten with current freq in init */
+	.polling_ms	= 100,
+	.target		= mmc_devfreq_target,
+	.get_dev_status	= mmc_devfreq_get_dev_status,
+};
+
+static struct devfreq_simple_ondemand_data mmc_governor_data = {
+	.upthreshold		= MMC_DEVFREQ_SATURATION,
+	.downdifferential	= 5,
+};
+
+static void mmc_devfreq_init(struct mmc_card *card)
+{
+	int ret;
+	unsigned int i;
+	unsigned int max_freq = card->host->f_max;
+
+	WARN_ON(!max_freq);
+	for (i = 0; i < ARRAY_SIZE(mmc_devfreq_frequencies); i++) {
+		if (mmc_devfreq_frequencies[i] > max_freq)
+			break;
+
+		ret = dev_pm_opp_add(&card->dev, mmc_devfreq_frequencies[i], 0);
+		if (ret) {
+			dev_err(&card->dev,
+				"Cannot add opp entries: %d\n", ret);
+			return;
+		}
+	}
+	card->df_num_freq = i;
+
+	if (card->df_num_freq < 2) {
+		dev_info(&card->dev,
+			 "Not enough frequencies for devfreq (device supports %u frequencies)\n",
+			 card->df_num_freq);
+		return;
+	}
+
+	mmc_devfreq_profile.initial_freq = mmc_host_clk_rate(card->host);
+
+	card->devfreq = devm_devfreq_add_device(&card->dev,
+				&mmc_devfreq_profile, MMC_DEVFREQ_GOVERNOR,
+				&mmc_governor_data);
+	if (IS_ERR(card->devfreq)) {
+		card->devfreq = NULL;
+	} else {
+		dev_info(&card->dev,
+			 "Starting frequency scaling with %u frequencies\n",
+			 card->df_num_freq);
+		card->df_poll_time = ktime_get();
+		card->df_ceil_bps = 1; /* Non-zero to avoid first do_div by 0 */
+	}
+	/* TODO: devm_devfreq_register_opp_notifier */
+}
+
+static void mmc_devfreq_exit(struct mmc_card *card)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mmc_devfreq_frequencies); i++)
+		dev_pm_opp_remove(&card->dev, mmc_devfreq_frequencies[i]);
+}
+
+static void mmc_devfreq_account_req(struct mmc_card *card, struct request *req)
+{
+	if (!card->devfreq)
+		return;
+
+	atomic_add(blk_rq_bytes(req), &card->df_bytes);
+}
+
+#else /* !CONFIG_MMC_DEVFREQ */
+
+static inline void mmc_devfreq_init(struct mmc_card *card) { }
+static inline void mmc_devfreq_exit(struct mmc_card *card) { }
+static inline void mmc_devfreq_account_req(struct mmc_card *card,
+		struct request *req) { }
+
+#endif /* CONFIG_MMC_DEVFREQ */
+
 static int
 mmc_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
@@ -2038,6 +2276,10 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 			mmc_blk_issue_rw_rq(mq, NULL);
 		ret = mmc_blk_issue_flush(mq, req);
 	} else {
+		if (req) {
+			mmc_devfreq_account_req(mq->card, req);
+			// TODO: do not ignore special requests?
+		}
 		if (!req && host->areq) {
 			spin_lock_irqsave(&host->context_info.lock, flags);
 			host->context_info.is_waiting_last_req = true;
@@ -2469,6 +2711,9 @@ static int mmc_blk_probe(struct device *dev)
 		pm_runtime_enable(&card->dev);
 	}
 
+	if (card->host->caps2 & MMC_CAP2_FREQ_SCALING)
+		mmc_devfreq_init(card);
+
 	return 0;
 
  out:
@@ -2482,6 +2727,8 @@ static int mmc_blk_remove(struct device *dev)
 	struct mmc_card *card = mmc_dev_to_card(dev);
 	struct mmc_blk_data *md = dev_get_drvdata(dev);
 
+	/* FIXME: exit devfreq in mmc_detect_card_removed? */
+	mmc_devfreq_exit(card);
 	mmc_blk_remove_parts(card, md);
 	pm_runtime_get_sync(&card->dev);
 	mmc_claim_host(card->host);
diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index 9ebee72d9c3f..93e6893126f7 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -11,3 +11,19 @@ config MMC_CLKGATE
 	  support handling this in order for it to be of any use.
 
 	  If unsure, say N.
+
+config MMC_DEVFREQ
+	bool "MMC host clock frequency scaling for block devices"
+	depends on !MMC_CLKGATE
+	depends on PM_DEVFREQ
+	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	select PM_OPP
+	help
+	  This will add dynamic frequency scaling of MMC host clock
+	  depending on current utilization of MMC. The utilization is
+	  calculated as number of bytes queued for transfer (both from
+	  and to MMC card). This should reduce energy consumption when
+	  MMC is not heavily used. On high loads this shouldn't decrease
+	  performance. Only block devices are supported.
+
+	  If unsure, say N.
diff --git a/drivers/mmc/core/core.h b/drivers/mmc/core/core.h
index b528c0e5b264..8e45f541bad9 100644
--- a/drivers/mmc/core/core.h
+++ b/drivers/mmc/core/core.h
@@ -38,7 +38,6 @@ struct device_node *mmc_of_find_child_device(struct mmc_host *host,
 void mmc_init_erase(struct mmc_card *card);
 
 void mmc_set_chip_select(struct mmc_host *host, int mode);
-void mmc_set_clock(struct mmc_host *host, unsigned int hz);
 void mmc_gate_clock(struct mmc_host *host);
 void mmc_ungate_clock(struct mmc_host *host);
 void mmc_set_ungated(struct mmc_host *host);
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 07636449b4de..70b2c8055882 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -439,6 +439,8 @@ int mmc_of_parse(struct mmc_host *host)
 		host->caps2 |= MMC_CAP2_HS400_1_8V | MMC_CAP2_HS200_1_8V_SDR;
 	if (of_find_property(np, "mmc-hs400-1_2v", &len))
 		host->caps2 |= MMC_CAP2_HS400_1_2V | MMC_CAP2_HS200_1_2V_SDR;
+	if (of_find_property(np, "frequency-scaling", &len))
+		host->caps2 |= MMC_CAP2_FREQ_SCALING;
 
 	host->dsr_req = !of_property_read_u32(np, "dsr", &host->dsr);
 	if (host->dsr_req && (host->dsr & ~0xffff)) {
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 4d69c00497bd..412836d343dd 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -309,6 +309,14 @@ struct mmc_card {
 	struct dentry		*debugfs_root;
 	struct mmc_part	part[MMC_NUM_PHY_PARTITION]; /* physical partitions */
 	unsigned int    nr_parts;
+
+#ifdef CONFIG_MMC_DEVFREQ
+	struct devfreq		*devfreq;
+	atomic_t		df_bytes;
+	ktime_t			df_poll_time;
+	u64			df_ceil_bps;
+	unsigned int		df_num_freq;
+#endif
 };
 
 /*
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index b6bf718c3498..322e5bc11043 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -289,6 +289,7 @@ struct mmc_host {
 				 MMC_CAP2_HS400_1_2V)
 #define MMC_CAP2_HSX00_1_2V	(MMC_CAP2_HS200_1_2V_SDR | MMC_CAP2_HS400_1_2V)
 #define MMC_CAP2_SDIO_IRQ_NOTHREAD (1 << 17)
+#define MMC_CAP2_FREQ_SCALING	(1 << 18)	/* Supports MMC_DEVFREQ */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
@@ -489,6 +490,8 @@ static inline unsigned int mmc_host_clk_rate(struct mmc_host *host)
 	return host->ios.clock;
 }
 #endif
+/* FIXME: should it be exported? */
+void mmc_set_clock(struct mmc_host *host, unsigned int hz);
 
 static inline int mmc_card_hs(struct mmc_card *card)
 {
-- 
1.9.1

