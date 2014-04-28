Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbaD1Txe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:53:34 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:28071 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933078AbaD1Tx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:53:29 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 03/10] mfd: syscon: Add platform data with a regmap config name
Date: Mon, 28 Apr 2014 18:57:50 +0100
Message-Id: <1398707877-22596-4-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
References: <1398707877-22596-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define syscon platform data structure that can be used
to define a regmap config name. This is particularly useful
in the regmap debugfs when there is more than one syscon
device registered, to distinguish the register blocks.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/syscon.c                 | 4 ++++
 include/linux/platform_data/syscon.h | 8 ++++++++
 2 files changed, 12 insertions(+)
 create mode 100644 include/linux/platform_data/syscon.h

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index dbea55d..e2a04bb 100644
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
@@ -119,6 +120,7 @@ static struct regmap_config syscon_regmap_config = {
 static int syscon_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
+	struct syscon_platform_data *pdata = dev_get_platdata(dev);
 	struct syscon *syscon;
 	struct resource *res;
 	void __iomem *base;
@@ -136,6 +138,8 @@ static int syscon_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	syscon_regmap_config.max_register = res->end - res->start - 3;
+	if (pdata)
+		syscon_regmap_config.name = pdata->label;
 	syscon->regmap = devm_regmap_init_mmio(dev, base,
 					&syscon_regmap_config);
 	if (IS_ERR(syscon->regmap)) {
diff --git a/include/linux/platform_data/syscon.h b/include/linux/platform_data/syscon.h
new file mode 100644
index 0000000..2354c6f
--- /dev/null
+++ b/include/linux/platform_data/syscon.h
@@ -0,0 +1,8 @@
+#ifndef PLATFORM_DATA_SYSCON_H
+#define PLATFORM_DATA_SYSCON_H
+
+struct syscon_platform_data {
+	const char *label;
+};
+
+#endif
-- 
1.9.1

