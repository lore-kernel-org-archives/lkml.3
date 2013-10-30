Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab3J3FF4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 01:05:56 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57724 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3J3FFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 01:05:54 -0400
From: Rob Herring <robherring2@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: stefano.stabellini@eu.citrix.com, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] of: set dma_mask to point to coherent_dma_mask
Date: Wed, 30 Oct 2013 00:05:22 -0500
Message-Id: <1383109522-6879-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Platform devices created by DT code don't initialize dma_mask pointer to
anything. Set it to coherent_dma_mask by default if the architecture
code has not set it.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
I think this is at least part of what is needed to fix dma_mask issue
raised by Stefano [1]. Things should work AFAICT with just this, but
I suppose the xgmac driver needs to set the mask as well (not relying
on the default), but some pointing the dma_mask to a valid value is
needed first.

Rob

[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg528236.html

 drivers/of/platform.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index f6dcde2..fce088e 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -215,6 +215,8 @@ static struct platform_device *of_platform_device_create_pdata(
 	dev->archdata.dma_mask = 0xffffffffUL;
 #endif
 	dev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+	if (!dev->dev.dma_mask)
+		dev->dev.dma_mask = &dev->dev.coherent_dma_mask;
 	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
 
-- 
1.8.1.2

