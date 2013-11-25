Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab3KYWMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:12:54 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50658 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3KYWMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:12:53 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] regmap: use IS_ERR() to check clk_get() results
Date: Mon, 25 Nov 2013 15:12:47 -0700
Message-Id: <1385417567-7693-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

clk_get() returns an error pointer, or a valid token to pass back to the
clock API. Hence, the result must be checked with IS_ERR(), not by
comparison against NULL.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap-mmio.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/base/regmap/regmap-mmio.c b/drivers/base/regmap/regmap-mmio.c
index 98745dd77e8c..81f977510775 100644
--- a/drivers/base/regmap/regmap-mmio.c
+++ b/drivers/base/regmap/regmap-mmio.c
@@ -40,7 +40,7 @@ static int regmap_mmio_gather_write(void *context,
 
 	BUG_ON(reg_size != 4);
 
-	if (ctx->clk) {
+	if (!IS_ERR(ctx->clk)) {
 		ret = clk_enable(ctx->clk);
 		if (ret < 0)
 			return ret;
@@ -73,7 +73,7 @@ static int regmap_mmio_gather_write(void *context,
 		offset += ctx->val_bytes;
 	}
 
-	if (ctx->clk)
+	if (!IS_ERR(ctx->clk))
 		clk_disable(ctx->clk);
 
 	return 0;
@@ -96,7 +96,7 @@ static int regmap_mmio_read(void *context,
 
 	BUG_ON(reg_size != 4);
 
-	if (ctx->clk) {
+	if (!IS_ERR(ctx->clk)) {
 		ret = clk_enable(ctx->clk);
 		if (ret < 0)
 			return ret;
@@ -129,7 +129,7 @@ static int regmap_mmio_read(void *context,
 		offset += ctx->val_bytes;
 	}
 
-	if (ctx->clk)
+	if (!IS_ERR(ctx->clk))
 		clk_disable(ctx->clk);
 
 	return 0;
@@ -139,7 +139,7 @@ static void regmap_mmio_free_context(void *context)
 {
 	struct regmap_mmio_context *ctx = context;
 
-	if (ctx->clk) {
+	if (!IS_ERR(ctx->clk)) {
 		clk_unprepare(ctx->clk);
 		clk_put(ctx->clk);
 	}
@@ -209,6 +209,7 @@ static struct regmap_mmio_context *regmap_mmio_gen_context(struct device *dev,
 
 	ctx->regs = regs;
 	ctx->val_bytes = config->val_bits / 8;
+	ctx->clk = ERR_PTR(-ENODEV);
 
 	if (clk_id == NULL)
 		return ctx;
-- 
1.8.1.5

