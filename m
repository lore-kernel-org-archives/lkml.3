Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab3KMVwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 16:52:16 -0500
Received: from multi.imgtec.com ([194.200.65.239]:20880 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab3KMVwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 16:52:07 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <devicetree@vger.kernel.org>,
        <linux-metag@vger.kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>,
        <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 2/2] clk-fixed-rate: support specified-clock binding
Date: Wed, 13 Nov 2013 21:50:00 +0000
Message-ID: <1384379400-24776-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1384379400-24776-1-git-send-email-james.hogan@imgtec.com>
References: <1384379400-24776-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_11_13_21_52_05
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
Cc: linux-arm-kernel@lists.infradead.org
---
Changes in v2:
 * Rewrite to use a fixed clock instead of an entirely new clock type.
---
 drivers/clk/clk-fixed-rate.c | 51 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/clk-provider.h |  1 +
 2 files changed, 52 insertions(+)

diff --git a/drivers/clk/clk-fixed-rate.c b/drivers/clk/clk-fixed-rate.c
index 1ed591ab8b1d..7d7ec4094961 100644
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
@@ -103,4 +105,53 @@ void of_fixed_clk_setup(struct device_node *node)
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
index 7e59253b8603..0e1312504da9 100644
--- a/include/linux/clk-provider.h
+++ b/include/linux/clk-provider.h
@@ -203,6 +203,7 @@ struct clk *clk_register_fixed_rate(struct device *dev, const char *name,
 		unsigned long fixed_rate);
 
 void of_fixed_clk_setup(struct device_node *np);
+void of_specified_clk_setup(struct device_node *np);
 
 /**
  * struct clk_gate - gating clock
-- 
1.8.1.2


