Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaL0Lw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 06:52:57 -0500
Received: from www.osadl.org ([62.245.132.105]:59157 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbaL0Lw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 06:52:56 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Yao Yuan <yao.yuan@freescale.com>, Fugang Duan <B38611@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Kaushal Butala <kaushalkernelmailinglist@gmail.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] fix handling of wait_for_completion_timeout result
Date: Sat, 27 Dec 2014 06:48:50 -0500
Message-Id: <1419680930-9052-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wati_for_completion_timeout does not return negative values so 
"result" handlin here should be simplified to cover the actually
possible cases only.

patch was only compile tested for imx_v6_v7_defconfig 

patch is against 3.19.0-rc1 -next-20141226

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/i2c/busses/i2c-imx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 7f3a9fe..2be7d9d 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -628,9 +628,9 @@ static int i2c_imx_dma_write(struct imx_i2c_struct *i2c_imx,
 	result = wait_for_completion_timeout(
 				&i2c_imx->dma->cmd_complete,
 				msecs_to_jiffies(DMA_TIMEOUT));
-	if (result <= 0) {
+	if (result == 0) {
 		dmaengine_terminate_all(dma->chan_using);
-		return result ?: -ETIMEDOUT;
+		return -ETIMEDOUT;
 	}
 
 	/* Waiting for transfer complete. */
@@ -686,9 +686,9 @@ static int i2c_imx_dma_read(struct imx_i2c_struct *i2c_imx,
 	result = wait_for_completion_timeout(
 				&i2c_imx->dma->cmd_complete,
 				msecs_to_jiffies(DMA_TIMEOUT));
-	if (result <= 0) {
+	if (result == 0) {
 		dmaengine_terminate_all(dma->chan_using);
-		return result ?: -ETIMEDOUT;
+		return -ETIMEDOUT;
 	}
 
 	/* waiting for transfer complete. */
-- 
1.7.10.4

