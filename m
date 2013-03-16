Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab3CPNKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:10:12 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:48816 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3CPNKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:10:10 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] clk: add DT test clock consumer driver
Date: Sat, 16 Mar 2013 14:09:36 +0100
Message-Id: <1363439376-21294-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds a DT test clock consumer that exposes debugfs files to
enable/disable and set/get rate of the attached programmable clock.
During development of a i2c-attached clock generator I found it useful
to debug the clock generator's internal pll settings by enforcing clock
rates through debugfs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
---
 .../bindings/clock/test-clock-consumer.txt         |   19 ++
 drivers/clk/Kconfig                                |    6 +
 drivers/clk/Makefile                               |    3 +
 drivers/clk/clk-test.c                             |  183 ++++++++++++++++++++
 4 files changed, 211 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/test-clock-consumer.txt
 create mode 100644 drivers/clk/clk-test.c

diff --git a/Documentation/devicetree/bindings/clock/test-clock-consumer.txt b/Documentation/devicetree/bindings/clock/test-clock-consumer.txt
new file mode 100644
index 0000000..3e228ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/test-clock-consumer.txt
@@ -0,0 +1,19 @@
+* Test Clock Consumer
+
+The test clock consumer allows to debug clock providers by exposing
+debugfs files to enable/disable and set/get rate of attached clock
+respectively. It is especially useful for checking programmable clock
+generators, e.g. enforcing target clock rates to debug clock generator's
+pll settings. Currently, there is only one clock per test clock consumer
+supported but more than one test clock consumer can be added.
+
+Required properties:
+- compatible : shall be "test-clock-consumer"
+- clocks : phandle of the clock to debug
+
+Example:
+
+clock-consumer {
+	compatible = "test-clock-consumer";
+	clocks = <&programmable_clock>;
+};
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index a47e6ee..e23e471 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -33,6 +33,12 @@ config COMMON_CLK_DEBUG
 	  clk_flags, clk_prepare_count, clk_enable_count &
 	  clk_notifier_count.
 
+config COMMON_CLK_TEST_CONSUMER
+	tristate "Clock consumer test driver"
+	---help---
+	  This is a clock consumer test driver to allow testing clock
+	  provider through user space.
+
 config COMMON_CLK_WM831X
 	tristate "Clock driver for WM831x/2x PMICs"
 	depends on MFD_WM831X
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 300d477..095899e 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -34,3 +34,6 @@ obj-$(CONFIG_X86)		+= x86/
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
 obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
 obj-$(CONFIG_CLK_TWL6040)	+= clk-twl6040.o
