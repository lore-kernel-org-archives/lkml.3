Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab3AXDpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:45:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59125 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222Ab3AXDp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:45:26 -0500
From: "Patil, Rachna" <rachna@ti.com>
To: <linux-doc@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, Rob Herring <rob.herring@calxeda.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, Tony Lindgren <tony@atomide.com>,
        Benit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        <gururaja.hebbar@ti.com>, "Patil, Rachna" <rachna@ti.com>
Subject: [PATCH v4 1/8] input: ti_am335x_tsc: Step enable bits made configurable
Date: Thu, 24 Jan 2013 09:15:05 +0530
Message-ID: <1358999112-31192-2-git-send-email-rachna@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358999112-31192-1-git-send-email-rachna@ti.com>
References: <1358999112-31192-1-git-send-email-rachna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

Current code has hard coded value written to
step enable bits. Now the bits are updated based
on how many steps are needed to be configured got
from platform data.

The user needs to take care not to exceed
the count more than 16. While using ADC and TSC
one should take care to set this parameter correctly.

Signed-off-by: Patil, Rachna <rachna@ti.com>
---
 drivers/input/touchscreen/ti_am335x_tsc.c |   10 ++++++++--
 include/linux/mfd/ti_am335x_tscadc.h      |    1 -
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index 51e7b87..da652e0 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -39,6 +39,7 @@ struct titsc {
 	unsigned int		irq;
 	unsigned int		wires;
 	unsigned int		x_plate_resistance;
+	unsigned int		enable_bits;
 	bool			pen_down;
 	int			steps_to_configure;
 };
@@ -57,6 +58,7 @@ static void titsc_writel(struct titsc *tsc, unsigned int reg,
 static void titsc_step_config(struct titsc *ts_dev)
 {
 	unsigned int	config;
+	unsigned int	stepenable = 0;
 	int i, total_steps;
 
 	/* Configure the Step registers */
@@ -128,7 +130,11 @@ static void titsc_step_config(struct titsc *ts_dev)
 	titsc_writel(ts_dev, REG_STEPDELAY(total_steps + 2),
 			STEPCONFIG_OPENDLY);
 
-	titsc_writel(ts_dev, REG_SE, STPENB_STEPENB_TC);
+	for (i = 0; i <= (total_steps + 2); i++)
+		stepenable |= 1 << i;
+	ts_dev->enable_bits = stepenable;
+
+	titsc_writel(ts_dev, REG_SE, ts_dev->enable_bits);
 }
 
 static void titsc_read_coordinates(struct titsc *ts_dev,
@@ -250,7 +256,7 @@ static irqreturn_t titsc_irq(int irq, void *dev)
 
 	titsc_writel(ts_dev, REG_IRQSTATUS, irqclr);
 
-	titsc_writel(ts_dev, REG_SE, STPENB_STEPENB_TC);
+	titsc_writel(ts_dev, REG_SE, ts_dev->enable_bits);
 	return IRQ_HANDLED;
 }
 
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index c79ad5d..23e4f33 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -47,7 +47,6 @@
 #define STEPENB_MASK		(0x1FFFF << 0)
 #define STEPENB(val)		((val) << 0)
 #define STPENB_STEPENB		STEPENB(0x1FFFF)
-#define STPENB_STEPENB_TC	STEPENB(0x1FFF)
 
 /* IRQ enable */
 #define IRQENB_HW_PEN		BIT(0)
-- 
1.7.9.5

