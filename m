Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaEGVsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:48:39 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:45290 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaEGVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:48:31 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 4/4] of: kill off of_can_translate_address
Date: Wed,  7 May 2014 16:48:18 -0500
Message-Id: <1399499298-8830-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

of_can_translate_address only checks some conditions for address
translation, but does not check other conditions like having range
properties. The checks it does do are redundant with
__of_address_translate. The only difference is printing a message or
not. Since we only have a single caller that does the full translation
anyway, just remove of_can_translate_address and quiet the error
message.

Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/of/address.c       | 22 +---------------------
 drivers/of/platform.c      |  5 ++---
 include/linux/of_address.h |  1 -
 3 files changed, 3 insertions(+), 25 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index cb4242a..95351b2 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -498,8 +498,7 @@ static u64 __of_translate_address(struct device_node *dev,
 	/* Count address cells & copy address locally */
 	bus->count_cells(dev, &na, &ns);
 	if (!OF_CHECK_COUNTS(na, ns)) {
-		printk(KERN_ERR "prom_parse: Bad cell count for %s\n",
-		       of_node_full_name(dev));
+		pr_debug("OF: Bad cell count for %s\n", of_node_full_name(dev));
 		goto bail;
 	}
 	memcpy(addr, in_addr, na * 4);
@@ -564,25 +563,6 @@ u64 of_translate_dma_address(struct device_node *dev, const __be32 *in_addr)
 }
 EXPORT_SYMBOL(of_translate_dma_address);
 
-bool of_can_translate_address(struct device_node *dev)
-{
-	struct device_node *parent;
-	struct of_bus *bus;
-	int na, ns;
-
-	parent = of_get_parent(dev);
-	if (parent == NULL)
-		return false;
-
-	bus = of_match_bus(parent);
-	bus->count_cells(dev, &na, &ns);
-
-	of_node_put(parent);
-
-	return OF_CHECK_COUNTS(na, ns);
-}
-EXPORT_SYMBOL(of_can_translate_address);
-
 const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
 		    unsigned int *flags)
 {
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index d827ceb..07cfd1b 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -140,9 +140,8 @@ struct platform_device *of_device_alloc(struct device_node *np,
 		return NULL;
 
 	/* count the io and irq resources */
-	if (of_can_translate_address(np))
-		while (of_address_to_resource(np, num_reg, &temp_res) == 0)
-			num_reg++;
+	while (of_address_to_resource(np, num_reg, &temp_res) == 0)
+		num_reg++;
 	num_irq = of_irq_count(np);
 
 	/* Populate the resource table */
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 5f6ed6b..906ca76 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -40,7 +40,6 @@ extern u64 of_translate_dma_address(struct device_node *dev,
 
 #ifdef CONFIG_OF_ADDRESS
 extern u64 of_translate_address(struct device_node *np, const __be32 *addr);
-extern bool of_can_translate_address(struct device_node *dev);
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
 extern struct device_node *of_find_matching_node_by_address(
-- 
1.9.1

