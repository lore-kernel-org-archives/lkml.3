Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaKKIhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:37:31 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58328 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbaKKIh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:37:27 -0500
From: Vignesh R <vigneshr@ti.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        <richardcochran@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Vignesh R <vigneshr@ti.com>, Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>
Subject: [PATCH v3 6/6] input: touchscreen: ti_am335x_tsc: Replace delta filtering with median filtering
Date: Tue, 11 Nov 2014 14:04:04 +0530
Message-ID: <1415694844-11230-7-git-send-email-vigneshr@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415694844-11230-1-git-send-email-vigneshr@ti.com>
References: <1415694844-11230-1-git-send-email-vigneshr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, delta filtering was applied TSC co-ordinate readouts before
reporting a single value to user space. This patch replaces delta filtering
with median filtering. Median filtering sorts co-ordinate readouts, drops min
and max values, and reports the average of remaining values. This method is
more sensible than delta filering. Median filtering is applied only if number
of readouts is greater than 3 else just average of co-ordinate readouts is
reported.

Signed-off-by: Vignesh R <vigneshr@ti.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c | 91 +++++++++++++++++--------------
 1 file changed, 51 insertions(+), 40 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 20ce76b1b6e7..e1df470946e6 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/sort.h>
 
 #include <linux/mfd/ti_am335x_tscadc.h>
 
@@ -204,56 +205,61 @@ static void titsc_step_config(struct titsc *ts_dev)
 	am335x_tsc_se_set_cache(ts_dev->mfd_tscadc, ts_dev->step_mask);
 }
 
+static int titsc_cmp_coord(const void *a, const void *b)
+{
+	return *(int *)a - *(int *)b;
+}
+
 static void titsc_read_coordinates(struct titsc *ts_dev,
 		u32 *x, u32 *y, u32 *z1, u32 *z2)
 {
-	unsigned int fifocount = titsc_readl(ts_dev, REG_FIFO0CNT);
-	unsigned int prev_val_x = ~0, prev_val_y = ~0;
-	unsigned int prev_diff_x = ~0, prev_diff_y = ~0;
-	unsigned int read, diff;
-	unsigned int i, channel;
+	unsigned int yvals[7], xvals[7];
+	unsigned int i, xsum = 0, ysum = 0;
 	unsigned int creads = ts_dev->coordinate_readouts;
-	unsigned int first_step = TOTAL_STEPS - (creads * 2 + 2);
 
-	*z1 = *z2 = 0;
-	if (fifocount % (creads * 2 + 2))
-		fifocount -= fifocount % (creads * 2 + 2);
-	/*
-	 * Delta filter is used to remove large variations in sampled
-	 * values from ADC. The filter tries to predict where the next
-	 * coordinate could be. This is done by taking a previous
-	 * coordinate and subtracting it form current one. Further the
-	 * algorithm compares the difference with that of a present value,
-	 * if true the value is reported to the sub system.
-	 */
-	for (i = 0; i < fifocount; i++) {
-		read = titsc_readl(ts_dev, REG_FIFO0);
-
-		channel = (read & 0xf0000) >> 16;
-		read &= 0xfff;
-		if (channel > first_step + creads + 2) {
-			diff = abs(read - prev_val_x);
-			if (diff < prev_diff_x) {
-				prev_diff_x = diff;
-				*x = read;
-			}
-			prev_val_x = read;
+	for (i = 0; i < creads; i++) {
+		yvals[i] = titsc_readl(ts_dev, REG_FIFO0);
+		yvals[i] &= 0xfff;
+	}
 
-		} else if (channel == first_step + creads + 1) {
-			*z1 = read;
+	*z1 = titsc_readl(ts_dev, REG_FIFO0);
+	*z1 &= 0xfff;
+	*z2 = titsc_readl(ts_dev, REG_FIFO0);
+	*z2 &= 0xfff;
 
-		} else if (channel == first_step + creads + 2) {
-			*z2 = read;
+	for (i = 0; i < creads; i++) {
+		xvals[i] = titsc_readl(ts_dev, REG_FIFO0);
+		xvals[i] &= 0xfff;
+	}
 
-		} else if (channel > first_step) {
-			diff = abs(read - prev_val_y);
-			if (diff < prev_diff_y) {
-				prev_diff_y = diff;
-				*y = read;
-			}
-			prev_val_y = read;
+	/*
+	 * If co-ordinates readouts is less than 4 then
+	 * report the average. In case of 4 or more
+	 * readouts, sort the co-ordinate samples, drop
+	 * min and max values and report the average of
+	 * remaining values.
+	 */
+	if (creads <=  3) {
+		for (i = 0; i < creads; i++) {
+			ysum += yvals[i];
+			xsum += xvals[i];
 		}
+		ysum /= creads;
+		xsum /= creads;
+	} else {
+		sort(yvals, creads, sizeof(unsigned int),
+		     titsc_cmp_coord, NULL);
+		sort(xvals, creads, sizeof(unsigned int),
+		     titsc_cmp_coord, NULL);
+		for (i = 1; i < creads - 1; i++) {
+			ysum += yvals[i];
+			xsum += xvals[i];
+		}
+		ysum /= creads - 2;
+		xsum /= creads - 2;
 	}
+	*y = ysum;
+	*x = xsum;
 }
 
 static irqreturn_t titsc_irq(int irq, void *dev)
@@ -362,6 +368,11 @@ static int titsc_parse_dt(struct platform_device *pdev,
 	if (err < 0)
 		return err;
 
+	if (ts_dev->coordinate_readouts <= 0) {
+		dev_warn(&pdev->dev, "invalid co-ordinate readouts, resetting it to 5\n");
+		ts_dev->coordinate_readouts = 5;
+	}
+
 	err = of_property_read_u32(node, "ti,charge-delay",
 				   &ts_dev->charge_delay);
 	if (err < 0)
-- 
1.9.1

