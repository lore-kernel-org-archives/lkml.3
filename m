Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaIASsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 14:48:31 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33487 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaIASs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 14:48:29 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH 2/3] clk: mvebu: powersave clock is a multiplexer
Date: Mon,  1 Sep 2014 11:47:04 -0700
Message-Id: <1409597225-24368-3-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1409597225-24368-1-git-send-email-mturquette@linaro.org>
References: <1409597225-24368-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirkwood is unique among the mvebu SoCs for having a clock multiplexer
that feeds into the cpu. This multiplexer can select either the cpu pll
or the ddr clock as its input signal, allowing for a choice between
performance and power savings.

This patch introduces the code needed to register the clock multiplexer
on Kirkwood SoCs but does not include the clock data to actually
register the clock. That will be done in a follow-up patch which is
necessary to prevent breaking git bisect.

Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/mvebu/kirkwood.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/drivers/clk/mvebu/kirkwood.c b/drivers/clk/mvebu/kirkwood.c
index ddb666a..f73a2fa 100644
--- a/drivers/clk/mvebu/kirkwood.c
+++ b/drivers/clk/mvebu/kirkwood.c
@@ -13,9 +13,11 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/clk-provider.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include "common.h"
 
 /*
@@ -225,6 +227,91 @@ static const struct clk_gating_soc_desc kirkwood_gating_desc[] __initconst = {
 	{ }
 };
 
+
+/*
+ * Clock Muxing Control
+ */
+
+struct clk_muxing_soc_desc {
+	const char *name;
+	const char **parents;
+	int num_parents;
+	int shift;
+	int width;
+	unsigned long flags;
+};
+
+struct clk_muxing_ctrl {
+	spinlock_t *lock;
+	struct clk **muxes;
+	int num_muxes;
+};
+
+#define to_clk_mux(_hw) container_of(_hw, struct clk_mux, hw)
+
+static struct clk *clk_muxing_get_src(
+	struct of_phandle_args *clkspec, void *data)
+{
+	struct clk_muxing_ctrl *ctrl = (struct clk_muxing_ctrl *)data;
+	int n;
+
+	if (clkspec->args_count < 1)
+		return ERR_PTR(-EINVAL);
+
+	for (n = 0; n < ctrl->num_muxes; n++) {
+		struct clk_mux *mux =
+			to_clk_mux(__clk_get_hw(ctrl->muxes[n]));
+		if (clkspec->args[0] == mux->shift)
+			return ctrl->muxes[n];
+	}
+	return ERR_PTR(-ENODEV);
+}
+
+static void __init kirkwood_clk_muxing_setup(struct device_node *np,
+				   const struct clk_muxing_soc_desc *desc)
+{
+	struct clk_muxing_ctrl *ctrl;
+	void __iomem *base;
+	int n;
+
+	base = of_iomap(np, 0);
+	if (WARN_ON(!base))
+		return;
+
+	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
+	if (WARN_ON(!ctrl))
+		goto ctrl_out;
+
+	/* lock must already be initialized */
+	ctrl->lock = &ctrl_gating_lock;
+
+	/* Count, allocate, and register clock muxes */
+	for (n = 0; desc[n].name;)
+		n++;
+
+	ctrl->num_muxes = n;
+	ctrl->muxes = kcalloc(ctrl->num_muxes, sizeof(struct clk *),
+			GFP_KERNEL);
+	if (WARN_ON(!ctrl->muxes))
+		goto muxes_out;
+
+	for (n = 0; n < ctrl->num_muxes; n++) {
+		ctrl->muxes[n] = clk_register_mux(NULL, desc[n].name,
+				desc[n].parents, desc[n].num_parents,
+				desc[n].flags, base, desc[n].shift,
+				desc[n].width, desc[n].flags, ctrl->lock);
+		WARN_ON(IS_ERR(ctrl->muxes[n]));
+	}
+
+	of_clk_add_provider(np, clk_muxing_get_src, ctrl);
+
+	return;
+muxes_out:
+	kfree(ctrl);
+ctrl_out:
+	iounmap(base);
+}
+
 static void __init kirkwood_clk_init(struct device_node *np)
 {
 	struct device_node *cgnp =
-- 
1.8.3.2

