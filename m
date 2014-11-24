Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaKXWim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:38:42 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45206 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaKXWeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:34:10 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v2 04/14] of/reconfig: Add of_reconfig_get_state_change() of notifier helper.
Date: Mon, 24 Nov 2014 22:33:32 +0000
Message-Id: <1416868422-22103-5-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>

Introduce of_reconfig_get_state_change() which allows an of notifier
to query about device state changes.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/dynamic.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h   |  7 ++++
 2 files changed, 103 insertions(+)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index 661ad2f5c00c..6659c39ab3aa 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -85,6 +85,102 @@ int of_reconfig_notify(unsigned long action, void *p)
 	return notifier_to_errno(rc);
 }
 
+/*
+ * of_reconfig_get_state_change()	- Returns new state of device
+ * @action	- action of the of notifier
+ * @arg		- argument of the of notifier
+ *
+ * Returns the new state of a device based on the notifier used.
+ * Returns 0 on device going from enabled to disabled, 1 on device
+ * going from disabled to enabled and -1 on no change.
+ */
+int of_reconfig_get_state_change(unsigned long action, void *arg)
+{
+	struct device_node *dn;
+	struct property *prop, *old_prop;
+	struct of_prop_reconfig *pr;
+	int is_status, status_state, old_status_state, prev_state, new_state;
+
+	/* figure out if a device should be created or destroyed */
+	dn = NULL;
+	prop = old_prop = NULL;
+	switch (action) {
+	case OF_RECONFIG_ATTACH_NODE:
+	case OF_RECONFIG_DETACH_NODE:
+		dn = arg;
+		prop = of_find_property(dn, "status", NULL);
+		break;
+	case OF_RECONFIG_ADD_PROPERTY:
+	case OF_RECONFIG_REMOVE_PROPERTY:
+		pr = arg;
+		dn = pr->dn;
+		prop = pr->prop;
+		break;
+	case OF_RECONFIG_UPDATE_PROPERTY:
+		pr = arg;
+		dn = pr->dn;
+		prop = pr->prop;
+		old_prop = pr->old_prop;
+		break;
+	default:
+		return OF_RECONFIG_NO_CHANGE;
+	}
+
+	is_status = 0;
+	status_state = -1;
+	old_status_state = -1;
+	prev_state = -1;
+	new_state = -1;
+
+	if (prop && !strcmp(prop->name, "status")) {
+		is_status = 1;
+		status_state = !strcmp(prop->value, "okay") ||
+			       !strcmp(prop->value, "ok");
+		if (old_prop)
+			old_status_state = !strcmp(old_prop->value, "okay") ||
+					   !strcmp(old_prop->value, "ok");
+	}
+
+	switch (action) {
+	case OF_RECONFIG_ATTACH_NODE:
+		prev_state = 0;
+		/* -1 & 0 status either missing or okay */
+		new_state = status_state != 0;
+		break;
+	case OF_RECONFIG_DETACH_NODE:
+		/* -1 & 0 status either missing or okay */
+		prev_state = status_state != 0;
+		new_state = 0;
+		break;
+	case OF_RECONFIG_ADD_PROPERTY:
+		if (is_status) {
+			/* no status property -> enabled (legacy) */
+			prev_state = 1;
+			new_state = status_state;
+		}
+		break;
+	case OF_RECONFIG_REMOVE_PROPERTY:
+		if (is_status) {
+			prev_state = status_state;
+			/* no status property -> enabled (legacy) */
+			new_state = 1;
+		}
+		break;
+	case OF_RECONFIG_UPDATE_PROPERTY:
+		if (is_status) {
+			prev_state = old_status_state != 0;
+			new_state = status_state != 0;
+		}
+		break;
+	}
+
+	if (prev_state == new_state)
+		return OF_RECONFIG_NO_CHANGE;
+
+	return new_state ? OF_RECONFIG_CHANGE_ADD : OF_RECONFIG_CHANGE_REMOVE;
+}
+EXPORT_SYMBOL_GPL(of_reconfig_get_state_change);
+
 int of_property_notify(int action, struct device_node *np,
 		       struct property *prop, struct property *oldprop)
 {
diff --git a/include/linux/of.h b/include/linux/of.h
index 27635c89d8c2..8e3a264c869c 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -327,6 +327,7 @@ struct of_prop_reconfig {
 extern int of_reconfig_notifier_register(struct notifier_block *);
 extern int of_reconfig_notifier_unregister(struct notifier_block *);
 extern int of_reconfig_notify(unsigned long, void *);
+extern int of_reconfig_get_state_change(unsigned long action, void *arg);
 
 extern int of_attach_node(struct device_node *);
 extern int of_detach_node(struct device_node *);
@@ -887,6 +888,12 @@ struct of_changeset {
 	struct list_head entries;
 };
 
+enum of_reconfig_change {
+	OF_RECONFIG_NO_CHANGE = 0,
+	OF_RECONFIG_CHANGE_ADD,
+	OF_RECONFIG_CHANGE_REMOVE,
+};
+
 #ifdef CONFIG_OF_DYNAMIC
 extern void of_changeset_init(struct of_changeset *ocs);
 extern void of_changeset_destroy(struct of_changeset *ocs);
-- 
1.9.1

