Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaHNXJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 19:09:06 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:48773
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754494AbaHNXJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 19:09:04 -0400
X-WSS-ID: 0NABKAW-07-9IJ-02
X-M-MSG: 
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: <clemens@ladisch.de>, <linux@roeck-us.net>, <jdelvare@suse.de>,
        <rdunlap@infradead.org>, <bp@suse.de>
CC: <lm-sensors@lm-sensors.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Subject: [PATCH V3] hwmon, k10temp: Add support for F15h M60h
Date: Thu, 14 Aug 2014 18:15:27 -0500
Message-ID: <1408058127-19374-1-git-send-email-aravind.gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(199003)(189002)(92726001)(77156001)(48376002)(74662001)(74502001)(104166001)(106466001)(93916002)(97736001)(4396001)(62966002)(80022001)(102836001)(575784001)(88136002)(83072002)(68736004)(53416004)(87936001)(85852003)(31966008)(92566001)(2201001)(105586002)(46102001)(83322001)(50226001)(229853001)(50466002)(33646002)(81342001)(44976005)(47776003)(19580395003)(99396002)(107046002)(84676001)(77096002)(76482001)(87286001)(50986999)(81542001)(19580405001)(86362001)(89996001)(64706001)(101416001)(85306004)(77982001)(21056001)(36756003)(79102001)(95666004)(20776003)(19627235001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB038;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03030B9493
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds temperature monitoring support for F15h M60h processor.
 - Add new pci device id for the relevant processor
 - The functionality of REG_REPORTED_TEMPERATURE is moved to
   D0F0xBC_xD820_0CA4 [Reported Temperature Control]
   - So, use this to get CUR_TEMP value
   - Since we need an indirect register access, protect this with
     a mutex lock
 - Add Kconfig, Doc entries to indicate support for this processor.

Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
---
Changes in V3:
 - Move helper function that protects indirect register access locally
   until a time when others outside k10temp may need it
   
Changes in V2:
 - Prevent race with other code that may require indirect NB_SMU_REG access
 - Fix some minor style issues

 Documentation/hwmon/k10temp |  2 +-
 drivers/hwmon/Kconfig       |  4 ++--
 drivers/hwmon/k10temp.c     | 35 ++++++++++++++++++++++++++++++++---
 3 files changed, 35 insertions(+), 6 deletions(-)

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
index f7b46f6..36ea152 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -33,6 +33,9 @@ static bool force;
 module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "force loading on processors with erratum 319");
 
+/* Provide lock for writing to NB_SMU_IND_ADDR */
+DEFINE_MUTEX(nb_smu_ind_mutex);
+
 /* CPUID function 0x80000001, ebx */
 #define CPUID_PKGTYPE_MASK	0xf0000000
 #define CPUID_PKGTYPE_F		0x00000000
@@ -51,13 +54,38 @@ MODULE_PARM_DESC(force, "force loading on processors with erratum 319");
 #define REG_NORTHBRIDGE_CAPABILITIES	0xe8
 #define  NB_CAP_HTC			0x00000400
 
+/*
+ * For F15h M60h, functionality of REG_REPORTED_TEMPERATURE
+ * has been moved to D0F0xBC_xD820_0CA4 [Reported Temperature
+ * Control]
+ */
+#define F15H_M60H_REPORTED_TEMP_CTRL_OFFSET	0xd8200ca4
+#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F3	0x1573
+
+void amd_nb_smu_index_read(struct pci_dev *pdev, unsigned int devfn,
+			   int offset, u32 *val)
+{
+	mutex_lock(&nb_smu_ind_mutex);
+	pci_bus_write_config_dword(pdev->bus, devfn,
+				   0xb8, offset);
+	pci_bus_read_config_dword(pdev->bus, devfn,
+				  0xbc, val);
+	mutex_unlock(&nb_smu_ind_mutex);
+}
+
 static ssize_t show_temp(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	u32 regval;
-
-	pci_read_config_dword(to_pci_dev(dev),
-			      REG_REPORTED_TEMPERATURE, &regval);
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model == 0x60) {
+		amd_nb_smu_index_read(pdev, PCI_DEVFN(0, 0),
+				      F15H_M60H_REPORTED_TEMP_CTRL_OFFSET,
+				      &regval);
+	} else {
+		pci_read_config_dword(pdev, REG_REPORTED_TEMPERATURE, &regval);
+	}
 	return sprintf(buf, "%u\n", (regval >> 21) * 125);
 }
 
@@ -211,6 +239,7 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
 	{}
-- 
2.0.3

