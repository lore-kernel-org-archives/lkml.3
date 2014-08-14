Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaHNQsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 12:48:17 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:35145
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751304AbaHNQsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 12:48:15 -0400
X-WSS-ID: 0NAB2NW-07-D2X-02
X-M-MSG: 
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: <clemens@ladisch.de>, <linux@roeck-us.net>, <jdelvare@suse.de>,
        <rdunlap@infradead.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <bp@suse.de>
CC: <dan.carpenter@oracle.com>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Aravind Gopalakrishnan" <aravind.gopalakrishnan@amd.com>
Subject: [PATCH V2] hwmon, k10temp: Add support for F15h M60h
Date: Thu, 14 Aug 2014 11:54:22 -0500
Message-ID: <1408035262-18026-1-git-send-email-aravind.gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(199003)(189002)(77982001)(87286001)(81542001)(4396001)(19580395003)(97736001)(36756003)(68736004)(106466001)(229853001)(84676001)(81342001)(76482001)(85306004)(575784001)(2201001)(86362001)(85852003)(83322001)(89996001)(46102001)(44976005)(77096002)(19580405001)(101416001)(74662001)(31966008)(53416004)(21056001)(64706001)(80022001)(95666004)(74502001)(50466002)(99396002)(50986999)(50226001)(88136002)(87936001)(105586002)(102836001)(93916002)(107046002)(79102001)(104166001)(47776003)(77156001)(92726001)(92566001)(48376002)(83072002)(33646002)(62966002)(20776003)(19627235001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB045;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
Changes in V2:
 - Prevent race with other code that may require indirect NB_SMU_REG access
 - Fix some minor style issues

 Documentation/hwmon/k10temp   |  2 +-
 arch/x86/include/asm/amd_nb.h |  2 ++
 arch/x86/kernel/amd_nb.c      | 15 +++++++++++++++
 drivers/hwmon/Kconfig         |  6 +++---
 drivers/hwmon/k10temp.c       | 22 +++++++++++++++++++---
 5 files changed, 40 insertions(+), 7 deletions(-)

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
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index aaac3b2..e2bf43d 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -20,6 +20,8 @@ extern void amd_flush_garts(void);
 extern int amd_numa_init(void);
 extern int amd_get_subcaches(int);
 extern int amd_set_subcaches(int, unsigned long);
+/* helper function for reading from NB_SMU_IND_DATA */
+extern void amd_nb_smu_index_read(struct pci_dev *, unsigned int, int, u32 *);
 
 struct amd_l3_cache {
 	unsigned indices;
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index f04dbb3..6008e1d 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -13,6 +13,9 @@
 #include <linux/spinlock.h>
 #include <asm/amd_nb.h>
 
+/* Provide lock for writing to NB_SMU_IND_ADDR */
+DEFINE_MUTEX(nb_smu_ind_mutex);
+
 static u32 *flush_words;
 
 const struct pci_device_id amd_nb_misc_ids[] = {
@@ -221,6 +224,18 @@ int amd_set_subcaches(int cpu, unsigned long mask)
 	return 0;
 }
 
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
+EXPORT_SYMBOL_GPL(amd_nb_smu_index_read);
+
 static int amd_cache_gart(void)
 {
 	u16 i;
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 02d3d85..0234a08 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -275,13 +275,13 @@ config SENSORS_K8TEMP
 
 config SENSORS_K10TEMP
 	tristate "AMD Family 10h+ temperature sensor"
-	depends on X86 && PCI
+	depends on X86 && PCI && AMD_NB
 	help
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
index f7b46f6..c7422c5 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <asm/processor.h>
+#include <asm/amd_nb.h>
 
 MODULE_DESCRIPTION("AMD Family 10h+ CPU core temperature monitor");
 MODULE_AUTHOR("Clemens Ladisch <clemens@ladisch.de>");
@@ -51,13 +52,27 @@ MODULE_PARM_DESC(force, "force loading on processors with erratum 319");
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
 
@@ -211,6 +226,7 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
 	{}
-- 
2.0.3

