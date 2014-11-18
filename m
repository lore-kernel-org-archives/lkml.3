Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188AbaKSAAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 19:00:23 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45747 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173AbaKSAAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 19:00:20 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v3 2/2] clk-fixed-rate: support specified-clock binding
Date: Tue, 18 Nov 2014 23:59:47 +0000
Message-Id: <1416355187-11606-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1416355187-11606-1-git-send-email-james.hogan@imgtec.com>
References: <1416355187-11606-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the new specified-clock DT binding which uses a table to look
up the fixed frequency based on the value in a register.

The discovery is done entirely within of_specified_clk_setup() since the
clock rate is still fixed so there's no need to dynamically rediscover
the rate. The register is iomapped, read, and iounmapped, then the field
value is extracted and used to look up the clock frequency in the table
property.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
No changes in v3.

Changes in v2:
 * Rewrite to use a fixed clock instead of an entirely new clock type.
---
 drivers/clk/clk-fixed-rate.c | 51 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-provider.h |  1 +
 2 files changed, 52 insertions(+)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 0fc56ab..b8bcb4d 100644
--- a/drivers/clk/clk-fixed-rate.c
+++ b/drivers/clk/clk-fixed-rate.c
@@ -9,12 +9,14 @@
  * Fixed rate clock implementation
  */
 
+#include <linux/bitops.h>
 #include <linux/clk-provider.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/err.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 
 /*
  * DOC: basic fixed-rate clock that cannot gate
@@ -134,4 +136,53 @@ void of_fixed_clk_setup(struct device_node *node)
 }
 EXPORT_SYMBOL_GPL(of_fixed_clk_setup);
 CLK_OF_DECLARE(fixed_clk, "fixed-clock", of_fixed_clk_setup);
+
+/**
+ * of_specified_clk_setup() - Setup function for discoverable fixed rate clock
+ */
+void of_specified_clk_setup(struct device_node *node)
+{
+	struct clk *clk;
+	const char *clk_name = node->name;
+	u32 shift, mask, rate, reg_val, val;
+	void __iomem *reg;
+	struct property *prop;
+	const __be32 *p;
+
+	/* Iomap and read the configuration register */
+	reg = of_iomap(node, 0);
+	if (!reg)
+		return;
+	reg_val = readl(reg);
+	iounmap(reg);
+
+	/* Apply bit-mask */
+	if (of_property_read_u32(node, "bit-mask", &mask))
+		return;
+	reg_val &= mask;
+	/* Apply bit-shift */
+	if (of_property_read_u32(node, "bit-shift", &shift))
+		shift = ffs(mask) - 1;
+	reg_val >>= shift;
+
+	/* Look through the mapping for a matching frequency */
+	of_property_for_each_u32(node, "table", prop, p, val) {
+		p = of_prop_next_u32(prop, p, &rate);
+		if (!p)
+			break;
+		if (val == reg_val)
+			goto found_rate;
+	}
+	/* No match found */
+	return;
+found_rate:
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	clk = clk_register_fixed_rate(NULL, clk_name, NULL, CLK_IS_ROOT, rate);
+	if (!IS_ERR(clk))
+		of_clk_add_provider(node, of_clk_src_simple_get, clk);
+}
+EXPORT_SYMBOL_GPL(of_specified_clk_setup);
+CLK_OF_DECLARE(specified_clk, "specified-clock", of_specified_clk_setup);
 #endif
diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
index be21af1..7e5c1d3 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -257,6 +257,7 @@ struct clk *clk_register_fixed_rate_with_accuracy(struct device *dev,
 		unsigned long fixed_rate, unsigned long fixed_accuracy);
 
 void of_fixed_clk_setup(struct device_node *np);
+void of_specified_clk_setup(struct device_node *np);
 
 /**
  * struct clk_gate - gating clock
-- 
2.0.4

