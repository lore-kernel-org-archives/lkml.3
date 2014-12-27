Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaL0Nh4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 08:37:56 -0500
Received: from www.osadl.org ([62.245.132.105]:59631 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaL0Nhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 08:37:52 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Yao Yuan <yao.yuan@freescale.com>, Fugang Duan <B38611@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Kaushal Butala <kaushalkernelmailinglist@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH v2 -next] i2c: imx: fix handling of wait_for_completion_timeout result
Date: Sat, 27 Dec 2014 08:33:53 -0500
Message-Id: <1419687233-10498-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_for_completion_timeout does not return negative values so 
"result" handling here should be simplified to cover the actually
possible cases only.

patch was only compile tested for imx_v6_v7_defconfig 

V2 spellchecked this time and proper labeling as 
   suggested by Sedat Dilek <sedat.dilek@gmail.com>

patch is against linux-next 3.19.0-rc1 -next-20141226 

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

