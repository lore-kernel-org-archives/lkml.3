Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3ETTRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:17:43 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:20503
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755407Ab3ETTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:17:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <festevam@gmail.com>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: of-dma: Fix "'nbcells' may be used uninitialized" warning
Date: Mon, 20 May 2013 16:17:42 -0300
Message-ID: <1369077462-19315-1-git-send-email-fabio.estevam@freescale.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rearrange the code a bit so that we can get rid of the following build warning:

drivers/dma/of-dma.c:83:15: warning: 'nbcells' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/of-dma.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 7aa0864..107e820 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -77,15 +77,14 @@ int of_dma_controller_register(struct device_node *np,
 		return -ENOMEM;
 
 	prop = of_get_property(np, "#dma-cells", NULL);
-	if (prop)
-		nbcells = be32_to_cpup(prop);
+	if (!prop)
+		goto free;
+
+	nbcells = be32_to_cpup(prop);
 
-	if (!prop || !nbcells) {
-		pr_err("%s: #dma-cells property is missing or invalid\n",
-		       __func__);
-		kfree(ofdma);
-		return -EINVAL;
-	}
+
+	if (!nbcells)
+		goto free;
 
 	ofdma->of_node = np;
 	ofdma->of_dma_nbcells = nbcells;
@@ -98,6 +97,11 @@ int of_dma_controller_register(struct device_node *np,
 	mutex_unlock(&of_dma_lock);
 
 	return 0;
+
+free:
+	pr_err("%s: #dma-cells property is missing or invalid\n", __func__);
+	kfree(ofdma);
+	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(of_dma_controller_register);
 
-- 
1.8.1.2


