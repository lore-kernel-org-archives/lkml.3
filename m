Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaJ3KKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:10:30 -0400
Received: from mail-by2on0124.outbound.protection.outlook.com ([207.46.100.124]:16956
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758445AbaJ3KKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:10:24 -0400
X-WSS-ID: 0NE95L3-07-XSR-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, <linux-usb@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v4 03/20] usb: dwc3: initialize platform data at pci glue layer
Date: Thu, 30 Oct 2014 18:08:28 +0800
Message-ID: <1414663725-2195-4-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
References: <1414663725-2195-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(62966002)(31966008)(50466002)(53416004)(99396003)(36756003)(120916001)(48376002)(2171001)(87936001)(87286001)(76482002)(88136002)(89996001)(85852003)(77156001)(85306004)(93916002)(86362001)(20776003)(64706001)(92566001)(92726001)(101416001)(102836001)(47776003)(104166001)(76176999)(50986999)(84676001)(46102003)(80022003)(68736004)(44976005)(19580405001)(19580395003)(21056001)(106466001)(4396001)(105586002)(107046002)(77096002)(229853001)(33646002)(97736003)(50226001)(95666004);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB206;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB206;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 038002787A
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initializes platform data at pci glue layer, and SoCs x86-based
platform vendor is able to define their flags in platform data at bus glue
layer. Then do some independent behaviors at dwc3 core level.

Signed-off-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
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

