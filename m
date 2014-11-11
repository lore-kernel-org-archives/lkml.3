Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaKKMMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 07:12:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57109 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbaKKLJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 006/170] PM / clk: Fix crash in clocks management code if !CONFIG_PM_RUNTIME
Date: Tue, 11 Nov 2014 11:06:05 +0000
Message-Id: <1415704129-12709-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit a968bed78b549b4c61d4a46e59161fc1f60f96a6 upstream.

Unlike the clocks management code for runtime PM, the code used for
system suspend does not check the pm_clock_entry.status field.
If pm_clk_acquire() failed, ce->status will be PCE_STATUS_ERROR, and
ce->clk will be a negative error code (e.g. 0xfffffffe = -2 = -ENOENT).

Depending on the clock implementation, suspend or resume may crash with:

    Unable to handle kernel NULL pointer dereference at virtual address 00000026

(CCF clk_disable() has an IS_ERR_OR_NULL() check, while CCF clk_enable()
 only has a NULL check; pre-CCF implementations may behave differently)

While just checking for PCE_STATUS_ERROR would be sufficient, it doesn't
hurt to use the same state machine as is done for runtime PM, as this
makes the two versions more similar, and eligible for a future
consolidation.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/base/power/clock_ops.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index b99e6c06ee67..78369305e069 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -368,8 +368,13 @@ int pm_clk_suspend(struct device *dev)
 
 	spin_lock_irqsave(&psd->lock, flags);
 
-	list_for_each_entry_reverse(ce, &psd->clock_list, node)
-		clk_disable(ce->clk);
+	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
+		if (ce->status < PCE_STATUS_ERROR) {
+			if (ce->status == PCE_STATUS_ENABLED)
+				clk_disable(ce->clk);
+			ce->status = PCE_STATUS_ACQUIRED;
+		}
+	}
 
 	spin_unlock_irqrestore(&psd->lock, flags);
 
@@ -385,6 +390,7 @@ int pm_clk_resume(struct device *dev)
 	struct pm_subsys_data *psd = dev_to_psd(dev);
 	struct pm_clock_entry *ce;
 	unsigned long flags;
+	int ret;
 
 	dev_dbg(dev, "%s()\n", __func__);
 
@@ -394,8 +400,13 @@ int pm_clk_resume(struct device *dev)
 
 	spin_lock_irqsave(&psd->lock, flags);
 
-	list_for_each_entry(ce, &psd->clock_list, node)
-		__pm_clk_enable(dev, ce->clk);
+	list_for_each_entry(ce, &psd->clock_list, node) {
+		if (ce->status < PCE_STATUS_ERROR) {
+			ret = __pm_clk_enable(dev, ce->clk);
+			if (!ret)
+				ce->status = PCE_STATUS_ENABLED;
+		}
+	}
 
 	spin_unlock_irqrestore(&psd->lock, flags);
 
-- 
2.1.0

