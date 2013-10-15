Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189Ab3JONpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:45:10 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:41199 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758799Ab3JONpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:08 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH] of: Fix dereferencing node name in debug output to be safe
Date: Tue, 15 Oct 2013 14:44:32 +0100
Message-Id: <1381844672-24520-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several locations in the of_address and of_irq code dereference the
full_name parameter from a device_node pointer without checking if the
pointer is valid.  This patch switches to use of_node_full_name() which
always checks the pointer.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/address.c | 6 +++---
 drivers/of/irq.c     | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index 556a7fb..27224c0 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -489,7 +489,7 @@ static u64 __of_translate_address(struct device_node *dev,
 	int na, ns, pna, pns;
 	u64 result = OF_BAD_ADDR;
 
-	pr_debug("OF: ** translation for device %s **\n", dev->full_name);
+	pr_debug("OF: ** translation for device %s **\n", of_node_full_name(dev));
 
 	/* Increase refcount at current level */
 	of_node_get(dev);
@@ -504,13 +504,13 @@ static u64 __of_translate_address(struct device_node *dev,
 	bus->count_cells(dev, &na, &ns);
 	if (!OF_CHECK_COUNTS(na, ns)) {
 		printk(KERN_ERR "prom_parse: Bad cell count for %s\n",
-		       dev->full_name);
+		       of_node_full_name(dev));
 		goto bail;
 	}
 	memcpy(addr, in_addr, na * 4);
 
 	pr_debug("OF: bus is %s (na=%d, ns=%d) on %s\n",
-	    bus->name, na, ns, parent->full_name);
+	    bus->name, na, ns, of_node_full_name(parent));
 	of_dump_addr("OF: translating address:", addr, na);
 
 	/* Translate */
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 1752988..f5fa5d8 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -102,7 +102,7 @@ int of_irq_map_raw(struct device_node *parent, const __be32 *intspec,
 	int imaplen, match, i;
 
 	pr_debug("of_irq_map_raw: par=%s,intspec=[0x%08x 0x%08x...],ointsize=%d\n",
-		 parent->full_name, be32_to_cpup(intspec),
+		 of_node_full_name(parent), be32_to_cpup(intspec),
 		 be32_to_cpup(intspec + 1), ointsize);
 
 	ipar = of_node_get(parent);
@@ -126,7 +126,7 @@ int of_irq_map_raw(struct device_node *parent, const __be32 *intspec,
 		goto fail;
 	}
 
-	pr_debug("of_irq_map_raw: ipar=%s, size=%d\n", ipar->full_name, intsize);
+	pr_debug("of_irq_map_raw: ipar=%s, size=%d\n", of_node_full_name(ipar), intsize);
 
 	if (ointsize != intsize)
 		return -EINVAL;
@@ -287,7 +287,7 @@ int of_irq_map_one(struct device_node *device, int index, struct of_irq *out_irq
 	u32 intsize, intlen;
 	int res = -EINVAL;
 
-	pr_debug("of_irq_map_one: dev=%s, index=%d\n", device->full_name, index);
+	pr_debug("of_irq_map_one: dev=%s, index=%d\n", of_node_full_name(device), index);
 
 	/* OldWorld mac stuff is "special", handle out of line */
 	if (of_irq_workarounds & OF_IMAP_OLDWORLD_MAC)
@@ -355,7 +355,7 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
 
 		r->start = r->end = irq;
 		r->flags = IORESOURCE_IRQ;
-		r->name = name ? name : dev->full_name;
+		r->name = name ? name : of_node_full_name(dev);
 	}
 
 	return irq;
-- 
1.8.1.2

