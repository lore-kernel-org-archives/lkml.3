Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3BCALN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 19:11:13 -0500
Received: from mout.gmx.net ([212.227.15.19]:62285 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664Ab3BCALM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 19:11:12 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/+jJFCFSz+jOG9DmvxGFu7rmpyE2R1JHkLHNAnHj
	eeLnLFSY1D+zpd
From: Peter Huewe <peterhuewe@gmx.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] i2c/i2c-mxs: use devm_request_and_ioremap
Date: Sun,  3 Feb 2013 01:14:57 +0100
Message-Id: <1359850497-927-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to devm_request_mem_region followed by a call to
dev_ioremap_nocache with devm_request_and_ioremap which does the same.
And since res_size isn't needed anymore we can remove it as well.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/i2c/busses/i2c-mxs.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index d6abaf2..4ca92b6 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -439,7 +439,6 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	struct i2c_adapter *adap;
 	struct pinctrl *pinctrl;
 	struct resource *res;
-	resource_size_t res_size;
 	int err, irq, dmairq;
 	dma_cap_mask_t mask;
 
@@ -458,11 +457,7 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	if (!res || irq < 0 || dmairq < 0)
 		return -ENOENT;
 
-	res_size = resource_size(res);
-	if (!devm_request_mem_region(dev, res->start, res_size, res->name))
-		return -EBUSY;
-
-	i2c->regs = devm_ioremap_nocache(dev, res->start, res_size);
+	i2c->regs = devm_request_and_ioremap(dev, res);
 	if (!i2c->regs)
 		return -EBUSY;
 
-- 
1.7.8.6

