Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaBMOfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 09:35:45 -0500
Received: from 213083164162.static.sonofon.dk ([213.83.164.162]:47755 "EHLO
	HORWDSPRD01.spectralink.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751571AbaBMOfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 09:35:40 -0500
From: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
To: richardcochran@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: =?UTF-8?q?Stefan=20S=C3=B8rensen?= 
	<stefan.sorensen@spectralink.com>
Subject: [PATCH v3 2/3] net:phy:dp83640: Support a configurable number of periodic outputs
Date: Thu, 13 Feb 2014 15:35:24 +0100
Message-Id: <1392302129-24947-3-git-send-email-stefan.sorensen@spectralink.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
References: <1392302129-24947-1-git-send-email-stefan.sorensen@spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Feb 2014 14:35:38.0145 (UTC) FILETIME=[DCE2B910:01CF28C8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is currently limited to a single periodic output. This patch makes
the number of peridodic output dynamic by dropping the gpio_tab module
parameter and adding calibrate_pin, perout_pins, and extts_pins parameters.

Signed-off-by: Stefan Sørensen <stefan.sorensen@spectralink.com>
---
 drivers/net/phy/dp83640.c | 73 ++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 42 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index a370814..28a6e1d 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -38,15 +38,12 @@
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
 #define CAL_TRIGGER	7
-#define PER_TRIGGER	6
 
 #define MII_DP83640_MICR 0x11
 #define MII_DP83640_MISR 0x12
@@ -146,32 +143,24 @@ struct dp83640_clock {
 	struct ptp_clock *ptp_clock;
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
 
 static int chosen_phy = -1;
-static ushort gpio_tab[GPIO_TABLE_SIZE] = {
-	1, 2, 3, 4, 8, 9, 10, 11
-};
+static int calibrate_pin = 1;
+static int perout_pins[N_EXT] = {2};
+static int n_per_out = 1;
+static int extts_pins[N_EXT] = {3, 4, 8, 9, 10, 11};
+static int n_ext_ts = 6;
 
 module_param(chosen_phy, int, 0444);
-module_param_array(gpio_tab, ushort, NULL, 0444);
+module_param(calibrate_pin, int, 0444);
+module_param_array(perout_pins, int, &n_per_out, 0444);
+module_param_array(extts_pins, int, &n_ext_ts, 0444);
 
 MODULE_PARM_DESC(chosen_phy, \
 	"The address of the PHY to use for the ancillary clock features");
-MODULE_PARM_DESC(gpio_tab, \
-	"Which GPIO line to use for which purpose: cal,perout,extts1,...,extts6");
+MODULE_PARM_DESC(calibrate_pin, "Which pin to use for calibration");
+MODULE_PARM_DESC(perout_pins, "Which pins to use for periodic output");
+MODULE_PARM_DESC(extts_pins, "Which pins to use for external timestamping");
 
 /* a list of clocks and a mutex to protect it */
 static LIST_HEAD(phyter_clocks);
@@ -267,15 +256,15 @@ static u64 phy2txts(struct phy_txts *p)
 }
 
 static void periodic_output(struct dp83640_clock *clock,
-			    struct ptp_clock_request *clkreq, bool on)
+			    struct ptp_clock_request *clkreq, int trigger,
+			    bool on)
 {
 	struct dp83640_private *dp83640 = clock->chosen;
 	struct phy_device *phydev = dp83640->phydev;
 	u32 sec, nsec, period;
-	u16 gpio, ptp_trig, trigger, val;
+	u16 gpio, ptp_trig, val;
 
-	gpio = on ? gpio_tab[PEROUT_GPIO] : 0;
-	trigger = PER_TRIGGER;
+	gpio = on ? perout_pins[trigger] : 0;
 
 	ptp_trig = TRIG_WR |
 		(trigger & TRIG_CSEL_MASK) << TRIG_CSEL_SHIFT |
@@ -446,12 +435,12 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 	switch (rq->type) {
 	case PTP_CLK_REQ_EXTTS:
 		index = rq->extts.index;
-		if (index < 0 || index >= N_EXT_TS)
+		if (index < 0 || index >= n_ext_ts)
 			return -EINVAL;
-		event_num = EXT_EVENT + index;
+		event_num = index;
 		evnt = EVNT_WR | (event_num & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
 		if (on) {
-			gpio_num = gpio_tab[EXTTS0_GPIO + index];
+			gpio_num = extts_pins[index];
 			evnt |= (gpio_num & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
 			if (rq->extts.flags & PTP_FALLING_EDGE)
 				evnt |= EVNT_FALL;
@@ -462,9 +451,10 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
 		return 0;
 
 	case PTP_CLK_REQ_PEROUT:
-		if (rq->perout.index != 0)
+		index = rq->perout.index;
+		if (index < 0 || index >= n_per_out)
 			return -EINVAL;
-		periodic_output(clock, rq, on);
+		periodic_output(clock, rq, index, on);
 		return 0;
 
 	default:
@@ -557,10 +547,9 @@ static void recalibrate(struct dp83640_clock *clock)
 	struct list_head *this;
 	struct dp83640_private *tmp;
 	struct phy_device *master = clock->chosen->phydev;
-	u16 cal_gpio, cfg0, evnt, ptp_trig, trigger, val;
+	u16 cfg0, evnt, ptp_trig, trigger, val;
 
 	trigger = CAL_TRIGGER;
-	cal_gpio = gpio_tab[CALIBRATE_GPIO];
 
 	mutex_lock(&clock->extreg_lock);
 
@@ -583,8 +572,8 @@ static void recalibrate(struct dp83640_clock *clock)
 	 * enable an event timestamp
 	 */
 	evnt = EVNT_WR | EVNT_RISE | EVNT_SINGLE;
-	evnt |= (CAL_EVENT & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
-	evnt |= (cal_gpio & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
+	evnt |= (trigger & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
+	evnt |= (calibrate_pin & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
 
 	list_for_each(this, &clock->phylist) {
 		tmp = list_entry(this, struct dp83640_private, list);
@@ -597,7 +586,7 @@ static void recalibrate(struct dp83640_clock *clock)
 	 */
 	ptp_trig = TRIG_WR | TRIG_IF_LATE | TRIG_PULSE;
 	ptp_trig |= (trigger  & TRIG_CSEL_MASK) << TRIG_CSEL_SHIFT;
-	ptp_trig |= (cal_gpio & TRIG_GPIO_MASK) << TRIG_GPIO_SHIFT;
+	ptp_trig |= (calibrate_pin & TRIG_GPIO_MASK) << TRIG_GPIO_SHIFT;
 	ext_write(0, master, PAGE5, PTP_TRIG, ptp_trig);
 
 	/* load trigger */
@@ -661,7 +650,7 @@ static void recalibrate(struct dp83640_clock *clock)
 
 static inline u16 exts_chan_to_edata(int ch)
 {
-	return 1 << ((ch + EXT_EVENT) * 2);
+	return 1 << ((ch) * 2);
 }
 
 static int decode_evnt(struct dp83640_private *dp83640,
@@ -695,14 +684,14 @@ static int decode_evnt(struct dp83640_private *dp83640,
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
+	for (i = 0; i < n_ext_ts; i++) {
 		if (ext_status & exts_chan_to_edata(i)) {
 			event.index = i;
 			ptp_clock_event(dp83640->clock->ptp_clock, &event);
@@ -908,8 +897,8 @@ static void dp83640_clock_init(struct dp83640_clock *clock, struct mii_bus *bus)
 	sprintf(clock->caps.name, "dp83640 timer");
 	clock->caps.max_adj	= 1953124;
 	clock->caps.n_alarm	= 0;
-	clock->caps.n_ext_ts	= N_EXT_TS;
-	clock->caps.n_per_out	= 1;
+	clock->caps.n_ext_ts	= n_ext_ts;
+	clock->caps.n_per_out	= n_per_out;
 	clock->caps.pps		= 0;
 	clock->caps.adjfreq	= ptp_dp83640_adjfreq;
 	clock->caps.adjtime	= ptp_dp83640_adjtime;
-- 
1.8.5.3

