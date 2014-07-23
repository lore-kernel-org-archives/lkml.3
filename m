Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967AbaGWXos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:44:48 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:42902 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624AbaGWXom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:44:42 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, Nathan Fontenot <nfont@austin.ibm.com>,
        Tyrel Datwyler <turtle.in.the.kernel@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 09/10] of: Reorder device tree changes and notifiers
Date: Wed, 23 Jul 2014 17:44:23 -0600
Message-Id: <1406159064-21366-10-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
References: <1406159064-21366-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, devicetree reconfig notifiers get emitted before the change
is applied to the tree, but that behaviour is problematic if the
receiver wants the determine the new state of the tree. The current
users don't care, but the changeset code to follow will be making
multiple changes at once. Reorder notifiers to get emitted after the
change has been applied to the tree so that callbacks see the new tree
state.

At the same time, fixup the existing callbacks to expect the new order.
There are a few callbacks that compare the old and new values of a
changed property. Put both property pointers into the of_prop_reconfig
structure.

The current notifiers also allow the notifier callback to fail and
cancel the change to the tree, but that feature isn't actually used.
It really isn't valid to ignore a tree modification provided by firmware
anyway, so remove the ability to cancel a change to the tree.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
---
 arch/powerpc/platforms/pseries/hotplug-memory.c |  2 +-
 drivers/crypto/nx/nx-842.c                      | 30 +++++++------------------
 drivers/of/base.c                               | 21 ++++++++---------
 drivers/of/dynamic.c                            | 18 +++++++--------
 drivers/of/of_private.h                         |  4 ++--
 include/linux/of.h                              |  1 +
 6 files changed, 29 insertions(+), 47 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 7995135170a3..ac01e188faef 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -194,7 +194,7 @@ static int pseries_update_drconf_memory(struct of_prop_reconfig *pr)
 	if (!memblock_size)
 		return -EINVAL;
 
-	p = (u32 *)of_get_property(pr->dn, "ibm,dynamic-memory", NULL);
+	p = (u32 *) pr->old_prop->value;
 	if (!p)
 		return -EINVAL;
 
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 502edf0a2933..c897c3a5ee17 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -936,28 +936,14 @@ static int nx842_OF_upd(struct property *new_prop)
 		goto error_out;
 	}
 
-	/* Set ptr to new property if provided */
-	if (new_prop) {
-		/* Single property */
-		if (!strncmp(new_prop->name, "status", new_prop->length)) {
-			status = new_prop;
-
-		} else if (!strncmp(new_prop->name, "ibm,max-sg-len",
-					new_prop->length)) {
-			maxsglen = new_prop;
-
-		} else if (!strncmp(new_prop->name, "ibm,max-sync-cop",
-					new_prop->length)) {
-			maxsyncop = new_prop;
-
-		} else {
-			/*
-			 * Skip the update, the property being updated
-			 * has no impact.
-			 */
-			goto out;
-		}
-	}
+	/*
+	 * If this is a property update, there are only certain properties that
+	 * we care about. Bail if it isn't in the below list
+	 */
+	if (new_prop && (strncmp(new_prop->name, "status", new_prop->length) ||
+		         strncmp(new_prop->name, "ibm,max-sg-len", new_prop->length) ||
+		         strncmp(new_prop->name, "ibm,max-sync-cop", new_prop->length)))
+		goto out;
 
 	/* Perform property updates */
 	ret = nx842_OF_upd_status(new_devdata, status);
diff --git a/drivers/of/base.c b/drivers/of/base.c
index ededf8e33145..a7ad1013edfa 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1674,10 +1674,6 @@ int of_add_property(struct device_node *np, struct property *prop)
 	unsigned long flags;
 	int rc;
 
-	rc = of_property_notify(OF_RECONFIG_ADD_PROPERTY, np, prop);
-	if (rc)
-		return rc;
-
 	mutex_lock(&of_mutex);
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
@@ -1689,6 +1685,9 @@ int of_add_property(struct device_node *np, struct property *prop)
 
 	mutex_unlock(&of_mutex);
 
+	if (!rc)
+		of_property_notify(OF_RECONFIG_ADD_PROPERTY, np, prop, NULL);
+
 	return rc;
 }
 
@@ -1731,10 +1730,6 @@ int of_remove_property(struct device_node *np, struct property *prop)
 	unsigned long flags;
 	int rc;
 
