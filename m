Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaIIUh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:37:29 -0400
Received: from mail-by2on0141.outbound.protection.outlook.com ([207.46.100.141]:3811
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752341AbaIIUh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:37:26 -0400
X-WSS-ID: 0NBNIM8-07-36G-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <tj@kernel.org>, <hdegoede@redhat.com>
CC: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH] ata: ahci_platform: Add ACPI support for AMD Seattle SATA controller
Date: Tue, 9 Sep 2014 15:37:15 -0500
Message-ID: <1410295035-14471-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019018)(6009001)(428002)(199003)(189002)(77096002)(21056001)(77156001)(48376002)(50226001)(50466002)(99396002)(4396001)(53416004)(33646002)(76482001)(77982001)(46102001)(79102001)(50986999)(90102001)(95666004)(62966002)(102836001)(104166001)(87286001)(19580395003)(74502001)(84676001)(229853001)(101416001)(105586002)(107046002)(106466001)(81342001)(80022001)(44976005)(64706001)(36756003)(47776003)(97736003)(89996001)(20776003)(81542001)(87936001)(74662001)(93916002)(19580405001)(83322001)(92726001)(83072002)(85306004)(85852003)(86152002)(88136002)(86362001)(68736004)(92566001)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB044;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch adds ACPI support for non-PCI SATA contoller in ahci_platform driver.
It adds ACPI matching table in ahci_platform to support AMD Seattle SATA controller
with following ASL structure in DSDT:

    Device (SATA0)
    {
      Name(_HID, "AMDI0600")	// Seattle AHSATA
      Name (_CCA, 1)		// Cache-coherent controller
      Name (_CRS, ResourceTemplate ()
      {
        Memory32Fixed (ReadWrite, 0xE0300000, 0x00010000)
        Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive,,,) { 387 }
      })
    }

Since ATA driver should not require PCI support for ATA_ACPI,
this patch also removes dependency in the driver/ata/Kconfig.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 drivers/ata/Kconfig         |  2 +-
 drivers/ata/ahci_platform.c | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e1b9278..f2e6c9e 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -48,7 +48,7 @@ config ATA_VERBOSE_ERROR
 
 config ATA_ACPI
 	bool "ATA ACPI Support"
-	depends on ACPI && PCI
+	depends on ACPI
 	default y
 	help
 	  This option adds support for ATA-related ACPI objects.
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index f61ddb9..3499bab 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -20,6 +20,9 @@
 #include <linux/platform_device.h>
 #include <linux/libata.h>
 #include <linux/ahci_platform.h>
+#ifdef CONFIG_ATA_ACPI
+#include <linux/acpi.h>
+#endif
 #include "ahci.h"
 
 static const struct ata_port_info ahci_port_info = {
@@ -87,6 +90,13 @@ static const struct of_device_id ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
 
+#ifdef CONFIG_ATA_ACPI
+static const struct acpi_device_id ahci_acpi_match[] = {
+	{ "AMDI0600", 0 }, /* AMD Seattle AHCI */
+	{ },
+};
+#endif
+
 static struct platform_driver ahci_driver = {
 	.probe = ahci_probe,
 	.remove = ata_platform_remove_one,
@@ -94,6 +104,9 @@ static struct platform_driver ahci_driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
 		.of_match_table = ahci_of_match,
+#ifdef CONFIG_ATA_ACPI
+		.acpi_match_table = ACPI_PTR(ahci_acpi_match),
+#endif
 		.pm = &ahci_pm_ops,
 	},
 };
-- 
1.9.3

