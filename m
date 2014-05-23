Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaEWRfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:35:18 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:39034
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751050AbaEWRfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:35:16 -0400
X-WSS-ID: 0N61FIN-07-31E-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <tj@kernel.org>
CC: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 1/1] ata: Check and set 64-bit DMA mask for platform AHCI driver
Date: Fri, 23 May 2014 12:35:10 -0500
Message-ID: <1400866510-3130-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(62966002)(31966008)(74662001)(81342001)(99396002)(101416001)(20776003)(79102001)(86152002)(47776003)(48376002)(33646001)(102836001)(50466002)(80022001)(74502001)(50986999)(50226001)(4396001)(77982001)(76482001)(89996001)(36756003)(53416003)(64706001)(81542001)(97736001)(84676001)(86362001)(44976005)(19580405001)(83322001)(85852003)(83072002)(87936001)(87286001)(92566001)(92726001)(77156001)(19580395003)(21056001)(46102001)(88136002)(68736004)(93916002)(61793002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR02MB467;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0220D4B98D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

The current platform AHCI drier does not set the dma_mask correctly
for 64-bit DMA capable AHCI controller.  This patch checks the AHCI
capability bit and set the dma_mask and coherent_dma_mask accordingly.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
---
 drivers/ata/libahci_platform.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 7cb3a85..85049ef 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -368,6 +368,15 @@ int ahci_platform_init_host(struct platform_device *pdev,
 	ahci_init_controller(host);
 	ahci_print_info(host, "platform");
 
+	if (hpriv->cap & HOST_CAP_64) {
+		if (!dev->dma_mask)
+			dev->dma_mask = &dev->coherent_dma_mask;
+
+		rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
+		if (rc)
+			return rc;
+	}
+
 	return ata_host_activate(host, irq, ahci_interrupt, IRQF_SHARED,
 				 &ahci_platform_sht);
 }
-- 
1.9.0

