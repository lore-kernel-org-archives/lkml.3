Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab3IPVR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:17:56 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34609 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3IPVRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:17:54 -0400
X-Originating-IP: 83.160.107.163
Date: Mon, 16 Sep 2013 23:17:49 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Jonathan Cameron <jic23@cam.ac.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] iio: ti_am335x_adc: Take touchscreen steps into account
 for conversion timeout
Message-ID: <20130916211749.GG24058@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Jonathan Cameron <jic23@cam.ac.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Felipe Balbi <balbi@ti.com>,
	Pantelis Antoniou <panto@antoniou-consulting.com>,
	linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The calculation of the old conversion timeout value was based on the number of
steps used by this driver. This doesn't take into account that other steps
can be used by the touchscreen driver. Select the timeout value based on the
steps used by both drivers

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 drivers/iio/adc/ti_am335x_adc.c      | 4 ++--
 drivers/mfd/ti_am335x_tscadc.c       | 1 +
 include/linux/mfd/ti_am335x_tscadc.h | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 3ceac3e..75be579 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -145,8 +145,8 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
 	u32 step = UINT_MAX;
 	bool found = false;
 	u32 step_en;
-	unsigned long timeout = jiffies + usecs_to_jiffies
-				(IDLE_TIMEOUT * adc_dev->channels);
+	unsigned long timeout = jiffies + usecs_to_jiffies(IDLE_TIMEOUT *
+		(adc_dev->channels + adc_dev->mfd_tscadc->tsc_steps));
 	step_en = get_adc_step_mask(adc_dev);
 	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
 
diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index b003a16..b2e1a1c 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -228,6 +228,7 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	/* TSC Cell */
 	if (tsc_wires > 0) {
 		tscadc->tsc_cell = tscadc->used_cells;
+		tscadc->tsc_steps = readouts * 2 + 2;
 		cell = &tscadc->cells[tscadc->used_cells++];
 		cell->name = "TI-am335x-tsc";
 		cell->of_compatible = "ti,am3359-tsc";
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index db1791b..7e8d702 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -147,6 +147,7 @@ struct ti_tscadc_dev {
 	struct mfd_cell cells[TSCADC_CELLS];
 	u32 reg_se_cache;
 	spinlock_t reg_lock;
+	int tsc_steps;
 
 	/* tsc device */
 	struct titsc *tsc;
-- 
1.8.4.rc3

