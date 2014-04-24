Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbaDXKNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:13:54 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:60365 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416AbaDXKNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:13:45 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Felipe Balbi <balbi@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 2/4] PM / clock_ops: Add pm_clk_add_clk()
Date: Thu, 24 Apr 2014 12:13:21 +0200
Message-Id: <1398334403-26181-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing pm_clk_add() allows to pass a clock by con_id. However,
when referring to a specific clock from DT, no con_id is available.

Add pm_clk_add_clk(), which allows to specify the struct clk * directly.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/base/power/clock_ops.c |   40 ++++++++++++++++++++++++++++++----------
 include/linux/pm_clock.h       |    3 +++
 2 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index b99e6c06ee67..2d5c9c1eceb1 100644
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
index 8348866e7b05..6981aa288c45 100644
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

