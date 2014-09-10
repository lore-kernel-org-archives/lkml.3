Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaIJRJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:09:01 -0400
Received: from mail-bl2on0111.outbound.protection.outlook.com ([65.55.169.111]:3439
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750882AbaIJRI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:08:59 -0400
X-WSS-ID: 0NBP2VD-07-KBJ-02
X-M-MSG: 
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: <herrmann.der.user@googlemail.com>, <linux@roeck-us.net>,
        <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Subject: [PATCH] hwmon, fam15h_power: Add support for two more processors
Date: Wed, 10 Sep 2014 12:02:08 -0500
Message-ID: <1410368528-4738-1-git-send-email-aravind.gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(428002)(189002)(199003)(20776003)(86362001)(36756003)(101416001)(102836001)(229853001)(92566001)(89996001)(87936001)(97736003)(81542001)(88136002)(93916002)(87286001)(84676001)(80022001)(104166001)(50226001)(106466001)(107046002)(64706001)(4396001)(47776003)(77156001)(77096002)(50466002)(62966002)(81342001)(53416004)(105586002)(95666004)(74502001)(31966008)(74662001)(44976005)(19580405001)(19580395003)(83322001)(50986999)(83072002)(90102001)(68736004)(92726001)(2201001)(76482001)(85852003)(77982001)(46102001)(85306004)(99396002)(48376002)(21056001)(79102001)(33646002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB039;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fam16h,M30h(Mullins) and Fam15hM30h(Kaveri) processors can
report 'power_crit' value. So, adding their respective device ids.

Also, according to BKDGs, the 'TdpRunAvgAccCap' that show_power()
uses is valid only on Fam15h, Models 0x0-0xF. On all other processors
the field is 'Reserved'. So, return error if we are on any other family/model.

Impact on lm-sensors is minimal. On such families, instead of reporting
Current power value as '0', we now have:
power1:           N/A

Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
---
 drivers/hwmon/fam15h_power.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 4a7cbfa..b69bf7d 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -57,6 +57,10 @@ static ssize_t show_power(struct device *dev,
 	struct fam15h_power_data *data = dev_get_drvdata(dev);
 	struct pci_dev *f4 = data->pdev;
 
+	/* The value TdpRunAvgAccCap is valid only on F15h, Models 0x0-0xF */
+	if (boot_cpu_data.x86 != 0x15 || boot_cpu_data.x86_model > 0x0)
+		return -ENOSYS;
+
 	pci_bus_read_config_dword(f4->bus, PCI_DEVFN(PCI_SLOT(f4->devfn), 5),
 				  REG_TDP_RUNNING_AVERAGE, &val);
 	running_avg_capture = (val >> 4) & 0x3fffff;
@@ -216,7 +220,9 @@ static int fam15h_power_probe(struct pci_dev *pdev,
 
 static const struct pci_device_id fam15h_power_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
-- 
2.0.3

