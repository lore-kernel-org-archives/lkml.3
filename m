Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaDNLsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:48:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29932 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaDNLsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:48:23 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-e5-534bcb0400ac
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 05/13] extcon: extcon-class: improve extcon client API
Date: Mon, 14 Apr 2014 13:46:16 +0200
Message-id: <1397475984-28001-6-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWRbzDTcRzH++73Z7+55n6N6nfTdVmhpoQrfS/qPIj7duou5wn1QIvfjWPM
	huJJOqeiMDonWWX+b4yjuUz5s/FskU7xwN8uS6PRSdlFZHM9e31e7/f70YfCBD24kEpOy2QV
	aZJUEemGW7a+0KcIS1RMoGGWD1u/hUNT1wlomr0LJ9YWCFg+v4LBl0MjBCzTPsFg6XcNAUsN
	l+DAZjeA+XXtJBxZ1AJYODyPwVHrYxI29LXgUHO/HodjPWoSVteX4rC2sQCD85p3HKgfmubC
	hokPHDh5r5mETfZtEqoq9TicGzRyYZutEocFvUNc2De6ScD2p0t4+GHU+qIVoLGSYg7qMaoJ
	pCpdBcj4bJqLtE1rJBr8pcHRq2Yx6tQVkmixpYpAU+NvSdT/vJWLivOXSWQr2yCRcT2Pi0oM
	OnDN47pbWCKbmpzNKk5fvOmW1KftwOXWLXCn/PMYJw8YR0ER4FEMfYaxbf/k7PIBZnSmnSwC
	bpSArgVM93Y/d/d4wGFW7EuuFkmfZAzrKtfak8aYmor3LsZoK8G8dlxwsgd9mRneGN4ZUxRO
	+zBzI4FOzacjmN8zdsypGfoIoy4Pc2oeHcmYqv5iThbsVAbyJzEV4NeAPTqwn5UnyJW3pLLg
	AKVEpsxKkwYkpMs6geujX726gS4PmgFNAdFe/kN1VIyAkGQrc2RmwFCYyJMf0bWj+ImSnFxW
	kR6vyEpllWbgReGig3xTQWi0gJZKMtkUlpWziv8ph+IJ80BdiiV2yn+wehX5jl/5CI7pgV/C
	lPePy5rYim1LUO/R8ch2sb/DPSA4Tne1IMNonhaD21K/jk6hrz7T9qiqweodFK+q8XHEJf85
	lEHzQt5kcfiqmKwb4fq21E8L9sJoaVRKydlzjZa55eOR8tCWEPeifbVAWD24kGsSOc7ni3Bl
	kiRIjCmUkn/myCnAzQIAAA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves extcon client API to get rid of ugly functions operating
on name strings. It gives independency from naming convention in extcon
provider drivers. Names given at provider registration are now used only
for sysfs, debugs, and to support platforms using legacy devicetree bindings.

>From now individual cables are specified in devicetree, so client API has
changed from extcon_dev oriented to extcon_cable oriented. Added also some
minor modifications to simplify interest registration.

The extcon_specific_cable_nb structure has been changed to extcon_cable_nb.
Now this is the only struct which has to be supplied by client. Pointer to
user_nb has been changed to extcon_notifier_fn_t to simplify interest
registation process.

Each single cable is represented by struct extcon_cable. Pointer to
extcon_cable is returned from functions:

of_extcon_get_cable_by_index() - Return cable of given index.

of_extcon_get_cable() - Return cable by name defined in devicetree.

extcon_get_cable() - Similar to of_extcon_get_cable_by_name(),
	but it takes struct device instead of struct device_node.

extcon_get_cable_by_name() - return specified cable form extcon device
	found by name. It's for use in drivers without devicetree support,
	and shouldn't be used in new drivers.

Function extcon_register_interest() has been changed. Registration is now
not based on cable name string, but on pointer to struct extcon_cable.

Also extcon_get_cable_state() function has been changed. Now it takes
pointer to struct extcon_cable.

This patch modifies all client drivers to make it using new extcon API.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-class.c         |  246 +++++++++++++++++++++++----------
 drivers/power/charger-manager.c       |   36 +++--
 drivers/usb/dwc3/dwc3-omap.c          |   68 ++++-----
 drivers/usb/phy/phy-omap-otg.c        |   70 +++++-----
 include/linux/extcon.h                |  104 ++++++++------
 include/linux/power/charger-manager.h |    6 +-
 6 files changed, 331 insertions(+), 199 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index b0d9c90..cd830b0 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -324,15 +324,14 @@ EXPORT_SYMBOL_GPL(extcon_get_cable_state_);
 
 /**
  * extcon_get_cable_state() - Get the status of a specific cable.
- * @edev:	the extcon device that has the cable.
- * @cable_name:	cable name.
- *
- * Note that this is slower than extcon_get_cable_state_.
+ * @cable:	the cable.
  */
