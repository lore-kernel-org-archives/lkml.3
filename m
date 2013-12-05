Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3LEKE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:04:26 -0500
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:56867 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751025Ab3LEKEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:04:23 -0500
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 05:04:23 EST
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
Subject: [PATCH v3 1/3] usb: ohci-at91: replace request_mem_region + ioremap by devm_request_and_ioremap
Date: Thu,  5 Dec 2013 10:54:40 +0100
Message-Id: <1386237282-22385-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386237282-22385-1-git-send-email-b.brezillon@overkiz.com>
References: <1386237282-22385-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 5695927629290830080
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

Replace the request_mem_region + ioremap calls by the
devm_request_and_ioremap call which does the same things but with device
managed resources.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ohci-at91.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 7aec6ca..8528895 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -157,24 +157,18 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	hcd->rsrc_start = mem_r->start;
 	hcd->rsrc_len = resource_size(mem_r);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_debug("request_mem_region failed\n");
-		retval = -EBUSY;
-		goto err1;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_request_and_ioremap(dev, mem_r);
 	if (!hcd->regs) {
-		pr_debug("ioremap failed\n");
+		dev_dbg(dev, "devm_request_and_ioremap failed\n");
 		retval = -EIO;
-		goto err2;
+		goto err;
 	}
 
 	iclk = clk_get(&pdev->dev, "ohci_clk");
 	if (IS_ERR(iclk)) {
 		dev_err(&pdev->dev, "failed to get ohci_clk\n");
 		retval = PTR_ERR(iclk);
-		goto err3;
+		goto err;
 	}
 	fclk = clk_get(&pdev->dev, "uhpck");
 	if (IS_ERR(fclk)) {
@@ -218,13 +212,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
  err4:
 	clk_put(iclk);
 
- err3:
-	iounmap(hcd->regs);
-
- err2:
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
-
- err1:
+ err:
 	usb_put_hcd(hcd);
 	return retval;
 }
@@ -247,8 +235,6 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
 {
 	usb_remove_hcd(hcd);
 	at91_stop_hc(pdev);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
 	if (IS_ENABLED(CONFIG_COMMON_CLK))
-- 
1.7.9.5

