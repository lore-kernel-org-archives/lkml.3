Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3IRUXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:23:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50521 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3IRUXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:23:13 -0400
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
Subject: [dtc PATCH] Ensure all tests have matching reg and unit address
Date: Wed, 18 Sep 2013 14:23:02 -0600
Message-Id: <1379535782-12667-1-git-send-email-swarren@wwwdotorg.org>
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

Adjust all the dtc test-cases to conform to this rule.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 tests/aliases.dts                   |  4 ++++
 tests/include1.dts                  |  5 +++++
 tests/include7.dts                  |  1 +
 tests/include8.dts                  |  3 ++-
 tests/sw_tree1.c                    |  7 +++++++
 tests/test_tree1_body.dtsi          |  7 +++++++
 tests/test_tree1_merge.dts          |  7 +++++++
 tests/test_tree1_merge_labelled.dts |  7 +++++++
 tests/test_tree1_merge_path.dts     |  7 +++++++
 tests/test_tree1_wrong1.dts         |  7 +++++++
 tests/test_tree1_wrong2.dts         |  7 +++++++
 tests/test_tree1_wrong3.dts         |  7 +++++++
 tests/test_tree1_wrong4.dts         |  7 +++++++
 tests/test_tree1_wrong5.dts         |  7 +++++++
 tests/test_tree1_wrong6.dts         |  7 +++++++
 tests/test_tree1_wrong7.dts         |  7 +++++++
 tests/test_tree1_wrong8.dts         |  7 +++++++
 tests/test_tree1_wrong9.dts         |  7 +++++++
 tests/trees.S                       | 10 ++++++++++
 19 files changed, 120 insertions(+), 1 deletion(-)

