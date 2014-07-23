Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758643AbaGWXpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:45:38 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33485 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610AbaGWXol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:44:41 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, Nathan Fontenot <nfont@austin.ibm.com>,
        Tyrel Datwyler <turtle.in.the.kernel@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 08/10] of: Move dynamic node fixups out of powerpc and into common code
Date: Wed, 23 Jul 2014 17:44:22 -0600
Message-Id: <1406159064-21366-9-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
References: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PowerPC does an odd thing with dynamic nodes. It uses a notifier to
catch new node additions and set some of the values like name and type.
This makes no sense since that same code can be put directly into
of_attach_node(). Besides, all dynamic node users need this, not just
powerpc. Fix this problem by moving the logic out of arch/powerpc and
into drivers/of/dynamic.c.

It is also important to remove this notifier because we want to move the
firing of notifiers from before the tree is modified to after so that
the receiver gets a consistent view of the tree, but that is
incompatible with notifiers that modify the node.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/kernel/prom.c | 70 ----------------------------------------------
 drivers/of/base.c          |  4 +--
 drivers/of/dynamic.c       | 13 +++++++++
 drivers/of/of_private.h    |  2 ++
 4 files changed, 17 insertions(+), 72 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index b694b0730971..9e8d8a880d6f 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -821,76 +821,6 @@ int cpu_to_chip_id(int cpu)
 }
 EXPORT_SYMBOL(cpu_to_chip_id);
 
-#ifdef CONFIG_PPC_PSERIES
-/*
- * Fix up the uninitialized fields in a new device node:
- * name, type and pci-specific fields
- */
-
-static int of_finish_dynamic_node(struct device_node *node)
-{
-	struct device_node *parent = of_get_parent(node);
-	int err = 0;
-	const phandle *ibm_phandle;
-
-	node->name = of_get_property(node, "name", NULL);
-	node->type = of_get_property(node, "device_type", NULL);
-
-	if (!node->name)
-		node->name = "<NULL>";
-	if (!node->type)
-		node->type = "<NULL>";
-
-	if (!parent) {
-		err = -ENODEV;
-		goto out;
-	}
-
-	/* We don't support that function on PowerMac, at least
-	 * not yet
-	 */
-	if (machine_is(powermac))
-		return -ENODEV;
-
-	/* fix up new node's phandle field */
-	if ((ibm_phandle = of_get_property(node, "ibm,phandle", NULL)))
-		node->phandle = *ibm_phandle;
-
-out:
-	of_node_put(parent);
-	return err;
-}
-
-static int prom_reconfig_notifier(struct notifier_block *nb,
-				  unsigned long action, void *node)
-{
-	int err;
-
-	switch (action) {
-	case OF_RECONFIG_ATTACH_NODE:
-		err = of_finish_dynamic_node(node);
-		if (err < 0)
-			printk(KERN_ERR "finish_node returned %d\n", err);
-		break;
-	default:
-		err = 0;
-		break;
-	}
-	return notifier_from_errno(err);
-}
-
-static struct notifier_block prom_reconfig_nb = {
-	.notifier_call = prom_reconfig_notifier,
-	.priority = 10, /* This one needs to run first */
-};
-
-static int __init prom_reconfig_setup(void)
-{
-	return of_reconfig_notifier_register(&prom_reconfig_nb);
-}
-__initcall(prom_reconfig_setup);
-#endif
-
 bool arch_match_cpu_phys_id(int cpu, u64 phys_id)
 {
 	return (int)phys_id == get_hard_smp_processor_id(cpu);
diff --git a/drivers/of/base.c b/drivers/of/base.c
index ad4929cbd876..ededf8e33145 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -266,8 +266,8 @@ EXPORT_SYMBOL(of_find_all_nodes);
  * Find a property with a given name for a given node
  * and return the value.
  */
-static const void *__of_get_property(const struct device_node *np,
-				     const char *name, int *lenp)
+const void *__of_get_property(const struct device_node *np,
+			      const char *name, int *lenp)
 {
 	struct property *pp = __of_find_property(np, name, lenp);
 
diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index b96d83100987..7c020b9a3317 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -98,6 +98,19 @@ int of_property_notify(int action, struct device_node *np,
 
 void __of_attach_node(struct device_node *np)
 {
+	const __be32 *phandle;
+	int sz;
+
+	np->name = __of_get_property(np, "name", NULL) ? : "<NULL>";
+	np->type = __of_get_property(np, "device_type", NULL) ? : "<NULL>";
+
+	phandle = __of_get_property(np, "phandle", &sz);
+	if (!phandle)
+		phandle = __of_get_property(np, "linux,phandle", &sz);
+	if (IS_ENABLED(PPC_PSERIES) && !phandle)
+		phandle = __of_get_property(np, "ibm,phandle", &sz);
+	np->phandle = (phandle && (sz >= 4)) ? be32_to_cpup(phandle) : 0;
+
 	np->child = NULL;
 	np->sibling = np->parent->child;
 	np->allnext = np->parent->allnext;
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 0d99ba8caeed..8129c0e58d70 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -63,6 +63,8 @@ static inline int of_property_notify(int action, struct device_node *np,
 struct property *__of_prop_dup(const struct property *prop, gfp_t allocflags);
 struct device_node *__of_node_alloc(const char *full_name, gfp_t allocflags);
 
+extern const void *__of_get_property(const struct device_node *np,
+				     const char *name, int *lenp);
 extern int __of_add_property(struct device_node *np, struct property *prop);
 extern int __of_add_property_sysfs(struct device_node *np,
 		struct property *prop);
-- 
1.9.1

