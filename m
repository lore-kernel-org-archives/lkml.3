Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaFLRk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:40:57 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:26904
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751076AbaFLRky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:40:54 -0400
X-WSS-ID: 0N72H3O-08-N2C-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <tj@kernel.org>, <b.zolnierkie@samsung.com>
CC: <hdegoede@redhat.com>, <lho@apm.com>, <tphan@apm.com>, <stripathi@apm.com>,
        <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 1/2] ahci: Check and set 64-bit DMA mask for platform AHCI driver
Date: Thu, 12 Jun 2014 12:40:23 -0500
Message-ID: <1402594824-4151-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1402594824-4151-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1402594824-4151-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(189002)(199002)(99396002)(88136002)(80022001)(81542001)(104166001)(87936001)(81342001)(86362001)(33646001)(77982001)(47776003)(44976005)(77156001)(83322001)(79102001)(101416001)(20776003)(92726001)(50226001)(102836001)(84676001)(50986999)(19580405001)(50466002)(74662001)(62966002)(97736001)(89996001)(64706001)(93916002)(48376002)(74502001)(76176999)(85852003)(87286001)(68736004)(76482001)(53416003)(4396001)(46102001)(19580395003)(86152002)(83072002)(36756003)(61793002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0201MB0831;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02408926C4
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

The current platform AHCI driver does not set the dma_mask correctly
for 64-bit DMA capable AHCI controller. This patch checks the AHCI
capability bit and set the dma_mask and coherent_dma_mask accordingly.

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/ata/libahci_platform.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 3a5b4ed..a958a2b 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -364,6 +364,19 @@ int ahci_platform_init_host(struct platform_device *pdev,
 			ap->ops = &ata_dummy_port_ops;
 	}
 
+	if (hpriv->cap & HOST_CAP_64) {
+		rc = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
+		if (rc) {
+			rc = dma_coerce_mask_and_coherent(dev,
+							  DMA_BIT_MASK(32));
+			if (rc) {
+				dev_err(dev, "Failed to enable 64-bit DMA.\n");
+				return rc;
+			}
+			dev_warn(dev, "Enable 32-bit DMA instead of 64-bit.\n");
+		}
+	}
+
 	rc = ahci_reset_controller(host);
 	if (rc)
 		return rc;
-- 
1.9.0

