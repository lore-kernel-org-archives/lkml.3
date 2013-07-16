Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab3GPPai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:30:38 -0400
Received: from 12.mo1.mail-out.ovh.net ([87.98.162.229]:49674 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932241Ab3GPPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:30:37 -0400
X-Greylist: delayed 1337 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2013 11:30:37 EDT
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v3 6/7] USB: ohci-at91: add usb_clk for transition to common clk framework
Date: Tue, 16 Jul 2013 17:22:15 +0200
Message-Id: <1373988136-24622-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373986995-23899-1-git-send-email-b.brezillon@overkiz.com>
References: <1373986995-23899-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 7282039124527708268
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91 PMC (Power Management Controller) provides an USB clock used by
USB Full Speed host (ohci) and USB Full Speed device (udc).
The usb drivers (ohci and udc) must configure this clock to 48Mhz.
This configuration was formely done in mach-at91/clock.c, but this
implementation will be removed when moving to common clk framework.

This patch add support for usb clock retrieval and configuration, and is
backward compatible with the current at91 clk implementation (if usb clk
is not found, it does not configure/enable the usb clk).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/host/ohci-at91.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 9677f68..426c7d2 100644
--- a/drivers/usb/host/ohci-at91.c
+++ b/drivers/usb/host/ohci-at91.c
@@ -31,8 +31,8 @@
 #define at91_for_each_port(index)	\
 		for ((index) = 0; (index) < AT91_MAX_USBH_PORTS; (index)++)
 
-/* interface and function clocks; sometimes also an AHB clock */
-static struct clk *iclk, *fclk, *hclk;
+/* interface, function and usb clocks; sometimes also an AHB clock */
+static struct clk *iclk, *fclk, *uclk, *hclk;
 static int clocked;
 
 extern int usb_disabled(void);
@@ -41,6 +41,10 @@ extern int usb_disabled(void);
 
 static void at91_start_clock(void)
 {
+	if (uclk) {
+		clk_set_rate(uclk, 48000000);
+		clk_prepare_enable(uclk);
+	}
 	clk_prepare_enable(hclk);
 	clk_prepare_enable(iclk);
 	clk_prepare_enable(fclk);
@@ -52,6 +56,8 @@ static void at91_stop_clock(void)
 	clk_disable_unprepare(fclk);
 	clk_disable_unprepare(iclk);
 	clk_disable_unprepare(hclk);
+	if (uclk)
+		clk_disable_unprepare(uclk);
 	clocked = 0;
 }
 
@@ -144,6 +150,11 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 		goto err2;
 	}
 
+	uclk = clk_get(&pdev->dev, "usb_clk");
+	if (IS_ERR(uclk)) {
+		uclk = NULL;
+		dev_warn(&pdev->dev, "failed to get usb_clk\n");
+	}
 	iclk = clk_get(&pdev->dev, "ohci_clk");
 	if (IS_ERR(iclk)) {
 		dev_err(&pdev->dev, "failed to get ohci_clk\n");
@@ -212,10 +223,11 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
+	clk_put(uclk);
 	clk_put(hclk);
 	clk_put(fclk);
 	clk_put(iclk);
-	fclk = iclk = hclk = NULL;
+	fclk = iclk = hclk = uclk = NULL;
 
 	dev_set_drvdata(&pdev->dev, NULL);
 }
-- 
1.7.9.5