+
+# Debug drivers
+obj-$(CONFIG_COMMON_CLK_TEST_CONSUMER) += clk-test.o
diff --git a/drivers/clk/clk-test.c b/drivers/clk/clk-test.c
new file mode 100644
index 0000000..08dd66b
--- /dev/null
+++ b/drivers/clk/clk-test.c
@@ -0,0 +1,183 @@
+/*
+ * clk-test.c: Common Clock Framework Test Clock Consumer
+ *
+ * (c) 2012 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/debugfs.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/of_platform.h>
+
+struct clock_consumer_data {
+	struct clk	*clk;
+	struct dentry	*clkdir;
+	const char	*name;
+	unsigned int	enabled;
+};
+
+static struct dentry *rootdir;
+
+static int clock_consumer_debug_rate_set(void *data, u64 val)
+{
+	struct clock_consumer_data *ccdata = (struct clock_consumer_data *)data;
+
+	if (!ccdata->enabled)
+		return -EBUSY;
+
+	return clk_set_rate(ccdata->clk, (unsigned long)val);
+}
+
+static int clock_consumer_debug_rate_get(void *data, u64 *val)
+{
+	struct clock_consumer_data *ccdata = (struct clock_consumer_data *)data;
+
+	if (!ccdata->enabled)
+		return -EBUSY;
+
+	*val = clk_get_rate(ccdata->clk);
+
+	return 0;
+}
+
+static int clock_consumer_debug_enable_set(void *data, u64 val)
+{
+	struct clock_consumer_data *ccdata = (struct clock_consumer_data *)data;
+
+	if ((val == ccdata->enabled) || (!val && !ccdata->enabled))
+		return 0;
+
+	ccdata->enabled = (val) ? 1 : 0;
+
+	if (ccdata->enabled)
+		return clk_prepare_enable(ccdata->clk);
+
+	clk_disable_unprepare(ccdata->clk);
+	return 0;
+}
+
+static int clock_consumer_debug_enable_get(void *data, u64 *val)
+{
+	struct clock_consumer_data *ccdata = (struct clock_consumer_data *)data;
+	*val = ccdata->enabled;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(clock_consumer_debug_ops_enable,
+			clock_consumer_debug_enable_get,
+			clock_consumer_debug_enable_set, "%llu\n");
+DEFINE_SIMPLE_ATTRIBUTE(clock_consumer_debug_ops_rate,
+			clock_consumer_debug_rate_get,
+			clock_consumer_debug_rate_set, "%llu\n");
+
+static int clock_consumer_debug_create_one(struct platform_device *pdev)
+{
+	struct clock_consumer_data *ccdata = platform_get_drvdata(pdev);
+	struct dentry *d;
+
+	if (!rootdir) {
+		rootdir = debugfs_create_dir("clk_consumer", NULL);
+		if (WARN_ON(IS_ERR_OR_NULL(rootdir)))
+			return -ENOMEM;
+	}
+
+	ccdata->clkdir = debugfs_create_dir(ccdata->name, rootdir);
+	if (WARN_ON(IS_ERR_OR_NULL(ccdata->clkdir)))
+		return -ENOMEM;
+
+	d = debugfs_create_file("enable", S_IRUGO | S_IWUGO, ccdata->clkdir,
+				ccdata, &clock_consumer_debug_ops_enable);
+	if (WARN_ON(IS_ERR_OR_NULL(d)))
+		goto err_out;
+
+	d = debugfs_create_file("rate", S_IRUGO | S_IWUGO, ccdata->clkdir,
+				ccdata, &clock_consumer_debug_ops_rate);
+	if (WARN_ON(IS_ERR_OR_NULL(d)))
+		goto err_out;
+
+	return 0;
+
+err_out:
+	debugfs_remove(ccdata->clkdir);
+	return -ENOMEM;
+}
+
+static struct of_device_id clock_consumer_of_match[] = {
+	{ .compatible = "test-clock-consumer", },
+	{ }
+};
+
+static int clock_consumer_probe(struct platform_device *pdev)
+{
+	struct clock_consumer_data *ccdata;
+	int ret;
+
+	ccdata = devm_kzalloc(&pdev->dev, sizeof(struct clock_consumer_data),
+			      GFP_KERNEL);
+	if (WARN_ON(!ccdata))
+		return -ENOMEM;
+
+	ccdata->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(ccdata->clk)) {
+		dev_err(&pdev->dev, "unable to get parent clock");
+		return PTR_RET(ccdata->clk);
+	}
+
+	platform_set_drvdata(pdev, ccdata);
+	ccdata->name = pdev->dev.of_node->name;
+
+	ret = clock_consumer_debug_create_one(pdev);
+	if (ret)
+		return ret;
+
+	dev_info(&pdev->dev, "installed clock consumer %s\n",
+		 ccdata->name);
+
+	return 0;
+}
+
+static int clock_consumer_remove(struct platform_device *pdev)
+{
+	struct clock_consumer_data *ccdata = platform_get_drvdata(pdev);
+
+	if (!ccdata || !ccdata->clkdir)
+		return 0;
+
+	debugfs_remove_recursive(ccdata->clkdir);
+	if (!IS_ERR(ccdata->clk) && ccdata->enabled)
+		clk_disable_unprepare(ccdata->clk);
+
+	dev_info(&pdev->dev, "removed clock consumer %s\n", ccdata->name);
+
+	if (rootdir && list_empty(&rootdir->d_subdirs))
+		debugfs_remove_recursive(rootdir);
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver clock_consumer_driver = {
+	.driver = {
+		.name = "clock-consumer",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(clock_consumer_of_match),
+	},
+	.probe = clock_consumer_probe,
+	.remove = clock_consumer_remove,
+};
+
+module_platform_driver(clock_consumer_driver);
+
+MODULE_AUTHOR("Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>");
+MODULE_DESCRIPTION("Common clock framwork test clock consumer driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.10.4

