Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaLSU2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:28:42 -0500
Received: from mail-bn1bon0117.outbound.protection.outlook.com ([157.56.111.117]:44384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751281AbaLSU2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:28:39 -0500
X-Greylist: delayed 162703 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Dec 2014 15:28:39 EST
X-WSS-ID: 0NGUIUG-07-ZFI-02
X-M-MSG: 
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <arnd@arndb.de>, <mjg59@srcf.ucam.org>
CC: <hanjun.guo@linaro.org>, <al.stone@linaro.org>,
        <graeme.gregory@linaro.org>, <leo.duran@amd.com>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 2/2] ata: ahci_platform: Add ACPI _CLS matching
Date: Fri, 19 Dec 2014 14:13:08 -0600
Message-ID: <1419019988-4398-3-git-send-email-Suravee.Suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419019988-4398-1-git-send-email-Suravee.Suthikulpanit@amd.com>
References: <1419019988-4398-1-git-send-email-Suravee.Suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(20776003)(76176999)(48376002)(77156002)(229853001)(68736005)(84676001)(50986999)(62966003)(2201001)(92566001)(87936001)(64706001)(50466002)(86362001)(19580405001)(19580395003)(50226001)(53416004)(4396001)(2950100001)(77096005)(21056001)(97736003)(107046002)(46102003)(106466001)(120916001)(105586002)(101416001)(99396003)(36756003)(89996001)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB198;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2014 20:13:31.1580
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/ata/Kconfig         | 2 +-
 drivers/ata/ahci_platform.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

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
index 06f1d59..4879f9b 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -71,6 +71,8 @@ static const struct of_device_id ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
 
+static const struct acpi_device_cls ahci_cls = {0x01, 0x06, 0x01};
+
 static struct platform_driver ahci_driver = {
 	.probe = ahci_probe,
 	.remove = ata_platform_remove_one,
@@ -78,6 +80,7 @@ static struct platform_driver ahci_driver = {
 		.name = "ahci",
 		.owner = THIS_MODULE,
 		.of_match_table = ahci_of_match,
+		.acpi_cls = &ahci_cls,
 		.pm = &ahci_pm_ops,
 	},
 };
-- 
1.9.3

