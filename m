Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaDXKNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:13:48 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:60418 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424AbaDXKNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:13:43 -0400
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
Subject: [PATCH/RFC 1/4] clk: Add CLK_RUNTIME_PM and clk_may_runtime_pm()
Date: Thu, 24 Apr 2014 12:13:20 +0200
Message-Id: <1398334403-26181-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag CLK_RUNTIME_PM, to let low-level clock drivers indicate that
a clock is suitable for Runtime PM.
Add clk_may_runtime_pm(), to get the status of the flag.

This will allow the device core to enable automatic Runtime PM management
for devices tied to clocks that are suitable for Runtime PM.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/clk/clk.c            |   12 ++++++++++++
 include/linux/clk-provider.h |    1 +
 include/linux/clk.h          |    1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 0b2819551756..a83a2cc0af67 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1115,6 +1115,18 @@ long clk_get_accuracy(struct clk *clk)
 EXPORT_SYMBOL_GPL(clk_get_accuracy);
 
 /**
+ * clk_may_runtime_pm - check if the clock is suitable for Runtime PM
+ * @clk: the clock to check
+ *
+ * Return true if the clock is suitable for Runtime PM
+ * Return false if clk is NULL, or if the clock is not suitable for Runtime PM.
+ */
+bool clk_may_runtime_pm(const struct clk *clk)
+{
+	return clk && clk->flags & CLK_RUNTIME_PM;
+}
+
+/**
  * __clk_recalc_rates
  * @clk: first clk in the subtree
  * @msg: notification type (see include/linux/clk.h)
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 24c8ba4fa6ae..3ca9a7c1f02d 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -30,6 +30,7 @@
 #define CLK_GET_RATE_NOCACHE	BIT(6) /* do not use the cached clk rate */
 #define CLK_SET_RATE_NO_REPARENT BIT(7) /* don't re-parent on rate change */
 #define CLK_GET_ACCURACY_NOCACHE BIT(8) /* do not use the cached clk accuracy */
+#define CLK_RUNTIME_PM		BIT(9) /* clock is suitable for Runtime PM */
 
 struct clk_hw;
 struct dentry;
diff --git a/include/linux/clk.h b/include/linux/clk.h
index d030fce1d77e..07f156580064 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -106,6 +106,7 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
  */
 long clk_get_accuracy(struct clk *clk);
 
+bool clk_may_runtime_pm(const struct clk *clk);
 #else /* !CONFIG_COMMON_CLK */
 
 static inline long clk_get_accuracy(struct clk *clk)
-- 
1.7.9.5