diff --git a/tests/aliases.dts b/tests/aliases.dts
index 39d88ff..853479a 100644
--- a/tests/aliases.dts
+++ b/tests/aliases.dts
@@ -1,6 +1,9 @@
 /dts-v1/;
 
 / {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
 	aliases {
 		s1 = &sub1;
 		ss1 = &subsub1;
@@ -9,6 +12,7 @@
 
 	sub1: subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 
 		subsub1: subsubnode {
 			compatible = "subsubnode1", "subsubnode";
diff --git a/tests/include1.dts b/tests/include1.dts
index 893aaff..0b4b773 100644
--- a/tests/include1.dts
+++ b/tests/include1.dts
@@ -8,12 +8,17 @@
 	/include/ "include5.dts" = <0xdeadbeef>;
 	prop-int64 /include/ "include5a.dts";
 	prop-str = /include/ "include6.dts";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	/include/ "include7.dts"
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		/include/ "include8.dts"
 			phandle = <0x2001>;
diff --git a/tests/include7.dts b/tests/include7.dts
index dba5e47..2f6eb89 100644
--- a/tests/include7.dts
+++ b/tests/include7.dts
@@ -1,5 +1,6 @@
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
diff --git a/tests/include8.dts b/tests/include8.dts
index ec70064..7532ef5 100644
--- a/tests/include8.dts
+++ b/tests/include8.dts
@@ -1 +1,2 @@
-subsubnode@0 {
\ No newline at end of file
+subsubnode@0 {
+	reg = <0>;
diff --git a/tests/sw_tree1.c b/tests/sw_tree1.c
index 8eb6e5f..e9ea7e7 100644
--- a/tests/sw_tree1.c
+++ b/tests/sw_tree1.c
@@ -57,9 +57,12 @@ int main(int argc, char *argv[])
 	CHECK(fdt_property_u32(fdt, "prop-int", TEST_VALUE_1));
 	CHECK(fdt_property_u64(fdt, "prop-int64", TEST_VALUE64_1));
 	CHECK(fdt_property_string(fdt, "prop-str", TEST_STRING_1));
+	CHECK(fdt_property_u32(fdt, "#address-cells", 1));
+	CHECK(fdt_property_u32(fdt, "#size-cells", 0));
 
 	CHECK(fdt_begin_node(fdt, "subnode@1"));
 	CHECK(fdt_property_string(fdt, "compatible", "subnode1"));
+	CHECK(fdt_property_u32(fdt, "reg", 1));
 	CHECK(fdt_property_cell(fdt, "prop-int", TEST_VALUE_1));
 	CHECK(fdt_begin_node(fdt, "subsubnode"));
 	CHECK(fdt_property(fdt, "compatible", "subsubnode1\0subsubnode",
@@ -71,9 +74,13 @@ int main(int argc, char *argv[])
 	CHECK(fdt_end_node(fdt));
 
 	CHECK(fdt_begin_node(fdt, "subnode@2"));
+	CHECK(fdt_property_u32(fdt, "reg", 2));
 	CHECK(fdt_property_cell(fdt, "linux,phandle", PHANDLE_1));
 	CHECK(fdt_property_cell(fdt, "prop-int", TEST_VALUE_2));
+	CHECK(fdt_property_u32(fdt, "#address-cells", 1));
+	CHECK(fdt_property_u32(fdt, "#size-cells", 0));
 	CHECK(fdt_begin_node(fdt, "subsubnode@0"));
+	CHECK(fdt_property_u32(fdt, "reg", 0));
 	CHECK(fdt_property_cell(fdt, "phandle", PHANDLE_2));
 	CHECK(fdt_property(fdt, "compatible", "subsubnode2\0subsubnode",
 			   23));
diff --git a/tests/test_tree1_body.dtsi b/tests/test_tree1_body.dtsi
index 1446191..24a5e1e 100644
--- a/tests/test_tree1_body.dtsi
+++ b/tests/test_tree1_body.dtsi
@@ -6,9 +6,12 @@
 	prop-int = <0xdeadbeef>;
 	prop-int64 = /bits/ 64 <0xdeadbeef01abcdef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -21,10 +24,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		ssn0: subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_merge.dts b/tests/test_tree1_merge.dts
index ded08d8..b100c12 100644
--- a/tests/test_tree1_merge.dts
+++ b/tests/test_tree1_merge.dts
@@ -6,9 +6,12 @@
 	compatible = "test_tree1";
 	prop-int = "wrong!";
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 
 		subsubnode {
 			compatible = "subsubnode1", "subsubnode";
@@ -20,8 +23,11 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		ss2 {
 		};
@@ -36,6 +42,7 @@
 	};
 	subnode@2 {
 		ssn0: subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_merge_labelled.dts b/tests/test_tree1_merge_labelled.dts
index 29953b0..fcf5dc4 100644
--- a/tests/test_tree1_merge_labelled.dts
+++ b/tests/test_tree1_merge_labelled.dts
@@ -8,9 +8,12 @@
 	prop-int = <0xdeadbeef>;
 	prop-int64 = /bits/ 64 <0xdeadbeef01abcdef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -23,10 +26,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		ssn0: subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			prop-int = <0xbad>;
 		};
diff --git a/tests/test_tree1_merge_path.dts b/tests/test_tree1_merge_path.dts
index 168d066..c2ad829 100644
--- a/tests/test_tree1_merge_path.dts
+++ b/tests/test_tree1_merge_path.dts
@@ -8,9 +8,12 @@
 	prop-int = <0xdeadbeef>;
 	prop-int64 = /bits/ 64 <0xdeadbeef01abcdef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -23,10 +26,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		ssn0: subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			prop-int = <0xbad>;
 		};
diff --git a/tests/test_tree1_wrong1.dts b/tests/test_tree1_wrong1.dts
index d71820a..900d385 100644
--- a/tests/test_tree1_wrong1.dts
+++ b/tests/test_tree1_wrong1.dts
@@ -6,9 +6,12 @@
 	compatible = "test_tree1";
 	prop-int = <0xdeadbeef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -21,10 +24,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_wrong2.dts b/tests/test_tree1_wrong2.dts
index ac27023..099752b 100644
--- a/tests/test_tree1_wrong2.dts
+++ b/tests/test_tree1_wrong2.dts
@@ -6,9 +6,12 @@
 / {
 	compatible = "test_tree1";
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -21,10 +24,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_wrong3.dts b/tests/test_tree1_wrong3.dts
index 80be2fa..069353a 100644
--- a/tests/test_tree1_wrong3.dts
+++ b/tests/test_tree1_wrong3.dts
@@ -7,9 +7,12 @@
 	compatible = "test_tree1";
 	prop-int = <0xdeadbeef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 
 		subsubnode {
 			compatible = "subsubnode1", "subsubnode";
@@ -21,10 +24,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_wrong4.dts b/tests/test_tree1_wrong4.dts
index 09bb13b..2c56416 100644
--- a/tests/test_tree1_wrong4.dts
+++ b/tests/test_tree1_wrong4.dts
@@ -7,9 +7,12 @@
 	compatible = "test_tree1";
 	prop-int = <0xdeadbeef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -22,10 +25,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_wrong5.dts b/tests/test_tree1_wrong5.dts
index ef4c4f7..6ddd72d 100644
--- a/tests/test_tree1_wrong5.dts
+++ b/tests/test_tree1_wrong5.dts
@@ -7,9 +7,12 @@
 	compatible = "test_tree1";
 	prop-int = <0xdeadbefe>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -22,10 +25,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_wrong6.dts b/tests/test_tree1_wrong6.dts
index 98d6eda..36b4e1f 100644
--- a/tests/test_tree1_wrong6.dts
+++ b/tests/test_tree1_wrong6.dts
@@ -7,9 +7,12 @@
 	compatible = "test_tree1";
 	prop-int = <0xdeadbeef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -23,10 +26,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_wrong7.dts b/tests/test_tree1_wrong7.dts
index f57ace0..54150e6 100644
--- a/tests/test_tree1_wrong7.dts
+++ b/tests/test_tree1_wrong7.dts
@@ -7,9 +7,12 @@
 	compatible = "test_tree1";
 	prop-int = <0xdeadbeef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -22,10 +25,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_wrong8.dts b/tests/test_tree1_wrong8.dts
index 811ce6c..7a28a9f 100644
--- a/tests/test_tree1_wrong8.dts
+++ b/tests/test_tree1_wrong8.dts
@@ -7,9 +7,12 @@
 	compatible = "test_tree1";
 	prop-int = <0xdeadbeef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -24,8 +27,12 @@
 	subnode@2 {
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <2>;
 
 		subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/test_tree1_wrong9.dts b/tests/test_tree1_wrong9.dts
index 6ff6fab..f6486fa 100644
--- a/tests/test_tree1_wrong9.dts
+++ b/tests/test_tree1_wrong9.dts
@@ -8,9 +8,12 @@
 	compatible = "test_tree1";
 	prop-int = <0xdeadbeef>;
 	prop-str = "hello world";
+	#address-cells = <1>;
+	#size-cells = <0>;
 
 	subnode@1 {
 		compatible = "subnode1";
+		reg = <1>;
 		prop-int = [deadbeef];
 
 		subsubnode {
@@ -23,10 +26,14 @@
 	};
 
 	subnode@2 {
+		reg = <2>;
 		linux,phandle = <0x2000>;
 		prop-int = <123456789>;
+		#address-cells = <1>;
+		#size-cells = <0>;
 
 		subsubnode@0 {
+			reg = <0>;
 			phandle = <0x2001>;
 			compatible = "subsubnode2", "subsubnode";
 			prop-int = <0726746425>;
diff --git a/tests/trees.S b/tests/trees.S
index cae0187..2389cd3 100644
--- a/tests/trees.S
+++ b/tests/trees.S
@@ -92,9 +92,12 @@ test_tree1_struct:
 	PROP_INT(test_tree1, prop_int, TEST_VALUE_1)
 	PROP_INT64(test_tree1, prop_int64, TEST_VALUE64_1)
 	PROP_STR(test_tree1, prop_str, TEST_STRING_1)
+	PROP_INT(test_tree1, address_cells, 1)
+	PROP_INT(test_tree1, size_cells, 0)
 
 	BEGIN_NODE("subnode@1")
 	PROP_STR(test_tree1, compatible, "subnode1")
+	PROP_INT(test_tree1, reg, 1)
 	PROP_INT(test_tree1, prop_int, TEST_VALUE_1)
 
 	BEGIN_NODE("subsubnode")
@@ -108,10 +111,14 @@ test_tree1_struct:
 	END_NODE
 
 	BEGIN_NODE("subnode@2")
+	PROP_INT(test_tree1, reg, 2)
 	PROP_INT(test_tree1, linux_phandle, PHANDLE_1)
 	PROP_INT(test_tree1, prop_int, TEST_VALUE_2)
+	PROP_INT(test_tree1, address_cells, 1)
+	PROP_INT(test_tree1, size_cells, 0)
 
 	BEGIN_NODE("subsubnode@0")
+	PROP_INT(test_tree1, reg, 0)
 	PROP_INT(test_tree1, phandle, PHANDLE_2)
 	PROP_STR(test_tree1, compatible, "subsubnode2\0subsubnode")
 	PROP_INT(test_tree1, prop_int, TEST_VALUE_2)
@@ -133,6 +140,9 @@ test_tree1_strings:
 	STRING(test_tree1, prop_str, "prop-str")
 	STRING(test_tree1, linux_phandle, "linux,phandle")
 	STRING(test_tree1, phandle, "phandle")
+	STRING(test_tree1, reg, "reg")
+	STRING(test_tree1, address_cells, "#address-cells")
+	STRING(test_tree1, size_cells, "#size-cells")
 test_tree1_strings_end:
 test_tree1_end:
 
-- 
1.8.1.5

