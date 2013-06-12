Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3FLFj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 01:39:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:58983 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3FLFj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 01:39:28 -0400
Message-ID: <1371015544.8250.182.camel@pasglop>
Subject: [PATCH] of: Fix locking vs. interrupts
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Date: Wed, 12 Jun 2013 15:39:04 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OF code uses irqsafe locks everywhere except in a handful of functions
for no obvious reasons. Since the conversion from the old rwlocks, this
now triggers lockdep warnings when used at interrupt time. At least one
driver (ibmvscsi) seems to be doing that from softirq context.

This converts the few non-irqsafe locks into irqsafe ones, making them
consistent with the rest of the code.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <stable@vger.kernel.org> [v3.9+]
---

Note: It's silly to access the device-tree at interrupt time in most cases,
and we should probably fix ibmvscsi, but for the time being, let's fix the
obvious bug. Thomas, this can probably still go into 3.10... If not, I've
CCed stable.

diff --git a/arch/sparc/kernel/prom_common.c b/arch/sparc/kernel/prom_common.c
index 9f20566..79cc0d1 100644
--- a/arch/sparc/kernel/prom_common.c
+++ b/arch/sparc/kernel/prom_common.c
@@ -54,6 +54,7 @@ EXPORT_SYMBOL(of_set_property_mutex);
 int of_set_property(struct device_node *dp, const char *name, void *val, int len)
 {
 	struct property **prevp;
+	unsigned long flags;
 	void *new_val;
 	int err;
 
@@ -64,7 +65,7 @@ int of_set_property(struct device_node *dp, const char *name, void *val, int len
 	err = -ENODEV;
 
 	mutex_lock(&of_set_property_mutex);
-	raw_spin_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	prevp = &dp->properties;
 	while (*prevp) {
 		struct property *prop = *prevp;
@@ -91,7 +92,7 @@ int of_set_property(struct device_node *dp, const char *name, void *val, int len
 		}
 		prevp = &(*prevp)->next;
 	}
-	raw_spin_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	mutex_unlock(&of_set_property_mutex);
 
 	/* XXX Upate procfs if necessary... */
diff --git a/drivers/of/base.c b/drivers/of/base.c
index f53b992..951452c 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -192,14 +192,15 @@ EXPORT_SYMBOL(of_find_property);
 struct device_node *of_find_all_nodes(struct device_node *prev)
 {
 	struct device_node *np;
+	unsigned long flags;
 
-	raw_spin_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	np = prev ? prev->allnext : of_allnodes;
 	for (; np != NULL; np = np->allnext)
 		if (of_node_get(np))
 			break;
 	of_node_put(prev);
-	raw_spin_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_all_nodes);
@@ -421,8 +422,9 @@ struct device_node *of_get_next_available_child(const struct device_node *node,
 	struct device_node *prev)
 {
 	struct device_node *next;
+	unsigned long flags;
 
-	raw_spin_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	next = prev ? prev->sibling : node->child;
 	for (; next; next = next->sibling) {
 		if (!__of_device_is_available(next))
@@ -431,7 +433,7 @@ struct device_node *of_get_next_available_child(const struct device_node *node,
 			break;
 	}
 	of_node_put(prev);
-	raw_spin_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return next;
 }
 EXPORT_SYMBOL(of_get_next_available_child);
@@ -735,13 +737,14 @@ EXPORT_SYMBOL_GPL(of_modalias_node);
 struct device_node *of_find_node_by_phandle(phandle handle)
 {
 	struct device_node *np;
+	unsigned long flags;
 
-	raw_spin_lock(&devtree_lock);
+	raw_spin_lock_irqsave(&devtree_lock, flags);
 	for (np = of_allnodes; np; np = np->allnext)
 		if (np->phandle == handle)
 			break;
 	of_node_get(np);
-	raw_spin_unlock(&devtree_lock);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 	return np;
 }
 EXPORT_SYMBOL(of_find_node_by_phandle);