-int extcon_get_cable_state(struct extcon_dev *edev, const char *cable_name)
+int extcon_get_cable_state(struct extcon_cable *cable)
 {
-	return extcon_get_cable_state_(edev, extcon_find_cable_index
-						(edev, cable_name));
+	if (!cable)
+		return -ENODEV;
+
+	return !!(cable->edev->state & (1 << cable->cable_index));
 }
 EXPORT_SYMBOL_GPL(extcon_get_cable_state);
 
@@ -358,28 +357,27 @@ int extcon_set_cable_state_(struct extcon_dev *edev,
 EXPORT_SYMBOL_GPL(extcon_set_cable_state_);
 
 /**
- * extcon_get_extcon_dev() - Get the extcon device instance from the name
+ * extcon_get_extcon_dev_by_name() - Get the extcon device instance from the name
  * @extcon_name:	The extcon name provided with extcon_dev_register()
  */
-struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
+struct extcon_dev *extcon_get_extcon_dev_by_name(const char *extcon_name)
 {
-	struct extcon_dev *sd;
+	struct extcon_dev *edev;
 
 	mutex_lock(&extcon_dev_list_lock);
-	list_for_each_entry(sd, &extcon_dev_list, entry) {
-		if (!strcmp(sd->name, extcon_name))
+	list_for_each_entry(edev, &extcon_dev_list, entry) {
+		if (!strcmp(edev->name, extcon_name))
 			goto out;
 	}
-	sd = NULL;
+	edev = NULL;
 out:
 	mutex_unlock(&extcon_dev_list_lock);
-	return sd;
+	return edev;
 }
-EXPORT_SYMBOL_GPL(extcon_get_extcon_dev);
 
 /**
  * of_extcon_get_extcon_dev() - Get the extcon device instance from the name
- * @np: The node of extcon device
+ * @np:		The node of extcon device
  */
 struct extcon_dev *of_extcon_get_extcon_dev(const struct device_node *np)
 {
@@ -396,24 +394,158 @@ out:
 	return edev;
 }
 
+/**
+ * of_extcon_get_cable() - Get specified extcon cable instance from devicetree
+ * @np:		The node of extcon device
+ */
+struct extcon_cable *of_extcon_get_cable_by_index(struct device_node *np, int index)
+{
+	struct of_phandle_args extcon_spec;
+	struct extcon_dev *edev;
+	struct extcon_cable *cable;
+	int ret;
+
+	if (index < 0)
+		return ERR_PTR(-EINVAL);
+
+	ret = of_parse_phandle_with_args(np, "extcon-cables", "#extcon-cells",
+			index, &extcon_spec);
+	if (ret)
+		return ERR_PTR(ret);
+
+	edev = of_extcon_get_extcon_dev(extcon_spec.np);
+	if (!edev) {
+		pr_devel("unable to get extcon device");
+		return ERR_PTR(-ENODEV);
+	}
+
+	cable = &edev->cables[extcon_spec.args[0]];
+
+	of_node_put(extcon_spec.np);
+	return cable;
+}
+EXPORT_SYMBOL_GPL(of_extcon_get_cable_by_index);
+
+struct extcon_cable *of_extcon_get_cable_legacy(struct device_node *np,
+						const char *name)
+{
+	struct device_node *node;
+	struct extcon_dev *edev;
+	int i;
+
+	node = of_parse_phandle(np, "extcon", 0);
+	if (!node)
+		return ERR_PTR(-EINVAL);
+	edev = of_extcon_get_extcon_dev(node);
+	if (!edev)
+		return ERR_PTR(-ENODEV);
+
+	if (!edev->supported_cable)
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; edev->supported_cable[i]; ++i) {
+		if (!strncmp(edev->supported_cable[i], name, CABLE_NAME_MAX))
+			return &edev->cables[i];
+	}
+	return ERR_PTR(-ENODEV);
+}
+
+/*
+ * of_extcon_get_cable_by_name() - Get extcon cable from devicetree by name
+ * @np:		devicetree node of client device
+ * @name:	name of the cable specified in devicetree
+ *
+ * return the instance of extcon cable
+ */
+struct extcon_cable *of_extcon_get_cable(struct device_node *np,
+						 const char *name)
+{
+	struct extcon_cable *cable;
+	int index = 0;
+
+	if (!np)
+		return ERR_PTR(-EINVAL);
+
+	if (!of_property_read_bool(np, "extcon-cables")) {
+		if (!of_property_read_bool(np, "extcon")) {
+			return of_extcon_get_cable_legacy(np, name);
+		} else {
+			pr_devel("device node has not extcon entry\n");
+			return ERR_PTR(-EINVAL);
+		}
+	}
+
+	if (name)
+		index = of_property_match_string(np, "extcon-names", name);
+	cable = of_extcon_get_cable_by_index(np, index);
+	if (IS_ERR(cable)) {
+		pr_devel("unable to find cable\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	return cable;
+}
+EXPORT_SYMBOL_GPL(of_extcon_get_cable);
+
+/*
+ * of_extcon_get_cable_by_name() - Get extcon cable from devicetree by name
+ * @np:		devicetree node of client device
+ * @name:	name of the cable specified in devicetree
+ *
+ * return the instance of extcon cable
+ */
+struct extcon_cable *extcon_get_cable(struct device *dev, const char *name)
+{
+	return of_extcon_get_cable(dev->of_node, name);
+}
+EXPORT_SYMBOL_GPL(extcon_get_cable);
+
+/*
+ * of_extcon_get_cable_by_name() - Get extcon cable from devicetree by name
+ * @extcon_name:	the extcon name provided with extcon_dev_register()
+ * @name:		name of the cable specified in devicetree
+ *
+ * return the instance of extcon cable
+ */
+struct extcon_cable *extcon_get_cable_by_name(const char *extcon_name,
+					      const char *name)
+{
+	struct extcon_dev *edev;
+	int i;
+
+	edev = extcon_get_extcon_dev_by_name(extcon_name);
+	if (!edev)
+		return ERR_PTR(-ENODEV);
+
+	if (!edev->supported_cable)
+		return ERR_PTR(-EINVAL);
+
+	for (i = 0; edev->supported_cable[i]; ++i) {
+		if (!strncmp(edev->supported_cable[i], name, CABLE_NAME_MAX))
+			return &edev->cables[i];
+	}
+	return ERR_PTR(-ENODEV);
+
+}
+EXPORT_SYMBOL_GPL(extcon_get_cable_by_name);
+
 static int _call_per_cable(struct notifier_block *nb, unsigned long val,
 			   void *ptr)
 {
-	struct extcon_specific_cable_nb *obj = container_of(nb,
-			struct extcon_specific_cable_nb, internal_nb);
+	struct extcon_cable_nb *obj = container_of(nb,
+			struct extcon_cable_nb, internal_nb);
 	struct extcon_dev *edev = ptr;
 
-	if ((val & (1 << obj->cable_index)) !=
-	    (edev->state & (1 << obj->cable_index))) {
+	if ((val & (1 << obj->cable->cable_index)) !=
+			(edev->state & (1 << obj->cable->cable_index))) {
 		bool cable_state = true;
 
 		obj->previous_value = val;
 
-		if (val & (1 << obj->cable_index))
+		if (val & (1 << obj->cable->cable_index))
 			cable_state = false;
 
-		return obj->user_nb->notifier_call(obj->user_nb,
-				cable_state, ptr);
+		return obj->notifier_function(obj, cable_state);
 	}
 
 	return NOTIFY_OK;
@@ -423,14 +555,11 @@ static int _call_per_cable(struct notifier_block *nb, unsigned long val,
  * extcon_register_interest() - Register a notifier for a state change of a
  *				specific cable, not an entier set of cables of a
  *				extcon device.
- * @obj:		an empty extcon_specific_cable_nb object to be returned.
- * @extcon_name:	the name of extcon device.
- *			if NULL, extcon_register_interest will register
- *			every cable with the target cable_name given.
- * @cable_name:		the target cable name.
+ * @obj:		an empty extcon_cable_nb object to be returned.
+ * @cable:		the target cable.
  * @nb:			the notifier block to get notified.
  *
- * Provide an empty extcon_specific_cable_nb. extcon_register_interest() sets
+ * Provide an empty extcon_cable_nb. extcon_register_interest() sets
  * the struct for you.
  *
  * extcon_register_interest is a helper function for those who want to get
@@ -442,65 +571,38 @@ static int _call_per_cable(struct notifier_block *nb, unsigned long val,
  * "old_state", not the current state. The current state can be retrieved
  * by looking at the third pameter (edev pointer)'s state value.
  */
-int extcon_register_interest(struct extcon_specific_cable_nb *obj,
-			     const char *extcon_name, const char *cable_name,
-			     struct notifier_block *nb)
+int extcon_register_interest(struct extcon_cable_nb *obj,
+			     struct extcon_cable *cable,
+			     extcon_notifier_fn_t notifier_function)
 {
-	if (!obj || !cable_name || !nb)
+	if (!obj || !cable || !notifier_function)
 		return -EINVAL;
 
-	if (extcon_name) {
-		obj->edev = extcon_get_extcon_dev(extcon_name);
-		if (!obj->edev)
-			return -ENODEV;
-
-		obj->cable_index = extcon_find_cable_index(obj->edev,
-							  cable_name);
-		if (obj->cable_index < 0)
-			return obj->cable_index;
-
-		obj->user_nb = nb;
+	obj->cable = cable;
 
-		obj->internal_nb.notifier_call = _call_per_cable;
-
-		return raw_notifier_chain_register(&obj->edev->nh,
-						  &obj->internal_nb);
-	} else {
-		struct class_dev_iter iter;
-		struct extcon_dev *extd;
-		struct device *dev;
-
-		if (!extcon_class)
-			return -ENODEV;
-		class_dev_iter_init(&iter, extcon_class, NULL, NULL);
-		while ((dev = class_dev_iter_next(&iter))) {
-			extd = dev_get_drvdata(dev);
-
-			if (extcon_find_cable_index(extd, cable_name) < 0)
-				continue;
-
-			class_dev_iter_exit(&iter);
-			return extcon_register_interest(obj, extd->name,
-						cable_name, nb);
-		}
+	obj->internal_nb.notifier_call = _call_per_cable;
+	obj->notifier_function = notifier_function;
 
-		return -ENODEV;
-	}
+	return raw_notifier_chain_register(&cable->edev->nh,
+			&obj->internal_nb);
 }
 EXPORT_SYMBOL_GPL(extcon_register_interest);
 
 /**
  * extcon_unregister_interest() - Unregister the notifier registered by
  *				  extcon_register_interest().
- * @obj:	the extcon_specific_cable_nb object returned by
+ * @obj:	the extcon_cable_nb object returned by
  *		extcon_register_interest().
  */
-int extcon_unregister_interest(struct extcon_specific_cable_nb *obj)
+int extcon_unregister_interest(struct extcon_cable_nb *obj)
 {
 	if (!obj)
 		return -EINVAL;
 
-	return raw_notifier_chain_unregister(&obj->edev->nh, &obj->internal_nb);
+	obj->cable = NULL;
+
+	return raw_notifier_chain_unregister(&obj->cable->edev->nh,
+					     &obj->internal_nb);
 }
 EXPORT_SYMBOL_GPL(extcon_unregister_interest);
 
@@ -592,7 +694,7 @@ int extcon_dev_register(struct extcon_dev *edev)
 			;
 		edev->max_supported = index;
 	} else {
-		edev->max_supported = 0;
+		return -EINVAL;
 	}
 
 	if (index > SUPPORTED_CABLE_MAX) {
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 9e4dab4..331dad7 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1181,8 +1181,8 @@ static void charger_extcon_work(struct work_struct *work)
 		ret = regulator_set_current_limit(cable->charger->consumer,
 					cable->min_uA, cable->max_uA);
 		if (ret < 0) {
-			pr_err("Cannot set current limit of %s (%s)\n",
-			       cable->charger->regulator_name, cable->name);
+			pr_err("Cannot set current limit of %s\n",
+			       cable->charger->regulator_name);
 			return;
 		}
 
@@ -1202,17 +1202,17 @@ static void charger_extcon_work(struct work_struct *work)
  * @event: the cable state.
  * @ptr: the data pointer of notifier block.
  */
-static int charger_extcon_notifier(struct notifier_block *self,
-			unsigned long event, void *ptr)
+static int charger_extcon_notifier(struct extcon_cable_nb *cable_nb,
+				   bool state)
 {
 	struct charger_cable *cable =
-		container_of(self, struct charger_cable, nb);
+		container_of(cable_nb, struct charger_cable, cable_nb);
 
 	/*
 	 * The newly state of charger cable.
 	 * If cable is attached, cable->attached is true.
 	 */
-	cable->attached = event;
+	cable->attached = state;
 
 	/*
 	 * Setup monitoring to check battery state
@@ -1242,6 +1242,7 @@ static int charger_extcon_notifier(struct notifier_block *self,
 static int charger_extcon_init(struct charger_manager *cm,
 		struct charger_cable *cable)
 {
+	struct extcon_cable *ecable = cable->cable;
 	int ret = 0;
 
 	/*
@@ -1250,12 +1251,12 @@ static int charger_extcon_init(struct charger_manager *cm,
 	 * cable (e.g., TA, USB, MHL, Dock).
 	 */
 	INIT_WORK(&cable->wq, charger_extcon_work);
-	cable->nb.notifier_call = charger_extcon_notifier;
-	ret = extcon_register_interest(&cable->extcon_dev,
-			cable->extcon_name, cable->name, &cable->nb);
+
+	ret = extcon_register_interest(&cable->cable_nb,
+			ecable, charger_extcon_notifier);
 	if (ret < 0) {
-		pr_info("Cannot register extcon_dev for %s(cable: %s)\n",
-			cable->extcon_name, cable->name);
+		pr_info("Cannot register extcon_dev for %s(cable: %d)\n",
+			ecable->edev->name, ecable->cable_index);
 		ret = -EINVAL;
 	}
 
@@ -1632,11 +1633,8 @@ static struct charger_desc *of_cm_parse_desc(struct device *dev)
 				chg_regs->cables = cables;
 
 				for_each_child_of_node(child, _child) {
-					of_property_read_string(_child,
-					"cm-cable-name", &cables->name);
-					of_property_read_string(_child,
-					"cm-cable-extcon",
-					&cables->extcon_name);
+					cables->cable =
+					of_extcon_get_cable_by_index(_child, 0);
 					of_property_read_u32(_child,
 					"cm-cable-min",
 					&cables->min_uA);
@@ -1859,8 +1857,8 @@ err_reg_extcon:
 		for (j = 0; j < charger->num_cables; j++) {
 			struct charger_cable *cable = &charger->cables[j];
 			/* Remove notifier block if only edev exists */
-			if (cable->extcon_dev.edev)
-				extcon_unregister_interest(&cable->extcon_dev);
+			if (cable->cable_nb.cable)
+				extcon_unregister_interest(&cable->cable_nb);
 		}
 
 		regulator_put(desc->charger_regulators[i].consumer);
@@ -1891,7 +1889,7 @@ static int charger_manager_remove(struct platform_device *pdev)
 				= &desc->charger_regulators[i];
 		for (j = 0 ; j < charger->num_cables ; j++) {
 			struct charger_cable *cable = &charger->cables[j];
-			extcon_unregister_interest(&cable->extcon_dev);
+			extcon_unregister_interest(&cable->cable_nb);
 		}
 	}
 
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index b1d7ee6..86aada9 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -133,10 +133,8 @@ struct dwc3_omap {
 
 	u32			dma_status:1;
 
-	struct extcon_specific_cable_nb extcon_vbus_dev;
-	struct extcon_specific_cable_nb extcon_id_dev;
-	struct notifier_block	vbus_nb;
-	struct notifier_block	id_nb;
+	struct extcon_cable_nb	vbus_nb;
+	struct extcon_cable_nb	id_nb;
 
 	struct regulator	*vbus_reg;
 };
@@ -357,12 +355,13 @@ static void dwc3_omap_disable_irqs(struct dwc3_omap *omap)
 
 static u64 dwc3_omap_dma_mask = DMA_BIT_MASK(32);
 
-static int dwc3_omap_id_notifier(struct notifier_block *nb,
-	unsigned long event, void *ptr)
+static int dwc3_omap_id_notifier(struct extcon_cable_nb *cable_nb,
+				 bool state)
 {
-	struct dwc3_omap *omap = container_of(nb, struct dwc3_omap, id_nb);
+	struct dwc3_omap *omap = container_of(cable_nb,
+					struct dwc3_omap, id_nb);
 
-	if (event)
+	if (state)
 		dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
 	else
 		dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_FLOAT);
@@ -370,12 +369,13 @@ static int dwc3_omap_id_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static int dwc3_omap_vbus_notifier(struct notifier_block *nb,
-	unsigned long event, void *ptr)
+static int dwc3_omap_vbus_notifier(struct extcon_cable_nb *cable_nb,
+				   bool state)
 {
-	struct dwc3_omap *omap = container_of(nb, struct dwc3_omap, vbus_nb);
+	struct dwc3_omap *omap = container_of(cable_nb,
+					struct dwc3_omap, vbus_nb);
 
-	if (event)
+	if (state)
 		dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
 	else
 		dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_OFF);
@@ -390,9 +390,10 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	struct dwc3_omap	*omap;
 	struct resource		*res;
 	struct device		*dev = &pdev->dev;
-	struct extcon_dev	*edev;
 	struct regulator	*vbus_reg = NULL;
 
+	struct extcon_cable *cable_vbus, *cable_id;
+
 	int			ret = -ENOMEM;
 	int			irq;
 
@@ -520,29 +521,30 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 
 	dwc3_omap_enable_irqs(omap);
 
-	if (of_property_read_bool(node, "extcon")) {
-		edev = extcon_get_edev_by_phandle(dev, 0);
-		if (IS_ERR(edev)) {
-			dev_vdbg(dev, "couldn't get extcon device\n");
+	if (of_property_read_bool(node, "extcon") ||
+	    of_property_read_bool(node, "extcon-cable")) {
+		cable_vbus = extcon_get_cable(dev, "USB");
+		if (IS_ERR(cable_vbus)) {
+			dev_vdbg(dev, "couldn't get extcon cable USB\n");
 			ret = -EPROBE_DEFER;
 			goto err2;
 		}
 
-		omap->vbus_nb.notifier_call = dwc3_omap_vbus_notifier;
-		ret = extcon_register_interest(&omap->extcon_vbus_dev,
-			edev->name, "USB", &omap->vbus_nb);
+		ret = extcon_register_interest(&omap->vbus_nb,
+				cable_vbus, dwc3_omap_vbus_notifier);
 		if (ret < 0)
 			dev_vdbg(dev, "failed to register notifier for USB\n");
-		omap->id_nb.notifier_call = dwc3_omap_id_notifier;
-		ret = extcon_register_interest(&omap->extcon_id_dev, edev->name,
-					 "USB-HOST", &omap->id_nb);
+
+		cable_id = extcon_get_cable(dev, "USB-HOST");
+		ret = extcon_register_interest(&omap->id_nb,
+				cable_id, dwc3_omap_id_notifier);
 		if (ret < 0)
 			dev_vdbg(dev,
 				"failed to register notifier for USB-HOST\n");
 
-		if (extcon_get_cable_state(edev, "USB") == true)
+		if (extcon_get_cable_state(cable_vbus) == true)
 			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
-		if (extcon_get_cable_state(edev, "USB-HOST") == true)
+		if (extcon_get_cable_state(cable_id) == true)
 			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
 	}
 
@@ -555,10 +557,10 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	return 0;
 
 err3:
-	if (omap->extcon_vbus_dev.edev)
-		extcon_unregister_interest(&omap->extcon_vbus_dev);
-	if (omap->extcon_id_dev.edev)
-		extcon_unregister_interest(&omap->extcon_id_dev);
+	if (omap->vbus_nb.cable)
+		extcon_unregister_interest(&omap->vbus_nb);
+	if (omap->id_nb.cable)
+		extcon_unregister_interest(&omap->id_nb);
 
 err2:
 	dwc3_omap_disable_irqs(omap);
@@ -576,10 +578,10 @@ static int dwc3_omap_remove(struct platform_device *pdev)
 {
 	struct dwc3_omap	*omap = platform_get_drvdata(pdev);
 
-	if (omap->extcon_vbus_dev.edev)
-		extcon_unregister_interest(&omap->extcon_vbus_dev);
-	if (omap->extcon_id_dev.edev)
-		extcon_unregister_interest(&omap->extcon_id_dev);
+	if (omap->vbus_nb.cable)
+		extcon_unregister_interest(&omap->vbus_nb);
+	if (omap->id_nb.cable)
+		extcon_unregister_interest(&omap->id_nb);
 	dwc3_omap_disable_irqs(omap);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/usb/phy/phy-omap-otg.c b/drivers/usb/phy/phy-omap-otg.c
index 11598cd..6ea604e 100644
--- a/drivers/usb/phy/phy-omap-otg.c
+++ b/drivers/usb/phy/phy-omap-otg.c
@@ -30,10 +30,8 @@ struct otg_device {
 	void __iomem			*base;
 	bool				id;
 	bool				vbus;
-	struct extcon_specific_cable_nb	vbus_dev;
-	struct extcon_specific_cable_nb	id_dev;
-	struct notifier_block		vbus_nb;
-	struct notifier_block		id_nb;
+	struct extcon_cable_nb		vbus_nb;
+	struct extcon_cable_nb		id_nb;
 };
 
 #define OMAP_OTG_CTRL		0x0c
@@ -69,10 +67,11 @@ static void omap_otg_set_mode(struct otg_device *otg_dev)
 		omap_otg_ctrl(otg_dev, OMAP_OTG_ID | OMAP_OTG_BSESSEND);
 }
 
-static int omap_otg_id_notifier(struct notifier_block *nb,
-				unsigned long event, void *ptr)
+static int omap_otg_id_notifier(struct extcon_cable_nb *cable_nb,
+				bool state)
 {
-	struct otg_device *otg_dev = container_of(nb, struct otg_device, id_nb);
+	struct otg_device *otg_dev = container_of(cable_nb,
+					struct otg_device, id_nb);
 
 	otg_dev->id = event;
 	omap_otg_set_mode(otg_dev);
@@ -80,13 +79,13 @@ static int omap_otg_id_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static int omap_otg_vbus_notifier(struct notifier_block *nb,
-				  unsigned long event, void *ptr)
+static int omap_otg_vbus_notifier(struct extcon_cable_nb *cable_nb,
+				  bool state)
 {
-	struct otg_device *otg_dev = container_of(nb, struct otg_device,
-						  vbus_nb);
+	struct otg_device *otg_dev = container_of(cable_nb,
+					struct otg_device, vbus_nb);
 
-	otg_dev->vbus = event;
+	otg_dev->vbus = state;
 	omap_otg_set_mode(otg_dev);
 
 	return NOTIFY_DONE;
@@ -96,17 +95,13 @@ static int omap_otg_probe(struct platform_device *pdev)
 {
 	const struct omap_usb_config *config = pdev->dev.platform_data;
 	struct otg_device *otg_dev;
-	struct extcon_dev *extcon;
+	struct extcon_cable *cable_vbus, *cable_id;
 	int ret;
 	u32 rev;
 
 	if (!config || !config->extcon)
 		return -ENODEV;
 
-	extcon = extcon_get_extcon_dev(config->extcon);
-	if (!extcon)
-		return -EPROBE_DEFER;
-
 	otg_dev = devm_kzalloc(&pdev->dev, sizeof(*otg_dev), GFP_KERNEL);
 	if (!otg_dev)
 		return -ENOMEM;
@@ -115,41 +110,52 @@ static int omap_otg_probe(struct platform_device *pdev)
 	if (IS_ERR(otg_dev->base))
 		return PTR_ERR(otg_dev->base);
 
-	otg_dev->id_nb.notifier_call = omap_otg_id_notifier;
-	otg_dev->vbus_nb.notifier_call = omap_otg_vbus_notifier;
-
-	ret = extcon_register_interest(&otg_dev->id_dev, config->extcon,
-				       "USB-HOST", &otg_dev->id_nb);
+	cable_id = extcon_get_cable_by_name(config->extcon, "USB-HOST");
+	if (IS_ERR(cable_id)) {
+		dev_vdbg(&pdev->dev, "couldn't get extcon cable USB-HOST\n");
+		return PTR_ERR(cable_id);
+	}
+	ret = extcon_register_interest(&otg_dev->id_nb,
+				       cable_id, omap_otg_id_notifier);
 	if (ret)
 		return ret;
 
-	ret = extcon_register_interest(&otg_dev->vbus_dev, config->extcon,
-				       "USB", &otg_dev->vbus_nb);
+	cable_vbus = extcon_get_cable_by_name(config->extcon, "USB");
+	if (IS_ERR(cable_vbus)) {
+		dev_vdbg(&pdev->dev, "couldn't get extcon cable USB\n");
+		ret = PTR_ERR(cable_vbus);
+		goto err;
+	}
+	ret = extcon_register_interest(&otg_dev->vbus_nb,
+				       cable_vbus, omap_otg_vbus_notifier);
 	if (ret) {
-		extcon_unregister_interest(&otg_dev->id_dev);
-		return ret;
+		goto err;
 	}
 
-	otg_dev->id = extcon_get_cable_state(extcon, "USB-HOST");
-	otg_dev->vbus = extcon_get_cable_state(extcon, "USB");
+	otg_dev->id = extcon_get_cable_state(cable_id);
+	otg_dev->vbus = extcon_get_cable_state(cable_vbus);
 	omap_otg_set_mode(otg_dev);
 
 	rev = readl(otg_dev->base);
 
 	dev_info(&pdev->dev,
-		 "OMAP USB OTG controller rev %d.%d (%s, id=%d, vbus=%d)\n",
-		 (rev >> 4) & 0xf, rev & 0xf, config->extcon, otg_dev->id,
+		 "OMAP USB OTG controller rev %d.%d (id=%d, vbus=%d)\n",
+		 (rev >> 4) & 0xf, rev & 0xf, otg_dev->id,
 		 otg_dev->vbus);
 
 	return 0;
+
+err:
+	extcon_unregister_interest(&otg_dev->id_nb);
+	return ret;
 }
 
 static int omap_otg_remove(struct platform_device *pdev)
 {
 	struct otg_device *otg_dev = platform_get_drvdata(pdev);
 
-	extcon_unregister_interest(&otg_dev->id_dev);
-	extcon_unregister_interest(&otg_dev->vbus_dev);
+	extcon_unregister_interest(&otg_dev->id_nb);
+	extcon_unregister_interest(&otg_dev->vbus_nb);
 
 	return 0;
 }
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 573dd1f..bc680a9 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -1,6 +1,7 @@
 /*
  *  External connector (extcon) class driver
  *
+ *
  * Copyright (C) 2012 Samsung Electronics
  * Author: Donggeun Kim <dg77.kim@samsung.com>
  * Author: MyungJoo Ham <myungjoo.ham@samsung.com>
@@ -79,6 +80,7 @@ struct extcon_cable;
  * @name:		The name of this extcon device. Parent device name is
  * @node:		Devicetree node of parent device.
  *			used if NULL.
+ * @node:		Devicetree node of parent device.
  * @supported_cable:	Array of supported cable names ending with NULL.
  *			If supported_cable is NULL, cable name related APIs
  *			are disabled.
@@ -160,23 +162,24 @@ struct extcon_cable {
 	struct attribute *attrs[3]; /* to be fed to attr_g.attrs */
 };
 
+struct extcon_cable_nb;
+
+typedef int (*extcon_notifier_fn_t)(struct extcon_cable_nb *cable_nb,
+				    bool cable_state);
+
 /**
- * struct extcon_specific_cable_nb - An internal data for
- *				     extcon_register_interest().
+ * struct extcon_cable_nb - An internal data for extcon_register_interest().
  * @internal_nb:	A notifier block bridging extcon notifier
  *			and cable notifier.
- * @user_nb:		user provided notifier block for events from
- *			a specific cable.
- * @cable_index:	the target cable.
- * @edev:		the target extcon device.
- * @previous_value:	the saved previous event value.
+ * @user_nb:		Notifier block for events from a specific cable, used
+ *			to handle user provided callback function.
+ * @cable:		The target cable.
  */
-struct extcon_specific_cable_nb {
+struct extcon_cable_nb {
 	struct notifier_block internal_nb;
-	struct notifier_block *user_nb;
-	int cable_index;
-	struct extcon_dev *edev;
 	unsigned long previous_value;
+	extcon_notifier_fn_t notifier_function;
+	struct extcon_cable *cable;
 };
 
 #if IS_ENABLED(CONFIG_EXTCON)
@@ -187,7 +190,6 @@ struct extcon_specific_cable_nb {
  */
 extern int extcon_dev_register(struct extcon_dev *edev);
 extern void extcon_dev_unregister(struct extcon_dev *edev);
-extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
 /*
  * get/set/update_state access the 32b encoded state value, which represents
@@ -206,16 +208,13 @@ extern int extcon_update_state(struct extcon_dev *edev, u32 mask, u32 state);
 /*
  * get/set_cable_state access each bit of the 32b encoded state value.
  * They are used to access the status of each cable based on the cable_name
- * or cable_index, which is retrieved by extcon_find_cable_index
+tt or cable_index, which is retrieved by extcon_find_cable_index
  */
 extern int extcon_find_cable_index(struct extcon_dev *sdev,
 				   const char *cable_name);
 extern int extcon_get_cable_state_(struct extcon_dev *edev, int cable_index);
-extern int extcon_set_cable_state_(struct extcon_dev *edev, int cable_index,
-				   bool cable_state);
-
-extern int extcon_get_cable_state(struct extcon_dev *edev,
-				  const char *cable_name);
+extern int extcon_set_cable_state_(struct extcon_dev *edev,
+				  int cable_index, bool cable_state);
 
 /*
  * Following APIs are for notifiees (those who want to be notified)
@@ -223,11 +222,26 @@ extern int extcon_get_cable_state(struct extcon_dev *edev,
  * Notifiees are the connected device drivers wanting to get notified by
  * a specific external port of a connection device.
  */
-extern int extcon_register_interest(struct extcon_specific_cable_nb *obj,
-				    const char *extcon_name,
-				    const char *cable_name,
-				    struct notifier_block *nb);
-extern int extcon_unregister_interest(struct extcon_specific_cable_nb *nb);
+
+extern struct extcon_cable *
+of_extcon_get_cable_by_index(struct device_node *np, int index);
+
+extern struct extcon_cable *
+of_extcon_get_cable(struct device_node *np, const char *name);
+
+extern struct extcon_cable *
+extcon_get_cable(struct device *dev, const char *name);
+
+extern struct extcon_cable *
+extcon_get_cable_by_name(const char *extcon_name, const char *name);
+
+extern int extcon_register_interest(struct extcon_cable_nb *obj,
+				    struct extcon_cable *cable,
+				    extcon_notifier_fn_t notifier_function);
+
+extern int extcon_unregister_interest(struct extcon_cable_nb *nb);
+
+extern int extcon_get_cable_state(struct extcon_cable *cable);
 
 /*
  * Following APIs are to monitor every action of a notifier.
@@ -282,44 +296,56 @@ static inline int extcon_get_cable_state_(struct extcon_dev *edev,
 	return 0;
 }
 
-static inline int extcon_get_cable_state(struct extcon_dev *edev,
-			const char *cable_name)
+static inline int extcon_get_cable_state(struct extcon_cable *cable)
 {
 	return 0;
 }
 
-static inline int extcon_set_cable_state(struct extcon_dev *edev,
-			const char *cable_name, int state)
+static inline int extcon_register_notifier(struct extcon_dev *edev,
+					   struct notifier_block *nb)
 {
 	return 0;
 }
 
-static inline struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
+static inline int extcon_unregister_notifier(struct extcon_dev *edev,
+					     struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline struct extcon_cable *
+of_extcon_get_cable_by_index(struct device_node *np, int index)
 {
 	return NULL;
 }
 
-static inline int extcon_register_notifier(struct extcon_dev *edev,
-					   struct notifier_block *nb)
+static inline struct extcon_cable *
+of_extcon_get_cable(struct device_node *np, const char *name)
 {
-	return 0;
+	return NULL;
 }
 
-static inline int extcon_unregister_notifier(struct extcon_dev *edev,
-					     struct notifier_block *nb)
+static inline struct extcon_cable *
+extcon_get_cable(struct device *dev, const char *name)
 {
-	return 0;
+	return NULL;
 }
 
-static inline int extcon_register_interest(struct extcon_specific_cable_nb *obj,
-					   const char *extcon_name,
-					   const char *cable_name,
-					   struct notifier_block *nb)
+
+static inline struct extcon_cable *
+extcon_get_cable_by_name(const char *extcon_name, const char *name)
+{
+	return NULL;
+}
+
+static inline int extcon_register_interest(struct extcon_cable_nb *obj,
+				struct extcon_cable *cable,
+				extcon_notifier_fn_t notifier_function)
 {
 	return 0;
 }
 
-static inline int extcon_unregister_interest(struct extcon_specific_cable_nb
+static inline int extcon_unregister_interest(struct extcon_cable_nb
 						    *obj)
 {
 	return 0;
diff --git a/include/linux/power/charger-manager.h b/include/linux/power/charger-manager.h
index 07e7945..28e7a4b 100644
--- a/include/linux/power/charger-manager.h
+++ b/include/linux/power/charger-manager.h
@@ -84,13 +84,11 @@ struct charger_global_desc {
  * @cm: the Charger Manager representing the battery.
  */
 struct charger_cable {
-	const char *extcon_name;
-	const char *name;
+	struct extcon_cable *cable;
 
 	/* The charger-manager use Exton framework*/
-	struct extcon_specific_cable_nb extcon_dev;
+	struct extcon_cable_nb cable_nb;
 	struct work_struct wq;
-	struct notifier_block nb;
 
 	/* The state of charger cable */
 	bool attached;
-- 
1.7.9.5

