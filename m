Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaKEGJ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 01:09:28 -0500
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:23632
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750867AbaKEGJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 01:09:26 -0500
X-WSS-ID: 0NEJYFG-08-KBJ-02
X-M-MSG: 
From: Vincent Wan <vincent.wan@amd.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Arindam Nath <arindam.nath@amd.com>, Huang Rui <ray.huang@amd.com>,
        Wan Zongshun <mcuos.com@gmail.com>, Vincent Wan <vincent.wan@amd.com>
Subject: [PATCH v3 1/3] mmc:sdhci: Add a quirk for AMD SDHC transfer mode register need to be cleared for cmd without data
Date: Wed, 5 Nov 2014 14:09:00 +0800
Message-ID: <1415167740-5762-1-git-send-email-vincent.wan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(99396003)(21056001)(229853001)(106466001)(33646002)(86362001)(77096003)(53416004)(95666004)(217423001)(31966008)(120916001)(107046002)(50466002)(20776003)(93916002)(62966003)(47776003)(4396001)(64706001)(46102003)(50226001)(97736003)(36756003)(92726001)(48376002)(110136001)(88136002)(87286001)(89996001)(87936001)(84676001)(92566001)(101416001)(105586002)(19580405001)(19580395003)(50986999)(44976005)(104166001)(77156002)(68736004)(102836001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Vincent.Wan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDHC controller in AMD chipsets require SDHC transfer mode
register to be cleared for commands without data. The issue was
uncovered during testing eMMC cards on KB/ML based platforms

Signed-off-by: Vincent Wan <vincent.wan@amd.com>
Signed-off-by: Wan Zongshun <mcuos.com@gmail.com>
Signed-off-by: Arindam Nath <arindam.nath@amd.com>
Tested-by: Vikram B <vikram.b@amd.com>
Tested-by: Raghavendra Swamy <raghavendra.swamy@amd.com>
---
 drivers/mmc/host/sdhci.c  | 9 +++++++--
 include/linux/mmc/sdhci.h | 2 ++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index f895ab0..a743d52 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -915,10 +915,15 @@ static void sdhci_set_transfer_mode(struct sdhci_host *host,
 	struct mmc_data *data = cmd->data;
 
 	if (data == NULL) {
+		if (host->quirks2 &
+			SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD) {
+			sdhci_writew(host, 0x0, SDHCI_TRANSFER_MODE);
+		} else {
 		/* clear Auto CMD settings for no data CMDs */
-		mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
-		sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
+			mode = sdhci_readw(host, SDHCI_TRANSFER_MODE);
+			sdhci_writew(host, mode & ~(SDHCI_TRNS_AUTO_CMD12 |
 				SDHCI_TRNS_AUTO_CMD23), SDHCI_TRANSFER_MODE);
+		}
 		return;
 	}
 
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 931ac5e..ae7f357 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -102,6 +102,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK2_STOP_WITH_TC			(1<<8)
 /* Controller does not support 64-bit DMA */
 #define SDHCI_QUIRK2_BROKEN_64_BIT_DMA			(1<<9)
+/* need clear transfer mode register before send cmd */
+#define SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD	(1<<10)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.8.1.2

