Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbaJWOX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:23:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53599 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaJWOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:23:46 -0400
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
Subject: [PATCH v3 2/5] PM / clock_ops: make __pm_clk_enable more generic
Date: Thu, 23 Oct 2014 17:22:59 +0300
Message-ID: <1414074182-25980-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414074182-25980-1-git-send-email-grygorii.strashko@ti.com>
References: <1414074182-25980-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there are two places in code which do the same things,
so allow __pm_clk_enable() to accept pointer on pm_clock_entry
structure as second parameter instead of pointer on clock and
remove duplicated code.

Also, updated function intended to be used by the following patch.

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
index f14b767..c3b44c1 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -34,14 +34,20 @@ struct pm_clock_entry {
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
@@ -287,7 +293,6 @@ int pm_clk_resume(struct device *dev)
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 	unsigned long flags;
-	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -296,13 +301,8 @@ int pm_clk_resume(struct device *dev)
 
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
 
@@ -411,7 +411,6 @@ int pm_clk_resume(struct device *dev)
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 	unsigned long flags;
-	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -421,13 +420,8 @@ int pm_clk_resume(struct device *dev)
 
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

