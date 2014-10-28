Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaJ1L4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:56:12 -0400
Received: from mail-bn1on0118.outbound.protection.outlook.com ([157.56.110.118]:14064
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755107AbaJ1L4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:56:05 -0400
X-WSS-ID: 0NE5L58-08-OB4-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, "Vincent Wan" <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH v3 03/19] usb: dwc3: initialize platform data at pci glue layer
Date: Tue, 28 Oct 2014 19:54:24 +0800
Message-ID: <1414497280-3126-4-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(97736003)(77156001)(36756003)(229853001)(87286001)(88136002)(2171001)(89996001)(46102003)(87936001)(80022003)(76176999)(21056001)(104166001)(85852003)(76482002)(120916001)(95666004)(106466001)(62966002)(53416004)(50986999)(77096002)(107046002)(105586002)(68736004)(44976005)(19580405001)(50226001)(19580395003)(4396001)(93916002)(86362001)(102836001)(33646002)(20776003)(101416001)(50466002)(92566001)(47776003)(64706001)(92726001)(48376002)(84676001)(85306004)(31966008);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initializes platform data at pci glue layer, and SoCs x86-based
platform vendor is able to define their flags in platform data at bus glue
layer. Then do some independent behaviors at dwc3 core level.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/dwc3-pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index a36cf66..ada975f 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -25,6 +25,8 @@
 #include <linux/usb/otg.h>
 #include <linux/usb/usb_phy_generic.h>
 
+#include "platform_data.h"
+
 /* FIXME define these in <linux/pci_ids.h> */
 #define PCI_VENDOR_ID_SYNOPSYS		0x16c3
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
@@ -102,6 +104,9 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 	struct dwc3_pci		*glue;
 	int			ret;
 	struct device		*dev = &pci->dev;
+	struct dwc3_platform_data dwc3_pdata;
+
+	memset(&dwc3_pdata, 0x00, sizeof(dwc3_pdata));
 
 	glue = devm_kzalloc(dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue)
@@ -148,6 +153,10 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 
 	pci_set_drvdata(pci, glue);
 
+	ret = platform_device_add_data(dwc3, &dwc3_pdata, sizeof(dwc3_pdata));
+	if (ret)
+		goto err3;
+
 	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
 
 	dwc3->dev.dma_mask = dev->dma_mask;
-- 
1.9.1

