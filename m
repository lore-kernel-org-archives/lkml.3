Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbaKMJGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:06:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:61760 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131AbaKMJFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:05:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,375,1413270000"; 
   d="scan'208";a="631269702"
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yegnesh Iyer <yegnesh.s.iyer@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] ACPI / pmic_opregion: AXP288: support virtual GPIO in ACPI table
Date: Thu, 13 Nov 2014 17:04:36 +0800
Message-Id: <1415869476-24329-4-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415869476-24329-1-git-send-email-aaron.lu@intel.com>
References: <1415869476-24329-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same virtual GPIO strategy is also used for the AXP288 PMIC in that
various control methods that are used to do power rail handling and
sensor reading/setting will touch GPIO fields defined under the PMIC
device. The GPIO fileds are only defined by the ACPI code while the
actual hardware doesn't really have a GPIO controller, but to make those
control method execution succeed, we have to install a GPIO handler for
the PMIC device handle. Since we do not need the virtual GPIO strategy,
we can simply do nothing in that handler.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/pmic/intel_pmic_xpower.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pmic/intel_pmic_xpower.c b/drivers/acpi/pmic/intel_pmic_xpower.c
index c24bf1a6e48a..dee68d6c20ab 100644
--- a/drivers/acpi/pmic/intel_pmic_xpower.c
+++ b/drivers/acpi/pmic/intel_pmic_xpower.c
@@ -251,13 +251,32 @@ static struct intel_soc_pmic_opregion_data intel_xpower_pmic_opregion_data = {
 	.dptf_table_count = ARRAY_SIZE(dptf_table),
 };
 
+static acpi_status intel_xpower_pmic_gpio_handler(u32 function,
+		acpi_physical_address address, u32 bit_width, u64 *value,
+		void *handler_context, void *region_context)
+{
+	return AE_OK;
+}
 
 static int intel_xpower_pmic_opregion_probe(struct platform_device *pdev)
 {
-	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
-	return intel_soc_pmic_install_opregion_handler(&pdev->dev,
-			ACPI_HANDLE(pdev->dev.parent), axp20x->regmap,
-			&intel_xpower_pmic_opregion_data);
+	struct device *parent = pdev->dev.parent;
+	struct axp20x_dev *axp20x = dev_get_drvdata(parent);
+	acpi_status status;
+	int result;
+
+	result = intel_soc_pmic_install_opregion_handler(&pdev->dev,
+					ACPI_HANDLE(parent), axp20x->regmap,
+					&intel_xpower_pmic_opregion_data);
+	if (!result) {
+		status = acpi_install_address_space_handler(
+				ACPI_HANDLE(parent), ACPI_ADR_SPACE_GPIO,
+				intel_xpower_pmic_gpio_handler, NULL, NULL);
+		if (ACPI_FAILURE(status))
+			result = -ENODEV;
+	}
+
+	return result;
 }
 
 static struct platform_driver intel_xpower_pmic_opregion_driver = {
-- 
1.9.3

