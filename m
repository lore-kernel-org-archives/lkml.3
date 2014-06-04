Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaFDLhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:37:07 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58908 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbaFDLgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:09 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 08/21] i2c: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:08 +0400
Message-Id: <1401880402-30091-9-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/i2c/busses/i2c-mpc.c     |   12 ++++--------
 drivers/i2c/busses/i2c-mv64xxx.c |    2 +-
 drivers/i2c/busses/i2c-st.c      |    6 +++---
 drivers/i2c/busses/i2c-wmt.c     |    6 +++---
 4 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index f539163..f8e45a6 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -647,9 +647,11 @@ static int fsl_i2c_probe(struct platform_device *op)
 		goto fail_map;
 	}
 
-	i2c->irq = irq_of_parse_and_map(op->dev.of_node, 0);
+	i2c->irq = devm_irq_of_parse_and_map(&op->dev, op->dev.of_node, 0);
+	if (i2c->irq < 0)
+		return i2c->irq;
 	if (i2c->irq) { /* no i2c->irq implies polling */
-		result = request_irq(i2c->irq, mpc_i2c_isr,
+		result = devm_request_irq(&op->dev, i2c->irq, mpc_i2c_isr,
 				     IRQF_SHARED, "i2c-mpc", i2c);
 		if (result < 0) {
 			dev_err(i2c->dev, "failed to attach interrupt\n");
@@ -719,9 +721,7 @@ static int fsl_i2c_probe(struct platform_device *op)
  fail_add:
 	if (i2c->clk_per)
 		clk_disable_unprepare(i2c->clk_per);
-	free_irq(i2c->irq, i2c);
  fail_request:
-	irq_dispose_mapping(i2c->irq);
 	iounmap(i2c->base);
  fail_map:
 	kfree(i2c);
@@ -737,10 +737,6 @@ static int fsl_i2c_remove(struct platform_device *op)
 	if (i2c->clk_per)
 		clk_disable_unprepare(i2c->clk_per);
 
-	if (i2c->irq)
-		free_irq(i2c->irq, i2c);
-
-	irq_dispose_mapping(i2c->irq);
 	iounmap(i2c->base);
 	kfree(i2c);
 	return 0;
diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
index 540ea69..65f95d0 100644
--- a/drivers/i2c/busses/i2c-mv64xxx.c
+++ b/drivers/i2c/busses/i2c-mv64xxx.c
@@ -755,7 +755,7 @@ mv64xxx_of_config(struct mv64xxx_i2c_data *drv_data,
 		rc = -EINVAL;
 		goto out;
 	}
-	drv_data->irq = irq_of_parse_and_map(np, 0);
+	drv_data->irq = devm_irq_of_parse_and_map(dev, np, 0);
 
 	drv_data->rstc = devm_reset_control_get_optional(dev, NULL);
 	if (IS_ERR(drv_data->rstc)) {
diff --git a/drivers/i2c/busses/i2c-st.c b/drivers/i2c/busses/i2c-st.c
index 8720161..f2d0017 100644
--- a/drivers/i2c/busses/i2c-st.c
+++ b/drivers/i2c/busses/i2c-st.c
@@ -778,10 +778,10 @@ static int st_i2c_probe(struct platform_device *pdev)
 	if (IS_ERR(i2c_dev->base))
 		return PTR_ERR(i2c_dev->base);
 
-	i2c_dev->irq = irq_of_parse_and_map(np, 0);
-	if (!i2c_dev->irq) {
+	i2c_dev->irq = devm_irq_of_parse_and_map(&pdev->dev, np, 0);
+	if (i2c_dev->irq <= 0) {
 		dev_err(&pdev->dev, "IRQ missing or invalid\n");
-		return -EINVAL;
+		return i2c_dev->irq ? i2c_dev->irq : -EINVAL;
 	}
 
 	i2c_dev->clk = of_clk_get_by_name(np, "ssc");
diff --git a/drivers/i2c/busses/i2c-wmt.c b/drivers/i2c/busses/i2c-wmt.c
index 2c8a3e4..6082b93 100644
--- a/drivers/i2c/busses/i2c-wmt.c
+++ b/drivers/i2c/busses/i2c-wmt.c
@@ -389,10 +389,10 @@ static int wmt_i2c_probe(struct platform_device *pdev)
 	if (IS_ERR(i2c_dev->base))
 		return PTR_ERR(i2c_dev->base);
 
-	i2c_dev->irq = irq_of_parse_and_map(np, 0);
-	if (!i2c_dev->irq) {
+	i2c_dev->irq = devm_irq_of_parse_and_map(&pdev->dev, np, 0);
+	if (i2c_dev->irq <= 0) {
 		dev_err(&pdev->dev, "irq missing or invalid\n");
-		return -EINVAL;
+		return i2c_dev->irq ? i2c_dev->irq : -EINVAL;
 	}
 
 	i2c_dev->clk = of_clk_get(np, 0);
-- 
1.7.10.4

