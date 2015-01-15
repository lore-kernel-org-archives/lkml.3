Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbbAOTVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:21:51 -0500
Received: from smtprelay.synopsys.com ([198.182.47.9]:47762 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbbAOTVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:21:49 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Felipe Balbi <balbi@ti.com>, Kever Yang <kever.yang@rock-chips.com>
CC: "Dinh Nguyen (dinguyen@opensource.altera.com)" 
	<dinguyen@opensource.altera.com>,
        Doug Anderson <dianders@chromium.org>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Revert "usb: dwc2: add bus suspend/resume for dwc2"
Thread-Topic: [PATCH] Revert "usb: dwc2: add bus suspend/resume for dwc2"
Thread-Index: AdAw+H1ni/7Lz4jATrSNTqNBjHd7JQ==
Date: Thu, 15 Jan 2015 19:21:46 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030484507BC5@US01WEMBX2.internal.synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.19]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 0cf884e819e05437287a668b9bfcc198bab6329c.
Even after applying the follow-on patch at
https://patchwork.kernel.org/patch/5325111
there are still problems with device connect on the Altera SOCFPGA
platform at least. One possible fix would be to add a whitelist
to enable suspend/resume on platforms where it does work correctly.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
---
Based on Felipe's testing/next branch.

 drivers/usb/dwc2/hcd.c |   88 ++++++------------------------------------------
 1 files changed, 11 insertions(+), 77 deletions(-)

diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index a0cd9db..755e16b 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -1473,30 +1473,6 @@ static void dwc2_port_suspend(struct dwc2_hsotg *hsotg, u16 windex)
 	}
 }
 
-static void dwc2_port_resume(struct dwc2_hsotg *hsotg)
-{
-	u32 hprt0;
-
-	/* After clear the Stop PHY clock bit, we should wait for a moment
-	 * for PLL work stable with clock output.
-	 */
-	writel(0, hsotg->regs + PCGCTL);
-	usleep_range(2000, 4000);
-
-	hprt0 = dwc2_read_hprt0(hsotg);
-	hprt0 |= HPRT0_RES;
-	writel(hprt0, hsotg->regs + HPRT0);
-	hprt0 &= ~HPRT0_SUSP;
-	/* according to USB2.0 Spec 7.1.7.7, the host must send the resume
-	 * signal for at least 20ms
-	 */
-	usleep_range(20000, 25000);
-
-	hprt0 &= ~HPRT0_RES;
-	writel(hprt0, hsotg->regs + HPRT0);
-	hsotg->lx_state = DWC2_L0;
-}
-
 /* Handles hub class-specific requests */
 static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 				u16 wvalue, u16 windex, char *buf, u16 wlength)
@@ -1542,7 +1518,17 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
 		case USB_PORT_FEAT_SUSPEND:
 			dev_dbg(hsotg->dev,
 				"ClearPortFeature USB_PORT_FEAT_SUSPEND\n");
-			dwc2_port_resume(hsotg);
+			writel(0, hsotg->regs + PCGCTL);
+			usleep_range(20000, 40000);
+
+			hprt0 = dwc2_read_hprt0(hsotg);
+			hprt0 |= HPRT0_RES;
+			writel(hprt0, hsotg->regs + HPRT0);
+			hprt0 &= ~HPRT0_SUSP;
+			usleep_range(100000, 150000);
+
+			hprt0 &= ~HPRT0_RES;
+			writel(hprt0, hsotg->regs + HPRT0);
 			break;
 
 		case USB_PORT_FEAT_POWER:
@@ -2315,55 +2301,6 @@ static void _dwc2_hcd_stop(struct usb_hcd *hcd)
 	usleep_range(1000, 3000);
 }
 
-static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
-{
-	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
-	u32 hprt0;
-
-	if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
-		(hsotg->op_state == OTG_STATE_A_HOST)))
-		return 0;
-
-	/* TODO: We get into suspend from 'on' state, maybe we need to do
-	 * something if we get here from DWC2_L1(LPM sleep) state one day.
-	 */
-	if (hsotg->lx_state != DWC2_L0)
-		return 0;
-
-	hprt0 = dwc2_read_hprt0(hsotg);
-	if (hprt0 & HPRT0_CONNSTS) {
-		dwc2_port_suspend(hsotg, 1);
-	} else {
-		u32 pcgctl = readl(hsotg->regs + PCGCTL);
-
-		pcgctl |= PCGCTL_STOPPCLK;
-		writel(pcgctl, hsotg->regs + PCGCTL);
-	}
-
-	return 0;
-}
-
-static int _dwc2_hcd_resume(struct usb_hcd *hcd)
-{
-	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
-	u32 hprt0;
-
-	if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
-		(hsotg->op_state == OTG_STATE_A_HOST)))
-		return 0;
-
-	if (hsotg->lx_state != DWC2_L2)
-		return 0;
-
-	hprt0 = dwc2_read_hprt0(hsotg);
-	if ((hprt0 & HPRT0_CONNSTS) && (hprt0 & HPRT0_SUSP))
-		dwc2_port_resume(hsotg);
-	else
-		writel(0, hsotg->regs + PCGCTL);
-
-	return 0;
-}
-
 /* Returns the current frame number */
 static int _dwc2_hcd_get_frame_number(struct usb_hcd *hcd)
 {
@@ -2734,9 +2671,6 @@ static struct hc_driver dwc2_hc_driver = {
 	.hub_status_data = _dwc2_hcd_hub_status_data,
 	.hub_control = _dwc2_hcd_hub_control,
 	.clear_tt_buffer_complete = _dwc2_hcd_clear_tt_buffer_complete,
-
-	.bus_suspend = _dwc2_hcd_suspend,
-	.bus_resume = _dwc2_hcd_resume,
 };
 
 /*
-- 
1.7.6.5

