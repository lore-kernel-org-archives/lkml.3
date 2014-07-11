Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaGKMEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:04:33 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51258 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaGKMEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:04:30 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, mturquette@linaro.org, t.figa@samsung.com,
        trblinux@gmail.com
Subject: [PATCH V2 2/3] clk: samsung: Add API to unregister clocks
Date: Fri, 11 Jul 2014 17:30:34 +0530
Message-Id: <1405080036-6651-3-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405080036-6651-1-git-send-email-tushar.b@samsung.com>
References: <1405080036-6651-1-git-send-email-tushar.b@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added an API to unregister all the clocks defined within a context. This
is helpful in case where the clock is registered through a platform
driver and we want to unregister the clocks during remove callback.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
Changelog:
This is new patch required because of changes to patch 3/3.

 drivers/clk/samsung/clk.c |   19 +++++++++++++++++++
 drivers/clk/samsung/clk.h |    2 ++
 2 files changed, 21 insertions(+)

diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
index 49629c7..b9310b9 100644
--- a/drivers/clk/samsung/clk.c
+++ b/drivers/clk/samsung/clk.c
@@ -83,6 +83,25 @@ struct samsung_clk_provider *__init samsung_clk_init(struct device_node *np,
 	return ctx;
 }
 
+/* API to remove a clock provider */
+void samsung_clk_exit(struct device_node *np, struct samsung_clk_provider *ctx)
+{
+	int i;
+
+	if (np)
+		of_clk_del_provider(np);
+
+	if (!ctx)
+		return;
+
+	for (i = 0; i < ctx->clk_data.clk_num; i++)
+		if (!IS_ERR(ctx->clk_data.clks[i]))
+			clk_unregister(ctx->clk_data.clks[i]);
+
+	kfree(ctx->clk_data.clks);
+	kfree(ctx);
+}
+
 /* add a clock instance to the clock lookup table used for dt based lookup */
 void samsung_clk_add_lookup(struct samsung_clk_provider *ctx, struct clk *clk,
 				unsigned int id)
diff --git a/drivers/clk/samsung/clk.h b/drivers/clk/samsung/clk.h
index 9693b80..8ecc85a 100644
--- a/drivers/clk/samsung/clk.h
+++ b/drivers/clk/samsung/clk.h
@@ -327,6 +327,8 @@ struct samsung_pll_clock {
 extern struct samsung_clk_provider *__init samsung_clk_init(
 			struct device_node *np, void __iomem *base,
 			unsigned long nr_clks);
+extern void samsung_clk_exit(struct device_node *np,
+			struct samsung_clk_provider *ctx);
 extern void __init samsung_clk_of_register_fixed_ext(
 			struct samsung_clk_provider *ctx,
 			struct samsung_fixed_rate_clock *fixed_rate_clk,
-- 
1.7.9.5

