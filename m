Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3LCO0E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:26:04 -0500
Received: from 7.mo1.mail-out.ovh.net ([87.98.158.110]:45395 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753424Ab3LCOZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:25:57 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 09:25:57 EST
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Douglas Gilbert <dgilbert@interlog.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 3/3] usb: ohci-at91: use device managed clk retrieval
Date: Tue,  3 Dec 2013 15:07:49 +0100
Message-Id: <1386079669-3995-4-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079669-3995-1-git-send-email-b.brezillon@overkiz.com>
References: <1386079669-3995-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 16674859096968820994
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_get calls by devm_clk_get calls.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Tested-by: Robert Nelson <robertcnelson@gmail.com>
---
 drivers/usb/host/ohci-at91.c |   32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index c406f1e..3652962 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -164,30 +164,30 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 		goto err;
 	}
 
-	iclk = clk_get(&pdev->dev, "ohci_clk");
+	iclk = devm_clk_get(dev, "ohci_clk");
 	if (IS_ERR(iclk)) {
-		dev_err(&pdev->dev, "failed to get ohci_clk\n");
+		dev_err(dev, "failed to get ohci_clk\n");
 		retval = PTR_ERR(iclk);
 		goto err;
 	}
-	fclk = clk_get(&pdev->dev, "uhpck");
+	fclk = devm_clk_get(dev, "uhpck");
 	if (IS_ERR(fclk)) {
 		dev_err(&pdev->dev, "failed to get uhpck\n");
 		retval = PTR_ERR(fclk);
-		goto err4;
+		goto err;
 	}
-	hclk = clk_get(&pdev->dev, "hclk");
+	hclk = devm_clk_get(dev, "hclk");
 	if (IS_ERR(hclk)) {
 		dev_err(&pdev->dev, "failed to get hclk\n");
 		retval = PTR_ERR(hclk);
-		goto err5;
+		goto err;
 	}
 	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
-		uclk = clk_get(&pdev->dev, "usb_clk");
+		uclk = devm_clk_get(&pdev->dev, "usb_clk");
 		if (IS_ERR(uclk)) {
 			dev_err(&pdev->dev, "failed to get uclk\n");
 			retval = PTR_ERR(uclk);
-			goto err6;
+			goto err;
 		}
 	}
 
@@ -203,15 +203,6 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	/* Error handling */
 	at91_stop_hc(pdev);
 
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		clk_put(uclk);
- err6:
-	clk_put(hclk);
- err5:
-	clk_put(fclk);
- err4:
-	clk_put(iclk);
-
  err:
 	usb_put_hcd(hcd);
 	return retval;
@@ -236,13 +227,6 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
 	usb_remove_hcd(hcd);
 	at91_stop_hc(pdev);
 	usb_put_hcd(hcd);
-
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		clk_put(uclk);
-	clk_put(hclk);
-	clk_put(fclk);
-	clk_put(iclk);
-	fclk = iclk = hclk = NULL;
 }
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.9.5

