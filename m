Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab3DVIeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:34:20 -0400
Received: from smtp-out-209.synserver.de ([212.40.185.209]:1076 "EHLO
	smtp-out-209.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab3DVIeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:34:19 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15115
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2] dma: of: Remove restriction that #dma-cells can't be 0
Date: Mon, 22 Apr 2013 10:33:32 +0200
Message-Id: <1366619613-30639-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no sensible reason why #dma-cells shouldn't be allowed to be 0. It is
completely up to the DMA controller how many additional parameters, besides the
phandle, it needs to identify a channel. E.g. for DMA controller with only one
channel or for DMA controllers which don't have a restriction on which channel
can be used for which peripheral it completely legitimate to not require any
additional parameters.

Also fixes the following warning:
	drivers/dma/of-dma.c: In function 'of_dma_controller_register':
	drivers/dma/of-dma.c:67:7: warning: 'nbcells' may be used uninitialized in this function

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/of-dma.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 7aa0864..268cc8a 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -64,7 +64,6 @@ int of_dma_controller_register(struct device_node *np,
 				void *data)
 {
 	struct of_dma	*ofdma;
-	int		nbcells;
 	const __be32	*prop;
 
 	if (!np || !of_dma_xlate) {
@@ -77,18 +76,16 @@ int of_dma_controller_register(struct device_node *np,
 		return -ENOMEM;
 
 	prop = of_get_property(np, "#dma-cells", NULL);
-	if (prop)
-		nbcells = be32_to_cpup(prop);
-
-	if (!prop || !nbcells) {
-		pr_err("%s: #dma-cells property is missing or invalid\n",
+	if (!prop) {
+		pr_err("%s: #dma-cells property is missing\n",
 		       __func__);
 		kfree(ofdma);
 		return -EINVAL;
 	}
 
+
 	ofdma->of_node = np;
-	ofdma->of_dma_nbcells = nbcells;
+	ofdma->of_dma_nbcells = be32_to_cpup(prop);
 	ofdma->of_dma_xlate = of_dma_xlate;
 	ofdma->of_dma_data = data;
 
-- 
1.8.0

