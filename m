Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaKDIlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:41:14 -0500
Received: from mail-bn1bon0141.outbound.protection.outlook.com ([157.56.111.141]:31748
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751129AbaKDIlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:41:10 -0500
X-Greylist: delayed 919 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2014 03:41:09 EST
X-WSS-ID: 0NEIA2W-08-W7T-02
X-M-MSG: 
From: Vincent Wan <vincent.wan@amd.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vincent Wan <vincent.wan@amd.com>, Arindam Nath <arindam.nath@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH v2] mmc: Add a quirk for AMD SDHC transfer mode register need to be cleared for cmd without data
Date: Tue, 4 Nov 2014 15:32:37 +0800
Message-ID: <1415086357-4619-1-git-send-email-vincent.wan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(106466001)(105586002)(92726001)(102836001)(21056001)(99396003)(120916001)(107046002)(104166001)(47776003)(20776003)(62966003)(229853001)(64706001)(46102003)(95666004)(101416001)(92566001)(110136001)(33646002)(50986999)(87286001)(87936001)(19580395003)(93916002)(19580405001)(36756003)(48376002)(53416004)(44976005)(86362001)(4396001)(97736003)(68736004)(88136002)(31966008)(50226001)(89996001)(50466002)(84676001)(77156002)(77096003)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Vincent.Wan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDHC controller in AMD chipsets require SDHC transfer mode
register to be cleared for commands without data. The issue was
uncovered during testing eMMC cards on KB/ML based platforms.

Signed-off-by: Vincent Wan <vincent.wan@amd.com>
Signed-off-by: Arindam Nath <arindam.nath@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Tested-by: Vikram B <vikram.b@amd.com>
Tested-by: Raghavendra Swamy <raghavendra.swamy@amd.com>
---
 drivers/mmc/host/sdhci-pci.c | 27 +++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     | 11 ++++++++---
 include/linux/mmc/sdhci.h    |  2 ++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 6119297..8f5c998 100644
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
@@ -1045,6 +1062,16 @@ static const struct pci_device_id pci_ids[] = {
 		.driver_data	= (kernel_ulong_t)&sdhci_o2,
 	},

+	{
+		.vendor		= PCI_VENDOR_ID_AMD,
+		.device		= PCI_ANY_ID,
+		.class		= PCI_CLASS_SYSTEM_SDHCI << 8,
+		.class_mask	= 0xFFFF00,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.driver_data	= (kernel_ulong_t)&sdhci_amd,
+	},
+
 	{	/* Generic SD host controller */
 		PCI_DEVICE_CLASS((PCI_CLASS_SYSTEM_SDHCI << 8), 0xFFFF00)
 	},
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index ada1a3e..8085f26 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -889,10 +889,15 @@ static void sdhci_set_transfer_mode(struct sdhci_host *host,
 	struct mmc_data *data = cmd->data;

 	if (data == NULL) {
-		/* clear Auto CMD settings for no data CMDs */
-		mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
-		sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
+		if (host->quirks2 &
+			SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD) {
+			sdhci_writew(host, 0x0, SDHCI_TRANSFER_MODE);
+		} else {
+			/* clear Auto CMD settings for no data CMDs */
+			mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
+			sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
 				SDHCI_TRNS_AUTO_CMD23), SDHCI_TRANSFER_MODE);
+		}
 		return;
 	}

diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index dba793e..0a287aa 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -100,6 +100,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_BROKEN_DDR50			(1<<7)
 /* Stop command (CMD12) can set Transfer Complete when not using MMC_RSP_BUSY */
 #define SDHCI_QUIRK2_STOP_WITH_TC			(1<<8)
+/* need clear transfer mode register before send cmd */
+#define SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD	(1<<9)

 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
--
1.8.1.2

