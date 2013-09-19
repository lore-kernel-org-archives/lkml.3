Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab3ISRyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:54:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41531 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3ISRyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:54:32 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>
Cc: Olof Johansson <olof@lixom.net>, frowand.list@gmail.com,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: [dtc PATCH V2] Warn on node name unit-address presence/absence mismatch
Date: Thu, 19 Sep 2013 11:54:23 -0600
Message-Id: <1379613263-32080-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
node that has a reg property must include a unit address in its name
with value matching the first entry in its reg property. Conversely, if
a node does not have a reg property, the node name must not include a
unit address.

Implement a check for this. The code doesn't validate the format of the
unit address; ePAPR implies this may vary from (containing bus) binding
to binding, so doing so would be much more complex.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v2: Implement the new checks separately, rather than as part of existing
    checkes. downgrade from errors to warnings. Add tests.

Question: Do I need to make a special exception for the /memory node? I
assume we do want to fix that too, so the answer is no. That will require
removing the /memory node from skeleton.dtsi in the kernel though.
---
 checks.c                        | 22 ++++++++++++++++++++--
 tests/reg-without-unit-addr.dts | 10 ++++++++++
 tests/run_tests.sh              |  2 ++
 tests/unit-addr-without-reg.dts |  9 +++++++++
 4 files changed, 41 insertions(+), 2 deletions(-)
 create mode 100644 tests/reg-without-unit-addr.dts
 create mode 100644 tests/unit-addr-without-reg.dts

diff --git a/checks.c b/checks.c
index ee96a25..8d2ccc5 100644
--- a/checks.c
+++ b/checks.c
@@ -293,6 +293,24 @@ static void check_node_name_format(struct check *c, struct node *dt,
 }
 NODE_ERROR(node_name_format, NULL, &node_name_chars);
 
+static void check_unit_address_vs_reg(struct check *c, struct node *dt,
+			     struct node *node)
+{
+	const char *unitname = get_unitname(node);
+	struct property *prop = get_property(node, "reg");
+
+	if (prop) {
+		if (!unitname[0])
+			FAIL(c, "Node %s has a reg property, but no unit name",
+			    node->fullpath);
+	} else {
+		if (unitname[0])
+			FAIL(c, "Node %s has a unit name, but no reg property",
+			    node->fullpath);
+	}
+}
+NODE_WARNING(unit_address_vs_reg, NULL);
+
 static void check_property_name_chars(struct check *c, struct node *dt,
 				      struct node *node, struct property *prop)
 {
@@ -653,8 +671,8 @@ TREE_WARNING(obsolete_chosen_interrupt_controller, NULL);
 
 static struct check *check_table[] = {
 	&duplicate_node_names, &duplicate_property_names,
-	&node_name_chars, &node_name_format, &property_name_chars,
-	&name_is_string, &name_properties,
+	&node_name_chars, &node_name_format, &unit_address_vs_reg,
+	&property_name_chars, &name_is_string, &name_properties,
 
 	&duplicate_label,
 
diff --git a/tests/reg-without-unit-addr.dts b/tests/reg-without-unit-addr.dts
new file mode 100644
index 0000000..aaf8af7
--- /dev/null
+++ b/tests/reg-without-unit-addr.dts
@@ -0,0 +1,10 @@
+/dts-v1/;
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	node {
+		reg = <0 1>;
+	};
+};
diff --git a/tests/run_tests.sh b/tests/run_tests.sh
index c0a136b..8a95bec 100755
--- a/tests/run_tests.sh
+++ b/tests/run_tests.sh
@@ -400,6 +400,8 @@ dtc_tests () {
     check_tests reg-ranges-root.dts reg_format ranges_format
     check_tests default-addr-size.dts avoid_default_addr_size
     check_tests obsolete-chosen-interrupt-controller.dts obsolete_chosen_interrupt_controller
+    check_tests reg-without-unit-addr.dts unit_address_vs_reg
+    check_tests unit-addr-without-reg.dts unit_address_vs_reg
     run_sh_test dtc-checkfails.sh node_name_chars -- -I dtb -O dtb bad_node_char.dtb
     run_sh_test dtc-checkfails.sh node_name_format -- -I dtb -O dtb bad_node_format.dtb
     run_sh_test dtc-checkfails.sh prop_name_chars -- -I dtb -O dtb bad_prop_char.dtb
diff --git a/tests/unit-addr-without-reg.dts b/tests/unit-addr-without-reg.dts
new file mode 100644
index 0000000..ac786eb
--- /dev/null
+++ b/tests/unit-addr-without-reg.dts
@@ -0,0 +1,9 @@
+/dts-v1/;
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	node@1 {
+	};
+};
-- 
1.8.1.5

