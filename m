Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3KKNoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:44:00 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:54332 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3KKNnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:43:43 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: alexander.shishkin@linux.intel.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH 4/4] usb: chipidea: msm: Use USB PHY API to control PHY state
Date: Mon, 11 Nov 2013 15:35:37 +0200
Message-Id: <1384176937-1658-5-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

PHY drivers keep track of the current state of the hardware,
so don't change PHY settings under it.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/chipidea/ci_hdrc_msm.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
index e9624f3..338b209 100644
--- a/drivers/usb/chipidea/ci_hdrc_msm.c
+++ b/drivers/usb/chipidea/ci_hdrc_msm.c
@@ -20,13 +20,11 @@
 static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 {
 	struct device *dev = ci->gadget.dev.parent;
-	int val;
 
 	switch (event) {
 	case CI_HDRC_CONTROLLER_RESET_EVENT:
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_RESET_EVENT received\n");
-		writel(0, USB_AHBBURST);
-		writel(0, USB_AHBMODE);
+		usb_phy_init(ci->transceiver);
 		break;
 	case CI_HDRC_CONTROLLER_STOPPED_EVENT:
 		dev_dbg(dev, "CI_HDRC_CONTROLLER_STOPPED_EVENT received\n");
@@ -34,10 +32,7 @@ static void ci_hdrc_msm_notify_event(struct ci_hdrc *ci, unsigned event)
 		 * Put the transceiver in non-driving mode. Otherwise host
 		 * may not detect soft-disconnection.
 		 */
-		val = usb_phy_io_read(ci->transceiver, ULPI_FUNC_CTRL);
-		val &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
-		val |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
-		usb_phy_io_write(ci->transceiver, val, ULPI_FUNC_CTRL);
+		usb_phy_notify_disconnect(ci->transceiver, USB_SPEED_UNKNOWN);
 		break;
 	default:
 		dev_dbg(dev, "unknown ci_hdrc event\n");
-- 
1.7.9.5

