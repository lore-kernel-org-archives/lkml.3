Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3AaHQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:16:16 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:33588 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3AaHQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:16:13 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: sachin.kamat@linaro.org, Vinod Koul <vinod.koul@intel.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/1] dma: pl330: Convert to devm_ioremap_resource()
Date: Thu, 31 Jan 2013 12:37:04 +0530
Message-Id: <1359616024-11640-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
This change is based against linux-next tree (20130128).
This change however introduces the followign sparse warning:
drivers/dma/pl330.c:2883:22: warning: incorrect type in argument 1 (different address spaces)
drivers/dma/pl330.c:2883:22:    expected void const *ptr
drivers/dma/pl330.c:2883:22:    got void [noderef] <asn:2>*base
drivers/dma/pl330.c:2884:34: warning: incorrect type in argument 1 (different address spaces)
drivers/dma/pl330.c:2884:34:    expected void const *ptr
drivers/dma/pl330.c:2884:34:    got void [noderef] <asn:2>*base
---
 drivers/dma/pl330.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 316a43e..142fe4d 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -25,6 +25,7 @@
 #include <linux/amba/pl330.h>
 #include <linux/scatterlist.h>
 #include <linux/of.h>
+#include <linux/err.h>
 
 #include "dmaengine.h"
 #define PL330_MAX_CHAN		8
@@ -2878,9 +2879,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	pi->mcbufsz = pdat ? pdat->mcbuf_sz : 0;
 
 	res = &adev->res;
-	pi->base = devm_request_and_ioremap(&adev->dev, res);
-	if (!pi->base)
-		return -ENXIO;
+	pi->base = devm_ioremap_resource(&adev->dev, res);
+	if (IS_ERR(pi->base))
+		return PTR_ERR(pi->base);
 
 	amba_set_drvdata(adev, pdmac);
 
-- 
1.7.4.1

