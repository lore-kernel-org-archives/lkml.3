Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab3LHPEE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 10:04:04 -0500
Received: from mo1.mail-out.ovh.net ([178.32.228.1]:51808 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3LHPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 10:04:00 -0500
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
Subject: [PATCH v4 1/3] usb: ohci-at91: replace request_mem_region + ioremap by devm_ioremap_resource
Date: Sun,  8 Dec 2013 16:02:58 +0100
Message-Id: <1386514980-6383-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386514980-6383-1-git-send-email-b.brezillon@overkiz.com>
References: <1386514980-6383-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 9964214176403126528
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the request_mem_region + ioremap calls by the
devm_ioremap_resource call which does the same things but with device
managed resources.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ohci-at91.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 8c356af..fe2ecc5 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -158,24 +158,18 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 
-	if (!request_mem_region(hcd->rsrc_start, hcd->rsrc_len, hcd_name)) {
-		pr_debug("request_mem_region failed\n");
-		retval = -EBUSY;
-		goto err1;
-	}
-
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
-	if (!hcd->regs) {
-		pr_debug("ioremap failed\n");
-		retval = -EIO;
-		goto err2;
+	hcd->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(hcd->regs)) {
+		dev_dbg(dev, "devm_ioremap_resource failed\n");
+		retval = PTR_ERR(hcd->regs);
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
@@ -219,13 +213,7 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
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
@@ -248,8 +236,6 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
 {
 	usb_remove_hcd(hcd);
 	at91_stop_hc(pdev);
-	iounmap(hcd->regs);
-	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
 	if (IS_ENABLED(CONFIG_COMMON_CLK))
-- 
1.7.9.5

