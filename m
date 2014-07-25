Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbaGYRrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:47:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54825 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbaGYRq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:46:59 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-pm@vger.kernel.org>
CC: <ben.dooks@codethink.co.uk>, <laurent.pinchart@ideasonboard.com>,
        <grant.likely@secretlab.ca>, <ulf.hansson@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-sh@vger.kernel.org>
Subject: [RFC PATCH 1/3] PM / clock_ops: Add pm_clk_add_clk()
Date: Fri, 25 Jul 2014 21:31:34 +0300
Message-ID: <1406313096-29761-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com>
References: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

The existing pm_clk_add() allows to pass a clock by con_id. However,
when referring to a specific clock from DT, no con_id is available.

Add pm_clk_add_clk(), which allows to specify the struct clk * directly.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/base/power/clock_ops.c |   40 ++++++++++++++++++++++++++++++----------
 include/linux/pm_clock.h       |    3 +++
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index b99e6c0..2d5c9c1 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -53,7 +53,8 @@ static inline int __pm_clk_enable(struct device *dev, struct clk *clk)
  */
 static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
 {
-	ce->clk = clk_get(dev, ce->con_id);
+	if (!ce->clk)
+		ce->clk = clk_get(dev, ce->con_id);
 	if (IS_ERR(ce->clk)) {
 		ce->status = PCE_STATUS_ERROR;
 	} else {
@@ -63,15 +64,8 @@ static void pm_clk_acquire(struct device *dev, struct pm_clock_entry *ce)
 	}
 }
 
-/**
- * pm_clk_add - Start using a device clock for power management.
- * @dev: Device whose clock is going to be used for power management.
- * @con_id: Connection ID of the clock.
- *
- * Add the clock represented by @con_id to the list of clocks used for
- * the power management of @dev.
- */
-int pm_clk_add(struct device *dev, const char *con_id)
+static int __pm_clk_add(struct device *dev, const char *con_id,
+			struct clk *clk)
 {
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
@@ -93,6 +87,8 @@ int pm_clk_add(struct device *dev, const char *con_id)
 			kfree(ce);
 			return -ENOMEM;
 		}
+	} else {
+		ce->clk = clk;
 	}
 
 	pm_clk_acquire(dev, ce);
@@ -102,6 +98,30 @@ int pm_clk_add(struct device *dev, const char *con_id)
 	spin_unlock_irq(&psd->lock);
 	return 0;
 }
+/**
+ * pm_clk_add - Start using a device clock for power management.
+ * @dev: Device whose clock is going to be used for power management.
+ * @con_id: Connection ID of the clock.
+ *
+ * Add the clock represented by @con_id to the list of clocks used for
+ * the power management of @dev.
+ */
+int pm_clk_add(struct device *dev, const char *con_id)
+{
+	return __pm_clk_add(dev, con_id, NULL);
+}
+
+/**
+ * pm_clk_add_clk - Start using a device clock for power management.
+ * @dev: Device whose clock is going to be used for power management.
+ * @clk: Clock pointer
+ *
+ * Add the clock to the list of clocks used for the power management of @dev.
+ */
+int pm_clk_add_clk(struct device *dev, struct clk *clk)
+{
+	return __pm_clk_add(dev, NULL, clk);
+}
 
 /**
  * __pm_clk_remove - Destroy PM clock entry.
diff --git a/include/linux/pm_clock.h b/include/linux/pm_clock.h
index 8348866..6981aa2 100644
--- a/include/linux/pm_clock.h
+++ b/include/linux/pm_clock.h
@@ -18,6 +18,8 @@ struct pm_clk_notifier_block {
 	char *con_ids[];
 };
 
+struct clk;
+
 #ifdef CONFIG_PM_CLK
 static inline bool pm_clk_no_clocks(struct device *dev)
 {
@@ -29,6 +31,7 @@ extern void pm_clk_init(struct device *dev);
 extern int pm_clk_create(struct device *dev);
 extern void pm_clk_destroy(struct device *dev);
 extern int pm_clk_add(struct device *dev, const char *con_id);
+extern int pm_clk_add_clk(struct device *dev, struct clk *clk);
 extern void pm_clk_remove(struct device *dev, const char *con_id);
 extern int pm_clk_suspend(struct device *dev);
 extern int pm_clk_resume(struct device *dev);
-- 
1.7.9.5

