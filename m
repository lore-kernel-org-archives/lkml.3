Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbaGNTk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:40:27 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:49753
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754843AbaGNTkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:40:19 -0400
X-WSS-ID: 0N8PVYT-07-8L2-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <clemens@ladisch.de>, <jdelvare@suse.de>, <linux@roeck-us.net>,
        <rdunlap@infradead.org>, <bhelgaas@google.com>,
        <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] hwmon, k10temp: Add support for AMD F15h M60h processor
Date: Mon, 14 Jul 2014 15:23:08 -0500
Message-ID: <1405369388-12729-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(36756003)(64706001)(4396001)(89996001)(31966008)(102836001)(104166001)(48376002)(76482001)(86362001)(84676001)(50466002)(575784001)(19580395003)(53416004)(83072002)(229853001)(101416001)(85852003)(2201001)(77982001)(21056001)(85306003)(50226001)(92726001)(87286001)(74502001)(99396002)(97736001)(74662001)(87936001)(77096002)(80022001)(81542001)(46102001)(50986999)(107046002)(20776003)(47776003)(95666004)(93916002)(83322001)(79102001)(92566001)(62966002)(19580405001)(81342001)(105586002)(77156001)(68736004)(2101003)(19627235001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB044;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02723F29C4
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds temperature monitoring support for F15h M60h processor.
 - Add new pci device id for the relevant processor
 - The functionality of REG_REPORTED_TEMPERATURE is moved to
   D0F0xBC_xD820_0CA4 [Reported Temperature Control]
   - So, use this to get CUR_TEMP value
 - Add Kconfig, Doc entries to indicate support for this processor.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 Documentation/hwmon/k10temp |  2 +-
 drivers/hwmon/Kconfig       |  4 ++--
 drivers/hwmon/k10temp.c     | 22 ++++++++++++++++++++--
 include/linux/pci_ids.h     |  1 +
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/Documentation/hwmon/k10temp b/Documentation/hwmon/k10temp
index ee6d30e..254d2f5 100644
--- a/Documentation/hwmon/k10temp
+++ b/Documentation/hwmon/k10temp
@@ -11,7 +11,7 @@ Supported chips:
   Socket S1G2: Athlon (X2), Sempron (X2), Turion X2 (Ultra)
 * AMD Family 12h processors: "Llano" (E2/A4/A6/A8-Series)
 * AMD Family 14h processors: "Brazos" (C/E/G/Z-Series)
-* AMD Family 15h processors: "Bulldozer" (FX-Series), "Trinity", "Kaveri"
+* AMD Family 15h processors: "Bulldozer" (FX-Series), "Trinity", "Kaveri", "Carrizo"
 * AMD Family 16h processors: "Kabini", "Mullins"
 
   Prefix: 'k10temp'
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 02d3d85..57ba400 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -280,8 +280,8 @@ config SENSORS_K10TEMP
 	  If you say yes here you get support for the temperature
 	  sensor(s) inside your CPU. Supported are later revisions of
 	  the AMD Family 10h and all revisions of the AMD Family 11h,
-	  12h (Llano), 14h (Brazos), 15h (Bulldozer/Trinity/Kaveri) and
-	  16h (Kabini/Mullins) microarchitectures.
+	  12h (Llano), 14h (Brazos), 15h (Bulldozer/Trinity/Kaveri/Carrizo)
+	  and 16h (Kabini/Mullins) microarchitectures.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called k10temp.
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index f7b46f6..5da872f 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -51,13 +51,30 @@ MODULE_PARM_DESC(force, "force loading on processors with erratum 319");
 #define REG_NORTHBRIDGE_CAPABILITIES	0xe8
 #define  NB_CAP_HTC			0x00000400
 
+/*
+ * For F15h M60h, functionality of REG_REPORTED_TEMPERATURE
+ * has been moved to D0F0xBC_xD820_0CA4 [Reported Temperature
+ * Control]
+ */
+#define NB_SMU_IND_ADDR			0xb8
+#define NB_SMU_IND_DATA			0xbc
+#define IND_ADDR_OFFSET			0xd8200ca4
+
 static ssize_t show_temp(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	u32 regval;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model == 0x60) {
+		pci_bus_write_config_dword(pdev->bus, PCI_DEVFN(0, 0),
+					   NB_SMU_IND_ADDR, IND_ADDR_OFFSET);
+		pci_bus_read_config_dword(pdev->bus, PCI_DEVFN(0, 0),
+					  NB_SMU_IND_DATA, &regval);
+
+	} else
+		pci_read_config_dword(pdev, REG_REPORTED_TEMPERATURE, &regval);
 
-	pci_read_config_dword(to_pci_dev(dev),
-			      REG_REPORTED_TEMPERATURE, &regval);
 	return sprintf(buf, "%u\n", (regval >> 21) * 125);
 }
 
@@ -211,6 +228,7 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
 	{}
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 7fa3173..3c8e328 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -520,6 +520,7 @@
 #define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
 #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F3 0x141d
 #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F4 0x141e
+#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F3 0x1573
 #define PCI_DEVICE_ID_AMD_15H_NB_F0	0x1600
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
-- 
1.8.1.2

