Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbaGAQdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:33:37 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51018 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239AbaGAQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:33:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Rob Herring <rob.herring@linaro.org>, devicetree@vger.kernel.org
Subject: [PATCH 01/14] of: Create of_property_match()
Date: Tue,  1 Jul 2014 22:02:30 +0530
Message-Id: <9a6bdfa64092dd8ee483570880225e08fcbad810.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new routine of_property_match() that will match a property between two
nodes. If they are exactly same, it returns 1 else 0. If the property isn't
available in any of the nodes or the API isn't implemented, proper error codes
would be returned.

The first user of this routine would be cpufreq-cpu0 driver, which requires to
match "clock" property between CPU nodes to identify which CPUs share clock
line. And hence this routine.

Cc: Rob Herring <rob.herring@linaro.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/of/base.c  | 29 +++++++++++++++++++++++++++++
 include/linux/of.h | 10 ++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index b986480..a036c91 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1490,6 +1490,35 @@ int of_property_count_strings(struct device_node *np, const char *propname)
 }
 EXPORT_SYMBOL_GPL(of_property_count_strings);
 
+/**
+ * of_property_match - Match 'prop' property between two nodes
+ * @np1, np2: Nodes to match for property
+ * @prop_name: property to match
+ *
+ * Returns 1 on match, 0 on no match, and error for missing property.
+ */
+int of_property_match(const struct device_node *np1,
+		      const struct device_node *np2, const char *prop_name)
+{
+	const __be32 *prop1, *prop2;
+	int size1, size2;
+
+	/* Retrieve property from both nodes */
+	prop1 = of_get_property(np1, prop_name, &size1);
+	if (!prop1)
+		return -ENOENT;
+
+	prop2 = of_get_property(np2, prop_name, &size2);
+	if (!prop2)
+		return -ENOENT;
+
+	if (size1 != size2)
+		return 0;
+
+	return !memcmp(prop1, prop2, size1);
+}
+EXPORT_SYMBOL_GPL(of_property_match);
+
 void of_print_phandle_args(const char *msg, const struct of_phandle_args *args)
 {
 	int i;
diff --git a/include/linux/of.h b/include/linux/of.h
index 196b34c..4e9cf5a 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -275,6 +275,9 @@ extern int of_property_match_string(struct device_node *np,
 				    const char *string);
 extern int of_property_count_strings(struct device_node *np,
 				     const char *propname);
+extern int of_property_match(const struct device_node *np1,
+			     const struct device_node *np2,
+			     const char *prop_name);
 extern int of_device_is_compatible(const struct device_node *device,
 				   const char *);
 extern int of_device_is_available(const struct device_node *device);
@@ -498,6 +501,13 @@ static inline int of_property_count_strings(struct device_node *np,
 	return -ENOSYS;
 }
 
+static inline int of_property_match(const struct device_node *np1,
+				    const struct device_node *np2,
+				    const char *prop_name)
+{
+	return -ENOSYS;
+}
+
 static inline const void *of_get_property(const struct device_node *node,
 				const char *name,
 				int *lenp)
-- 
2.0.0.rc2

