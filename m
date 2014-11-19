Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbaKSXQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:16:06 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49972 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbaKSXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:16:01 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 02/15] clk: divider: expose new clk_register_divider_mask
Date: Wed, 19 Nov 2014 23:15:30 +0000
Message-Id: <1416438943-11429-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
References: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose a new function clk_register_divider_mask to set up a mask based
divider. This will be used by the upcoming TZ1090 divider driver whose
DT binding takes a mask rather than a shift and width.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk-divider.c    | 25 +++++++++++++++++++++++++
 include/linux/clk-provider.h |  5 +++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index a432cf8..23ef3df 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -462,3 +462,28 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 			((1 << width) - 1), clk_divider_flags, table, lock);
 }
 EXPORT_SYMBOL_GPL(clk_register_divider_table);
+
+/**
+ * clk_register_divider_mask - register a mask based divider clock with
+ * the clock framework
+ * @dev: device registering this clock
+ * @name: name of this clock
+ * @parent_name: name of clock's parent
+ * @flags: framework-specific flags
+ * @reg: register address to adjust divider
+ * @mask: mask of bitfield
+ * @width: width of the bitfield
+ * @clk_divider_flags: divider-specific flags for this clock
+ * @table: array of divider/value pairs ending with a div set to 0
+ * @lock: shared register lock for this clock
+ */
+struct clk *clk_register_divider_mask(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 shift, u32 mask,
+		u8 clk_divider_flags, const struct clk_div_table *table,
+		spinlock_t *lock)
+{
+	return _register_divider(dev, name, parent_name, flags, reg, shift,
+			mask, clk_divider_flags, table, lock);
+}
+EXPORT_SYMBOL_GPL(clk_register_divider_mask);
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index 2c00215..85048fb 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -361,6 +361,11 @@ struct clk *clk_register_divider_table(struct device *dev, const char *name,
 		void __iomem *reg, u8 shift, u8 width,
 		u8 clk_divider_flags, const struct clk_div_table *table,
 		spinlock_t *lock);
+struct clk *clk_register_divider_mask(struct device *dev, const char *name,
+		const char *parent_name, unsigned long flags,
+		void __iomem *reg, u8 shift, u32 mask,
+		u8 clk_divider_flags, const struct clk_div_table *table,
+		spinlock_t *lock);
 
 /**
  * struct clk_mux - multiplexer clock
-- 
2.0.4