-	rc = of_property_notify(OF_RECONFIG_REMOVE_PROPERTY, np, prop);
-	if (rc)
-		return rc;
-
 	mutex_lock(&of_mutex);
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
@@ -1746,6 +1741,9 @@ int of_remove_property(struct device_node *np, struct property *prop)
 
 	mutex_unlock(&of_mutex);
 
+	if (!rc)
+		of_property_notify(OF_RECONFIG_REMOVE_PROPERTY, np, prop, NULL);
+
 	return rc;
 }
 
@@ -1805,10 +1803,6 @@ int of_update_property(struct device_node *np, struct property *newprop)
 	if (!newprop->name)
 		return -EINVAL;
 
-	rc = of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop);
-	if (rc)
-		return rc;
-
 	mutex_lock(&of_mutex);
 
 	raw_spin_lock_irqsave(&devtree_lock, flags);
@@ -1820,6 +1814,9 @@ int of_update_property(struct device_node *np, struct property *newprop)
 
 	mutex_unlock(&of_mutex);
 
+	if (!rc)
+		of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop, oldprop);
+
 	return rc;
 }
 
diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 7c020b9a3317..7bd5501736a6 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -83,7 +83,7 @@ int of_reconfig_notify(unsigned long action, void *p)
 }
 
 int of_property_notify(int action, struct device_node *np,
-		       struct property *prop)
+		       struct property *prop, struct property *oldprop)
 {
 	struct of_prop_reconfig pr;
 
@@ -93,6 +93,7 @@ int of_property_notify(int action, struct device_node *np,
 
 	pr.dn = np;
 	pr.prop = prop;
+	pr.old_prop = oldprop;
 	return of_reconfig_notify(action, &pr);
 }
 
@@ -125,11 +126,6 @@ void __of_attach_node(struct device_node *np)
 int of_attach_node(struct device_node *np)
 {
 	unsigned long flags;
-	int rc;
-
-	rc = of_reconfig_notify(OF_RECONFIG_ATTACH_NODE, np);
-	if (rc)
-		return rc;
 
 	mutex_lock(&of_mutex);
 	raw_spin_lock_irqsave(&devtree_lock, flags);
@@ -138,6 +134,9 @@ int of_attach_node(struct device_node *np)
 
 	__of_attach_node_sysfs(np);
 	mutex_unlock(&of_mutex);
+
+	of_reconfig_notify(OF_RECONFIG_ATTACH_NODE, np);
+
 	return 0;
 }
 
@@ -188,10 +187,6 @@ int of_detach_node(struct device_node *np)
 	unsigned long flags;
 	int rc = 0;
 
-	rc = of_reconfig_notify(OF_RECONFIG_DETACH_NODE, np);
-	if (rc)
-		return rc;
-
 	mutex_lock(&of_mutex);
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	__of_detach_node(np);
@@ -199,6 +194,9 @@ int of_detach_node(struct device_node *np)
 
 	__of_detach_node_sysfs(np);
 	mutex_unlock(&of_mutex);
+
+	of_reconfig_notify(OF_RECONFIG_DETACH_NODE, np);
+
 	return rc;
 }
 
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 8129c0e58d70..f69ccb1fa308 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -43,11 +43,11 @@ static inline struct device_node *kobj_to_device_node(struct kobject *kobj)
 
 #if defined(CONFIG_OF_DYNAMIC)
 extern int of_property_notify(int action, struct device_node *np,
-			      struct property *prop);
+			      struct property *prop, struct property *old_prop);
 extern void of_node_release(struct kobject *kobj);
 #else /* CONFIG_OF_DYNAMIC */
 static inline int of_property_notify(int action, struct device_node *np,
-				     struct property *prop)
+				     struct property *prop, struct property *old_prop)
 {
 	return 0;
 }
diff --git a/include/linux/of.h b/include/linux/of.h
index 705fa12fca7f..400f18cb4fff 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -321,6 +321,7 @@ extern int of_update_property(struct device_node *np, struct property *newprop);
 struct of_prop_reconfig {
 	struct device_node	*dn;
 	struct property		*prop;
+	struct property		*old_prop;
 };
 
 extern int of_reconfig_notifier_register(struct notifier_block *);
-- 
1.9.1

