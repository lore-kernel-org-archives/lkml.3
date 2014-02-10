Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaBJNT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:19:26 -0500
Received: from 213083164162.static.sonofon.dk ([213.83.164.162]:57972 "EHLO
	HORWDSPRD01.spectralink.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752195AbaBJNTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:19:23 -0500
X-Greylist: delayed 1111 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2014 08:19:22 EST
From: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
To: richardcochran@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH] dp83640: Get gpio and master/slave configuration from DT
Date: Mon, 10 Feb 2014 14:00:40 +0100
Message-Id: <1392037240-30913-1-git-send-email-stefan.sorensen@spectralink.com>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Feb 2014 13:00:49.0003 (UTC) FILETIME=[1EA74BB0:01CF2660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the module parameters gpio_tab and chosen_phy in favour of
retrieving the configuration from DT through the properties
	dp83640,slave
	dp83640,calibrate-gpio
	dp83640,perout-gpios
	dp83640,extts-gpios
The configuration is now stored for each master clock device, allowing different 
gpio setups for each master.

Furthermore the code is enhanced to handle more than one periodic output.

Signed-off-by: Stefan Sørensen <stefan.sorensen@spectralink.com>
---

The slave configuration code is totally untested as I only have access to 
boards with a single DP3640. 

 drivers/net/phy/dp83640.c | 195 ++++++++++++++++++++++++++++++----------------
 1 file changed, 128 insertions(+), 67 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 547725f..118403d 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -30,6 +30,7 @@
 #include <linux/phy.h>
 #include <linux/ptp_classify.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/of_device.h>
 
 #include "dp83640_reg.h"
 
@@ -38,15 +39,11 @@
 #define LAYER4		0x02
 #define LAYER2		0x01
 #define MAX_RXTS	64
-#define N_EXT_TS	6
+#define N_EXT		8
 #define PSF_PTPVER	2
 #define PSF_EVNT	0x4000
 #define PSF_RX		0x2000
 #define PSF_TX		0x1000
-#define EXT_EVENT	1
-#define CAL_EVENT	7
-#define CAL_TRIGGER	7
-#define PER_TRIGGER	6
 
 #define MII_DP83640_MICR 0x11
 #define MII_DP83640_MISR 0x12
@@ -123,6 +120,8 @@ struct dp83640_private {
 	/* queues of incoming and outgoing packets */
 	struct sk_buff_head rx_queue;
 	struct sk_buff_head tx_queue;
+	/* is this phyter a slave */
+	bool slave;
 };
 
 struct dp83640_clock {
@@ -144,35 +143,9 @@ struct dp83640_clock {
 	struct list_head phylist;
 	/* reference to our PTP hardware clock */
 	struct ptp_clock *ptp_clock;
+	u32 perout_gpios[N_EXT], extts_gpios[N_EXT], calibrate_gpio;
 };
 
-/* globals */
-
-enum {
-	CALIBRATE_GPIO,
-	PEROUT_GPIO,
-	EXTTS0_GPIO,
-	EXTTS1_GPIO,
-	EXTTS2_GPIO,
-	EXTTS3_GPIO,
-	EXTTS4_GPIO,
-	EXTTS5_GPIO,
-	GPIO_TABLE_SIZE
-};
-
-static int chosen_phy = -1;
-static ushort gpio_tab[GPIO_TABLE_SIZE] = {
-	1, 2, 3, 4, 8, 9, 10, 11
-};
-
-module_param(chosen_phy, int, 0444);
-module_param_array(gpio_tab, ushort, NULL, 0444);
-
-MODULE_PARM_DESC(chosen_phy, \
-	"The address of the PHY to use for the ancillary clock features");
-MODULE_PARM_DESC(gpio_tab, \
-	"Which GPIO line to use for which purpose: cal,perout,extts1,...,extts6");
-
 /* a list of clocks and a mutex to protect it */
 static LIST_HEAD(phyter_clocks);
 static DEFINE_MUTEX(phyter_clocks_lock);
@@ -267,15 +240,16 @@ static u64 phy2txts(struct phy_txts *p)
 }
 
 static void periodic_output(struct dp83640_clock *clock,
-			    struct ptp_clock_request *clkreq, bool on)
+			    struct ptp_clock_request *clkreq, int index,
+			    bool on)
 {
 	struct dp83640_private *dp83640 = clock->chosen;
 	struct phy_device *phydev = dp83640->phydev;
 	u32 sec, nsec, period;
 	u16 gpio, ptp_trig, trigger, val;
 
-	gpio = on ? gpio_tab[PEROUT_GPIO] : 0;
-	trigger = PER_TRIGGER;
+	gpio = on ? clock->perout_gpios[index] : 0;
+	trigger = clock->caps.n_ext_ts + index;
 
 	ptp_trig = TRIG_WR |
 		(trigger & TRIG_CSEL_MASK) << TRIG_CSEL_SHIFT |
@@ -430,12 +404,12 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
 		index = rq->extts.index;
-		if (index < 0 || index >= N_EXT_TS)
+		if (index < 0 || index >= clock->caps.n_ext_ts)
 			return -EINVAL;
-		event_num = EXT_EVENT + index;
+		event_num = index;
 		evnt = EVNT_WR | (event_num & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
 		if (on) {
-			gpio_num = gpio_tab[EXTTS0_GPIO + index];
+			gpio_num = clock->extts_gpios[index];
 			evnt |= (gpio_num & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
 			evnt |= EVNT_RISE;
 		}
@@ -443,9 +417,10 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 		return 0;
 
 	case PTP_CLK_REQ_PEROUT:
-		if (rq->perout.index != 0)
+		index = rq->perout.index;
+		if (index < 0 || index >= clock->caps.n_per_out)
 			return -EINVAL;
-		periodic_output(clock, rq, on);
+		periodic_output(clock, rq, index, on);
 		return 0;
 
 	default:
@@ -538,10 +513,9 @@ static void recalibrate(struct dp83640_clock *clock)
 	struct list_head *this;
 	struct dp83640_private *tmp;
 	struct phy_device *master = clock->chosen->phydev;
-	u16 cal_gpio, cfg0, evnt, ptp_trig, trigger, val;
+	u16 cfg0, evnt, ptp_trig, trigger, val;
 
-	trigger = CAL_TRIGGER;
-	cal_gpio = gpio_tab[CALIBRATE_GPIO];
+	trigger = clock->caps.n_ext_ts + clock->caps.n_per_out;
 
 	mutex_lock(&clock->extreg_lock);
 
@@ -564,8 +538,8 @@ static void recalibrate(struct dp83640_clock *clock)
 	 * enable an event timestamp
 	 */
 	evnt = EVNT_WR | EVNT_RISE | EVNT_SINGLE;
-	evnt |= (CAL_EVENT & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
-	evnt |= (cal_gpio & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
+	evnt |= (trigger & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
+	evnt |= (clock->calibrate_gpio & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
 
 	list_for_each(this, &clock->phylist) {
 		tmp = list_entry(this, struct dp83640_private, list);
@@ -578,7 +552,7 @@ static void recalibrate(struct dp83640_clock *clock)
 	 */
 	ptp_trig = TRIG_WR | TRIG_IF_LATE | TRIG_PULSE;
 	ptp_trig |= (trigger  & TRIG_CSEL_MASK) << TRIG_CSEL_SHIFT;
-	ptp_trig |= (cal_gpio & TRIG_GPIO_MASK) << TRIG_GPIO_SHIFT;
+	ptp_trig |= (clock->calibrate_gpio & TRIG_GPIO_MASK) << TRIG_GPIO_SHIFT;
 	ext_write(0, master, PAGE5, PTP_TRIG, ptp_trig);
 
 	/* load trigger */
@@ -642,7 +616,7 @@ static void recalibrate(struct dp83640_clock *clock)
 
 static inline u16 exts_chan_to_edata(int ch)
 {
-	return 1 << ((ch + EXT_EVENT) * 2);
+	return 1 << ((ch) * 2);
 }
 
 static int decode_evnt(struct dp83640_private *dp83640,
@@ -676,14 +650,14 @@ static int decode_evnt(struct dp83640_private *dp83640,
 		parsed = words + 2;
 	} else {
 		parsed = words + 1;
-		i = ((ests >> EVNT_NUM_SHIFT) & EVNT_NUM_MASK) - EXT_EVENT;
+		i = ((ests >> EVNT_NUM_SHIFT) & EVNT_NUM_MASK);
 		ext_status = exts_chan_to_edata(i);
 	}
 
 	event.type = PTP_CLOCK_EXTTS;
 	event.timestamp = phy2txts(&dp83640->edata);
 
-	for (i = 0; i < N_EXT_TS; i++) {
+	for (i = 0; i < dp83640->clock->caps.n_ext_ts; i++) {
 		if (ext_status & exts_chan_to_edata(i)) {
 			event.index = i;
 			ptp_clock_event(dp83640->clock->ptp_clock, &event);
@@ -889,8 +863,6 @@ static void dp83640_clock_init(struct dp83640_clock *clock, struct mii_bus *bus)
 	sprintf(clock->caps.name, "dp83640 timer");
 	clock->caps.max_adj	= 1953124;
 	clock->caps.n_alarm	= 0;
-	clock->caps.n_ext_ts	= N_EXT_TS;
-	clock->caps.n_per_out	= 1;
 	clock->caps.pps		= 0;
 	clock->caps.adjfreq	= ptp_dp83640_adjfreq;
 	clock->caps.adjtime	= ptp_dp83640_adjtime;
@@ -903,18 +875,6 @@ static void dp83640_clock_init(struct dp83640_clock *clock, struct mii_bus *bus)
 	get_device(&bus->dev);
 }
 
-static int choose_this_phy(struct dp83640_clock *clock,
-			   struct phy_device *phydev)
-{
-	if (chosen_phy == -1 && !clock->chosen)
-		return 1;
-
-	if (chosen_phy == phydev->addr)
-		return 1;
-
-	return 0;
-}
-
 static struct dp83640_clock *dp83640_clock_get(struct dp83640_clock *clock)
 {
 	if (clock)
@@ -960,6 +920,100 @@ static void dp83640_clock_put(struct dp83640_clock *clock)
 	mutex_unlock(&clock->clock_lock);
 }
 
+#ifdef CONFIG_OF
+static int dp83640_probe_dt(struct device_node *node,
+			    struct dp83640_private *dp83640)
+{
+	struct dp83640_clock *clock = dp83640->clock;
+	struct property *prop;
+	int err, proplen;
+
+	if (!node)
+		return 0;
+
+	if (of_find_property(node, "dp83640,slave", NULL))
+		dp83640->slave = true;
+	if (!dp83640->slave && clock->chosen) {
+		pr_err("dp83640,slave must be set if more than one device on the same bus");
+		return -EINVAL;
+	}
+
+	prop = of_find_property(node, "dp83640,perout-gpios", &proplen);
+	if (prop) {
+		if (dp83640->slave) {
+			pr_err("dp83640,perout-gpios property can not be set together with dp83640,slave");
+			return -EINVAL;
+		}
+
+		clock->caps.n_per_out = proplen / sizeof(u32);
+		if (clock->caps.n_per_out > N_EXT) {
+			pr_err("dp83640,perout-gpios may not have more than %d entries",
+			       N_EXT);
+			return -EINVAL;
+		}
+		err = of_property_read_u32_array(node, "dp83640,perout-gpios",
+						 clock->perout_gpios,
+						 clock->caps.n_per_out);
+		if (err < 0)
+			return err;
+	}
+
+	prop = of_find_property(node, "dp83640,extts-gpios", &proplen);
+	if (prop) {
+		if (dp83640->slave) {
+			pr_err("dp83640,extts-gpios property can not be set together with dp83640,slave");
+			return -EINVAL;
+		}
+
+		clock->caps.n_ext_ts = proplen / sizeof(u32);
+		if (clock->caps.n_ext_ts > N_EXT) {
+			pr_err("dp83640,extts-gpios may not have more than %d entries",
+			       N_EXT);
+			return -EINVAL;
+		}
+		err = of_property_read_u32_array(node, "dp83640,extts-gpios",
+						 clock->extts_gpios,
+						 clock->caps.n_ext_ts);
+		if (err < 0)
+			return err;
+	}
+
+	prop = of_find_property(node, "dp83640,calibrate-gpio", &proplen);
+	if (prop) {
+		if (dp83640->slave) {
+			pr_err("dp83640,calibrate-gpio property can not be set together with dp83640,slave");
+			return -EINVAL;
+		}
+		clock->calibrate_gpio = -1;
+		of_property_read_u32(node, "dp83640,calibrate-gpio",
+				     &clock->calibrate_gpio);
+	}
+
+	if (!dp83640->slave) {
+		if (clock->caps.n_per_out + clock->caps.n_ext_ts +
+		    (clock->calibrate_gpio != -1 ? 1 : 0) > N_EXT) {
+			pr_err("Too many gpios configured");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static const struct of_device_id dp83640_of_match_table[] = {
+	{ .compatible = "national,dp83640", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, dp83640_of_match_table);
+#else
+
+static inline int dp83640_probe_dt(struct device_node *node,
+				   struct dp83640_private *dp83640)
+{
+	return 0;
+}
+#endif
+
 static int dp83640_probe(struct phy_device *phydev)
 {
 	struct dp83640_clock *clock;
@@ -977,7 +1031,13 @@ static int dp83640_probe(struct phy_device *phydev)
 	if (!dp83640)
 		goto no_memory;
 
+	dp83640->clock = clock;
 	dp83640->phydev = phydev;
+
+	err = dp83640_probe_dt(phydev->dev.of_node, dp83640);
+	if (err)
+		return err;
+
 	INIT_WORK(&dp83640->ts_work, rx_timestamp_work);
 
 	INIT_LIST_HEAD(&dp83640->rxts);
@@ -991,9 +1051,7 @@ static int dp83640_probe(struct phy_device *phydev)
 	skb_queue_head_init(&dp83640->rx_queue);
 	skb_queue_head_init(&dp83640->tx_queue);
 
-	dp83640->clock = clock;
-
-	if (choose_this_phy(clock, phydev)) {
+	if (!clock->chosen && !dp83640->slave) {
 		clock->chosen = dp83640;
 		clock->ptp_clock = ptp_clock_register(&clock->caps, &phydev->dev);
 		if (IS_ERR(clock->ptp_clock)) {
@@ -1338,7 +1396,10 @@ static struct phy_driver dp83640_driver = {
 	.hwtstamp	= dp83640_hwtstamp,
 	.rxtstamp	= dp83640_rxtstamp,
 	.txtstamp	= dp83640_txtstamp,
-	.driver		= {.owner = THIS_MODULE,}
+	.driver		= {
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(dp83640_of_match_table),
+	}
 };
 
 static int __init dp83640_init(void)
-- 
1.8.5.3

