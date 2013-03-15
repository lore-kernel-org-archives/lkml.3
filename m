Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3CONSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:18:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60445 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab3CONS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:18:29 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 47/50] staging: omap-thermal: switch mutex to spinlock inside omap-bandgap
Date: Fri, 15 Mar 2013 09:00:35 -0400
Message-ID: <1363352438-15935-48-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because there is a need to lock inside IRQ handler, this patch
changes the locking mechanism inside the omap-bandgap.[c,h] to
spinlocks. Now this lock is used to protect omap_bandgap struct
during APIs exposed (possibly used in sysfs handling functions)
and inside the ALERT IRQ handler.

Because there are registers shared among the sensors, this lock
is global, not per sensor.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/TODO           |    1 -
 drivers/staging/omap-thermal/omap-bandgap.c |   18 ++++++++++--------
 drivers/staging/omap-thermal/omap-bandgap.h |    4 ++--
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/omap-thermal/TODO b/drivers/staging/omap-thermal/TODO
index 77b761b..0f24e9b 100644
--- a/drivers/staging/omap-thermal/TODO
+++ b/drivers/staging/omap-thermal/TODO
@@ -1,7 +1,6 @@
 List of TODOs (by Eduardo Valentin)
 
 on omap-bandgap.c:
-- Rework locking
 - Improve driver code by adding usage of regmap-mmio
 - Test every exposed API to userland
 - Add support to hwmon
diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 4b631fd..846ced6 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -33,7 +33,7 @@
 #include <linux/platform_device.h>
 #include <linux/err.h>
 #include <linux/types.h>
-#include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/reboot.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
@@ -170,6 +170,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 	u32 t_hot = 0, t_cold = 0, ctrl;
 	int i;
 
+	spin_lock(&bg_ptr->lock);
 	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
 		tsr = bg_ptr->conf->sensors[i].registers;
 		ctrl = omap_bandgap_readl(bg_ptr, tsr->bgap_status);
@@ -208,6 +209,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 		if (bg_ptr->conf->report_temperature)
 			bg_ptr->conf->report_temperature(bg_ptr, i);
 	}
+	spin_unlock(&bg_ptr->lock);
 
 	return IRQ_HANDLED;
 }
@@ -502,9 +504,9 @@ int _omap_bandgap_write_threshold(struct omap_bandgap *bg_ptr, int id, int val,
 	if (ret < 0)
 		goto exit;
 
-	mutex_lock(&bg_ptr->bg_mutex);
+	spin_lock(&bg_ptr->lock);
 	omap_bandgap_update_alert_threshold(bg_ptr, id, adc_val, hot);
-	mutex_unlock(&bg_ptr->bg_mutex);
+	spin_unlock(&bg_ptr->lock);
 
 exit:
 	return ret;
@@ -666,9 +668,9 @@ int omap_bandgap_write_update_interval(struct omap_bandgap *bg_ptr,
 		return -ENOTSUPP;
 
 	interval = interval * bg_ptr->clk_rate / 1000;
-	mutex_lock(&bg_ptr->bg_mutex);
+	spin_lock(&bg_ptr->lock);
 	RMW_BITS(bg_ptr, id, bgap_counter, counter_mask, interval);
-	mutex_unlock(&bg_ptr->bg_mutex);
+	spin_unlock(&bg_ptr->lock);
 
 	return 0;
 }
@@ -691,9 +693,9 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
 	if (ret)
 		return ret;
 
-	mutex_lock(&bg_ptr->bg_mutex);
+	spin_lock(&bg_ptr->lock);
 	temp = omap_bandgap_read_temp(bg_ptr, id);
-	mutex_unlock(&bg_ptr->bg_mutex);
+	spin_unlock(&bg_ptr->lock);
 
 	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, temp, &temp);
 	if (ret)
@@ -1016,7 +1018,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 		clk_prepare_enable(bg_ptr->fclock);
 
 
-	mutex_init(&bg_ptr->bg_mutex);
+	spin_lock_init(&bg_ptr->lock);
 	bg_ptr->dev = &pdev->dev;
 	platform_set_drvdata(pdev, bg_ptr);
 
diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index edcc965..5700586 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -23,7 +23,7 @@
 #ifndef __OMAP_BANDGAP_H
 #define __OMAP_BANDGAP_H
 
-#include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/err.h>
 
@@ -211,7 +211,7 @@ struct omap_bandgap {
 	struct omap_bandgap_data	*conf;
 	struct clk			*fclock;
 	struct clk			*div_clk;
-	struct mutex			bg_mutex; /* shields this struct */
+	spinlock_t			lock; /* shields this struct */
 	int				irq;
 	int				tshut_gpio;
 	u32				clk_rate;
-- 
1.7.7.1.488.ge8e1c

