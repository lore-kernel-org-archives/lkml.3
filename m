Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3LEJun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 04:50:43 -0500
Received: from 7.mo1.mail-out.ovh.net ([87.98.158.110]:48931 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754781Ab3LEJuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 04:50:40 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH v3] usb: ohci-at91: fix irq and iomem resource retrieval
Date: Thu,  5 Dec 2013 10:50:13 +0100
Message-Id: <1386237013-22285-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 5614862836966258943
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using dt resources retrieval (interrupts and reg properties) there is
no predefined order for these resources in the platform dev resources
table.

Retrieve resources using the platform_get_resource function instead of
direct resource table entries to avoid resource type mismatch.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
Changes since v2:
 - split the patch series to isolate the urgent fix provided by this patch

Changes since v1:
 - none

 drivers/usb/host/ohci-at91.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 418444e..7aec6ca 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -136,23 +136,26 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	struct ohci_hcd *ohci;
 	int retval;
 	struct usb_hcd *hcd = NULL;
+	struct device *dev = &pdev->dev;
+	struct resource *mem_r, *irq_r;
 
-	if (pdev->num_resources != 2) {
-		pr_debug("hcd probe: invalid num_resources");
+	mem_r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_r) {
+		dev_dbg(dev, "hcd probe: missing memory resource\n");
 		return -ENODEV;
 	}
 
-	if ((pdev->resource[0].flags != IORESOURCE_MEM)
-			|| (pdev->resource[1].flags != IORESOURCE_IRQ)) {
-		pr_debug("hcd probe: invalid resource type\n");
+	irq_r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq_r) {
+		dev_dbg(dev, "hcd probe: missing irq resource\n");
 		return -ENODEV;
 	}
 
 	hcd = usb_create_hcd(driver, &pdev->dev, "at91");
 	if (!hcd)
 		return -ENOMEM;
-	hcd->rsrc_start = pdev->resource[0].start;
-	hcd->rsrc_len = resource_size(&pdev->resource[0]);
+	hcd->rsrc_start = mem_r->start;
+	hcd->rsrc_len = resource_size(mem_r);
 
 	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
 		pr_debug("request_mem_region failed\n");
@@ -199,7 +202,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	ohci->num_ports = board->ports;
 	at91_start_hc(pdev);
 
-	retval = usb_add_hcd(hcd, pdev->resource[1].start, IRQF_SHARED);
+	retval = usb_add_hcd(hcd, irq_r->start, IRQF_SHARED);
 	if (retval == 0)
 		return retval;
 
-- 
1.7.9.5

