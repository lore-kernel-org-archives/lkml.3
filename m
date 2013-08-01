Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3HARJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:09:26 -0400
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:36469 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752685Ab3HARJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:09:25 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: [PATCH v2] USB: ohci-at91: add usb_clk for transition to common clk framework
Date: Thu,  1 Aug 2013 19:09:13 +0200
Message-Id: <1375376953-22823-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 10898711098603763814
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrieduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrieduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91 PMC (Power Management Controller) provides an USB clock used by
USB Full Speed host (ohci) and USB Full Speed device (udc).
The usb drivers (ohci and udc) must configure this clock to 48Mhz.
This configuration was formely done in mach-at91/clock.c, but this
implementation will be removed when moving to common clk framework.

This patch adds support for usb clock retrieval and configuration, and is
backward compatible with the current at91 clk implementation (if usb clk
is not found, it does not configure/enable it).

Changes since v1:
 - use IS_ENABLED(CONFIG_COMMON_CLK) to isolate new at91 clk support

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/host/ohci-at91.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
index 9677f68..db60048 100644
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
+	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
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
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
+		clk_disable_unprepare(uclk);
 	clocked = 0;
 }
 
@@ -162,6 +168,14 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 		retval = PTR_ERR(hclk);
 		goto err5;
 	}
+	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
+		uclk = clk_get(&pdev->dev, "usb_clk");
+		if (IS_ERR(uclk)) {
+			dev_err(&pdev->dev, "failed to get uclk\n");
+			retval = PTR_ERR(uclk);
+			goto err6;
+		}
+	}
 
 	at91_start_hc(pdev);
 	ohci_hcd_init(hcd_to_ohci(hcd));
@@ -173,6 +187,9 @@ static int usb_hcd_at91_probe(const struct hc_driver *driver,
 	/* Error handling */
 	at91_stop_hc(pdev);
 
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
+		clk_put(uclk);
+ err6:
 	clk_put(hclk);
  err5:
 	clk_put(fclk);
@@ -212,6 +229,8 @@ static void usb_hcd_at91_remove(struct usb_hcd *hcd,
 	release_mem_region(hcd->rsrc_start, hcd->rsrc_len);
 	usb_put_hcd(hcd);
 
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
+		clk_put(uclk);
 	clk_put(hclk);
 	clk_put(fclk);
 	clk_put(iclk);
-- 
1.7.9.5

