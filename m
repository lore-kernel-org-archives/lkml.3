Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab3CGAaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:30:17 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24853 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259Ab3CGA3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:29:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,798,1355126400"; 
   d="scan'208";a="27969702"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 6/6] RFC: SSBI: Simple pm8058 test driver
Date: Wed,  6 Mar 2013 16:29:47 -0800
Message-Id: <1362616187-21089-7-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A very small ssbi device driver that reads the pm8058 version register
;and prints it out.

This isn't really a useful driver, hence the RFC, but it is useful for
someone wanting to test the SSBI driver itself.  Once the PMIC drivers
are finished, this isn't useful at all.

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/boot/dts/msm8660-surf.dts |  4 +++
 arch/arm/boot/dts/msm8960-cdp.dts  |  4 +++
 drivers/ssbi/Makefile              |  1 +
 drivers/ssbi/ssbi-test.c           | 61 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 70 insertions(+)
 create mode 100644 drivers/ssbi/ssbi-test.c

diff --git a/arch/arm/boot/dts/msm8660-surf.dts b/arch/arm/boot/dts/msm8660-surf.dts
index 67f8670..68a0c7c4 100644
--- a/arch/arm/boot/dts/msm8660-surf.dts
+++ b/arch/arm/boot/dts/msm8660-surf.dts
@@ -43,5 +43,9 @@
 		compatible = "qcom,ssbi";
 		reg = <0x500000 0x1000>;
 		qcom,controller-type = "pmic-arbiter";
+
+		qcom,ssbi-test {
+			compatible = "qcom,ssbi-test";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts
index c9b09a8..60804d7 100644
--- a/arch/arm/boot/dts/msm8960-cdp.dts
+++ b/arch/arm/boot/dts/msm8960-cdp.dts
@@ -43,5 +43,9 @@
 		compatible = "qcom,ssbi";
 		reg = <0x500000 0x1000>;
 		qcom,controller-type = "pmic-arbiter";
+
+		qcom,ssbi-test {
+			compatible = "qcom,ssbi-test";
+		};
 	};
 };
diff --git a/drivers/ssbi/Makefile b/drivers/ssbi/Makefile
index ea8c1e4..3561280 100644
--- a/drivers/ssbi/Makefile
+++ b/drivers/ssbi/Makefile
@@ -2,3 +2,4 @@
 # Makefile for the MSM specific device drivers.
 #
 obj-$(CONFIG_MSM_SSBI) += ssbi.o
+obj-$(CONFIG_MSM_SSBI) += ssbi-test.o
diff --git a/drivers/ssbi/ssbi-test.c b/drivers/ssbi/ssbi-test.c
new file mode 100644
index 0000000..dea4dd0
--- /dev/null
+++ b/drivers/ssbi/ssbi-test.c
@@ -0,0 +1,61 @@
+/* A simple ssbi test device. */
+
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/msm_ssbi.h>
+
+static int __init ssbi_test_probe(struct platform_device *pdev)
+{
+	int ret;
+	char version;
+
+	dev_info(&pdev->dev, "probe, me = %p, parent = %p\n",
+		 pdev, pdev->dev.parent);
+
+	/* Let's try reading. */
+	ret = msm_ssbi_read(pdev->dev.parent, 0x02, &version, 1);
+	if (ret != 0)
+		return ret;
+
+	dev_info(&pdev->dev, "Version = %02x\n", version);
+
+	/* Should already be hooked in. */
+	return 0;
+}
+
+static int ssbi_test_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct of_device_id ssbi_test_match_table[] = {
+	{ .compatible = "qcom,ssbi-test" },
+	{}
+};
+
+static struct platform_driver ssbi_test_driver = {
+	.remove = ssbi_test_remove,
+	.driver = {
+		.name = "sbbi_test",
+		.owner = THIS_MODULE,
+		.of_match_table = ssbi_test_match_table,
+	},
+};
+
+static int __init ssbi_test_init(void)
+{
+	int ret;
+
+	ret = platform_driver_probe(&ssbi_test_driver, ssbi_test_probe);
+	return ret;
+}
+
+static void __exit ssbi_test_exit(void)
+{
+}
+
+module_init(ssbi_test_init);
+module_exit(ssbi_test_exit);
+
+MODULE_LICENSE("GPL");
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

