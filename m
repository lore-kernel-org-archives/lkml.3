Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3HEMlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:41:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36635 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3HEMlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:41:02 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/2] OF: Add helper for matching against linux,stdout-path
Date: Mon,  5 Aug 2013 14:40:44 +0200
Message-Id: <1375706445-15375-2-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc0
In-Reply-To: <1375706445-15375-1-git-send-email-s.hauer@pengutronix.de>
References: <1375706445-15375-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devicetrees may have a linux,stdout-path property in the chosen
node describing the console device. This adds a helper function
to match a device against this property so a driver can call
add_preferred_console for a matching device.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/of/base.c  | 26 ++++++++++++++++++++++++++
 include/linux/of.h |  7 +++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 5c54279..1c3c79c 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -32,6 +32,7 @@ struct device_node *of_allnodes;
 EXPORT_SYMBOL(of_allnodes);
 struct device_node *of_chosen;
 struct device_node *of_aliases;
+static struct device_node *of_stdout;
 
 DEFINE_MUTEX(of_aliases_mutex);
 
@@ -1595,6 +1596,15 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 	of_chosen = of_find_node_by_path("/chosen");
 	if (of_chosen == NULL)
 		of_chosen = of_find_node_by_path("/chosen@0");
+
+	if (of_chosen) {
+		const char *name;
+
+		name = of_get_property(of_chosen, "linux,stdout-path", NULL);
+		if (name)
+			of_stdout = of_find_node_by_path(name);
+	}
+
 	of_aliases = of_find_node_by_path("/aliases");
 	if (!of_aliases)
 		return;
@@ -1703,3 +1713,19 @@ const char *of_prop_next_string(struct property *prop, const char *cur)
 	return curv;
 }
 EXPORT_SYMBOL_GPL(of_prop_next_string);
+
+/**
+ * of_device_is_stdout_path - check if a device node matches the
+ *                            linux,stdout-path property
+ *
+ * Check if this device node matches the linux,stdout-path property
+ * in the chosen node. return true if yes, false otherwise.
+ */
+int of_device_is_stdout_path(struct device_node *dn)
+{
+	if (!of_stdout)
+		return false;
+
+	return of_stdout == dn;
+}
+EXPORT_SYMBOL_GPL(of_device_is_stdout_path);
diff --git a/include/linux/of.h b/include/linux/of.h
index 1fd08ca..429e168 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -343,6 +343,8 @@ const char *of_prop_next_string(struct property *prop, const char *cur);
 		s;						\
 		s = of_prop_next_string(prop, s))
 
+int of_device_is_stdout_path(struct device_node *dn);
+
 #else /* CONFIG_OF */
 
 static inline const char* of_node_full_name(struct device_node *np)
@@ -505,6 +507,11 @@ static inline int of_machine_is_compatible(const char *compat)
 	return 0;
 }
 
+static inline int of_device_is_stdout_path(struct device_node *dn)
+{
+	return 0;
+}
+
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
 #define of_property_for_each_u32(np, propname, prop, p, u) \
-- 
1.8.4.rc0

