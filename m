Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946Ab3EALLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:11:37 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48971 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab3EALLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:11:32 -0400
From: Sudeep.KarkadaNagesha@arm.com
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Shawn Guo <shawn.guo@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH 1/2] PM / OPP: add support to specify phandle of another node for OPP
Date: Wed,  1 May 2013 12:11:18 +0100
Message-Id: <1367406679-21603-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1367406679-21603-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 01 May 2013 11:11:29.0314 (UTC) FILETIME=[A10B7020:01CE465C]
X-MC-Unique: 113050112113008501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r41BC2Ij029600

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

If more than one similar devices share the same OPPs, currently we
need to replicate the OPP entries in all the nodes.

Few drivers like cpufreq depend on physical cpu0 node to specify the
OPPs and only that node is referred irrespective of the logical cpu
accessing it. Alternatively to support cpuhotplug path, few drivers
parse all the cpu nodes for OPPs. Instead we can specify the phandle
of the node with which the current node shares the operating points.

This patch adds support to specify the phandle in the operating points
of any device node, where the node specified by the phandle holds the
actual OPPs.

Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 Documentation/devicetree/bindings/power/opp.txt |   41 +++++++++++++++++++++++
 drivers/base/power/opp.c                        |   30 ++++++++++++-----
 2 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/power/opp.txt b/Documentation/devicetree/bindings/power/opp.txt
index 74499e5..a659da4 100644
--- a/Documentation/devicetree/bindings/power/opp.txt
+++ b/Documentation/devicetree/bindings/power/opp.txt
@@ -23,3 +23,44 @@ cpu@0 {
 		198000  850000
 	>;
 };
+
+If more than one device of same type share the same OPPs, e.g. all the CPUs on
+a SoC or in a single cluster on a SoC, then we need to avoid replicating the
+OPPs in all the nodes. We can specify the phandle of the node with which the
+current node shares the operating points instead.
+
+Examples:
+Consider an SMP with 4 CPUs all sharing the same OPPs.
+
+cpu0: cpu@0 {
+	compatible = "arm,cortex-a9";
+	reg = <0>;
+	next-level-cache = <&L2>;
+	operating-points = <
+		/* kHz    uV */
+		792000  1100000
+		396000  950000
+		198000  850000
+	>;
+};
+
+cpu1: cpu@1 {
+	compatible = "arm,cortex-a9";
+	reg = <1>;
+	next-level-cache = <&L2>;
+	operating-points = <&cpu0>;
+};
+
+cpu2: cpu@2 {
+	compatible = "arm,cortex-a9";
+	reg = <2>;
+	next-level-cache = <&L2>;
+	operating-points = <&cpu0>;
+};
+
+cpu3: cpu@3 {
+	compatible = "arm,cortex-a9";
+	reg = <3>;
+	next-level-cache = <&L2>;
+	operating-points = <&cpu0>;
+};
diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index f0077cb..4dfdc01 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -698,19 +698,15 @@ struct srcu_notifier_head *opp_get_notifier(struct device *dev)
 }
 
 #ifdef CONFIG_OF
-/**
- * of_init_opp_table() - Initialize opp table from device tree
- * @dev:	device pointer used to lookup device OPPs.
- *
- * Register the initial OPP table with the OPP library for given device.
- */
-int of_init_opp_table(struct device *dev)
+static int of_init_opp_table_from_ofnode(struct device *dev,
+					struct device_node *of_node)
 {
+	struct device_opp *dev_opp = NULL;
 	const struct property *prop;
 	const __be32 *val;
 	int nr;
 
-	prop = of_find_property(dev->of_node, "operating-points", NULL);
+	prop = of_find_property(of_node, "operating-points", NULL);
 	if (!prop)
 		return -ENODEV;
 	if (!prop->value)
@@ -722,6 +718,14 @@ int of_init_opp_table(struct device *dev)
 	 */
 	nr = prop->length / sizeof(u32);
 	if (nr % 2) {
+		if (nr == 1) {
+			struct device_node *opp_node;
+			opp_node = of_parse_phandle(dev->of_node,
+						"operating-points", 0);
+			if (opp_node)
+				return of_init_opp_table_from_ofnode(dev,
+								opp_node);
+		}
 		dev_err(dev, "%s: Invalid OPP list\n", __func__);
 		return -EINVAL;
 	}
@@ -741,5 +745,15 @@ int of_init_opp_table(struct device *dev)
 
 	return 0;
 }
+/**
+ * of_init_opp_table() - Initialize opp table from device tree
+ * @dev:	device pointer used to lookup device OPPs.
+ *
+ * Register the initial OPP table with the OPP library for given device.
+ */
+int of_init_opp_table(struct device *dev)
+{
+	return of_init_opp_table_from_ofnode(dev, dev->of_node);
+}
 EXPORT_SYMBOL_GPL(of_init_opp_table);
 #endif
-- 
1.7.10.4


