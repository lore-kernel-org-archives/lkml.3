Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbbAEVMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:12:05 -0500
Received: from mail-by2on0129.outbound.protection.outlook.com ([207.46.100.129]:19184
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753922AbbAEVLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:11:41 -0500
X-WSS-ID: 0NHQ2V8-08-U88-02
X-M-MSG: 
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <arnd@arndb.de>, <mjg59@srcf.ucam.org>,
        <grant.likely@linaro.org>
CC: <hanjun.guo@linaro.org>, <al.stone@linaro.org>,
        <graeme.gregory@linaro.org>, <leo.duran@amd.com>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [V2 PATCH 2/2] ata: ahci_platform: Add ACPI _CLS matching
Date: Mon, 5 Jan 2015 15:11:15 -0600
Message-ID: <1420492275-6878-3-git-send-email-Suravee.Suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420492275-6878-1-git-send-email-Suravee.Suthikulpanit@amd.com>
References: <1420492275-6878-1-git-send-email-Suravee.Suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(31966008)(36756003)(101416001)(87936001)(4396001)(50226001)(77096005)(89996001)(2201001)(68736005)(21056001)(2950100001)(92566001)(86362001)(53416004)(77156002)(97736003)(62966003)(50986999)(76176999)(105586002)(106466001)(229853001)(107046002)(99396003)(120916001)(46102003)(19580395003)(84676001)(19580405001)(48376002)(50466002)(20776003)(47776003)(64706001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR02MB200;
X-Forefront-PRVS: 0447DB1C71
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2015 21:11:35.8217
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.222]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB200
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

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 drivers/ata/Kconfig         | 2 +-
 drivers/ata/ahci_platform.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index a3a1360..edca892 100644
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
index 18d5398..ae66974 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -71,12 +71,15 @@ static const struct of_device_id ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
 
+static const struct acpi_device_cls ahci_cls = {0x01, 0x06, 0x01};
+
 static struct platform_driver ahci_driver = {
 	.probe = ahci_probe,
 	.remove = ata_platform_remove_one,
 	.driver = {
 		.name = "ahci",
 		.of_match_table = ahci_of_match,
+		.acpi_match_cls = &ahci_cls,
 		.pm = &ahci_pm_ops,
 	},
 };
-- 
1.9.3

