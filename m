Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaLQXRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:17:03 -0500
Received: from mail-bn1on0136.outbound.protection.outlook.com ([157.56.110.136]:46880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751456AbaLQXQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:16:59 -0500
X-WSS-ID: 0NGR205-07-0IE-02
X-M-MSG: 
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <arnd@arndb.de>, <mjg59@srcf.ucam.org>
CC: <hanjun.guo@linaro.org>, <leo.duran@amd.com>, <graeme.gregory@linaro.org>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [RFC PATCH 2/2] ata: ahci_platform: Add ACPI _CLS matching
Date: Wed, 17 Dec 2014 17:16:35 -0600
Message-ID: <1418858195-22857-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418858195-22857-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1418858195-22857-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(50226001)(46102003)(48376002)(86362001)(2201001)(99396003)(33646002)(92566001)(77156002)(77096005)(101416001)(19580405001)(62966003)(68736005)(31966008)(36756003)(47776003)(20776003)(19580395003)(50466002)(64706001)(84676001)(21056001)(53416004)(107046002)(120916001)(106466001)(50986999)(97736003)(4396001)(89996001)(229853001)(76176999)(2950100001)(87936001)(105586002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB207;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB207;
X-Forefront-PRVS: 042857DBB5
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB207;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch adds ACPI supports for AHCI platform driver, which uses _CLS
method to match the device.

The following is an example of ASL structure in DSDT for a SATA controller,
which contains _CLS package to be matched by the ahci_platform driver:

  Device (AHC0) // AHCI Controller
  {
    Name(_HID, "AMDI0600")
    Name (_CCA, 1)
    Name (_CLS, Package (3)
    {
      0x01, // Base Class: Mass Storage
      0x06, // Sub-Class: serial ATA
      0x01, // Interface: AHCI
    })
    Name (_CRS, ResourceTemplate ()
    {
      Memory32Fixed (ReadWrite, 0xE0300000, 0x00010000)
      Interrupt (ResourceConsumer, Level, ActiveHigh, Exclusive,,,) { 387 }
    })
  }

Also, since ATA driver should not require PCI support for ATA_ACPI,
this patch removes dependency in the driver/ata/Kconfig.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 drivers/ata/Kconfig         |  2 +-
 drivers/ata/ahci_platform.c | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index cd4cccb..edb00c6 100644
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
index 06f1d59..54568ec 100644
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
@@ -71,6 +74,10 @@ static const struct of_device_id ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
 
+#ifdef CONFIG_ATA_ACPI
+static const struct acpi_device_cls ahci_cls = {0x01, 0x06, 0x01};
+#endif
+
 static struct platform_driver ahci_driver = {
 	.probe = ahci_probe,
 	.remove = ata_platform_remove_one,
@@ -78,6 +85,9 @@ static struct platform_driver ahci_driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
 		.of_match_table = ahci_of_match,
+#ifdef CONFIG_ATA_ACPI
+		.acpi_cls = &ahci_cls,
+#endif
 		.pm = &ahci_pm_ops,
 	},
 };
-- 
1.9.3

