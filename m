Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbbAZLOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:14:22 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:36517 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbbAZLOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:14:16 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, mturquette@linaro.org,
        sboyd@codeaurora.org, devicetree@vger.kernel.org
Subject: [PATCH 3/4] clk: st: Provide a clock domain
Date: Mon, 26 Jan 2015 11:13:59 +0000
Message-Id: <1422270840-3039-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422270840-3039-1-git-send-email-lee.jones@linaro.org>
References: <1422270840-3039-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ST's h/w contains clocks which if turned off would prove fatal.  The
only way to recover is to restart the board(s).  This driver takes
references to clocks which are required to be always-on in order to
prevent the common clk framework from trying to turn them off during
the clk_disabled_unused() procedure.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/st/Makefile     |  2 +-
 drivers/clk/st/clk-domain.c | 63 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/st/clk-domain.c

diff --git a/drivers/clk/st/Makefile b/drivers/clk/st/Makefile
index ede7b2f..ac09be6 100644
--- a/drivers/clk/st/Makefile
+++ b/drivers/clk/st/Makefile
@@ -1 +1 @@
-obj-y += clkgen-mux.o clkgen-pll.o clkgen-fsyn.o clk-flexgen.o
+obj-y += clkgen-mux.o clkgen-pll.o clkgen-fsyn.o clk-flexgen.o clk-domain.o
diff --git a/drivers/clk/st/clk-domain.c b/drivers/clk/st/clk-domain.c
new file mode 100644
index 0000000..e34049b
--- /dev/null
+++ b/drivers/clk/st/clk-domain.c
@@ -0,0 +1,63 @@
+/*
+ * ST Clock Domain
+ *
+ * Copyright (C) 2015 STMicroelectronics – All Rights Reserved
+ *
+ * Author: Lee Jones <lee.jones@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/clk-private.h>
+#include <linux/clk-provider.h>
+#include <linux/of_address.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+
+static void st_clk_domain_hog_clock(struct platform_device *pdev, int index)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct clk *clk;
+	int ret;
+
+	clk = of_clk_get(np, index);
+	if (IS_ERR(clk)) {
+		dev_warn(&pdev->dev, "Failed get clock %s[%d]: %li\n",
+			 np->full_name, index, PTR_ERR(clk));
+		return;
+	}
+
+	ret = clk_prepare_enable(clk);
+	if (ret)
+		dev_warn(&pdev->dev, "Failed to enable clock: %s\n", clk->name);
+}
+
+static int st_clk_domain_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	int nclks, i;
+
+	nclks = of_count_phandle_with_args(np, "clocks", "#clock-cells");
+
+	for (i = 0; i < nclks; i++)
+		st_clk_domain_hog_clock(pdev, i);
+
+	return 0;
+}
+
+static const struct of_device_id st_clk_domain_match[] = {
+	{ .compatible = "st,clk-domain" },
+	{ },
+};
+
+static struct platform_driver st_clk_domain_driver = {
+	.probe = st_clk_domain_probe,
+	.driver = {
+		.name = "st-clk-domain",
+		.of_match_table = st_clk_domain_match,
+	},
+};
+module_platform_driver(st_clk_domain_driver);
-- 
1.9.1

