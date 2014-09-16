Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaIPCdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 22:33:45 -0400
Received: from mail-bn1on0132.outbound.protection.outlook.com ([157.56.110.132]:11728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752716AbaIPCdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 22:33:38 -0400
X-WSS-ID: 0NBZ33N-08-TSU-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-apci@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <astone@redhat.com>,
        <hanjun.guo@linaro.org>, <rjw@rjwysocki.net>, <marc.zyngier@arm.com>,
        <mark.rutland@arm.com>, <Sudeep.Holla@arm.com>, <olof@lixom.net>,
        <grant.likely@linaro.org>, <graeme.gregory@linaro.org>,
        <arnd@arndb.de>, <jason@lakedaemon.net>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 1/4] ata: ahci_platform: Add ACPI support for AMD Seattle SATA controller
Date: Mon, 15 Sep 2014 19:47:23 -0500
Message-ID: <1410828446-28502-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1410828446-28502-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(85852003)(62966002)(20776003)(77096002)(106466001)(87286001)(87936001)(86152002)(89996001)(31966008)(83322001)(229853001)(53416004)(76176999)(85306004)(105586002)(2201001)(33646002)(101416001)(86362001)(97736003)(44976005)(48376002)(68736004)(93916002)(99396002)(90102001)(50226001)(50986999)(102836001)(92566001)(36756003)(92726001)(47776003)(104166001)(21056001)(88136002)(83072002)(77156001)(107046002)(84676001)(4396001)(76482001)(19580405001)(19580395003)(74662003)(74502003)(81342003)(81542003)(80022003)(79102003)(95666004)(77982003)(46102003)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB018;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch adds ACPI match table in ahci_platform. The table includes
the acpi_device_id to match AMD Seattle SATA controller with following
asl structure in DSDT:

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

Also, since ATA driver should not require PCI support for ATA_ACPI,
this patch removes dependency in the driver/ata/Kconfig.
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

