Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaBKRwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:52:50 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:55941 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751614AbaBKRws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:52:48 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v2 1/2] mfd: syscon: Add platform data with a regmap config name
Date: Tue, 11 Feb 2014 17:52:44 +0000
Message-Id: <1392141165-14338-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140211174829.GJ15081@lee--X1>
References: <20140211174829.GJ15081@lee--X1>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define syscon platform data structure that can be used
to define a regmap config name. This is particularly useful
in the regmap debugfs when there is more than one syscon
device registered, to distinguish the register blocks.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/syscon.c                 | 4 ++++
 include/linux/platform_data/syscon.h | 8 ++++++++
 2 files changed, 12 insertions(+)
 create mode 100644 include/linux/platform_data/syscon.h

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 71841f9..854b8d9 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -18,6 +18,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
+#include <linux/platform_data/syscon.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/mfd/syscon.h>
@@ -126,6 +127,7 @@ static struct regmap_config syscon_regmap_config = {
 static int syscon_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct syscon_platform_data *pdata = dev_get_platdata(dev);
 	struct syscon *syscon;
 	struct resource *res;
 	void __iomem *base;
@@ -143,6 +145,8 @@ static int syscon_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	syscon_regmap_config.max_register = res->end - res->start - 3;
+	if (pdata)
+		syscon_regmap_config.name = pdata->label;
 	syscon->regmap = devm_regmap_init_mmio(dev, base,
 					&syscon_regmap_config);
 	if (IS_ERR(syscon->regmap)) {
diff --git a/include/linux/platform_data/syscon.h b/include/linux/platform_data/syscon.h
new file mode 100644
index 0000000..921e59a
--- /dev/null
+++ b/include/linux/platform_data/syscon.h
@@ -0,0 +1,8 @@
+#ifndef PLATFORM_DATA_SYSCON_H
+#define PLATFORM_DATA_SYSCON_H
+
+struct syscon_platform_data {
+	        const char *label;
+};
+
+#endif
-- 
1.8.3.2

