Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3DVIeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:34:21 -0400
Received: from smtp-out-209.synserver.de ([212.40.185.209]:1081 "EHLO
	smtp-out-209.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3DVIeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:34:19 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15115
From: Lars-Peter Clausen <lars@metafoo.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] dma: of: Remove check on always true condition
Date: Mon, 22 Apr 2013 10:33:33 +0200
Message-Id: <1366619613-30639-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1366619613-30639-1-git-send-email-lars@metafoo.de>
References: <1366619613-30639-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both of_dma_nbcells field of the of_dma_controller and the args_count field of
the dma_spec are initialized by parsing the #dma-cells attribute of their device
tree node. So if the device tree nodes of a DMA controller and the dma_spec
match this means that of_dma_nbcells and args_count will also match. So the
second test in the of_dma_find_controller loop is redundant because given the
first test yields true the second test will also yield true. So we can safely
remove the test whether of_dma_nbcells matches args_count. Since this was the
last user of the of_dma_nbcells field we can remove it altogether.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/dma/of-dma.c   | 14 +-------------
 include/linux/of_dma.h |  1 -
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
index 268cc8a..75334bd 100644
--- a/drivers/dma/of-dma.c
+++ b/drivers/dma/of-dma.c
@@ -35,8 +35,7 @@ static struct of_dma *of_dma_find_controller(struct of_phandle_args *dma_spec)
 	struct of_dma *ofdma;
 
 	list_for_each_entry(ofdma, &of_dma_list, of_dma_controllers)
-		if ((ofdma->of_node == dma_spec->np) &&
-		    (ofdma->of_dma_nbcells == dma_spec->args_count))
+		if (ofdma->of_node == dma_spec->np)
 			return ofdma;
 
 	pr_debug("%s: can't find DMA controller %s\n", __func__,
@@ -64,7 +63,6 @@ int of_dma_controller_register(struct device_node *np,
 				void *data)
 {
 	struct of_dma	*ofdma;
-	const __be32	*prop;
 
 	if (!np || !of_dma_xlate) {
 		pr_err("%s: not enough information provided\n", __func__);
@@ -75,17 +73,7 @@ int of_dma_controller_register(struct device_node *np,
 	if (!ofdma)
 		return -ENOMEM;
 
-	prop = of_get_property(np, "#dma-cells", NULL);
-	if (!prop) {
-		pr_err("%s: #dma-cells property is missing\n",
-		       __func__);
-		kfree(ofdma);
-		return -EINVAL;
-	}
-
-
 	ofdma->of_node = np;
-	ofdma->of_dma_nbcells = be32_to_cpup(prop);
 	ofdma->of_dma_xlate = of_dma_xlate;
 	ofdma->of_dma_data = data;
 
diff --git a/include/linux/of_dma.h b/include/linux/of_dma.h
index 364dda7..ae36298 100644
--- a/include/linux/of_dma.h
+++ b/include/linux/of_dma.h
@@ -21,7 +21,6 @@ struct device_node;
 struct of_dma {
 	struct list_head	of_dma_controllers;
 	struct device_node	*of_node;
-	int			of_dma_nbcells;
 	struct dma_chan		*(*of_dma_xlate)
 				(struct of_phandle_args *, struct of_dma *);
 	void			*of_dma_data;
-- 
1.8.0

