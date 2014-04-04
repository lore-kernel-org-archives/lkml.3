Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaDDMo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 08:44:58 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52635 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaDDMoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 08:44:44 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v4 8/8] OF: selftest: Add overlay self-test support.
Date: Fri,  4 Apr 2014 15:44:01 +0300
Message-Id: <1396615441-29630-9-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1396615441-29630-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds overlay tests to the OF selftest.

It tests overlay device addition/removal and whether
the apply revert sequence is correct.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/of/selftest.c                       | 368 ++++++++++++++++++++++++++++
 drivers/of/testcase-data/testcases.dtsi     |   1 +
 drivers/of/testcase-data/tests-overlay.dtsi | 125 ++++++++++
 3 files changed, 494 insertions(+)
 create mode 100644 drivers/of/testcase-data/tests-overlay.dtsi

diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index ae44500..eeb29ff 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -14,6 +14,8 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/of_platform.h>
 
 static struct selftest_results {
 	int passed;
@@ -427,6 +429,371 @@ static void __init of_selftest_match_node(void)
 	}
 }
 
+#ifdef CONFIG_OF_OVERLAY
+
+static int selftest_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+
+	if (np == NULL) {
+		dev_err(dev, "No OF data for device\n");
+		return -EINVAL;
+
+	}
+
+	dev_dbg(dev, "%s for node @%s\n", __func__, np->full_name);
+	return 0;
+}
+
+static int selftest_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+
+	dev_dbg(dev, "%s for node @%s\n", __func__, np->full_name);
+	return 0;
+}
+
+static struct of_device_id selftest_match[] = {
+	{ .compatible = "selftest", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, altera_jtaguart_match);
+
+static struct platform_driver selftest_driver = {
+	.probe			= selftest_probe,
+	.remove			= selftest_remove,
+	.driver = {
+		.name		= "selftest",
+		.owner		= THIS_MODULE,
+		.of_match_table	= of_match_ptr(selftest_match),
+	},
+};
+
+/* get the platform device instantiated at the path */
+static struct platform_device *of_path_to_platform_device(const char *path)
+{
+	struct device_node *np;
+	struct platform_device *pdev;
+
+	np = of_find_node_by_path(path);
+	if (np == NULL)
+		return NULL;
+
+	pdev = of_find_device_by_node(np);
+	of_node_put(np);
+
+	return pdev;
+}
+
+/* find out if a platform device exists at that path */
+static int of_path_platform_device_exists(const char *path)
+{
+	struct platform_device *pdev;
+
+	pdev = of_path_to_platform_device(path);
+	platform_device_put(pdev);
+	return pdev != NULL;
+}
+
+static const char *selftest_path(int nr)
+{
+	static char buf[256];
+
+	snprintf(buf, sizeof(buf) - 1,
+		"/testcase-data/overlay-node/test-bus/test-selftest%d", nr);
+	buf[sizeof(buf) - 1] = '\0';
+
+	return buf;
+}
+
+static const char *overlay_path(int nr)
+{
+	static char buf[256];
+
+	snprintf(buf, sizeof(buf) - 1,
+		"/testcase-data/overlay%d", nr);
+	buf[sizeof(buf) - 1] = '\0';
+
+	return buf;
+}
+
+static const char *bus_path = "/testcase-data/overlay-node/test-bus";
+
+static int of_selftest_apply_overlay(int selftest_nr, int overlay_nr,
+		int *ovcount_arg, struct of_overlay_info **ovinfo_arg)
+{
+	struct device_node *np = NULL;
+	int ret, ovcount_val, *ovcount;
+	struct of_overlay_info *ovinfo_val, **ovinfo;
+
+	if (ovcount_arg == NULL || ovinfo_arg == NULL) {
+		ovcount = &ovcount_val;
+		ovinfo = &ovinfo_val;
+	} else {
+		ovcount = ovcount_arg;
+		ovinfo = ovinfo_arg;
+	}
+
+	*ovcount = 0;
+	*ovinfo = NULL;
+
+	np = of_find_node_by_path(overlay_path(overlay_nr));
+	if (np == NULL) {
+		selftest(0, "could not find overlay node @\"%s\"\n",
+				overlay_path(overlay_nr));
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = of_build_overlay_info(np, ovcount, ovinfo);
+	if (ret != 0) {
+		selftest(0, "could not build overlay from \"%s\"\n",
+				overlay_path(overlay_nr));
+		goto out;
+	}
+
+	ret = of_overlay(*ovcount, *ovinfo);
+	if (ret != 0) {
+		selftest(0, "could not apply overlay from \"%s\"\n",
+				overlay_path(overlay_nr));
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	/* free if no argument passed */
+	if (ovinfo == &ovinfo_val)
+		of_free_overlay_info(*ovcount, *ovinfo);
+	of_node_put(np);
+	return ret;
+}
+
+/* apply an overlay while checking before and after states */
+static int of_selftest_apply_overlay_check(int overlay_nr, int selftest_nr,
+		int before, int after)
+{
+	int ret;
+
+	/* selftest device must not be in before state */
+	if (of_path_platform_device_exists(selftest_path(selftest_nr))
+			!= before) {
+		selftest(0, "overlay @\"%s\" with device @\"%s\" %s\n",
+				overlay_path(overlay_nr),
+				selftest_path(selftest_nr),
+				!before ? "enabled" : "disabled");
+		return -EINVAL;
+	}
+
+	ret = of_selftest_apply_overlay(overlay_nr, selftest_nr, NULL, NULL);
+	if (ret != 0) {
+		/* of_selftest_apply_overlay already called selftest() */
+		return ret;
+	}
+
+	/* selftest device must be to set to after state */
+	if (of_path_platform_device_exists(selftest_path(selftest_nr))
+			!= after) {
+		selftest(0, "overlay @\"%s\" failed to create @\"%s\" %s\n",
+				overlay_path(overlay_nr),
+				selftest_path(selftest_nr),
+				!after ? "enabled" : "disabled");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* apply an overlay and then revert it while checking before, after states */
+static int of_selftest_apply_revert_overlay_check(int overlay_nr,
+		int selftest_nr, int before, int after)
+{
+	int ret, ovcount;
+	struct of_overlay_info *ovinfo;
+
+	/* selftest device must be in before state */
+	if (of_path_platform_device_exists(selftest_path(selftest_nr))
+			!= before) {
+		selftest(0, "overlay @\"%s\" with device @\"%s\" %s\n",
+				overlay_path(overlay_nr),
+				selftest_path(selftest_nr),
+				!before ? "enabled" : "disabled");
+		return -EINVAL;
+	}
+
+	/* apply the overlay */
+	ret = of_selftest_apply_overlay(overlay_nr, selftest_nr,
+			&ovcount, &ovinfo);
+	if (ret != 0) {
+		/* of_selftest_apply_overlay already called selftest() */
+		return ret;
+	}
+
+	/* selftest device must be in after state */
+	if (of_path_platform_device_exists(selftest_path(selftest_nr))
+			!= after) {
+		selftest(0, "overlay @\"%s\" failed to create @\"%s\" %s\n",
+				overlay_path(overlay_nr),
+				selftest_path(selftest_nr),
+				!after ? "enabled" : "disabled");
+		return -EINVAL;
+	}
+
+	ret = of_overlay_revert(ovcount, ovinfo);
+	if (ret != 0) {
+		selftest(0, "overlay @\"%s\" failed to revert @\"%s\"\n",
+				overlay_path(overlay_nr),
+				selftest_path(selftest_nr));
+		return ret;
+	}
+
+	of_free_overlay_info(ovcount, ovinfo);
+
+	/* selftest device must be again in before state */
+	if (of_path_platform_device_exists(selftest_path(selftest_nr))
+			!= before) {
+		selftest(0, "overlay @\"%s\" with device @\"%s\" %s\n",
+				overlay_path(overlay_nr),
+				selftest_path(selftest_nr),
+				!before ? "enabled" : "disabled");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* test activation of device */
+static void of_selftest_overlay_0(void)
+{
+	int ret;
+
+	/* device should enable */
+	ret = of_selftest_apply_overlay_check(0, 0, 0, 1);
+	if (ret != 0)
+		return;
+
+	selftest(1, "overlay test %d passed\n", 0);
+}
+
+/* test deactivation of device */
+static void of_selftest_overlay_1(void)
+{
+	int ret;
+
+	/* device should disable */
+	ret = of_selftest_apply_overlay_check(1, 1, 1, 0);
+	if (ret != 0)
+		return;
+
+	selftest(1, "overlay test %d passed\n", 1);
+}
+
+/* test activation of device */
+static void of_selftest_overlay_2(void)
+{
+	int ret;
+
+	/* device should enable */
+	ret = of_selftest_apply_overlay_check(2, 2, 0, 1);
+	if (ret != 0)
+		return;
+
+	selftest(1, "overlay test %d passed\n", 2);
+}
+
+/* test deactivation of device */
+static void of_selftest_overlay_3(void)
+{
+	int ret;
+
+	/* device should disable */
+	ret = of_selftest_apply_overlay_check(3, 3, 1, 0);
+	if (ret != 0)
+		return;
+
+	selftest(1, "overlay test %d passed\n", 3);
+}
+
+/* test activation of a full device node */
+static void of_selftest_overlay_4(void)
+{
+	int ret;
+
+	/* device should disable */
+	ret = of_selftest_apply_overlay_check(4, 4, 0, 1);
+	if (ret != 0)
+		return;
+
+	selftest(1, "overlay test %d passed\n", 4);
+}
+
+/* test overlay apply/revert sequence */
+static void of_selftest_overlay_5(void)
+{
+	int ret;
+
+	/* device should disable */
+	ret = of_selftest_apply_revert_overlay_check(5, 5, 0, 1);
+	if (ret != 0)
+		return;
+
+	selftest(1, "overlay test %d passed\n", 5);
+}
+
+static void __init of_selftest_overlay(void)
+{
+	struct device_node *bus_np = NULL;
+	int ret;
+
+	ret = platform_driver_register(&selftest_driver);
+	if (ret != 0) {
+		selftest(0, "could not register selftest driver\n");
+		goto out;
+	}
+
+	bus_np = of_find_node_by_path(bus_path);
+	if (bus_np == NULL) {
+		selftest(0, "could not find bus_path \"%s\"\n", bus_path);
+		goto out;
+	}
+
+	ret = of_platform_populate(bus_np, of_default_bus_match_table,
+			NULL, NULL);
+	if (ret != 0) {
+		selftest(0, "could not populate bus @ \"%s\"\n", bus_path);
+		goto out;
+	}
+
+	if (!of_path_platform_device_exists(selftest_path(100))) {
+		selftest(0, "could not find selftest0 @ \"%s\"\n", selftest_path(100));
+		goto out;
+	}
+
+	if (of_path_platform_device_exists(selftest_path(101))) {
+		selftest(0, "selftest1 @ \"%s\" should not exist\n", selftest_path(101));
+		goto out;
+	}
+
+	selftest(1, "basic infrastructure of overlays passed");
+
+	/* tests in sequence */
+	of_selftest_overlay_0();
+	of_selftest_overlay_1();
+	of_selftest_overlay_2();
+	of_selftest_overlay_3();
+	of_selftest_overlay_4();
+	of_selftest_overlay_5();
+
+out:
+	of_node_put(bus_np);
+}
+
+#else
+static inline void __init of_selftest_overlay(void) { }
+#endif
+
 static int __init of_selftest(void)
 {
 	struct device_node *np;
@@ -445,6 +812,7 @@ static int __init of_selftest(void)
 	of_selftest_parse_interrupts();
 	of_selftest_parse_interrupts_extended();
 	of_selftest_match_node();
+	of_selftest_overlay();
 	pr_info("end of selftest - %i passed, %i failed\n",
 		selftest_results.passed, selftest_results.failed);
 	return 0;
diff --git a/drivers/of/testcase-data/testcases.dtsi b/drivers/of/testcase-data/testcases.dtsi
index 3a5b75a..6a9441e 100644
--- a/drivers/of/testcase-data/testcases.dtsi
+++ b/drivers/of/testcase-data/testcases.dtsi
@@ -1,3 +1,4 @@
 #include "tests-phandle.dtsi"
 #include "tests-interrupts.dtsi"
 #include "tests-match.dtsi"
+#include "tests-overlay.dtsi"
diff --git a/drivers/of/testcase-data/tests-overlay.dtsi b/drivers/of/testcase-data/tests-overlay.dtsi
new file mode 100644
index 0000000..9981b20
--- /dev/null
+++ b/drivers/of/testcase-data/tests-overlay.dtsi
@@ -0,0 +1,125 @@
+
+/ {
+	testcase-data {
+		overlay-node {
+
+			/* test bus */
+			selftestbus: test-bus {
+				compatible = "simple-bus";
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				selftest100: test-selftest100 {
+					compatible = "selftest";
+					status = "okay";
+					reg = <100>;
+				};
+
+				selftest101: test-selftest101 {
+					compatible = "selftest";
+					status = "disabled";
+					reg = <101>;
+				};
+
+				selftest0: test-selftest0 {
+					compatible = "selftest";
+					status = "disabled";
+					reg = <0>;
+				};
+
+				selftest1: test-selftest1 {
+					compatible = "selftest";
+					status = "okay";
+					reg = <1>;
+				};
+
+				selftest2: test-selftest2 {
+					compatible = "selftest";
+					status = "disabled";
+					reg = <2>;
+				};
+
+				selftest3: test-selftest3 {
+					compatible = "selftest";
+					status = "okay";
+					reg = <3>;
+				};
+
+				selftest5: test-selftest5 {
+					compatible = "selftest";
+					status = "disabled";
+					reg = <5>;
+				};
+			};
+		};
+
+		/* test enable using absolute target path */
+		overlay0 {
+			fragment@0 {
+				target-path = "/testcase-data/overlay-node/test-bus/test-selftest0";
+				__overlay__ {
+					status = "okay";
+				};
+			};
+		};
+
+		/* test disable using absolute target path */
+		overlay1 {
+			fragment@0 {
+				target-path = "/testcase-data/overlay-node/test-bus/test-selftest1";
+				__overlay__ {
+					status = "disabled";
+				};
+			};
+		};
+
+		/* test enable using label */
+		overlay2 {
+			fragment@0 {
+				target = <&selftest2>;
+				__overlay__ {
+					status = "okay";
+				};
+			};
+		};
+
+		/* test disable using label */
+		overlay3 {
+			fragment@0 {
+				target = <&selftest3>;
+				__overlay__ {
+					status = "disabled";
+				};
+			};
+		};
+
+		/* test insertion of a full node */
+		overlay4 {
+			fragment@0 {
+				target = <&selftestbus>;
+				__overlay__ {
+
+					/* suppress DTC warning */
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					test-selftest4 {
+						compatible = "selftest";
+						status = "okay";
+						reg = <4>;
+					};
+				};
+			};
+		};
+
+		/* test overlay apply revert */
+		overlay5 {
+			fragment@0 {
+				target-path = "/testcase-data/overlay-node/test-bus/test-selftest5";
+				__overlay__ {
+					status = "okay";
+				};
+			};
+		};
+	};
+};
-- 
1.7.12

