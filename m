Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaJQJSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:18:36 -0400
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:61026
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752157AbaJQJO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:14:27 -0400
X-WSS-ID: 0NDKZNB-07-HNC-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vincent Wan <vincent.wan@amd.com>, Tony Li <tony.li@amd.com>,
        <linux-usb@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Huang Rui <ray.huang@amd.com>
Subject: [PATCH v2 05/16] usb: dwc3: add quirks support to be compatible for kinds of SoCs
Date: Fri, 17 Oct 2014 16:53:30 +0800
Message-ID: <1413536021-4886-6-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
References: <1413536021-4886-1-git-send-email-ray.huang@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6029001)(6009001)(428002)(189002)(199003)(97736003)(50226001)(76176999)(102836001)(53416004)(92726001)(86362001)(44976005)(62966002)(31966008)(20776003)(68736004)(101416001)(19580405001)(19580395003)(47776003)(575784001)(92566001)(105586002)(77096002)(93916002)(84676001)(64706001)(36756003)(229853001)(87286001)(87936001)(88136002)(85306004)(85852003)(4396001)(120916001)(104166001)(77156001)(89996001)(80022003)(46102003)(95666004)(76482002)(48376002)(107046002)(50466002)(99396003)(21056001)(50986999)(33646002)(106466001)(2171001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0367A50BB1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a quirks flag at dwc3 structure, and SoCs platform vendor is
able to define this flag in platform data at bus glue layer. Then do some
independent behaviors at dwc3 core level.

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/usb/dwc3/core.c          | 2 ++
 drivers/usb/dwc3/core.h          | 3 +++
 drivers/usb/dwc3/dwc3-pci.c      | 9 +++++++++
 drivers/usb/dwc3/platform_data.h | 2 ++
 4 files changed, 16 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index ddac372..50c0eae 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -710,6 +710,8 @@ static int dwc3_probe(struct platform_device *pdev)
 
 		dwc->needs_fifo_resize = pdata->tx_fifo_resize;
 		dwc->dr_mode = pdata->dr_mode;
+
+		dwc->quirks = pdata->quirks;
 	}
 
 	/* default to superspeed if no maximum_speed passed */
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index f6ee623..cfe0d57 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -636,6 +636,7 @@ struct dwc3_scratchpad_array {
  * @u1u2: only used on revisions <1.83a for workaround
  * @maximum_speed: maximum speed requested (mainly for testing purposes)
  * @revision: revision register contents
+ * @quirks: represents different SOCs hardware work-arounds and quirks
  * @dr_mode: requested mode of operation
  * @usb2_phy: pointer to USB2 PHY
  * @usb3_phy: pointer to USB3 PHY
@@ -740,6 +741,8 @@ struct dwc3 {
 #define DWC3_REVISION_270A	0x5533270a
 #define DWC3_REVISION_280A	0x5533280a
 
+	u32			quirks;
+
 	enum dwc3_ep0_next	ep0_next_event;
 	enum dwc3_ep0_state	ep0state;
 	enum dwc3_link_state	link_state;
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 3806547..18569a4 100644
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
@@ -103,6 +105,9 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 	struct dwc3_pci		*glue;
 	int			ret;
 	struct device		*dev = &pci->dev;
+	struct dwc3_platform_data dwc3_pdata;
+
+	memset(&dwc3_pdata, 0x00, sizeof(dwc3_pdata));
 
 	glue = devm_kzalloc(dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue)
@@ -149,6 +154,10 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 
 	pci_set_drvdata(pci, glue);
 
+	ret = platform_device_add_data(dwc3, &dwc3_pdata, sizeof(dwc3_pdata));
+	if (ret)
+		goto err3;
+
 	dma_set_coherent_mask(&dwc3->dev, dev->coherent_dma_mask);
 
 	dwc3->dev.dma_mask = dev->dma_mask;
diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
index 7db34f0..1d3d65f 100644
--- a/drivers/usb/dwc3/platform_data.h
+++ b/drivers/usb/dwc3/platform_data.h
@@ -24,4 +24,6 @@ struct dwc3_platform_data {
 	enum usb_device_speed maximum_speed;
 	enum usb_dr_mode dr_mode;
 	bool tx_fifo_resize;
+
+	u32     quirks;
 };
-- 
1.9.1

