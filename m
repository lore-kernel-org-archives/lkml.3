Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaGJN3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 09:29:54 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:32873 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaGJN3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 09:29:38 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] spi: core: Fix check for dma_map_sg() failures
Date: Thu, 10 Jul 2014 15:29:32 +0200
Message-Id: <1404998973-19425-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

According to Documentation/DMA-API.txt, dma_map_sg() returns 0 on failure.
As spi_map_buf() returns an error code, convert zero into -ENOMEM.
Keep the existing check for negative numbers just in case.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/spi/spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 3a3245dd64ed..3aac0e885cd9 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -617,6 +617,8 @@ static int spi_map_buf(struct spi_master *master, struct device *dev,
 	}
 
 	ret = dma_map_sg(dev, sgt->sgl, sgt->nents, dir);
+	if (!ret)
+		ret = -ENOMEM;
 	if (ret < 0) {
 		sg_free_table(sgt);
 		return ret;
-- 
1.9.1

