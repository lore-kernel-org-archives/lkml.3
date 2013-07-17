Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3GQPsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 11:48:04 -0400
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:60817 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755735Ab3GQPsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 11:48:01 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH v2 26/42] USB: ohci-at91: add usb_clk for transition to common clk framework
Date: Wed, 17 Jul 2013 17:47:42 +0200
Message-Id: <1374076062-20293-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
References: <1374068069-13496-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 13584545328086612076
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrvdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91 PMC (Power Management Controller) provides an USB clock used by
USB Full Speed host (ohci) and USB Full Speed device (udc).
The usb drivers (ohci and udc) must configure this clock to 48Mhz.
This configuration was formely done in mach-at91/clock.c, but this
implementation will be removed when moving to common clk framework.

This patch add support for usb clock retrieval and configuration.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/host/ohci-at91.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 9677f68..ca1cdd6 100644
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
@@ -41,6 +41,8 @@ extern int usb_disabled(void);
 
 static void at91_start_clock(void)
 {
+	clk_set_rate(uclk, 48000000);
+	clk_prepare_enable(uclk);
 	clk_prepare_enable(hclk);
 	clk_prepare_enable(iclk);
 	clk_prepare_enable(fclk);
@@ -52,6 +54,7 @@ static void at91_stop_clock(void)
 	clk_disable_unprepare(fclk);
 	clk_disable_unprepare(iclk);
 	clk_disable_unprepare(hclk);
+	clk_disable_unprepare(uclk);
 	clocked = 0;
 }
 
@@ -162,6 +165,12 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 		retval = PTR_ERR(hclk);
 		goto err5;
 	}
+	uclk = clk_get(&pdev->dev, "usb_clk");
+	if (IS_ERR(uclk)) {
+		dev_err(&pdev->dev, "failed to get usb_clk\n");
+		retval = PTR_ERR(uclk);
+		goto err6;
+	}
 
 	at91_start_hc(pdev);
 	ohci_hcd_init(hcd_to_ohci(hcd));
@@ -173,6 +182,8 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	/* Error handling */
 	at91_stop_hc(pdev);
 
+	clk_put(uclk);
+ err6:
 	clk_put(hclk);
  err5:
 	clk_put(fclk);
@@ -212,6 +223,7 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
+	clk_put(uclk);
 	clk_put(hclk);
 	clk_put(fclk);
 	clk_put(iclk);
-- 
1.7.9.5

