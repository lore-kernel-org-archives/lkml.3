Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab3FRNsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:48:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:49031 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561Ab3FRNst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,889,1363158000"; 
   d="scan'208";a="331522425"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI / LPSS: override SDIO device's private register space size
Date: Tue, 18 Jun 2013 16:51:35 +0300
Message-Id: <1371563495-7325-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SDIO device in Lynxpoint has its LTR registers allocated for a WiFi
device (a child of the SDIO device) instead in ACPI namespace even though
they physically belong to the SDIO device. In order to be able to access
the LTR registers from the ACPI LPSS driver for diagnostic purposes we need
to enlarge size of this private register space.

Work around this by adding a possibility to override size of the private
register space in the ACPI LPSS driver and set correct size for the SDIO
device.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Applies on top of https://patchwork.kernel.org/patch/2742521/ (ACPI / LPSS:
Power up LPSS devices during enumeration)

 drivers/acpi/acpi_lpss.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index a14d997..539aeae 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -44,6 +44,7 @@ struct lpss_device_desc {
 	const char *clkdev_name;
 	bool ltr_required;
 	unsigned int prv_offset;
+	size_t prv_size_override;
 	bool clk_gate;
 	struct lpss_shared_clock *shared_clock;
 };
@@ -69,6 +70,7 @@ static struct lpss_device_desc lpt_dev_desc = {
 
 static struct lpss_device_desc lpt_sdio_dev_desc = {
 	.prv_offset = 0x1000,
+	.prv_size_override = 0x1018,
 	.ltr_required = true,
 };
 
@@ -226,7 +228,10 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
 
 	list_for_each_entry(rentry, &resource_list, node)
 		if (resource_type(&rentry->res) == IORESOURCE_MEM) {
-			pdata->mmio_size = resource_size(&rentry->res);
+			if (dev_desc->prv_size_override)
+				pdata->mmio_size = dev_desc->prv_size_override;
+			else
+				pdata->mmio_size = resource_size(&rentry->res);
 			pdata->mmio_base = ioremap(rentry->res.start,
 						   pdata->mmio_size);
 			pdata->dev_desc = dev_desc;
-- 
1.8.3.1

