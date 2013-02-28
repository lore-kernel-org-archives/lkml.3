Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3B1A6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 19:58:25 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:36710 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab3B1A6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 19:58:24 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 2/2] dma: of: allow for non-existent #dma-cells property
Date: Wed, 27 Feb 2013 18:57:58 -0600
Message-Id: <1362013078-2213-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362013078-2213-1-git-send-email-robherring2@gmail.com>
References: <1362013078-2213-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Allow the #dma-cells property to be optional and default to 0. This fixes
a crash on Calxed highbank which has no clients and no #dma-cells property.

Also, the error check was pointless as be32_to_cpup causes a NULL ptr error
first before we get to the error check.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/dma/of-dma.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 69d04d2..e97a062 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -92,7 +92,7 @@ int of_dma_controller_register(struct device_node *np,
 				void *data)
 {
 	struct of_dma	*ofdma;
-	int		nbcells;
+	int		nbcells = 0;
 
 	if (!np || !of_dma_xlate) {
 		pr_err("%s: not enough information provided\n", __func__);
@@ -103,13 +103,7 @@ int of_dma_controller_register(struct device_node *np,
 	if (!ofdma)
 		return -ENOMEM;
 
-	nbcells = be32_to_cpup(of_get_property(np, "#dma-cells", NULL));
-	if (!nbcells) {
-		pr_err("%s: #dma-cells property is missing or invalid\n",
-		       __func__);
-		kfree(ofdma);
-		return -EINVAL;
-	}
+        of_property_read_u32(np, "#dma-cells", &nbcells);
 
 	ofdma->of_node = np;
 	ofdma->of_dma_nbcells = nbcells;
-- 
1.7.10.4

