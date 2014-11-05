Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaKEGY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 01:24:28 -0500
Received: from mail-by2on0112.outbound.protection.outlook.com ([207.46.100.112]:7104
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751335AbaKEGYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 01:24:25 -0500
X-Greylist: delayed 885 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 01:24:24 EST
X-WSS-ID: 0NEJYFW-07-A9Q-02
X-M-MSG: 
From: Vincent Wan <vincent.wan@amd.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Arindam Nath <arindam.nath@amd.com>, Huang Rui <ray.huang@amd.com>,
        Wan Zongshun <mcuos.com@gmail.com>, Vincent Wan <vincent.wan@amd.com>
Subject: [PATCH v3 2/3] mmc:sdhci-pci: enable the clear transfer mode register quirk for AMD sdhci
Date: Wed, 5 Nov 2014 14:09:14 +0800
Message-ID: <1415167754-5801-1-git-send-email-vincent.wan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(44976005)(93916002)(97736003)(104166001)(33646002)(110136001)(68736004)(84676001)(19580395003)(19580405001)(102836001)(36756003)(87286001)(77096003)(87936001)(88136002)(229853001)(89996001)(77156002)(21056001)(50986999)(92566001)(106466001)(64706001)(50466002)(31966008)(217423001)(86362001)(107046002)(53416004)(4396001)(92726001)(101416001)(48376002)(50226001)(105586002)(46102003)(20776003)(99396003)(47776003)(120916001)(62966003)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Vincent.Wan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to enable the quirk for AMD sdhci requiring transfer
mode register need to be cleared for commands without data

Signed-off-by: Vincent Wan <vincent.wan@amd.com>
Signed-off-by: Wan Zongshun <mcuos.com@gmail.com>
---
 drivers/mmc/host/sdhci-pci.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index c25639b..5a77f18 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -645,6 +645,23 @@ static const struct sdhci_pci_fixes sdhci_rtsx = {
 	.probe_slot	= rtsx_probe_slot,
 };
 
+static int amd_probe(struct sdhci_pci_chip *chip)
+{
+	struct pci_dev	*smbus_dev;
+
+	smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
+			PCI_DEVICE_ID_AMD_HUDSON2_SMBUS, NULL);
+
+	if (smbus_dev && (smbus_dev->revision < 0x51))
+		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
+
+	return 0;
+}
+
+static const struct sdhci_pci_fixes sdhci_amd = {
+	.probe		= amd_probe,
+};
+
 static const struct pci_device_id pci_ids[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_RICOH,
@@ -1044,7 +1061,15 @@ static const struct pci_device_id pci_ids[] = {
 		.subdevice	= PCI_ANY_ID,
 		.driver_data	= (kernel_ulong_t)&sdhci_o2,
 	},
-
+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_ANY_ID,
+		.class		= PCI_CLASS_SYSTEM_SDHCI << 8,
+		.class_mask	= 0xFFFF00,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_amd,
+	},
 	{	/* Generic SD host controller */
 		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
 	},
-- 
1.8.1.2

