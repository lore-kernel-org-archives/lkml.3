Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaKFNvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:51:48 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47305 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751702AbaKFNvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:51:43 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <ssantosh@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <khilman@linaro.org>
CC: <linux-pm@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <grant.likely@secretlab.ca>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH v4 2/3] PM / clock_ops: make __pm_clk_enable more generic
Date: Thu, 6 Nov 2014 15:51:01 +0200
Message-ID: <1415281862-23764-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415281862-23764-1-git-send-email-grygorii.strashko@ti.com>
References: <1415281862-23764-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there are two places in code which do the same things,
so allow __pm_clk_enable() to accept pointer on pm_clock_entry
structure as second parameter instead of pointer on clock and
remove duplicated code.

Also, updated function intended to be used by following patch.

CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Kevin Hilman <khilman@linaro.org>
CC: Ulf Hansson <ulf.hansson@linaro.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/base/power/clock_ops.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index f061eaa..b32b5d4 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -35,14 +35,20 @@ struct pm_clock_entry {
 /**
  * pm_clk_enable - Enable a clock, reporting any errors
  * @dev: The device for the given clock
- * @clk: The clock being enabled.
+ * @ce: PM clock entry corresponding to the clock.
  */
-static inline int __pm_clk_enable(struct device *dev, struct clk *clk)
+static inline int __pm_clk_enable(struct device *dev, struct pm_clock_entry *ce)
 {
-	int ret = clk_enable(clk);
-	if (ret)
-		dev_err(dev, "%s: failed to enable clk %p, error %d\n",
-			__func__, clk, ret);
+	int ret;
+
+	if (ce->status < PCE_STATUS_ERROR) {
+		ret = clk_enable(ce->clk);
+		if (!ret)
+			ce->status = PCE_STATUS_ENABLED;
+		else
+			dev_err(dev, "%s: failed to enable clk %p, error %d\n",
+				__func__, ce->clk, ret);
+	}
 
 	return ret;
 }
@@ -293,7 +299,6 @@ int pm_clk_resume(struct device *dev)
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 	unsigned long flags;
-	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -302,13 +307,8 @@ int pm_clk_resume(struct device *dev)
 
 	spin_lock_irqsave(&psd->lock, flags);
 
-	list_for_each_entry(ce, &psd->clock_list, node) {
-		if (ce->status < PCE_STATUS_ERROR) {
-			ret = __pm_clk_enable(dev, ce->clk);
-			if (!ret)
-				ce->status = PCE_STATUS_ENABLED;
-		}
-	}
+	list_for_each_entry(ce, &psd->clock_list, node)
+		__pm_clk_enable(dev, ce);
 
 	spin_unlock_irqrestore(&psd->lock, flags);
 
@@ -417,7 +417,6 @@ int pm_clk_resume(struct device *dev)
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 	unsigned long flags;
-	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -427,13 +426,8 @@ int pm_clk_resume(struct device *dev)
 
 	spin_lock_irqsave(&psd->lock, flags);
 
-	list_for_each_entry(ce, &psd->clock_list, node) {
-		if (ce->status < PCE_STATUS_ERROR) {
-			ret = __pm_clk_enable(dev, ce->clk);
-			if (!ret)
-				ce->status = PCE_STATUS_ENABLED;
-		}
-	}
+	list_for_each_entry(ce, &psd->clock_list, node)
+		__pm_clk_enable(dev, ce);
 
 	spin_unlock_irqrestore(&psd->lock, flags);
 
-- 
1.9.1

