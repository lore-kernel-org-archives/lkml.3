Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab3JRTfs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:35:48 -0400
Received: from 10.mo4.mail-out.ovh.net ([188.165.33.109]:57448 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757224Ab3JRTfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:35:47 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH] USB: ehci-atmel: add usb_clk for transition to CCF
Date: Fri, 18 Oct 2013 21:26:51 +0200
Message-Id: <1382124411-29023-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 10046123394882828396
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrfeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrfeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AT91 PMC (Power Management Controller) provides a USB clock used by
the different USB controllers (ehci, ohci and udc).
The atmel-ehci driver must configure the usb clock rate to 48Mhz in order
to get a fully functionnal USB host controller.
This configuration was formely done in mach-at91/clock.c, but will be
bypassed when moving to common clk framework.

This patch adds support for usb clock retrieval and configuration only if
CCF is enabled (CONFIG_COMMON_CLK).

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/usb/host/ehci-atmel.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci-atmel.c b/drivers/usb/host/ehci-atmel.c
index 3b645ff..f417526 100644
--- a/drivers/usb/host/ehci-atmel.c
+++ b/drivers/usb/host/ehci-atmel.c
@@ -30,13 +30,17 @@ static const char hcd_name[] = "ehci-atmel";
 static struct hc_driver __read_mostly ehci_atmel_hc_driver;
 
 /* interface and function clocks */
-static struct clk *iclk, *fclk;
+static struct clk *iclk, *fclk, *uclk;
 static int clocked;
 
 /*-------------------------------------------------------------------------*/
 
 static void atmel_start_clock(void)
 {
+	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
+		clk_set_rate(uclk, 48000000);
+		clk_prepare_enable(uclk);
+	}
 	clk_prepare_enable(iclk);
 	clk_prepare_enable(fclk);
 	clocked = 1;
@@ -46,6 +50,8 @@ static void atmel_stop_clock(void)
 {
 	clk_disable_unprepare(fclk);
 	clk_disable_unprepare(iclk);
+	if (IS_ENABLED(CONFIG_COMMON_CLK))
+		clk_disable_unprepare(uclk);
 	clocked = 0;
 }
 
@@ -130,6 +136,14 @@ static int ehci_atmel_drv_probe(struct platform_device *pdev)
 		retval = -ENOENT;
 		goto fail_request_resource;
 	}
+	if (IS_ENABLED(CONFIG_COMMON_CLK)) {
+		uclk = devm_clk_get(&pdev->dev, "usb_clk");
+		if (IS_ERR(uclk)) {
+			dev_err(&pdev->dev, "failed to get uclk\n");
+			retval = PTR_ERR(uclk);
+			goto fail_request_resource;
+		}
+	}
 
 	ehci = hcd_to_ehci(hcd);
 	/* registers start at offset 0x0 */
-- 
1.7.9.5

