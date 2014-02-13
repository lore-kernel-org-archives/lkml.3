Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaBMOhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:37:10 -0500
Received: from 213083164162.static.sonofon.dk ([213.83.164.162]:49824 "EHLO
	HORWDSPRD01.spectralink.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861AbaBMOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:37:06 -0500
From: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
To: richardcochran@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH v3 3/3] net:phy:dp83640: Get pin and master/slave configuration from DT
Date: Thu, 13 Feb 2014 15:35:29 +0100
Message-Id: <1392302129-24947-8-git-send-email-stefan.sorensen@spectralink.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
References: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Feb 2014 14:37:04.0296 (UTC) FILETIME=[103C5280:01CF28C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds configuration of the periodic output and external timestamp
pins available on the dp83640 family of PHYs. It also configures the
master/slave relationship in a group of PHYs on the same MDIO bus and the pins
used for clock calibration in the group.

The configuration is retrieved from DT through the properties
    dp83640,slave
    dp83640,calibrate-pin
    dp83640,perout-pins
    dp83640,extts-pins
The configuration module parameters are retained as fallback for the non-DT
case.

Since the pin configuration is now stored for each clock device, groups of
devices on different mdio busses can now have different pin configurations.

Signed-off-by: Stefan Sørensen <stefan.sorensen@spectralink.com>
---
 Documentation/devicetree/bindings/net/dp83640.txt |  29 +++++
 drivers/net/phy/dp83640.c                         | 139 ++++++++++++++++++----
 2 files changed, 143 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dp83640.txt

diff --git a/Documentation/devicetree/bindings/net/dp83640.txt b/Documentation/devicetree/bindings/net/dp83640.txt
new file mode 100644
index 0000000..b9a57c0
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dp83640.txt
@@ -0,0 +1,29 @@
+Required properties for the National DP83640 ethernet phy:
+
+- compatible : Must contain "national,dp83640"
+
+Optional properties:
+
+- dp83640,slave: If present, this phy will be slave to another dp83640
+  on the same mdio bus.
+- dp83640,perout-pins : List of the pin pins used for periodic output
+  triggers.
+- dp83640,extts-pins : List of the pin pins used for external event
+  timestamping.
+- dp83640,calibrate-pin : The pin used for master/slave calibration.
+
+Example:
+
+	ethernet-phy@1 {
+		compatible = "national,dp83640", "ethernet-phy-ieee802.3-c22";
+		reg = <1>;
+		dp83640,perout-pins = <2>;
+		dp83640,extts-pins = <3 4 8 9 10 11>;
+		dp83640,calibrate-pin = <1>;
+	};
+
+	ethernet-phy@2 {
+		compatible = "national,dp83640", "ethernet-phy-ieee802.3-c22";
+		reg = <2>;
+		dp83640,slave;
+	};
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 28a6e1d..077bdc2 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -30,6 +30,7 @@
 #include <linux/phy.h>
 #include <linux/ptp_classify.h>
 #include <linux/ptp_clock_kernel.h>
+#include <linux/of_device.h>
 
 #include "dp83640_reg.h"
 
@@ -120,6 +121,8 @@ struct dp83640_private {
 	/* queues of incoming and outgoing packets */
 	struct sk_buff_head rx_queue;
 	struct sk_buff_head tx_queue;
+	/* is this phyter a slave */
+	bool slave;
 };
 
 struct dp83640_clock {
@@ -141,6 +144,7 @@ struct dp83640_clock {
 	struct list_head phylist;
 	/* reference to our PTP hardware clock */
 	struct ptp_clock *ptp_clock;
+	u32 perout_pins[N_EXT], extts_pins[N_EXT], calibrate_pin;
 };
 
 
@@ -264,7 +268,7 @@ static void periodic_output(struct dp83640_clock *clock,
 	u32 sec, nsec, period;
 	u16 gpio, ptp_trig, val;
 
-	gpio = on ? perout_pins[trigger] : 0;
+	gpio = on ? clock->perout_pins[trigger] : 0;
 
 	ptp_trig = TRIG_WR |
 		(trigger & TRIG_CSEL_MASK) << TRIG_CSEL_SHIFT |
@@ -435,12 +439,12 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
 		index = rq->extts.index;
-		if (index < 0 || index >= n_ext_ts)
+		if (index < 0 || index >= clock->caps.n_ext_ts)
 			return -EINVAL;
 		event_num = index;
 		evnt = EVNT_WR | (event_num & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
 		if (on) {
-			gpio_num = extts_pins[index];
+			gpio_num = clock->extts_pins[index];
 			evnt |= (gpio_num & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
 			if (rq->extts.flags & PTP_FALLING_EDGE)
 				evnt |= EVNT_FALL;
@@ -452,7 +456,7 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 
 	case PTP_CLK_REQ_PEROUT:
 		index = rq->perout.index;
-		if (index < 0 || index >= n_per_out)
+		if (index < 0 || index >= clock->caps.n_per_out)
 			return -EINVAL;
 		periodic_output(clock, rq, index, on);
 		return 0;
@@ -573,7 +577,7 @@ static void recalibrate(struct dp83640_clock *clock)
 	 */
 	evnt = EVNT_WR | EVNT_RISE | EVNT_SINGLE;
 	evnt |= (trigger & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
-	evnt |= (calibrate_pin & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
+	evnt |= (clock->calibrate_pin & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
 
 	list_for_each(this, &clock->phylist) {
 		tmp = list_entry(this, struct dp83640_private, list);
@@ -586,7 +590,7 @@ static void recalibrate(struct dp83640_clock *clock)
 	 */
 	ptp_trig = TRIG_WR | TRIG_IF_LATE | TRIG_PULSE;
 	ptp_trig |= (trigger  & TRIG_CSEL_MASK) << TRIG_CSEL_SHIFT;
-	ptp_trig |= (calibrate_pin & TRIG_GPIO_MASK) << TRIG_GPIO_SHIFT;
+	ptp_trig |= (clock->calibrate_pin & TRIG_GPIO_MASK) << TRIG_GPIO_SHIFT;
 	ext_write(0, master, PAGE5, PTP_TRIG, ptp_trig);
 
 	/* load trigger */
@@ -691,7 +695,7 @@ static int decode_evnt(struct dp83640_private *dp83640,
 	event.type = PTP_CLOCK_EXTTS;
 	event.timestamp = phy2txts(&dp83640->edata);
 
-	for (i = 0; i < n_ext_ts; i++) {
+	for (i = 0; i < dp83640->clock->caps.n_ext_ts; i++) {
 		if (ext_status & exts_chan_to_edata(i)) {
 			event.index = i;
 			ptp_clock_event(dp83640->clock->ptp_clock, &event);
@@ -893,12 +897,11 @@ static void dp83640_clock_init(struct dp83640_clock *clock, struct mii_bus *bus)
 	mutex_init(&clock->extreg_lock);
 	mutex_init(&clock->clock_lock);
 	INIT_LIST_HEAD(&clock->phylist);
+	clock->calibrate_pin = -1;
 	clock->caps.owner = THIS_MODULE;
 	sprintf(clock->caps.name, "dp83640 timer");
 	clock->caps.max_adj	= 1953124;
 	clock->caps.n_alarm	= 0;
-	clock->caps.n_ext_ts	= n_ext_ts;
-	clock->caps.n_per_out	= n_per_out;
 	clock->caps.pps		= 0;
 	clock->caps.adjfreq	= ptp_dp83640_adjfreq;
 	clock->caps.adjtime	= ptp_dp83640_adjtime;
@@ -911,18 +914,6 @@ static void dp83640_clock_init(struct dp83640_clock *clock, struct mii_bus *bus)
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
@@ -968,6 +959,86 @@ static void dp83640_clock_put(struct dp83640_clock *clock)
 	mutex_unlock(&clock->clock_lock);
 }
 
+#ifdef CONFIG_OF
+static int dp83640_probe_dt(struct device_node *node,
+			    struct dp83640_private *dp83640)
+{
+	struct dp83640_clock *clock = dp83640->clock;
+	struct property *prop;
+	int err, proplen, n_cal = 0;
+
+	dp83640->slave = of_property_read_bool(node, "dp83640,slave");
+	if (!dp83640->slave && clock->chosen) {
+		pr_err("More then one dp83640 master on the same bus");
+		return -EINVAL;
+	}
+
+	prop = of_find_property(node, "dp83640,calibrate-pin", &proplen);
+	if (prop) {
+		if (dp83640->slave) {
+			pr_err("dp83640 slave cannot have calibrate pin");
+			return -EINVAL;
+		}
+		of_property_read_u32(node, "dp83640,calibrate-pin",
+				     &clock->calibrate_pin);
+		n_cal = 1;
+	}
+
+	prop = of_find_property(node, "dp83640,perout-pins", &proplen);
+	if (prop) {
+		if (dp83640->slave) {
+			pr_err("dp83640 slave cannot have perout pins");
+			return -EINVAL;
+		}
+
+		clock->caps.n_per_out = proplen / sizeof(u32);
+		if (clock->caps.n_per_out + n_cal > N_EXT) {
+			pr_err("Too many dp83640,perout-pins");
+			return -EINVAL;
+		}
+		err = of_property_read_u32_array(node, "dp83640,perout-pins",
+						 clock->perout_pins,
+						 clock->caps.n_per_out);
+		if (err < 0)
+			return err;
+	}
+
+	prop = of_find_property(node, "dp83640,extts-pins", &proplen);
+	if (prop) {
+		if (dp83640->slave) {
+			pr_err("dp83640 slave cannot have extts pins");
+			return -EINVAL;
+		}
+
+		clock->caps.n_ext_ts = proplen / sizeof(u32);
+		if (clock->caps.n_ext_ts + n_cal > N_EXT) {
+			pr_err("Too many dp83640,extts-pins");
+			return -EINVAL;
+		}
+		err = of_property_read_u32_array(node, "dp83640,extts-pins",
+						 clock->extts_pins,
+						 clock->caps.n_ext_ts);
+		if (err < 0)
+			return err;
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
@@ -985,7 +1056,24 @@ static int dp83640_probe(struct phy_device *phydev)
 	if (!dp83640)
 		goto no_memory;
 
+	dp83640->clock = clock;
 	dp83640->phydev = phydev;
+
+	if (phydev->dev.of_node) {
+		err = dp83640_probe_dt(phydev->dev.of_node, dp83640);
+		if (err)
+			return err;
+	} else {
+		clock->calibrate_pin = calibrate_pin;
+		memcpy(clock->perout_pins, perout_pins,
+		       sizeof(clock->perout_pins));
+		memcpy(clock->extts_pins, extts_pins,
+		       sizeof(clock->extts_pins));
+		if (clock->chosen ||
+		    (chosen_phy != -1 && phydev->addr != chosen_phy))
+			dp83640->slave = true;
+	}
+
 	INIT_WORK(&dp83640->ts_work, rx_timestamp_work);
 
 	INIT_LIST_HEAD(&dp83640->rxts);
@@ -999,9 +1087,7 @@ static int dp83640_probe(struct phy_device *phydev)
 	skb_queue_head_init(&dp83640->rx_queue);
 	skb_queue_head_init(&dp83640->tx_queue);
 
-	dp83640->clock = clock;
-
-	if (choose_this_phy(clock, phydev)) {
+	if (!dp83640->slave) {
 		clock->chosen = dp83640;
 		clock->ptp_clock = ptp_clock_register(&clock->caps, &phydev->dev);
 		if (IS_ERR(clock->ptp_clock)) {
@@ -1353,7 +1439,10 @@ static struct phy_driver dp83640_driver = {
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

