Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaKXWhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:37:42 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61269 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaKXWeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:12 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH v2 07/14] of/reconfig: Always use the same structure for notifiers
Date: Mon, 24 Nov 2014 22:33:35 +0000
Message-Id: <1416868422-22103-8-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OF_RECONFIG notifier callback uses a different structure depending
on whether it is a node change or a property change. This is silly, and
not very safe. Rework the code to use the same data structure regardless
of the type of notifier.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: <linuxppc-dev@lists.ozlabs.org>
---
 arch/powerpc/mm/numa.c                          |  3 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c    |  7 +++--
 arch/powerpc/platforms/pseries/hotplug-memory.c | 15 +++++----
 arch/powerpc/platforms/pseries/iommu.c          |  5 +--
 arch/powerpc/platforms/pseries/setup.c          |  5 +--
 drivers/crypto/nx/nx-842.c                      |  4 +--
 drivers/of/dynamic.c                            | 41 +++++++++++++------------
 include/linux/of.h                              | 23 ++++++++------
 8 files changed, 54 insertions(+), 49 deletions(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index b9d1dfdbe5bb..9fe6002c1d5a 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1711,12 +1711,11 @@ static void stage_topology_update(int core_id)
 static int dt_update_callback(struct notifier_block *nb,
 				unsigned long action, void *data)
 {
-	struct of_prop_reconfig *update;
+	struct of_reconfig_data *update = data;
 	int rc = NOTIFY_DONE;
 
 	switch (action) {
 	case OF_RECONFIG_UPDATE_PROPERTY:
-		update = (struct of_prop_reconfig *)data;
 		if (!of_prop_cmp(update->dn->type, "cpu") &&
 		    !of_prop_cmp(update->prop->name, "ibm,associativity")) {
 			u32 core_id;
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index 5c375f93c669..f30cf4d136a4 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -340,16 +340,17 @@ static void pseries_remove_processor(struct device_node *np)
 }
 
 static int pseries_smp_notifier(struct notifier_block *nb,
-				unsigned long action, void *node)
+				unsigned long action, void *data)
 {
+	struct of_reconfig_data *rd = data;
 	int err = 0;
 
 	switch (action) {
 	case OF_RECONFIG_ATTACH_NODE:
-		err = pseries_add_processor(node);
+		err = pseries_add_processor(rd->dn);
 		break;
 	case OF_RECONFIG_DETACH_NODE:
-		pseries_remove_processor(node);
+		pseries_remove_processor(rd->dn);
 		break;
 	}
 	return notifier_from_errno(err);
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index 3c4c0dcd90d3..1bbb78fab530 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -183,7 +183,7 @@ static int pseries_add_mem_node(struct device_node *np)
 	return (ret < 0) ? -EINVAL : 0;
 }
 
-static int pseries_update_drconf_memory(struct of_prop_reconfig *pr)
+static int pseries_update_drconf_memory(struct of_reconfig_data *pr)
 {
 	struct of_drconf_cell *new_drmem, *old_drmem;
 	unsigned long memblock_size;
@@ -232,22 +232,21 @@ static int pseries_update_drconf_memory(struct of_prop_reconfig *pr)
 }
 
 static int pseries_memory_notifier(struct notifier_block *nb,
-				   unsigned long action, void *node)
+				   unsigned long action, void *data)
 {
-	struct of_prop_reconfig *pr;
+	struct of_reconfig_data *rd = data;
 	int err = 0;
 
 	switch (action) {
 	case OF_RECONFIG_ATTACH_NODE:
-		err = pseries_add_mem_node(node);
+		err = pseries_add_mem_node(rd->dn);
 		break;
 	case OF_RECONFIG_DETACH_NODE:
-		err = pseries_remove_mem_node(node);
+		err = pseries_remove_mem_node(rd->dn);
 		break;
 	case OF_RECONFIG_UPDATE_PROPERTY:
-		pr = (struct of_prop_reconfig *)node;
-		if (!strcmp(pr->prop->name, "ibm,dynamic-memory"))
-			err = pseries_update_drconf_memory(pr);
+		if (!strcmp(rd->prop->name, "ibm,dynamic-memory"))
+			err = pseries_update_drconf_memory(rd);
 		break;
 	}
 	return notifier_from_errno(err);
diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index e32e00976a94..3e5bfdafee63 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1251,10 +1251,11 @@ static struct notifier_block iommu_mem_nb = {
 	.notifier_call = iommu_mem_notifier,
 };
 
-static int iommu_reconfig_notifier(struct notifier_block *nb, unsigned long action, void *node)
+static int iommu_reconfig_notifier(struct notifier_block *nb, unsigned long action, void *data)
 {
 	int err = NOTIFY_OK;
-	struct device_node *np = node;
+	struct of_reconfig_data *rd = data;
+	struct device_node *np = rd->dn;
 	struct pci_dn *pci = PCI_DN(np);
 	struct direct_window *window;
 
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 125c589eeef5..ed8a90022a3d 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -251,9 +251,10 @@ static void __init pseries_discover_pic(void)
 	       " interrupt-controller\n");
 }
 
-static int pci_dn_reconfig_notifier(struct notifier_block *nb, unsigned long action, void *node)
+static int pci_dn_reconfig_notifier(struct notifier_block *nb, unsigned long action, void *data)
 {
-	struct device_node *np = node;
+	struct of_reconfig_data *rd = data;
+	struct device_node *np = rd->dn;
 	struct pci_dn *pci = NULL;
 	int err = NOTIFY_OK;
 
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 061407d59520..887196e9b50c 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -1009,9 +1009,9 @@ error_out:
  *		notifier_to_errno() to decode this value
  */
 static int nx842_OF_notifier(struct notifier_block *np, unsigned long action,
-			     void *update)
+			     void *data)
 {
-	struct of_prop_reconfig *upd = update;
+	struct of_reconfig_data *upd = data;
 	struct nx842_devdata *local_devdata;
 	struct device_node *node = NULL;
 
diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index cc106529dca8..3351ef408125 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -87,18 +87,17 @@ const char *action_names[] = {
 };
 #endif
 
-int of_reconfig_notify(unsigned long action, void *p)
+int of_reconfig_notify(unsigned long action, struct of_reconfig_data *p)
 {
 	int rc;
 #ifdef DEBUG
-	struct device_node *dn = p;
-	struct of_prop_reconfig *pr = p;
+	struct of_reconfig_data *pr = p;
 
 	switch (action) {
 	case OF_RECONFIG_ATTACH_NODE:
 	case OF_RECONFIG_DETACH_NODE:
 		pr_debug("of/notify %-15s %s\n", action_names[action],
-			dn->full_name);
+			pr->dn->full_name);
 		break;
 	case OF_RECONFIG_ADD_PROPERTY:
 	case OF_RECONFIG_REMOVE_PROPERTY:
@@ -122,31 +121,22 @@ int of_reconfig_notify(unsigned long action, void *p)
  * Returns 0 on device going from enabled to disabled, 1 on device
  * going from disabled to enabled and -1 on no change.
  */
-int of_reconfig_get_state_change(unsigned long action, void *arg)
+int of_reconfig_get_state_change(unsigned long action, struct of_reconfig_data *pr)
 {
-	struct device_node *dn;
-	struct property *prop, *old_prop;
-	struct of_prop_reconfig *pr;
+	struct property *prop, *old_prop = NULL;
 	int is_status, status_state, old_status_state, prev_state, new_state;
 
 	/* figure out if a device should be created or destroyed */
-	dn = NULL;
-	prop = old_prop = NULL;
 	switch (action) {
 	case OF_RECONFIG_ATTACH_NODE:
 	case OF_RECONFIG_DETACH_NODE:
-		dn = arg;
-		prop = of_find_property(dn, "status", NULL);
+		prop = of_find_property(pr->dn, "status", NULL);
 		break;
 	case OF_RECONFIG_ADD_PROPERTY:
 	case OF_RECONFIG_REMOVE_PROPERTY:
-		pr = arg;
-		dn = pr->dn;
 		prop = pr->prop;
 		break;
 	case OF_RECONFIG_UPDATE_PROPERTY:
-		pr = arg;
-		dn = pr->dn;
 		prop = pr->prop;
 		old_prop = pr->old_prop;
 		break;
@@ -212,7 +202,7 @@ EXPORT_SYMBOL_GPL(of_reconfig_get_state_change);
 int of_property_notify(int action, struct device_node *np,
 		       struct property *prop, struct property *oldprop)
 {
-	struct of_prop_reconfig pr;
+	struct of_reconfig_data pr;
 
 	/* only call notifiers if the node is attached */
 	if (!of_node_is_attached(np))
@@ -250,8 +240,12 @@ void __of_attach_node(struct device_node *np)
  */
 int of_attach_node(struct device_node *np)
 {
+	struct of_reconfig_data rd;
 	unsigned long flags;
 
+	memset(&rd, 0, sizeof(rd));
+	rd.dn = np;
+
 	mutex_lock(&of_mutex);
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	__of_attach_node(np);
@@ -260,7 +254,7 @@ int of_attach_node(struct device_node *np)
 	__of_attach_node_sysfs(np);
 	mutex_unlock(&of_mutex);
 
-	of_reconfig_notify(OF_RECONFIG_ATTACH_NODE, np);
+	of_reconfig_notify(OF_RECONFIG_ATTACH_NODE, &rd);
 
 	return 0;
 }
@@ -298,9 +292,13 @@ void __of_detach_node(struct device_node *np)
  */
 int of_detach_node(struct device_node *np)
 {
+	struct of_reconfig_data rd;
 	unsigned long flags;
 	int rc = 0;
 
+	memset(&rd, 0, sizeof(rd));
+	rd.dn = np;
+
 	mutex_lock(&of_mutex);
 	raw_spin_lock_irqsave(&devtree_lock, flags);
 	__of_detach_node(np);
@@ -309,7 +307,7 @@ int of_detach_node(struct device_node *np)
 	__of_detach_node_sysfs(np);
 	mutex_unlock(&of_mutex);
 
-	of_reconfig_notify(OF_RECONFIG_DETACH_NODE, np);
+	of_reconfig_notify(OF_RECONFIG_DETACH_NODE, &rd);
 
 	return rc;
 }
@@ -505,6 +503,7 @@ static void __of_changeset_entry_invert(struct of_changeset_entry *ce,
 
 static void __of_changeset_entry_notify(struct of_changeset_entry *ce, bool revert)
 {
+	struct of_reconfig_data rd;
 	struct of_changeset_entry ce_inverted;
 	int ret;
 
@@ -516,7 +515,9 @@ static void __of_changeset_entry_notify(struct of_changeset_entry *ce, bool reve
 	switch (ce->action) {
 	case OF_RECONFIG_ATTACH_NODE:
 	case OF_RECONFIG_DETACH_NODE:
-		ret = of_reconfig_notify(ce->action, ce->np);
+		memset(&rd, 0, sizeof(rd));
+		rd.dn = ce->np;
+		ret = of_reconfig_notify(ce->action, &rd);
 		break;
 	case OF_RECONFIG_ADD_PROPERTY:
 	case OF_RECONFIG_REMOVE_PROPERTY:
diff --git a/include/linux/of.h b/include/linux/of.h
index b59ee21933a4..fe1dec87fd68 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -73,6 +73,12 @@ struct of_phandle_args {
 	uint32_t args[MAX_PHANDLE_ARGS];
 };
 
+struct of_reconfig_data {
+	struct device_node	*dn;
+	struct property		*prop;
+	struct property		*old_prop;
+};
+
 /* initialize a node */
 extern struct kobj_type of_node_ktype;
 static inline void of_node_init(struct device_node *node)
@@ -318,12 +324,6 @@ extern int of_update_property(struct device_node *np, struct property *newprop);
 #define OF_RECONFIG_REMOVE_PROPERTY	0x0004
 #define OF_RECONFIG_UPDATE_PROPERTY	0x0005
 
-struct of_prop_reconfig {
-	struct device_node	*dn;
-	struct property		*prop;
-	struct property		*old_prop;
-};
-
 extern int of_attach_node(struct device_node *);
 extern int of_detach_node(struct device_node *);
 
@@ -892,8 +892,9 @@ enum of_reconfig_change {
 #ifdef CONFIG_OF_DYNAMIC
 extern int of_reconfig_notifier_register(struct notifier_block *);
 extern int of_reconfig_notifier_unregister(struct notifier_block *);
-extern int of_reconfig_notify(unsigned long, void *);
-extern int of_reconfig_get_state_change(unsigned long action, void *arg);
+extern int of_reconfig_notify(unsigned long, struct of_reconfig_data *rd);
+extern int of_reconfig_get_state_change(unsigned long action,
+					struct of_reconfig_data *arg);
 
 extern void of_changeset_init(struct of_changeset *ocs);
 extern void of_changeset_destroy(struct of_changeset *ocs);
@@ -941,11 +942,13 @@ static inline int of_reconfig_notifier_unregister(struct notifier_block *nb)
 {
 	return -EINVAL;
 }
-static inline int of_reconfig_notify(unsigned long action, void *arg)
+static inline int of_reconfig_notify(unsigned long action,
+				     struct of_reconfig_data *arg)
 {
 	return -EINVAL;
 }
-static inline int of_reconfig_get_state_change(unsigned long action, void *arg)
+static inline int of_reconfig_get_state_change(unsigned long action,
+						struct of_reconfig_data *arg)
 {
 	return -EINVAL;
 }
-- 
1.9.1

